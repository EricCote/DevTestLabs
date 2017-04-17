$master_prefs = @'
{ 
 "browser": {
   "default_browser_infobar_last_declined":"66666666666666",
   "should_reset_check_default_browser": false,
   "default_browser_setting_enabled": false
 },
 "first_run_tabs": ["about:newtab"],
 "homepage" : "http://www.afiexpertise.com", 
 "homepage_is_newtabpage" : false, 
 "sync_promo" : {"show_on_first_run_allowed": false,  "user_skipped": true}, 
 "distribution" : { 
   "create_all_shortcuts" : false, 
   "make_chrome_default" : false, 
   "make_chrome_default_for_user": false, 
   "suppress_first_run_default_browser_prompt": true,
   "suppress_first_run_bubble": true,
   "do_not_create_desktop_shortcut":true,
   "do_not_create_quick_launch_shortcut":true,
   "do_not_create_taskbar_shortcut":true,
   "do_not_create_any_shortcuts" : true,
   "welcome_page_on_os_upgrade_enabled": false,
   "msi":true,
   "system_level":true,
   "verbose_logging":true,
   "allow_downgrade":false
 }
}
'@

Set-Content "c:\program files (x86)\Google\Chrome\Application\master_preferences" $master_prefs -Encoding Utf8


#these do nothing under "distribution" object.  they were removed:
#   "show_welcome_page": false,
#   "skip_first_run_ui": true,
#cf https://serverfault.com/questions/635202/how-can-i-customize-the-default-settings-when-deploying-google-chrome-for-busine/635203#635203

