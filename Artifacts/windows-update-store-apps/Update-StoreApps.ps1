winget settings --enable LocalArchiveMalwareScanOverride

winget settings --enable InstallerHashOverride

winget upgrade `
       --all `
       --silent `
       --accept-source-agreements `
       --accept-package-agreements `
       --disable-interactivity `
       --verbose-logs `
       --include-unknown `
       --force `
       --scope machine

       