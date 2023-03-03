mode con:cols=50 lines=1
title Start work...

call :Clear>>C:\11\Clear.log 2>&1
EXIT /b 0

:Clear
title Mount boot.wim
mkdir C:\11\boot
dism /mount-image /imagefile:C:\11\boot.wim /index:2 /mountdir:C:\11\boot
title Load registry
reg load HKEY_LOCAL_MACHINE\WIM_BOOT C:\11\boot\Windows\System32\config\SYSTEM
TIMEOUT /T 1 /NOBREAK >nul
title Disable TPM check
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassCPUCheck /t REG_DWORD /d 1
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassTPMCheck /t REG_DWORD /d 1
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassRAMCheck /t REG_DWORD /d 1
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassSecureBootCheck /t REG_DWORD /d 1
TIMEOUT /T 1 /NOBREAK >nul
title Unload registry
reg unload HKEY_LOCAL_MACHINE\WIM_BOOT
TIMEOUT /T 1 /NOBREAK >nul
title Unmount boot.wim
dism /unmount-wim /mountdir:C:\11\boot /commit
TIMEOUT /T 1 /NOBREAK >nul
title Compress boot.wim
start /w C:\11\WimOptimize.exe C:\11\boot.wim
title Applying Clear.ps1
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -File C:\11\Clear.ps1
title Load registry
reg load HKEY_LOCAL_MACHINE\WIM_SOFTWARE C:\11\Install\Windows\System32\config\SOFTWARE
reg load HKEY_LOCAL_MACHINE\WIM_SYSTEM C:\11\Install\Windows\System32\config\SYSTEM
reg load HKEY_LOCAL_MACHINE\WIM_CURRENT_USER C:\11\Install\Users\Default\NTUSER.DAT
TIMEOUT /T 1 /NOBREAK >nul
title Applying Clear.reg
reg import C:\11\Clear.reg
title Remove protect
set KEYSLIST=HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.AllAppsDesktopApplication HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.Computer HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.DesktopPackagedApplication HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.ImmersiveApplication HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.SystemSettings HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\IE.AssocFile.WEBSITE HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Microsoft.Website
for %%a in (%KEYSLIST%) do (
	reg export %%a\shellex\ContextMenuHandlers C:\11\_temp.reg /y
	C:\11\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\reg.exe /CommandLine "delete %%a\shellex\ContextMenuHandlers /f" /RunAs 8 /WaitProcess 1 /Run
	C:\11\PostClear\AdvancedRun.exe /EXEFilename C:\11\SubinAcl.exe  /CommandLine "/keyreg %%a\shellex /grant=S-1-5-18=F" /RunAs 8 /WaitProcess 1 /Run
	C:\11\PostClear\AdvancedRun.exe /EXEFilename C:\11\SubinAcl.exe  /CommandLine "/keyreg %%a\shellex /grant=S-1-5-32-544=F" /RunAs 8 /WaitProcess 1 /Run
	reg import C:\11\_temp.reg
	del /f /q C:\11\_temp.reg
)
title Disable Secondary Logs
for /f "tokens=*" %%a in ('reg QUERY "HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels"') do (
	reg add "%%a" /v Enabled /t REG_DWORD /d 0 /f
)
TIMEOUT /T 1 /NOBREAK >nul
title Unload registry
reg unload HKEY_LOCAL_MACHINE\WIM_CURRENT_USER
reg unload HKEY_LOCAL_MACHINE\WIM_SYSTEM
reg unload HKEY_LOCAL_MACHINE\WIM_SOFTWARE
title Hide NTUSER.DAT
ATTRIB C:\11\Install\Users\Default\NTUSER.DAT +S +H
title Shortcuts
move "C:\11\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\Character Map.lnk" "C:\11\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools"
set DEL="C:\11\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools\desktop.ini"
type %DEL%>>%DEL%.temp
del /f /q /a:sh %DEL%
move %DEL%.temp %DEL%
echo Character Map.lnk=@%SystemRoot%\system32\shell32.dll,-22021>>%DEL%
ATTRIB %DEL% +S +H
rd /s /q "C:\11\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools"
move "C:\11\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell ISE.lnk" "C:\11\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools"
rd /s /q "C:\11\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell"
rd /s /q "C:\11\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Maintenance"
move "C:\11\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" "C:\11\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools"
rd /s /q "C:\11\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell"
rd /s /q "C:\11\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Maintenance"
set DEL="C:\11\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\desktop.ini"
type %DEL%>>%DEL%.temp
del /f /q /a:sh %DEL%
move %DEL%.temp %DEL%
echo Administrative Tools.lnk=@%SystemRoot%\system32\shell32.dll,-21762>>%DEL%
echo File Explorer.lnk=@%SystemRoot%\system32\shell32.dll,-22067>>%DEL%
ATTRIB %DEL% +S +H
set DEL="C:\11\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\desktop.ini"
ATTRIB %DEL% -S -H
del /f /q %DEL%
move "C:\11\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Administrative Tools.lnk" "C:\11\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Administrative Tools.lnk"
move "C:\11\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\File Explorer.lnk" "C:\11\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk"
attrib +r -s -h "C:\11\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Accessories" /S /D
title EdgeUpdate
rd /s /q "C:\11\Install\Program Files (x86)\Microsoft\EdgeUpdate"
rd /s /q "C:\11\Install\Program Files (x86)\Microsoft\EdgeCore\100.0.1185.36"
rd /s /q "C:\11\Install\Program Files (x86)\Microsoft\EdgeWebView\Application\100.0.1185.36"
rd /s /q "C:\11\Install\Program Files (x86)\Microsoft\Edge\Application\100.0.1185.36\Installer"
del /f /q "C:\11\Install\Program Files (x86)\Microsoft\Edge\Application\100.0.1185.36\elevation_service.exe"
del /f /q "C:\11\Install\Program Files (x86)\Microsoft\Edge\Application\100.0.1185.36\notification_helper.exe"
del /f /q "C:\11\Install\Program Files (x86)\Microsoft\Edge\Application\100.0.1185.36\notification_helper.exe.manifest"
title Disable Appx Protect
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path C:\11\Install\Windows | Set-Acl -Path 'C:\11\Install\Program Files\WindowsApps'"
title OneDrive
takeown /f C:\11\Install\Windows\WinSxS\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.22621.1_none_86d60ce019ce7baf
icacls C:\11\Install\Windows\WinSxS\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.22621.1_none_86d60ce019ce7baf /grant "%username%":f /c /l /q
rd /s /q C:\11\Install\Windows\WinSxS\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.22621.1_none_86d60ce019ce7baf
set DELETELIST=C:\11\Install\Windows\System32\OneDriveSetup.exe C:\11\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.22621.1_none_86d60ce019ce7baf.manifest C:\11\Install\Windows\WinSxS\SettingsManifests\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.22621.1_none_86d60ce019ce7baf.manifest C:\11\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-onedrive-setupregistry_31bf3856ad364e35_10.0.22621.1_none_51812954380458e2.manifest C:\11\Install\Windows\WinSxS\Manifests\wow64_microsoft-windows-onedrive-setupregistry_31bf3856ad364e35_10.0.22621.1_none_5bd5d3a66c651add.manifest C:\11\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.22621.1.cat C:\11\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.22621.1.mum C:\11\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.cat C:\11\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.mum C:\11\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.22621.1.cat C:\11\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.22621.1.mum C:\11\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.cat C:\11\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.mum C:\11\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.22621.1.cat C:\11\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.cat C:\11\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.22621.1.cat C:\11\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.cat
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	del /f /q %%a
)
title UPFC
set DEL=C:\11\Install\Windows\System32\upfc.exe
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move C:\11\upfc.exe C:\11\Install\Windows\System32
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path C:\11\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
set DEL=C:\11\Install\Windows\WinSxS\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.22621.1_none_08bb51571021559f
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=C:\11\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.22621.1_none_08bb51571021559f.manifest
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
title Calc
set DELETELIST=C:\11\Install\Windows\WinSxS\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.22621.1_none_0b53ccef0e7a283c C:\11\Install\Windows\WinSxS\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.22621.1_none_15a8774142daea37
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	rd /s /q %%a
)
set DELETELIST=C:\11\Install\Windows\System32\calc.exe C:\11\Install\Windows\SysWOW64\calc.exe C:\11\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.22621.1_none_0b53ccef0e7a283c.manifest C:\11\Install\Windows\WinSxS\Manifests\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.22621.1_none_15a8774142daea37.manifest
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	del /f /q %%a
)
title GameDVR
set DEL="C:\11\Install\Windows\bcastdvr\KnownGameList.bin"
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move C:\11\KnownGameList.bin %DEL%
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path C:\11\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
title WaaS tasks
set DELETELIST=C:\11\Install\Windows\WaaS\regkeys C:\11\Install\Windows\WaaS\services C:\11\Install\Windows\WaaS
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	rd /s /q %%a
)
set DELETELIST=C:\11\Install\Windows\WinSxS\FileMaps\$$_waas_regkeys_dbffc348a6fab71c.cdf-ms C:\11\Install\Windows\WinSxS\FileMaps\$$_waas_services_ddfc4ae175ff1678.cdf-ms
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	del /f /q %%a
)
title Clear WinSxS
for /f "tokens=*" %%i in ('dir C:\11\Install\Windows\WinSxS\Backup /b /a:-d') do (
	icacls "C:\11\Install\Windows\WinSxS\Backup\%%~i" /grant "%username%":f /c /l /q
	del /f /q "C:\11\Install\Windows\WinSxS\Backup\%%~i"
)
title Compress Winre
start /w C:\11\WimOptimize.exe C:\11\Install\Windows\System32\Recovery\Winre.wim
TIMEOUT /T 1 /NOBREAK >nul
title Copy PostClear
if not exist C:\11\Install\Windows\ru-RU\explorer.exe.mui (
	del /f /q C:\11\PostClear\Help.chm
)
move C:\11\PostClear C:\11\Install\ProgramData\PostClear
title Unmounting
dism /unmount-wim /mountdir:C:\11\Install /commit
title Done...
mkdir C:\11\done 
move C:\11\Clear.ps1 C:\11\done
move C:\11\Clear.reg C:\11\done
move C:\11\SubinAcl.exe C:\11\done
move C:\11\WimOptimize.exe C:\11\done
move C:\11\_Clear.bat C:\11\done
set DEL="C:\11\Install"
rd /s /q %del%
set DEL="C:\11\boot"
rd /s /q %del%
