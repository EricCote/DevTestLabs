

$wc = new-object System.Net.WebClient
 
$wc.DownloadFile("http://download.microsoft.com/download/7/2/8/7285472F-D0D2-4537-93C2-86EBB63DC68C/20764C-ENU-Allfiles.exe", "c:\dbBackup\20764C-ENU-Allfiles.exe")
$wc.Dispose()

& "c:\dbBackup\20764C-ENU-Allfiles.exe"  -s -dc:\Labs


$admins= @("localmachine\afi","NT AUTHORITY\SYSTEM")
$adminString= ($admins | ForEach-Object  {($_ -replace "localmachine\\", "$env:computername\") -replace "(.+)", '"$1"'} )  -join " " -replace '^\"(.+)\"', '$1'
$adminString2 = $adminString ;

$isoFile2 = "c:\sqlISO\SQLServer2019-x64-ENU-Dev.iso" ;

#Mount iso
Mount-DiskImage $isoFile2    

$mountedVolume = Get-DiskImage -ImagePath $isoFile2 | Get-Volume
$isoFileLetter = "$($mountedVolume.DriveLetter):"

$setupFile= "$isoFileletter\setup.exe"


  &  "$setupFile" /q `
                       /Action=install `
                       /FEATURES=SQL `
                       /SuppressPrivacyStatementNotice `
                       /IAcceptSqlServerLicenseTerms `
                       /InstanceName=sql2 `
                       /SqlSysAdminAccounts= $adminString2 `
                       /SqlSvcInstantFileInit `
                       /tcpEnabled=1 `
                       /UpdateEnabled=true `
                       /UpdateSource="c:\cu" `
                       | Out-Default



  &  "$setupFile" /q `
                       /Action=install `
                       /FEATURES=SQL `
                       /SuppressPrivacyStatementNotice `
                       /IAcceptSqlServerLicenseTerms `
                       /InstanceName=sql3 `
                       /SqlSysAdminAccounts= $adminString2 `
                       /SqlSvcInstantFileInit `
                       /tcpEnabled=1 `
                       /UpdateEnabled=true `
                       /UpdateSource="c:\cu" `
                       | Out-Default



   dismount-DiskImage $isoFile2  


   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices" -Name "d:" -Value "\??\C:\Labs"

