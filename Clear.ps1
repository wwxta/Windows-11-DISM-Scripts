# Remove all revisions except Pro

	dism /delete-image /imagefile:C:\11\install.wim /index:10
	dism /delete-image /imagefile:C:\11\install.wim /index:9
	dism /delete-image /imagefile:C:\11\install.wim /index:8
	dism /delete-image /imagefile:C:\11\install.wim /index:7
	dism /delete-image /imagefile:C:\11\install.wim /index:6
	dism /delete-image /imagefile:C:\11\install.wim /index:4
	dism /delete-image /imagefile:C:\11\install.wim /index:3
	dism /delete-image /imagefile:C:\11\install.wim /index:2
	dism /delete-image /imagefile:C:\11\install.wim /index:1


# Mounting
mkdir C:\11\Install
dism /mount-image /imagefile:C:\11\install.wim /index:1 /mountdir:C:\11\Install
# Adding a response file
mkdir C:\11\Install\Windows\Panther
move C:\11\unattend.xml C:\11\Install\Windows\Panther
# Removing components
dism /image:C:\11\Install /remove-capability /capabilityname:App.StepsRecorder~~~~0.0.1.0
dism /image:C:\11\Install /remove-capability /capabilityname:Hello.Face.20134~~~~0.0.1.0
dism /image:C:\11\Install /remove-capability /capabilityname:MathRecognizer~~~~0.0.1.0
dism /image:C:\11\Install /remove-capability /capabilityname:OneCoreUAP.OneSync~~~~0.0.1.0
$letters=@("D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
foreach ($letter in $letters) {
	if ([System.IO.File]::Exists($letter+":\sources\install.wim"))
	{
		$found=$letter+":\sources\sxs\"
	}
}

# Disable Defender Definitions
dism /image:C:\11\Install /disable-feature /featurename:Windows-Defender-Default-Definitions
# Removing Pre-Installation Packages
$apps=@(
"Clipchamp.Clipchamp_2.2.8.0_neutral_~_yxz26nhyzhsrt",
"Microsoft.549981C3F5F10_3.2204.14815.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.BingNews_4.2.27001.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.BingWeather_4.53.33420.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.GamingApp_2021.427.138.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.GetHelp_10.2201.421.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Getstarted_2021.2204.1.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.MicrosoftOfficeHub_18.2204.1141.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.MicrosoftSolitaireCollection_4.12.3171.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.MicrosoftStickyNotes_4.2.2.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.People_2020.901.1724.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.PowerAutomateDesktop_10.0.3735.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.StorePurchaseApp_12008.1001.113.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Todos_2.54.42772.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Windows.Photos_21.21030.25003.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsAlarms_2022.2202.24.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsCalculator_2020.2103.8.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsCamera_2022.2201.4.0_neutral_~_8wekyb3d8bbwe",
"microsoft.windowscommunicationsapps_16005.14326.20544.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsFeedbackHub_2022.106.2230.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsMaps_2022.2202.6.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsNotepad_11.2112.32.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsSoundRecorder_2021.2103.28.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsStore_22204.1400.4.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Xbox.TCUI_1.23.28004.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.XboxGameOverlay_1.47.2385.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.XboxGamingOverlay_2.622.3232.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.XboxIdentityProvider_12.50.6001.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.YourPhone_1.22022.147.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.ZuneMusic_11.2202.46.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.ZuneVideo_2019.22020.10021.0_neutral_~_8wekyb3d8bbwe",
"MicrosoftCorporationII.QuickAssist_2022.414.1758.0_neutral_~_8wekyb3d8bbwe",
"MicrosoftWindows.Client.WebExperience_421.20070.195.0_neutral_~_cw5n1h2txyewy"
)
foreach ($app in $apps) {
	dism /image:C:\11\Install /remove-provisionedappxpackage /packagename:$app
}
