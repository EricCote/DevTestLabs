$ProgressPreference = 'SilentlyContinue'



$linkArray = @(
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-EMS-SAC-Desktop-Tools-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:05:47Z&se=2023-11-01T01:05:47Z&spr=https&sv=2020-08-04&sr=b&sig=EvabVvGYSt6%2FdEwDJLHhZzdoIN0hMx6X9whpjN%2FWJjs%3D",
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:42:49Z&se=2023-11-01T01:42:49Z&spr=https&sv=2020-08-04&sr=b&sig=QZBat%2B4HgSmDQQV%2B0OpGoOLDgkzi3bYZ3AbK%2F8efwZc%3D",
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-Notepad-System-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:43:40Z&se=2023-11-01T01:43:40Z&spr=https&sv=2020-08-04&sr=b&sig=UJJsrUfyDdlc9H8yyNGM9i2DtNGyhco%2BZjcbHTOF6V8%3D",    
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-Notepad-System-FoD-Package~31bf3856ad364e35~wow64~fr-CA~.cab?sp=r&st=2021-10-31T17:44:13Z&se=2023-11-01T01:44:13Z&spr=https&sv=2020-08-04&sr=b&sig=j5LIeFLg9LqtPBHDxANQvJeC9yNkOiwkxvGzNVn8aNo%3D",
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:45:07Z&se=2023-11-01T01:45:07Z&spr=https&sv=2020-08-04&sr=b&sig=EhG3otJhWm9vQ1%2BzpCOdP4mGsw7Z67hjWHee5y7WCCQ%3D",
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~wow64~fr-CA~.cab?sp=r&st=2021-10-31T17:45:36Z&se=2023-11-01T01:45:36Z&spr=https&sv=2020-08-04&sr=b&sig=2%2FOyrgnQHBMO5ehfV7MCsYqhTCm5ChCZGIsHrKt6bmA%3D",
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-Printing-PMCPPC-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:48:35Z&se=2023-11-01T01:48:35Z&spr=https&sv=2020-08-04&sr=b&sig=pZOcMU7Qb9jYzSQVz1TO6d9I7Q5ij9fpFgUQo8liZQQ%3D",
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:49:08Z&se=2023-11-01T01:49:08Z&spr=https&sv=2020-08-04&sr=b&sig=pmokvxDbrsGioAS00eWPKjP%2BKjIE5F9QWIYwcyJi4Ds%3D",
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:49:40Z&se=2023-11-01T01:49:40Z&spr=https&sv=2020-08-04&sr=b&sig=%2F%2F%2F%2BQUyjgRYLt6JnXqXPKJFAAtBojtpx%2BfaFltU2G%2Bs%3D",
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~wow64~fr-CA~.cab?sp=r&st=2021-10-31T17:50:05Z&se=2023-11-01T01:50:05Z&spr=https&sv=2020-08-04&sr=b&sig=sZuQ0s%2Fajyw29GjujJYeSsBI8x94HVyG9NsJrAKC0pA%3D",
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:50:32Z&se=2023-11-01T01:50:32Z&spr=https&sv=2020-08-04&sr=b&sig=CzASUpV6TJkkMc68MqXgWkG60jyOuYsLmLTwpgucoWQ%3D",
    "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~wow64~fr-CA~.cab?sp=r&st=2021-10-31T17:51:09Z&se=2023-11-01T01:51:09Z&spr=https&sv=2020-08-04&sr=b&sig=nh%2Fgz4wgnhLZAGqZyB%2FHrYwrCbYvScBdCgwKIpjoh%2Bw%3D"
)


$FOD = @(
    "Language.Basic~~~fr-CA~0.0.1.0",
    "Language.Basic~~~fr-FR~0.0.1.0",
    "Language.Handwriting~~~fr-FR~0.0.1.0",
    "Language.OCR~~~fr-CA~0.0.1.0",
    "Language.Speech~~~fr-CA~0.0.1.0",
    "Language.TextToSpeech~~~fr-CA~0.0.1.0"
    # "Windows.Desktop.EMS-SAC.Tools~~~~0.0.1.0",
    # "Browser.InternetExplorer~~~~0.0.11.0",
    # "Microsoft.Windows.Notepad.System~~~~0.0.1.0",
    # "Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0",
    # "Print.Management.Console~~~~0.0.1.0",
    # "Print.Fax.Scan~~~~0.0.1.0",
    # "App.StepsRecorder~~~~0.0.1.0",
    # "Microsoft.Windows.WordPad~~~~0.0.1.0"
);

$url="https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-Client-Language-Pack_x64_fr-ca.cab?sp=r&st=2021-10-31T17:40:45Z&se=2023-11-01T01:40:45Z&spr=https&sv=2020-08-04&sr=b&sig=5xD%2BdyQwdlOSbqg%2FSW7IGHREGcdEJ%2Bc%2BMYNl5G6%2B6m4%3D"


Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile "$env:temp\lang.cab"
"Lang Downloaded" | out-file  "$env:temp\wow1.txt" -append
Add-WindowsPackage -online -PackagePath  "$env:temp\lang.cab"
"Lang Installed" | out-file  "$env:temp\wow1.txt" -append



# $FOD | ForEach-Object  { if ($_ -notmatch "Language\.")  {  Remove-WindowsCapability -Online -Name $_  }}
# "Removed capabilities" | out-file "$env:temp\wow3.txt"



$FOD | ForEach-Object  { Add-WindowsCapability -Online -Name $_  }
"Added FOD capabilities"  | out-file "$env:temp\wow1.txt" -append


$packages = $linkArray | ForEach-Object { @{url=$_ ; filename=[regex]::Match($_ , "fr-ca\/(.+)\?").captures.groups[1].value }  }
"generate a list of package names and url" | out-file "$env:temp\wow1.txt" -append


$packages | ForEach-Object  { Invoke-WebRequest -UseBasicParsing -Uri $_.url -OutFile (join-path  $env:temp   $_.filename)  } 
"loop for download" | out-file "$env:temp\wow1.txt" -append


$packages | ForEach-Object { Add-WindowsPackage -Online -PackagePath (join-path  $env:temp   $_.filename)  }
"loop for integrating windows package"  | out-file "$env:temp\wow1.txt" -append


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

# ModifyRegistry  -Regini $regini -profilename ".DEFAULT"
# ModifyRegistry  -Regini $regini -profilename "S-1-5-19"
# ModifyRegistry  -Regini $regini -profilename "S-1-5-20"
# ModifyRegistry  -Regini $regini -profilename "HKEY_CURRENT_USER"



# &reg load hku\def "C:\users\default user\NTUSER.DAT"
# ModifyRegistry  -Regini $regini -profilename "def"
# &reg unload hku\def


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


restart-computer
"Restarted"   | out-file "$env:temp\wow1.txt" -append

# set in canada
# set-WinHomeLocation -geoid 39
# set-culture -CultureInfo fr-CA
# Set-WinSystemLocale -SystemLocale fr-CA

# $UserLanguageList = New-WinUserLanguageList -Language "fr-CA"
# $UserLanguageList.Add("en-US")

# Set-WinUserLanguageList -LanguageList $UserLanguageList -force


#Set-WinUILanguageOverride -Language fr-CA


