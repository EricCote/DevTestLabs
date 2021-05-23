﻿$master_prefs = @'
{ 
 "browser": {
   "default_browser_infobar_last_declined":"66666666666666",
   "should_reset_check_default_browser": false,
   "default_browser_setting_enabled": false
 },
 "first_run_tabs": ["about:newtab"],
 "sync_promo": {"show_on_first_run_allowed" : false },  
 "homepage": "http://www.afiexpertise.com", 
 "homepage_is_newtabpage": false, 
 "distribution": { 
   "make_chrome_default": false, 
   "make_chrome_default_for_user": false, 
   "do_not_create_desktop_shortcut": true,
   "do_not_create_quick_launch_shortcut": true,
   "do_not_create_taskbar_shortcut": false,
   "msi": true,
   "system_level": true
 }
}
'@

Set-Content "c:\program files\Google\Chrome\Application\master_preferences" $master_prefs -Encoding Utf8


#these do nothing under "distribution" object.  they were removed:
#   "show_welcome_page": false,
#   "skip_first_run_ui": true,
#   "suppress_first_run_default_browser_prompt": true,
#   "suppress_first_run_bubble": true,
#   "welcome_page_on_os_upgrade_enabled": false,
#these do something, but I dont need them anymore
#   "verbose_logging":true,
#   "allow_downgrade":false
#   "create_all_shortcuts" : false, 
#   "do_not_create_any_shortcuts" : true,
#   
#cf https://serverfault.com/questions/635202/how-can-i-customize-the-default-settings-when-deploying-google-chrome-for-busine/635203#635203

mkdir "HKLM:\SOFTWARE\Policies\Google\Chrome" -Force

#stop nagging default Browser for chrome 
New-ItemProperty -path "HKLM:\SOFTWARE\Policies\Google\Chrome" -name  "DefaultBrowserSettingEnabled" -Value 0
#hide first run popups
New-ItemProperty -path "HKLM:\Software\Policies\Google\Chrome" -name "WelcomePageOnOSUpgradeEnabled" -value 0





