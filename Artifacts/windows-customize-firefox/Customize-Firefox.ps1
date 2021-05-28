
$ini= @'
[Install]
QuickLaunchShortcut=false
DesktopShortcut=false
'@

$prefs = @'
//comment because firefox disregards the first line of this file 
pref("browser.shell.checkDefaultBrowser", false);   //removes the popup "make firefox your default browser"
//defaultPref("startup.homepage_welcome_url", "");  //not sure what this does
pref("browser.startup.homepage_override.mstone", "ignore");  //removes the prompt of configuring a firefox account to sync
pref("browser.aboutHomeSnippets.updateUrl", "");   //removes the ads at the bottom of start page
pref("browser.usedOnWindows10",true);      //Removes the windows 10 tutorial
pref("browser.disableResetPrompt", true);  //To remove the prompt of: "previous install detected, click here to refresh and remove addon from your profile"
//pref("browser.tabs.remote.force-enable", true);  //to force usage of Electrolysis (e10s) 
//defaultPref("browser.startup.homepage", "data:text/plain,browser.startup.homepage=http://www.afiexpertise.com/fr/");
//defaultPref("general.useragent.locale", "fr");  //forces the language of the browser
pref("intl.locale.matchOS", true);         //syncs the browser language with the OS language
pref("toolkit.telemetry.prompted", 2);
pref("toolkit.telemetry.rejected", true);
pref("toolkit.telemetry.enabled", false);
pref("datareporting.healthreport.service.enabled", false);
pref("datareporting.healthreport.uploadEnabled", false);
pref("datareporting.healthreport.service.firstRun", false);
pref("datareporting.healthreport.logging.consoleEnabled", false);
pref("datareporting.policy.dataSubmissionEnabled", false);
pref("datareporting.policy.dataSubmissionPolicyResponseType", "accepted-info-bar-dismissed");
pref("datareporting.policy.dataSubmissionPolicyAccepted", false);

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

Set-Content "c:\program files\mozilla firefox\browser\defaults\preferences\all-afi.js" $prefs -Encoding Utf8
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

