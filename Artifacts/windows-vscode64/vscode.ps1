#increase download speed by hiding progress bar
$ProgressPreference = 'SilentlyContinue'

$setupExe = "$env:temp\VsCodeSetup.exe" 
$url = 'https://update.code.visualstudio.com/latest/win32-x64/stable' 
Invoke-WebRequest -Uri $url -OutFile $SetupExe -UseBasicParsing

#call setup
& "$setupExe" /SP- /SUPPRESSMSGBOXES /VERYSILENT /NORESTART /MERGETASKS="!runcode,addcontextmenufolders,addcontextmenufiles" | out-null

#remove installation file
Remove-Item -Path $SetupExe