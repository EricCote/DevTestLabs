$ProgressPreference = 'SilentlyContinue'
### Enabling services for WSL
Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform, Microsoft-Windows-Subsystem-Linux -online -norestart

Restart-Computer 

