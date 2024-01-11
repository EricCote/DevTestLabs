New-Item -ItemType Directory -Path "C:\ProgramData\disks" -Force | Out-Null

out-file -filePath C:\ProgramData\disks\dp.txt -Encoding utf8  -InputObject @"
create vdisk file=C:\programdata\disks\devDrive.vhdx maximum=50000 type=fixed
attach vdisk
create partition  primary
assign letter=d
"@

& DiskPart /s C:\ProgramData\disks\dp.txt | Out-Null

& Format D: /v:DevDrive /DevDrv /Q /y 

New-Item -ItemType Directory -Path "d:\Packages" -Force | out-null 
New-Item -ItemType Directory -Path "d:\Packages\npm" -Force | out-null
New-Item -ItemType Directory -Path "d:\Packages\.nuget" -Force | out-null

New-Item -ItemType Directory -Path "d:\temp" -Force | out-null 

& SETX /M npm_config_cache D:\Packages\npm
& setx /M NUGET_PACKAGES D:\Packages\.nuget\packages



###############

##################################
# work with default user registry
##################################
New-PSDrive HKU Registry HKEY_USERS | out-null
& REG LOAD "HKU\Default" "C:\Users\Default\NTUSER.DAT"  | out-null

# use temp folder on dev drive
New-ItemProperty -path "HKU:Default\Environment" `
    -name TEMP `
    -Value 'D:\temp' -PropertyType string `
    -Force | out-null

# use temp folder on dev drive                 
New-ItemProperty -path "HKU:Default\Environment" `
    -name TMP `
    -Value 'D:\temp' -PropertyType string `
    -Force | out-null     
          
#for explanation: https://stackoverflow.com/questions/25438409/reg-unload-and-new-key
Remove-PSDrive HKU 
0
[gc]::Collect()
[gc]::WaitForPendingFinalizers()

Start-Sleep -Seconds 1
& REG UNLOAD "HKU\Default" | out-default
Start-Sleep -Seconds 1

