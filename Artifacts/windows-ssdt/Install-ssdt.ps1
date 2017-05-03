#ssdt setup
$source = "https://go.microsoft.com/fwlink/?linkid=846626"
$destination = "$env:temp\ssdtsetup.exe"

(New-Object System.Net.WebClient).DownloadFile($Source, $Destination)

& $Destination INSTALLALL=1 /quiet | out-default
