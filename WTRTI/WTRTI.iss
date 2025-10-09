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
DefaultDirName={pf}\WTRTI\WTRTI
DefaultGroupName=WTRTI
OutputBaseFilename=Setup
Compression=none
SolidCompression=no
LicenseFile=license.txt
UninstallDisplayIcon={app}\WTRTI\WTRTI.exe
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
Source: "crescent\*"; DestDir: "{app}\crescent"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\CRESCENT MOON がぁる"; Filename: "{app}\crescent\adv.exe"
Name: "{userdesktop}\CRESCENT MOON がぁる"; Filename: "{app}\crescent\adv.exe"; Tasks: desktopicon
Name: "{group}\アンインストール CRESCENT MOON がぁる"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\crescent\adv.exe"; Description: "CRESCENT MOON がぁるを起動"; Flags: nowait postinstall skipifsilent
