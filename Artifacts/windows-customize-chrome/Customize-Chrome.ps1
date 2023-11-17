########################################################
#Remove chrome "first run" page:
#you need to create two files in profile to get rid of it.  

# #Create empty file
# New-Item  "C:\Users\Default\AppData\Local\Google\Chrome\User Data\First Run" -ItemType File -force | out-null

# #create nearly empty file
# mkdir "C:\Users\Default\AppData\Local\Google\Chrome\User Data\Default" | out-null
# "{}" | Out-File  "C:\Users\Default\AppData\Local\Google\Chrome\User Data\Default\Preferences" -force -Encoding utf8


########################################
#set Policies
mkdir "HKLM:\SOFTWARE\Policies\Google\Chrome" -Force | Out-Null

#stop nagging default Browser for chrome 
New-ItemProperty -path "HKLM:\SOFTWARE\Policies\Google\Chrome" -name  "DefaultBrowserSettingEnabled" -Value 0 | Out-Null

#don't display welcome page
New-ItemProperty -path "HKLM:\SOFTWARE\Policies\Google\Chrome" -name  "PromotionalTabsEnabled" -Value 0 | Out-Null



#get chrome version
# $chromeVersion = Get-ChildItem "C:\Program Files\Google\Chrome\Application" | 
#   Select-Object -First 1 BaseName | % { ([version]$_.BaseName).major }



#remove the desktop shortcut
$content = @"
{
  "distribution": {
      "msi": true,
      "system_level": true,
      "verbose_logging": true,
      "msi_product_id": "19B37A31-CC51-332C-AB5D-860490DA5960",
      "allow_downgrade": false,
      "do_not_create_desktop_shortcut": true
  }
}
"@ 

# "browser": {
#   "last_whats_new_version":$chromeVersion
# }  

       
$content | Out-File "C:\Program Files\Google\Chrome\Application\master_preferences" -Force -Encoding ascii
$content | Out-File "C:\Program Files\Google\Chrome\Application\initial_preferences" -Force -Encoding ascii


#delete Desktop icon
Remove-Item 'C:\Users\Public\Desktop\Google Chrome.lnk' -Force