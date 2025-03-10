[CmdletBinding()]
param(
    [ValidateSet("test1", "test2", "test3", "test4")] 
    [string] $test = 'test1',
    [switch] $MyFlag
)





function test1 {
    # Get-ChildItem "C:\program files\WindowsApps" 
    Get-AppxProvisionedPackage -online
}

function test2 {
    # Install-Language -Language "fr-CA" 
    Set-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Windows\Appx" `
        -name "AllowDevelopmentWithoutDevLicense" `
        -value 1 `
        -force | out-null


    $ProgressPreference = 'SilentlyContinue'
    $Ver = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -name DisplayVersion 

    if ($Ver -eq '23H2') { $Ver = '22h2' } 

    $Ver = $ver.ToLower();

    $sas = "sv=2022-11-02&ss=b&srt=co&sp=rwdlaciytfx&se=2030-03-07T22:21:14Z&st=2025-03-07T14:21:14Z&spr=https&sig=xvYvvZHVuDVhQZdoal86XK35qlSEgQaTrFZC1qHPlLw%3D"
    $blobLocation = "https://azureshelleric.blob.core.windows.net/win11-$Ver/inbox-apps";

    $logPath = "$env:temp\log-sys-fr-ca.txt"


    $destination = "$env:temp\lang"

    new-item -ItemType Directory -Path $destination -Force | Out-Null


    $url2 = "$blobLocation/inbox.zip?$sas"
    Invoke-WebRequest -UseBasicParsing -Uri $url2 -OutFile "$destination\inbox.zip"
    "Download inbox files $(Get-Date -Format T)"  | tee -file $logPath -append

    Expand-Archive -Path "$destination\inbox.zip" -DestinationPath "$destination\appx"   -Force
    "Unzip inbox files $(Get-Date -Format T)"  | tee -file $logPath -append


    Add-AppxProvisionedPackage -Online -PackagePath "$destination\appx\Microsoft.ZuneMusic_8wekyb3d8bbwe.msixbundle" -LicensePath "$destination\appx\Microsoft.ZuneMusic_8wekyb3d8bbwe.xml"
    Add-AppxProvisionedPackage -Online -PackagePath "$destination\appx\Microsoft.WindowsNotepad_8wekyb3d8bbwe.msixbundle" -LicensePath "$destination\appx\Microsoft.WindowsNotepad_8wekyb3d8bbwe.xml" 



    # Add-AppxProvisionedPackage -Online -PackagePath "$destination\appx\Microsoft.ZuneMusic_8wekyb3d8bbwe.msixbundle" -skipLicense
    # Add-AppxProvisionedPackage -Online -PackagePath "$destination\appx\Microsoft.WindowsNotepad_8wekyb3d8bbwe.msixbundle" -skipLicense


    # foreach ($app in (Get-ChildItem $destination\appx\*.*xbundle )) {
    #     $app.BaseName + " prep  $(Get-Date -Format T)"  | tee -file $logPath -append
    #     $lic = "$($app.DirectoryName)\$($app.BaseName).xml"
    #     Add-AppxProvisionedPackage -Online -PackagePath $($app.fullname) -LicensePath $lic *>&1 | tee -file $logPath -append
    #     $app.BaseName + " done  $(Get-Date -Format T)"  | tee -file $logPath -append
    #     break;
    # }


    # Remove-Item $destination  -Recurse -Force
    # "Remove downloaded files  $(Get-Date -Format T)" | tee -file $logPath -append  

    #Get-Content c:\windows\logs\dism\dism.log | Out-Default

    Get-ChildItem "C:\program files\WindowsApps" | Select-Object name | Format-Table
    # Get-ChildItem "$destination/appx" 

}

function test3 {
    Import-Module Appx
    Import-Module Dism
    Get-AppxPackage -AllUsers | Format-Table -Property PackageFullName, PackageUserInformation
}
<# 
 #>

function test4 {
    New-PSDrive HKU Registry HKEY_USERS | out-null
    & REG LOAD "HKU\Default" "C:\Users\Default\NTUSER.DAT"  

    Copy-Item (Get-Command reg).Source "$env:temp\reg5.exe"
    & "$env:temp\reg5.exe" 'add HKU\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarDa /t REG_DWORD /d 0 /f'

    & "$env:temp\reg5.exe" 'query HKU\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarDa'
    "wow"
    Remove-Item "$env:temp\reg5.exe"


    $tb = Get-ItemPropertyValue -Path 'HKU:Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -name TaskbarDa 
    "TaskbarDa=$tb"

    #for explanation: https://stackoverflow.com/questions/25438409/reg-unload-and-new-key
    Remove-PSDrive HKU 
    [gc]::Collect()
    [gc]::WaitForPendingFinalizers()

    & REG UNLOAD "HKU\Default" | out-default
}


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


if ($test -eq "test1") { test1 }
if ($test -eq "test2") { test2 }
if ($test -eq "test3") { test3 }
if ($test -eq "test4") { test4 }