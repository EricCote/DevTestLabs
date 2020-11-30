#ssms setup
$source = "https://aka.ms/ssmsfullsetup"
$destination = "$env:temp\ssms-setup-enu.exe"

(New-Object System.Net.WebClient).DownloadFile($Source, $Destination)

& $Destination /install /quiet | out-default
