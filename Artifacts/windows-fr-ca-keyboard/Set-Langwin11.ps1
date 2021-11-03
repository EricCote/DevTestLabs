$ProgressPreference = 'SilentlyContinue'



# $linkArray = @(
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-Client-Language-Pack_x64_fr-ca.cab?sp=r&st=2021-10-31T17:40:45Z&se=2023-11-01T01:40:45Z&spr=https&sv=2020-08-04&sr=b&sig=5xD%2BdyQwdlOSbqg%2FSW7IGHREGcdEJ%2Bc%2BMYNl5G6%2B6m4%3D",
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-EMS-SAC-Desktop-Tools-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:05:47Z&se=2023-11-01T01:05:47Z&spr=https&sv=2020-08-04&sr=b&sig=EvabVvGYSt6%2FdEwDJLHhZzdoIN0hMx6X9whpjN%2FWJjs%3D",
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:42:49Z&se=2023-11-01T01:42:49Z&spr=https&sv=2020-08-04&sr=b&sig=QZBat%2B4HgSmDQQV%2B0OpGoOLDgkzi3bYZ3AbK%2F8efwZc%3D",
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-Notepad-System-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:43:40Z&se=2023-11-01T01:43:40Z&spr=https&sv=2020-08-04&sr=b&sig=UJJsrUfyDdlc9H8yyNGM9i2DtNGyhco%2BZjcbHTOF6V8%3D",    
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-Notepad-System-FoD-Package~31bf3856ad364e35~wow64~fr-CA~.cab?sp=r&st=2021-10-31T17:44:13Z&se=2023-11-01T01:44:13Z&spr=https&sv=2020-08-04&sr=b&sig=j5LIeFLg9LqtPBHDxANQvJeC9yNkOiwkxvGzNVn8aNo%3D",
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:45:07Z&se=2023-11-01T01:45:07Z&spr=https&sv=2020-08-04&sr=b&sig=EhG3otJhWm9vQ1%2BzpCOdP4mGsw7Z67hjWHee5y7WCCQ%3D",
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~wow64~fr-CA~.cab?sp=r&st=2021-10-31T17:45:36Z&se=2023-11-01T01:45:36Z&spr=https&sv=2020-08-04&sr=b&sig=2%2FOyrgnQHBMO5ehfV7MCsYqhTCm5ChCZGIsHrKt6bmA%3D",
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-Printing-PMCPPC-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:48:35Z&se=2023-11-01T01:48:35Z&spr=https&sv=2020-08-04&sr=b&sig=pZOcMU7Qb9jYzSQVz1TO6d9I7Q5ij9fpFgUQo8liZQQ%3D",
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:49:08Z&se=2023-11-01T01:49:08Z&spr=https&sv=2020-08-04&sr=b&sig=pmokvxDbrsGioAS00eWPKjP%2BKjIE5F9QWIYwcyJi4Ds%3D",
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:49:40Z&se=2023-11-01T01:49:40Z&spr=https&sv=2020-08-04&sr=b&sig=%2F%2F%2F%2BQUyjgRYLt6JnXqXPKJFAAtBojtpx%2BfaFltU2G%2Bs%3D",
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~wow64~fr-CA~.cab?sp=r&st=2021-10-31T17:50:05Z&se=2023-11-01T01:50:05Z&spr=https&sv=2020-08-04&sr=b&sig=sZuQ0s%2Fajyw29GjujJYeSsBI8x94HVyG9NsJrAKC0pA%3D",
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab?sp=r&st=2021-10-31T17:50:32Z&se=2023-11-01T01:50:32Z&spr=https&sv=2020-08-04&sr=b&sig=CzASUpV6TJkkMc68MqXgWkG60jyOuYsLmLTwpgucoWQ%3D",
#     "https://azureshelleric.blob.core.windows.net/win11/fr-ca/Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~wow64~fr-CA~.cab?sp=r&st=2021-10-31T17:51:09Z&se=2023-11-01T01:51:09Z&spr=https&sv=2020-08-04&sr=b&sig=nh%2Fgz4wgnhLZAGqZyB%2FHrYwrCbYvScBdCgwKIpjoh%2Bw%3D"
# )


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
"lang installed" | out-file  "$env:temp\wow1.txt"
Add-WindowsPackage -online -PackagePath  "$env:temp\lang.cab"
"lang installed" | out-file  "$env:temp\wow2.txt"



$lang | ForEach-Object  { Remove-WindowsCapability -Online -Name $_  }
"Removed capabilities" | out-file "$env:temp\wow3.txt"



$lang | ForEach-Object  { Add-WindowsCapability -Online -Name $_  }
"Added capabilities"  | out-file "$env:temp\wow4.txt"


# $array = $linkArray  | ForEach-Object { @{url=$_ ; filename=[regex]::Match($_ , "fr-ca\/(.+)\?").captures.groups[1].value }  }
# "Loop for array"
# get-date -Format "T"
# " "

# $array | ForEach-Object  { Invoke-WebRequest -UseBasicParsing -Uri $_.url -OutFile (join-path  $env:temp   $_.filename)  } 
# "loop for download"
# get-date -Format "T"
# " "

# $array | ForEach-Object { Add-WindowsPackage -Online -PackagePath (join-path  $env:temp   $_.filename)  }
# "loop for integrating windows package"
# get-date -Format "T"
# " "


restart-computer
"Restarted"  | out-file "$env:temp\wow5.txt"


# set in canada
# set-WinHomeLocation -geoid 39
# set-culture -CultureInfo fr-CA
# Set-WinSystemLocale -SystemLocale fr-CA

# $UserLanguageList = New-WinUserLanguageList -Language "fr-CA"
# $UserLanguageList.Add("en-US")

# Set-WinUserLanguageList -LanguageList $UserLanguageList -force


#Set-WinUILanguageOverride -Language fr-CA


