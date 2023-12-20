[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'

$chromeEnterpriseMSIUri = 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi'

#download chrome
Invoke-WebRequest -Uri $chromeEnterpriseMSIUri -OutFile "$env:temp\chrome.msi" -UseBasicParsing;

#install chrome
msiexec /q /i "$env:temp\chrome.msi"  ALLUSERS=1 | out-null

