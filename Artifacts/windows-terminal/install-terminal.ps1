##install latest version of terminal
$ProgressPreference = 'SilentlyContinue'

$response = Invoke-RestMethod -Uri https://api.github.com/repos/microsoft/terminal/releases/latest
$url = ($response.assets | Where-Object {$_.content_type -eq "application/x-zip-compressed"}).browser_download_url


Invoke-WebRequest -UseBasicParsing -Uri $url  -OutFile "$env:temp\terminal.zip"
Expand-Archive -Path "$env:temp\terminal.zip" -DestinationPath "$env:temp\terminal"


$msix = Get-ChildItem -Path "$env:temp\terminal\*" -Include "*.msixbundle" -name
$license = Get-ChildItem -Path "$env:temp\terminal\*" -Include "*license*.xml" -name


Add-AppxProvisionedPackage -Online -PackagePath "$env:temp\terminal\$msix" `
     -LicensePath "$env:temp\terminal\$license" -Regions all  | out-null
