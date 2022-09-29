$ProgressPreference = 'SilentlyContinue'

Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -online -norestart

Invoke-WebRequest -uri "https://aka.ms/wslubuntu2004" -UseBasicParsing -OutFile "$env:TEMP\Ubuntu.appx"
Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\Ubuntu.appx"  -Regions all 


$latestSvc = "https://api.github.com/repos/microsoft/WSL/releases/latest";
$response = Invoke-RestMethod -URI $latestSvc -UseBasicParsing
$download_url = $response.assets[0].url


Invoke-WebRequest -uri $download_url -UseBasicParsing -OutFile "$env:TEMP\wsl2.msixbundle"
Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\wsl2.msixbundle"  -Regions all 

Remove-Item -Path "$env:TEMP\Ubuntu.appx"  -Force
Remove-Item -Path "$env:TEMP\wsl2.msixbundle"  -Force

#wsl --install
restart-computer
