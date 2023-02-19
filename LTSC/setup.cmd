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

:: Note - Applying changes, Windows must be restarted afterwards.
Title Setup: Almost done
mode con: cols=52 lines=7
echo ___________________________________________________
echo.
echo   We're almost done, dont touch your PC just yet.
echo          Windows will automatically restart.
echo.
echo ___________________________________________________

:: Note - Download files
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/Edge_Uninstall.bat', 'C:\Program Files\LTSC\Scripts\Edge_Uninstall.bat')" >nul 2>&1
powershell -command "wget 'https://github.com/LSX285/Windows11-LTSC/raw/main/LTSC/Scripts/ViveTool/Albacore.ViVe.dll' -outfile 'C:\Program Files\LTSC\Scripts/ViveTool/Albacore.ViVe.dll'" >nul 2>&1
powershell -command "wget 'https://github.com/LSX285/Windows11-LTSC/raw/main/LTSC/Scripts/ViveTool/FeatureDictionary.pfs' -outfile 'C:\Program Files\LTSC\Scripts/ViveTool/FeatureDictionary.pfs'" >nul 2>&1
powershell -command "wget 'https://github.com/LSX285/Windows11-LTSC/raw/main/LTSC/Scripts/ViveTool/Newtonsoft.Json.dll' -outfile 'C:\Program Files\LTSC\Scripts/ViveTool/Newtonsoft.Json.dll'" >nul 2>&1
powershell -command "wget 'https://github.com/LSX285/Windows11-LTSC/raw/main/LTSC/Scripts/ViveTool/ViVeTool.exe' -outfile 'C:\Program Files\LTSC\Scripts/ViveTool/ViVeTool.exe'" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://aka.ms/vs/17/release/vc_redist.x64.exe', 'C:\Users\%USERNAME%\Desktop\vc_redist.x64.exe')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/activate.cmd', 'C:\Program Files\LTSC\Scripts\activate.cmd')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/tweaks.reg', 'C:\Program Files\LTSC\tweaks.reg')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/hosts', 'C:\Windows\System32\drivers\etc\hosts')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/Apps/HEVCVideoExtensions.appx', 'C:\Users\%USERNAME%\Desktop\HEVCVideoExtensions.appx')" >nul 2>&1

:: Note - Removing Edge
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\Edge_Uninstall.bat" >nul 2>&1

:: Note - Don't autoinstall Microsoft Teams
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f >nul 2>&1

:: Note - Remove the US QWERTY Keyboard Layout if you set up your own in OOBE
reg delete "HKCU\Keyboard Layout\Preload" /v 2 /F >nul 2>&1

:: Note - Turn off Reserved Storage for Updates to save more Storage
dism /Online /Set-ReservedStorageState /State:Disabled >nul 2>&1

:: Note - Turn off Hibernation
powercfg /h off >nul 2>&1

:: Note - Set network profile to "private"
PowerShell -ExecutionPolicy Unrestricted -Command Set-NetConnectionProfile -Name 'Network' -NetworkCategory Private >nul 2>&1

:: Note - Setting Services to Demand/Manual
sc config HomeGroupListener start=demand >nul 2>&1
sc config HomeGroupProvider start=demand >nul 2>&1
sc config diagnosticshub.standardcollector.service start=demand >nul 2>&1
sc config DiagTrack start=demand >nul 2>&1
sc config DPS start=demand >nul 2>&1
sc config dmwappushservice start=demand >nul 2>&1
sc config lfsvc start=demand >nul 2>&1
sc config MapsBroker start=demand >nul 2>&1
sc config NetTcpPortSharing start=demand >nul 2>&1
sc config RemoteAccess start=demand >nul 2>&1
sc config RemoteRegistry start=demand >nul 2>&1
sc config SharedAccess start=demand >nul 2>&1
sc config TrkWks start=demand >nul 2>&1
sc config WMPNetworkSvc start=demand >nul 2>&1
sc config WSearch start=demand >nul 2>&1
sc config XblAuthManager start=demand >nul 2>&1
sc config XblGameSave start=demand >nul 2>&1
sc config XboxNetApiSvc start=demand >nul 2>&1
sc config XboxGipSvc start=demand >nul 2>&1
sc config ndu start=auto >nul 2>&1
sc config WerSvc start=demand >nul 2>&1
sc config Fax start=demand >nul 2>&1
sc config fhsvc start=demand >nul 2>&1
sc config gupdate start=demand >nul 2>&1
sc config gupdatem start=demand >nul 2>&1
sc config AJRouter start=demand >nul 2>&1
sc config stisvc start=demand >nul 2>&1
sc config MSDTC start=demand >nul 2>&1
sc config WpcMonSvc start=demand >nul 2>&1
sc config PhoneSvc start=demand >nul 2>&1
sc config PrintNotify start=demand >nul 2>&1
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
sc config Browser start=demand >nul 2>&1
sc config BthAvctpSvc start=demand >nul 2>&1
sc config iphlpsvc start=demand >nul 2>&1
sc config edgeupdate start=demand >nul 2>&1
sc config MicrosoftEdgeElevationService start=demand >nul 2>&1
sc config edgeupdatem start=demand >nul 2>&1
sc config SEMgrSvc start=demand >nul 2>&1
sc config PerfHost start=demand >nul 2>&1
sc config BcastDVRUserService_48486de start=demand >nul 2>&1
sc config CaptureService_48486de start=demand >nul 2>&1
sc config cbdhsvc_48486de start=demand >nul 2>&1
sc config WpnService start=demand >nul 2>&1
sc config RtkBtManServ start=demand >nul 2>&1
sc config QWAVE start=demand >nul 2>&1

:: Note - Task Scheduler Block
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyMonitor" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1

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

:: Note - Install VCRedist
"C:\Users\%USERNAME%\Desktop\vc_redist.x64.exe" /install /quiet /norestart
del /f "C:\Users\%USERNAME%\Desktop\vc_redist.x64.exe" >nul 2>&1

:: Note - Install HEVC Codec
PowerShell -Command "add-appxpackage -path 'C:\Users\%USERNAME%\Desktop\HEVCVideoExtensions.appx'" >nul 2>&1
del /f "C:\Users\%USERNAME%\Desktop\HEVCVideoExtensions.appx" >nul 2>&1

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

:: Note - Install Windows Update Powershell components
PowerShell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force" >nul 2>&1
PowerShell -Command "Install-PackageProvider -Name NuGet -Force" >nul 2>&1
PowerShell -Command "Install-Module PSWindowsUpdate -Force" >nul 2>&1
PowerShell -Command "Add-WUServiceManager -MicrosoftUpdate -Confirm:$False" >nul 2>&1

:: Note - Remove Onedrive
"C:\Windows\System32\OneDriveSetup.exe" /uninstall >nul 2>&1

:: Note - Getting rid of Accesibility & Windows Tools shortcut to clean up the Start Menu
rmdir /S /Q "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Accessibility"
rmdir /S /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessibility"
del /f "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Administrative Tools.lnk"

:: Note - Activating Windows
start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\activate.cmd" >nul 2>&1

:: Note - Set Windows Drive Label to OS
label c: OS >nul 2>&1

:: Note - Applying Registry Changes
regedit /s "C:\Program Files\LTSC\tweaks.reg"

:: Note - Delete PS Folder which is automaticallly created when installing PSWindowsUpdate components.
rmdir /S /Q "C:\Users\%USERNAME%\Documents\WindowsPowerShell" >nul 2>&1

:: Note - Restarting Windows to apply all changes made by this script.
timeout 20 >nul 2>&1
shutdown -r -t 0 -f >nul 2>&1
