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
@ECHO [36m___________________________________________________[0m
echo.
echo   We're almost done, [91mdon't[0m touch your PC just yet.
echo          Windows will [93mautomatically restart[0m.
echo.
@ECHO [36m___________________________________________________[0m

:: Note - Move hosts
move "C:\Program Files\LTSC\hosts" "C:\Windows\System32\drivers\etc\hosts" >nul 2>&1

:: Note - Activating Windows

ver | findstr /i "22621 22624" >nul
if %errorlevel% equ 0 (
    start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\activate.cmd" >nul 2>&1
) else (
    systeminfo | findstr /i /c:"OS Name" | findstr /i /c:"Server" >nul
    if %errorlevel% equ 0 (
        start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\activate_server.cmd" >nul 2>&1
    ) else (
         start cmd.exe @cmd /C "C:\Program Files\LTSC\Scripts\activate.cmd" >nul 2>&1
    )
)

:: Note - Set the correct branding for all LTSC versions
ver | findstr /i "22621 22624" >nul
if %errorlevel% equ 0 (
    Reg add "HKCU\Control Panel\Desktop" /v "WallPaper" /t REG_SZ /d "C:\Windows\Web\Wallpaper\ThemeD\img32.jpg" /f >nul 2>&1
    Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /t REG_SZ /d "Windows 11 LTSC" /f >nul 2>&1
    Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Manufacturer" /t REG_SZ /d "Windows 11 LTSC" /f >nul 2>&1
    Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportURL" /t REG_SZ /d "https://github.com/LSX285/Windows11-LTSC" /f >nul 2>&1
) else (
    systeminfo | findstr /i /c:"OS Name" | findstr /i /c:"Server" >nul
    if %errorlevel% equ 0 (
        Reg add "HKCU\Control Panel\Desktop" /v "WallPaper" /t REG_SZ /d "C:\Windows\Web\Wallpaper\ThemeD\img34.jpg" /f >nul 2>&1
        Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /t REG_SZ /d "Windows 11 LTSC Server" /f >nul 2>&1
        Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Manufacturer" /t REG_SZ /d "Windows 11 LTSC Server" /f >nul 2>&1
        Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportURL" /t REG_SZ /d "https://github.com/LSX285/Windows11-LTSC" /f >nul 2>&1
    ) else (
         Reg add "HKCU\Control Panel\Desktop" /v "WallPaper" /t REG_SZ /d "C:\Windows\Web\Wallpaper\ThemeD\img33.jpg" /f >nul 2>&1
         Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /t REG_SZ /d "Windows 11 LTSC Insider" /f >nul 2>&1
         Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Manufacturer" /t REG_SZ /d "Windows 11 LTSC Insider" /f >nul 2>&1
         Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportURL" /t REG_SZ /d "https://github.com/LSX285/Windows11-LTSC" /f >nul 2>&1
    )
)

Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v "RunItOnce" /t REG_SZ /d "\"C:\Program Files\LTSC\App.bat\"" /f >nul 2>&1

:: Note - Restarting Windows to apply all changes made by this script.
shutdown /r /f /t 25 >nul 2>&1
