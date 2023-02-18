@echo off
timeout 3
ECHO [-] Updating APP ...
attrib -r C:\Program Files\LTSC\App.bat
powershell -command "wget https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/App.bat -outfile 'C:\Program Files\LTSC\App.bat'"
ECHO [+] Done.
timeout 3
start cmd.exe @cmd "C:\Program Files\LTSC\App.bat"
exit


