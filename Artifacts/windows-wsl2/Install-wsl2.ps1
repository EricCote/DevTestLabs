$ProgressPreference = 'SilentlyContinue'

Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -online -norestart

Invoke-WebRequest -uri "https://aka.ms/wslubuntu2004" -UseBasicParsing -OutFile "$env:TEMP\Ubuntu.appx"
Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\Ubuntu.appx"  -Regions all 


Invoke-WebRequest -uri "https://github.com/microsoft/WSL/releases/download/0.50.2/Microsoft.WSL_0.50.2.0_x64_ARM64.msixbundle" -UseBasicParsing -OutFile "$env:TEMP\wsl2.msixbundle"
Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\wsl2.msixbundle"  -Regions all 


#wsl --install
restart-computer
