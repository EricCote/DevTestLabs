$ProgressPreference = 'SilentlyContinue'
$latestSvc="https://api.github.com/repos/coreybutler/nvm-windows/releases/latest";

$Compute=Invoke-RestMethod -URI $latestSvc -UseBasicParsing

$download_url=$compute.assets.Where({$_.name -eq "nvm-noinstall.zip"}).browser_download_url

$zipFile= "$env:temp\nvm-noinstall.zip"
$nvmPath= "$env:programdata\nvm"
$nodePath= "$env:programfiles\nodejs"

Invoke-WebRequest -UseBasicParsing -uri $download_url -OutFile $zipFile

Expand-Archive -Path  $zipFile -destinationPath $nvmPath

Remove-Item $zipFile -force

[Environment]::SetEnvironmentVariable("NVM_HOME", $nvmPath, 'Machine')
[Environment]::SetEnvironmentVariable("NVM_SYMLINK", $nodePath, 'Machine')


[Environment]::SetEnvironmentVariable("NVM_HOME", $nvmPath, 'Process')
[Environment]::SetEnvironmentVariable("NVM_SYMLINK", $nodePath, 'Process')

$path = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$newpath = $path +  ";%NVM_HOME%;%NVM_SYMLINK%"
& SETX /m PATH $newpath

$path2 = [Environment]::GetEnvironmentVariable('Path', 'Process')
$newpath2 = $path2 + ";$nvmPath;$nodePath"
[Environment]::SetEnvironmentVariable("Path", $newpath2, 'Process')

$Settings= @"
root: $nvmPath
path: $nodePath
arch: 64
proxy: none
"@;

$settings | Out-File $nvmPath\settings.txt -Encoding ascii

& nvm install latest
& nvm install lts
& nvm use lts




#   rmdir 'C:\ProgramData\nvm' -Recurse -Force
#   cmd /c rmdir /s /q 'C:\Program Files\nodejs'
