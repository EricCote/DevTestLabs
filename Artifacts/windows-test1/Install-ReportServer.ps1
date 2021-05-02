
$path="C:\bi"
mkdir $path
$out="$path\out.txt"


#  & "C:\Program Files\Microsoft Power BI Report Server\Shared Tools\RSConfig.exe" -c -s localhost -d reportserver -a Windows 
#  & "C:\Program Files\Microsoft Power BI Report Server\Shared Tools\rskeymgmt.exe" -l -i PBIRS

Install-Module -Name ReportingServicesTools -Force

"install-module" | Out-File  -FilePath $out -append

Connect-RsReportServer -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"
"Connect-RsReportServer" | Out-File  -FilePath $out -append
Set-RsDatabase -DatabaseServerName "localhost" -DatabaseCredentialType "ServiceAccount" -name "ReportServer"  -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"   -confirm:$false
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
