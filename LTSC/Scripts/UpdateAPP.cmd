@echo off
timeout 1 >nul 2>&1
ECHO [-] Updating APP ...
attrib -r  C:\Program Files\LTSC\*.* /s >nul 2>&1
powershell -command "wget https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/App.bat -outfile 'C:\Program Files\LTSC\App.bat'" >nul 2>&1
ECHO [+] Done.
timeout 2 >nul 2>&1
"C:\Program Files\LTSC\App.bat"
exit


