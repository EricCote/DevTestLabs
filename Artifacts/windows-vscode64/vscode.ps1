

$setupexe = "$PSScriptRoot\setup.exe" 

$url = 'https://update.code.visualstudio.com/latest/win32-x64-user/stable' 
$setupUrl = Get-RedirectedUrl -URL $url
Invoke-WebRequest -Uri $setupUrl -OutFile $SetupExe

& "$setupExe" /123 /SP- /SUPPRESSMSGBOXES /VERYSILENT /NORESTART /MERGETASKS="!runcode"
