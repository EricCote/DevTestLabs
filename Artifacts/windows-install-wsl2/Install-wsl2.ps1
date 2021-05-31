#install
Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -online -norestart
Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux"  -online  -norestart
#Enable-WindowsOptionalFeature -FeatureName HypervisorPlatform -online -norestart  
#Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All  -online -norestart
Invoke-WebRequest -UseBasicParsing -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile "$env:temp\wsl_update_x64.msi"  
Invoke-WebRequest -uri "https://aka.ms/wslubuntu2004" -UseBasicParsing -OutFile "$env:TEMP\Ubuntu.appx"

Rename-Item "$env:TEMP\Ubuntu.appx" "$env:TEMP\Ubuntu.zip" -force
Expand-Archive "$env:TEMP\Ubuntu.zip" "$env:TEMP\Ubuntu" -force

#& "$env:TEMP\Ubuntu\ubuntu2004.exe"
#& "C:\Windows\TEMP\Ubuntu\ubuntu2004.exe"


$Part2 = @"
& msiexec /i "c:\windows\temp\wsl_update_x64.msi" /quiet ;  
wsl --set-default-version 2 ;
schtasks.exe /change /f /tn WSL2RestartTask /disable
"@

mkdir -path C:\ProgramData\script -Force

$part2 | Out-File "C:\ProgramData\script\wsl2.ps1"


& schtasks.exe /create /f /tn WSL2RestartTask /sc ONSTART /rl HIGHEST /RU "NT AUTHORITY\SYSTEM"  /tr "powershell.exe -ExecutionPolicy bypass -file c:\programdata\script\wsl2.ps1"
restart-computer






