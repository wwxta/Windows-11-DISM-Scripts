mode con:cols=50 lines=1
title Start work...
call :PostClear>>%userprofile%\Desktop\PostClear.log 2>&1
EXIT /b 0
:PostClear
title Wait Explorer
taskkill /f /im explorer.exe
if exist %programdata%\PostClear\FirstLoad.reg (
	title Applying FirstLoad.reg
	%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\reg.exe /CommandLine "import %programdata%\PostClear\FirstLoad.reg" /RunAs 8 /WaitProcess 1 /Run
	title Deleting Defender tasks
	schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /f
	schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /f
	schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /f
	schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Verification" /f
	TIMEOUT /T 1 /NOBREAK >nul
	del /f /q %programdata%\PostClear\FirstLoad.reg
	title Start Explorer
	start %windir%\explorer.exe
	TIMEOUT /T 2 /NOBREAK >nul
	goto Reboot
)
if exist %programdata%\PostClear\PostClearM.bat (
	call %programdata%\PostClear\PostClearM.bat
) else (
	for /F "skip=1 tokens=2*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\InstallService" /V Start') do (if %%B equ 0x4 (title Press any key && start cmd /c "mode con:cols=60 lines=3 && title AppX Warning && echo off && echo "Microsoft Store Install Service" is Disabled! && echo Before create new account you must Enable AppX support. && pause" && pause))
	TIMEOUT /T 1 /NOBREAK >nul
)
title Applying PostClear.reg
reg import %programdata%\PostClear\PostClear.reg
TIMEOUT /T 1 /NOBREAK >nul
if exist %programdata%\PostClear\PostClearM.bat (
	title Install CustomStart	
	!7z.exe /q INSTALLDIR="C:\Program Files\7-Zip" INSTALLLEVEL=1 
	"C:\Program Files\7-Zip\7z.exe" x "%programdata%\PostClear\38.7z"
	powercfg -import "%programdata%\Postclear\power.pow" 77777777-7777-7777-7777-777777777777
	powercfg -SETACTIVE "77777777-7777-7777-7777-777777777777"
	powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e
	powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 
	powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a
	del /f /q %programdata%\PostClear\PostClearM.bat
	start /w %programdata%\PostClear\vcredist_x64.exe /quiet
	start /w %programdata%\PostClear\vcredist_x86.exe /quiet
	TIMEOUT /T 2 /NOBREAK >nul
	start /w %programdata%\PostClear\STR.exe -install
	sc config STR start=auto
	net start STR
	TIMEOUT /T 2 /NOBREAK >nul
	reg import %programdata%\PostClear\_RegistryTweaks.reg
	!start /w %programdata%\PostClear\nvidia.exe	
	TIMEOUT /T 2 /NOBREAK >nul
	title 33 
	TIMEOUT /T 4 /NOBREAK >nul
	call %programdata%\PostClear\38.cmd
	start %windir%\explorer.exe
	start /w %programdata%\PostClear\NvidiaProfileInspector.exe "%programdata%\PostClear\NvidiaBaseProfile.nip" -silent
	TIMEOUT /T 2
	sysdm.cpl
	!title simplewall_steam
	!ix
	PAUSE
	TIMEOUT /T 2 /NOBREAK >nul
	lodctr /r
	lodctr /r	
	start /w %programdata%\PostClear\cru.exe 
	start /w %programdata%\PostClear\msi.exe
	%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\cmd.exe /CommandLine "call del.bat"
	%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\reg.exe /CommandLine "import %programdata%\PostClear\disable.reg" /RunAs 4 /WaitProcess 1 /Run
	call %programdata%\PostClear\destroy.txt
	%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\cmd.exe /CommandLine "regedit" /RunAs 4 /WaitProcess 1 /Run	
	cleanmgr /verylowdisk
) else (
	title meme
	del /f /q %programdata%\PostClear\AdvancedRun.exe
	!%programdata%\PostClear\AdvancedRun.exe /EXEFilename "" /RunAs 4 /WaitProcess 1 /Run	
)

:Reboot
title Rebooting...
SHUTDOWN -r -t 3
