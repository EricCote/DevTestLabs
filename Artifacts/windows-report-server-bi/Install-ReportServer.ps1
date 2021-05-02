

#https://download.microsoft.com/download/7/0/A/70AD68EF-5085-4DF2-A3AB-D091244DDDBF/PBIDesktopRS_x64.msi

$wc = new-object System.Net.WebClient
 
$wc.DownloadFile("https://download.microsoft.com/download/7/0/A/70AD68EF-5085-4DF2-A3AB-D091244DDDBF/PowerBIReportServer.exe", "d:\PowerBIReportServer.exe")
$wc.Dispose()

& "d:\PowerBIReportServer.exe" /Passive /IAcceptLicenseTerms /Edition=Eval | out-default
# & "d:\PowerBIReportServer.exe" /uninstall


#  & "C:\Program Files\Microsoft Power BI Report Server\Shared Tools\RSConfig.exe" -c -s localhost -d reportserver -a Windows 
#  & "C:\Program Files\Microsoft Power BI Report Server\Shared Tools\rskeymgmt.exe" -l -i PBIRS


Install-Module -Name ReportingServicesTools -Force

Connect-RsReportServer -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"
Set-RsDatabase -DatabaseServerName "localhost" -DatabaseCredentialType "ServiceAccount" -name "ReportServer"  -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"   -confirm:$false
Set-PbiRsUrlReservation   -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"

Stop-Service PowerBIReportServer
Start-Service PowerBIReportServer

Initialize-Rs -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"


$wc = new-object System.Net.WebClient
 
$wc.DownloadFile("https://download.microsoft.com/download/7/0/A/70AD68EF-5085-4DF2-A3AB-D091244DDDBF/PBIDesktopRS_x64.msi", "d:\PBIDesktopRS_x64.msi")
$wc.DownloadFile("https://download.microsoft.com/download/F/F/9/FF945E45-7D61-49DD-B982-C5D93D3FB0CF/PowerBiReportBuilder.en-US.msi", "d:\PowerBiReportBuilder.en-US.msi")
$wc.DownloadFile("https://download.microsoft.com/download/7/3/8/73806360-39F4-4EFA-8369-27F4488C764C/SSRS.MobileReportPublisher.Installer.msi", "d:\SSRS.MobileReportPublisher.Installer.msi")
$wc.DownloadFile("https://download.microsoft.com/download/5/E/B/5EB40744-DC0A-47C0-8B0A-1830E74D3C23/ReportBuilder.msi", "d:\ReportBuilder.msi")

$wc.Dispose()


& msiexec /i  "d:\PBIDesktopRS_x64.msi" /passive ACCEPT_EULA=1  | out-default
& msiexec /i  "d:\PowerBiReportBuilder.en-US.msi" /quiet   | out-default
& msiexec /i  "d:\SSRS.MobileReportPublisher.Installer.msi" /quiet   | out-default
& msiexec /i  "d:\ReportBuilder.msi" /quiet   | out-default


