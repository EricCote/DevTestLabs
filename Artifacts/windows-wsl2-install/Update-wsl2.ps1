



 $ProgressPreference = 'SilentlyContinue'

$regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Lxss"

New-Item -Path $regPath -Force | out-null
new-itemproperty -Path $regPath -Name "OOBEComplete" -Value "1"  -Force | out-null

 $latestSvc = "https://api.github.com/repos/microsoft/WSL/releases/latest";
 $response = Invoke-RestMethod -URI $latestSvc -UseBasicParsing
 $download_url=""
 foreach ($item in $response.assets){
    if($item.browser_download_url.contains("x64.msi")){
     $download_url=$item.browser_download_url;
   }
 }
 
Invoke-WebRequest -uri $download_url -UseBasicParsing -OutFile "$env:TEMP\wsl2.msi" 

"Downloaded"

 & msiexec /i "$env:TEMP\wsl2.msi" /quiet /l*v "$env:TEMP\wsl2.log"  | out-default

"Installed WSL2"
"---------------"

 # & C:\Windows\System32\wsl.exe --install ubuntu --no-launch | out-default

"---------------"

 # get-content "$env:TEMP\wsl2.log" | Out-Default
 


