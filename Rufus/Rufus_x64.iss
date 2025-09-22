[Setup]
AppName=Rufus
AppVersion=0
DefaultDirName={pf}\Rufus
DefaultGroupName=Rufus
OutputBaseFilename=Setup
Compression=none
SolidCompression=no
UninstallDisplayIcon={app}\Rufus\Rufus.exe
DisableWelcomePage=no
PrivilegesRequired=admin

[Languages]
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"

[Components]
Name: "main"; Description: "ゲーム本体（必須）"; Flags: fixed
Name: "bonus"; Description: "追加パック（HDテクスチャなど）"; Types: full compact custom

[Tasks]
Name: "desktopicon"; Description: "デスクトップにショートカットを作成"; GroupDescription: "追加オプション:"; Flags: checkedonce

[Files]
Source: "Rufus\*"; DestDir: "{app}\"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Rufus"; Filename: "{app}\Rufus.exe"
Name: "{commondesktop}\Rufus"; Filename: "{app}\Rufus.exe"; Tasks: desktopicon
Name: "{group}\アンインストール Rufus"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\Rufus.exe"; Description: "Rufus を起動"; Flags: nowait postinstall runascurrentuser
