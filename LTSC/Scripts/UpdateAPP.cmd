@echo off
timeout 1 >nul 2>&1
attrib -r  C:\Program Files\LTSC\*.* /s >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/App.cmd', 'C:\Program Files\LTSC\App.cmd')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP Updater','APP has been updated to the latest version.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
"C:\Program Files\LTSC\App.cmd"
exit


