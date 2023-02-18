@echo off
timeout 3
ECHO [-] Updating APP ...
attrib -r C:\Windows\Web\LTSC\App.bat
powershell -command "wget https://raw.githubusercontent.com/LSX285/windows11-ltsc-assets/main/App.bat -outfile C:\Windows\Web\LTSC\App.bat"
ECHO [+] Done. Open APP again.
timeout 3
exit


