$UserLanguageList = New-WinUserLanguageList -Language "fr-CA"
$UserLanguageList.Add("en-US")
Set-WinUserLanguageList -LanguageList $UserLanguageList -force


& schtasks /run /tn \Microsoft\Windows\InstallService\ScanForUpdates

