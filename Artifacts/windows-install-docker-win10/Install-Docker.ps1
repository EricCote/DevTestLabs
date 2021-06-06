
#Enable-WindowsOptionalFeature -FeatureName HypervisorPlatform -online -norestart  
#Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All  -online -norestart

# Invoke-WebRequest -uri "https://aka.ms/wslubuntu2004" -UseBasicParsing -OutFile "$env:TEMP\Ubuntu.appx"
# Rename-Item "$env:TEMP\Ubuntu.appx" "$env:TEMP\Ubuntu.zip" -force
# Expand-Archive "$env:TEMP\Ubuntu.zip" "$env:TEMP\Ubuntu" -force
# & "$env:TEMP\Ubuntu\ubuntu2004.exe"



# Start-service TrustedInstaller
# $p = get-ntprocess -Name TrustedInstaller.exe   
# $th= $p.getFirstThread()
# $current= get-Ntthread -Current -PseudoHandle
# $current.ImpersonateThread($th, $true)
# $imp_Token=Get-NtToken -Impersonation
# $imp_Token.Groups | Where-Object {$_.Sid.Name -match "TrustedInstaller"}




#install
Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -online -norestart
Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux"  -online  -norestart


Invoke-WebRequest -UseBasicParsing -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile "$env:temp\wsl_update_x64.msi"  
& msiexec /i "$env:temp\wsl_update_x64.msi" /quiet


Invoke-WebRequest -uri "https://desktop.docker.com/win/stable/amd64/Docker%20Desktop%20Installer.exe" -UseBasicParsing -OutFile "$env:TEMP\installDocker.exe"



$Part2 = @"
& msiexec /i "c:\windows\temp\wsl_update_x64.msi" /quiet ;  
& "$env:TEMP\installDocker.exe" install --quiet
net localgroup docker-users afi /add
schtasks.exe /change /f /tn WSL2RestartTask /disable
"@

mkdir -path C:\ProgramData\script -Force

$part2 | Out-File "C:\ProgramData\script\docker.ps1"


& schtasks.exe /create /f /tn WSL2RestartTask /sc ONSTART /rl HIGHEST /RU "NT AUTHORITY\SYSTEM"  /tr "powershell.exe -ExecutionPolicy bypass -file c:\programdata\script\wsl2.ps1"
restart-computer



#-----------------------------------------


#install


refreshenv
Start-Service docker 

docker image pull alpine



