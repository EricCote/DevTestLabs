#does not work because https://github.com/microsoft/winget-cli/issues/2854


$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
    if ($ResolveWingetPath){
           $WingetPath = $ResolveWingetPath[-1].Path
    }

cd  $WingetPath

"Path : $WingetPath"

# ./winget settings --enable LocalArchiveMalwareScanOverride

# ./winget settings --enable InstallerHashOverride

./winget upgrade  `
       --all `
       --silent `
       --accept-source-agreements `
       --accept-package-agreements `
       --verbose-logs `
       --force 

    

@"
# & winget settings --enable LocalArchiveMalwareScanOverride

# & winget settings --enable InstallerHashOverride

& winget upgrade `
       --all `
       --silent `
       --accept-source-agreements `
       --accept-package-agreements `
       --verbose-logs `
       --force `

"@

