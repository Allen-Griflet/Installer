;========================================================
;  Program Name : Setup.exe
;  File         : WTRTI.iss
;  Author       : Allen.Griflet(https://github.com/Allen-Griflet)
;  Created      : 2025-10-09
;  Last Update  : 2025-10-09
;  Description  : Installer script for WTRTI
;  License      : license.txt
;========================================================

[Setup]
AppName=WTRTI
AppVersion=2.3.4
DefaultDirName={pf}\WTRTI
DefaultGroupName=WTRTI
OutputBaseFilename=Setup
Compression=none
SolidCompression=no
LicenseFile=license.txt
UninstallDisplayIcon={app}\WTRTI\WTRTI.exe
DisableWelcomePage=no
PrivilegesRequired=admin

[Languages]
Name: "English"; MessagesFile: "compiler:Languages\English.isl"

[Components]
Name: "main"; Description: "ゲーム本体（必須）"; Flags: fixed
Name: "bonus"; Description: "追加パック（HDテクスチャなど）"; Types: full compact custom

[Tasks]
Name: "desktopicon"; Description: "デスクトップにショートカットを作成"; GroupDescription: "追加オプション:"; Flags: checkedonce

[Files]
Source: "WTRTI.v2.3.4_windows\*"; DestDir: "{app}\WTRTI"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\WTRTI"; Filename: "{app}\WTRTI\WTRTI.exe"
Name: "{userdesktop}\WTRTI"; Filename: "{app}\WTRTI\WTRTI.exe"; Tasks: desktopicon
Name: "{group}\アンインストール WTRTI"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\WTRTI\WTRTI.exe"; Description: "WTRTIを起動"; Flags: nowait postinstall skipifsilent
