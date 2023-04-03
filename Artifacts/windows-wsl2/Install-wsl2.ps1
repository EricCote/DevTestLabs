$ProgressPreference = 'SilentlyContinue'

# Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -online -norestart
# Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux"  -online  -norestart


#$latestSvc = "https://api.github.com/repos/microsoft/WSL/releases/latest";
#$response = Invoke-RestMethod -URI $latestSvc -UseBasicParsing
#$download_url = $response.assets[0].browser_download_url


#Invoke-WebRequest -uri $download_url -UseBasicParsing -OutFile "$env:TEMP\wsl2.msixbundle"
#Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\wsl2.msixbundle"  -Regions all 
#Add-AppxPackage -Path "$env:TEMP\wsl2.msixbundle"  


# Invoke-WebRequest -UseBasicParsing -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile "$env:temp\wsl_update_x64.msi"  
# & msiexec /i "$env:temp\wsl_update_x64.msi" /quiet 

###

# $ProgressPreference = 'SilentlyContinue'

# function install-appx($name, $id){
#   $postParams = @{type='ProductId';url=$id ;ring='Retail';lang='en-US'}
  
#   $res = invoke-webrequest  -UseBasicParsing `
#      -Uri "https://store.rg-adguard.net/api/GetFiles" `
#      -ContentType "application/x-www-form-urlencoded" `
#      -Body $postParams `
#      -Method Post

#   $link = $res.links[1].href

#   Invoke-WebRequest -UseBasicParsing -uri $link  -OutFile "$env:temp\$name"
  
#   Add-AppxProvisionedPackage -SkipLicense -PackagePath "$env:temp\$name" -online

#   Remove-Item "$env:temp\$name" -force
# }

# install-appx -name "wsl.msixbundle" -id "9P9TQF7MRM4R"

# install-appx -name "ubuntu.appxbundle" -id "9NBLGGH4MSV6"

###

$link="https://catalog.s.download.windowsupdate.com/d/msdownload/update/software/updt/2022/03/wsl_update_x64_8b248da7042adb19e7c5100712ecb5e509b3ab5f.cab"
Invoke-WebRequest -UseBasicParsing -uri $link  -OutFile "$env:temp\wslupdate.cab"

& expand "$env:temp\wslupdate.cab" /f:* "$env:temp\wslupdate.msi"



New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss" -Name WslInstalling -Value 1
& msiexec /i "$env:temp\wslupdate.msi" /quiet
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss" -Name WslInstalling

remove-item "$env:temp\wslupdate.cab" -force
remove-item "$env:temp\wslupdate.msi" -Recurse  -force



#wsl.exe --status
#wsl.exe --update
#& wsl.exe --install

#(get-command wsl).path

Restart-Computer
