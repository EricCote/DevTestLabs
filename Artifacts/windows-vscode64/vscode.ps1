$ProgressPreference = 'SilentlyContinue'

$setupexe = "$PSScriptRoot\setup.exe" 

$url = 'https://update.code.visualstudio.com/latest/win32-x64/stable' 

Invoke-WebRequest -Uri $url -OutFile $SetupExe -UseBasicParsing

& "$setupExe" /123 /SP- /SUPPRESSMSGBOXES /VERYSILENT /NORESTART /MERGETASKS="!runcode"
