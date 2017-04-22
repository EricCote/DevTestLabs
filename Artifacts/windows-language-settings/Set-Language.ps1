Param
(
    [string] $language
)

$lang = if ($language -eq "fr-CA") {"fr-CA"} else {"en-US"};

$tempFolder= $env:Temp;
 
[int]$OsVersion=[Environment]::OSVersion.Version.Major ;


#$languagePacks = (Get-WmiObject -Class Win32_OperatingSystem).MUILanguages;
#$hasFrenchCa =($languagePacks | where {$_ -eq "fr-CA"}).count -gt 0

#$lang = if ($hasFrenchCa) {"fr-CA"} else {"en-US"}


function Add-OptionalFeature ($Name)
{
  if((Get-WindowsCapability -online -Name $Name).State -eq "NotPresent")
  {
    Add-WindowsCapability -online -Name $Name;
  }
}

if ($OsVersion -ge 8)
{      
  Add-OptionalFeature -Name "Language.Basic~~~fr-FR~0.0.1.0";
  Add-OptionalFeature -Name "Language.Basic~~~fr-CA~0.0.1.0";
  Add-OptionalFeature -Name "Language.Handwriting~~~fr-FR~0.0.1.0";
  Add-OptionalFeature -Name "Language.OCR~~~fr-FR~0.0.1.0";
  Add-OptionalFeature -Name "Language.OCR~~~fr-CA~0.0.1.0";

  Add-OptionalFeature -Name "Language.Speech~~~fr-CA~0.0.1.0";
  Add-OptionalFeature -Name "Language.Speech~~~en-CA~0.0.1.0";
  Add-OptionalFeature -Name "Language.TextToSpeech~~~fr-CA~0.0.1.0";
  Add-OptionalFeature -Name "Language.TextToSpeech~~~EN-CA~0.0.1.0";
}


<#
$xml = @"
<gs:GlobalizationServices xmlns:gs="urn:longhornGlobalizationUnattend">

  <!--User List-->

  <gs:UserList>
    <gs:User UserID="Current" CopySettingsToDefaultUserAcct="true" CopySettingsToSystemAcct="true" />
  </gs:UserList>

  <!--User Locale - This changes formats to French Canada -->
  <gs:UserLocale>
    <gs:Locale Name="$lang" SetAsCurrent="true"/>
  </gs:UserLocale>

  <gs:MUILanguagePreferences> 
    <gs:MUILanguage Value="$lang" /> 
  </gs:MUILanguagePreferences> 

  <gs:InputPreferences>

    <!--Add English US-->
    <gs:InputLanguageID Action="add" ID="0409:00000409"/>
    <!--Add canada Francais-->
    <gs:InputLanguageID Action="add" ID="0c0c:00001009" Default="true" />
    <!--Remove Canadian MultiLingual Standard -->
    <gs:InputLanguageID Action="remove" ID="0c0c:00011009"/>
    <gs:InputLanguageID Action="remove" ID="1009:00011009"/>
    <!--Remove french legacy-->
    <gs:InputLanguageID Action="remove" ID="0c0c:00000c0c"/>  
    <!-- remove us Canada -->
    <gs:InputLanguageID Action="remove" ID="1009:00000409"/>
    <!-- Remove azerty france  -->
    <gs:InputLanguageID Action="remove" ID="040c:0000040c"/>
  </gs:InputPreferences>

  <!--location - Change location on Location tab to Canada: 39 US:244-->
  <gs:LocationPreferences>
    <gs:GeoID Value="39"/>
  </gs:LocationPreferences>

</gs:GlobalizationServices>
"@


$confPath= Join-Path $tempFolder  "lang.xml"
sc $confPath $xml 
$arg = "/c control.exe intl.cpl,, /f:`"$confPath`""
&cmd $arg | out-null 

"waiting 10 seconds..."
start-sleep 10
"resume"
#>


#modify language list for current user
$languages = New-WinUserLanguageList $lang;
$languages.Add("en-US");
$languages.Add("fr-CA");
Set-WinUserLanguageList $languages -force;

#modify keyboards for French-Canada (remove multilingual)
$languages = Get-WinUserLanguageList;
$fr=$languages | Where {$_.LanguageTag -eq "fr-CA"}[0];
$fr.InputMethodTips.clear();
$fr.InputMethodTips.add("0c0c:00001009");
Set-WinUserLanguageList $languages -force;
#Get-WinUILanguageOverride;
Set-WinUILanguageOverride $lang;

#Order the list accordingly 
$frFirst = "hex(7):66,00,72,00,2d,00,43,00,41,00,00,00,65,00,6e,00,2d,00,55,00,53,00,00,00";
$enFirst = "hex(7):65,00,6e,00,2d,00,55,00,53,00,00,00,66,00,72,00,2d,00,43,00,41,00,00,00";
$enbrowser= "en-US,en;q=0.8,fr-CA;q=0.5,fr;q=0.3";
$frbrowser= "fr-CA,fr;q=0.8,en-CA;q=0.5,en;q=0.3";

$langlist=   $(if ($lang -eq "fr-CA") {$frFirst} else {$enFirst});
$inverse=    $(if ($lang -eq "fr-CA") {$enFirst} else {$frFirst});
$browserlist=$(if ($lang -eq "fr-CA") {$frbrowser} else {$enbrowser});

#create a .ini registry string
$regini = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\International]
"Locale"="00000C0C"
"LocaleName"="fr-CA"
"s1159"=""
"s2359"=""
"iCountry"="2"
"sCountry"="Canada"
"sCurrency"="$"
"sDate"="-"
"sDecimal"=","
"sGrouping"="3;0"
"sLanguage"="FRC"
"sList"=";"
"sLongDate"="d MMMM yyyy"
"sMonDecimalSep"=","
"sMonGrouping"="3;0"
"sMonThousandSep"=" "
"sNativeDigits"="0123456789"
"sNegativeSign"="-"
"sPositiveSign"=""
"sShortDate"="yyyy-MM-dd"
"sThousand"=" "
"sTime"=":"
"sTimeFormat"="HH:mm:ss"
"sShortTime"="HH:mm"
"sYearMonth"="MMMM, yyyy"
"iCalendarType"="1"
"iCurrDigits"="2"
"iCurrency"="3"
"iDate"="2"
"iDigits"="2"
"NumShape"="1"
"iFirstDayOfWeek"="6"
"iFirstWeekOfYear"="0"
"iLZero"="1"
"iMeasure"="0"
"iNegCurr"="15"
"iNegNumber"="1"
"iPaperSize"="1"
"iTime"="1"
"iTimePrefix"="0"
"iTLZero"="1"


[HKEY_CURRENT_USER\Control Panel\International\Geo]
"Nation"="39"

[HKEY_CURRENT_USER\Control Panel\International\User Profile]
"Languages"=$langlist
"ShowAutoCorrection"=dword:00000001
"ShowTextPrediction"=dword:00000001
"ShowCasing"=dword:00000001
"ShowShiftLock"=dword:00000001
"InputMethodOverride"="0c0c:00001009"
"WindowsOverride"="$lang"

[-HKEY_CURRENT_USER\Control Panel\International\User Profile\en-US]

[HKEY_CURRENT_USER\Control Panel\International\User Profile\en-US]
"CachedLanguageName"="@Winlangdb.dll,-1121"
"0409:00000409"=dword:00000001

[-HKEY_CURRENT_USER\Control Panel\International\User Profile\fr-CA]

[HKEY_CURRENT_USER\Control Panel\International\User Profile\fr-CA]
"CachedLanguageName"="@Winlangdb.dll,-1160"
"0C0C:00001009"=dword:00000001
"0C0C:00011009"=dword:00000002

[-HKEY_CURRENT_USER\Control Panel\International\User Profile\fr-FR]

[-HKEY_CURRENT_USER\Control Panel\International\User Profile\en-CA]

[-HKEY_CURRENT_USER\Control Panel\International\User Profile System Backup]


[-HKEY_CURRENT_USER\Keyboard Layout\Preload]

[HKEY_CURRENT_USER\Keyboard Layout\Preload]
"1"="00000409"
"2"="00000c0c"
"3"="d0010c0c"

[-HKEY_CURRENT_USER\Keyboard Layout\Substitutes]

[HKEY_CURRENT_USER\Keyboard Layout\Substitutes]
"00000c0c"="00001009"
"d0010c0c"="00011009"

[HKEY_CURRENT_USER\Keyboard Layout\Toggle]
"Language Hotkey"="3"
"Hotkey"="3"
"Layout Hotkey"="3"

[HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\International]
"AcceptLanguage"="$browserlist"

[HKEY_CURRENT_USER\Control Panel\Desktop]
"PreferredUILanguages"=$inverse
"PreferredUILanguagesPending"=$langlist

[HKEY_CURRENT_USER\Control Panel\Desktop\MuiCached]
"MachinePreferredUILanguages"=$langlist

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\MUI\Settings]
"PreferredUILanguages"=$langlist

"@

#-----------------------------------------

function  ModifyRegistry($Regini, $profileName)
{
    $profileName= "HKEY_USERS\" + $profileName
    if ($profileName -eq "HKCU") {$profileName = "HKEY_CURRENT_USER" }
    
    #modify ini to affect system user
    $regSys = $regini.Replace("HKEY_CURRENT_USER",$profileName)

    #save it in a temp file and import it using reg.exe
    $confPath= Join-Path $tempFolder "lang.reg"
    sc $confPath $regSys -Encoding Unicode 
    $params = "/c reg.exe IMPORT `"$confPath`" /reg:64 2> null:"
    &cmd $params
}

ModifyRegistry  -Regini $regini -profilename "HKCU"
ModifyRegistry  -Regini $regini -profilename ".DEFAULT"
ModifyRegistry  -Regini $regini -profilename "S-1-5-19"
ModifyRegistry  -Regini $regini -profilename "S-1-5-20"

&reg load hku\def "C:\users\default user\NTUSER.DAT"
ModifyRegistry  -Regini $regini -profilename "def"
&reg unload hku\def


