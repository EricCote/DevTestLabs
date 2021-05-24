New-Item  "$env:userprofile\AppData\Local\Google\Chrome\User Data\First Run" -ItemType File -force

"{}" | Out-File  "$env:userprofile\AppData\Local\Google\Chrome\User Data\Default\Preferences" -force -Encoding utf8


mkdir "HKLM:\SOFTWARE\Policies\Google\Chrome" -Force

#stop nagging default Browser for chrome 
New-ItemProperty -path "HKLM:\SOFTWARE\Policies\Google\Chrome" -name  "DefaultBrowserSettingEnabled" -Value 0
#hide first run popups
New-ItemProperty -path "HKLM:\Software\Policies\Google\Chrome" -name "WelcomePageOnOSUpgradeEnabled" -value 0





