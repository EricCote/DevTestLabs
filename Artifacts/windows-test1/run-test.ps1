$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -uri "https://aka.ms/wsl-ubuntu-1604" -UseBasicParsing -OutFile "$env:TEMP\Ubuntu16.appx"
Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\Ubuntu16.appx"






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


