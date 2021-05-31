#install
Invoke-WebRequest -UseBasicParsing -Uri "https://desktop.docker.com/win/stable/amd64/64133/Docker%20Desktop%20Installer.exe" -OutFile "$env:TEMP\docker.exe"
& "$env:TEMP\docker.exe" install --quiet


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


