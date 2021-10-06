$ProgressPreference = 'SilentlyContinue'

#install
Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -online -norestart
Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux"  -online  -norestart


Invoke-WebRequest -UseBasicParsing -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile "$env:temp\wsl_update_x64.msi"  
Invoke-WebRequest -uri "https://aka.ms/wslubuntu2004" -UseBasicParsing -OutFile "$env:TEMP\Ubuntu.appx"
Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\Ubuntu.appx"  -Regions all 



##################################
# Load default user registry
##################################
New-PSDrive HKU Registry HKEY_USERS 
& REG LOAD HKU\Default C:\Users\Default\NTUSER.DAT 

# set default version to 2
New-Item -path "HKU:\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss" -Force
New-ItemProperty -path "HKU:\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss" `
                    -name DefaultVersion `
                    -Value 2 -PropertyType dword `
                    -Force 

#for explanation: https://stackoverflow.com/questions/25438409/reg-unload-and-new-key
[gc]::Collect()
& REG UNLOAD HKU\Default 
Remove-PSDrive HKU

$Part2 = @"
 & msiexec /i "c:\windows\temp\wsl_update_x64.msi" /quiet ;
 & schtasks.exe /change /tn WSL2RestartTask /disable
 ## restart-computer
"@

mkdir -path "$env:ProgramData\script" -Force
$part2 | Out-File "$env:ProgramData\script\wsl2.ps1"


& schtasks.exe /create /f /tn WSL2RestartTask /sc ONSTART /rl HIGHEST /RU "NT AUTHORITY\SYSTEM"  /tr "powershell.exe -ExecutionPolicy bypass -File c:\programdata\script\wsl2.ps1"
restart-computer




 #Install-Module PendingReboot  
 #Test-PendingReboot -Detailed



# & msiexec /i "$env:temp\wsl_update_x64.msi" /quiet
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


