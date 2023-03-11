#Defining preferences variables
Write-Output "Loading config"
$config = (Get-Content ".\tools\config.json" -Raw) | ConvertFrom-Json
$wantedImageName = $config.WantedWindowsEdition
$unwantedProvisionnedPackages = $config.ProvisionnedPackagesToRemove
$unwantedWindowsPackages = $config.WindowsPackagesToRemove
$unwantedWindowsFeatures = $config.WindowsFeaturesToRemove
$pathsToDelete = $config.PathsToDelete

#Defining variables
Write-Output "Creating variables"
$rootWorkdir = "c:\LTSC\"
$isoFolder = $rootWorkdir + "iso\"
$mountFolder = $rootWorkdir + "mount\"
$isoPath = "c:\windows.iso"

function Load-RegistryHives {
    $username = $env:USERNAME
    reg load HKLM\zCOMPONENTS "C:\LTSC\mount\Windows\System32\config\COMPONENTS" | Out-Null
    reg load HKLM\zDEFAULT "C:\LTSC\mount\Windows\System32\config\default" | Out-Null
    reg load HKLM\zNTUSER "C:\LTSC\mount\Users\Default\ntuser.dat" | Out-Null
    reg load HKLM\zSOFTWARE "C:\LTSC\mount\Windows\System32\config\SOFTWARE" | Out-Null
    reg load HKLM\zSYSTEM "C:\LTSC\mount\Windows\System32\config\SYSTEM" | Out-Null
}

function Unload-RegistryHives {
    reg unload HKLM\zCOMPONENTS | Out-Null
    reg unload HKLM\zDEFAULT | Out-Null
    reg unload HKLM\zNTUSER | Out-Null
    reg unload HKLM\zSOFTWARE | Out-Null
    reg unload HKLM\zSYSTEM | Out-Null
}

#Mount the original Windows ISO
Write-Output "Mounting original iso"
$mountResult = Mount-DiskImage -ImagePath $isoPath
$isoDriveLetter = ($mountResult | Get-Volume).DriveLetter

#Creating folders
Write-Output "Creating folders"
md $rootWorkdir | Out-Null
md $isoFolder | Out-Null
md $mountFolder | Out-Null

#Copying ISO files to the ISO folder
Write-Output "Copying files of original iso"
cp -Recurse ($isoDriveLetter + ":\*") $isoFolder | Out-Null

#Unmounting the original ISO since we don't need it anymore (we have a copy of the content)
Write-Output "Unmounting original iso"
Dismount-DiskImage -ImagePath $isoPath | Out-Null

#Getting the wanted image index
$wantedImageIndex = Get-WindowsImage -ImagePath ($isoFolder + "sources\install.wim") | where-object { $_.ImageName -eq $wantedImageName } | Select-Object -ExpandProperty ImageIndex

#Mounting the WIM image
Write-Output "Mounting install.wim image"
Set-ItemProperty -Path ($isoFolder + "sources\install.wim") -Name IsReadOnly -Value $false | Out-Null
Mount-WindowsImage -ImagePath ($isoFolder + "sources\install.wim") -Path $mountFolder -Index $wantedImageIndex | Out-Null

#Detecting provisionned app packages
Write-Output "Removing app packages from install.wim image"
$detectedProvisionnedPackages = Get-AppxProvisionedPackage -Path $mountFolder

#Removing provisionned app packages
Foreach ($detectedProvisionnedPackage in $detectedProvisionnedPackages)
{
	Foreach ($unwantedProvisionnedPackage in $unwantedProvisionnedPackages)
	{
		If ($detectedProvisionnedPackage.PackageName.Contains($unwantedProvisionnedPackage))
		{
			Remove-AppxProvisionedPackage -Path $mountFolder -PackageName $detectedProvisionnedPackage.PackageName -ErrorAction SilentlyContinue | Out-Null
		}
	}
}

#Detecting windows packages
Write-Output "Removing windows packages from the install.wim image"
$detectedWindowsPackages = Get-WindowsPackage -Path $mountFolder

#Removing windows packages
Foreach ($detectedWindowsPackage in $detectedWindowsPackages)
{
	Foreach ($unwantedWindowsPackage in $unwantedWindowsPackages)
	{
		If ($detectedWindowsPackage.PackageName.Contains($unwantedWindowsPackage))
		{
			Remove-WindowsPackage -Path $mountFolder -PackageName $detectedWindowsPackage.PackageName -ErrorAction SilentlyContinue | Out-Null
		}
	}
}

#Detecting windows features
Write-Output "Removing windows features from install.wim image"
$detectedWindowsFeatures = Get-WindowsOptionalFeature -Path $mountFolder

#Removing windows packages
Foreach ($detectedWindowsFeature in $detectedWindowsFeatures)
{
	Foreach ($unwantedWindowsFeature in $unwantedWindowsFeatures)
	{
		If ($detectedWindowsFeature.FeatureName.Contains($unwantedWindowsFeature))
		{
			Disable-WindowsOptionalFeature -Path $mountFolder -FeatureName $detectedWindowsFeature.FeatureName -ErrorAction SilentlyContinue | Out-Null
		}
	}
}

Write-Output "Deleting additional files"
Foreach ($pathToDelete in $pathsToDelete)
{
	$fullpath = ($mountFolder + $pathToDelete.Path)

	If ($pathToDelete.IsFolder -eq $true)
	{
		takeown /f $fullpath /r /d $yes | Out-Null
		icacls $fullpath /grant ("$env:username"+":F") /T /C | Out-Null
		Remove-Item -Force $fullpath -Recurse -ErrorAction SilentlyContinue | Out-Null
	}
	Else
	{
		takeown /f $fullpath | Out-Null
		icacls $fullpath /grant ("$env:username"+":F") /T /C | Out-Null
		Remove-Item -Force $fullpath -ErrorAction SilentlyContinue | Out-Null
	}
}

# Loading the registry hive from the mounted WIM image
Load-RegistryHives

# Disable compatibility checks
Write-Output "Disabling hardware compatibility checks on install image"
Reg add "HKLM\zDEFAULT\Control Panel\UnsupportedHardwareNotificationCache" /v "SV1" /t REG_DWORD /d "0" /f | Out-Null
Reg add "HKLM\zDEFAULT\Control Panel\UnsupportedHardwareNotificationCache" /v "SV2" /t REG_DWORD /d "0" /f | Out-Null
Reg add "HKLM\zNTUSER\Control Panel\UnsupportedHardwareNotificationCache" /v "SV1" /t REG_DWORD /d "0" /f | Out-Null
Reg add "HKLM\zNTUSER\Control Panel\UnsupportedHardwareNotificationCache" /v "SV2" /t REG_DWORD /d "0" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /t REG_DWORD /d "1" /f | Out-Null

# Apply tweaks
regedit /s ./tools/Registry.reg | Out-Null

# Unloading the registry hive from the mounted WIM image
Unload-RegistryHives

# Deploying LTSC files to mounted WIM image
Write-Output "Deploying LTSC"
New-Item -ItemType Directory -Path "C:\LTSC\mount\Program Files\LTSC" | Out-Null
New-Item -ItemType Directory -Path "C:\LTSC\mount\Program Files\LTSC\Scripts" | Out-Null
New-Item -ItemType Directory -Path "C:\LTSC\mount\Program Files\LTSC\Scripts\ViveTool" | Out-Null
New-Item -ItemType Directory -Path "C:\LTSC\mount\Program Files\LTSC\AdditionalFiles" | Out-Null
New-Item -ItemType Directory -Path "C:\LTSC\mount\Program Files\LTSC\AdditionalFiles\RepairWin" | Out-Null
New-Item -ItemType Directory -Path "C:\LTSC\mount\Windows\Setup\Scripts" | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/setup.cmd', 'C:\LTSC\mount\Program Files\LTSC\setup.cmd') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/App.cmd', 'C:\LTSC\mount\Program Files\LTSC\App.cmd') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/hosts', 'C:\LTSC\mount\Windows\System32\drivers\etc\hosts') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/SetupComplete.cmd', 'C:\LTSC\mount\Windows\Setup\Scripts\SetupComplete.cmd') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/AntiDefender.cmd', 'C:\LTSC\mount\Program Files\LTSC\Scripts\AntiDefender.cmd') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/reapplyLTSC.cmd', 'C:\LTSC\mount\Program Files\LTSC\Scripts\reapplyLTSC.cmd') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/tweaks.reg', 'C:\LTSC\mount\Program Files\LTSC\Scripts\tweaks.reg') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/AntiDefenderUndo.cmd', 'C:\LTSC\mount\Program Files\LTSC\Scripts\AntiDefenderUndo.cmd') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/CleanFiles.cmd', 'C:\LTSC\mount\Program Files\LTSC\Scripts\CleanFiles.cmd') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/Edge_Uninstall.cmd', 'C:\LTSC\mount\Program Files\LTSC\Scripts\Edge_Uninstall.cmd') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/UpdateAPP.cmd', 'C:\LTSC\mount\Program Files\LTSC\Scripts\UpdateAPP.cmd') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/activate.cmd', 'C:\LTSC\mount\Program Files\LTSC\Scripts\activate.cmd') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/LTSC/Scripts/ViveTool/Albacore.ViVe.dll', 'C:\LTSC\mount\Program Files\LTSC\Scripts\ViveTool\Albacore.ViVe.dll') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LSX285/Windows11-LTSC/main/LTSC/Scripts/ViveTool/FeatureDictionary.pfs', 'C:\LTSC\mount\Program Files\LTSC\Scripts\ViveTool\FeatureDictionary.pfs') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/LTSC/Scripts/ViveTool/Newtonsoft.Json.dll', 'C:\LTSC\mount\Program Files\LTSC\Scripts\ViveTool\Newtonsoft.Json.dll') | Out-Null
(New-Object Net.WebClient).DownloadFile('https://github.com/LSX285/Windows11-LTSC/raw/main/LTSC/Scripts/ViveTool/ViVeTool.exe', 'C:\LTSC\mount\Program Files\LTSC\Scripts\ViveTool\ViVeTool.exe') | Out-Null

#Unmount install.wim image
Write-Output "Unmounting install.wim image"
Dismount-WindowsImage -Path $mountFolder -Save | Out-Null

#Moving wanted image index to a new image
Write-Output "Creating clean install.wim image"
Export-WindowsImage -SourceImagePath ($isoFolder + "sources\install.wim") -SourceIndex $wantedImageIndex -DestinationImagePath ($isoFolder + "sources\install_patched.wim") -CompressionType max | Out-Null

#Delete old install.wim and rename new one
rm ($isoFolder + "sources\install.wim") | Out-Null
Rename-Item -Path ($isoFolder + "sources\install_patched.wim") -NewName "install.wim" | Out-Null

#Mount Boot image
Set-ItemProperty -Path ($isoFolder + "sources\boot.wim") -Name IsReadOnly -Value $false | Out-Null
Write-Output "Mounting boot.wim image"
Mount-WindowsImage -ImagePath ($isoFolder + "sources\boot.wim") -Path $mountFolder -Index 2 | Out-Null

# Loading the registry hive from the mounted WIM image
Load-RegistryHives

# Disable compatibility checks
Write-Output "Disabling hardware compatibility checks on boot image"
Reg add "HKLM\zDEFAULT\Control Panel\UnsupportedHardwareNotificationCache" /v "SV1" /t REG_DWORD /d "0" /f | Out-Null
Reg add "HKLM\zDEFAULT\Control Panel\UnsupportedHardwareNotificationCache" /v "SV2" /t REG_DWORD /d "0" /f | Out-Null
Reg add "HKLM\zNTUSER\Control Panel\UnsupportedHardwareNotificationCache" /v "SV1" /t REG_DWORD /d "0" /f | Out-Null
Reg add "HKLM\zNTUSER\Control Panel\UnsupportedHardwareNotificationCache" /v "SV2" /t REG_DWORD /d "0" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f | Out-Null
Reg add "HKLM\zSYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /t REG_DWORD /d "1" /f | Out-Null

# Unloading the registry hive from the mounted WIM image
Unload-RegistryHives

#Unmount the boot image
Write-Output "Unmounting boot.wim image"
Dismount-WindowsImage -Path $mountFolder -Save | Out-Null

#Compressing install.wim to install.esd
Write-Output "Compressing image files. This may take a while. 10-50 Minutes."
Dism /Export-Image /SourceImageFile:"C:\LTSC\iso\sources\install.wim" /SourceIndex:1 /DestinationImageFile:"C:\LTSC\iso\sources\install.esd" /Compress:Recovery /CheckIntegrity | Out-Null
Remove-Item -Path "C:\LTSC\iso\sources\install.wim" | Out-Null
Remove-Item -Path $mountFolder -Recurse -Force | Out-Null

#Building LTSC iso
.\tools\oscdimg.exe -m -o -u2 -udfver102 -bootdata:("2#p0,e,b" + $isoFolder + "boot\etfsboot.com#pEF,e,b" + $isoFolder + "efi\microsoft\boot\efisys.bin") $isoFolder c:\LTSC.iso | Out-Null
[reflection.assembly]::loadwithpartialname('System.Windows.Forms'); [reflection.assembly]::loadwithpartialname('System.Drawing'); $notify = new-object system.windows.forms.notifyicon; $notify.icon = [System.Drawing.SystemIcons]::WinLogo; $notify.visible = $true; $notify.showballoontip(10,'LTSC Builder','Done. Your LTSC Iso is ready.',[system.windows.forms.tooltipicon]::None) | Out-Null
Remove-Item -Path $rootWorkdir -Recurse -Force | Out-Null
exit