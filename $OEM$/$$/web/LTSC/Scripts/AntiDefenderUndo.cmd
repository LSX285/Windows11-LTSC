@cls
@echo off
>nul chcp 437
setlocal enabledelayedexpansion
title Anti Defender ^(thanks freddie-o, geepnozeex, St1ckys, Bau^)

cls
cd /d "%~dp0"

:::: Run as administrator, AveYo: ps\vbs version
1>nul 2>nul fltmc || (
	set "_=call "%~f0" %*" & powershell -nop -c start cmd -args'/d/x/r',$env:_ -verb runas || (
	>"%temp%\Elevate.vbs" echo CreateObject^("Shell.Application"^).ShellExecute "%~dpf0", "%*" , "", "runas", 1
	>nul "%temp%\Elevate.vbs" & del /q "%temp%\Elevate.vbs" )
	exit)
	
2>nul powershell -nop -c "Add-MpPreference -ExclusionPath '%~dpnx0'"

>nul 2>&1 where wmic || (
	echo.
	echo Missing Critical files [wmic.exe]
	echo.
	pause
	exit /b
)

>nul 2>&1 where powershell || (
	echo.
	echo Missing Critical files [powershell.exe]
	echo.
	pause
	exit /b
)

rem == Destroy Defender Called from End OF Script
whoami|>nul findstr /i /c:"nt authority\system" && (
	echo.
	call :RunAtSystemLevel
	exit
)

echo:
echo If you have Home* Edition - 
echo Must Log Out / Log in, To refresh
echo Virus ^& threat protection Tab
echo:

echo == Enable Malicious Software Reporting Tool
echo == Enable Windows Defender Security Center Notifications
echo == Show Windows Security Systray
echo == Turn On Windows Defender
echo == Enable smartscreen
echo == Enable smartscreen for store and apps
echo == Enable smartscreen for microsoft edge

echo.
set Policies=HKLM\SOFTWARE\Policies

>nul 2>&1 REG delete "%Policies%\Microsoft\Windows Defender" /f
>nul 2>&1 REG delete "%Policies%\Microsoft\Windows Defender Security Center" /f

>nul 2>&1 REG delete "%Policies%\Microsoft\MRT" /f /v DontReportInfectionInformation
>nul 2>&1 REG delete "%Policies%\Microsoft\MRT" /f /v DontOfferThroughWUAU 
>nul 2>&1 REG delete "%Policies%\Microsoft\Windows\System" /f /v EnableSmartScreen
>nul 2>&1 REG delete "%Policies%\Microsoft\Internet Explorer\PhishingFilter" /f /v Enabled 
>nul 2>&1 REG delete "%Policies%\Microsoft\Internet Explorer\PhishingFilter" /f /v EnabledV8
>nul 2>&1 REG delete "%Policies%\Microsoft\Internet Explorer\PhishingFilter" /f /v EnabledV9
>nul 2>&1 REG delete "%Policies%\Policies\Microsoft\Windows\System" /f /v "AllowSmartScreen"

>nul 2>&1 REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /f /v SmartScreenEnabled /t REG_SZ /d "on"
>nul 2>&1 REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /f /v EnableWebContentEvaluation /t REG_DWORD /d "1"
>nul 2>&1 REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /f /v PreventOverride /t REG_DWORD /d "1"
>nul 2>&1 REG ADD "HKCU\SOFTWARE\Microsoft\Windows Security Health\State" /f /v AppAndBrowser_StoreAppsSmartScreenOff /t REG_DWORD /d "1"
>nul 2>&1 REG ADD "HKCU\SOFTWARE\Microsoft\Edge" /f /v SmartScreenEnabled /t REG_DWORD /d "1"
>nul 2>&1 REG ADD "HKCU\SOFTWARE\Microsoft\Edge" /f /v SmartScreenPuaEnabled /t REG_DWORD /d "1"
>nul 2>&1 REG ADD "HKCU\SOFTWARE\Microsoft\Windows Security Health\State" /f /v AppAndBrowser_EdgeSmartScreenOff /t REG_DWORD /d "1"

echo == Enable Malicious Software Reporting Tool
>nul 2>&1 reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MRT.exe" /f

echo == Restore Temper Protection
>nul 2>nul REG ADD "HKLM\SOFTWARE\Microsoft\Windows Defender" /f /v DisableAntiSpyware /t REG_DWORD /d 0
>nul 2>nul REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /f /v DisableAntiSpyware /t REG_DWORD /d 0
>nul 2>nul REG ADD "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /f /v DisableAntiSpyware /t REG_DWORD /d 0
>nul 2>nul REG ADD "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /f /v TamperProtection /t REG_DWORD /d 1

echo == Start Windows Defender Services [via mpcmdrun]
2>nul pushd "%ProgramFiles%\Windows Defender" && (
	start "" /MIN "mpcmdrun.exe" -EnableService
	start "" /MIN "mpcmdrun.exe" -wdEnable
	popd
	timeout 4 >nul
)

call :RunAsTI "%~dpf0"
timeout 10 /nobreak
start "" /wait "windowsdefender://ThreatSettings/"
exit

:RunAtSystemLevel
:RunAtSystemLevel
:RunAtSystemLevel

rem glitch ... using PS ... it work even with tampre on ... idea from geepnozeex
echo == Start Windows Defender Services [via PowerShell]
>nul 2>&1 powershell -ep bypass -nop -c "gwmi Win32_BaseService|where Name -Match 'WinDefend|Sense|WdBoot|WdFilter|WdNisSvc|WdNisDrv|wscsvc'|foreach {$_.StartService()}"
rem glitch ... using PS ... it work even with tampre on ... idea from geepnozeex

echo == Start Windows Defender Services [via SC]
for %%A IN (WinDefend,WdBoot,WdFilter,Sense,WdNisDrv,WdNisSvc,wscsvc) do (
	>nul 2>&1 sc config %%A start=auto
	>nul 2>&1 sc start %%A
)

timeout 4 /nobreak
goto :eof

:DestryFolder
set targetFolder=%*
if exist %targetFolder% (
    rd /s /q %targetFolder%
    if exist %targetFolder% (
        for /f "tokens=*" %%g in ('dir /b/s /a-d %targetFolder%') do move /y "%%g" "%temp%"
        rd /s /q %targetFolder%
    )
)
goto :eof

:export
rem AveYo's :export text attachments snippet
setlocal enabledelayedexpansion || Prints all text between lines starting with :NAME:[ and :NAME:] - A pure batch snippet by AveYo
set [=&for /f "delims=:" %%s in ('findstr/nbrc:":%~1:\[" /c:":%~1:\]" "%~f0"') do if defined [ (set/a ]=%%s-3) else set/a [=%%s-1
<"%~fs0" ((for /l %%i in (0 1 %[%) do set /p =)&for /l %%i in (%[% 1 %]%) do (set txt=&set /p txt=&echo(!txt!)) &endlocal &exit/b

:cson:[

#---------------------------------------------------------------
# Windows.10.Defender_Uninstall.ps1
# IMPORTANT: Run as Administrator or for the better as TrustedInstaller
# https://github.com/St1ckys/Stuff/blob/main/Windows.10.Defender_Uninstall.ps1
#---------------------------------------------------------------


Set-ItemProperty -Path "REGISTRY::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\*Windows-Defender*" -Name Visibility -Value "1"
Remove-Item -Path "REGISTRY::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\*Windows-Defender*" -Include *Owner* -Recurse -Force | Out-Null
Get-ChildItem -Path "REGISTRY::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\*Windows-Defender*" -Name | ForEach-Object  {dism /online /remove-package /PackageName:$_ /NoRestart}

:cson:]

#:RunAsTI: #1 snippet to run as TI/System, with /high priority, /priv ownership, explorer and HKCU load
set ^ #=& set "0=%~f0"& set 1=%*& powershell -nop -c iex(([io.file]::ReadAllText($env:0)-split':RunAsTI\:.*')[1])& exit/b
$_CAN_PASTE_DIRECTLY_IN_POWERSHELL='^,^'; function RunAsTI ($cmd) { $id='RunAsTI'; $sid=((whoami /user)-split' ')[-1]; $code=@'
$ti=(whoami /groups)-like"*1-16-16384*"; $DM=[AppDomain]::CurrentDomain."DefineDynamicAss`embly"(1,1)."DefineDynamicMod`ule"(1)
$D=@(); 0..5|% {$D+=$DM."DefineT`ype"("M$_",1179913,[ValueType])}; $I=[int32];$P=$I.module.gettype("System.Int`Ptr"); $U=[uintptr]
$D+=$U; 4..6|% {$D+=$D[$_]."MakeB`yRefType"()};$M=$I.module.gettype("System.Runtime.Interop`Services.Mar`shal");$Z=[uintptr]::size
$S=[string]; $F="kernel","advapi","advapi",($S,$S,$I,$I,$I,$I,$I,$S,$D[7],$D[8]),($U,$S,$I,$I,$D[9]),($U,$S,$I,$I,[byte[]],$I)
0..2|% {$9=$D[0]."DefinePInvokeMeth`od"(("CreateProcess","RegOpenKeyEx","RegSetValueEx")[$_],$F[$_]+'32',8214,1,$S,$F[$_+3],1,4)}
$DF=0,($P,$I,$P),($I,$I,$I,$I,$P,$D[1]),($I,$S,$S,$S,$I,$I,$I,$I,$I,$I,$I,$I,[int16],[int16],$P,$P,$P,$P),($D[3],$P),($P,$P,$I,$I)
1..5|% {$k=$_;$n=1;$AveYo=1; $DF[$_]|% {$9=$D[$k]."DefineFie`ld"('f'+$n++,$_,6)}}; $T=@(); 0..5|% {$T+=$D[$_]."CreateT`ype"()}
0..5|% {nv "A$_" ([Activator]::CreateInstance($T[$_])) -force}; function F ($1,$2) {$T[0]."GetMeth`od"($1).invoke(0,$2)};
if (!$ti) { $g=0; "TrustedInstaller","lsass"|% {if (!$g) {net1 start $_ 2>&1 >$null; $g=@(get-process -name $_ -ea 0|% {$_})[0]}}
 function M($1,$2,$3){$M."GetMeth`od"($1,[type[]]$2).invoke(0,$3)}; $H=@(); $Z,(4*$Z+16)|% {$H+=M "AllocHG`lobal" $I $_};
 M "WriteInt`Ptr" ($P,$P) ($H[0],$g.Handle); $A1.f1=131072;$A1.f2=$Z;$A1.f3=$H[0];$A2.f1=1;$A2.f2=1;$A2.f3=1;$A2.f4=1;$A2.f6=$A1
 $A3.f1=10*$Z+32;$A4.f1=$A3;$A4.f2=$H[1]; M "StructureTo`Ptr" ($D[2],$P,[boolean]) (($A2 -as $D[2]),$A4.f2,$false); $w=0x0E080600
 $out=@($null,"powershell -win 1 -nop -c iex `$env:A",0,0,0,$w,0,$null,($A4 -as $T[4]),($A5 -as $T[5])); F "CreateProcess" $out
} else { $env:A=''; $PRIV=[uri].module.gettype("System.Diagnostics.Process")."GetMeth`ods"(42) |? {$_.Name -eq "SetPrivilege"}
 "SeSecurityPrivilege","SeTakeOwnershipPrivilege","SeBackupPrivilege","SeRestorePrivilege" |% {$PRIV.Invoke(0, @("$_",2))}
 $HKU=[uintptr][uint32]2147483651; $LNK=$HKU; $reg=@($HKU,"S-1-5-18",8,2,($LNK -as $D[9])); F "RegOpenKeyEx" $reg; $LNK=$reg[4]
 function SYM($1,$2){$b=[Text.Encoding]::Unicode.GetBytes("\Registry\User\$1");@($2,"SymbolicLinkValue",0,6,[byte[]]$b,$b.Length)}
 F "RegSetValueEx" (SYM $(($key-split'\\')[1]) $LNK); $EXP="HKLM:\Software\Classes\AppID\{CDCBCFCA-3CDC-436f-A4E2-0E02075250C2}"
 $r="explorer"; if (!$cmd) {$cmd='C:\'}; $dir=test-path -lit ((($cmd -split '^("[^"]+")|^([^\s]+)') -ne'')[0].trim('"')) -type 1
 if (!$dir) {$r="start `"$id`" /high /w"}; sp $EXP RunAs '' -force; start cmd -args ("/q/x/d/r title $id && $r",$cmd) -wait -win 1
 do {sleep 7} while ((gwmi win32_process -filter 'name="explorer.exe"'|? {$_.getownersid().sid -eq "S-1-5-18"}))
 F "RegSetValueEx" (SYM ".Default" $LNK); sp $EXP RunAs "Interactive User" -force } # lean and mean snippet by AveYo, 2018-2021
'@; $key="Registry::HKEY_USERS\$sid\Volatile Environment"; $a1="`$id='$id';`$key='$key';";$a2="`$cmd='$($cmd-replace"'","''")';`n"
sp $key $id $($a1,$a2,$code) -type 7 -force; $arg="$a1 `$env:A=(gi `$key).getvalue(`$id)-join'';rp `$key `$id -force; iex `$env:A"
$_PRESS_ENTER='^,^'; start powershell -args "-win 1 -nop -c $arg" -verb runas }; <#,#>  RunAsTI $env:1;  #:RunAsTI:

:reg_own #key [optional] all user owner access permission  :        call :reg_own "HKCU\My" "" S-1-5-32-544 "" Allow FullControl
powershell -nop -c $A='%~1','%~2','%~3','%~4','%~5','%~6';iex(([io.file]::ReadAllText('%~f0')-split':Own1\:.*')[1])&exit/b:Own1:
$D1=[uri].module.gettype('System.Diagnostics.Process')."GetM`ethods"(42) |where {$_.Name -eq 'SetPrivilege'} #`:no-ev-warn
'SeSecurityPrivilege','SeTakeOwnershipPrivilege','SeBackupPrivilege','SeRestorePrivilege'|foreach {$D1.Invoke($null, @("$_",2))}
$path=$A[0]; $rk=$path-split'\\',2; $HK=gi -lit Registry::$($rk[0]) -fo; $s=$A[1]; $sps=[Security.Principal.SecurityIdentifier]
$u=($A[2],'S-1-5-32-544')[!$A[2]];$o=($A[3],$u)[!$A[3]];$w=$u,$o |% {new-object $sps($_)}; $old=!$A[3];$own=!$old; $y=$s-eq'all'
$rar=new-object Security.AccessControl.RegistryAccessRule( $w[0], ($A[5],'FullControl')[!$A[5]], 1, 0, ($A[4],'Allow')[!$A[4]] )
$x=$s-eq'none';function Own1($k){$t=$HK.OpenSubKey($k,2,'TakeOwnership');if($t){0,4|%{try{$o=$t.GetAccessControl($_)}catch{$old=0}
};if($old){$own=1;$w[1]=$o.GetOwner($sps)};$o.SetOwner($w[0]);$t.SetAccessControl($o); $c=$HK.OpenSubKey($k,2,'ChangePermissions')
$p=$c.GetAccessControl(2);if($y){$p.SetAccessRuleProtection(1,1)};$p.ResetAccessRule($rar);if($x){$p.RemoveAccessRuleAll($rar)}
$c.SetAccessControl($p);if($own){$o.SetOwner($w[1]);$t.SetAccessControl($o)};if($s){$subkeys=$HK.OpenSubKey($k).GetSubKeyNames()
foreach($n in $subkeys){Own1 "$k\$n"}}}};Own1 $rk[1];if($env:VO){get-acl Registry::$path|fl} #:Own1: lean & mean snippet by AveYo
::-_-::