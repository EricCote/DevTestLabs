[CmdletBinding()]
param(
    [ValidateSet("test1","test2")] 
    [string] $MyString = 'test1',
    [switch] $MyFlag
)


$MyString | Out-Default
$MyFlag | Out-Default


'-----------__________________' | Out-Default

#Install-Language -Language "fr-CA" 


$ProgressPreference = 'SilentlyContinue'
$sas="sp=rl&st=2025-03-04T18:33:42Z&se=2030-03-05T02:33:42Z&spr=https&sv=2022-11-02&sr=c&sig=bTucvhs7LFnn40suvivcWV6tuBrQmV6qUlAfd6EZeSc%3D"
$blobLocation = "https://azureshelleric.blob.core.windows.net/win11-24h2/inbox-apps";

$logPath = "$env:temp\log-sys-fr-ca.txt"


$destination="$env:temp\lang"

new-item -ItemType Directory -Path $destination -Force


$url2 = "$blobLocation/inbox.zip?$sas"
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



#Install-Language -Language "fr-CA" -CopyToSettings
#Set-SystemPreferredUILanguage "fr-CA"

Restart-Computer -Force

# report languages

# $OSInfo = Get-WmiObject -Class Win32_OperatingSystem
# $OSInfo.MUILanguages

#----------------------------------------------------------


# Error of 23h2 images: Security center is not properly shown
# fix to install the proper version of security center:


# $secLink='https://www.winhelponline.com/apps/SecurityHealthSetup.exe'
# invoke-webrequest -UseBasicParsing  $secLink -OutFile $env:TEMP\securityhealthsetup.exe
# & $env:TEMP\securityhealthsetup.exe

#----------------------------------------------------------


