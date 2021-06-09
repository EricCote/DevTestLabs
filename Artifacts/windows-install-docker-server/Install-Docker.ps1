#install
$ProgressPreference = 'SilentlyContinue'

Install-WindowsFeature -Name Hyper-V, Containers -IncludeAllSubFeature -IncludeManagementTools -restart


# Install-WindowsFeature -name Microsoft-Windows-Subsystem-Linux -restart
#c:\tools\psexec -sid powershell

#Invoke-WebRequest -uri "https://aka.ms/wslubuntu2004" -UseBasicParsing -OutFile "$env:TEMP\Ubuntu.appx"

#Rename-Item "$env:TEMP\Ubuntu.appx" "$env:TEMP\Ubuntu.zip" -force
#Expand-Archive "$env:TEMP\Ubuntu.zip" "$env:TEMP\Ubuntu" -force

#& "$env:TEMP\Ubuntu\ubuntu2004.exe"
#& "C:\Windows\TEMP\Ubuntu\ubuntu2004.exe"




Install-PackageProvider -Name NuGet   -force;
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Install-Package -Name docker -ProviderName DockerMsftProvider -Force


$configfile = @"
{ "experimental": true }
"@
Out-File -FilePath C:\ProgramData\docker\config\daemon.json -InputObject $configfile -Encoding ascii -Force


Stop-service Docker -ErrorAction SilentlyContinue


[Environment]::SetEnvironmentVariable("LCOW_SUPPORTED", "1", "Machine")
[Environment]::SetEnvironmentVariable("LCOW_API_PLATFORM_IF_OMITTED", "linux", "Machine")
 

Invoke-WebRequest -Uri "https://github.com/linuxkit/lcow/releases/download/v4.14.35-v0.3.9/release.zip" -UseBasicParsing -OutFile "$env:temp\release.zip"
Expand-Archive "$env:temp\release.zip" -DestinationPath "$Env:ProgramFiles\Linux Containers\."

refreshenv
Start-Service docker 

docker image pull mcr.microsoft.com/windows/servercore:ltsc2019
docker image pull mcr.microsoft.com/windows/nanoserver:1809  
docker image pull mcr.microsoft.com/dotnet/core/aspnet
docker image pull mcr.microsoft.com/dotnet/core/sdk

docker image pull alpine

#Uninstall-Package -name docker
#unInstall-Module -Name DockerMsftProvider
#uninstall-windowsFeature -Name Containers


