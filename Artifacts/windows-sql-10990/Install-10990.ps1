https://web.archive.org/web/20190908172512/http://download.microsoft.com/download/6/3/3/6335542B-5F26-4400-9AE2-62A5B7A19A97/10990B-ENU-Allfiles.exe
https://web.archive.org/web/20190908172512/http://download.microsoft.com/download/8/2/6/8263CDB7-1D2B-4EB1-9A9C-97063D3C3AF0/10990C-ENU-Allfiles.exe
$wc = new-object System.Net.WebClient
 
$wc.DownloadFile("https://web.archive.org/web/20190908172512/http://download.microsoft.com/download/8/2/6/8263CDB7-1D2B-4EB1-9A9C-97063D3C3AF0/10990C-ENU-Allfiles.exe", "c:\dbBackup\10990C-ENU-Allfiles.exe")
$wc.Dispose()

& "c:\dbBackup\10990C-ENU-Allfiles.exe"  -s -dc:\Labs



   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices" -Name "d:" -Value "\??\C:\Labs"

