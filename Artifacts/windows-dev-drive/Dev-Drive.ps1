param (
    [switch]$IsVhd,
    [switch]$RemapTemp
)

$vhd = "C:\ProgramData\disks\devDrive.vhdx"

if ($IsVhd) {
    New-Item -ItemType Directory -Path "C:\ProgramData\disks" -Force | Out-Null
    

    out-file -filePath $env:temp\dp.txt -Encoding utf8  -InputObject @"
    create vdisk file="C:\ProgramData\disks\devDrive.vhdx" maximum=52000 type=expandable
    attach vdisk
    convert gpt
    create partition primary
    select volume d
    remove letter=d
    assign letter=e
"@ 

    & DiskPart /s $env:temp\dp.txt 
    
    & remove-item $env:temp\dp.txt 
}
else {
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

}

Start-Sleep -Seconds 2

& Format D: /v:DevDrive /DevDrv /Q /y 

& fsutil devdrv trust d: /V


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
if ($RemapTemp) {
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

}

 
if ($IsVhd) {
    #read position 00210018 
    $startPositionHex = "0x00210018"
    
    # Convert the hexadecimal starting position to a decimal integer
    $startPositionDecimal = [int64]$startPositionHex
    
    $fileStream = New-Object System.IO.FileStream($vhd, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite )
    
    # Create a BinaryReader object to read from the FileStream
    $binaryReader = New-Object System.IO.BinaryReader($fileStream)
    
    # Seek to the specified offset
    $fileStream.Seek($startPositionDecimal, [System.IO.SeekOrigin]::Begin)
    
    # Read the specified number of bytes
    $guidBytes = $binaryReader.ReadBytes(16)
    
    $guid = New-Object System.Guid(, $guidBytes)
    
    $binaryReader.Close()
    $fileStream.Close()
    $guid.ToString()
    
    
    New-Item -path "hklm:\SYSTEM\CurrentControlSet\Control\AutoAttachVirtualDisks\{$guid}" -force | Out-Null
    New-ItemProperty -Path  "hklm:\SYSTEM\CurrentControlSet\Control\AutoAttachVirtualDisks\{$guid}"  `
        -name "Path" `
        -value $vhd  `
        -force | out-null
    
}
    
     
    


