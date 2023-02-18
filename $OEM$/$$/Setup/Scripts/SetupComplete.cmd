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

:: Create LTSC folders
mkdir "C:\Program Files\LTSC" >nul 2>&1
mkdir "C:\Program Files\LTSC\Scripts" >nul 2>&1
mkdir "C:\Program Files\LTSC\Scripts\Vivetool" >nul 2>&1
mkdir "C:\Program Files\LTSC\AdditionalFiles" >nul 2>&1
mkdir "C:\Program Files\LTSC\AdditionalFiles\RepairWin" >nul 2>&1

:: download latest setup & app
powershell -command "wget 'https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/setup.cmd' -outfile 'C:\Program Files\LTSC\Setup.cmd'" >nul 2>&1
powershell -command "wget 'https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/App.bat' -outfile 'C:\Program Files\LTSC\App.bat'" >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "RunOnce_RunMe" /t REG_SZ /d "\"C:\Program Files\LTSC\Setup.cmd\"" /f >nul 2>&1
exit


