$ProgressPreference = 'SilentlyContinue'

$sas = "sp=r&st=2023-04-02T16:50:54Z&se=2027-04-03T00:50:54Z&spr=https&sv=2021-12-02&sr=c&sig=012Vqsxh8laVq0pioYJI8i1N1Ykg7yfeN8bXVUw1y2g%3D" 
$blobLocation = "https://azureshelleric.blob.core.windows.net/win2022server/fr-ca";

$logPath = "$env:temp\log-sys-fr-ca.txt"


$linkArray = @(
    "Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~wow64~fr-CA~.cab",
    "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~wow64~fr-CA~.cab",
    "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~wow64~fr-CA~.cab",
    "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~wow64~fr-CA~.cab",   
    "Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~fr-CA~.cab",
    "Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~wow64~fr-CA~.cab"
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

$FOD2 = @(
"Microsoft-Windows-LanguageFeatures-Basic-fr-ca-Package~31bf3856ad364e35~amd64~~.cab",
"Microsoft-Windows-LanguageFeatures-Basic-fr-fr-Package~31bf3856ad364e35~amd64~~.cab",
"Microsoft-Windows-LanguageFeatures-Handwriting-fr-fr-Package~31bf3856ad364e35~amd64~~.cab",
"Microsoft-Windows-LanguageFeatures-OCR-fr-ca-Package~31bf3856ad364e35~amd64~~.cab",
"Microsoft-Windows-LanguageFeatures-Speech-fr-ca-Package~31bf3856ad364e35~amd64~~.cab",
"Microsoft-Windows-LanguageFeatures-TextToSpeech-fr-ca-Package~31bf3856ad364e35~amd64~~.cab"
)


$url = "$blobLocation/Microsoft-Windows-Server-Language-Pack_x64_fr-ca.cab?$sas"

$destination="$env:temp\lang"
New-Item  $destination -ItemType Directory -force

Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile "$destination\lang.cab"
"Lang Downloaded $(Get-Date -Format T)"  | out-file  $logPath -append
Add-WindowsPackage -online -PackagePath  "$destination\lang.cab"
"Lang Installed $(Get-Date -Format T)" | out-file  $logPath -append

$packagesFod = $FOD2 | ForEach-Object { @{url = "$blobLocation/$($_)?$sas"; filename = $_ } }
"list of FOD packages $(Get-Date -Format T)"  | out-file $logPath -append

$packagesFod | ForEach-Object { Invoke-WebRequest -UseBasicParsing -Uri $_.url -OutFile "$destination\$($_.filename)" } 
"loop for FOD download $(Get-Date -Format T)" | out-file $logPath -append

$FOD | ForEach-Object { Add-WindowsCapability -Online  -Name $_  -Source $destination -LimitAccess }
"loop for integrating FOD package $(Get-Date -Format T)"  | out-file $logPath -append

$packages = $linkArray | ForEach-Object { @{url = "$blobLocation/$($_)?$sas"; filename = $_ } }
"generate a list of package names and url $(Get-Date -Format T)" | out-file $logPath -append

$packages | ForEach-Object { Invoke-WebRequest -UseBasicParsing -Uri $_.url -OutFile "$destination\$($_.filename)" } 
"loop for download $(Get-Date -Format T)" | out-file $logPath -append

$packages | ForEach-Object { Add-WindowsPackage -Online -PackagePath (join-path  $destination   $_.filename) }
"loop for integrating windows package $(Get-Date -Format T)"  | out-file $logPath -append

Remove-Item $destination  -Recurse -Force
"Remove downloaded files"   | out-file $logPath -append

restart-computer
"Restarted  $(Get-Date -Format T)"   | out-file $logPath -append

