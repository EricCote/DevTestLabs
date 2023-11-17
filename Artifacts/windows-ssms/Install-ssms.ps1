param (
    [string]$lang = "English (409)"
)

$Query = [regex]::Matches($lang, "\((.*)\)")
$num = $Query.Groups[1].Value
$langNumber="0x$num"
$source="https://aka.ms/ssmsfullsetup?clcid=$langNumber"


$destination = "$env:temp\ssms-setup.exe"

Invoke-WebRequest  -UseBasicParsing -Uri $source  -OutFile $destination

& $destination /install /quiet | out-default

Remove-Item $destination




