$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -uri "https://aka.ms/wslubuntu2004" -UseBasicParsing -OutFile "$env:TEMP\Ubuntu.appx"
Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\Ubuntu.appx"  -Regions all 
Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V-All"  -online  -norestart



wsl --install
restart-computer

