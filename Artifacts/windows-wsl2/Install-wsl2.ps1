Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -online -norestart
Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux"  -online  -norestart


#$latestSvc = "https://api.github.com/repos/microsoft/WSL/releases/latest";
#$response = Invoke-RestMethod -URI $latestSvc -UseBasicParsing
#$download_url = $response.assets[0].browser_download_url


#Invoke-WebRequest -uri $download_url -UseBasicParsing -OutFile "$env:TEMP\wsl2.msixbundle"
#Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\wsl2.msixbundle"  -Regions all 
#Add-AppxPackage -Path "$env:TEMP\wsl2.msixbundle"  

wsl --status
wsl --update
wsl --install