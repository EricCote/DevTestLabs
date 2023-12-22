param(
  [bool] $DownloadOnline=$false
)


$ProgressPreference = 'SilentlyContinue'

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


$destination="$env:temp\lang"

#############################

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








