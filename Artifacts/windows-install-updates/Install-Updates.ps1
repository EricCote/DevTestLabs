[CmdletBinding()]
param(
    [switch] $Restart
)

$ProgressPreference = 'SilentlyContinue'

# $sas = "sp=rl&st=2022-10-02T07:44:44Z&se=2026-10-02T15:44:44Z&spr=https&sv=2021-06-08&sr=c&sig=8COlEmuB7LVPphsQWBhfGPqx1guSF4MRWmRKdVU5Bvg%3D" 
# $blobLocation = "https://azureshelleric.blob.core.windows.net/win11-22h2";

# $url = "$blobLocation/notepad.zip?$sas"


# Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile "$env:temp\notepad.zip"
# Expand-Archive -Path "$env:temp\notepad.zip" -DestinationPath "$env:temp\appx"   -Force


# foreach ($app in (Get-ChildItem $env:TEMP\appx\*.*xbundle )) {
#     $app.BaseName + " prep  $(Get-Date -Format T)"  
#    # $lic = "$($app.DirectoryName)\$($app.BaseName).xml"
#     Add-AppxProvisionedPackage -Online -PackagePath $($app.fullname) -SkipLicense 
#     $app.BaseName + " done  $(Get-Date -Format T)" 
# }

# foreach ($app in (Get-ChildItem $env:TEMP\appx\*.appx )) {
#     $app.BaseName + " prep  $(Get-Date -Format T)"  
#    # $lic = "$($app.DirectoryName)\$($app.BaseName).xml"
#     Add-AppxProvisionedPackage -Online -PackagePath $($app.fullname) -SkipLicense 
#     $app.BaseName + " done  $(Get-Date -Format T)" 
# }

# Remove-Item $env:TEMP\appx  -Recurse -Force
# Remove-Item "C:\Windows\Temp\appx"  -Recurse -Force




#------------------------------------------

Install-PackageProvider -Name NuGet -force
Install-Module PSWindowsUpdate -force

Get-WUInstall  -AcceptAll -Install -IgnoreReboot 


if ($Restart){
  "Let's restart"
  Restart-Computer
}


#Install-WindowsUpdate -AcceptAll -verbose -IgnoreReboot

#Get-WURebootStatus



#---------------------

