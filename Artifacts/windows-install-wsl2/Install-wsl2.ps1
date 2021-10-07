wsl --install

$Part2 = @'
$file = (Get-ChildItem C:\windows\SystemTemp\ubunt*)[0]
$zip = "$env:TEMP\Ubuntu.zip"
copy-Item $file.FullName $zip -force
Expand-Archive  $zip  "$env:temp\Ubuntu" -force
$file = (Get-ChildItem "$env:TEMP\Ubuntu\ubuntu*.exe")[0]
& $file.FullName install --root
 ## restart-computer
'@


mkdir -path "$env:ProgramData\script" -Force
$part2 | Out-File "$env:ProgramData\script\wsl2.ps1"


& schtasks.exe /create /f /tn WSL2RestartTask /sc ONSTART /rl HIGHEST /RU "NT AUTHORITY\SYSTEM"  /tr "powershell.exe -ExecutionPolicy bypass -File c:\programdata\script\wsl2.ps1"

#restart-computer