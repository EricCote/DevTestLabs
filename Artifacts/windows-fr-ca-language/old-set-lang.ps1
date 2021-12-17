

$lang="fr-CA";
$tempFolder="$env:temp"



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

[-HKEY_CURRENT_USER\Control Panel\International\User Profile\fr-FR]

[-HKEY_CURRENT_USER\Control Panel\International\User Profile\en-CA]

[-HKEY_CURRENT_USER\Control Panel\International\User Profile System Backup]


[-HKEY_CURRENT_USER\Keyboard Layout\Preload]

[HKEY_CURRENT_USER\Keyboard Layout\Preload]
"1"="00000409"
"2"="00000c0c"


[-HKEY_CURRENT_USER\Keyboard Layout\Substitutes]

[HKEY_CURRENT_USER\Keyboard Layout\Substitutes]
"00000c0c"="00001009"


[HKEY_CURRENT_USER\Keyboard Layout\Toggle]
"Language Hotkey"="3"
"Hotkey"="3"
"Layout Hotkey"="3"

[HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\International]
"AcceptLanguage"="$browserlist"

[HKEY_CURRENT_USER\Control Panel\Desktop]
"PreferredUILanguages"=hex(7):66,00,72,00,2d,00,43,00,41,00,00,00
"PreferredUILanguagesPending"=hex(7):66,00,72,00,2d,00,43,00,41,00,00,00


[HKEY_CURRENT_USER\Software\Microsoft\CTF\Assemblies\0x00000c0c\{34745C63-B2F0-4784-8B67-5E12C8701A31}]
"Default"="{00000000-0000-0000-0000-000000000000}"
"Profile"="{00000000-0000-0000-0000-000000000000}"
"KeyboardLayout"=dword:10090c0c

[HKEY_CURRENT_USER\Software\Microsoft\CTF\SortOrder\AssemblyItem\0x00000409\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000]
"CLSID"="{00000000-0000-0000-0000-000000000000}"
"KeyboardLayout"=dword:04090409
"Profile"="{00000000-0000-0000-0000-000000000000}"


[HKEY_CURRENT_USER\Software\Microsoft\CTF\SortOrder\AssemblyItem\0x00000c0c\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000]
"CLSID"="{00000000-0000-0000-0000-000000000000}"
"KeyboardLayout"=dword:10090c0c
"Profile"="{00000000-0000-0000-0000-000000000000}"

[HKEY_CURRENT_USER\Software\Microsoft\CTF\SortOrder\Language]
"00000000"="00000c0c"
"00000001"="00000409"

[HKEY_CURRENT_USER\Software\Microsoft\CTF\TIP\{8613E14C-D0C0-4161-AC0F-1DD2563286BC}\LanguageProfile\0x0000ffff\{B37D4237-8D1A-412E-9026-538FE16DF216}]
"Enable"=dword:00000001

[HKEY_CURRENT_USER\Software\Microsoft\Spelling\Spellers\Disabled]
"fr-CA"=dword:00000000
"en-US"=dword:00000000


[HKEY_CURRENT_USER\Software\Microsoft\TabletTip\1.7\PagePreference]
"fr"=hex:01
"en"=hex:01


;[HKEY_CURRENT_USER\Control Panel\Desktop\MuiCached]
;"MachinePreferredUILanguages"=$langlist

;[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\MUI\Settings]
;"PreferredUILanguages"=$langlist

"@


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
ModifyRegistry  -Regini $regini -profilename "HKEY_CURRENT_USER"



&reg load hku\def "C:\users\default user\NTUSER.DAT"
ModifyRegistry  -Regini $regini -profilename "def"
&reg unload hku\def

#----------------------------------------------------------------------------
$script=@'
$UserLanguageList = New-WinUserLanguageList -Language "fr-CA"
$UserLanguageList.Add("en-US")
Set-WinUserLanguageList -LanguageList $UserLanguageList -force

Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("Il faut redémarrer le poste pour le mettre en français. Cliquez sur OK pour redémarrer.", "Français")
# restart-computer
& schtasks /run /tn \Microsoft\Windows\InstallService\ScanForUpdates

'@

New-Item  c:\programdata\script\ -ItemType Directory -Force  | Out-Null

$script | Out-File  "c:\programdata\script\frca.ps1" -Force -Encoding utf8


new-itemproperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name setToFrCA -Value "powershell -ExecutionPolicy bypass -WindowStyle hidden -File c:\programdata\script\frca.ps1"  -Force | out-null;



#----------------------------------------------------------------


#set in canada
set-WinHomeLocation -geoid 39
set-culture -CultureInfo fr-CA
Set-WinSystemLocale -SystemLocale fr-CA

$UserLanguageList = New-WinUserLanguageList -Language "fr-CA"
$UserLanguageList.Add("en-US")
Set-WinUserLanguageList -LanguageList $UserLanguageList -force

Set-WinUILanguageOverride -Language fr-CA
