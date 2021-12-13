$UserLanguageList = New-WinUserLanguageList -Language "en-US"
$UserLanguageList.Add("fr-CA")
Set-WinUserLanguageList -LanguageList $UserLanguageList -force


& schtasks /run /tn \Microsoft\Windows\InstallService\ScanForUpdates

