@echo off
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "RunOnce_RunMe" /t REG_SZ /d "\"C:\Program Files\LTSC\setup.cmd\"" /f >nul 2>&1
				
del /q /f "%0"