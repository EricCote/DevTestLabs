$tempFolder= ${env:Temp};


$BuildVersion=[Environment]::OSVersion.Version.Build
$OsVersion=[Environment]::OSVersion.Version.Major 
$isServer= (Gwmi  Win32_OperatingSystem).productType -gt 1


$OSInfo = Get-WmiObject -Class Win32_OperatingSystem
$languagePacks = $OSInfo.MUILanguages
$hasFrenchCa =($languagePacks | where {$_ -eq "fr-CA"}).count -gt 0

$lang = if ($hasFrenchCa) {"fr-CA"} else {"en-US"}



function Add-OptionalFeature ($Name)
{
  if((Get-WindowsCapability -online -Name $Name).State -eq "NotPresent")
  {
    Add-WindowsCapability -online -Name $Name
  }
}

if ($OsVersion -eq 10)
{      
  Add-OptionalFeature -Name "Language.Basic~~~fr-CA~0.0.1.0"
  Add-OptionalFeature -Name "Language.Basic~~~fr-FR~0.0.1.0"
  Add-OptionalFeature -Name "Language.Handwriting~~~fr-FR~0.0.1.0"
  Add-OptionalFeature -Name "Language.OCR~~~fr-CA~0.0.1.0"
  Add-OptionalFeature -Name "Language.Speech~~~fr-CA~0.0.1.0"
  Add-OptionalFeature -Name "Language.Speech~~~en-CA~0.0.1.0"
  Add-OptionalFeature -Name "Language.TextToSpeech~~~fr-CA~0.0.1.0"
  Add-OptionalFeature -Name "Language.TextToSpeech~~~EN-CA~0.0.1.0"

}


#Order the list accordingly 
$frFirst = "hex(7):66,00,72,00,2d,00,43,00,41,00,00,00,65,00,6e,00,2d,00,55,00,53,00,00,00"
$enFirst = "hex(7):65,00,6e,00,2d,00,55,00,53,00,00,00,66,00,72,00,2d,00,43,00,41,00,00,00"
$enbrowser= "en-US,en;q=0.8,fr-CA;q=0.5,fr;q=0.3"
$frbrowser= "fr-CA,fr;q=0.8,en-CA;q=0.5,en;q=0.3"

$langlist=$(if ($lang -eq "fr-CA") {$frFirst} else {$enFirst})
$browserlist=$(if ($lang -eq "fr-CA") {$frbrowser} else {$enbrowser})

#create a .ini registry string
$regini = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\International]
"Locale"="00000C0C"
"LocaleName"="fr-CA"
"s1159"=""
"s2359"=""
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
"iCountry"="1"
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
"Name"="CA"

[HKEY_CURRENT_USER\Control Panel\International\User Profile]
"Languages"=$langlist
"ShowAutoCorrection"=dword:00000001
"ShowTextPrediction"=dword:00000001
"ShowCasing"=dword:00000001
"ShowShiftLock"=dword:00000001
;"InputMethodOverride"="0c0c:00001009"

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

;[HKEY_CURRENT_USER\Control Panel\Desktop]
;"PreferredUILanguages"=$langlist
;"PreferredUILanguagesPending"=$langlist

;[HKEY_CURRENT_USER\Control Panel\Desktop\MuiCached]
;"MachinePreferredUILanguages"=$langlist

;[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\MUI\Settings]
;"PreferredUILanguages"=$langlist

"@

#-----------------------------------------

function  ModifyRegistry($Regini, $profileName)
{
    if ($profileName -ne "HKEY_CURRENT_USER")
    {
         $profileName= "HKEY_USERS\" + $profileName
    }

    #modify ini to affect system user
    $regSys = $regini.Replace("HKEY_CURRENT_USER",$profileName)

    #save it in a temp file and import it using reg.exe
    $confPath= Join-Path $tempFolder "lang.reg"
    set-content $confPath $regSys -Encoding Unicode 
    $params = "/c reg.exe IMPORT `"$confPath`" /reg:64 2> null:"
    &cmd $params
}

ModifyRegistry  -Regini $regini -profilename ".DEFAULT"
ModifyRegistry  -Regini $regini -profilename "S-1-5-19"
ModifyRegistry  -Regini $regini -profilename "S-1-5-20"

&reg load hku\def "C:\users\default user\NTUSER.DAT"
ModifyRegistry  -Regini $regini -profilename "def"
&reg unload hku\def


