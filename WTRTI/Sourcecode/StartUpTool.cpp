#include <windows.h>
#include <tlhelp32.h>
#include <string>
#include <thread>
#include <fstream>
#include <filesystem>

namespace fs = std::filesystem;

// 設定
struct Config {
    std::wstring watchExe;
    std::wstring launchExe;
    int intervalSeconds = 1;
};

// UTF-8 → UTF-16
std::wstring utf8_to_wstring(const std::string& str) {
    if (str.empty()) return L"";
    int size_needed = MultiByteToWideChar(CP_UTF8, 0, str.c_str(), (int)str.size(), NULL, 0);
    std::wstring wstr(size_needed, 0);
    MultiByteToWideChar(CP_UTF8, 0, str.c_str(), (int)str.size(), &wstr[0], size_needed);
    return wstr;
}

// 設定読み込み
Config LoadConfig(const std::wstring& filename) {
    Config cfg;
    std::ifstream file(filename);
    if (!file) {
        MessageBoxW(NULL, L"StartUpTool.ini が見つかりません。", L"StartUpTool", MB_ICONERROR);
        exit(1);
    }

    std::string line;
    while (std::getline(file, line)) {
        std::wstring wline = utf8_to_wstring(line);
        if (wline.rfind(L"watch=", 0) == 0)
            cfg.watchExe = wline.substr(6);
        else if (wline.rfind(L"launch=", 0) == 0)
            cfg.launchExe = wline.substr(7);
        else if (wline.rfind(L"interval=", 0) == 0)
            cfg.intervalSeconds = std::stoi(wline.substr(9));
    }
    return cfg;
}

// プロセスチェック
bool IsProcessRunning(const std::wstring& processName) {
    HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (snapshot == INVALID_HANDLE_VALUE) return false;

    PROCESSENTRY32 pe{ sizeof(pe) };
    bool found = false;
    if (Process32First(snapshot, &pe)) {
        do {
            if (_wcsicmp(pe.szExeFile, processName.c_str()) == 0) {
                found = true;
                break;
            }
        }
        while (Process32Next(snapshot, &pe));
    }
    CloseHandle(snapshot);
    return found;
}

// 終了
void KillProcessByName(const std::wstring& processName) {
    HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (snapshot == INVALID_HANDLE_VALUE) return;

    PROCESSENTRY32 pe{ sizeof(pe) };
    if (Process32First(snapshot, &pe)) {
        do {
            if (_wcsicmp(pe.szExeFile, processName.c_str()) == 0) {
                HANDLE hProc = OpenProcess(PROCESS_TERMINATE, FALSE, pe.th32ProcessID);
                if (hProc) {
                    TerminateProcess(hProc, 0);
                    CloseHandle(hProc);
                }
            }
        }
        while (Process32Next(snapshot, &pe));
    }
    CloseHandle(snapshot);
}

// GUI更新スレッドに渡す構造体
struct SharedState {
    HWND hwnd;
    Config cfg;
    bool launched = false;
};

// GUI更新
void WatchThread(SharedState* state) {
    std::wstring launchName = fs::path(state->cfg.launchExe).filename().wstring();

    while (true) {
        bool watchRunning = IsProcessRunning(state->cfg.watchExe);

        if (watchRunning && !state->launched) {
            // 起動
            STARTUPINFOW si{ sizeof(si) };
            PROCESS_INFORMATION pi;
            if (CreateProcessW(state->cfg.launchExe.c_str(), NULL, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
                CloseHandle(pi.hProcess);
                CloseHandle(pi.hThread);
                state->launched = true;
            }
        }

        if (!watchRunning && state->launched) {
            KillProcessByName(launchName);
            state->launched = false;
        }

        // 状態をウィンドウに表示更新
        std::wstring status = L"監視対象: " + state->cfg.watchExe + L"\n状態: " +
            (watchRunning ? (state->launched ? L"起動中..." : L"監視中...") : L"停止中...");

        SetWindowTextW(state->hwnd, status.c_str());

        std::this_thread::sleep_for(std::chrono::seconds(state->cfg.intervalSeconds));
    }
}

// ウィンドウプロシージャ
LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    if (msg == WM_DESTROY) {
        PostQuitMessage(0);
        return 0;
    }
    return DefWindowProc(hwnd, msg, wParam, lParam);
}

// メイン
int WINAPI wWinMain(HINSTANCE hInst, HINSTANCE, LPWSTR, int) {
    // 設定読み込み
    wchar_t exePath[MAX_PATH];
    GetModuleFileNameW(NULL, exePath, MAX_PATH);
    fs::path baseDir = fs::path(exePath).parent_path();
    fs::path iniPath = baseDir / L"StartUpTool.ini";
    Config cfg = LoadConfig(iniPath.wstring());

    // ウィンドウクラス登録
    WNDCLASSW wc{};
    wc.lpfnWndProc = WndProc;
    wc.hInstance = hInst;
    wc.lpszClassName = L"StartUpToolClass";
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
    RegisterClassW(&wc);

    // ウィンドウ作成
    HWND hwnd = CreateWindowW(L"StartUpToolClass", L"StartUpTool", WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU,
        CW_USEDEFAULT, CW_USEDEFAULT, 300, 120, NULL, NULL, hInst, NULL);

    ShowWindow(hwnd, SW_SHOW);
    UpdateWindow(hwnd);

    // スレッド起動
    SharedState state{ hwnd, cfg, false };
    std::thread watcher(WatchThread, &state);
    watcher.detach();

    // メッセージループ
    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    return 0;
}
