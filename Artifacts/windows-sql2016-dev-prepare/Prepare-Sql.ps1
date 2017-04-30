#$source = "http://go.microsoft.com/fwlink/?LinkID=799009"
#$dest =  "$env:userprofile\downloads\SQLServer2016-SSEI-Dev.exe"    

#& $dest /ConfigurationFile=C:\sqlsource\ConfigurationFile.ini  /iAcceptSqlServerLicenseTerms /mediaPath=c:\sqlSource /ENU


#Download SqlServer 2016 SP1
$source = "https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLServer2016SP1-FullSlipstream-x64-ENU-DEV.iso"
$isoFile =  "$env:temp\SQLServer2016SP1-FullSlipstream-x64-ENU-DEV.iso"    

$wc = new-object System.Net.WebClient
$wc.DownloadFile($Source,$isoFile)
$wc.Dispose()


#remove newer c++ redistribuable from 2017
$vcRemove32="C:\ProgramData\Package Cache\{c239cea1-d49e-4e16-8e87-8c055765f7ec}\VC_redist.x86.exe"
$vcRemove64="C:\ProgramData\Package Cache\{f1e7e313-06df-4c56-96a9-99fdfd149c51}\VC_redist.x64.exe"
if (Test-Path $vcRemove32)
{
    & $vcRemove32  /uninstall  /quiet | Out-Default   
}
if (Test-Path $vcRemove64)
{
    & $vcRemove64  /uninstall  /quiet | Out-Default   
}

Mount-DiskImage $isoFile
$mountedVolume = Get-DiskImage -ImagePath $isoFile | Get-Volume
$isoFileLetter = "$($mountedVolume.DriveLetter):"



& $isoFileletter\setup.exe /q `
                       /Action=PrepareImage `
                       /Features=SQL,AS,RS,IS,DQC,MDS,ADVANCEDANALYTICS `
                       /SuppressPrivacyStatementNotice `
                       /IAcceptROpenLicenseTerms `
                       /IAcceptSqlServerLicenseTerms `
                       /InstanceID=MSSQLSERVER `
                       | Out-Default


Dismount-DiskImage $isoFile


