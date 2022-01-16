$ProgressPreference = 'SilentlyContinue'


$path="C:\bi"
mkdir $path
$out="$path\out.txt"


$link1="https://aka.ms/pbireportserver"
$result= Invoke-WebRequest -Uri $link1 -UseBasicParsing -MaximumRedirection 0 -ErrorAction ignore
$result.Headers.Location -match "=(.*)"
$num = $matches[1]

$page = (Invoke-WebRequest "https://www.microsoft.com/en-us/download/confirmation.aspx?id=$num"  -UseBasicParsing).RawContent
$myMatches = [regex]::Matches($page,'{url:\"(.*?)\"')
$links = $myMatches | % { $_.Groups[1].value}
$links | % {  Invoke-WebRequest -Uri $_  -UseBasicParsing -OutFile $(Join-path -path $env:TEMP -ChildPath $( split-path $_  -Leaf))    }


$page = (Invoke-WebRequest "https://www.microsoft.com/en-us/download/confirmation.aspx?id=58158"  -UseBasicParsing).RawContent
$page -match '{url:\"(.*?)\"'
$reportBuilderSrc = $matches[1]
Invoke-WebRequest -Uri $reportBuilderSrc  -UseBasicParsing -OutFile $(Join-path -path $env:TEMP -ChildPath $( split-path $reportBuilderSrc  -Leaf))


$page = (Invoke-WebRequest "https://www.microsoft.com/en-us/download/confirmation.aspx?id=50400"  -UseBasicParsing).RawContent
$page -match '{url:\"(.*?)\"'
$reportMobileSrc = $matches[1]
Invoke-WebRequest -Uri $reportMobileSrc  -UseBasicParsing -OutFile $(Join-path -path $env:TEMP -ChildPath $( split-path $reportMobileSrc -Leaf))



$page = (Invoke-WebRequest "https://www.microsoft.com/en-us/download/confirmation.aspx?id=53613"  -UseBasicParsing).RawContent
$page -match '{url:\"(.*?)\"'
$reportBuilderSrc = $matches[1]
Invoke-WebRequest -Uri $reportBuilderSrc  -UseBasicParsing -OutFile $(Join-path -path $env:TEMP -ChildPath $( split-path $reportBuilderSrc -Leaf))


$path = $env:temp


& "$path\PowerBIReportServer.exe" /quiet /IAcceptLicenseTerms /Edition=Eval | out-default

#  & "C:\Program Files\Microsoft Power BI Report Server\Shared Tools\RSConfig.exe" -c -s localhost -d reportserver -a Windows 
#  & "C:\Program Files\Microsoft Power BI Report Server\Shared Tools\rskeymgmt.exe" -l -i PBIRS

Install-PackageProvider -Name NuGet   -force;
Install-Module -Name ReportingServicesTools -Force;
Install-Module -Name SqlServer -Force;

"install-module" | Out-File  -FilePath $out -append

Connect-RsReportServer -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"
"Connect-RsReportServer" | Out-File  -FilePath $out -append

# -DatabaseCredential $afiCredentials
Set-RsDatabase -DatabaseServerName "localhost" -DatabaseCredentialType "ServiceAccount"   -name "ReportServer"  -ComputerName "localhost"  -ReportServerInstance "PBIRS" -ReportServerVersion "SQLServervNext"   -confirm:$false
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


