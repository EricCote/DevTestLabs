
$path="C:\bi"
mkdir $path
$out="$path\out.txt"

$wc = new-object System.Net.WebClient
$wc.DownloadFile("https://download.microsoft.com/download/7/0/A/70AD68EF-5085-4DF2-A3AB-D091244DDDBF/PowerBIReportServer.exe", "$path\PowerBIReportServer.exe")

$wc.DownloadFile("https://download.microsoft.com/download/7/0/A/70AD68EF-5085-4DF2-A3AB-D091244DDDBF/PBIDesktopRS_x64.msi", "$path\PBIDesktopRS_x64.msi")
$wc.DownloadFile("https://download.microsoft.com/download/F/F/9/FF945E45-7D61-49DD-B982-C5D93D3FB0CF/PowerBiReportBuilder.en-US.msi", "$path\PowerBiReportBuilder.en-US.msi")
$wc.DownloadFile("https://download.microsoft.com/download/7/3/8/73806360-39F4-4EFA-8369-27F4488C764C/SSRS.MobileReportPublisher.Installer.msi", "$path\SSRS.MobileReportPublisher.Installer.msi")
$wc.DownloadFile("https://download.microsoft.com/download/5/E/B/5EB40744-DC0A-47C0-8B0A-1830E74D3C23/ReportBuilder.msi", "$path\ReportBuilder.msi")
$wc.Dispose()

& "$path\PowerBIReportServer.exe" /quiet /IAcceptLicenseTerms /Edition=Eval | out-default


#  & "C:\Program Files\Microsoft Power BI Report Server\Shared Tools\RSConfig.exe" -c -s localhost -d reportserver -a Windows 
#  & "C:\Program Files\Microsoft Power BI Report Server\Shared Tools\rskeymgmt.exe" -l -i PBIRS

$pwd1 = ConvertTo-SecureString 'afi123123123!' -AsPlainText -Force
$afiCredentials = New-Object System.Management.Automation.PSCredential ("afi", $pwd1)


Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208  -force;
Install-Module -Name ReportingServicesTools -Force;

"install-module" | Out-File  -FilePath $out -append

Connect-RsReportServer -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"
"Connect-RsReportServer" | Out-File  -FilePath $out -append
Set-RsDatabase -DatabaseServerName "localhost" -DatabaseCredentialType "windows" -DatabaseCredential $afiCredentials  -name "ReportServer"  -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"   -confirm:$false
"Set-RsDatabase" | Out-File  -FilePath $out -append
Set-PbiRsUrlReservation   -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"
"Set-PbiRsUrlReservation " | Out-File  -FilePath $out -append


Stop-Service PowerBIReportServer
Start-Service PowerBIReportServer

"restart service" | Out-File  -FilePath $out -append

Initialize-Rs -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"
"init rs" | Out-File  -FilePath $out -append

& msiexec /i  "$path\PBIDesktopRS_x64.msi" /quiet ACCEPT_EULA=1  | out-default
& msiexec /i  "$path\PowerBiReportBuilder.en-US.msi" /quiet   | out-default
& msiexec /i  "$path\SSRS.MobileReportPublisher.Installer.msi" /quiet   | out-default
& msiexec /i  "$path\ReportBuilder.msi" /quiet   | out-default

"All installed" | Out-File  -FilePath $out -append


