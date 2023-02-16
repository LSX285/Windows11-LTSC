@cls
@echo off
>nul chcp 437
setlocal enabledelayedexpansion
title Temp Cleaner

echo.
cd /d "%~dp0"

:::: Run as administrator, AveYo: ps\vbs version
1>nul 2>nul fltmc || (
	set "_=call "%~dpfx0" %*" & powershell -nop -c start cmd -args '/d/x/r',$env:_ -verb runas || (
	>"%temp%\Elevate.vbs" echo CreateObject^("Shell.Application"^).ShellExecute "%~dpfx0", "%*" , "", "runas", 1
	>nul "%temp%\Elevate.vbs" & del /q "%temp%\Elevate.vbs" )
	exit)

rem Clean Up the WinSxS Folder
rem https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/clean-up-the-winsxs-folder

echo ### Clean Folder :: "C:\WINDOWS\WinSxS"
1>nul 2>&1 reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /f /v "DisableResetbase" /t "reg_DWORD" /d 0
1>nul 2>&1 Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase || (
	1>nul 2>&1 Dism.exe /online /Cleanup-Image /SPSuperseded
	1>nul 2>&1 Dism.exe /online /Cleanup-Image /StartComponentCleanup
)

call :DestryFolder "%Windir%\Temp"
call :DestryFolder "%Windir%\assembly\tmp"
call :DestryFolder "%Windir%\assembly\temp"
call :DestryFolder "%LOCALAPPDATA%\Temp"
call :DestryFolder "%ALLUSERSPROFILE%\Comodo\Cis\tempscrpt"
call :DestryFolder "%Windir%\SoftwareDistribution\Download"
call :DestryFolder "%ProgramData%\NVIDIA Corporation\Downloader"
call :DestryFolder "%ProgramFiles%\NVIDIA Corporation\Installer2"

echo ### Clean Folder :: "%Windir%\System32\config\systemprofile\AppData\Local"
set "tPath=%Windir%\System32\config\systemprofile\AppData\Local"
>"%temp%\result" 2>&1 dir /ad /b "%tPath%\*tmp" && for /f "tokens=*" %%# in ('type "%temp%\result"') do >nul 2>&1 rd /s /q "%tPath%\%%#"


echo.
1>nul 2>&1 reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches" && (
	>"%temp%\tmp" reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
	for /f "tokens=*" %%g in ('type "%temp%\tmp"') do (
		set addin=%%g
		echo ### Clean Addins :: !addin:~83!
		1>nul 2>&1 REG ADD "%%g" /f /v "StateFlags0001" /t REG_DWORD /d "2"
	)
	start /HIGH "" "cleanmgr" "/sagerun:1"
)

echo.

:DestryFolder
set "targetFolder=%*"
echo ### Clean Folder :: %targetFolder%
if exist %targetFolder% (
    1>nul 2>&1 rd /s /q %targetFolder%
    if exist %targetFolder% (
		if /i '!targetFolder!' NEQ '%temp%' (
			for /f "tokens=*" %%g in ('dir /b/s /a-d %targetFolder%') do (
				1>nul 2>&1 move /y "%%g" "%temp%"
			)
		)
	) else (
		md %targetFolder%
	)
) else (
	md %targetFolder%
)
goto :eof