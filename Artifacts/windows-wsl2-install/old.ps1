


# ### Setting registry key to avoid "Welcome to WSL" on WSL first launch
# $regPath="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss"
# New-Item -Path $regPath -Force | out-null
# Set-ItemProperty -Path $regPath -Name "OOBEComplete" -Value 1 -Force | out-null


# # new-itemproperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name install  -Value "powershell -ExecutionPolicy bypass -File c:\programdata\scripts\test.ps1"  -Force | out-null;

# $TaskName = "Install WSL"
# $adminName = "afi"

# $myScript = @"
# WSL --install --no-launch
# Disable-ScheduledTask -TaskName "$TaskName"
# # Restart-Computer
# "@

# New-Item -Path "C:\ProgramData\scripts" -ItemType Directory -Force | out-null

# $myScript | Set-Content -Path "C:\ProgramData\scripts\wsl.ps1" 


# # Define the task details

# $TaskDescription = "Installs WSL as the current user with elevated privileges upon logon."
# $ActionPath = "powershell.exe"
# # *** REPLACE with your script path ***
# $ActionArguments = "-ExecutionPolicy Bypass -File `"C:\programdata\scripts\wsl.ps1`" -windowstyle hidden -noninteractive "

# # --- 1. Define the Action (What to run) ---
# $TaskAction = New-ScheduledTaskAction -Execute $ActionPath -Argument $ActionArguments

# # --- 2. Define the Trigger (When to run) ---
# # Creates a trigger that fires 'At logon for *this* user'
# # Use '-User $env:UserName' to target only the user running the script
# $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:COMPUTERNAME\$adminName"

# # --- 3. Define the Principal (Who runs and with what rights) ---
# # Use $env:USERNAME to specify the current user.
# # Use '-RunLevel Highest' to request elevation (UAC prompt will appear if not already admin).
# $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$adminName" -RunLevel Highest

# # --- 4. Register the Scheduled Task ---
# Write-Host "Registering task: $TaskName"
# Register-ScheduledTask -TaskName $TaskName `
#     -Description $TaskDescription `
#     -Action $TaskAction `
#     -Trigger $TaskTrigger `
#     -Principal $TaskPrincipal `
#     -Force 



# --------------------------------


### Getting the WSL app from the GitHub repo

# $latestSvc = "https://api.github.com/repos/microsoft/WSL/releases/latest";
# $response = Invoke-RestMethod -URI $latestSvc -UseBasicParsing
# $download_url=""

# foreach ($item in $response.assets){
#   if($item.browser_download_url.contains("x64.msi")){
#     $download_url=$item.browser_download_url;
#   }
# } 

# Invoke-WebRequest -uri $download_url -UseBasicParsing -OutFile "$env:TEMP\wsl2.msi"
# 'wow!'

# & msiexec /i "$env:TEMP\wsl3.msi" /quiet /l*v "$env:TEMP\wsl3.log"  | out-null
# get-content "$env:TEMP\wsl3.log" | Out-Default
# "wow again"


#$latestSvc = "https://api.github.com/repos/microsoft/WSL/releases/latest";
#$response = Invoke-RestMethod -URI $latestSvc -UseBasicParsing
#$download_url = $response.assets[0].browser_download_url

#Invoke-WebRequest -uri $download_url -UseBasicParsing -OutFile "$env:TEMP\wsl2.msixbundle"
#Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\wsl2.msixbundle"  -Regions all 
#Add-AppxPackage -Path "$env:TEMP\wsl2.msixbundle"  


### Instaling store apps using the store links from the adguard website.
### This is a kind of web scraping. Not perferct at all! 

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


### Old way of getting the Kernel update

# Invoke-WebRequest -UseBasicParsing -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile "$env:temp\wsl_update_x64.msi"  
# & msiexec /i "$env:temp\wsl_update_x64.msi" /quiet 

### more recent version of kernel update  (is it necessary anymore???)
# $link="https://catalog.s.download.windowsupdate.com/d/msdownload/update/software/updt/2022/03/wsl_update_x64_8b248da7042adb19e7c5100712ecb5e509b3ab5f.cab"
# Invoke-WebRequest -UseBasicParsing -uri $link  -OutFile "$env:temp\wslupdate.cab"

# & expand "$env:temp\wslupdate.cab" /f:* "$env:temp\wslupdate.msi"

# New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss" -Name WslInstalling -Value 1 -PropertyType string
# & msiexec /i "$env:temp\wslupdate.msi" /quiet /l*v C:\windows\temp\mis.log
# Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss" -Name WslInstalling

# get-content -path  C:\windows\temp\mis.log

# remove-item "$env:temp\wslupdate.cab" -force
# remove-item "$env:temp\wslupdate.msi" -Recurse  -force

##############

#wsl.exe --status
#wsl.exe --update
# & wsl.exe --install --inbox --no-distribution --no-launch | out-default
# & wsl.exe --install --web-download --no-launch --no-distribution | out-default

#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


#(get-command wsl).path

# Restart-Computer
