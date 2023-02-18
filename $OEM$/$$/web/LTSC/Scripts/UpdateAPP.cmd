timeout 3 >nul 2>&1
ECHO [-] Updating APP ...
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/windows11-ltsc-assets/main/App.bat', 'C:\Windows\Web\LTSC\App.bat')" >nul 2>&1
timeout 3 >nul 2>&1
exit