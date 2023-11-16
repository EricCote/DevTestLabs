﻿$ProgressPreference = 'SilentlyContinue'

$sasold = "sp=rl&st=2021-11-27T21:25:00Z&se=2024-11-29T18:01:00Z&sv=2020-08-04&sr=c&sig=MoK27t71M1qqeqZcOzMunBIKNBP5WDUi8JRGSgmg0js%3D"
$sas = "sp=rl&st=2022-10-02T07:44:44Z&se=2026-10-02T15:44:44Z&spr=https&sv=2021-06-08&sr=c&sig=8COlEmuB7LVPphsQWBhfGPqx1guSF4MRWmRKdVU5Bvg%3D" 
$blobLocation = "https://azureshelleric.blob.core.windows.net/win11-22h2/fr-ca";

$logPath = "$env:temp\log-sys-fr-ca.txt"


$linkArray = @(
    "Microsoft-Windows-EMS-SAC-Desktop-Tools-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-MediaPlayer-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-MediaPlayer-Package~31bf3856ad364e35~wow64~fr-CA~.cab",
    "Microsoft-Windows-Notepad-System-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab",    
    "Microsoft-Windows-Notepad-System-FoD-Package~31bf3856ad364e35~wow64~fr-CA~.cab",
    "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~wow64~fr-CA~.cab",
    "Microsoft-Windows-Printing-PMCPPC-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~wow64~fr-CA~.cab",
    "Microsoft-Windows-WMIC-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-WMIC-FoD-Package~31bf3856ad364e35~wow64~fr-CA~.cab",
    "Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~wow64~fr-CA~.cab"
)


$FOD = @(
    "Language.Basic~~~fr-CA~0.0.1.0",
    "Language.Basic~~~fr-FR~0.0.1.0",
    "Language.Basic~~~en-CA~0.0.1.0",
    "Language.Handwriting~~~fr-FR~0.0.1.0",
    "Language.OCR~~~fr-CA~0.0.1.0",
    "Language.Speech~~~fr-CA~0.0.1.0",
    "Language.TextToSpeech~~~fr-CA~0.0.1.0"
    # "Windows.Desktop.EMS-SAC.Tools~~~~0.0.1.0",
    # "Browser.InternetExplorer~~~~0.0.11.0",
    # "Microsoft.Windows.Notepad.System~~~~0.0.1.0",
    # "Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0",
    # "Print.Management.Console~~~~0.0.1.0",
    # "Print.Fax.Scan~~~~0.0.1.0",
    # "App.StepsRecorder~~~~0.0.1.0",
    # "Microsoft.Windows.WordPad~~~~0.0.1.0"
);

$FOD2 = @("Microsoft-Windows-LanguageFeatures-Basic-fr-ca-Package~31bf3856ad364e35~amd64~~.cab",
"Microsoft-Windows-LanguageFeatures-Basic-fr-fr-Package~31bf3856ad364e35~amd64~~.cab"
"Microsoft-Windows-LanguageFeatures-Basic-en-ca-Package~31bf3856ad364e35~amd64~~.cab",
"Microsoft-Windows-LanguageFeatures-Handwriting-fr-fr-Package~31bf3856ad364e35~amd64~~.cab",
"Microsoft-Windows-LanguageFeatures-OCR-fr-ca-Package~31bf3856ad364e35~amd64~~.cab",
"Microsoft-Windows-LanguageFeatures-Speech-fr-ca-Package~31bf3856ad364e35~amd64~~.cab",
"Microsoft-Windows-LanguageFeatures-TextToSpeech-fr-ca-Package~31bf3856ad364e35~amd64~~.cab"
)



$url = "$blobLocation/Microsoft-Windows-Client-Language-Pack_x64_fr-ca.cab?$sas"


$destination="$env:temp\lang"
New-Item  $destination -ItemType Directory -force

Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile "$destination\lang.cab"
"Lang Downloaded $(Get-Date -Format T)"  | out-file  $logPath -append
Add-WindowsPackage -online -PackagePath  "$destination\lang.cab"
"Lang Installed $(Get-Date -Format T)" | out-file  $logPath -append


# $FOD | ForEach-Object  { if ($_ -notmatch "Language\.")  {  Remove-WindowsCapability -Online -Name $_  }}
# "Removed capabilities" | out-file "$env:temp\wow3.txt"


$FOD | ForEach-Object { Add-WindowsCapability -Online -Name $_ }
"Classic way of installing online"  | out-file $logPath -append

# #$FOD2
# $packagesFod = $FOD2 | ForEach-Object { @{url = "$blobLocation/$($_)?$sas"; filename = $_ } }
# "list of FOD packages $(Get-Date -Format T)"  | out-file $logPath -append

# $packagesFod | ForEach-Object { Invoke-WebRequest -UseBasicParsing -Uri $_.url -OutFile "$destination\$($_.filename)" } 
# "loop for FOD download $(Get-Date -Format T)" | out-file $logPath -append

# $FOD | ForEach-Object { Add-WindowsCapability -Online  -Name $_  -Source $destination -LimitAccess }
# "loop for integrating FOD package $(Get-Date -Format T)"  | out-file $logPath -append


$packages = $linkArray | ForEach-Object { @{url = "$blobLocation/$($_)?$sas"; filename = $_ } }
"generate a list of package names and url $(Get-Date -Format T)" | out-file $logPath -append


$packages | ForEach-Object { Invoke-WebRequest -UseBasicParsing -Uri $_.url -OutFile "$destination\$($_.filename)" } 
"loop for download $(Get-Date -Format T)" | out-file $logPath -append


$packages | ForEach-Object { Add-WindowsPackage -Online -PackagePath (join-path  $destination   $_.filename) }
"loop for integrating windows package $(Get-Date -Format T)"  | out-file $logPath -append


$url2 = "https://azureshelleric.blob.core.windows.net/win11-22h2/inbox-apps/inbox.zip?$sas"
Invoke-WebRequest -UseBasicParsing -Uri $url2 -OutFile "$destination\inbox.zip"
"Download inbox files $(Get-Date -Format T)"  | out-file $logPath -append

Expand-Archive -Path "$destination\inbox.zip" -DestinationPath "$destination\appx"   -Force
"Unzip inbox files $(Get-Date -Format T)"  | out-file $logPath -append

foreach ($app in (Get-ChildItem $destination\appx\*.*xbundle )) {
    $app.BaseName + " prep  $(Get-Date -Format T)"  | out-file $logPath -append
    $lic = "$($app.DirectoryName)\$($app.BaseName).xml"
    Add-AppxProvisionedPackage -Online -PackagePath $($app.fullname) -LicensePath $lic  | Out-Null
    $app.BaseName + " done  $(Get-Date -Format T)"  | out-file $logPath -append
}


Remove-Item $destination  -Recurse -Force
"Remove downloaded files"   | out-file $logPath -append


restart-computer
"Restarted  $(Get-Date -Format T)"   | out-file $logPath -append
