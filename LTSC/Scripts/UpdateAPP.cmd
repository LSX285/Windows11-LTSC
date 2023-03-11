@echo off
timeout 1 >nul 2>&1
attrib -r  C:\Program Files\LTSC\*.* /s >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/App.cmd', 'C:\Program Files\LTSC\App.cmd')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/setup.cmd', 'C:\Program Files\LTSC\setup.cmd')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/activate.cmd', 'C:\Program Files\LTSC\Scripts\activate.cmd')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/AntiDefender.cmd', 'C:\Program Files\LTSC\Scripts\AntiDefender.cmd')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/AntiDefenderUndo.cmd', 'C:\Program Files\LTSC\Scripts\AntiDefenderUndo.cmd')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/CleanFiles.cmd', 'C:\Program Files\LTSC\Scripts\CleanFiles.cmd')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/Edge_Uninstall.cmd', 'C:\Program Files\LTSC\Scripts\Edge_Uninstall.cmd')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/reapplyLTSC.cmd', 'C:\Program Files\LTSC\Scripts\reapplyLTSC.cmd')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/tweaks.reg', 'C:\Program Files\LTSC\Scripts\tweaks.reg')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/UpdateAPP.cmd', 'C:\Program Files\LTSC\Scripts\UpdateAPP.cmd')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/ViveTool/Albacore.ViVe.dll', 'C:\Program Files\LTSC\Scripts\ViveTool\Albacore.ViVe.dll')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/ViveTool/FeatureDictionary.pfs', 'C:\Program Files\LTSC\Scripts\ViveTool\FeatureDictionary.pfs')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/ViveTool/Newtonsoft.Json.dll', 'C:\Program Files\LTSC\Scripts\ViveTool\Newtonsoft.Json.dll')" >nul 2>&1
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/ViveTool/ViVeTool.exe', 'C:\Program Files\LTSC\Scripts\ViveTool\ViVeTool.exe')" >nul 2>&1
powershell -Command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'APP Updater','APP and its components have been updated to the latest version.',[system.windows.forms.tooltipicon]::None)" >nul 2>&1
"C:\Program Files\LTSC\App.cmd"
exit


