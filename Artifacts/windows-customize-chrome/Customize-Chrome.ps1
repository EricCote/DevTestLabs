########################################################
#Remove chrome "first run" page:
#you need to create two files in profile to get rid of it.  

#Create empty file
New-Item  "C:\Users\Default\AppData\Local\Google\Chrome\User Data\First Run" -ItemType File -force | out-null

#create nearly empty file
mkdir "C:\Users\Default\AppData\Local\Google\Chrome\User Data\Default" | out-null
"{}" | Out-File  "C:\Users\Default\AppData\Local\Google\Chrome\User Data\Default\Preferences" -force -Encoding utf8


########################################
#set Policies
mkdir "HKLM:\SOFTWARE\Policies\Google\Chrome" -Force | Out-Null

#stop nagging default Browser for chrome 
New-ItemProperty -path "HKLM:\SOFTWARE\Policies\Google\Chrome" -name  "DefaultBrowserSettingEnabled" -Value 0 | Out-Null
#hide first run popups
New-ItemProperty -path "HKLM:\SOFTWARE\Policies\Google\Chrome" -name "WelcomePageOnOSUpgradeEnabled" -value 0 | Out-Null


