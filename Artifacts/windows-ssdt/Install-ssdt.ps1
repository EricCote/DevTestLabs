#ssms setup
$source = "https://go.microsoft.com/fwlink/?linkid=847722"
$destination = "$env:temp\ssms-setup-enu.exe"

(New-Object System.Net.WebClient).DownloadFile($Source, $Destination)

& $Destination /install /quiet | out-default
