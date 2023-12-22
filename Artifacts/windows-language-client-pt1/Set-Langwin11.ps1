param(
  [bool] $DownloadOnline=$false
)

$ProgressPreference = 'SilentlyContinue'

$sas = "sp=rl&st=2022-10-02T07:44:44Z&se=2026-10-02T15:44:44Z&spr=https&sv=2021-06-08&sr=c&sig=8COlEmuB7LVPphsQWBhfGPqx1guSF4MRWmRKdVU5Bvg%3D" 
$blobLocation = "https://azureshelleric.blob.core.windows.net/win11-22h2/fr-ca";

$logPath = "$env:temp\log-sys-fr-ca.txt"


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
"Microsoft-Windows-LanguageFeatures-Basic-fr-fr-Package~31bf3856ad364e35~amd64~~.cab",
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


# $FOD | ForEach-Object  { if ($_ -notmatch "$destination\.")  {  Remove-WindowsCapability -Online -Name $_  }}
# "Removed capabilities" | out-file  $logPath -append


if ($DownloadOnline) {
    $FOD | ForEach-Object { Add-WindowsCapability -Online -Name $_ }
    "Classic way of installing online"  | out-file $logPath -append
}else {
    $packagesFod = $FOD2 | ForEach-Object { @{url = "$blobLocation/$($_)?$sas"; filename = $_ } }
    "list of FOD packages $(Get-Date -Format T)"  | out-file $logPath -append

    $packagesFod | ForEach-Object { Invoke-WebRequest -UseBasicParsing -Uri $_.url -OutFile "$destination\$($_.filename)" } 
    "loop for FOD download $(Get-Date -Format T)" | out-file $logPath -append

    ##the following line is faster when -LimitAccess is used
    $FOD | ForEach-Object { Add-WindowsCapability -Online  -Name $_  -Source $destination -LimitAccess }  
    "loop for integrating FOD package $(Get-Date -Format T)"  | out-file $logPath -append
}


restart-computer
"Restarted  $(Get-Date -Format T)"   | out-file $logPath -append

#############################


# dir hklm:\SYSTEM\CurrentControlSet\Control\MUI\UILanguages


# dir hklm:\SOFTWARE\Microsoft\LanguageOverlay
# dir hklm:\SOFTWARE\Microsoft\LanguageOverlay\OverlayPackages
# dir hklm:\SOFTWARE\Microsoft\LanguageOverlay\DeferredCleanup


# New-Item -Path HKLM:\SYSTEM\CurrentControlSet\Control\MUI\UILanguages -Name fr-CA -Force | Out-Null

# $frca = "HKLM:\SYSTEM\CurrentControlSet\Control\MUI\UILanguages\fr-CA"

# New-ItemProperty -path $frca -name "LCID" -value 3084 -PropertyType dword -Force | Out-Null
# New-ItemProperty -path $frca -name "Type" -value 274 -PropertyType dword -Force | Out-Null
# New-ItemProperty -path $frca -name "DefaultFallback" -value "fr-FR" -PropertyType string -Force | Out-Null
# New-ItemProperty -path $frca -name "fr-FR" -value @("en-US") -PropertyType MultiString -Force | Out-Null




# $sas = "sp=rl&st=2022-10-02T07:44:44Z&se=2026-10-02T15:44:44Z&spr=https&sv=2021-06-08&sr=c&sig=8COlEmuB7LVPphsQWBhfGPqx1guSF4MRWmRKdVU5Bvg%3D" 
# $blobLocation = "https://azureshelleric.blob.core.windows.net/win11-22h2/fr-ca";

# $logPath = "$env:temp\log-sys-fr-ca.txt"


# $url = "$blobLocation/Microsoft-Windows-Client-Language-Pack_x64_fr-ca.cab?$sas"


# $destination="$env:temp\lang"
# New-Item  $destination -ItemType Directory -force

# Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile "$destination\lang.cab"
# "Lang Downloaded $(Get-Date -Format T)"  | out-file  $logPath -append


# Invoke-WebRequest -UseBasicParsing   https://live.sysinternals.com/Procmon64.exe -OutFile $env:TEMP\procmon64.exe

# & $env:TEMP\procmon64.exe /AcceptEula /BackingFile C:\capture.pml /Quiet


# "Lang Installed $(Get-Date -Format T)" | out-file  $logPath -append

# & $env:TEMP\procmon64.exe /terminate








