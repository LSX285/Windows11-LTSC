@echo off
timeout 3
ECHO [-] Updating APP ...
attrib -r C:\Windows\Web\LTSC\App.bat
powershell -command "wget https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/App.bat -outfile 'C:\Program Files\LTSC\App.bat'"
ECHO [+] Done. Open APP again.
timeout 3
exit


