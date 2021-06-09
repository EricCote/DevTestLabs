# from https://gist.github.com/ScottHutchinson/
# Based on http://nuts4.net/post/automated-download-and-installation-of-visual-studio-extensions-via-powershell

param([String] $PackageName, [switch] $IsExe)
 
$ErrorActionPreference = "Stop"
$ProgressPreference = 'SilentlyContinue'
 
$baseProtocol = "https:"
$baseHostName = "marketplace.visualstudio.com"
 
$Uri = "$($baseProtocol)//$($baseHostName)/items?itemName=$($PackageName)"
$VsixLocation = "$($env:Temp)\$([guid]::NewGuid()).vsix"
if ($IsExe) 
{
    $VsixLocation = "$($env:Temp)\$([guid]::NewGuid()).exe"
}
 
$VSInstallDir = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\resources\app\ServiceHub\Services\Microsoft.VisualStudio.Setup.Service"
 
if (-Not $VSInstallDir) {
  Write-Error "Visual Studio InstallDir registry key missing"
  Exit 1
}
 
Write-Host "Grabbing VSIX extension at $($Uri)"
$HTML = Invoke-WebRequest -Uri $Uri -UseBasicParsing -SessionVariable session
 
Write-Host "Attempting to download $($PackageName)..."
$anchor = $HTML.Links |
Where-Object { $_.class -eq 'install-button-container' } |
Select-Object -ExpandProperty href

if (-Not $anchor) {
  Write-Error "Could not find download anchor tag on the Visual Studio Extensions page"
  Exit 1
}
Write-Host "Anchor is $($anchor)"
$href = "$($baseProtocol)//$($baseHostName)$($anchor)"
Write-Host "Href is $($href)"
Invoke-WebRequest $href -OutFile $VsixLocation -UseBasicParsing -WebSession $session
 
if (-Not (Test-Path $VsixLocation)) {
  Write-Error "Downloaded VSIX file could not be located"
  Exit 1
}

if ($IsExe)
{
    Start-Process -Filepath "$($VsixLocation)" -ArgumentList "/quiet" -Wait
}
else
{
    Write-Host "VSInstallDir is $($VSInstallDir)"
    Write-Host "VsixLocation is $($VsixLocation)"
    Write-Host "Installing $($PackageName)..."
    Start-Process -Filepath "$($VSInstallDir)\VSIXInstaller" -ArgumentList "/q /a $($VsixLocation)" -Wait
}

Write-Host "Cleanup..."
#rm $VsixLocation
 
Write-Host "Installation of $($PackageName) complete!"