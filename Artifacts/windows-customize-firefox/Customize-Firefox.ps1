
$ini= @'
[Install]
QuickLaunchShortcut=false
DesktopShortcut=false
'@

$prefs = @'
//comment
pref("browser.shell.checkDefaultBrowser", false); 
//defaultPref("startup.homepage_welcome_url", "");
pref("browser.startup.homepage_override.mstone","");
pref("browser.usedOnWindows10",true);
pref("browser.disableResetPrompt", true);  //To remove the prompt of: "previous install detected, click here to refresh and remove addon from your profile"
//defaultPref("browser.tabs.remote.force-enable", true);

defaultPref("browser.startup.homepage", "data:text/plain,browser.startup.homepage=http://www.afiexpertise.com/fr/");
//defaultPref("general.useragent.locale", "fr");
defaultPref("intl.locale.matchOS", true);
defaultPref("toolkit.telemetry.prompted", 2);
defaultPref("toolkit.telemetry.rejected", true);
defaultPref("toolkit.telemetry.enabled", false);
pref("datareporting.healthreport.service.enabled", false);
pref("datareporting.healthreport.uploadEnabled", false);
pref("datareporting.healthreport.service.firstRun", false);
defaultPref("datareporting.healthreport.logging.consoleEnabled", false);
defaultPref("datareporting.policy.dataSubmissionEnabled", false);
defaultPref("datareporting.policy.dataSubmissionPolicyResponseType", "accepted-info-bar-dismissed");
defaultPref("datareporting.policy.dataSubmissionPolicyAccepted", false);
'@


$override= @'
[XRE]
EnableProfileMigrator=false
'@

<#
#Download and install Firefox
$wc = new-object System.Net.WebClient ;
$wc.DownloadFile($fireLink, $dl + "firefox_Setup.exe");
$wc.Dispose();  

Set-Content (Join-Path $dl "firefox.ini") $ini
&  (Join-Path $dl "firefox_setup.exe") -ms /ini=(Join-Path $dl "firefox.ini")  | out-null

#>

if(!(Test-Path "c:\program files\mozilla firefox\browser\defaults\preferences")){
  mkdir "c:\program files\mozilla firefox\browser\defaults\preferences"
}

Set-Content "c:\program files\mozilla firefox\browser\defaults\preferences\all-afi.js" $prefs
Set-Content "c:\program files\mozilla firefox\browser\override.ini" $override

if(!(Test-Path "c:\program files\mozilla firefox\distribution\extensions")){
  mkdir "c:\program files\mozilla firefox\distribution\extensions"
}

$fr="https://addons.mozilla.org/firefox/downloads/latest/417178/addon-417178-latest.xpi"
$en="https://addons.mozilla.org/firefox/downloads/latest/407142/addon-407142-latest.xpi"

$destFr="c:\program files\mozilla firefox\distribution\extensions\langpack-fr@firefox.mozilla.org.xpi"
$destEn="c:\program files\mozilla firefox\distribution\extensions\langpack-en-US@firefox.mozilla.org.xpi"

$wc = new-object System.Net.WebClient ;
$wc.DownloadFile($fr, $destFr) ;
$wc.DownloadFile($en, $destEn);
$wc.Dispose();  

