param (
    [switch]$IsVhd,
    [switch]$RemapTemp,
    [string]$DriveLetter = "P"
)

$vhd = "C:\ProgramData\disks\devDrive.vhdx"

if ($IsVhd) {
    New-Item -ItemType Directory -Path "C:\ProgramData\disks" -Force | Out-Null
   
    out-file -filePath $env:temp\dp.txt -Encoding utf8  -InputObject @"
    rem select volume ${DriveLetter}
    rem remove letter=${DriveLetter}
    create vdisk file="C:\ProgramData\disks\devDrive.vhdx" maximum=52000 type=expandable
    attach vdisk
    convert gpt
    create partition primary
    assign letter=${DriveLetter}
    rem format quick fs=ntfs label=DevDrive
"@ 

     
}
else {
    out-file -filePath $env:temp\dp.txt -Encoding utf8  -InputObject @"
    select volume c
    shrink desired=53000
    rem select volume ${DriveLetter}
    rem remove letter=${DriveLetter}
    select disk 0
    create partition primary
    assign letter=${DriveLetter}
"@

}


& DiskPart /s $env:temp\dp.txt 
& remove-item $env:temp\dp.txt

& Format ${DriveLetter}: /v:DevDrive /DevDrv /Q /y 
& fsutil devdrv trust /f ${DriveLetter}: 


#####


New-Item -ItemType Directory -Path "${DriveLetter}:\Packages" -Force | out-null 
New-Item -ItemType Directory -Path "${DriveLetter}:\Packages\npm" -Force | out-null
New-Item -ItemType Directory -Path "${DriveLetter}:\Packages\.nuget" -Force | out-null
New-Item -ItemType Directory -Path "${DriveLetter}:\Packages\.nuget\packages" -Force | out-null
New-Item -ItemType Directory -Path "${DriveLetter}:\Packages\vcpkg" -Force | out-null 
New-Item -ItemType Directory -Path "${DriveLetter}:\Packages\pip" -Force | out-null
New-Item -ItemType Directory -Path "${DriveLetter}:\Packages\cargo" -Force | out-null
New-Item -ItemType Directory -Path "${DriveLetter}:\Packages\cargo" -Force | out-null
New-Item -ItemType Directory -Path "${DriveLetter}:\Projects" -Force | out-null


New-Item -ItemType Directory -Path "${DriveLetter}:\temp" -Force | out-null 

& SETX /M npm_config_cache ${DriveLetter}:\Packages\npm
& SETX /M NUGET_PACKAGES ${DriveLetter}:\Packages\.nuget\packages
& SETX /M RestorePackagesPath ${DriveLetter}:\Packages\.nuget\packages
& SETX /M VCPKG_DEFAULT_BINARY_CACHE ${DriveLetter}:\Packages\vcpkg
& SETX /M PIP_CACHE_DIR ${DriveLetter}:\Packages\pip
& SETX /M CARGO_HOME ${DriveLetter}:\Packages\cargo




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
        -Value "${DriveLetter}:\temp" -PropertyType string `
        -Force | out-null

    # use temp folder on dev drive                 
    New-ItemProperty -path "HKU:Default\Environment" `
        -name TMP `
        -Value "${DriveLetter}:\temp" -PropertyType string `
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
    
     
    


 
