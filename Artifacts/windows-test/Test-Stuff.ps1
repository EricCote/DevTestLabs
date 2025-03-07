[CmdletBinding()]
param(
    [ValidateSet("test1", "test2")] 
    [string] $MyString = 'test1',
    [switch] $MyFlag
)


$MyString | Out-Default
$MyFlag | Out-Default


'-----------__________________' | Out-Default

# dism /online /Get-ProvisioningPackageInfo


#Install-Language -Language "fr-CA" 


$ProgressPreference = 'SilentlyContinue'
$Ver = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -name DisplayVersion 

if ($ver -eq '23h2') { $ver = '22h2' }


$sas = "sp=rl&st=2025-03-04T18:33:42Z&se=2030-03-05T02:33:42Z&spr=https&sv=2022-11-02&sr=c&sig=bTucvhs7LFnn40suvivcWV6tuBrQmV6qUlAfd6EZeSc%3D"
$blobLocation = "https://azureshelleric.blob.core.windows.net/$Ver/inbox-apps";

$logPath = "$env:temp\log-sys-fr-ca.txt"


$destination = "$env:temp\lang"

new-item -ItemType Directory -Path $destination -Force | Out-Null


$url2 = "$blobLocation/inbox.zip?$sas"
Invoke-WebRequest -UseBasicParsing -Uri $url2 -OutFile "$destination\inbox.zip"
"Download inbox files $(Get-Date -Format T)"  | tee -file $logPath -append

Expand-Archive -Path "$destination\inbox.zip" -DestinationPath "$destination\appx"   -Force
"Unzip inbox files $(Get-Date -Format T)"  | tee -file $logPath -append

 
foreach ($app in (Get-ChildItem $destination\appx\*.*xbundle )) {
    $app.BaseName + " prep  $(Get-Date -Format T)"  | tee -file $logPath -append
    $lic = "$($app.DirectoryName)\$($app.BaseName).xml"
    Add-AppxProvisionedPackage -Online -PackagePath $($app.fullname) -LicensePath $lic *>&1 | tee -file $logPath -append
    $app.BaseName + " done  $(Get-Date -Format T)"  | tee -file $logPath -append
    break
}
#>

Remove-Item $destination  -Recurse -Force
"Remove downloaded files  $(Get-Date -Format T)" | out-file $logPath -append  


<# Import-Module Appx
Import-Module Dism
Get-AppxPackage -AllUsers | Where PublisherId -eq 8wekyb3d8bbwe | Format-List -Property PackageFullName,PackageUserInformation
 
 #>



#Install-Language -Language "fr-CA" -CopyToSettings
#Set-SystemPreferredUILanguage "fr-CA"

# Restart-Computer -Force


# $progressPreference = 'silentlyContinue'
# Write-Host "Installing WinGet PowerShell module from PSGallery..."
# Install-PackageProvider -Name NuGet -Force | Out-Null
# Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
# Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
# Repair-WinGetPackageManager
# Write-Host "Done."



#----------------------------------------------------------

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


