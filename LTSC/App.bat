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
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
@echo                     - Please execute as Administrator. -
@echo.
@ECHO [36m____________________________________________________________________________[0m
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
@ECHO.                                 Hi, [96m%USERNAME%[0m
@ECHO                          Welcome to Windows [94m11[0m [7mLTSC[0m
@ECHO. 
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO    [[1mA[0m] Install Apps     [[1mB[0m] More Debloat      [[1mC[0m] Drivers    [[1mD[0m] Settings
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO    [101m[X] Exit[0m   [100m[U] Update APP[0m                                 [100m[Z] Debug[0m
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
winget install Google.Chrome --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Google Chrome has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Discord
winget install Discord.Discord --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Discord has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Spotify
powershell -command "(New-Object Net.WebClient).DownloadFile('https://download.scdn.co/SpotifySetup.exe', 'C:\Users\%USERNAME%\Desktop\SpotifySetup.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Spotify has been downloaded. Please run the setup manually.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Steam
winget install Valve.Steam --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Steam has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:EpicGames
winget install EpicGames.EpicGamesLauncher --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Epic Games Launcher has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Mullvad
winget install MullvadVPN.MullvadVPN --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Mullvad has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Wireguard
winget install WireGuard.WireGuard --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Wireguard has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:LibreOffice
winget install TheDocumentFoundation.LibreOffice --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','LibreOffice has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Paintnet
winget install dotPDNLLC.paintdotnet --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Paint.net has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu


:VlcPlayer
winget install VideoLAN.VLC --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','VLC Player has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:MSIAfterburner
ECHO [[93m-[0m] Downloading [93mMSI Afterburner[0m ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://ftp.nluug.nl/pub/games/PC/guru3d/afterburner/[Guru3D.com]-MSIAfterburnerSetup465Beta4Build16358.zip', 'C:\Users\%USERNAME%\Desktop\MSIAfterburner.zip')" >nul 2>&1
ECHO [[93m-[0m] Extracting [93mMSI Afterburner[0m ...
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\MSIAfterburner.zip' 'C:\Users\%USERNAME%\Desktop'"
ECHO [[93m-[0m] Installing [93mMSI Afterburner[0m ...
"C:\Users\%USERNAME%\Desktop\MSIAfterburnerSetup465Beta4.exe" /S
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','MSI Afterburner has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\MSIAfterburner.zip" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\MSIAfterburnerSetup465Beta4.exe" >nul 2>&1
rmdir /S /Q "C:\Users\%USERNAME%\Desktop\Guru3D.com" >nul 2>&1
move /y "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\MSI Afterburner\MSI Afterburner.lnk" "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs" >nul 2>&1
rmdir /S /Q "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\MSI Afterburner"
GOTO AppDLMenu

:NZXTCam
winget install NZXT.CAM --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','NZXT CAM has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:VSCode
winget install Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','VS Code has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Blender
winget install BlenderFoundation.Blender --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Blender has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Hwinfo
winget install REALiX.HWiNFO --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','HWINFO has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AppDLMenu

:Updates
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
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
winget install Opera.OperaGX --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Opera GX has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:Brave
winget install Brave.Brave --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Brave has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:EADesktop
winget install ElectronicArts.EADesktop --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','EA Desktop App has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:GOGGalaxy
winget install GOG.Galaxy --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','GOG Galaxy has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:BattleNet
ECHO [[93m-[0m] Downloading [93mBattle.net[0m ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://www.battle.net/download/getInstallerForGame?os=win&gameProgram=BATTLENET_APP&version=Live&id=undefined', 'C:\Users\%USERNAME%\Desktop\Battle.net-Setup.exe')" >nul 2>&1
ECHO [[93m-[0m] Installing [93mBattle.net[0m ...
"C:\Users\%USERNAME%\Desktop\Battle.net-Setup.exe" --lang=enUS --installpath="C:\Program Files (x86)\Battle.net"
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Battle.net Launcher has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Battle.net-Setup.exe" >nul 2>&1
GOTO More

:UbisoftConnect
winget install Ubisoft.Connect --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Ubisoft Connect has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:GIMP 
winget install GIMP.GIMP --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','GIMP has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:GPUZ
winget install TechPowerUp.GPU-Z --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','GPU-Z has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:OneDrive
winget install  Microsoft.OneDrive --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','OneDrive has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:OBSStudio
winget install OBSProject.OBSStudio --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','OBS Studio has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:GeforceExperience
winget install Nvidia.GeForceExperience --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Geforce Experience has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:GeforceNOW
ECHO [[93m-[0m] Downloading [93mGeforce Now[0m ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://download.nvidia.com/gfnpc/GeForceNOW-release.exe', 'C:\Users\%USERNAME%\Desktop\GeForceNOW-Setup.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Geforce Now has been downloaded. Please run the installer manually.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:PostgreSQL
winget install PostgreSQL.PostgreSQL --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','POSTgreSQL has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:Dropbox
winget install Dropbox.Dropbox --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Dropbox has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:Teams
winget install Microsoft.Teams --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Teams has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More

:Updates
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
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
winget install Zoom.Zoom --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Zoom has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:SublimeText
winget install SublimeHQ.SublimeText.4 --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Sublime Text has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Notepadplusplus
winget install Notepad++.Notepad++ --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Notepad PlusPlus has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Corsairicue
winget install Corsair.iCUE.4 --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Corsair iCUE has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Firefox
winget install Mozilla.Firefox --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Firefox has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:VisualStudio
winget install Microsoft.VisualStudio.2022.Community --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Visual Studio 2022 Community has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Radiograph
winget install 9NH1P86H06CG --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Radiograph has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:qBittorrent
winget install qBittorrent.qBittorrent --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','qBittorrent has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Picotorrent
winget install PicoTorrent.PicoTorrent --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Picotorrent has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:GooglePlayGames
winget install Google.PlayGames.Beta --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Google Play Games has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Audacity
winget install Audacity.Audacity --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Audacity has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Cinebench
winget install 9PGZKJC81Q7J --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Cinebench has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:iTunes
winget install Apple.iTunes --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','iTunes has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Rufus
winget install Rufus.Rufus --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Rufus has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Aida64
winget install FinalWire.AIDA64.Extreme --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Aida64 has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More2

:Updates
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
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
winget install NordVPN.NordVPN --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','NordVPN has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:ExpressVPN
winget install ExpressVPN.ExpressVPN --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','ExpressVPN has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Surfshark
winget install Surfshark.Surfshark --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Surfshark has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:WinSCP
winget install WinSCP.WinSCP --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','WinSCP has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:WindowsTerminal
winget install Microsoft.WindowsTerminal --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows Terminal has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:LogitechGHUB
winget install Logitech.GHUB --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Logitech G Hub has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:VSCodium
winget install VSCodium.VSCodium --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','VS Codium has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:NVCleanstall
winget install TechPowerUp.NVCleanstall --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','NVCleanstall has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:BlueStacks
winget install BlueStack.BlueStacks --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Bluestacks has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Powershell
winget install Microsoft.PowerShell --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Powershell has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Teamviewer
winget install TeamViewer.TeamViewer --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Teamviewer has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Parsec
winget install Parsec.Parsec --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Parsec has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Vivaldi
winget install VivaldiTechnologies.Vivaldi --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Vivaldi has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Virtualbox
winget install Oracle.VirtualBox --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Virtualbox has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:VMWare
winget install VMware.WorkstationPlayer --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','VMWare has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More3

:Updates
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
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
winget install LizardByte.Sunshine --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','NVIDIA Sunshine has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:Foobar2000
winget install PeterPawlowski.foobar2000 --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Foobar 2000 has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:CPUZ
winget install CPUID.CPU-Z --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','CPU-Z has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:ChromeBeta
winget install Google.Chrome.Beta --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Google Chrome Beta has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:ChromeDev
winget install Google.Chrome.Dev --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Google Chrome Dev has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:ChromeCanary
winget install Google.Chrome.Canary --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Google Chrome Canary has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:UngoogledChromium
winget install eloston.ungoogled-chromium --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Ungoogled Chromium has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:Edge
winget install Microsoft.Edge --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Microsoft Edge has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:EdgeBeta
winget install Microsoft.Edge.Beta --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Microsoft Edge Beta has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:EdgeDev
winget install Microsoft.Edge.Dev --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Microsoft Edge Dev has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:AdobeAcrobatReader
winget install Adobe.Acrobat.Reader.64-bit --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Adobe Acrobat Reader has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:WhatsApp
winget install WhatsApp.WhatsApp --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','WhatsApp has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:Telegram
winget install Telegram.TelegramDesktop --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Telegram has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:MSPCManager
winget install Microsoft.PCManager --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Microsoft PC Manager has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:Winamp
winget install Winamp.Winamp --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','WinAMP has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More4

:Updates
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
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
winget install Microsoft.Skype --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Skype has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Thunderbird
winget install Mozilla.Thunderbird --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Mozilla Thunderbird has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Slack
winget install SlackTechnologies.Slack --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Slack has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:ShareX
winget install ShareX.ShareX --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','ShareX has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Lightshot
winget install Skillbrains.Lightshot --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Lightshot has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Eartrumpet
winget install File-New-Project.EarTrumpet --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Eartrumpet has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Files
winget install FilesCommunity.Files --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Files has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:GoogleDrive
winget install Google.Drive --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Google Drive has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:WinRar
winget install RARLab.WinRAR --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','WinRar has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:7zip
winget install 7zip.7zip --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','7Zip has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Dolphin
winget install DolphinEmulator.Dolphin --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Dolphin Emulator has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:ppsspp
winget install PPSSPPTeam.PPSSPP --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','ppsspp Emulator has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:rpcs3
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/RPCS3/rpcs3-binaries-win/releases/download/build-39760189804d59315ab9f304d3cebddfb5d72f63/rpcs3-v0.0.26-14712-39760189_win64.7z', 'C:\Users\%USERNAME%\Desktop\rpcs3.7z')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','rpcs3 has been downloaded. Extract the 7zip file and run the installer manually.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Ryujinx
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/Ryujinx/release-channel-master/releases/download/1.1.617/ryujinx-1.1.617-win_x64.zip', 'C:\Users\%USERNAME%\Desktop\ryujinx.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\ryujinx.zip' 'C:\Users\%USERNAME%\Desktop\ryujinx'" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Ryujinx has been downloaded. Run the installer manually.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\ryujinx.zip" >nul 2>&1
GOTO More5

:AppleDevices
winget install 9NP83LWLPZ9K --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Apple Devices has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More5

:Updates
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
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
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Apps/Microsoft_Store.msix', 'C:\Users\%USERNAME%\Desktop\Microsoft_Store.msix')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path 'C:\Users\%USERNAME%\Desktop\Microsoft_Store.msix'" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1073475667905224714/1076434344106803261/Services_Store.Engagement.Appx', 'C:\Users\%USERNAME%\Desktop\Services_Store.Engagement.Appx')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path 'C:\Users\%USERNAME%\Desktop\Services_Store.Engagement.Appx'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Services_Store.Engagement.Appx" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Microsoft_Store.msix" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Microsoft Store has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:MicrosoftStorePurchaseApp
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Apps/Microsoft_Store-PurchaseApp.Msixbundle', 'C:\Users\%USERNAME%\Desktop\Microsoft_Store-PurchaseApp.Msixbundle')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path 'C:\Users\%USERNAME%\Desktop\Microsoft_Store-PurchaseApp.Msixbundle'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Microsoft_Store-PurchaseApp.Msixbundle" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Microsoft Store Purchase App has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:SnippingTool
winget install 9MZ95KL8MR0L --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Snipping Tool has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:Notepad
winget install 9MSMLRH6LZF3 --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Notepad has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:Nanazip
winget install M2Team.NanaZip --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Nanazip has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:XboxIdentityProvider
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Apps/XboxIdentityProvider.appx', 'C:\Users\%USERNAME%\Desktop\XboxIdentityProvider.appx')" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "add-appxpackage -path 'C:\Users\%USERNAME%\Desktop\XboxIdentityProvider.appx'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\XboxIdentityProvider.appx" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Xbox Identity Provider has been installed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:Placeholder
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO More6

:Updates
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Searching for Updates ...',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
winget upgrade --all >nul 2>&1
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
@ECHO                              [7mDebloat[0m [101;93mExperimental[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO                                      WIP
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO      [101m[X] Go back[0m
CHOICE /C:ax /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 2 GOTO GoBack
IF ERRORLEVEL 1 GOTO WIP

:WIP
ECHO [[93m-[0m] WIP ...
timeout 3 >nul 2>&1
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
@ECHO                                   [7mSettings[0m 
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO       [[1mA[0m] Disable Windows Defender         [[1mI[0m] Disable SmartScreen
ECHO       [[1mB[0m] Enable  Windows Defender         [[1mJ[0m] Enable  SmartScreen
ECHO       [[1mC[0m] Enable  Windows Dark Theme       [[1mK[0m] Disable Firewall
ECHO       [[1mD[0m] Enable  Windows Light Theme      [[1mL[0m] Enable  Firewall
ECHO       [[1mE[0m] Modernized classic context Menu  [[1mM[0m] Enable  Windows AMOLED
ECHO       [[1mF[0m] Back to Windows 11 Context Menu  [[1mN[0m] Disable Windows AMOLED
ECHO       [[1mG[0m] Enable  Photo Viewer [Legacy]    [[1mO[0m] Enable Education Themes
ECHO       [[1mH[0m] Disable Photo Viewer [Legacy]    [[1mP[0m] Disable Education Themes
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO      [101m[X] Go back[0m
CHOICE /C:abcdefghijklmnopx /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 17 GOTO GoBack
IF ERRORLEVEL 16 GOTO DisableEduThemes
IF ERRORLEVEL 15 GOTO EnableEduThemes
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
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Please go to Windows Security and turn off Tamper Protection. Press any Key to continue then.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
ECHO [[91m![0m] Press any Key to continue.
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/AntiDefender.cmd', 'C:\Program Files\LTSC\Scripts\AntiDefender.cmd')" >nul 2>&1
pause >nul 2>&1
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\AntiDefender.cmd" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows Defender has been turned off.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu


:EnableDefender
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/AntiDefenderUndo.cmd', 'C:\Program Files\LTSC\Scripts\AntiDefenderUndo.cmd')" >nul 2>&1
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\AntiDefenderUndo.cmd" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows Defender has been turned on.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableDarkMode
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V SystemUsesLightTheme /T REG_DWORD /D 0 /F >nul 2>&1
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V AppsUseLightTheme /T REG_DWORD /D 0 /F >nul 2>&1
taskkill /F /IM explorer.exe & start explorer >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows is now using Dark Mode.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableLightMode
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V SystemUsesLightTheme /T REG_DWORD /D 1 /F >nul 2>&1
REG Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /V AppsUseLightTheme /T REG_DWORD /D 1 /F >nul 2>&1
taskkill /F /IM explorer.exe & start explorer >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows is now using Light Mode.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:ModernContextMenu
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
winget install Nilesoft.Shell --accept-source-agreements --accept-package-agreements >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows is now using a modern legacy context menu.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:Windows11ContextMenu
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
winget uninstall Nilesoft.Shell >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Default Windows context menu has been restored.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnablePhotoViewer
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/EnablePhotoViewer.reg', 'C:\Program Files\LTSC\Scripts\EnablePhotoViewer.reg')" >nul 2>&1
regedit /s "C:\Program Files\LTSC\Scripts\EnablePhotoViewer.reg" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Legacy Photo viewer has been enabled. You might have to restart Windows to get it working.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisablePhotoViewer
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/DisablePhotoViewer.reg', 'C:\Program Files\LTSC\Scripts\DisablePhotoViewer.reg')" >nul 2>&1
regedit /s "C:\Program Files\LTSC\Scripts\DisablePhotoViewer.reg" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Legacy Photo viewer has been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisableSmartscreen
REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows Smartscreen has been turned off.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableSmartscreen
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Warn" /f >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows Smartscreen has been turned on.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisableFirewall
netsh advfirewall set allprofiles state off >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows Firewall has been turned off.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableFirewall
netsh advfirewall set allprofiles state on >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows Firewall has been turned on.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableWindowsAmoled
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/EnableAMOLED.reg', 'C:\Program Files\LTSC\Scripts\EnableAMOLED.reg')" >nul 2>&1
regedit /s "C:\Program Files\LTSC\Scripts\EnableAMOLED.reg" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows AMOLED Dark Mode has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisableWindowsAmoled
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/DisableAMOLED.reg', 'C:\Program Files\LTSC\Scripts\DisableAMOLED.reg')" >nul 2>&1
regedit /s "C:\Program Files\LTSC\Scripts\DisableAMOLED.reg" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows AMOLED has been removed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:EnableEduThemes
REG add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Education" /v "EnableEduThemes" /t REG_DWORD /d "1" /f >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Education themes have been enabled. Rebooting into Safeboot may display a hard error message which can be ignored.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO SettingsMenu

:DisableEduThemes
REG add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Education" /v "EnableEduThemes" /t REG_DWORD /d "0" /f >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Education themes have been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
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
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Chipset/Intel_Chipset_Legacy.exe', 'C:\Users\%USERNAME%\Desktop\Intel_Legacy_Chipset.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO ChipsetMenu

:Intel1213
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Chipset/Intel_Chipset.exe', 'C:\Users\%USERNAME%\Desktop\Intel_Chipset.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO ChipsetMenu

:AMDLegacy
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Chipset/AMD_Chipset_Legacy.exe', 'C:\Users\%USERNAME%\Desktop\AMD_Legacy_Chipset.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO ChipsetMenu

:AMDRyzen
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Chipset/AMD_Chipset.exe', 'C:\Users\%USERNAME%\Desktop\AMD_Chipset.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
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
powershell -command "(New-Object Net.WebClient).DownloadFile('https://international.download.nvidia.com/Windows/528.49/528.49-desktop-win10-win11-64bit-international-dch-whql.exe', 'C:\Users\%USERNAME%\Desktop\NVIDIA.exe')" >nul 2>&1
ECHO [[92m+[0m] Done.
timeout 3 >nul 2>&1
GOTO GraphicsMenu

:NvidiaGeforce2
powershell -command "(New-Object Net.WebClient).DownloadFile('https://international.download.nvidia.com/Windows/474.14/474.14-desktop-win10-win11-64bit-international-dch-whql.exe', 'C:\Users\%USERNAME%\Desktop\NVIDIA.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO GraphicsMenu

:NvidiaGeforce3
powershell -command "(New-Object Net.WebClient).DownloadFile('https://international.download.nvidia.com/Windows/391.35/391.35-desktop-win10-64bit-international-whql.exe', 'C:\Users\%USERNAME%\Desktop\NVIDIA.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO GraphicsMenu

:NvidiaGeforce4
powershell -command "(New-Object Net.WebClient).DownloadFile('https://international.download.nvidia.com/Windows/342.01/342.01-desktop-win10-64bit-international.exe', 'C:\Users\%USERNAME%\Desktop\NVIDIA.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO GraphicsMenu

:AMDRadeon4007000
powershell -command "(New-Object Net.WebClient).DownloadFile('https://www.mediafire.com/file/5f04vdbqt02dz4c/whql-amd-software-adrenalin-edition-23.2.2-win10-win11-feb22-VideoCardz.com.exe', 'C:\Users\%USERNAME%\Desktop\AMD_Radeon.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO GraphicsMenu

:IntelArc
powershell -command "(New-Object Net.WebClient).DownloadFile('https://downloadmirror.intel.com/768896/gfx_win_101.4125.exe', 'C:\Users\%USERNAME%\Desktop\Intel_ARC.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO GraphicsMenu

:InteliGPU
powershell -command "(New-Object Net.WebClient).DownloadFile('https://downloadmirror.intel.com/751359/gfx_win_101.3790_101.2114.zip', 'C:\Users\%USERNAME%\Desktop\Intel_iGPU.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Intel_iGPU.zip' 'C:\Users\%USERNAME%\Desktop\InteliGPU'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Intel_iGPU.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
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
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Audio/Audio_Realtek_ASUS.zip', 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_ASUS.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_ASUS.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_ASUS'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Audio_Realtek_ASUS.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekMSI
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Audio/Audio_Realtek_MSI.zip', 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_MSI.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_MSI.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_MSI'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Audio_Realtek_MSI.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekGigaByte
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Audio/Audio_Realtek_Gigabyte.zip', 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Gigabyte.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Gigabyte.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_GigaByte'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Audio_Realtek_Gigabyte.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekAsrock
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Audio/Audio_Realtek_Asrock.zip', 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Asrock.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Asrock.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Asrock'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Audio_Realtek_Asrock.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekEVGA
powershell -command "(New-Object Net.WebClient).DownloadFile('https://cdn.evga.com/driver/Z690/E698/Audio.zip', 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_EVGA.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_EVGA.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_EVGA'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Audio_Realtek_EVGA.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekDell
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Audio/Audio_Realtek_Dell.zip', 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Dell.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Dell.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Dell'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Audio_Realtek_Dell.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekLenovo
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Audio/Audio_Realtek_Lenovo.exe', 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Lenovo.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekHP
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Audio/Audio_Realtek_HP.zip', 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_HP.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_HP.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_HP'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Audio_Realtek_HP.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO AudioMenu

:RealtekAllOEM
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Audio/Audio_Realtek_Others.zip', 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Others.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Others.zip' 'C:\Users\%USERNAME%\Desktop\Audio_Realtek_Others'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Audio_Realtek_Others.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
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
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Intel_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Intel_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Intel_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Intel_Ethernet.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:RealtekEthernet
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Realtek_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Realtek_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Realtek_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Realtek_Ethernet.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MediatekEthernet
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Mediatek_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Mediatek_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Mediatek_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Mediatek_Ethernet.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:IntelWifi
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Intel_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Intel_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Intel_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Intel_Wifi.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:RealtekWifi
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Realtek_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Realtek_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Realtek_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Realtek_Wifi.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MediatekWifi
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Mediatek_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Mediatek_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Mediatek_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Mediatek_Wifi.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:IntelBluetooth
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Intel_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Intel_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Intel_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Intel_Bluetooth.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:RealtekBluetooth
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Realtek_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Realtek_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Realtek_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Realtek_Bluetooth.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MediatekBluetooth
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Mediatek_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Mediatek_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Mediatek_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Mediatek_Bluetooth.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:QualcommEthernet
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Qualcomm_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Qualcomm_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Qualcomm_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Qualcomm_Ethernet.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MarvellEthernet
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Marvell_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Marvell_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Marvell_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Marvell_Ethernet.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:BroadcomEthernet
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Broadcom_Ethernet.zip', 'C:\Users\%USERNAME%\Desktop\Broadcom_Ethernet.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Broadcom_Ethernet.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Broadcom_Ethernet.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:QualcommWifi
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Qualcomm_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Qualcomm_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Qualcomm_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Qualcomm_Wifi.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MarvellWifi
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Marvell_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Marvell_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Marvell_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Marvell_Wifi.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:BroadcomWifi
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Broadcom_Wifi.zip', 'C:\Users\%USERNAME%\Desktop\Broadcom_Wifi.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Broadcom_Wifi.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Broadcom_Wifi.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:QualcommBluetooth
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Qualcomm_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Qualcomm_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Qualcomm_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Qualcomm_Bluetooth.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:MarvellBluetooth
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Marvell_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Marvell_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Marvell_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Marvell_Bluetooth.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:BroadcomBluetooth
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Drivers/Networking/Broadcom_Bluetooth.zip', 'C:\Users\%USERNAME%\Desktop\Broadcom_Bluetooth.zip')" >nul 2>&1
powershell -command "Expand-Archive -Force 'C:\Users\%USERNAME%\Desktop\Broadcom_Bluetooth.zip' 'C:\Users\%USERNAME%\Desktop'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\Broadcom_Bluetooth.zip" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Driver download completed. Check your Desktop.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO NetworkingMenu

:GoBack
GOTO DriversMenu

:DebugMenu
mode con: cols=76 lines=20
Title Install Drivers
@ECHO OFF
CLS
@ECHO.
@ECHO                                     [7mDebug[0m
@ECHO.
@ECHO [36m____________________________________________________________________________[0m
@ECHO.
ECHO [[1mA[0m] Repair Windows     [[1mB[0m] Repair Windows (.WIM)   [[1mC[0m] Clean Temp Files
ECHO [[1mD[0m] Install Win Updates[[1mE[0m] MS Activation           [[1mF[0m] Update APP
ECHO [[1mG[0m] Rebuild Icon Cache [[1mH[0m] Flush DNS Cache         [[1mI[0m] Clear Thumbnail cache
ECHO [[1mJ[0m] Repair MS Store    [[1mK[0m] Enable builtin Admin    [[1mL[0m] Disable builtin Admin
ECHO.[[1mM[0m] Disable TPM Checks [[1mN[0m] Disable Modern Standby  [[1mO[0m] Reapply LTSC scripts
ECHO.[[1mP[0m] Update Win Security[[1mQ[0m] Placeholder             [[1mR[0m] Placeholder
ECHO.
@ECHO [36m____________________________________________________________________________[0m
ECHO.
ECHO          [101m[X] Go back[0m   [100m[Y] Restart Windows[0m   [100m[Z] Restart into BIOS[0m
CHOICE /C:abcdefghijklmnopqrxyz /N /M ""

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 21 GOTO RestartBIOS
IF ERRORLEVEL 20 GOTO RestartWindows
IF ERRORLEVEL 19 GOTO GoBack
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
IF ERRORLEVEL 5 GOTO MSActivation
IF ERRORLEVEL 4 GOTO InstallUpdates
IF ERRORLEVEL 3 GOTO CleanTempFiles
IF ERRORLEVEL 2 GOTO RepairWindowsAdvanced
IF ERRORLEVEL 1 GOTO RepairWindows

:RepairWindows
ECHO [[93m-[0m] Trying to [93mrepair Windows[0m ...
SFC /Scannow >nul 2>&1
DISM /Online /Cleanup-Image /CheckHealth >nul 2>&1
DISM /Online /Cleanup-Image /ScanHealth >nul 2>&1
DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Repair finished. Please restart Windows.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:RepairWindowsAdvanced
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Please move the install.wim to C:\Program Files\LTSC\AdditionalFiles\RepairWin and press any Key to continue.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
ECHO [[91m![0m] Press any key to continue.
pause >nul 2>&1
SFC /Scannow >nul 2>&1
DISM /Online /Cleanup-Image /CheckHealth >nul 2>&1
DISM /Online /Cleanup-Image /ScanHealth >nul 2>&1
DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1
DISM /Online /Cleanup-Image /RestoreHealth /Source:"C:\Program Files\LTSC\AdditionalFiles\RepairWin\install.wim"
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Repair finished. Please restart Windows.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:CleanTempFiles
ECHO [[93m-[0m] Cleaning [93mWindows Temp files[0m ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/CleanFiles.cmd', 'C:\Program Files\LTSC\Scripts\CleanFiles.cmd')" >nul 2>&1
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\CleanFiles.cmd" >nul 2>&1
GOTO DebugMenu

:InstallUpdates
PowerShell -Command "Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows Update sucessfully completed',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:MSActivation
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/activate.cmd', 'C:\Program Files\LTSC\Scripts\activate.cmd')" >nul 2>&1
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\activate.cmd" >nul 2>&1
GOTO DebugMenu

:UpdateAPP
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/UpdateAPP.cmd', 'C:\Program Files\LTSC\Scripts\UpdateAPP.cmd')" >nul 2>&1
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\UpdateAPP.cmd" >nul 2>&1
exit

:RebuildIconCache
ie4uinit.exe -show >nul 2>&1
taskkill /IM explorer.exe /F >nul 2>&1
DEL /A /Q "%localappdata%\IconCache.db" >nul 2>&1
DEL /A /F /Q "%localappdata%\Microsoft\Windows\Explorer\iconcache*" >nul 2>&1
start explorer.exe
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Icon cache has been rebuilt. Please restart Windows.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:FlushDNS
ipconfig /flushdns >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','DNS resolver cache has been flushed.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:ClearThumbnailCache
taskkill /f /im explorer.exe >nul 2>&1
timeout 2 >nul 2>&1
DEL /F /S /Q /A "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
timeout 2 >nul 2>&1
start explorer.exe
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Thumbnail cache has been cleared.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:RepairMSStore
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage -AllUsers 'WindowsStore' | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppXManifest.xml'}" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Microsoft Store has been repaired.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:EnableBuiltinAdmin
net user Administrator /active:yes >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Built-In Administrator Account has been enabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:DisableBuiltinAdmin
net user Administrator /active:no >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Built-In Administrator Account has been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:DisableChecks
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vdsldr.exe" /f >nul 2>&1
wmic /namespace:"\\root\subscription" path __EventFilter where Name="Skip TPM Check on Dynamic Update" delete >nul 2>&1
REG Add "HKLM\SYSTEM\Setup\MoSetup" /V AllowUpgradesWithUnsupportedTPMOrCPU /T REG_DWORD /D 1 /F >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Hardware compatibility checks have been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:DisableModernStandby
POWERCFG -SETDCVALUEINDEX SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 >nul 2>&1
POWERCFG -SETACVALUEINDEX SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Modern Standby connectivity has been disabled.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:ReapplyLTSC
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/setup.cmd', 'C:\Program Files\LTSC\Setup.cmd')" >nul 2>&1
start cmd.exe @cmd /C "C:\Program Files\LTSC\Setup.cmd" >nul 2>&1
GOTO DebugMenu

:UpdateWinSecurity
cd C:\ProgramData\Microsoft\Windows Defender\Platform\4.18* >nul 2>&1
MpCmdRun -SignatureUpdate >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows Security has been updated.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:Placeholder
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Placeholder.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
GOTO DebugMenu

:GoBack
GOTO Welcome

:RestartWindows
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Windows will restart shortly.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
shutdown /r /f /t 05 >nul 2>&1

:RestartBIOS
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Your PC will restart into UEFI/BIOS shortly.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
shutdown /r /fw /t 05 >nul 2>&1

:: Note - BATCH FILE END.
