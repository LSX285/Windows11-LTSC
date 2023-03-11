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

set version=v1.0.4.5
set ltscdir=C:\Program Files\LTSC
set vivetool="%ltscdir%\Scripts\Vivetool\ViVeTool.exe"
set desktop=C:\Users\%USERNAME%\Desktop
set repository=https://github.com/LSX285/Windows11-LTSC/raw/main
set notify=powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,
set downloadfile=powershell -command "(New-Object Net.WebClient).DownloadFile(
set wingetsilent=--accept-source-agreements --accept-package-agreements

:: Note - Welcome Page
:Welcome
mode con: cols=76 lines=20
Title APP %version%
@ECHO OFF
CLS
@ECHO.   
@ECHO.                                 Hi, [96m%USERNAME%[0m
@ECHO                          Welcome to Windows [94m11[0m [7mLTSC[0m
@ECHO. 
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO    [[1mA[0m] Install Apps     [[1mB[0m] More Debloat      [[1mC[0m] Drivers    [[1mD[0m] Settings
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO      [101m[X] Go back[0m                                              [100m[Z] Debug[0m
CHOICE /C:abcdxz /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 6 GOTO DebugMenu
IF ERRORLEVEL 5 GOTO exit
IF ERRORLEVEL 4 GOTO SettingsMenu
IF ERRORLEVEL 3 GOTO DriversMenu
IF ERRORLEVEL 2 GOTO DebloatMenu
IF ERRORLEVEL 1 GOTO AppDLMenu

:exit
exit

:: Note - Install Applications Page
:AppDLMenu
mode con: cols=76 lines=20
Title Download Apps %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                   [7mApps[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO        [[1mA[0m] Chrome         [[1mF[0m] Mullvad           [[1mK[0m] MSI Afterburner
ECHO        [[1mB[0m] Discord        [[1mG[0m] Wireguard         [[1mL[0m] NZXT CAM
ECHO        [[1mC[0m] Spotify        [[1mH[0m] LibreOffice       [[1mM[0m] VS Code
ECHO        [[1mD[0m] Steam          [[1mI[0m] Paint.net         [[1mN[0m] Blender
ECHO        [[1mE[0m] Epic Games     [[1mJ[0m] VLC Media Player  [[1mO[0m] HwInfo64
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO        [101m[X] Go back[0m   [100m[U] Search for Updates[0m   [100m[Q] More Apps[0m   [[93m1[0m/[96m7[0m]
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
winget install Google.Chrome %wingetsilent% >nul 2>&1
%notify%'APP','Google Chrome has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Discord
winget install Discord.Discord %wingetsilent% >nul 2>&1
%notify%'APP','Discord has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Spotify
%downloadfile%'https://download.scdn.co/SpotifySetup.exe', '%desktop%\SpotifySetup.exe')" >nul 2>&1
%notify%'APP','Spotify has been downloaded. Please run the setup manually.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Steam
winget install Valve.Steam %wingetsilent% >nul 2>&1
%notify%'APP','Steam has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:EpicGames
winget install EpicGames.EpicGamesLauncher %wingetsilent% >nul 2>&1
%notify%'APP','Epic Games Launcher has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Mullvad
winget install MullvadVPN.MullvadVPN %wingetsilent% >nul 2>&1
%notify%'APP','Mullvad has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Wireguard
winget install WireGuard.WireGuard %wingetsilent% >nul 2>&1
%notify%'APP','Wireguard has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:LibreOffice
winget install TheDocumentFoundation.LibreOffice %wingetsilent% >nul 2>&1
%notify%'APP','LibreOffice has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Paintnet
winget install dotPDNLLC.paintdotnet %wingetsilent% >nul 2>&1
%notify%'APP','Paint.net has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu


:VlcPlayer
winget install VideoLAN.VLC %wingetsilent% >nul 2>&1
%notify%'APP','VLC Player has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:MSIAfterburner
ECHO [[93m-[0m] Downloading [93mMSI Afterburner[0m ...
%downloadfile%'https://ftp.nluug.nl/pub/games/PC/guru3d/afterburner/[Guru3D.com]-MSIAfterburnerSetup465Beta4Build16358.zip', '%desktop%\MSIAfterburner.zip')" >nul 2>&1
ECHO [[93m-[0m] Extracting [93mMSI Afterburner[0m ...
powershell -command "Expand-Archive -Force '%desktop%\MSIAfterburner.zip' '%desktop%'"
ECHO [[93m-[0m] Installing [93mMSI Afterburner[0m ...
"%desktop%\MSIAfterburnerSetup465Beta4.exe" /S
%notify%'APP','MSI Afterburner has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
del /f "%desktop%\MSIAfterburner.zip" >nul 2>&1
del /f "%desktop%\MSIAfterburnerSetup465Beta4.exe" >nul 2>&1
rmdir /S /Q "%desktop%\Guru3D.com" >nul 2>&1
move /y "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\MSI Afterburner\MSI Afterburner.lnk" "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs" >nul 2>&1
rmdir /S /Q "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\MSI Afterburner"
GOTO AppDLMenu

:NZXTCam
winget install NZXT.CAM %wingetsilent% >nul 2>&1
%notify%'APP','NZXT CAM has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:VSCode
winget install Microsoft.VisualStudioCode %wingetsilent% >nul 2>&1
%notify%'APP','VS Code has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Blender
winget install BlenderFoundation.Blender %wingetsilent% >nul 2>&1
%notify%'APP','Blender has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Hwinfo
winget install REALiX.HWiNFO %wingetsilent% >nul 2>&1
%notify%'APP','HWINFO has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Updates
%notify%'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
GOTO AppDLMenu

:Goback
GOTO Welcome

:: Note - More Applications Page
:More
mode con: cols=76 lines=20
Title Download Apps %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                   [7mApps[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO       [[1mA[0m] Opera GX           [[1mF[0m] Ubisoft Connect [[1mK[0m] GeForce Experience
ECHO       [[1mB[0m] Brave              [[1mG[0m] GIMP            [[1mL[0m] GeForce NOW
ECHO       [[1mC[0m] EA Desktop         [[1mH[0m] GPU-Z           [[1mM[0m] PostgreSQL
ECHO       [[1mD[0m] GOG Galaxy         [[1mI[0m] OneDrive        [[1mN[0m] Dropbox
ECHO       [[1mE[0m] Battle.Net         [[1mJ[0m] OBS Studio      [[1mO[0m] Teams
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO        [101m[X] Go back[0m   [100m[U] Search for Updates[0m   [100m[Q] More Apps[0m   [[93m2[0m/[96m7[0m]
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
winget install Opera.OperaGX %wingetsilent% >nul 2>&1
%notify%'APP','Opera GX has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:Brave
winget install Brave.Brave %wingetsilent% >nul 2>&1
%notify%'APP','Brave has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:EADesktop
winget install ElectronicArts.EADesktop %wingetsilent% >nul 2>&1
%notify%'APP','EA Desktop App has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:GOGGalaxy
winget install GOG.Galaxy %wingetsilent% >nul 2>&1
%notify%'APP','GOG Galaxy has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:BattleNet
%downloadfile%'https://www.battle.net/download/getInstallerForGame?os=win&gameProgram=BATTLENET_APP&version=Live&id=undefined', '%desktop%\Battle.net-Setup.exe')" >nul 2>&1
"%desktop%\Battle.net-Setup.exe" --lang=enUS --installpath="C:\Program Files (x86)\Battle.net"
%notify%'APP','Battle.net Launcher has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
del /f "%desktop%\Battle.net-Setup.exe" >nul 2>&1
GOTO More

:UbisoftConnect
winget install Ubisoft.Connect %wingetsilent% >nul 2>&1
%notify%'APP','Ubisoft Connect has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:GIMP 
winget install GIMP.GIMP %wingetsilent% >nul 2>&1
%notify%'APP','GIMP has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:GPUZ
winget install TechPowerUp.GPU-Z %wingetsilent% >nul 2>&1
%notify%'APP','GPU-Z has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:OneDrive
winget install  Microsoft.OneDrive %wingetsilent% >nul 2>&1
%notify%'APP','OneDrive has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:OBSStudio
winget install OBSProject.OBSStudio %wingetsilent% >nul 2>&1
%notify%'APP','OBS Studio has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:GeforceExperience
winget install Nvidia.GeForceExperience %wingetsilent% >nul 2>&1
%notify%'APP','Geforce Experience has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:GeforceNOW
ECHO [[93m-[0m] Downloading [93mGeforce Now[0m ...
%downloadfile%'https://download.nvidia.com/gfnpc/GeForceNOW-release.exe', '%desktop%\GeForceNOW-Setup.exe')" >nul 2>&1
%notify%'APP','Geforce Now has been downloaded. Please run the installer manually.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:PostgreSQL
winget install PostgreSQL.PostgreSQL %wingetsilent% >nul 2>&1
%notify%'APP','POSTgreSQL has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:Dropbox
winget install Dropbox.Dropbox %wingetsilent% >nul 2>&1
%notify%'APP','Dropbox has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:Teams
winget install Microsoft.Teams %wingetsilent% >nul 2>&1
%notify%'APP','Teams has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:Updates
%notify%'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
GOTO More

:GoBack
GOTO AppDLMenu

:More2
:: Note - More Applications Page 3
mode con: cols=76 lines=20
Title Download Apps %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                   [7mApps[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO       [[1mA[0m] Zoom               [[1mF[0m] Visual Studio      [[1mK[0m] Audacity
ECHO       [[1mB[0m] Sublime Text       [[1mG[0m] Radiograph         [[1mL[0m] Cinebench
ECHO       [[1mC[0m] Notepad ++         [[1mH[0m] qBittorrent        [[1mM[0m] iTunes
ECHO       [[1mD[0m] Corsair iCUE       [[1mI[0m] PicoTorrent        [[1mN[0m] Rufus
ECHO       [[1mE[0m] Firefox            [[1mJ[0m] Google Play Games  [[1mO[0m] Aida64
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO        [101m[X] Go back[0m   [100m[U] Search for Updates[0m   [100m[Q] More Apps[0m   [[93m3[0m/[96m7[0m]
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
winget install Zoom.Zoom %wingetsilent% >nul 2>&1
%notify%'APP','Zoom has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:SublimeText
winget install SublimeHQ.SublimeText.4 %wingetsilent% >nul 2>&1
%notify%'APP','Sublime Text has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Notepadplusplus
winget install Notepad++.Notepad++ %wingetsilent% >nul 2>&1
%notify%'APP','Notepad PlusPlus has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Corsairicue
winget install Corsair.iCUE.4 %wingetsilent% >nul 2>&1
%notify%'APP','Corsair iCUE has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Firefox
winget install Mozilla.Firefox %wingetsilent% >nul 2>&1
%notify%'APP','Firefox has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:VisualStudio
winget install Microsoft.VisualStudio.2022.Community %wingetsilent% >nul 2>&1
%notify%'APP','Visual Studio 2022 Community has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Radiograph
winget install 9NH1P86H06CG %wingetsilent% >nul 2>&1
%notify%'APP','Radiograph has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:qBittorrent
winget install qBittorrent.qBittorrent %wingetsilent% >nul 2>&1
%notify%'APP','qBittorrent has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Picotorrent
winget install PicoTorrent.PicoTorrent %wingetsilent% >nul 2>&1
%notify%'APP','Picotorrent has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:GooglePlayGames
winget install Google.PlayGames.Beta %wingetsilent% >nul 2>&1
%notify%'APP','Google Play Games has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Audacity
winget install Audacity.Audacity %wingetsilent% >nul 2>&1
%notify%'APP','Audacity has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Cinebench
winget install 9PGZKJC81Q7J %wingetsilent% >nul 2>&1
%notify%'APP','Cinebench has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:iTunes
winget install Apple.iTunes %wingetsilent% >nul 2>&1
%notify%'APP','iTunes has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Rufus
winget install Rufus.Rufus %wingetsilent% >nul 2>&1
%notify%'APP','Rufus has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Aida64
winget install FinalWire.AIDA64.Extreme %wingetsilent% >nul 2>&1
%notify%'APP','Aida64 has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Updates
%notify%'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
GOTO More2

:GoBack
GOTO More

:: Note - More Applications Page 4
:More3
mode con: cols=76 lines=20
Title Download Apps %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                   [7mApps[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO        [[1mA[0m] NordVPN              [[1mF[0m] Logitech G HUB     [[1mK[0m] Teamviewer
ECHO        [[1mB[0m] ExpressVPN           [[1mG[0m] VS Codium          [[1mL[0m] Parsec
ECHO        [[1mC[0m] Surfshark            [[1mH[0m] NVCleanstall       [[1mM[0m] Vivaldi
ECHO        [[1mD[0m] WinSCP               [[1mI[0m] BlueStacks         [[1mN[0m] Virtualbox
ECHO        [[1mE[0m] Windows Terminal     [[1mJ[0m] Powershell         [[1mO[0m] VM Ware
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO        [101m[X] Go back[0m   [100m[U] Search for Updates[0m   [100m[Q] More Apps[0m   [[93m4[0m/[96m7[0m]
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
winget install NordVPN.NordVPN %wingetsilent% >nul 2>&1
%notify%'APP','NordVPN has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:ExpressVPN
winget install ExpressVPN.ExpressVPN %wingetsilent% >nul 2>&1
%notify%'APP','ExpressVPN has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Surfshark
winget install Surfshark.Surfshark %wingetsilent% >nul 2>&1
%notify%'APP','Surfshark has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:WinSCP
winget install WinSCP.WinSCP %wingetsilent% >nul 2>&1
%notify%'APP','WinSCP has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:WindowsTerminal
winget install Microsoft.WindowsTerminal %wingetsilent% >nul 2>&1
%notify%'APP','Windows Terminal has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:LogitechGHUB
winget install Logitech.GHUB %wingetsilent% >nul 2>&1
%notify%'APP','Logitech G Hub has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:VSCodium
winget install VSCodium.VSCodium %wingetsilent% >nul 2>&1
%notify%'APP','VS Codium has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:NVCleanstall
winget install TechPowerUp.NVCleanstall %wingetsilent% >nul 2>&1
%notify%'APP','NVCleanstall has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:BlueStacks
winget install BlueStack.BlueStacks %wingetsilent% >nul 2>&1
%notify%'APP','Bluestacks has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Powershell
winget install Microsoft.PowerShell %wingetsilent% >nul 2>&1
%notify%'APP','Powershell has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Teamviewer
winget install TeamViewer.TeamViewer %wingetsilent% >nul 2>&1
%notify%'APP','Teamviewer has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Parsec
winget install Parsec.Parsec %wingetsilent% >nul 2>&1
%notify%'APP','Parsec has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Vivaldi
winget install VivaldiTechnologies.Vivaldi %wingetsilent% >nul 2>&1
%notify%'APP','Vivaldi has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Virtualbox
winget install Oracle.VirtualBox %wingetsilent% >nul 2>&1
%notify%'APP','Virtualbox has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:VMWare
winget install VMware.WorkstationPlayer %wingetsilent% >nul 2>&1
%notify%'APP','VMWare has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Updates
%notify%'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
GOTO More3

:GoBack
GOTO More2

:: Note - More Applications Page 5
:More4
mode con: cols=76 lines=20
Title Download Apps %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                   [7mApps[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO     [[1mA[0m] NVIDIA Sunshine   [[1mF[0m] Chrome Canary     [[1mK[0m] Adobe Acrobat Reader
ECHO     [[1mB[0m] Foobar2000        [[1mG[0m] Ungoogled Chromium[[1mL[0m] WhatsApp
ECHO     [[1mC[0m] CPU-Z             [[1mH[0m] Edge              [[1mM[0m] Telegram
ECHO     [[1mD[0m] Chrome Beta       [[1mI[0m] Edge Beta         [[1mN[0m] MS PC Manager
ECHO     [[1mE[0m] Chrome Dev        [[1mJ[0m] Edge Dev          [[1mO[0m] Winamp 
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO        [101m[X] Go back[0m   [100m[U] Search for Updates[0m   [100m[Q] More Apps[0m   [[93m5[0m/[96m7[0m]
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
winget install LizardByte.Sunshine %wingetsilent% >nul 2>&1
%notify%'APP','NVIDIA Sunshine has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:Foobar2000
winget install PeterPawlowski.foobar2000 %wingetsilent% >nul 2>&1
%notify%'APP','Foobar 2000 has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:CPUZ
winget install CPUID.CPU-Z %wingetsilent% >nul 2>&1
%notify%'APP','CPU-Z has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:ChromeBeta
winget install Google.Chrome.Beta %wingetsilent% >nul 2>&1
%notify%'APP','Google Chrome Beta has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:ChromeDev
winget install Google.Chrome.Dev %wingetsilent% >nul 2>&1
%notify%'APP','Google Chrome Dev has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:ChromeCanary
winget install Google.Chrome.Canary %wingetsilent% >nul 2>&1
%notify%'APP','Google Chrome Canary has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:UngoogledChromium
winget install eloston.ungoogled-chromium %wingetsilent% >nul 2>&1
%notify%'APP','Ungoogled Chromium has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:Edge
winget install Microsoft.Edge %wingetsilent% >nul 2>&1
%notify%'APP','Microsoft Edge has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:EdgeBeta
winget install Microsoft.Edge.Beta %wingetsilent% >nul 2>&1
%notify%'APP','Microsoft Edge Beta has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:EdgeDev
winget install Microsoft.Edge.Dev %wingetsilent% >nul 2>&1
%notify%'APP','Microsoft Edge Dev has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:AdobeAcrobatReader
winget install Adobe.Acrobat.Reader.64-bit %wingetsilent% >nul 2>&1
%notify%'APP','Adobe Acrobat Reader has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:WhatsApp
winget install WhatsApp.WhatsApp %wingetsilent% >nul 2>&1
%notify%'APP','WhatsApp has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:Telegram
winget install Telegram.TelegramDesktop %wingetsilent% >nul 2>&1
%notify%'APP','Telegram has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:MSPCManager
winget install Microsoft.PCManager %wingetsilent% >nul 2>&1
%notify%'APP','Microsoft PC Manager has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:Winamp
winget install Winamp.Winamp %wingetsilent% >nul 2>&1
%notify%'APP','WinAMP has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:Updates
%notify%'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
GOTO More4

:GoBack
GOTO More3

:: Note - More Applications Page 6
:More5
mode con: cols=76 lines=20
Title Download Apps %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                   [7mApps[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO            [[1mA[0m] Skype         [[1mF[0m] EarTrumpet    [[1mK[0m] Dolphin
ECHO            [[1mB[0m] Thunderbird   [[1mG[0m] Files         [[1mL[0m] ppsspp
ECHO            [[1mC[0m] Slack         [[1mH[0m] Google Drive  [[1mM[0m] rpcs3
ECHO            [[1mD[0m] ShareX        [[1mI[0m] WinRar        [[1mN[0m] Ryujinx
ECHO            [[1mE[0m] Lightshot     [[1mJ[0m] 7zip          [[1mO[0m] Apple Devices
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO        [101m[X] Go back[0m   [100m[U] Search for Updates[0m   [100m[Q] More Apps[0m   [[93m6[0m/[96m7[0m]
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
winget install Microsoft.Skype %wingetsilent% >nul 2>&1
%notify%'APP','Skype has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Thunderbird
winget install Mozilla.Thunderbird %wingetsilent% >nul 2>&1
%notify%'APP','Mozilla Thunderbird has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Slack
winget install SlackTechnologies.Slack %wingetsilent% >nul 2>&1
%notify%'APP','Slack has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:ShareX
winget install ShareX.ShareX %wingetsilent% >nul 2>&1
%notify%'APP','ShareX has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Lightshot
winget install Skillbrains.Lightshot %wingetsilent% >nul 2>&1
%notify%'APP','Lightshot has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Eartrumpet
winget install File-New-Project.EarTrumpet %wingetsilent% >nul 2>&1
%notify%'APP','Eartrumpet has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Files
winget install FilesCommunity.Files %wingetsilent% >nul 2>&1
%notify%'APP','Files has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:GoogleDrive
winget install Google.Drive %wingetsilent% >nul 2>&1
%notify%'APP','Google Drive has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:WinRar
winget install RARLab.WinRAR %wingetsilent% >nul 2>&1
%notify%'APP','WinRar has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:7zip
winget install 7zip.7zip %wingetsilent% >nul 2>&1
%notify%'APP','7Zip has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Dolphin
winget install DolphinEmulator.Dolphin %wingetsilent% >nul 2>&1
%notify%'APP','Dolphin Emulator has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:ppsspp
winget install PPSSPPTeam.PPSSPP %wingetsilent% >nul 2>&1
%notify%'APP','ppsspp Emulator has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:rpcs3
%downloadfile%'https://github.com/RPCS3/rpcs3-binaries-win/releases/download/build-39760189804d59315ab9f304d3cebddfb5d72f63/rpcs3-v0.0.26-14712-39760189_win64.7z', '%desktop%\rpcs3.7z')" >nul 2>&1
%notify%'APP','rpcs3 has been downloaded. Extract the 7zip file and run the installer manually.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Ryujinx
%downloadfile%'https://github.com/Ryujinx/release-channel-master/releases/download/1.1.617/ryujinx-1.1.617-win_x64.zip', '%desktop%\ryujinx.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\ryujinx.zip' '%desktop%\ryujinx'" >nul 2>&1
%notify%'APP','Ryujinx has been downloaded. Run the installer manually.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
del /f "%desktop%\ryujinx.zip" >nul 2>&1
GOTO More5

:AppleDevices
winget install 9NP83LWLPZ9K %wingetsilent% >nul 2>&1
%notify%'APP','Apple Devices has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Updates
%notify%'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
GOTO More5

:GoBack
GOTO More4

:: Note - More Applications Page 7
:More6
mode con: cols=76 lines=20
Title Download Apps %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                   [7mApps[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO          [[1mA[0m] Microsoft Store   [[1mF[0m] Xbox ID Provider  [[1mK[0m] Placeholder
ECHO          [[1mB[0m] MS Store Buy App  [[1mG[0m] Placeholder       [[1mL[0m] Placeholder
ECHO          [[1mC[0m] Snipping Tool     [[1mH[0m] Placeholder       [[1mM[0m] Placeholder
ECHO          [[1mD[0m] Notepad           [[1mI[0m] Placeholder       [[1mN[0m] Placeholder
ECHO          [[1mE[0m] Nanazip           [[1mJ[0m] Placeholder       [[1mO[0m] Placeholder
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO        [101m[X] Go back[0m   [100m[U] Search for Updates[0m                   [[93m7[0m/[96m7[0m]
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
%downloadfile%'%repository%/Apps/Microsoft_Store.Msixbundle', '%desktop%\Microsoft_Store.Msixbundle')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path '%desktop%\Microsoft_Store.Msixbundle'" >nul 2>&1
del /f "%desktop%\Microsoft_Store.Msixbundle" >nul 2>&1
%notify%'APP','Microsoft Store has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:MicrosoftStorePurchaseApp
%downloadfile%'%repository%/Apps/Microsoft_Store-PurchaseApp.Msixbundle', '%desktop%\Microsoft_Store-PurchaseApp.Msixbundle')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path '%desktop%\Microsoft_Store-PurchaseApp.Msixbundle'" >nul 2>&1
del /f "%desktop%\Microsoft_Store-PurchaseApp.Msixbundle" >nul 2>&1
%notify%'APP','Microsoft Store Purchase App has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:SnippingTool
winget install 9MZ95KL8MR0L %wingetsilent% >nul 2>&1
%notify%'APP','Snipping Tool has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:Notepad
winget install 9MSMLRH6LZF3 %wingetsilent% >nul 2>&1
%notify%'APP','Notepad has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:Nanazip
winget install M2Team.NanaZip %wingetsilent% >nul 2>&1
%notify%'APP','Nanazip has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:XboxIdentityProvider
%downloadfile%'%repository%/Apps/XboxIdentityProvider.appx', '%desktop%\XboxIdentityProvider.appx')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path '%desktop%\XboxIdentityProvider.appx'" >nul 2>&1
del /f "%desktop%\XboxIdentityProvider.appx" >nul 2>&1
%notify%'APP','Xbox Identity Provider has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:Placeholder
%notify%'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:Updates
%notify%'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
GOTO More6

:GoBack
GOTO More5

:: Note - Further Debloat Windows Page
:DebloatMenu
mode con: cols=76 lines=20
Title Debloat %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                              [7mDebloat[0m [101;93mExperimental[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO         [[1mA[0m] Remove preinstalled Apps      [[1mB[0m] Remove Microsoft Edge
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO      [101m[X] Go back[0m
CHOICE /C:abx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 3 GOTO GoBack
IF ERRORLEVEL 2 GOTO RemoveMicrosoftEdge
IF ERRORLEVEL 1 GOTO RemovePreinstalledApps

:RemovePreinstalledApps
"C:\Windows\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
powershell -command "Get-AppxPackage *family* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Teams* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.Getstarted* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.Paint* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.ZuneMusic* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WindowsStore* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WindowsNotepad* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.ScreenSketch* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WindowsTerminal* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.XboxIdentityProvider* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.HEIFImageExtension* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.HEVCVideoExtensions* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *microsoft.windowscommunicationsapps* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WindowsAlarms* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WebMediaExtensions* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.VP9VideoExtensions* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WebpImageExtension* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.Todos* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *MicrosoftCorporationII.QuickAssist* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.ZuneVideo* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.YourPhone* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.XboxSpeechToTextOverlay* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.XboxGamingOverlay* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.Xbox.TCUI* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WindowsSoundRecorder* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WindowsCamera* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WindowsCalculator* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.Windows.Photos* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.StorePurchaseApp* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.RawImageExtension* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.PowerAutomateDesktop* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.People* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.HEVCVideoExtension* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.GamingApp* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.BingWeather* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Clipchamp.Clipchamp* | Remove-AppxPackage" >nul 2>&1
%notify%'APP','All preinstalled programs have been removed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebloatMenu

:RemoveMicrosoftEdge
start cmd.exe @cmd /C "%ltscdir%\Scripts\Edge_Uninstall.cmd" >nul 2>&1
GOTO DebloatMenu

:GoBack
GOTO Welcome

:: Note - Settings Page
:SettingsMenu
mode con: cols=76 lines=22
Title Settings / Tweaks %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                   [7mSettings[0m 
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO       [[1mA[0m] Disable Windows Defender         [[1mM[0m] Disable Windows Update
ECHO       [[1mB[0m] Enable  Windows Defender         [[1mN[0m] Enable  Windows Update
ECHO       [[1mC[0m] Enable  Windows Dark Theme       [[1mO[0m] Enable  Education Themes
ECHO       [[1mD[0m] Enable  Windows Light Theme      [[1mP[0m] Disable Education Themes
ECHO       [[1mE[0m] Modernized classic context Menu  [[1mQ[0m] Enable  Internet Search
ECHO       [[1mF[0m] Back to Windows 11 Context Menu  [[1mR[0m] Disable Internet Serach
ECHO       [[1mG[0m] Placeholder                      [[1mS[0m] Left Taskbar
ECHO       [[1mH[0m] Placeholder                      [[1mT[0m] Centered Taskbar
ECHO       [[1mI[0m] Disable SmartScreen              [[1mU[0m] Disable Snap assist flyout
ECHO       [[1mJ[0m] Enable  SmartScreen              [[1mV[0m] Enable  Snap assist flyout
ECHO       [[1mK[0m] Disable Firewall                 [[1mY[0m] Disable startup sound
ECHO       [[1mL[0m] Enable  Firewall                 [[1mZ[0m] Enable  startup sound
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO          [101m[X] Go back[0m
CHOICE /C:abcdefghijklmnopqrstuvyzx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 25 GOTO GoBack
IF ERRORLEVEL 24 GOTO EnableStartupSound
IF ERRORLEVEL 23 GOTO DisableStartupSound
IF ERRORLEVEL 22 GOTO EnableSnapAssistFlyout
IF ERRORLEVEL 21 GOTO DisableSnapAssistFlyout
IF ERRORLEVEL 20 GOTO CenterTaskbar
IF ERRORLEVEL 19 GOTO LeftTaskbar
IF ERRORLEVEL 18 GOTO DisableWebSearch
IF ERRORLEVEL 17 GOTO EnableWebSearch
IF ERRORLEVEL 16 GOTO DisableEduThemes
IF ERRORLEVEL 15 GOTO EnableEduThemes
IF ERRORLEVEL 14 GOTO EnableWindowsUpdate
IF ERRORLEVEL 13 GOTO DisableWindowsUpdate
IF ERRORLEVEL 12 GOTO EnableFirewall
IF ERRORLEVEL 11 GOTO DisableFirewall
IF ERRORLEVEL 10 GOTO EnableSmartscreen
IF ERRORLEVEL 9 GOTO DisableSmartscreen
IF ERRORLEVEL 8 GOTO Placeholder
IF ERRORLEVEL 7 GOTO Placeholder
IF ERRORLEVEL 6 GOTO Windows11ContextMenu
IF ERRORLEVEL 5 GOTO ModernContextMenu
IF ERRORLEVEL 4 GOTO EnableLightMode
IF ERRORLEVEL 3 GOTO EnableDarkMode
IF ERRORLEVEL 2 GOTO EnableDefender
IF ERRORLEVEL 1 GOTO DisableDefender


:DisableDefender
%notify%'APP','Please go to Windows Security and turn off Tamper Protection. Press any Key to continue then.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
ECHO [[91m![0m] Press any Key to continue.
pause >nul 2>&1
start cmd.exe @cmd /C "%ltscdir%\Scripts\AntiDefender.cmd" >nul 2>&1
%notify%'APP','Windows Defender has been turned off.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu


:EnableDefender
start cmd.exe @cmd /C "%ltscdir%\Scripts\AntiDefenderUndo.cmd" >nul 2>&1
%notify%'APP','Windows Defender has been turned on.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableDarkMode
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V SystemUsesLightTheme /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V AppsUseLightTheme /T REG_DWORD /D 0 /F >nul 2>&1
taskkill /F /IM explorer.exe & start explorer >nul 2>&1
%notify%'APP','Windows is now using Dark Mode.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableLightMode
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V SystemUsesLightTheme /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V AppsUseLightTheme /T REG_DWORD /D 1 /F >nul 2>&1
taskkill /F /IM explorer.exe & start explorer >nul 2>&1
%notify%'APP','Windows is now using Light Mode.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:ModernContextMenu
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
winget install Nilesoft.Shell %wingetsilent% >nul 2>&1
%notify%'APP','Windows is now using a modern legacy context menu.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:Windows11ContextMenu
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
winget uninstall Nilesoft.Shell >nul 2>&1
%notify%'APP','Default Windows context menu has been restored.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:Placeholder
%notify%'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:Placeholder
%notify%'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisableSmartscreen
REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
%notify%'APP','Windows Smartscreen has been turned off.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableSmartscreen
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Warn" /f >nul 2>&1
%notify%'APP','Windows Smartscreen has been turned on.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisableFirewall
netsh advfirewall set allprofiles state off >nul 2>&1
%notify%'APP','Windows Firewall has been turned off.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableFirewall
netsh advfirewall set allprofiles state on >nul 2>&1
%notify%'APP','Windows Firewall has been turned on.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisableWindowsUpdate
Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "OptInOOBE" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v "AutoDownload" /t REG_DWORD /d "5" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-DeviceUpdateAgent/Operational" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-WindowsUpdateClient/Operational" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "HideMCTLink" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d " " /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d " " /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /t REG_SZ /d " " /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Services\wuauserv" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:quiethours;crossdevice;troubleshoot;project;remotedesktop;activation;multitasking;mobile-devices;pen;usb;autoplay;network-dialup;network-proxy;network-vpn;personalization-textinput;maps;appsforwebsites;sync;ms-settings;otherusers;speech;gaming-gamebar;gaming-gamedvr;gaming-gamemode;easeofaccess-eyecontrol;easeofaccess-narrator;easeofaccess-highcontrast;easeofaccess-magnifier;easeofaccess-cursor;easeofaccess-colorfilter;privacy-feedback;findmydevice;windowsdefender;privacy-speech;privacy-speechtyping;cortana-windowssearch;windowsupdate" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:quiethours;crossdevice;troubleshoot;project;remotedesktop;activation;multitasking;mobile-devices;pen;usb;autoplay;network-dialup;network-proxy;network-vpn;personalization-textinput;maps;appsforwebsites;sync;ms-settings;otherusers;speech;gaming-gamebar;gaming-gamedvr;gaming-gamemode;easeofaccess-eyecontrol;easeofaccess-narrator;easeofaccess-highcontrast;easeofaccess-magnifier;easeofaccess-cursor;easeofaccess-colorfilter;privacy-feedback;findmydevice;windowsdefender;privacy-speech;privacy-speechtyping;cortana-windowssearch;windowsupdate" /f >nul 2>&1
%notify%'APP','Windows Update has been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableWindowsUpdate
Reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "OptInOOBE" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v "AutoDownload" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-DeviceUpdateAgent/Operational" /v "Enabled" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-WindowsUpdateClient/Operational" /v "Enabled" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "HideMCTLink" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /f >nul 2>&1
Reg delete "HKLM\SYSTEM\ControlSet001\Services\wuauserv" /v "Start" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Services\wuauserv" /v "Start" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:quiethours;crossdevice;troubleshoot;project;remotedesktop;activation;multitasking;mobile-devices;pen;usb;autoplay;network-dialup;network-proxy;network-vpn;personalization-textinput;maps;appsforwebsites;sync;ms-settings;otherusers;speech;gaming-gamebar;gaming-gamedvr;gaming-gamemode;easeofaccess-eyecontrol;easeofaccess-narrator;easeofaccess-highcontrast;easeofaccess-magnifier;easeofaccess-cursor;easeofaccess-colorfilter;privacy-feedback;findmydevice;windowsdefender;privacy-speech;privacy-speechtyping;cortana-windowssearch" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:quiethours;crossdevice;troubleshoot;project;remotedesktop;activation;multitasking;mobile-devices;pen;usb;autoplay;network-dialup;network-proxy;network-vpn;personalization-textinput;maps;appsforwebsites;sync;ms-settings;otherusers;speech;gaming-gamebar;gaming-gamedvr;gaming-gamemode;easeofaccess-eyecontrol;easeofaccess-narrator;easeofaccess-highcontrast;easeofaccess-magnifier;easeofaccess-cursor;easeofaccess-colorfilter;privacy-feedback;findmydevice;windowsdefender;privacy-speech;privacy-speechtyping;cortana-windowssearch" /f >nul 2>&1
%notify%'APP','Windows Update has been enabled. You might need to restart Windows.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableEduThemes
REG add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Education" /v "EnableEduThemes" /t REG_DWORD /d "1" /f >nul 2>&1
%notify%'APP','Education themes have been enabled. Rebooting into Safeboot may display a hard error message which can be ignored.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisableEduThemes
REG add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Education" /v "EnableEduThemes" /t REG_DWORD /d "0" /f >nul 2>&1
%notify%'APP','Education themes have been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableWebSearch
taskkill /f /im explorer.exe >nul 2>&1
REG Add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /V DisableSearchBoxSuggestions /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V NoSearchInternetInStartMenu /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /V IsDynamicSearchBoxEnabled /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /V IsAADCloudSearchEnabled /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /V IsMSACloudSearchEnabled /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V AllowCloudSearch /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V AllowCortana /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V ConnectedSearchUseWeb /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V DisableWebSerach /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V EnableDynamicContentInWSB /T REG_DWORD /D 1 /F >nul 2>&1
timeout 1 >nul 2>&1
start explorer.exe >nul 2>&1
%notify%'APP','Web results for Search box have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisableWebSearch
taskkill /f /im explorer.exe >nul 2>&1
REG Add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /V DisableSearchBoxSuggestions /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V NoSearchInternetInStartMenu /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /V IsDynamicSearchBoxEnabled /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /V IsAADCloudSearchEnabled /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /V IsMSACloudSearchEnabled /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V AllowCloudSearch /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V AllowCortana /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V ConnectedSearchUseWeb /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V DisableWebSerach /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V EnableDynamicContentInWSB /T REG_DWORD /D 0 /F >nul 2>&1
timeout 1 >nul 2>&1
start explorer.exe >nul 2>&1
%notify%'APP','Web results for Search box have been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:LeftTaskbar
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V TaskbarAl /T REG_DWORD /D 0 /F >nul 2>&1
%notify%'APP','Taskbar alignment set to left.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:CenterTaskbar
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V TaskbarAl /T REG_DWORD /D 1 /F >nul 2>&1
%notify%'APP','Taskbar alignment set to center.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisableSnapAssistFlyout
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V EnableSnapAssistFlyout /T REG_DWORD /D 0 /F >nul 2>&1
%notify%'APP','Snap Assist Flyout has been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableSnapAssistFlyout
REG Add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V EnableSnapAssistFlyout /T REG_DWORD /D 1 /F >nul 2>&1
%notify%'APP','Snap Assist Flyout has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisableStartupSound
REG Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\EditionOverrides" /V UserSetting_DisableStartupSound /T REG_DWORD /D 1 /F >nul 2>&1
%notify%'APP','Windows startup sound has been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableStartupSound
REG Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\EditionOverrides" /V UserSetting_DisableStartupSound /T REG_DWORD /D 0 /F >nul 2>&1
%notify%'APP','Windows startup sound has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:GoBack
GOTO Welcome

:: Note - Drivers Menu Page
:DriversMenu
mode con: cols=76 lines=20
Title Install Drivers %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                    [7mDrivers[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO     [[1mA[0m] Chipset      [[1mB[0m] Graphics        [[1mC[0m] Audio      [[1mD[0m] Networking
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO      [101m[X] Go back[0m
CHOICE /C:abcdx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 5 GOTO Welcome
IF ERRORLEVEL 4 GOTO NetworkingMenu
IF ERRORLEVEL 3 GOTO AudioMenu
IF ERRORLEVEL 2 GOTO GraphicsMenu
IF ERRORLEVEL 1 GOTO ChipsetMenu

:: Note - Chipset Menu Page
:ChipsetMenu
mode con: cols=76 lines=20
Title Install Drivers: Chipset %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                    [7mChipset[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO             [[1mA[0m] [94mIntel[0m "Legacy" (1xx-5xx)    [[1mB[0m] [94mIntel[0m 6xx-7xx
ECHO             [[1mC[0m] [91mAMD[0m   "Legacy" (5xx-9xx)    [[1mD[0m] [91mAMD[0m 3xx-6xx/TR40
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO      [101m[X] Go back[0m
CHOICE /C:abcdx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 5 GOTO GoBack
IF ERRORLEVEL 4 GOTO AMDRyzen
IF ERRORLEVEL 3 GOTO AMDLegacy
IF ERRORLEVEL 2 GOTO Intel1213
IF ERRORLEVEL 1 GOTO IntelLegacy

:IntelLegacy
%downloadfile%'%repository%/Drivers/Chipset/Intel_Chipset_Legacy.exe', '%desktop%\Intel_Legacy_Chipset.exe')" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO ChipsetMenu

:Intel1213
%downloadfile%'%repository%/Drivers/Chipset/Intel_Chipset.exe', '%desktop%\Intel_Chipset.exe')" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO ChipsetMenu

:AMDLegacy
%downloadfile%'%repository%/Drivers/Chipset/AMD_Chipset_Legacy.exe', '%desktop%\AMD_Legacy_Chipset.exe')" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO ChipsetMenu

:AMDRyzen
%downloadfile%'%repository%/Drivers/Chipset/AMD_Chipset.exe', '%desktop%\AMD_Chipset.exe')" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO ChipsetMenu

:GoBack
GOTO DriversMenu

:: Note - Graphics Menu Page
:GraphicsMenu
mode con: cols=76 lines=20
Title Install Drivers: Graphics %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                   [7mGraphics[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO   [[1mA[0m] [92mNvidia[0m GeForce 900-4000 Series        [[1mE[0m] [91mAMD[0m Radeon 400-7000 Series
ECHO   [[1mB[0m] [92mNvidia[0m GeForce 600-700  Series        [[1mF[0m] [94mIntel[0m Arc
ECHO   [[1mC[0m] [92mNvidia[0m GeForce 400-500  Series        [[1mG[0m] [94mIntel[0m iGPU
ECHO   [[1mD[0m] [92mNvidia[0m GeForce 100-300  Series        
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO      [101m[X] Go back[0m
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
ECHO [[93m-[0m] Downloading [93mNVIDIA drivers for 900-4000 series[0m ...
%downloadfile%'https://international.download.nvidia.com/Windows/531.26hf/531.26-desktop-notebook-win10-win11-64bit-international-dch.hf.exe', '%desktop%\NVIDIA.exe')" >nul 2>&1
ECHO [[92m+[0m] Done.
timeout 3 >nul 2>&1
GOTO GraphicsMenu

:NvidiaGeforce2
%downloadfile%'https://international.download.nvidia.com/Windows/474.14/474.14-desktop-win10-win11-64bit-international-dch-whql.exe', '%desktop%\NVIDIA.exe')" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO GraphicsMenu

:NvidiaGeforce3
%downloadfile%'https://international.download.nvidia.com/Windows/391.35/391.35-desktop-win10-64bit-international-whql.exe', '%desktop%\NVIDIA.exe')" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO GraphicsMenu

:NvidiaGeforce4
%downloadfile%'https://international.download.nvidia.com/Windows/342.01/342.01-desktop-win10-64bit-international.exe', '%desktop%\NVIDIA.exe')" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO GraphicsMenu

:AMDRadeon4007000
%downloadfile%'https://www.mediafire.com/file_premium/ywvzw2aaojrxpjd/whql-amd-software-adrenalin-edition-23.3.1-win10-win11-mar7-VideoCardz.exe', '%desktop%\AMD_Radeon.exe')" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO GraphicsMenu

:IntelArc
%downloadfile%'https://downloadmirror.intel.com/772016/gfx_win_101.4146.exe', '%desktop%\Intel_ARC.exe')" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO GraphicsMenu

:InteliGPU
%downloadfile%'https://downloadmirror.intel.com/751359/gfx_win_101.3790_101.2114.zip', '%desktop%\Intel_iGPU.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Intel_iGPU.zip' '%desktop%\InteliGPU'" >nul 2>&1
del /f "%desktop%\Intel_iGPU.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO GraphicsMenu

:GoBack
GOTO DriversMenu

:: Note - Audio Menu Page
:AudioMenu
mode con: cols=76 lines=20
Title Install Drivers: Audio %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                    [7mAudio[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO          [[1mA[0m] [34mRealtek[0m Audio (ASUS)         [[1mB[0m] [34mRealtek[0m Audio (MSI)
ECHO          [[1mC[0m] [34mRealtek[0m Audio (GigaByte)     [[1mD[0m] [34mRealtek[0m Audio (Asrock)
ECHO          [[1mE[0m] [34mRealtek[0m Audio (EVGA)         [[1mF[0m] [34mRealtek[0m Audio (Dell)
ECHO          [[1mG[0m] [34mRealtek[0m Audio (Lenovo)       [[1mH[0m] [34mRealtek[0m Audio (HP)
ECHO.
ECHO          [[1mI[0m] [34mRealtek[0m Audio (Others, right click install .inf file)
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO      [101m[X] Go back[0m
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
%downloadfile%'%repository%/Drivers/Audio/Audio_Realtek_ASUS.zip', '%desktop%\Audio_Realtek_ASUS.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Audio_Realtek_ASUS.zip' '%desktop%\Audio_Realtek_ASUS'" >nul 2>&1
del /f "%desktop%\Audio_Realtek_ASUS.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekMSI
%downloadfile%'%repository%/Drivers/Audio/Audio_Realtek_MSI.zip', '%desktop%\Audio_Realtek_MSI.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Audio_Realtek_MSI.zip' '%desktop%\Audio_Realtek_MSI'" >nul 2>&1
del /f "%desktop%\Audio_Realtek_MSI.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekGigaByte
%downloadfile%'%repository%/Drivers/Audio/Audio_Realtek_Gigabyte.zip', '%desktop%\Audio_Realtek_Gigabyte.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Audio_Realtek_Gigabyte.zip' '%desktop%\Audio_Realtek_GigaByte'" >nul 2>&1
del /f "%desktop%\Audio_Realtek_Gigabyte.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekAsrock
%downloadfile%'%repository%/Drivers/Audio/Audio_Realtek_Asrock.zip', '%desktop%\Audio_Realtek_Asrock.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Audio_Realtek_Asrock.zip' '%desktop%\Audio_Realtek_Asrock'" >nul 2>&1
del /f "%desktop%\Audio_Realtek_Asrock.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekEVGA
%downloadfile%'https://cdn.evga.com/driver/Z690/E698/Audio.zip', '%desktop%\Audio_Realtek_EVGA.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Audio_Realtek_EVGA.zip' '%desktop%\Audio_Realtek_EVGA'" >nul 2>&1
del /f "%desktop%\Audio_Realtek_EVGA.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekDell
%downloadfile%'%repository%/Drivers/Audio/Audio_Realtek_Dell.zip', '%desktop%\Audio_Realtek_Dell.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Audio_Realtek_Dell.zip' '%desktop%\Audio_Realtek_Dell'" >nul 2>&1
del /f "%desktop%\Audio_Realtek_Dell.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekLenovo
%downloadfile%'%repository%/Drivers/Audio/Audio_Realtek_Lenovo.exe', '%desktop%\Audio_Realtek_Lenovo.exe')" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekHP
%downloadfile%'%repository%/Drivers/Audio/Audio_Realtek_HP.zip', '%desktop%\Audio_Realtek_HP.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Audio_Realtek_HP.zip' '%desktop%\Audio_Realtek_HP'" >nul 2>&1
del /f "%desktop%\Audio_Realtek_HP.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekAllOEM
%downloadfile%'%repository%/Drivers/Audio/Audio_Realtek_Others.zip', '%desktop%\Audio_Realtek_Others.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Audio_Realtek_Others.zip' '%desktop%\Audio_Realtek_Others'" >nul 2>&1
del /f "%desktop%\Audio_Realtek_Others.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:GoBack
GOTO DriversMenu

:NetworkingMenu
:: Note - Netowrking Menu Page
mode con: cols=76 lines=20
Title Install Drivers: Network %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                 [7mNetworking[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
@echo   [[1mA[0m] [94mIntel[0m Ethernet     [[1mB[0m] [34mRealtek[0m Ethernet  [[1mC[0m] [91mAMD/Mediatek[0m Ethernet
@echo   [[1mD[0m] [94mIntel[0m Wifi         [[1mE[0m] [34mRealtek[0m Wifi      [[1mF[0m] [91mAMD/Mediatek[0m Wifi
@echo   [[1mG[0m] [94mIntel[0m Bluetooth    [[1mH[0m] [34mRealtek[0m Bluetooth [[1mI[0m] [91mAMD/Mediatek[0m Bluetooth
ECHO.
@echo   [[1mJ[0m] Qualcomm Ethernet  [[1mK[0m] Marvell Ethernet  [[1mL[0m] Broadcom Ethernet
@echo   [[1mM[0m] Qualcomm Wifi      [[1mN[0m] Marvell Wifi      [[1mO[0m] Broadcom Wifi
@echo   [[1mP[0m] Qualcomm Bluetooth [[1mQ[0m] Marvell Bluetooth [[1mR[0m] Broadcom Bluetooth
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO      [101m[X] Go back[0m
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
%downloadfile%'%repository%/Drivers/Networking/Intel_Ethernet.zip', '%desktop%\Intel_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Intel_Ethernet.zip' '%desktop%\Intel_Ethernet'" >nul 2>&1
del /f "%desktop%\Intel_Ethernet.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:RealtekEthernet
%downloadfile%'%repository%/Drivers/Networking/Realtek_Ethernet.zip', '%desktop%\Realtek_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Realtek_Ethernet.zip' '%desktop%\Realtek_Ethernet'" >nul 2>&1
del /f "%desktop%\Realtek_Ethernet.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MediatekEthernet
%downloadfile%'%repository%/Drivers/Networking/Mediatek_Ethernet.zip', '%desktop%\Mediatek_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Mediatek_Ethernet.zip' '%desktop%\Mediatek_Ethernet'" >nul 2>&1
del /f "%desktop%\Mediatek_Ethernet.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:IntelWifi
%downloadfile%'%repository%/Drivers/Networking/Intel_Wifi.zip', '%desktop%\Intel_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Intel_Wifi.zip' '%desktop%}Intel_Wifi'" >nul 2>&1
del /f "%desktop%\Intel_Wifi.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:RealtekWifi
%downloadfile%'%repository%/Drivers/Networking/Realtek_Wifi.zip', '%desktop%\Realtek_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Realtek_Wifi.zip' '%desktop%\Realtek_Wifi'" >nul 2>&1
del /f "%desktop%\Realtek_Wifi.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MediatekWifi
%downloadfile%'%repository%/Drivers/Networking/Mediatek_Wifi.zip', '%desktop%\Mediatek_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Mediatek_Wifi.zip' '%desktop%\Mediatek_Wifi'" >nul 2>&1
del /f "%desktop%\Mediatek_Wifi.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:IntelBluetooth
%downloadfile%'%repository%/Drivers/Networking/Intel_Bluetooth.zip', '%desktop%\Intel_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Intel_Bluetooth.zip' '%desktop%\Intel_Bluetooth'" >nul 2>&1
del /f "%desktop%\Intel_Bluetooth.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:RealtekBluetooth
%downloadfile%'%repository%/Drivers/Networking/Realtek_Bluetooth.zip', '%desktop%\Realtek_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Realtek_Bluetooth.zip' '%desktop%\Realtek_Bluetooth'" >nul 2>&1
del /f "%desktop%\Realtek_Bluetooth.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MediatekBluetooth
%downloadfile%'%repository%/Drivers/Networking/Mediatek_Bluetooth.zip', '%desktop%\Mediatek_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Mediatek_Bluetooth.zip' '%desktop%\Mediatek_Bluetooth'" >nul 2>&1
del /f "%desktop%\Mediatek_Bluetooth.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:QualcommEthernet
%downloadfile%'%repository%/Drivers/Networking/Qualcomm_Ethernet.zip', '%desktop%\Qualcomm_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Qualcomm_Ethernet.zip' '%desktop%\Qualcomm_Ethernet'" >nul 2>&1
del /f "%desktop%\Qualcomm_Ethernet.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MarvellEthernet
%downloadfile%'%repository%/Drivers/Networking/Marvell_Ethernet.zip', '%desktop%\Marvell_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Marvell_Ethernet.zip' '%desktop%\Marvell_Ethernet'" >nul 2>&1
del /f "%desktop%\Marvell_Ethernet.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:BroadcomEthernet
%downloadfile%'%repository%/Drivers/Networking/Broadcom_Ethernet.zip', '%desktop%\Broadcom_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Broadcom_Ethernet.zip' '%desktop%\Broadcam_Ethernet'" >nul 2>&1
del /f "%desktop%\Broadcom_Ethernet.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:QualcommWifi
%downloadfile%'%repository%/Drivers/Networking/Qualcomm_Wifi.zip', '%desktop%\Qualcomm_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Qualcomm_Wifi.zip' '%desktop%\Qualcomm_Wifi'" >nul 2>&1
del /f "%desktop%\Qualcomm_Wifi.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MarvellWifi
%downloadfile%'%repository%/Drivers/Networking/Marvell_Wifi.zip', '%desktop%\Marvell_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Marvell_Wifi.zip' '%desktop%\Marvell_Wifi'" >nul 2>&1
del /f "%desktop%\Marvell_Wifi.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:BroadcomWifi
%downloadfile%'%repository%/Drivers/Networking/Broadcom_Wifi.zip', '%desktop%\Broadcom_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Broadcom_Wifi.zip' '%desktop%\Broadcom_Wifi'" >nul 2>&1
del /f "%desktop%\Broadcom_Wifi.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:QualcommBluetooth
%downloadfile%'%repository%/Drivers/Networking/Qualcomm_Bluetooth.zip', '%desktop%\Qualcomm_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Qualcomm_Bluetooth.zip' '%desktop%\Qualcomm_Bluetooth'" >nul 2>&1
del /f "%desktop%\Qualcomm_Bluetooth.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MarvellBluetooth
%downloadfile%'%repository%/Drivers/Networking/Marvell_Bluetooth.zip', '%desktop%\Marvell_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Marvell_Bluetooth.zip' '%desktop%\Marvell_Bluetooth'" >nul 2>&1
del /f "%desktop%\Marvell_Bluetooth.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:BroadcomBluetooth
%downloadfile%'%repository%/Drivers/Networking/Broadcom_Bluetooth.zip', '%desktop%\Broadcom_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force '%desktop%\Broadcom_Bluetooth.zip' '%desktop%\Broadcom_Bluetooth'" >nul 2>&1
del /f "%desktop%\Broadcom_Bluetooth.zip" >nul 2>&1
%notify%'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:GoBack
GOTO DriversMenu

:DebugMenu
mode con: cols=76 lines=20
Title Debug Menu %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                     [7mDebug[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO [[1mA[0m] Repair Windows     [[1mB[0m] Repair Windows (.WIM)   [[1mC[0m] Clean Temp Files
ECHO [[1mD[0m] Update hosts file  [[1mE[0m] Windows activation      [[1mF[0m] Update APP / Scripts
ECHO [[1mG[0m] Rebuild Icon Cache [[1mH[0m] Flush DNS Cache         [[1mI[0m] Clear Thumbnail cache
ECHO [[1mJ[0m] Repair MS Store    [[1mK[0m] Enable builtin Admin    [[1mL[0m] Disable builtin Admin
ECHO.[[1mM[0m] Disable TPM Checks [[1mN[0m] Disable Modern Standby  [[1mO[0m] Reapply LTSC scripts
ECHO.[[1mP[0m] Update Win Security[[1mQ[0m] Placeholder             [[1mR[0m] Placeholder
ECHO.
@ECHO                          [42m[S]LTSC Insider Features[0m
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO          [101m[X] Go back[0m   [100m[Y] Restart Windows[0m   [100m[Z] Restart into BIOS[0m
CHOICE /C:abcdefghijklmnopqrsxyz /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 22 GOTO RestartBIOS
IF ERRORLEVEL 21 GOTO RestartWindows
IF ERRORLEVEL 20 GOTO GoBack
IF ERRORLEVEL 19 GOTO InsiderFeaturesMenu
IF ERRORLEVEL 18 GOTO Placeholder
IF ERRORLEVEL 17 GOTO Placeholder
IF ERRORLEVEL 16 GOTO UpdateWinSecurity
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
IF ERRORLEVEL 5 GOTO WindowsActivation
IF ERRORLEVEL 4 GOTO UpdateHostsFile
IF ERRORLEVEL 3 GOTO CleanTemp
IF ERRORLEVEL 2 GOTO RepairWindowsAdvanced
IF ERRORLEVEL 1 GOTO RepairWindows

:RepairWindows
ECHO [[93m-[0m] Trying to [93mrepair Windows[0m ...
SFC /Scannow >nul 2>&1
DISM /Online /Cleanup-Image /CheckHealth >nul 2>&1
DISM /Online /Cleanup-Image /ScanHealth >nul 2>&1
DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1
%notify%'APP','Repair finished. Please restart Windows.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:RepairWindowsAdvanced
%notify%'APP','Please move the install.wim to %ltscdir%\AdditionalFiles\RepairWin and press any Key to continue.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
ECHO [[91m![0m] Press any key to continue.
pause >nul 2>&1
SFC /Scannow >nul 2>&1
DISM /Online /Cleanup-Image /CheckHealth >nul 2>&1
DISM /Online /Cleanup-Image /ScanHealth >nul 2>&1
DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1
DISM /Online /Cleanup-Image /RestoreHealth /Source:"%ltscdir%\AdditionalFiles\RepairWin\install.wim"
%notify%'APP','Repair finished. Please restart Windows.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:CleanTemp
start cmd.exe @cmd /C "%ltscdir%\Scripts\CleanFiles.cmd" >nul 2>&1
GOTO DebugMenu

:UpdateHostsFile
%downloadfile%'%repository%/LTSC/hosts', 'C:\Windows\System32\drivers\etc\hosts')" >nul 2>&1
%notify%'APP','Hosts file has been updated.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:WindowsActivation
start cmd.exe @cmd /C "%ltscdir%\Scripts\activate.cmd" >nul 2>&1
GOTO DebugMenu

:UpdateAPP
%downloadfile%'%repository%/LTSC/setup.cmd', '%ltscdir%\setup.cmd')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/activate.cmd', '%ltscdir%\Scripts\activate.cmd')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/AntiDefender.cmd', '%ltscdir%\Scripts\AntiDefender.cmd')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/AntiDefenderUndo.cmd', '%ltscdir%\Scripts\AntiDefenderUndo.cmd')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/CleanFiles.cmd', '%ltscdir%\Scripts\CleanFiles.cmd')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/Edge_Uninstall.cmd', '%ltscdir%\Scripts\Edge_Uninstall.cmd')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/reapplyLTSC.cmd', '%ltscdir%\Scripts\reapplyLTSC.cmd')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/tweaks.reg', '%ltscdir%\Scripts\tweaks.reg')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/UpdateAPP.cmd', '%ltscdir%\Scripts\UpdateAPP.cmd')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/ViveTool/Albacore.ViVe.dll', '%ltscdir%\Scripts\ViveTool\Albacore.ViVe.dll')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/ViveTool/FeatureDictionary.pfs', '%ltscdir%\Scripts\ViveTool\FeatureDictionary.pfs')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/ViveTool/Newtonsoft.Json.dll', '%ltscdir%\Scripts\ViveTool\Newtonsoft.Json.dll')" >nul 2>&1
%downloadfile%'%repository%/LTSC/Scripts/ViveTool/ViVeTool.exe', '%ltscdir%\Scripts\ViveTool\ViVeTool.exe')" >nul 2>&1
start cmd.exe @cmd /C "%ltscdir%\Scripts\UpdateAPP.cmd" >nul 2>&1
exit

:RebuildIconCache
ie4uinit.exe -show >nul 2>&1
taskkill /IM explorer.exe /F >nul 2>&1
DEL /A /Q "%localappdata%\IconCache.db" >nul 2>&1
DEL /A /F /Q "%localappdata%\Microsoft\Windows\Explorer\iconcache*" >nul 2>&1
start explorer.exe
%notify%'APP','Icon cache has been rebuilt. Please restart Windows.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:FlushDNS
ipconfig /flushdns >nul 2>&1
%notify%'APP','DNS resolver cache has been flushed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:ClearThumbnailCache
taskkill /f /im explorer.exe >nul 2>&1
timeout 2 >nul 2>&1
DEL /F /S /Q /A "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
timeout 2 >nul 2>&1
start explorer.exe >nul 2>&1
%notify%'APP','Thumbnail cache has been cleared.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:RepairMSStore
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage -AllUsers 'WindowsStore' | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppXManifest.xml'}" >nul 2>&1
%notify%'APP','Microsoft Store has been repaired.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:EnableBuiltinAdmin
net user Administrator /active:yes >nul 2>&1
%notify%'APP','Built-In Administrator Account has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:DisableBuiltinAdmin
net user Administrator /active:no >nul 2>&1
%notify%'APP','Built-In Administrator Account has been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:DisableChecks
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vdsldr.exe" /f >nul 2>&1
wmic /namespace:"\\root\subscription" path __EventFilter where Name="Skip TPM Check on Dynamic Update" delete >nul 2>&1
REG Add "HKLM\SYSTEM\Setup\MoSetup" /V AllowUpgradesWithUnsupportedTPMOrCPU /T REG_DWORD /D 1 /F >nul 2>&1
%notify%'APP','Hardware compatibility checks have been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:DisableModernStandby
POWERCFG -SETDCVALUEINDEX SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 >nul 2>&1
POWERCFG -SETACVALUEINDEX SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 >nul 2>&1
%notify%'APP','Modern Standby connectivity has been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:ReapplyLTSC
%notify%'Warning','Reapplying LTSC changes will delete Edge, all inbox apps and more. If you want to continue, press any key in APP or close it.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
ECHO [[91m![0m] Press any Key to continue.
pause >nul 2>&1
start cmd.exe @cmd /C "%ltscdir%\Scripts\reapplyLTSC.cmd" >nul 2>&1
GOTO DebugMenu

:UpdateWinSecurity
cd C:\ProgramData\Microsoft\Windows Defender\Platform\4.18* >nul 2>&1
MpCmdRun -SignatureUpdate >nul 2>&1
%notify%'APP','Windows Security has been updated.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:Placeholder
%notify%'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:Placeholder
%notify%'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:GoBack
GOTO Welcome

:RestartWindows
%notify%'APP','Windows will restart shortly.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
shutdown /r /f /t 05 >nul 2>&1

:RestartBIOS
%notify%'APP','Your PC will restart into UEFI/BIOS shortly.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
shutdown /r /fw /t 05 >nul 2>&1

:InsiderFeaturesMenu
mode con: cols=76 lines=20
Title Insider Features %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                [7mInsider Features[0m
@ECHO                  Only use this Menu if you're on LTSC-Insider.
@ECHO                  You might have to restart Windows afterwards.
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO   [[1mA[0m] Win/AppServices Privacy [[1mB[0m] New Volume Mixer [[1mC[0m] New Nearby Sharing
ECHO   [[1mD[0m] Custom color Search box [[1mE[0m] Remove Add Device[[1mF[0m] Show tips and more
ECHO   [[1mG[0m] ReFS Dev Volumes        [[1mH[0m] New Spotlight UI [[1mI[0m] New Snap Assist UI
ECHO   [[1mJ[0m] Touch Keyboard Drop Menu[[1mK[0m] Auto Color Mngmnt[[1mL[0m] Start Acc Badge
ECHO   [[1mM[0m] WinAppSDK File Explorer [[1mN[0m] Uninstall Apps ..[[1mO[0m] KB layout settings
ECHO   [[1mP[0m] Emoji 15 support        [[1mW[0m] End Task option  [[1mR[0m] Widgets no Account
ECHO   [[1mS[0m] Ambient Device Lighting [[1mT[0m] New Setting UIs  [[1mU[0m] Suggested Actions
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO          [101m[X] Go back[0m   [100m[Q] Next Page[0m                         [[93m1[0m/[96m2[0m]
CHOICE /C:abcdefghijklmnopwrstuxq /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 23 GOTO FeaturesPage2
IF ERRORLEVEL 22 GOTO GoBack
IF ERRORLEVEL 21 GOTO Feature21
IF ERRORLEVEL 20 GOTO Feature20
IF ERRORLEVEL 19 GOTO Feature19
IF ERRORLEVEL 18 GOTO Feature18
IF ERRORLEVEL 17 GOTO Feature17
IF ERRORLEVEL 16 GOTO Feature16
IF ERRORLEVEL 15 GOTO Feature15
IF ERRORLEVEL 14 GOTO Feature14
IF ERRORLEVEL 13 GOTO Feature13
IF ERRORLEVEL 12 GOTO Feature12
IF ERRORLEVEL 11 GOTO Feature11
IF ERRORLEVEL 10 GOTO Feature10
IF ERRORLEVEL 9 GOTO Feature9
IF ERRORLEVEL 8 GOTO Feature8
IF ERRORLEVEL 7 GOTO Feature7
IF ERRORLEVEL 6 GOTO Feature6
IF ERRORLEVEL 5 GOTO Feature5
IF ERRORLEVEL 4 GOTO Feature4
IF ERRORLEVEL 3 GOTO Feature3
IF ERRORLEVEL 2 GOTO Feature2
IF ERRORLEVEL 1 GOTO Feature1

:Feature1
%vivetool% /enable /id:41736838 >nul 2>&1
%vivetool% /enable /id:42057226 >nul 2>&1
%notify%'APP','Windows and App services microphone privacy setting has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature2
%vivetool% /enable /id:42106010 >nul 2>&1
%notify%'APP','New Volume Mixer has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature3
%vivetool% /enable /id:38890980 >nul 2>&1
%notify%'APP','Nearby Sharing UX improvements have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature4
%vivetool% /enable /id:42922989 >nul 2>&1
%notify%'APP','Custom color search box has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature5
%vivetool% /enable /id:41734715 >nul 2>&1
%notify%'APP','Remove Add Device Button if your PC doesnt have Bluetooth has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature6
%vivetool% /enable /id:42916428 >nul 2>&1
%notify%'APP','Show recommendations for tips, shortcuts, new apps and more has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature7
%vivetool% /enable /id:40347509 >nul 2>&1
%notify%'APP','ReFS Developer Volumes have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature8
%vivetool% /enable /id:39880030 >nul 2>&1
%vivetool% /enable /id:40268500 >nul 2>&1
%vivetool% /enable /id:40522394 >nul 2>&1
%vivetool% /enable /id:41744267 >nul 2>&1
%notify%'APP','New Spotlight UIs have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature9
%vivetool% /enable /id:40851068 >nul 2>&1
%notify%'APP','New Snap Assist Layout has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature10
%vivetool% /enable /id:37007953 >nul 2>&1
%notify%'APP','Touch keyboard dropdown menu has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature11
%vivetool% /enable /id:36371531 >nul 2>&1
%notify%'APP','Auto Color Management has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature12
%vivetool% /enable /id:36435151 /variant:1 /variantpayloadkind:1 /variantpayload:1121 >nul 2>&1
%notify%'APP','Start Menu Account badge has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature13
%vivetool% /enable /id:40729001 >nul 2>&1
%vivetool% /enable /id:40731912 >nul 2>&1
%vivetool% /enable /id:41969252 >nul 2>&1
%vivetool% /enable /id:42922424 >nul 2>&1
%vivetool% /enable /id:41040327 >nul 2>&1
%vivetool% /enable /id:42295138 >nul 2>&1
%vivetool% /enable /id:39661369 >nul 2>&1
%vivetool% /enable /id:38613007 >nul 2>&1
%notify%'APP','WinAppSDK File Explorer has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature14
%vivetool% /enable /id:38579715 >nul 2>&1
%notify%'APP','The ability to uninstall apps which have interdependencies has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature15
%vivetool% /enable /id:38612934 >nul 2>&1
%vivetool% /enable /id:34912776 >nul 2>&1
%vivetool% /enable /id:40618079 >nul 2>&1
%notify%'APP','New Keyboard Layout Settings UX has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature16
%vivetool% /enable /id:40213648 >nul 2>&1
%notify%'APP','Emoji 15 support has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature17
%vivetool% /enable /id:42592269 >nul 2>&1
%notify%'APP','End Task Option has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature18
%vivetool% /enable /id:41561445 >nul 2>&1
%vivetool% /enable /id:41561454 >nul 2>&1
%notify%'APP','Widgets no Account mandatory has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature19
%vivetool% /enable /id:35262205 >nul 2>&1
%vivetool% /enable /id:41355275 >nul 2>&1
%notify%'APP','Ambient Device Lighting has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature20
%vivetool% /enable /id:36390579 >nul 2>&1
%vivetool% /enable /id:42739793 >nul 2>&1
%vivetool% /enable /id:42733866 >nul 2>&1
%vivetool% /enable /id:41670003 >nul 2>&1
%vivetool% /enable /id:41598133 >nul 2>&1
%vivetool% /enable /id:38228963 >nul 2>&1
%vivetool% /enable /id:39811196 >nul 2>&1
%vivetool% /enable /id:40112637 >nul 2>&1
%notify%'APP','New Settings UIs have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:Feature21
%vivetool% /enable /id:41058795 >nul 2>&1
%vivetool% /enable /id:41539325 >nul 2>&1
%vivetool% /enable /id:42623125 >nul 2>&1
%vivetool% /enable /id:41424794 >nul 2>&1
%notify%'APP','Suggested actions have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO InsiderFeaturesMenu

:GoBack
GOTO DebugMenu

:FeaturesPage2
mode con: cols=76 lines=20
Title Insider Features %version%
@ECHO OFF
CLS
@ECHO.
@ECHO                                [7mInsider Features[0m
@ECHO                  Only use this Menu if you're on LTSC-Insider.
@ECHO                  You might have to restart Windows afterwards.
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO   [[1mA[0m] For You Start Menu      [[1mB[0m] Multi Lang CCs   [[1mC[0m] Inplace Upgrade
ECHO   [[1mD[0m] Live Kernel Dump        [[1mE[0m] Cloud Storage UI [[1mF[0m] New Search Box
ECHO   [[1mG[0m] Stickers drawing        [[1mH[0m] VPN indicator    [[1mI[0m] Trade/Recycle PC
ECHO   [[1mJ[0m] Desktop Search Box      [[1mK[0m] Taskbar Seconds  [[1mL[0m] Anim. Settgs Icons
ECHO   [[1mM[0m] Explorer recommendations[[1mN[0m] USB4 doamin viewr[[1mO[0m] Access Keys
ECHO   [[1mP[0m] Placeholder             [[1mQ[0m] Placeholder      [[1mR[0m] Placeholder
ECHO   [[1mS[0m] Placeholder             [[1mT[0m] Placeholder      [[1mU[0m] Placeholders
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO          [101m[X] Go back[0m                                         [[93m2[0m/[96m2[0m]
CHOICE /C:abcdefghijklmnopqrstux /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 22 GOTO GoBack
IF ERRORLEVEL 21 GOTO Feature42
IF ERRORLEVEL 20 GOTO Feature41
IF ERRORLEVEL 19 GOTO Feature40
IF ERRORLEVEL 18 GOTO Feature39
IF ERRORLEVEL 17 GOTO Feature38
IF ERRORLEVEL 16 GOTO Feature37
IF ERRORLEVEL 15 GOTO Feature36
IF ERRORLEVEL 14 GOTO Feature35
IF ERRORLEVEL 13 GOTO Feature34
IF ERRORLEVEL 12 GOTO Feature33
IF ERRORLEVEL 11 GOTO Feature32
IF ERRORLEVEL 10 GOTO Feature31
IF ERRORLEVEL 9 GOTO Feature30
IF ERRORLEVEL 8 GOTO Feature29
IF ERRORLEVEL 7 GOTO Feature28
IF ERRORLEVEL 6 GOTO Feature27
IF ERRORLEVEL 5 GOTO Feature26
IF ERRORLEVEL 4 GOTO Feature25
IF ERRORLEVEL 3 GOTO Feature24
IF ERRORLEVEL 2 GOTO Feature23
IF ERRORLEVEL 1 GOTO Feature22

:Feature22
%vivetool% /enable /id:42533185 >nul 2>&1
%notify%'APP','Replacing Recommended with For You in Start Menu has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature23
%vivetool% /enable /id:38811930 >nul 2>&1
%notify%'APP','Multiple Languages support for Live Captions have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature24
%vivetool% /enable /id:42550315 >nul 2>&1
%notify%'APP','New option for Inplace Upgrade without reinstall has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature25
%vivetool% /enable /id:40430431 >nul 2>&1
%notify%'APP','Live Kernel Dump has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature26
%vivetool% /enable /id:40733296 >nul 2>&1
%vivetool% /enable /id:41540372 >nul 2>&1
%vivetool% /enable /id:41562961 >nul 2>&1
%vivetool% /enable /id:41061894 >nul 2>&1
%notify%'APP','New Visuals for Microsoft Cloud Storage have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature27
%vivetool% /enable /id:40887771 >nul 2>&1
%vivetool% /enable /id:38937525 >nul 2>&1
%notify%'APP','New Windows Search has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature28
%vivetool% /enable /id:36165848 >nul 2>&1
%notify%'APP','Sticker drawing has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature29
%vivetool% /enable /id:38113452 >nul 2>&1
%notify%'APP','Network VPN Indicator has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature30
%vivetool% /enable /id:39731733 >nul 2>&1
%notify%'APP','Tradein or Recycle PC option has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature31
%vivetool% /enable /id:37969115 >nul 2>&1
%notify%'APP','Desktop Search Box has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature32
%vivetool% /enable /id:41314201 >nul 2>&1
%notify%'APP','Taskbar Seconds have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature33
%vivetool% /enable /id:34878152 >nul 2>&1
%notify%'APP','Animated Settings Icons have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature34
%vivetool% /enable /id:38664959
%vivetool% /enable /id:40064642
%vivetool% /enable /id:41070380
%notify%'APP','File Explorer recommendations have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature35
%vivetool% /enable /id:39305332
%notify%'APP','USB4 domain viewer has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature36
%vivetool% /enable /id:39696859
%notify%'APP','File Explorer new access keys have been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature37
%notify%'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature38
%notify%'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature39
%notify%'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature40
%notify%'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature41
%notify%'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:Feature42
%notify%'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO FeaturesPage2

:GoBack
GOTO InsiderFeaturesMenu
:: Note - BATCH FILE END.
