$ProgressPreference = 'SilentlyContinue'


$setupExe = "$env:temp\VsCodeSetup.exe" 

$url = 'https://update.code.visualstudio.com/latest/win32-x64/stable' 

Invoke-WebRequest -Uri $url -OutFile $SetupExe -UseBasicParsing

& "$setupExe" /123 /SP- /SUPPRESSMSGBOXES /VERYSILENT /NORESTART /MERGETASKS="!runcode" | out-null
