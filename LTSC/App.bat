@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (GOTO askAdmin)
GOTO gotAdmin
:askAdmin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"
:: batch is being ran as admin
:skipAdmin



:: Note - App requires Administrator permissions to run perfectly.
@echo off
%windir%\system32\reg.exe query "HKU\S-1-5-19" >nul 2>&1 || (
@ECHO ____________________________________________________________________________
@ECHO.
@echo                     - Please execute as Administrator. -
@echo.
@ECHO ____________________________________________________________________________
pause >nul
exit
)
pushd %~dp0
:: Note - Turning UAC promtps back to on to default for the sake of security.
REG Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /V ConsentPromptBehaviorAdmin /T REG_DWORD /D 5 /F >nul 2>&1
REG Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /V PromptOnSecureDesktop /T REG_DWORD /D 1 /F >nul 2>&1
:: Note - Welcome Page
:Welcome
mode con: cols=76 lines=20
Title APP
@ECHO OFF
CLS
@ECHO.   
@ECHO.                                 Hi, %USERNAME%
@ECHO                          Welcome to Windows 11 LTSC
@ECHO. 
@ECHO ____________________________________________________________________________
@ECHO.
ECHO    [A] Install Apps     [B] More Debloat      [C] Drivers    [D] Settings
ECHO.
@ECHO ____________________________________________________________________________
ECHO.
ECHO    [X] Exit   [U] Update APP                                 [Z] Debug
CHOICE /C:abcduxz /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 7 GOTO Debug
IF ERRORLEVEL 6 GOTO exit
IF ERRORLEVEL 5 GOTO UpdateAPP
IF ERRORLEVEL 4 GOTO Settings
IF ERRORLEVEL 3 GOTO Drivers
IF ERRORLEVEL 2 GOTO Debloat
IF ERRORLEVEL 1 GOTO Apps

:Apps
GOTO AppDLMenu

:Debloat
GOTO DebloatMenu

:Settings
GOTO SettingsMenu

:Drivers
GOTO DriversMenu

:UpdateAPP
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/UpdateAPP.cmd', 'C:\Program Files\LTSC\Scripts\UpdateAPP.cmd')" >nul 2>&1
ECHO [-] Updating APP ...
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\UpdateAPP.cmd" >nul 2>&1
exit

:Debug
GOTO DebugMenu

:exit
exit



:: Note - Install Applications Page
:AppDLMenu
mode con: cols=76 lines=20
Title Download Apps
@ECHO OFF
CLS
@ECHO.
@ECHO                                   Apps
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO        [A] Chrome         [F] Mullvad           [K] MSI Afterburner
ECHO        [B] Discord        [G] Wireguard         [L] NZXT CAM
ECHO        [C] Spotify        [H] LibreOffice       [M] VS Code
ECHO        [D] Steam          [I] Paint.net         [N] Blender
ECHO        [E] Epic Games     [J] VLC Media Player  [O] HwInfo64
ECHO.
ECHO                                                 [Page 1/7]
@ECHO ____________________________________________________________________________
ECHO.
ECHO        [X] Go back   [U] Search for Updates   [Q] More Apps
CHOICE /C:abcdefghijklmnouqx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 18 GOTO Goback
IF ERRORLEVEL 17 GOTO More
IF ERRORLEVEL 16 GOTO Updates
IF ERRORLEVEL 15 GOTO Hwinfo
IF ERRORLEVEL 14 GOTO Blender
IF ERRORLEVEL 13 GOTO VSCode
IF ERRORLEVEL 12 GOTO NZXTCam
IF ERRORLEVEL 11 GOTO MSIAfterburner
IF ERRORLEVEL 10 GOTO VlcPlayer
IF ERRORLEVEL 9 GOTO Paintnet
IF ERRORLEVEL 8 GOTO LibreOffice
IF ERRORLEVEL 7 GOTO Wireguard
IF ERRORLEVEL 6 GOTO Mullvad
IF ERRORLEVEL 5 GOTO EpicGames
IF ERRORLEVEL 4 GOTO Steam
IF ERRORLEVEL 3 GOTO Spotify
IF ERRORLEVEL 2 GOTO Discord
IF ERRORLEVEL 1 GOTO Chrome

:Chrome
ECHO [-] Installing Chrome ...
winget install Google.Chrome --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:Discord
ECHO [-] Installing Discord ...
winget install Discord.Discord --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:Spotify
ECHO [-] Downloading Spotify ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://download.scdn.co/SpotifySetup.exe', 'C:\Users\%USERNAME%\Desktop\SpotifySetup.exe')" >nul 2>&1
ECHO [!] You have to run the Setup manually.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:Steam
ECHO [-] Installing Steam ...
winget install Valve.Steam --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:EpicGames
ECHO [-] Installing Epic Games Launcher ...
winget install EpicGames.EpicGamesLauncher --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:Mullvad
ECHO [-] Installing Mullvad ...
winget install MullvadVPN.MullvadVPN --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:Wireguard
ECHO [-] Installing Wireguard ...
winget install WireGuard.WireGuard --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:LibreOffice
ECHO [-] Installing LibreOffice ...
winget install TheDocumentFoundation.LibreOffice --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:Paintnet
ECHO [-] Downloading Paint.net ...
winget install dotPDNLLC.paintdotnet --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu


:VlcPlayer
ECHO [-] Installing VLC Media Player ...
winget install VideoLAN.VLC --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:MSIAfterburner
ECHO [-] Downloading MSI Afterburner ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://ftp.nluug.nl/pub/games/PC/guru3d/afterburner/[Guru3D.com]-MSIAfterburnerSetup465Beta4Build16358.zip', 'C:\Users\%USERNAME%\Desktop\MSIAfterburner.zip')" >nul 2>&1
ECHO [-] Extracting MSI Afterburner ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\MSIAfterburner.zip' 'C:\Users\%USERNAME%\Desktop'"
ECHO [-] Installing MSI Afterburner ...
"C:\Users\%USERNAME%\Desktop\MSIAfterburnerSetup465Beta4.exe" /S
ECHO [+] Done.
timeout 5 >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\MSIAfterburner.zip" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\MSIAfterburnerSetup465Beta4.exe" >nul 2>&1
rmdir /S /Q "C:\Users\%USERNAME%\Desktop\Guru3D.com" >nul 2>&1
move /y "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\MSI Afterburner\MSI Afterburner.lnk" "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs" >nul 2>&1
rmdir /S /Q "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\MSI Afterburner"
GOTO AppDLMenu

:NZXTCam
ECHO [-] Installing NZXT Cam ...
winget install NZXT.CAM --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:VSCode
ECHO [-] Installing Visual Studio Code ...
winget install Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:Blender
ECHO [-] Installing Blender ...
winget install BlenderFoundation.Blender --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:Hwinfo
ECHO [-] Downloading HwInfo64 ...
winget install REALiX.HWiNFO --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:Updates
ECHO [-] Searching for Updates ...
winget upgrade --all >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO AppDLMenu

:Goback
GOTO Welcome

:: Note - More Applications Page
:More
mode con: cols=76 lines=20
Title Download Apps
@ECHO OFF
CLS
@ECHO.
@ECHO                                   Apps
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO       [A] Opera GX           [F] Ubisoft Connect [K] GeForce Experience
ECHO       [B] Brave              [G] GIMP            [L] GeForce NOW
ECHO       [C] EA Desktop         [H] GPU-Z           [M] PostgreSQL
ECHO       [D] GOG Galaxy         [I] OneDrive        [N] Dropbox
ECHO       [E] Battle.Net         [J] OBS Studio      [O] Teams
ECHO.
ECHO.                                                 [Page 2/7]
@ECHO ____________________________________________________________________________
ECHO.
ECHO       [X] Go back   [U] Search for Updates   [Q] More Apps
CHOICE /C:abcdefghijklmnouqx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 18 GOTO GoBack
IF ERRORLEVEL 17 GOTO More2
IF ERRORLEVEL 16 GOTO Updates
IF ERRORLEVEL 15 GOTO Teams
IF ERRORLEVEL 14 GOTO Dropbox
IF ERRORLEVEL 13 GOTO PostgreSQL
IF ERRORLEVEL 12 GOTO GeForceNOW
IF ERRORLEVEL 11 GOTO GeforceExperience
IF ERRORLEVEL 10 GOTO OBSStudio
IF ERRORLEVEL 9 GOTO OneDrive
IF ERRORLEVEL 8 GOTO GPUZ
IF ERRORLEVEL 7 GOTO GIMP
IF ERRORLEVEL 6 GOTO UbisoftConnect
IF ERRORLEVEL 5 GOTO BattleNet
IF ERRORLEVEL 4 GOTO GOGGalaxy
IF ERRORLEVEL 3 GOTO EADesktop
IF ERRORLEVEL 2 GOTO Brave
IF ERRORLEVEL 1 GOTO OperaGX

:OperaGX
ECHO [-] Installing Opera GX ...
winget install Opera.OperaGX --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:Brave
ECHO [-] Installing Brave ...
winget install Brave.Brave --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:EADesktop
ECHO [-] Installing EA Desktop ...
winget install ElectronicArts.EADesktop --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:GOGGalaxy
ECHO [-] Installing GOG Galaxy ...
winget install GOG.Galaxy --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:BattleNet
ECHO [-] Downloading Battle.net ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://www.battle.net/download/getInstallerForGame?os=win&gameProgram=BATTLENET_APP&version=Live&id=undefined', 'C:\Users\%USERNAME%\Desktop\Battle.net-Setup.exe')" >nul 2>&1
ECHO [-] Installing Battle.net ...
"C:\Users\%USERNAME%\Desktop\Battle.net-Setup.exe" --lang=enUS --installpath="C:\Program Files (x86)\Battle.net"
ECHO [+] Done.
timeout 5 >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Battle.net-Setup.exe" >nul 2>&1
GOTO More

:UbisoftConnect
ECHO [-] Installing Ubisoft Connect ...
winget install Ubisoft.Connect --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:GIMP 
ECHO [-] Installing GIMP ...
winget install GIMP.GIMP --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:GPUZ
ECHO [-] Installing GPU-Z ...
winget install TechPowerUp.GPU-Z --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:OneDrive
ECHO [-] Installing OneDrive ...
winget install  Microsoft.OneDrive --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:OBSStudio
ECHO [-] Installing OBS Studio ...
winget install OBSProject.OBSStudio --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:GeforceExperience
ECHO [-] Installing GeForce Experience ...
winget install Nvidia.GeForceExperience --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:GeforceNOW
ECHO [-] Downloading GeForce NOW ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://download.nvidia.com/gfnpc/GeForceNOW-release.exe', 'C:\Users\%USERNAME%\Desktop\GeForceNOW-Setup.exe')" >nul 2>&1
ECHO [!] Due to how the installer works, you have to run it manually.
timeout 5 >nul 2>&1
GOTO More

:PostgreSQL
ECHO [-] Installing PostgreSQL ...
winget install PostgreSQL.PostgreSQL --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:Dropbox
ECHO [-] Installing Dropbox ...
winget install Dropbox.Dropbox --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:Teams
ECHO [-] Installing Microsoft Teams ...
winget install Microsoft.Teams --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:Updates
ECHO [-] Searching for Updates ...
winget upgrade --all >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More

:GoBack
GOTO AppDLMenu

:More2
:: Note - More Applications Page 3
mode con: cols=76 lines=20
Title Download Apps
@ECHO OFF
CLS
@ECHO.
@ECHO                                   Apps
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO       [A] Zoom               [F] Visual Studio      [K] Audacity
ECHO       [B] Sublime Text       [G] Radiograph         [L] Cinebench
ECHO       [C] Notepad ++         [H] qBittorrent        [M] iTunes
ECHO       [D] Corsair iCUE       [I] PicoTorrent        [N] Rufus
ECHO       [E] Firefox            [J] Google Play Games  [O] Aida64
ECHO.
ECHO.                                                    [Page 3/7]
@ECHO ____________________________________________________________________________
ECHO.
ECHO       [X] Go back   [U] Search for Updates   [Q] More Apps
CHOICE /C:abcdefghijklmnouxq /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 18 GOTO More3
IF ERRORLEVEL 17 GOTO GoBack
IF ERRORLEVEL 16 GOTO Updates
IF ERRORLEVEL 15 GOTO Aida64
IF ERRORLEVEL 14 GOTO Rufus
IF ERRORLEVEL 13 GOTO iTunes
IF ERRORLEVEL 12 GOTO Cinebench
IF ERRORLEVEL 11 GOTO Audacity
IF ERRORLEVEL 10 GOTO GooglePlayGames
IF ERRORLEVEL 9 GOTO Picotorrent
IF ERRORLEVEL 8 GOTO qBittorrent
IF ERRORLEVEL 7 GOTO Radiograph
IF ERRORLEVEL 6 GOTO VisualStudio
IF ERRORLEVEL 5 GOTO Firefox
IF ERRORLEVEL 4 GOTO Corsairicue
IF ERRORLEVEL 3 GOTO Notepadplusplus
IF ERRORLEVEL 2 GOTO SublimeText
IF ERRORLEVEL 1 GOTO Zoom

:Zoom
ECHO [-] Installing Zoom ...
winget install Zoom.Zoom --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:SublimeText
ECHO [-] Installing Sublime Text ...
winget install SublimeHQ.SublimeText.4 --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:Notepadplusplus
ECHO [-] Installing Notepad ++ ...
winget install Notepad++.Notepad++ --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:Corsairicue
ECHO [-] Installing Corsair iCUE ...
winget install Corsair.iCUE.4 --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:Firefox
ECHO [-] Installing Firefox ...
winget install Mozilla.Firefox --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:VisualStudio
ECHO [-] Installing Visual Studio 2022 Community ...
winget install Microsoft.VisualStudio.2022.Community --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:Radiograph
ECHO [-] Installing Radiograph ...
winget install 9NH1P86H06CG --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:qBittorrent
ECHO [-] Installing qBittorrent ...
winget install qBittorrent.qBittorrent --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:Picotorrent
ECHO [-] Installing Picotorrent ...
winget install PicoTorrent.PicoTorrent --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:GooglePlayGames
ECHO [-] Installing Google Play Games ...
winget install Google.PlayGames.Beta --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:Audacity
ECHO [-] Installing Audacity ...
winget install Audacity.Audacity --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:Cinebench
ECHO [-] Installing Cinebench ...
winget install 9PGZKJC81Q7J --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:iTunes
ECHO [-] Installing iTunes ...
winget install Apple.iTunes --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:Rufus
ECHO [-] Installing Rufus ...
winget install Rufus.Rufus --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:Aida64
ECHO [-] Installing Aida64 ...
winget install FinalWire.AIDA64.Extreme --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:Updates
ECHO [-] Searching for Updates ...
winget upgrade --all >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More2

:GoBack
GOTO More

:: Note - More Applications Page 4
:More3
mode con: cols=76 lines=20
Title Download Apps
@ECHO OFF
CLS
@ECHO.
@ECHO                                   Apps
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO        [A] NordVPN              [F] Logitech G HUB     [K] Teamviewer
ECHO        [B] ExpressVPN           [G] VS Codium          [L] Parsec
ECHO        [C] Surfshark            [H] NVCleanstall       [M] Vivaldi
ECHO        [D] WinSCP               [I] BlueStacks         [N] Virtualbox
ECHO        [E] Windows Terminal     [J] Powershell         [O] VM Ware
ECHO.
ECHO.                                                       [Page 4/7]
@ECHO ____________________________________________________________________________
ECHO.
ECHO        [X] Go back   [U] Search for Updates   [Q] More Apps
CHOICE /C:abcdefghijklmnouxq /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 18 GOTO More4
IF ERRORLEVEL 17 GOTO GoBack
IF ERRORLEVEL 16 GOTO Updates
IF ERRORLEVEL 15 GOTO VMWare
IF ERRORLEVEL 14 GOTO Virtualbox
IF ERRORLEVEL 13 GOTO Vivaldi
IF ERRORLEVEL 12 GOTO Parsec
IF ERRORLEVEL 11 GOTO Teamviewer
IF ERRORLEVEL 10 GOTO Powershell
IF ERRORLEVEL 9 GOTO BlueStacks
IF ERRORLEVEL 8 GOTO NVCleanstall
IF ERRORLEVEL 7 GOTO VSCodium
IF ERRORLEVEL 6 GOTO LogitechGHUB
IF ERRORLEVEL 5 GOTO WindowsTerminal
IF ERRORLEVEL 4 GOTO WinSCP
IF ERRORLEVEL 3 GOTO Surfshark
IF ERRORLEVEL 2 GOTO ExpressVPN
IF ERRORLEVEL 1 GOTO NordVPN

:NordVPN
ECHO [-] Installing NordVPN ...
winget install NordVPN.NordVPN --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:ExpressVPN
ECHO [-] Installing ExpressVPN ...
winget install ExpressVPN.ExpressVPN --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:Surfshark
ECHO [-] Installing Surfshark ...
winget install Surfshark.Surfshark --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:WinSCP
ECHO [-] Installing WinSCP ...
winget install WinSCP.WinSCP --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:WindowsTerminal
ECHO [-] Installing Windows Terminal ...
winget install Microsoft.WindowsTerminal --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:LogitechGHUB
ECHO [-] Installing Logitech G HUB ...
winget install Logitech.GHUB --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:VSCodium
ECHO [-] Installing VSCodium ...
winget install VSCodium.VSCodium --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:NVCleanstall
ECHO [-] Installing NVCleanstall ...
winget install TechPowerUp.NVCleanstall --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:BlueStacks
ECHO [-] Installing BlueStacks ...
winget install BlueStack.BlueStacks --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:Powershell
ECHO [-] Installing Powershell ...
winget install Microsoft.PowerShell --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:Teamviewer
ECHO [-] Installing Teamviewer ...
winget install TeamViewer.TeamViewer --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:Parsec
ECHO [-] Installing Parsec ...
winget install Parsec.Parsec --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:Vivaldi
ECHO [-] Installing Vivaldi ...
winget install VivaldiTechnologies.Vivaldi --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:Virtualbox
ECHO [-] Installing Virtualbox ...
winget install Oracle.VirtualBox --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:VMWare
ECHO [-] Installing VMware ...
winget install VMware.WorkstationPlayer --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:Updates
ECHO [-] Searching for Updates ...
winget upgrade --all >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More3

:GoBack
GOTO More2

:: Note - More Applications Page 5
:More4
mode con: cols=76 lines=20
Title Download Apps
@ECHO OFF
CLS
@ECHO.
@ECHO                                   Apps
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO     [A] NVIDIA Sunshine   [F] Chrome Canary     [K] Adobe Acrobat Reader
ECHO     [B] Foobar2000        [G] Ungoogled Chromium[L] WhatsApp
ECHO     [C] CPU-Z             [H] Edge              [M] Telegram
ECHO     [D] Chrome Beta       [I] Edge Beta         [N] MS PC Manager
ECHO     [E] Chrome Dev        [J] Edge Dev          [O] Winamp 
ECHO.
ECHO.                                                [Page 5/7]
@ECHO ____________________________________________________________________________
ECHO.
ECHO     [X] Go back   [U] Search for Updates   [Q] More Apps
CHOICE /C:abcdefghijklmnouxq /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 18 GOTO More5
IF ERRORLEVEL 17 GOTO GoBack
IF ERRORLEVEL 16 GOTO Updates
IF ERRORLEVEL 15 GOTO Winamp
IF ERRORLEVEL 14 GOTO MSPCManager
IF ERRORLEVEL 13 GOTO Telegram
IF ERRORLEVEL 12 GOTO WhatsApp
IF ERRORLEVEL 11 GOTO AdobeAcrobatReader
IF ERRORLEVEL 10 GOTO EdgeDev
IF ERRORLEVEL 9 GOTO EdgeBeta
IF ERRORLEVEL 8 GOTO Edge
IF ERRORLEVEL 7 GOTO UngoogledChromium
IF ERRORLEVEL 6 GOTO ChromeCanary
IF ERRORLEVEL 5 GOTO ChromeDev
IF ERRORLEVEL 4 GOTO ChromeBeta
IF ERRORLEVEL 3 GOTO CPUZ
IF ERRORLEVEL 2 GOTO Foobar2000
IF ERRORLEVEL 1 GOTO Sunshine

:Sunshine
ECHO [-] Installing NVIDIA Sunshine ...
winget install LizardByte.Sunshine --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:Foobar2000
ECHO [-] Installing Foobar2000 ...
winget install PeterPawlowski.foobar2000 --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:CPUZ
ECHO [-] Installing CPU-Z ...
winget install CPUID.CPU-Z --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:ChromeBeta
ECHO [-] Installing Google Chrome Beta ...
winget install Google.Chrome.Beta --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:ChromeDev
ECHO [-] Installing Google Chrome Dev ...
winget install Google.Chrome.Dev --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:ChromeCanary
ECHO [-] Installing Google Chrome Canary ...
winget install Google.Chrome.Canary --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:UngoogledChromium
ECHO [-] Installing Ungoogled Chromium ...
winget install eloston.ungoogled-chromium --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4
:Edge
ECHO [-] Installing Edge ...
winget install Microsoft.Edge --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:EdgeBeta
ECHO [-] Installing Edge Beta ...
winget install Microsoft.Edge.Beta --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:EdgeDev
ECHO [-] Installing Edge Dev ...
winget install Microsoft.Edge.Dev --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:AdobeAcrobatReader
ECHO [-] Installing Adobe Acrobat Reader ...
winget install Adobe.Acrobat.Reader.64-bit --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:WhatsApp
ECHO [-] Installing WhatsApp ...
winget install WhatsApp.WhatsApp --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:Telegram
ECHO [-] Installing Telegram ...
winget install Telegram.TelegramDesktop --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:MSPCManager
ECHO [-] Installing Microsoft PC Manager ...
winget install Microsoft.PCManager --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:Winamp
ECHO [-] Installing Winamp ...
winget install Winamp.Winamp --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:Updates
ECHO [-] Searching for Updates ...
winget upgrade --all >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More4

:GoBack
GOTO More3

:: Note - More Applications Page 6
:More5
mode con: cols=76 lines=20
Title Download Apps
@ECHO OFF
CLS
@ECHO.
@ECHO                                   Apps
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO            [A] Skype         [F] EarTrumpet    [K] Dolphin
ECHO            [B] Thunderbird   [G] Files         [L] ppsspp
ECHO            [C] Slack         [H] Google Drive  [M] rpcs3
ECHO            [D] ShareX        [I] WinRar        [N] Ryujinx
ECHO            [E] Lightshot     [J] 7zip          [O] Apple Devices
ECHO.
ECHO.                                               [Page 6/7]
@ECHO ____________________________________________________________________________
ECHO.
ECHO            [X] Go back   [U] Search for Updates   [Q] More Apps
CHOICE /C:abcdefghijklmnouxq /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 18 GOTO More6
IF ERRORLEVEL 17 GOTO GoBack
IF ERRORLEVEL 16 GOTO Updates
IF ERRORLEVEL 15 GOTO AppleDevices
IF ERRORLEVEL 14 GOTO Ryujinx
IF ERRORLEVEL 13 GOTO rpcs3
IF ERRORLEVEL 12 GOTO ppsspp
IF ERRORLEVEL 11 GOTO Dolphin
IF ERRORLEVEL 10 GOTO 7zip
IF ERRORLEVEL 9 GOTO WinRar
IF ERRORLEVEL 8 GOTO GoogleDrive
IF ERRORLEVEL 7 GOTO Files
IF ERRORLEVEL 6 GOTO Eartrumpet
IF ERRORLEVEL 5 GOTO Lightshot
IF ERRORLEVEL 4 GOTO ShareX
IF ERRORLEVEL 3 GOTO Slack
IF ERRORLEVEL 2 GOTO Thunderbird
IF ERRORLEVEL 1 GOTO Skype

:Skype
ECHO [-] Installing Skype ...
winget install Microsoft.Skype --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:Thunderbird
ECHO [-] Installing Mozilla Thunderbird ...
winget install Mozilla.Thunderbird --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:Slack
ECHO [-] Installing Slack ...
winget install SlackTechnologies.Slack --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:ShareX
ECHO [-] Installing ShareX ...
winget install ShareX.ShareX --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:Lightshot
ECHO [-] Installing Lightshot ...
winget install Skillbrains.Lightshot --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:Eartrumpet
ECHO [-] Installing Eartrumpet ...
winget install File-New-Project.EarTrumpet --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:Files
ECHO [-] Installing Files ...
winget install FilesCommunity.Files --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:GoogleDrive
ECHO [-] Installing Google Drive ...
winget install Google.Drive --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:WinRar
ECHO [-] Installing WinRar ...
winget install RARLab.WinRAR --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:7zip
ECHO [-] Installing 7zip ...
winget install 7zip.7zip --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:Dolphin
ECHO [-] Installing Dolphin Emulator ...
winget install DolphinEmulator.Dolphin --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:ppsspp
ECHO [-] Installing ppsspp Emulator ...
winget install PPSSPPTeam.PPSSPP --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:rpcs3
ECHO [-] Downloading RPCS3 Emulator  ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/RPCS3/rpcs3-binaries-win/releases/download/build-39760189804d59315ab9f304d3cebddfb5d72f63/rpcs3-v0.0.26-14712-39760189_win64.7z', 'C:\Users\%USERNAME%\Desktop\rpcs3.7z')" >nul 2>&1
ECHO [+] Done. Extract the .7z file and run the setup.
timeout 5 >nul 2>&1
GOTO More5

:Ryujinx
ECHO [-] Installing Ryujinx Emulator  ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/Ryujinx/release-channel-master/releases/download/1.1.617/ryujinx-1.1.617-win_x64.zip', 'C:\Users\%USERNAME%\Desktop\ryujinx.zip')" >nul 2>&1
ECHO [-] Extracting Ryujinx ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\ryujinx.zip' 'C:\Users\%USERNAME%\Desktop\ryujinx'" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\ryujinx.zip" >nul 2>&1
GOTO More5

:AppleDevices
ECHO [-] Installing Apple Devices  ...
winget install 9NP83LWLPZ9K --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:Updates
ECHO [-] Searching for Updates ...
winget upgrade --all >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More5

:GoBack
GOTO More4

:: Note - More Applications Page 7
:More6
mode con: cols=76 lines=20
Title Download Apps
@ECHO OFF
CLS
@ECHO.
@ECHO                                   Apps
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO          [A] Microsoft Store   [F] Xbox ID Provider  [K] Placeholder
ECHO          [B] MS Store Buy App  [G] Placeholder       [L] Placeholder
ECHO          [C] Snipping Tool     [H] Placeholder       [M] Placeholder
ECHO          [D] Notepad           [I] Placeholder       [N] Placeholder
ECHO          [E] Nanazip           [J] Placeholder       [O] Placeholder
ECHO.
ECHO.                                                     [Page 7/7]
@ECHO ____________________________________________________________________________
ECHO.
ECHO          [X] Go back   [U] Search for Updates
CHOICE /C:abcdefghijklmnouxq /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 18 GOTO More6
IF ERRORLEVEL 17 GOTO GoBack
IF ERRORLEVEL 16 GOTO Updates
IF ERRORLEVEL 15 GOTO Placeholder
IF ERRORLEVEL 14 GOTO Placeholder
IF ERRORLEVEL 13 GOTO Placeholder
IF ERRORLEVEL 12 GOTO Placeholder
IF ERRORLEVEL 11 GOTO Placeholder
IF ERRORLEVEL 10 GOTO Placeholder
IF ERRORLEVEL 9 GOTO Placeholder
IF ERRORLEVEL 8 GOTO Placeholder
IF ERRORLEVEL 7 GOTO Placeholder
IF ERRORLEVEL 6 GOTO XboxIdentityProvider
IF ERRORLEVEL 5 GOTO Nanazip
IF ERRORLEVEL 4 GOTO Notepad
IF ERRORLEVEL 3 GOTO SnippingTool
IF ERRORLEVEL 2 GOTO MicrosoftStorePurchaseApp
IF ERRORLEVEL 1 GOTO MicrosoftStore

:MicrosoftStore
ECHO [-] Installing Microsoft Store ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Apps/Microsoft_Store.msix', 'C:\Users\%USERNAME%\Desktop\Microsoft_Store.msix')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path 'C:\Users\%USERNAME%\Desktop\Microsoft_Store.msix'" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1076434344106803261/Services_Store.Engagement.Appx', 'C:\Users\%USERNAME%\Desktop\Services_Store.Engagement.Appx')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path 'C:\Users\%USERNAME%\Desktop\Services_Store.Engagement.Appx'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Services_Store.Engagement.Appx" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Microsoft_Store.msix" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More6

:MicrosoftStorePurchaseApp
ECHO [-] Installing Microsoft Store Purchase App ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1076434306051878984/Microsoft_Store-PurchaseApp.Msixbundle', 'C:\Users\%USERNAME%\Desktop\Microsoft_Store-PurchaseApp.Msixbundle')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path 'C:\Users\%USERNAME%\Desktop\Microsoft_Store-PurchaseApp.Msixbundle'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Microsoft_Store-PurchaseApp.Msixbundle" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More6

:SnippingTool
ECHO [-] Installing Snipping Tool ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1076434358229008404/SnippingTool.msix', 'C:\Users\%USERNAME%\Desktop\SnippingTool.msix')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path 'C:\Users\%USERNAME%\Desktop\SnippingTool.msix'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\SnippingTool.msix" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More6

:Notepad
ECHO [-] Installing Notepad ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1076434332958330970/Notepad.msix', 'C:\Users\%USERNAME%\Desktop\Notepad.msix')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path 'C:\Users\%USERNAME%\Desktop\Notepad.msix'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Notepad.msix" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More6

:Nanazip
ECHO [-] Installing Nanazip ...
winget install M2Team.NanaZip --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More6

:XboxIdentityProvider
ECHO [-] Installing Windows Terminal ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1076434414466248744/XboxIdentityProvider.appx', 'C:\Users\%USERNAME%\Desktop\XboxIdentityProvider.appx')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path 'C:\Users\%USERNAME%\Desktop\XboxIdentityProvider.appx'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\XboxIdentityProvider.appx" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More6

:Placeholder
ECHO [-] Placeholder.
timeout 5 >nul 2>&1
GOTO More6

:Updates
ECHO [-] Searching for Updates ...
winget upgrade --all >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO More6

:GoBack
GOTO More5

:: Note - Further Debloat Windows Page
:DebloatMenu
mode con: cols=76 lines=20
Title Debloat
@ECHO OFF
CLS
@ECHO.
@ECHO                         Debloat Windows even further.
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO      [A] Remove all preinstalled Apps
ECHO.
@ECHO ____________________________________________________________________________
ECHO.
ECHO      [X] Go back
CHOICE /C:ax /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 2 GOTO GoBack
IF ERRORLEVEL 1 GOTO RemoveAll

:RemoveAll
ECHO [-] Removing Snipping Tool ...
powershell -command "Get-AppxPackage *sketch* | Remove-AppxPackage" >nul 2>&1
ECHO [-] Removing Nanazip ...
powershell -command "Get-AppxPackage *nanazip* | Remove-AppxPackage" >nul 2>&1
ECHO [-] Removing Windows Terminal ...
powershell -command "Get-AppxPackage *terminal* | Remove-AppxPackage" >nul 2>&1
ECHO [-] Removing Windows Notepad ...
powershell -command "Get-AppxPackage *notepad* | Remove-AppxPackage" >nul 2>&1
ECHO [-] Removing Xbox  ...
powershell -command "Get-AppxPackage *xbox* | Remove-AppxPackage" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO DebloatMenu

:GoBack
GOTO Welcome

:: Note - Settings Page
:SettingsMenu
mode con: cols=76 lines=20
Title Settings / Tweaks
@ECHO OFF
CLS
@ECHO.
@ECHO                                   Settings  
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO       [A] Disable Windows Defender         [I] Disable SmartScreen
ECHO       [B] Enable  Windows Defender         [J] Enable  SmartScreen
ECHO       [C] Enable  Windows Dark Theme       [K] Disable Firewall
ECHO       [D] Enable  Windows Light Theme      [L] Enable  Firewall
ECHO       [E] Modernized classic context Menu  [M] Enable  Windows AMOLED
ECHO       [F] Back to Windows 11 Context Menu  [N] Disable Windows AMOLED
ECHO       [G] Enable  Photo Viewer [Legacy]
ECHO       [H] Disable Photo Viewer [Legacy]
@ECHO.
@ECHO ____________________________________________________________________________
ECHO.
ECHO       [X] Go back
CHOICE /C:abcdefghijklmnx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 15 GOTO GoBack
IF ERRORLEVEL 14 GOTO DisableWindowsAmoled
IF ERRORLEVEL 13 GOTO EnableWindowsAmoled
IF ERRORLEVEL 12 GOTO EnableFirewall
IF ERRORLEVEL 11 GOTO DisableFirewall
IF ERRORLEVEL 10 GOTO EnableSmartscreen
IF ERRORLEVEL 9 GOTO DisableSmartscreen
IF ERRORLEVEL 8 GOTO DisablePhotoViewer
IF ERRORLEVEL 7 GOTO EnablePhotoViewer
IF ERRORLEVEL 6 GOTO Windows11ContextMenu
IF ERRORLEVEL 5 GOTO ModernContextMenu
IF ERRORLEVEL 4 GOTO EnableLightMode
IF ERRORLEVEL 3 GOTO EnableDarkMode
IF ERRORLEVEL 2 GOTO EnableDefender
IF ERRORLEVEL 1 GOTO DisableDefender


:DisableDefender
ECHO [-] Turning Windows Defender off ...
timeout 2 >nul 2>&1
ECHO [!] Please go into Virus and Threat protection settings and
ECHO [!] turn off Tamper Protection. Press any Key to continue.
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/AntiDefender.cmd', 'C:\Program Files\LTSC\Scripts\AntiDefender.cmd')" >nul 2>&1
pause >nul 2>&1
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\AntiDefender.cmd" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu


:EnableDefender
ECHO [-] Turning Windows Defender back on ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/AntiDefenderUndo.cmd', 'C:\Program Files\LTSC\Scripts\AntiDefenderUndo.cmd')" >nul 2>&1
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\AntiDefenderUndo.cmd" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:EnableDarkMode
ECHO [-] Turning on Dark Mode ...
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V SystemUsesLightTheme /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V AppsUseLightTheme /T REG_DWORD /D 0 /F >nul 2>&1
taskkill /F /IM explorer.exe & start explorer >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:EnableLightMode
ECHO [-] Turning on Light Mode ...
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V SystemUsesLightTheme /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V AppsUseLightTheme /T REG_DWORD /D 1 /F >nul 2>&1
taskkill /F /IM explorer.exe & start explorer >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:ModernContextMenu
ECHO [-] Switching to a more modernized classic context menu.
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
winget install Nilesoft.Shell --accept-source-agreements --accept-package-agreements >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:Windows11ContextMenu
ECHO [-] Returning to the usual Windows 11 default context menu.
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
winget uninstall Nilesoft.Shell >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:EnablePhotoViewer
ECHO [-] Turning legacy Photo Viewer on ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/EnablePhotoViewer.reg', 'C:\Program Files\LTSC\Scripts\EnablePhotoViewer.reg')" >nul 2>&1
regedit /s "C:\Program Files\LTSC\Scripts\EnablePhotoViewer.reg" >nul 2>&1
ECHO [+] Done. You might have to restart.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:DisablePhotoViewer
ECHO [-] Turning legacy Photo Viewer back off ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/DisablePhotoViewer.reg', 'C:\Program Files\LTSC\Scripts\DisablePhotoViewer.reg')" >nul 2>&1
regedit /s "C:\Program Files\LTSC\Scripts\DisablePhotoViewer.reg" >nul 2>&1
ECHO [+] Done. You might have to restart.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:DisableSmartscreen
ECHO [-] Turning Windows Smartscreen off ...
REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:EnableSmartscreen
ECHO [-] Turning Windows Smartscreen back on ...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Warn" /f >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:DisableFirewall
ECHO [-] Turning Windows Firewall off ...
netsh advfirewall set allprofiles state off >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:EnableFirewall
ECHO [-] Turning Windows Smartscreen back on ...
netsh advfirewall set allprofiles state on >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:EnableWindowsAmoled
ECHO [-] Turning on AMOLED setting ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/EnableAMOLED.reg', 'C:\Program Files\LTSC\Scripts\EnableAMOLED.reg')" >nul 2>&1
regedit /s "C:\Program Files\LTSC\Scripts\EnableAMOLED.reg" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:DisableWindowsAmoled
ECHO [-] Undoing AMOLED changes ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/DisableAMOLED.reg', 'C:\Program Files\LTSC\Scripts\DisableAMOLED.reg')" >nul 2>&1
regedit /s "C:\Program Files\LTSC\Scripts\DisableAMOLED.reg" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO SettingsMenu

:GoBack
GOTO Welcome
:: Note - Drivers Menu Page
:DriversMenu
mode con: cols=76 lines=20
Title Install Drivers
@ECHO OFF
CLS
@ECHO.
@ECHO                                    Drivers
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO     [A] Chipset      [B] Graphics        [C] Audio      [D] Networking
ECHO.
@ECHO ____________________________________________________________________________
ECHO.
ECHO     [X] Go back
CHOICE /C:abcdx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 5 GOTO GoBack
IF ERRORLEVEL 4 GOTO Networking
IF ERRORLEVEL 3 GOTO Audio
IF ERRORLEVEL 2 GOTO Graphics
IF ERRORLEVEL 1 GOTO Chipset

:Chipset
GOTO ChipsetMenu

:Graphics
GOTO GraphicsMenu

:Audio
GOTO AudioMenu

:Networking
GOTO NetworkingMenu

:GoBack
GOTO Welcome

:: Note - Chipset Menu Page
:ChipsetMenu
mode con: cols=76 lines=20
Title Install Drivers: Chipset
@ECHO OFF
CLS
@ECHO.
@ECHO                                    Chipset
@ECHO.
@ECHO ___________________________________________________________________________
@ECHO.
ECHO             [A] Intel "Legacy" (1xx-5xx)    [B] Intel 6xx-7xx
ECHO             [C] AMD   "Legacy" (5xx-9xx)    [D] AMD 3xx-6xx/TR40
ECHO.
@ECHO ___________________________________________________________________________
ECHO.
ECHO             [X] Go back
CHOICE /C:abcdx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 5 GOTO GoBack
IF ERRORLEVEL 4 GOTO AMDRyzen
IF ERRORLEVEL 3 GOTO AMDLegacy
IF ERRORLEVEL 2 GOTO Intel1213
IF ERRORLEVEL 1 GOTO IntelLegacy

:IntelLegacy
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1073476383705137232/CHIPSET_Intel_v10.1.19284.8351.exe', 'C:\Users\%USERNAME%\Desktop\Intel_Legacy_Chipset.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO ChipsetMenu

:Intel1213
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1075355439807594566/intel1213.exe', 'C:\Users\%USERNAME%\Desktop\Intel_Chipset.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO ChipsetMenu

:AMDLegacy
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073827304242942062/CHIPSET_AMD_LEGACY.exe', 'C:\Users\%USERNAME%\Desktop\AMD_Legacy_Chipset.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO ChipsetMenu

:AMDRyzen
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://dlcdnets.asus.com/pub/ASUS/mb/03CHIPSET/DRV_Chipset_AMD_AM5_SZ-TSD_W11_64_V407132243_20220901R.zip', 'C:\Users\%USERNAME%\Desktop\AMD_Chipset.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\AMD_Chipset.zip' 'C:\Users\%USERNAME%\Desktop\AMD_Chipset'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\AMD_Chipset.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO ChipsetMenu

:GoBack
GOTO DriversMenu

:: Note - Graphics Menu Page
:GraphicsMenu
mode con: cols=76 lines=20
Title Install Drivers: Graphics
@ECHO OFF
CLS
@ECHO.
@ECHO                                   Graphics
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO   [A] NVIDIA GeForce 900-4000 Series        [E] AMD Radeon 400-7000 Series
ECHO   [B] NVIDIA GeForce 600-700  Series        [F] Intel Arc
ECHO   [C] NVIDIA GeForce 400-500  Series        [G] Intel iGPU
ECHO   [D] NVIDIA GeForce 100-300  Series        
ECHO.
@ECHO ____________________________________________________________________________
ECHO.
ECHO   [X] Go back
CHOICE /C:abcdefgx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 8 GOTO GoBack
IF ERRORLEVEL 7 GOTO InteliGPU
IF ERRORLEVEL 6 GOTO IntelArc
IF ERRORLEVEL 5 GOTO AMDRadeon4007000
IF ERRORLEVEL 4 GOTO NvidiaGeforce4
IF ERRORLEVEL 3 GOTO NvidiaGeforce3
IF ERRORLEVEL 2 GOTO NvidiaGeforce2
IF ERRORLEVEL 1 GOTO NvidiaGeforce1

:NvidiaGeforce1
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://international.download.nvidia.com/Windows/528.49/528.49-desktop-win10-win11-64bit-international-dch-whql.exe', 'C:\Users\%USERNAME%\Desktop\NVIDIA_528.49.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO GraphicsMenu

:NvidiaGeforce2
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://international.download.nvidia.com/Windows/474.14/474.14-desktop-win10-win11-64bit-international-dch-whql.exe', 'C:\Users\%USERNAME%\Desktop\NVIDIA_474.14.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO GraphicsMenu

:NvidiaGeforce3
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://international.download.nvidia.com/Windows/391.35/391.35-desktop-win10-64bit-international-whql.exe', 'C:\Users\%USERNAME%\Desktop\NVIDIA_391.35.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO GraphicsMenu

:NvidiaGeforce4
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://international.download.nvidia.com/Windows/342.01/342.01-desktop-win10-64bit-international.exe', 'C:\Users\%USERNAME%\Desktop\NVIDIA_342.01.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO GraphicsMenu

:AMDRadeon4007000
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://www.mediafire.com/file/krpbxjxgayxzxki/whql-amd-software-adrenalin-edition-23.2.1-win10-win11-feb14-VideoCardz.com.exe', 'C:\Users\%USERNAME%\Desktop\AMD_Radeon.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO GraphicsMenu

:IntelArc
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://downloadmirror.intel.com/768896/gfx_win_101.4125.exe', 'C:\Users\%USERNAME%\Desktop\Intel_ARC.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO GraphicsMenu

:InteliGPU
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://downloadmirror.intel.com/751359/gfx_win_101.3790_101.2114.zip', 'C:\Users\%USERNAME%\Desktop\Intel_iGPU.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Intel_iGPU.zip' 'C:\Users\%USERNAME%\Desktop\InteliGPU'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Intel_iGPU.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO GraphicsMenu

:GoBack
GOTO DriversMenu

:: Note - Audio Menu Page
:AudioMenu
mode con: cols=76 lines=20
Title Install Drivers: Audio
@ECHO OFF
CLS
@ECHO.
@ECHO                                    Audio
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO          [A] Realtek Audio (ASUS)         [B] Realtek Audio (MSI)
ECHO          [C] Realtek Audio (GigaByte)     [D] Realtek Audio (Asrock)
ECHO          [E] Realtek Audio (EVGA)         [F] Realtek Audio (Dell)
ECHO          [G] Realtek Audio (Lenovo)       [H] Realtek Audio (HP)
ECHO.
ECHO          [I] Realtek Audio (Others, right click install .inf file)
ECHO.
@ECHO ____________________________________________________________________________
ECHO.
ECHO          [X] Go back
CHOICE /C:abcdefghix /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 10 GOTO GoBack
IF ERRORLEVEL 9 GOTO RealtekAllOEM
IF ERRORLEVEL 8 GOTO RealtekHP
IF ERRORLEVEL 7 GOTO RealtekLenovo
IF ERRORLEVEL 6 GOTO RealtekDell
IF ERRORLEVEL 5 GOTO RealtekEVGA
IF ERRORLEVEL 4 GOTO RealtekAsrock
IF ERRORLEVEL 3 GOTO RealtekGigaByte
IF ERRORLEVEL 2 GOTO RealtekMSI
IF ERRORLEVEL 1 GOTO RealtekAsus

:RealtekAsus
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073484583586234409/AUDIO_Realtek_UAD_ASUS_ROG-TUF-PRIME_RTK_v6.0.9468.1.zip', 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_ASUS_v6.0.9468.1.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_ASUS_v6.0.9468.1.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_ASUS'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_ASUS_v6.0.9468.1.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO AudioMenu

:RealtekMSI
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://download.msi.com/nb_drivers/ad/9459_UAD_WHQL_NB_6.0.9459.1_0x7b15cb9a.zip', 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_MSI_v6.0.9459.1.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_MSI_v6.0.9459.1.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_MSI'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_MSI_v6.0.9459.1.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO AudioMenu

:RealtekGigaByte
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://download.gigabyte.com/FileList/Driver/nb-driver-64bit-win11-dchu-audio-6.0.9459.1.zip', 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_GigaByte_v6.0.9459.1.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_GigaByte_v6.0.9459.1.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_GigaByte'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_GigaByte_v6.0.9459.1.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO AudioMenu

:RealtekAsrock
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://www.station-drivers.com/download/Realtek/uad/Realtek_uad_9462.1_asrock(station-drivers.com).zip', 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_Asrock_v6.0.9462.1.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_Asrock_v6.0.9462.1.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Asrock'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_Asrock_v6.0.9462.1.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO AudioMenu

:RealtekEVGA
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.evga.com/driver/Z690/E698/Audio.zip', 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_EVGA_v6.0.9225.1.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_EVGA_v6.0.9225.1.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_EVGA'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_EVGA_v6.0.9225.1.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO AudioMenu

:RealtekDell
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://dl.dell.com/FOLDER09103111M/2/Realtek-High-Definition-Audio-Driver_5X81R_WIN_6.0.9422.1_A03.EXE', 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_Dell_v6.0.9422.1.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO AudioMenu

:RealtekLenovo
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://download.lenovo.com/consumer/mobiles/fql3047fsep5knd0.exe', 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_Lenovo_v6.0.9462.1.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO AudioMenu

:RealtekHP
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://ftp.ext.hp.com/pub/softpaq/sp143501-144000/sp143948.exe', 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_HP_v6.0.9452.1.exe')" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO AudioMenu

:RealtekAllOEM
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073522959228096552/AUDIO_Realtek_UAD_Others_v6.0.9462.1.zip', 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_Others_v6.0.9462.1.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_Others_v6.0.9462.1.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Others'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\AUDIO_Realtek_UAD_Others_v6.0.9462.1.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO AudioMenu

:GoBack
GOTO DriversMenu

:NetworkingMenu
:: Note - Netowrking Menu Page
mode con: cols=76 lines=20
Title Install Drivers: Network
@ECHO OFF
CLS
@ECHO.
@ECHO                                 Networking
@ECHO.
@ECHO ___________________________________________________________________________
@ECHO.
@echo   [A] Intel Ethernet     [B] Realtek Ethernet  [C] AMD/Mediatek Ethernet
@echo   [D] Intel Wifi         [E] Realtek Wifi      [F] AMD/Mediatek Wifi
@echo   [G] Intel Bluetooth    [H] Realtek Bluetooth [I] AMD/Mediatek Bluetooth
ECHO.
@echo   [J] Qualcomm Ethernet  [K] Marvell Ethernet  [L] Broadcom Ethernet
@echo   [M] Qualcomm Wifi      [N] Marvell Wifi      [O] Broadcom Wifi
@echo   [P] Qualcomm Bluetooth [Q] Marvell Bluetooth [R] Broadcom Bluetooth
ECHO.
@ECHO ___________________________________________________________________________
ECHO.
@echo   [X] Go back
CHOICE /C:abcdefghijklmnopqrx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 19 GOTO GoBack
IF ERRORLEVEL 18 GOTO BroadcomBluetooth
IF ERRORLEVEL 17 GOTO MarvellBluetooth
IF ERRORLEVEL 16 GOTO QualcommBluetooth
IF ERRORLEVEL 15 GOTO BroadcomWifi
IF ERRORLEVEL 14 GOTO MarvellWifi
IF ERRORLEVEL 13 GOTO QualcommWifi
IF ERRORLEVEL 12 GOTO BroadcomEthernet
IF ERRORLEVEL 11 GOTO MarvellEthernet
IF ERRORLEVEL 10 GOTO QualcommEthernet
IF ERRORLEVEL 9 GOTO MediatekBluetooth
IF ERRORLEVEL 8 GOTO RealtekBluetooth
IF ERRORLEVEL 7 GOTO IntelBluetooth
IF ERRORLEVEL 6 GOTO MediatekWifi
IF ERRORLEVEL 5 GOTO RealtekWifi
IF ERRORLEVEL 4 GOTO IntelWifi
IF ERRORLEVEL 3 GOTO MediatekEthernet
IF ERRORLEVEL 2 GOTO RealtekEthernet
IF ERRORLEVEL 1 GOTO IntelEthernet

:IntelEthernet
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073542197032525854/Intel_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Intel_Ethernet.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Intel_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Intel_Ethernet.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:RealtekEthernet
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073542196025892934/Realtek_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Realtek_Ethernet.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Realtek_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Realtek_Ethernet.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:MediatekEthernet
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073542194943762522/Mediatek_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Mediatek_Ethernet.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Mediatek_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Mediatek_Ethernet.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:IntelWifi
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073542194218143804/Intel_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Intel_Wifi.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Intel_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Intel_Wifi.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:RealtekWifi
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073542196407570474/Realtek_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Realtek_Wifi.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Realtek_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Realtek_Wifi.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:MediatekWifi
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073542195283496960/Mediatek_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Mediatek_Wifi.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Mediatek_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Mediatek_Wifi.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:IntelBluetooth
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073542196734734356/Intel_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Intel_Bluetooth.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Intel_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Intel_Bluetooth.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:RealtekBluetooth
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073542195623243856/Realtek_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Realtek_Bluetooth.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Realtek_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Realtek_Bluetooth.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:MediatekBluetooth
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/955551954396934146/1073542194591445083/Mediatek_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Mediatek_Bluetooth.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Mediatek_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Mediatek_Bluetooth.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:QualcommEthernet
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1074349991402938378/Qualcomm_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Qualcomm_Ethernet.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Qualcomm_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Qualcomm_Ethernet.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:MarvellEthernet
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1074350040082030645/Marvell_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Marvell_Ethernet.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Marvell_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Marvell_Ethernet.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:BroadcomEthernet
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1074350115319451668/Broadcom_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Broadcom_Ethernet.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Broadcom_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Broadcom_Ethernet.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:QualcommWifi
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1074350007408410725/Qualcomm_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Qualcomm_Wifi.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Qualcomm_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Qualcomm_Wifi.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:MarvellWifi
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1074350049875730542/Marvell_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Marvell_Wifi.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Marvell_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Marvell_Wifi.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:BroadcomWifi
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1074350133602418798/Broadcom_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Broadcom_Wifi.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Broadcom_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Broadcom_Wifi.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:QualcommBluetooth
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1074350022352719912/Qualcomm_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Qualcomm_Bluetooth.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Qualcomm_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Qualcomm_Bluetooth.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:MarvellBluetooth
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1074350060793507850/Marvell_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Marvell_Bluetooth.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Marvell_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Marvell_Bluetooth.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:BroadcomBluetooth
ECHO [-] Downloading Driver ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1074350150836813874/Broadcom_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Broadcom_Bluetooth.zip')" >nul 2>&1
ECHO [-] Extracting Driver ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Broadcom_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Broadcom_Bluetooth.zip" >nul 2>&1
ECHO [-] Done.
timeout 5 >nul 2>&1
GOTO NetworkingMenu

:GoBack
GOTO DriversMenu

:DebugMenu
mode con: cols=76 lines=20
Title Install Drivers
@ECHO OFF
CLS
@ECHO.
@ECHO                                     Debug
@ECHO.
@ECHO ____________________________________________________________________________
@ECHO.
ECHO [A] Repair Windows     [B] Repair Windows (.WIM)   [C] Clean Temp Files
ECHO [D] Install Win Updates[E] MS Activation           [F] Update APP
ECHO [G] Rebuild Icon Cache [H] Flush DNS Cache         [I] Clear Thumbnail cache
ECHO [J] Repair MS Store    [K] Enable builtin Admin    [L] Disable builtin Admin
ECHO.[M] Disable TPM Checks [N] Disable Modern Standby  [O] Reapply LTSC scripts
ECHO.
@ECHO ____________________________________________________________________________
ECHO.
ECHO [X] Go back   [Y] Restart Windows   [Z] Restart into BIOS
CHOICE /C:abcdefghijklmnoxyz /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 18 GOTO RestartBIOS
IF ERRORLEVEL 17 GOTO RestartWindows
IF ERRORLEVEL 16 GOTO GoBack
IF ERRORLEVEL 15 GOTO ReapplyLTSC
IF ERRORLEVEL 14 GOTO DisableModernStandby
IF ERRORLEVEL 13 GOTO DisableChecks
IF ERRORLEVEL 12 GOTO DisableBuiltinAdmin
IF ERRORLEVEL 11 GOTO EnableBuiltinAdmin
IF ERRORLEVEL 10 GOTO RepairMSStore
IF ERRORLEVEL 9 GOTO ClearThumbnailCache
IF ERRORLEVEL 8 GOTO FlushDNS
IF ERRORLEVEL 7 GOTO RebuildIconCache
IF ERRORLEVEL 6 GOTO UpdateAPP
IF ERRORLEVEL 5 GOTO MSActivation
IF ERRORLEVEL 4 GOTO InstallUpdates
IF ERRORLEVEL 3 GOTO CleanTempFiles
IF ERRORLEVEL 2 GOTO RepairWindowsAdvanced
IF ERRORLEVEL 1 GOTO RepairWindows

:RepairWindows
ECHO [-] Trying to repair Windows ...
SFC /Scannow >nul 2>&1
DISM /Online /Cleanup-Image /CheckHealth >nul 2>&1
DISM /Online /Cleanup-Image /ScanHealth >nul 2>&1
DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1
ECHO [+] Done. Please restart Windows.
timeout 5 >nul 2>&1
GOTO DebugMenu

:RepairWindowsAdvanced
ECHO [-] Trying to repair Windows ...
timeout 2 >nul 2>&1
ECHO [!] Copy install.wim file to C:\Program Files\LTSC\AdditionalFiles\RepairWin
ECHO [!] Press any key to continue.
pause >nul 2>&1
SFC /Scannow >nul 2>&1
DISM /Online /Cleanup-Image /CheckHealth >nul 2>&1
DISM /Online /Cleanup-Image /ScanHealth >nul 2>&1
DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1
DISM /Online /Cleanup-Image /RestoreHealth /Source:C:\Program Files\LTSC\AdditionalFiles\RepairWin\install.wim
ECHO [+] Done. Please restart Windows.
timeout 5 >nul 2>&1
GOTO DebugMenu

:CleanTempFiles
ECHO [-] Cleaning Windows ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/CleanFiles.cmd', 'C:\Program Files\LTSC\Scripts\CleanFiles.cmd')" >nul 2>&1
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\CleanFiles.cmd" >nul 2>&1
timeout 10 >nul 2>&1
GOTO DebugMenu

:InstallUpdates
ECHO [-] Searching for Windows Updates ...
PowerShell -Command "Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO DebugMenu

:MSActivation
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/KMS_VL_ALL_AIO.cmd', 'C:\Program Files\LTSC\Scripts\KMS_VL_ALL_AIO.cmd')" >nul 2>&1
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\KMS_VL_ALL_AIO.cmd" >nul 2>&1
timeout 5 >nul 2>&1
GOTO DebugMenu

:UpdateAPP
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/UpdateAPP.cmd', 'C:\Program Files\LTSC\Scripts\UpdateAPP.cmd')" >nul 2>&1
ECHO [-] Updating APP ...
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\UpdateAPP.cmd" >nul 2>&1
exit

:RebuildIconCache
ECHO [-] Rebuilding icon cache ...
ie4uinit.exe -show >nul 2>&1
taskkill /IM explorer.exe /F >nul 2>&1
DEL /A /Q "%localappdata%\IconCache.db" >nul 2>&1
DEL /A /F /Q "%localappdata%\Microsoft\Windows\Explorer\iconcache*" >nul 2>&1
ECHO [+] Done. Windows will restart to finish the rebuilding process.
timeout 5 >nul 2>&1
shutdown /r /f /t 00 >nul 2>&1
GOTO DebugMenu

:FlushDNS
ECHO [-] Flushing DNS resolver cache ...
ipconfig /flushdns >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO DebugMenu

:ClearThumbnailCache
ECHO [-] Clearing thumbnail cache ...
taskkill /f /im explorer.exe >nul 2>&1
timeout 2 >nul 2>&1
DEL /F /S /Q /A "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
timeout 2 >nul 2>&1
start explorer.exe
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO DebugMenu

:RepairMSStore
ECHO [-] Trying to repair the Microsoft Store App ...
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage -AllUsers 'WindowsStore' | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppXManifest.xml'}" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO DebugMenu

:EnableBuiltinAdmin
ECHO [-] Enabling builtin Administrator account ...
net user Administrator /active:yes >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO DebugMenu

:DisableBuiltinAdmin
ECHO [-] Disabling builtin Administrator account ...
net user Administrator /active:no >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO DebugMenu

:DisableChecks
ECHO [-] Disabling Upgrade Hardware compatibility checks ...
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vdsldr.exe" /f >nul 2>&1
wmic /namespace:"\\root\subscription" path __EventFilter where Name="Skip TPM Check on Dynamic Update" delete >nul 2>&1
REG Add "HKLM\SYSTEM\Setup\MoSetup" /V AllowUpgradesWithUnsupportedTPMOrCPU /T REG_DWORD /D 1 /F >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO DebugMenu

:DisableModernStandby
ECHO [-] Disabling modern standby connectivity ...
POWERCFG -SETDCVALUEINDEX SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 >nul 2>&1
POWERCFG -SETACVALUEINDEX SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO DebugMenu

:ReapplyLTSC
ECHO [-] Re-applying LTSC scripts ...
powershell -command "wget 'https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/setup.cmd' -outfile 'C:\Program Files\LTSC\Setup.cmd'" >nul 2>&1
start cmd.exe @cmd /C "C:\Program Files\LTSC\Setup.cmd" >nul 2>&1
ECHO [+] Done.
timeout 5 >nul 2>&1
GOTO DebugMenu

:GoBack
GOTO Welcome

:RestartWindows
ECHO [-] Restarting Windows ...
timeout 5 >nul 2>&1
shutdown /r /f /t 00 >nul 2>&1

:RestartBIOS
ECHO [-] Restarting into BIOS ...
timeout 5 >nul 2>&1
shutdown /r /fw -t 0 >nul 2>&1

:: Note - BATCH FILE END.
