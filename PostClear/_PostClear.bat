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
	
	title  eth
	!start /w devmgmt.msc
	
	TIMEOUT /T 2 /NOBREAK >nul
	!title sw 
	for /f "tokens=4" %%a in ('dir /a-d /o-d') do @echo %%a|find "simplewall" && (set vartmp=%%a)
	start /w %programdata%\PostClear\7za.exe" x "%programdata%\PostClear\%vartmp%"
	ren "%programdata%\PostClear\%vartmp%\simplewall\64" "simplewall"
	robocopy "%programdata%\PostClear\%vartmp%\simplewall\simplewall" "%programdata%\PostClear\" /NFL /NDL /NJH /NJS /nc /ns /np /E /MOVE
	rd /s /q "%programdata%\PostClear\%vartmp%\"
	%programdata%\PostClear\simplewall\simplewall.exe -install -silent 

	TIMEOUT /T 2 /NOBREAK >nul
	title www
	start /w %programdata%\PostClear\wget --tries=inf w3.org
	del /f /q %programdata%\PostClear\index.html
	call %programdata%\PostClear\wget.cmd
	
	TIMEOUT /T 2 /NOBREAK >nul
	title 7z
	start /w %programdata%\PostClear\7z.exe /S
	start /w %programdata%\PostClear\7za.exe" x "%programdata%\PostClear\38.7z"
	
	TIMEOUT /T 2 /NOBREAK >nul
	title wd
	move "%programdata%\PostClear\windirstat.lnk" "C:\Users\admin\Desktop\"
	reg import %programdata%\PostClear\windirstat.reg
	
	TIMEOUT /T 2 /NOBREAK >nul
	title nvidia
	start /w %programdata%\PostClear\NVCleanstall_1.15.1.exe
	
	TIMEOUT /T 2 /NOBREAK >nul
	title ph
	for /f "tokens=4" %%a in ('dir /a-d /o-d') do @echo %%a|find "systeminformer" && (set vartmp=%%a)
	start /w %programdata%\PostClear\7za.exe x -y -oC:\programdata\PostClear\ C:\programdata\PostClear\%vartmp%.zip * -aoa -r
	ren "%programdata%\PostClear\%vartmp%\amd64" "systeminformer"
	robocopy "%programdata%\PostClear\%vartmp%\systeminformer\" "%programdata%\PostClear\" /NFL /NDL /NJH /NJS /nc /ns /np /E /MOVE
	rd /s /q "%programdata%\PostClear\%vartmp%\"
	rd /s /q "%programdata%\PostClear\systeminformer\x86"
	reg import %programdata%\PostClear\IFEO.reg
	
	TIMEOUT /T 2 /NOBREAK >nul
	title pp
	powercfg -import "%programdata%\Postclear\power.pow" 77777777-7777-7777-7777-777777777777
	powercfg -SETACTIVE "77777777-7777-7777-7777-777777777777"
	powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e
	powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 
	powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a
	
	TIMEOUT /T 2 /NOBREAK >nul
	title vc
	start /w %programdata%\PostClear\vcredist_x64.exe /quiet
	start /w %programdata%\PostClear\vcredist_x86.exe /quiet
	
	TIMEOUT /T 2 /NOBREAK >nul
	title str
	start /w %programdata%\PostClear\STR.exe -install
	sc config STR start=auto
	net start STR
	
	TIMEOUT /T 2 /NOBREAK >nul
	title 38
	@echo off
	CHOICE /C CT /T 2 /D C
	IF %ERRORLEVEL% EQU 1 goto nah
	!IF NOT EXIST %programdata%\PostClear\simplewall\simplewall.exe goto nah
	call %programdata%\PostClear\38.cmd 
	:nah
	del /f /q %programdata%\PostClear\38.cmd
	
	TIMEOUT /T 2 /NOBREAK >nul
	title apps
	%programdata%\PostClear\SteamSetup.exe /S
	%programdata%\PostClear\SpotifyFullSetup.exe /silent
	start %windir%\explorer.exe
	start /w msconfig
	start /w sysdm.cpl
	start "%programdata%\PostClear\simplewall\simplewall.exe"
	start control
	!pause
	
	TIMEOUT /T 2 /NOBREAK >nul
	title 33
	reg import %programdata%\PostClear\33.reg
	lodctr /r
	lodctr /r
	start /w %programdata%\PostClear\NvidiaProfileInspector.exe "%programdata%\PostClear\NvidiaBaseProfile.nip" -silent
	start /w %programdata%\PostClear\cru.exe 
	start /w %programdata%\PostClear\msi.exe

	TIMEOUT /T 2 /NOBREAK >nul
	title nvidia
	takeown.exe /f "C:\Program Files\WindowsApps\NVIDIACorp.NVIDIAControlPanel_8.1.963.0_x64__56jybvy8sckqj" /r /d y
	icacls.exe "C:\Program Files\WindowsApps\NVIDIACorp.NVIDIAControlPanel_8.1.963.0_x64__56jybvy8sckqj" /grant *S-1-3-4:F /t /q
	start /w "" "C:\Program Files\WindowsApps\NVIDIACorp.NVIDIAControlPanel_8.1.963.0_x64__56jybvy8sckqj\nvcplui.exe"
		
	TIMEOUT /T 2 /NOBREAK >nul
	title reg
	%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\cmd.exe /CommandLine "call del.bat" /RunAs 4 /WaitProcess 1 /Run
	%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\reg.exe /CommandLine "import %programdata%\PostClear\disable.reg" /RunAs 4 /WaitProcess 1 /Run
	%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\cmd.exe /CommandLine "regedit" /RunAs 4 /WaitProcess 1 /Run
	call %programdata%\PostClear\destroy.txt
	PAUSE
	
	TIMEOUT /T 2 /NOBREAK >nul
	title fin
	del /f /q %programdata%\PostClear\PostClearM.bat
	del /f /q %programdata%\PostClear\7za.exe
	del /f /q %programdata%\PostClear\windirstat.reg
	del /f /q %programdata%\PostClear\IFEO.reg
	del /f /q %programdata%\PostClear\33.reg
	del /f /q %programdata%\PostClear\NvidiaBaseProfile.nip
	del /f /q %programdata%\PostClear\power.pow
	del /f /q %programdata%\PostClear\vcredist_x64.exe
	del /f /q %programdata%\PostClear\vcredist_x86.exe
	start /w cleanmgr /verylowdisk
	TIMEOUT /T 10 /NOBREAK >nul
) else (
	title meme
	del /f /q %programdata%\PostClear\AdvancedRun.exe
		
)

:Reboot
title Rebooting...
SHUTDOWN -r -t 3
