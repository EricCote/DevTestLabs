
Install-PackageProvider -Name NuGet -force
Install-Module PSWindowsUpdate -force

Get-WUInstall -acceptall -ignorereboot  -verbose
