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
@echo off
%windir%\system32\reg.exe query "HKU\S-1-5-19" >nul 2>&1 || (
@echo Please execute as Admin.
@echo.
@echo Press any key to continue ...
pause >nul
exit
)
pushd %~dp0

set ltscdir=C:\Program Files\LTSC
set repository=https://github.com/LSX285/Windows11-LTSC/raw/main

:: Note - Applying changes, Windows must be restarted afterwards.
Title Setup: Almost done
mode con: cols=52 lines=7
@ECHO [36m___________________________________________________[0m
echo.
echo   We're almost done, [91mdon't[0m touch your PC just yet.
echo          Windows will [93mautomatically restart[0m.
echo.
@ECHO [36m___________________________________________________[0m

:: Note - Hosts file blocking telemetry and advertising hosts
powershell -command "(New-Object Net.WebClient).DownloadFile('%repository%/LTSC/hosts', 'C:\Windows\System32\drivers\etc\hosts')" >nul 2>&1

:: Note - Turn off Hibernate
powercfg /h off >nul 2>&1

:: Note - Turn off reserved storage
dism /Online /Set-ReservedStorageState /State:Disabled

:: Note - Setting Services to Demand/Manual
sc config diagnosticshub.standardcollector.service start=demand >nul 2>&1
sc config DPS start=demand >nul 2>&1
sc config dmwappushservice start=demand >nul 2>&1
sc config lfsvc start=demand >nul 2>&1
sc config MapsBroker start=demand >nul 2>&1
sc config RemoteAccess start=demand >nul 2>&1
sc config RemoteRegistry start=demand >nul 2>&1
sc config SharedAccess start=demand >nul 2>&1
sc config TrkWks start=demand >nul 2>&1
sc config WSearch start=demand >nul 2>&1
sc config XblAuthManager start=demand >nul 2>&1
sc config XblGameSave start=demand >nul 2>&1
sc config XboxNetApiSvc start=demand >nul 2>&1
sc config XboxGipSvc start=demand >nul 2>&1
sc config WerSvc start=demand >nul 2>&1
sc config fhsvc start=demand >nul 2>&1
sc config AJRouter start=demand >nul 2>&1
sc config stisvc start=demand >nul 2>&1
sc config MSDTC start=demand >nul 2>&1
sc config WpcMonSvc start=demand >nul 2>&1
sc config PhoneSvc start=demand >nul 2>&1
sc config PcaSvc start=demand >nul 2>&1
sc config WPDBusEnum start=demand >nul 2>&1
sc config seclogon start=demand >nul 2>&1
sc config SysMain start=demand >nul 2>&1
sc config lmhosts start=demand >nul 2>&1
sc config wisvc start=demand >nul 2>&1
sc config FontCache start=demand >nul 2>&1
sc config RetailDemo start=demand >nul 2>&1
sc config ALG start=demand >nul 2>&1
sc config SCardSvr start=demand >nul 2>&1
sc config EntAppSvc start=demand >nul 2>&1
sc config BthAvctpSvc start=demand >nul 2>&1
sc config iphlpsvc start=demand >nul 2>&1
sc config edgeupdate start=demand >nul 2>&1
sc config edgeupdatem start=demand >nul 2>&1
sc config SEMgrSvc start=demand >nul 2>&1
sc config PerfHost start=demand >nul 2>&1
sc config BcastDVRUserService start=demand >nul 2>&1
sc config CaptureService start=demand >nul 2>&1
sc config cbdhsvc start=demand >nul 2>&1
sc config WpnService start=demand >nul 2>&1
sc config QWAVE start=demand >nul 2>&1
sc config AppXSvc start=demand >nul 2>&1
sc config WPNSerivce start=demand >nul 2>&1
sc config WpnUserService start=demand >nul 2>&1
sc config webthreatdefusersvc start=demand >nul 2>&1
sc config SgrmBroker start=demand >nul 2>&1
sc config RMSvc start=demand >nul 2>&1
sc config NcdAutoSetup start=demand >nul 2>&1
sc config FDResPub start=demand >nul 2>&1
sc config fdPHost start=demand >nul 2>&1
sc config EFS start=demand >nul 2>&1
sc config DusmSvc start=demand >nul 2>&1
sc config Deviceassociationservice start=demand >nul 2>&1

:: Note - Removing FoD Packages
dism /Online /Disable-Feature /FeatureName:"TelnetClient" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"WCF-TCP-PortSharing45" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"SmbDirect" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"TFTP" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"WorkFolders-Client" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-LPRPortMonitor" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Printing-XPSServices-Features" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Xps-Foundation-Xps-Viewer" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x64" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x84" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-amd64" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"LegacyComponents" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"MediaPlayback" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"WindowsMediaPlayer" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"SearchEngine-Client-Package" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"MicrosoftWindowsPowershellV2Root" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"MSRDC-Infrastructure" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"FaxServicesClientPackage" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"ScanManagementConsole" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Printing-PrintToPDFServices-Features" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"LPDPrintService" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-InternetPrinting-Client" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-Features" /NoRestart >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'Browser.InternetExplorer*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'MathRecognizer*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'OneCoreUAP.OneSync*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'OpenSSH.Client*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'Microsoft.Windows.PowerShell.ISE*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'App.Support.QuickAssist*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'App.StepsRecorder*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'Hello.Face*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'Media.WindowsMediaPlayer*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'Microsoft.Wallpapers.Extended*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'Microsoft.Windows.Ethernet.Client*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'Microsoft.Windows.Notepad*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'Microsoft.Windows.Wifi.Client*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'Microsoft.Windows.WordPad*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'Print.Fax.Scan*' | Remove-WindowsCapability -Online" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'Print.Management.Console*' | Remove-WindowsCapability -Online" >nul 2>&1

:: Note - Remove Apps
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

:: Note - Remove Onedrive
"C:\Windows\System32\OneDriveSetup.exe" /uninstall >nul 2>&1

:: Note - Remove Autologger telemetry
reg delete "HKLM\SYSTEM\ControlSet001\Control\WMI\Autologger\CloudExperienceHostOobe" /f >nul 2>&1
reg delete "HKLM\SYSTEM\ControlSet001\Control\WMI\Autologger\Diagtrack-Listener" /f >nul 2>&1
reg delete "HKLM\SYSTEM\ControlSet001\Control\WMI\Autologger\SQMLogger" /f >nul 2>&1
reg delete "HKLM\SYSTEM\ControlSet001\Control\WMI\Autologger\WFP-IPsec Trace" /f >nul 2>&1

:: Note - Getting rid of Accesibility & Windows Tools shortcut to clean up the Start Menu
rmdir /S /Q "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Accessibility" >nul 2>&1
rmdir /S /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessibility" >nul 2>&1
del /f "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Administrative Tools.lnk" >nul 2>&1

:: Note - Disabling hardware compatibility checks
Reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\SYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /t REG_DWORD /d "1" /f | Out-Null

:: Note - Set drive name OS
label OS

:: Note - Turn off hibernate
powercfg /h off

:: Note - Downloading latest tweaks and Applying Registry Changes 
regedit /s "%ltscdir%\Scripts\tweaks.reg" >nul 2>&1

 Note - Removing Edge
start cmd.exe @cmd /C "%ltscdir%\Scripts\Edge_Uninstall.cmd" >nul 2>&1

:: Note - Activating Windows
start cmd.exe @cmd /C "%ltscdir%\Scripts\activate.cmd" >nul 2>&1

timeout 30 >nul 2>&1

:: Note - Set the correct branding for all LTSC versions
ver | findstr /i "22000 22621 22622 22623 22624" >nul
if %errorlevel% equ 0 (
    Reg add "HKCU\Control Panel\Desktop" /v "WallPaper" /t REG_SZ /d "C:\Windows\Web\Wallpaper\ThemeD\img32.jpg" /f >nul 2>&1
    Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /t REG_SZ /d "Windows 11 LTSC" /f >nul 2>&1
    Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Manufacturer" /t REG_SZ /d "Windows 11 LTSC" /f >nul 2>&1
    Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportURL" /t REG_SZ /d "https://github.com/LSX285/Windows11-LTSC" /f >nul 2>&1
) else (
        Reg add "HKCU\Control Panel\Desktop" /v "WallPaper" /t REG_SZ /d "C:\Windows\Web\Wallpaper\ThemeD\img33.jpg" /f >nul 2>&1
        Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /t REG_SZ /d "Windows 11 LTSC Insider" /f >nul 2>&1
        Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Manufacturer" /t REG_SZ /d "Windows 11 LTSC Insider" /f >nul 2>&1
        Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportURL" /t REG_SZ /d "https://github.com/LSX285/Windows11-LTSC" /f >nul 2>&1
    )
)

Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v "RunItOnce" /t REG_SZ /d "\"%ltscdir%\App.cmd\"" /f >nul 2>&1

powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP','Reapplying LTSC finished. Windows will restart shortly.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1

:: Note - Restarting Windows to apply all changes made by this script.
shutdown /r /f /t 05 >nul 2>&1