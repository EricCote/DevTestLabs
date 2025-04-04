# del C:\programdata\disks\devDrive.vhdx

# New-Item -ItemType Directory -Path "C:\ProgramData\disks" -Force | Out-Null


# create vdisk file=C:\programdata\disks\devDrive.vhdx maximum=52000 type=fixed
# attach vdisk
# convert gpt

out-file -filePath $env:temp\dp.txt -Encoding utf8  -InputObject @"
select volume c
shrink desired=53000
select volume d
remove letter=d
select disk 0
create partition primary
assign letter=d 
"@

& DiskPart /s $env:temp\dp.txt 

& remove-item $env:temp\dp.txt 

& Format D: /v:DevDrive /DevDrv /Q /y 

& fsutil devdrv trust d: /V

# does not work :-(
# Get-VirtualDisk | Where-Object {$_.IsManualAttach -eq $True} | Set-VirtualDisk -IsManualAttach $False

#####


New-Item -ItemType Directory -Path "d:\Packages" -Force | out-null 
New-Item -ItemType Directory -Path "d:\Packages\npm" -Force | out-null
New-Item -ItemType Directory -Path "d:\Packages\.nuget" -Force | out-null
New-Item -ItemType Directory -Path "D:\Packages\.nuget\packages" -Force | out-null
New-Item -ItemType Directory -Path "d:\Packages\vcpkg" -Force | out-null 
New-Item -ItemType Directory -Path "d:\Packages\pip" -Force | out-null
New-Item -ItemType Directory -Path "d:\Packages\cargo" -Force | out-null

New-Item -ItemType Directory -Path "d:\temp" -Force | out-null 

& SETX /M npm_config_cache D:\Packages\npm
& SETX /M NUGET_PACKAGES D:\Packages\.nuget\packages
& SETX /M RestorePackagesPath D:\Packages\.nuget\packages
& SETX /M VCPKG_DEFAULT_BINARY_CACHE D:\Packages\vcpkg
& SETX /M PIP_CACHE_DIR D:\Packages\pip
& SETX /M CARGO_HOME D:\Packages\cargo




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

