$ProgressPreference = 'SilentlyContinue'

$jsonRetail = @"
[
    {
        "Name":  "Microsoft.BingWeather_8wekyb3d8bbwe",
        "Version":  "4.7.20002.0"
    },
    {
        "Name":  "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe",
        "Version":  "2021.1026.721.0"
    },
    {
        "Name":  "Microsoft.GetHelp_8wekyb3d8bbwe",
        "Version":  "10.2109.42921.0"
    },
    {
        "Name":  "Microsoft.Getstarted_8wekyb3d8bbwe",
        "Version":  "10.7.42522.0"
    },
    {
        "Name":  "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe",
        "Version":  "18.2106.12410.0"
    },
    {
        "Name":  "Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe",
        "Version":  "4.10.10270.0"
    },
    {
        "Name":  "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe",
        "Version":  "4.1.6.0"
    },
    {
        "Name":  "Microsoft.Paint_8wekyb3d8bbwe",
        "Version":  "11.2110.0.0"
    },
    {
        "Name":  "Microsoft.People_8wekyb3d8bbwe",
        "Version":  "2021.2105.4.0"
    },
    {
        "Name":  "Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe",
        "Version":  "10.0.2290.0"
    },
    {
        "Name":  "Microsoft.ScreenSketch_8wekyb3d8bbwe",
        "Version":  "2021.2109.37.0"
    },
    {
        "Name":  "Microsoft.StorePurchaseApp_8wekyb3d8bbwe",
        "Version":  "12109.1001.10.0"
    },
    {
        "Name":  "Microsoft.Todos_8wekyb3d8bbwe",
        "Version":  "2.57.43142.0"
    },
    {
        "Name":  "Microsoft.UI.Xaml.x64.2.4",
        "Version":  "2.42007.9001.0"
    },

    {
        "Name":  "Microsoft.VP9VideoExtensions_8wekyb3d8bbwe.x64",
        "Version":  "1.0.42791.0"
    },
    {
        "Name":  "Microsoft.WebMediaExtensions_8wekyb3d8bbwe",
        "Version":  "1.0.42192.0"
    },
    {
        "Name":  "Microsoft.WebpImageExtension_8wekyb3d8bbwe.x64",
        "Version":  "1.0.42351.0"
    },
    {
        "Name":  "Microsoft.Windows.Photos_8wekyb3d8bbwe",
        "Version":  "2021.21110.8005.0"
    },
    {
        "Name":  "Microsoft.WindowsAlarms_8wekyb3d8bbwe",
        "Version":  "2021.2101.28.0"
    },
    {
        "Name":  "Microsoft.WindowsCalculator_8wekyb3d8bbwe",
        "Version":  "2021.2109.9.0"
    },
    {
        "Name":  "Microsoft.WindowsCamera_8wekyb3d8bbwe",
        "Version":  "2022.2110.0.0"
    },
    {
        "Name":  "microsoft.windowscommunicationsapps_8wekyb3d8bbwe",
        "Version":  "16005.14326.20544.0"
    },
    {
        "Name":  "Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe",
        "Version":  "2021.1114.122.0"
    },
    {
        "Name":  "Microsoft.WindowsMaps_8wekyb3d8bbwe",
        "Version":  "2021.2104.2.0"
    },
    {
        "Name":  "Microsoft.WindowsNotepad_8wekyb3d8bbwe",
        "Version":  "10.2103.6.0"
    },
    {
        "Name":  "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe",
        "Version":  "2021.2103.28.0"
    },
    {
        "Name":  "Microsoft.WindowsStore_8wekyb3d8bbwe",
        "Version":  "22110.1401.17.0"
    },
    {
        "Name":  "Microsoft.WindowsTerminal_8wekyb3d8bbwe",
        "Version":  "2021.1019.2143.0"
    },
    {
        "Name":  "Microsoft.Xbox.TCUI_8wekyb3d8bbwe",
        "Version":  "1.24.10001.0"
    },
    {
        "Name":  "Microsoft.XboxGameOverlay_8wekyb3d8bbwe",
        "Version":  "1.54.4001.0"
    },
    {
        "Name":  "Microsoft.XboxGamingOverlay_8wekyb3d8bbwe",
        "Version":  "5.721.10202.0"
    },
    {
        "Name":  "Microsoft.XboxIdentityProvider_8wekyb3d8bbwe",
        "Version":  "12.83.12001.0"
    },
    {
        "Name":  "Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe",
        "Version":  "1.21.13002.0"
    },
    {
        "Name":  "Microsoft.YourPhone_8wekyb3d8bbwe",
        "Version":  "2021.1111.2011.0"
    },
    {
        "Name":  "Microsoft.ZuneMusic_8wekyb3d8bbwe",
        "Version":  "2019.21102.11411.0"
    },
    {
        "Name":  "Microsoft.ZuneVideo_8wekyb3d8bbwe",
        "Version":  "2019.21092.10731.0"
    },
    {
        "Name":  "Microsoft.BingNews_8wekyb3d8bbwe",
        "Version":  "4.7.28001.0"
    },
    {
        "Name":  "Microsoft.GamingApp_8wekyb3d8bbwe",
        "Version":  "2021.427.138.0"
    }
]
"@



$jsonRP = @"
[
    {
        "Name":  "Microsoft.549981C3F5F10_8wekyb3d8bbwe",
        "Version":  "3.2110.13603.0"
    },
]
"@


Invoke-WebRequest -UseBasicParsing "https://azureshelleric.blob.core.windows.net/win11/inbox-apps/inbox.iso?sp=rl&st=2021-11-27T21:25:00Z&se=2024-11-29T18:01:00Z&sv=2020-08-04&sr=c&sig=MoK27t71M1qqeqZcOzMunBIKNBP5WDUi8JRGSgmg0js%3D" -OutFile $env:TEMP\inbox.iso


$disk = Mount-DiskImage -ImagePath $env:TEMP\inbox.iso 
Start-Sleep -Seconds 2
$drive=  ($disk | get-volume).DriveLetter


$appxPath = "$drive`:\amd64fre"

$list = ConvertFrom-Json $jsonRetail
$list | Select-Object *  |   % {
    $n=$_.Name
    $p =  dir "$appxPath\$n.*xbundle"
    if (!$p) {$p = dir "$appxPath\$n.appx" }
    $lic = "$($p.DirectoryName)\$($p.BaseName).lic"
    if (Test-Path -Path $lic) {
        Add-AppxProvisionedPackage -Online -PackagePath $p.fullname -LicensePath $lic
    } else {
        Add-AppxProvisionedPackage -Online -PackagePath $p.fullname -SkipLicense
    }
    
}
