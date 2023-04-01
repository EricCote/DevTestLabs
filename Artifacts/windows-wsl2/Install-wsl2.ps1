$ProgressPreference = 'SilentlyContinue'

Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -online -norestart
Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux"  -online  -norestart


#$latestSvc = "https://api.github.com/repos/microsoft/WSL/releases/latest";
#$response = Invoke-RestMethod -URI $latestSvc -UseBasicParsing
#$download_url = $response.assets[0].browser_download_url


#Invoke-WebRequest -uri $download_url -UseBasicParsing -OutFile "$env:TEMP\wsl2.msixbundle"
#Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\wsl2.msixbundle"  -Regions all 
#Add-AppxPackage -Path "$env:TEMP\wsl2.msixbundle"  


Invoke-WebRequest -UseBasicParsing -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile "$env:temp\wsl_update_x64.msi"  
& msiexec /i "$env:temp\wsl_update_x64.msi" /quiet 

#wsl.exe --status
#wsl.exe --update
#& wsl.exe --install

#(get-command wsl).path

Restart-Computer