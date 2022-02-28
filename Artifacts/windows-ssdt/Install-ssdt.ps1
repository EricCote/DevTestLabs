#------------old ssdt 2015 setup
#------------start

# $source = "https://go.microsoft.com/fwlink/?linkid=846626"
# $destination = "$env:temp\ssdtsetup.exe"

# (New-Object System.Net.WebClient).DownloadFile($Source, $Destination)

# & $Destination INSTALLALL=1 /quiet | out-default

#------------end

#SSDT 2019

& .\install-vsix   -PackageName "ProBITools.MicrosoftAnalysisServicesModelingProjects"

& .\install-vsix   -PackageName "ProBITools.MicrosoftReportProjectsforVisualStudio"

& .\install-vsix   -PackageName "SSIS.SqlServerIntegrationServicesProjects" -IsExe

