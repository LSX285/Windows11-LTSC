@echo off

set ltscdir=C:\Program Files\LTSC

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "RunOnce_RunMe" /t REG_SZ /d "\"%ltscdir%\setup.cmd\"" /f >nul 2>&1
				
del /q /f "%0"