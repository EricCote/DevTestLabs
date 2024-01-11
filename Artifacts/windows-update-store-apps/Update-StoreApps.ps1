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
       --force `
       --scope machine

    

@"
# & winget settings --enable LocalArchiveMalwareScanOverride

# & winget settings --enable InstallerHashOverride

& winget upgrade `
       --all `
       --silent `
       --accept-source-agreements `
       --accept-package-agreements `
       --disable-interactivity `
       --verbose-logs `
       --include-unknown `
       --force `
       --scope machine
"@

