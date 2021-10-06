
#Enable-WindowsOptionalFeature -FeatureName HypervisorPlatform -online -norestart  
#Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All  -online -norestart

$ProgressPreference = 'SilentlyContinue'

#install
Invoke-WebRequest -uri "https://desktop.docker.com/win/stable/amd64/Docker%20Desktop%20Installer.exe" -UseBasicParsing -OutFile "$env:TEMP\installDocker.exe"
 
& "$env:TEMP\installDocker.exe" install --quiet  | out-null
 

while ((net localgroup) -inotcontains "*docker-users")
  {
      & ping 127.0.0.1 -n 10 
      out-file  "c:\programdata\script\result.txt" "Wait 10 "  -Append
  }
& net localgroup docker-users afi /add *>&1 | out-file "c:\programdata\script\result.txt" -Append
# & schtasks.exe /change  /tn DockerTask /disable
#"@


#mkdir -path $env:ProgramData\script -Force
#$part2 | Out-File "$env:ProgramData\script\Docker.ps1"


#& schtasks.exe /create /f /tn DockerTask /sc ONSTART /rl HIGHEST /RU "NT AUTHORITY\SYSTEM"  /tr "powershell.exe -ExecutionPolicy bypass -file c:\programdata\script\Docker.ps1"
#restart-computer




#install


# refreshenv
# Start-Service docker 

# docker image pull alpine



