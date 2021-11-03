$ProgressPreference = 'SilentlyContinue'


$lang = @(
    "Language.Basic~~~fr-CA~0.0.1.0",
    "Language.Basic~~~fr-FR~0.0.1.0",
    "Language.Handwriting~~~fr-FR~0.0.1.0",
    "Language.OCR~~~fr-CA~0.0.1.0",
    "Language.Speech~~~fr-CA~0.0.1.0",
    "Language.TextToSpeech~~~fr-CA~0.0.1.0",
    "Windows.Desktop.EMS-SAC.Tools~~~~0.0.1.0",
    "Browser.InternetExplorer~~~~0.0.11.0",
    "Microsoft.Windows.Notepad.System~~~~0.0.1.0",
    "Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0",
    "Print.Management.Console~~~~0.0.1.0",
    "Print.Fax.Scan~~~~0.0.1.0",
    "App.StepsRecorder~~~~0.0.1.0",
    "Microsoft.Windows.WordPad~~~~0.0.1.0"
);

$url="https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-Client-Language-Pack_x64_fr-ca.cab?sp=r&st=2021-10-31T17:40:45Z&se=2023-11-01T01:40:45Z&spr=https&sv=2020-08-04&sr=b&sig=5xD%2BdyQwdlOSbqg%2FSW7IGHREGcdEJ%2Bc%2BMYNl5G6%2B6m4%3D"

Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile "$env:temp\lang.cab"
Add-WindowsPackage -online -PackagePath  "$env:temp\lang.cab"
"lang installed"
get-date -Format "T"


$lang | ForEach-Object  { Add-WindowsCapability -Online -Name $_  }
"loop done"
get-date -Format "T"

restart-computer


# set in canada
# set-WinHomeLocation -geoid 39
# set-culture -CultureInfo fr-CA
# Set-WinSystemLocale -SystemLocale fr-CA

# $UserLanguageList = New-WinUserLanguageList -Language "fr-CA"
# $UserLanguageList.Add("en-US")

# Set-WinUserLanguageList -LanguageList $UserLanguageList -force


#Set-WinUILanguageOverride -Language fr-CA


