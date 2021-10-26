
#Enable-WindowsOptionalFeature -FeatureName HypervisorPlatform -online -norestart  
#Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All  -online -norestart

$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -uri "https://aka.ms/wslubuntu2004" -UseBasicParsing -OutFile "$env:TEMP\Ubuntu.appx"
Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$env:TEMP\Ubuntu.appx"  -Regions all 

#install
Invoke-WebRequest -uri "https://desktop.docker.com/win/stable/amd64/Docker%20Desktop%20Installer.exe" -UseBasicParsing -OutFile "$env:TEMP\installDocker.exe"
 
& "$env:TEMP\installDocker.exe" install --quiet  | out-default
 
while ((net localgroup) -inotcontains "*docker-users")
  {
      & ping 127.0.0.1 -n 10 
      out-file  "c:\programdata\script\result.txt" "Wait 10 "  -Append
  }
& net localgroup docker-users users /add *>&1 | out-file "c:\programdata\script\result.txt" -Append

# Start-Service com.docker.service 
# docker image pull alpine



