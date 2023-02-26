@echo off
timeout 1 >nul 2>&1
ECHO [[93m-[0m] [93mUpdating APP[0m ...
attrib -r  C:\Program Files\LTSC\*.* /s >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/App.bat', 'C:\Program Files\LTSC\App.bat')" >nul 2>&1
ECHO [[92m+[0m] Done.
timeout 2 >nul 2>&1
"C:\Program Files\LTSC\App.bat"
exit


