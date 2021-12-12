$ProgressPreference = 'SilentlyContinue'

$apiUrl = "https://store.rg-adguard.net/api/GetFiles"


# Get-AppxProvisionedPackage -Online |  
# select-object @{label="name";expression={"$($_.DisplayName)_$($_.PublisherId)"}} , Version  |
# ConvertTo-Json 

#$list | select-object @{label = "name"; expression = { $_.name.split("_")[0] }} | where {$_.name -notin $items.name}     


$jsonRetail = @"
[
    {
        "name":  "Microsoft.549981C3F5F10_8wekyb3d8bbwe",
        "Version":  "3.2110.13603.0"
    },
    {
        "name":  "Microsoft.BingNews_8wekyb3d8bbwe",
        "Version":  "4.9.30001.0",
        "exclude": ["4.9.31001.0", "4.31.12124.0", "2016.408.1840.2841"]
    },
    {
        "name":  "Microsoft.BingWeather_8wekyb3d8bbwe",
        "Version":  "4.7.20002.0",
        "exclude": ["4.31.11905.0", "2016.1014.23.3280"]
    },
    {
        "name":  "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe",
        "Version":  "2021.1026.721.0"
    },
    {
        "name":  "Microsoft.GamingApp_8wekyb3d8bbwe",
        "Version":  "2112.1001.10.0"
    },
    {
        "name":  "Microsoft.GetHelp_8wekyb3d8bbwe",
        "Version":  "10.2109.42921.0"
    },
    {
        "name":  "Microsoft.Getstarted_8wekyb3d8bbwe",
        "Version":  "2021.2110.6.0"
    },
    {
        "name":  "Microsoft.HEIFImageExtension_8wekyb3d8bbwe",
        "Version":  "1.0.42621.0"
    },
    {
        "name":  "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe",
        "Version":  "18.2110.13110.0"
    },
    {
        "name":  "Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe",
        "Version":  "4.11.12030.0"
    },
    {
        "name":  "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe",
        "Version":  "4.1.6.0"
    },
    {
        "name":  "Microsoft.Paint_8wekyb3d8bbwe",
        "Version":  "11.2110.0.0"
    },
    {
        "name":  "Microsoft.People_8wekyb3d8bbwe",
        "Version":  "2021.2105.4.0"
    },
    {
        "name":  "Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe",
        "Version":  "10.0.2290.0"
    },
    {
        "name":  "Microsoft.ScreenSketch_8wekyb3d8bbwe",
        "Version":  "2021.2109.37.0"
    },
    {
        "name":  "Microsoft.StorePurchaseApp_8wekyb3d8bbwe",
        "Version":  "12109.1001.10.0"
    },
    {
        "name":  "Microsoft.Todos_8wekyb3d8bbwe",
        "Version":  "2.57.43142.0"
    },
    {
        "name":  "Microsoft.VP9VideoExtensions_8wekyb3d8bbwe",
        "Version":  "1.0.42791.0"
    },
    {
        "name":  "Microsoft.WebMediaExtensions_8wekyb3d8bbwe",
        "Version":  "1.0.42192.0"
    },
    {
        "name":  "Microsoft.WebpImageExtension_8wekyb3d8bbwe",
        "Version":  "1.0.42351.0"
    },
    {
        "name":  "Microsoft.Windows.Photos_8wekyb3d8bbwe",
        "Version":  "2021.21110.8005.0"
    },
    {
        "name":  "Microsoft.WindowsAlarms_8wekyb3d8bbwe",
        "Version":  "2022.2109.1.0"
    },
    {
        "name":  "Microsoft.WindowsCalculator_8wekyb3d8bbwe",
        "Version":  "2021.2109.9.0"
    },
    {
        "name":  "Microsoft.WindowsCamera_8wekyb3d8bbwe",
        "Version":  "2022.2110.0.0"
    },
    {
        "name":  "microsoft.windowscommunicationsapps_8wekyb3d8bbwe",
        "Version":  "16005.14326.20544.0",
        "exclude": ["16006.11001.20116.0"]
    },
    {
        "name":  "Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe",
        "Version":  "2021.1114.122.0"
    },
    {
        "name":  "Microsoft.WindowsMaps_8wekyb3d8bbwe",
        "Version":  "2021.2104.2.0"
    },
    {
        "name":  "Microsoft.WindowsNotepad_8wekyb3d8bbwe",
        "Version":  "10.2103.6.0"
    },
    {
        "name":  "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe",
        "Version":  "2021.2103.28.0"
    },
    {
        "name":  "Microsoft.WindowsStore_8wekyb3d8bbwe",
        "Version":  "22111.1401.1.0"
    },
    {
        "name":  "Microsoft.WindowsTerminal_8wekyb3d8bbwe",
        "Version":  "2021.1019.2143.0"
    },
    {
        "name":  "Microsoft.Xbox.TCUI_8wekyb3d8bbwe",
        "Version":  "1.24.10001.0"
    },
    {
        "name":  "Microsoft.XboxGameOverlay_8wekyb3d8bbwe",
        "Version":  "1.54.4001.0"
    },
    {
        "name":  "Microsoft.XboxGamingOverlay_8wekyb3d8bbwe",
        "Version":  "5.721.12013.0"
    },
    {
        "name":  "Microsoft.XboxIdentityProvider_8wekyb3d8bbwe",
        "Version":  "12.83.12001.0",
        "exclude": ["2017.523.613.1000"]
    },
    {
        "name":  "Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe",
        "Version":  "1.21.13002.0"
    },
    {
        "name":  "Microsoft.YourPhone_8wekyb3d8bbwe",
        "Version":  "2021.1208.104.0"
    },
    {
        "name":  "Microsoft.ZuneMusic_8wekyb3d8bbwe",
        "Version":  "2019.21102.11411.0"
    },
    {
        "name":  "Microsoft.ZuneVideo_8wekyb3d8bbwe",
        "Version":  "2019.21111.10511.0"
    },
    {
        "name":  "MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy",
        "Version":  "421.20050.505.0"
    }
   
] 
"@

$jsonDeps=
@" 
[
    {
        "name":  "Microsoft.UI.Xaml.2.1_8wekyb3d8bbwe",
        "Version":  "2.11906.6001.0"
    },
    {
        "name":  "Microsoft.UI.Xaml.2.4_8wekyb3d8bbwe",
        "Version":  "2.42007.9001.0"
    },
    {
        "name":  "Microsoft.UI.Xaml.2.6_8wekyb3d8bbwe",
        "Version":  "2.62112.3002.0"
    },
    {
        "name":  "Microsoft.UI.Xaml.2.7_8wekyb3d8bbwe",
        "Version":  "7.2109.13004.0"
    },
    {
        "name":  "Microsoft.VCLibs.140.00_8wekyb3d8bbwe",
        "Version":  "14.0.30704.0"
    },
    {
        "name":  "Microsoft.VCLibs.140.00.UWPDesktop_8wekyb3d8bbwe",
        "Version":  "14.0.30704.0"
    },
    {
        "name":  "Microsoft.NET.Native.Runtime.2.2_8wekyb3d8bbwe",
        "Version":  "2.2.28604.0"
    },
    {
        "name":  "Microsoft.NET.Native.Framework.2.2_8wekyb3d8bbwe",
        "Version":  "2.2.29512.0"
    },
    {
        "name":  "Microsoft.Advertising.Xaml_8wekyb3d8bbwe",
        "Version":  "10.1811.1.0"
    }
]
"@



$jsonIgnored = @"
[   
  
    {
        "Name":  "Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe",
        "Version":  "96.0.1054.34"
    },
    {
        "name":  "Microsoft.SecHealthUI_8wekyb3d8bbwe",
        "Version":  "1000.22000.1.0"
    },
 
    {
        "Name":  "MicrosoftTeams_cw5n1h2txyewy",
        "Version":  "21302.202.1065.6968"
    }
]
"@




function Invoke-AppxLink { 
    param ([string]$appx)
    $body = @{
        type = 'PackageFamilyName'
        url  = $appx
        ring = 'Retail'
        lang = 'en-US'
    }

    $theName = $appx.Split("_")[0];

    $count = 0;
    $matches = $null;

    do {
        $count += 1;
        $raw = Invoke-RestMethod -Method Post -Uri $apiUrl -ContentType 'application/x-www-form-urlencoded' -Body $body
    
        $matches = $raw | 
        Select-String '<tr style.*<a href=\"(?<url>.*)"\s.*>(?<text>.*)<\/a>' -AllMatches | 
        % { $_.Matches } ;
    }
    while ($matches.count -eq 0 -and $count -le 5);

    if ($matches.count -eq 0) { throw "Cannot find $appx" }

    $matches | % { 
        $url = $_.Groups[1].Value
        $text = $_.Groups[2].Value
        $parts = $text.split("_")
        $subparts = ([string]$parts[4]).split(".")
            
        [PSCustomObject]@{
            Name         = $parts[0];
            Version      = [version]$parts[1];
            Architecture = $parts[2];
            Lang         = $parts[3];
            PublisherID  = $subparts[0];
            Ext          = $subparts[1];
            Url          = $url;
        }
    } |
    sort  -property Version | 
    where Name -Match $theName  |
    Where Ext -NotMatch '^(e|B)' |
    Where Architecture -Match '(neutral|x64)'
}



New-Item $env:TEMP\appx -ItemType Directory -Force | out-null


$listDeps = ConvertFrom-Json $jsonDeps
$deps = $listApps | Select-Object   | % {
    $exclude = if ($_.exclude -ne $null) {$_.exclude} else {@("1.1.1")};
    $theVersion=$_.version;
    Invoke-AppxLink -appx $_.name |
    Where version -GE $theVersion   |
    where version -NotIn $exclude  |
    Select-Object name, version, @{label = "current"; expression = { if ($_.version -eq $theVersion) { '*' } else { ' ' } } }, ext, url, Architecture
}  


$listApps = ConvertFrom-Json $jsonRetail
$items = $listApps | Select-Object   | % {
    $exclude = if ($_.exclude -ne $null) {$_.exclude} else {@("1.1.1")};
    $theVersion=$_.version;
    Invoke-AppxLink -appx $_.name |
    Where version -GE $theVersion   |
    where version -NotIn $exclude  |
    Select-Object name, version, @{label = "current"; expression = { if ($_.version -eq $theVersion) { '*' } else { ' ' } } }, ext, url, architecture
}  

$deps | where current -EQ '*' | % { Invoke-WebRequest -UseBasicParsing -Uri $_.url  -out "$env:TEMP\appx\$($_.name)_$($_.Architecture)_$($_.PublisherID).$($_.ext)"  }

$items | where current -EQ '*' | % { Invoke-WebRequest -UseBasicParsing -Uri $_.url  -out "$env:TEMP\appx\$($_.name)_$($_.PublisherID).$($_.ext)"  }


Invoke-WebRequest -UseBasicParsing "https://azureshelleric.blob.core.windows.net/win11/inbox-apps/licenses.zip?sp=rl&st=2021-11-27T21:25:00Z&se=2024-11-29T18:01:00Z&sv=2020-08-04&sr=c&sig=MoK27t71M1qqeqZcOzMunBIKNBP5WDUi8JRGSgmg0js%3D" -OutFile $env:TEMP\licenses.zip

Expand-Archive -Path "$env:TEMP\licenses.zip" -DestinationPath "$env:TEMP\appx" -force


$appxPath="$env:TEMP\appx";

$files=get-childitem "$($appxPath)\*"  -include "*.appx" ;

$files |   % { 
    $n=$_.Name.split("_")[0];
    $lic =  get-childitem -path $($_.DirectoryName) -include $n*.xml;

    if ($lic.count -gt 0) {
       "licence $n"; 
        Add-AppxProvisionedPackage -Online -PackagePath $_.fullname -LicensePath $lic.FullName
    } else {
        "no lic $n $($_.fullname)"; 
        Add-AppxProvisionedPackage -Online -PackagePath $_.fullname -SkipLicense
    }
}

get-childitem $appxPath  -exclude *.xml,*.appx |   % { 
        $n=$_.Name.split("_")[0];

        $lic =  get-childitem -path "$appxPath\*" -include "$n*.xml";

        if ($lic.count -gt 0) {
            "lic $n" 
            try {
                Add-AppxProvisionedPackage -Online -PackagePath $_.fullname -LicensePath $lic.FullName 
            }
            catch {
                Add-AppxProvisionedPackage -Online -PackagePath $_.fullname -LicensePath $lic.FullName -StubPackageOption InstallStub 
            }
         } elseif ($n -eq "Microsoft.549981C3F5F10") {
            "lic $n"
            Add-AppxProvisionedPackage -Online -PackagePath $_.fullname -LicensePath $appxPath\Microsoft.CortanaApp_8wekyb3d8bbwe.xml 
        } else {
            "no lic $n" 
            try {
                Add-AppxProvisionedPackage -Online -PackagePath $_.fullname -SkipLicense 
            }
            catch {
                Add-AppxProvisionedPackage -Online -PackagePath $_.fullname -SkipLicense -StubPackageOption InstallStub 
            }
        }
    }





# Invoke-WebRequest -UseBasicParsing "https://azureshelleric.blob.core.windows.net/win11/inbox-apps/inbox.iso?sp=rl&st=2021-11-27T21:25:00Z&se=2024-11-29T18:01:00Z&sv=2020-08-04&sr=c&sig=MoK27t71M1qqeqZcOzMunBIKNBP5WDUi8JRGSgmg0js%3D" -OutFile $env:TEMP\inbox.iso


# $disk = Mount-DiskImage -ImagePath $env:TEMP\inbox.iso 
# Start-Sleep -Seconds 2
# $drive=  ($disk | get-volume).DriveLetter


# $appxPath = "$drive`:\amd64fre"

# $list = ConvertFrom-Json $jsonRetail
# $list | Select-Object *  |   % {
#     $n=$_.Name
#     $p =  dir "$appxPath\$n.*xbundle"
#     if (!$p) {$p = dir "$appxPath\$n.appx" }
#     $lic = "$($p.DirectoryName)\$($p.BaseName).lic"
#     if (Test-Path -Path $lic) {
#         Add-AppxProvisionedPackage -Online -PackagePath $p.fullname -LicensePath $lic
#     } else {
#         Add-AppxProvisionedPackage -Online -PackagePath $p.fullname -SkipLicense
#     }
    
# }
