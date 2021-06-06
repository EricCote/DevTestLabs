#install
Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux"  -online  -norestart

Invoke-WebRequest -UseBasicParsing -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile "$env:temp\wsl_update_x64.msi"  
& msiexec /i "$env:temp\wsl_update_x64.msi" /quiet

Invoke-WebRequest -uri "https://aka.ms/wslubuntu2004" -UseBasicParsing -OutFile "$env:TEMP\Ubuntu.appx"
Rename-Item "$env:TEMP\Ubuntu.appx" "$env:TEMP\Ubuntu.zip" -force
Expand-Archive "$env:TEMP\Ubuntu.zip" "$env:TEMP\Ubuntu" -force
# & "$env:TEMP\Ubuntu\ubuntu2004.exe"





# Start-service TrustedInstaller
# $p = get-ntprocess -Name TrustedInstaller.exe   
# $th= $p.getFirstThread()
# $current= get-Ntthread -Current -PseudoHandle
# $current.ImpersonateThread($th, $true)
# $imp_Token=Get-NtToken -Impersonation
# $imp_Token.Groups | Where-Object {$_.Sid.Name -match "TrustedInstaller"}







