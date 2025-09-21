[Setup]
AppName=Ralpha
AppVersion=170111
DefaultDirName={pf}\Ralpha
DefaultGroupName=Ralpha
OutputBaseFilename=Setup
Compression=none
SolidCompression=no
LicenseFile=Ralpha\readme.txt
AppCopyright=readme.txt
UninstallDisplayIcon={app}\Ralpha\Ralpha.exe
DisableWelcomePage=no
PrivilegesRequired=lowest

[Languages]
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"

[Components]
Name: "main"; Description: "ゲーム本体（必須）"; Flags: fixed
Name: "bonus"; Description: "追加パック（HDテクスチャなど）"; Types: full compact custom

[Tasks]
Name: "desktopicon"; Description: "デスクトップにショートカットを作成"; GroupDescription: "追加オプション:"; Flags: checkedonce

[Files]
Source: "Ralpha\*"; DestDir: "{app}\Ralpha"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Ralpha"; Filename: "{app}\Ralpha\Ralpha.exe"
Name: "{userdesktop}\Ralpha"; Filename: "{app}\Ralpha\Ralpha.exe"; Tasks: desktopicon
Name: "{group}\アンインストール Ralpha"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\Ralpha\Ralpha.exe"; Description: "Ralpha を起動"; Flags: nowait postinstall skipifsilent
