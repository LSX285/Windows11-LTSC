@echo off

set ltscdir=C:\Program Files\LTSC
set repository=https://github.com/LSX285/Windows11-LTSC/raw/main

timeout 1 >nul 2>&1
attrib -r  %ltscdir%\*.* /s >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/LTSC/App.cmd', '%ltscdir%\App.cmd')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP Updater','APP and its components have been updated to the latest version.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
"%ltscdir%\App.cmd"
exit


