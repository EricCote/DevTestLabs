


[CmdletBinding()]
Param ( 
    [string] $Edition = "SSMS",
    [string] $Version = "21",
    [string] $Channel = "Release",
    [string] $Workloads = "Select",
    [string] $WorkloadList = "AI+,BI+,HybridAndMigration+",
    [string] $languages = "en-US", 
    [string] $Key = "",
    [string] $Components = "",
    [string] $Restart = "No Restart"
)


#Let's prepare a version of the key with no dashes.
$keyNoDashes = $key.ToUpper().Replace("-", "");
# the param "--productKey" is only sent when there is a $key
$stringKey = if ($key) { "--productKey $keyNoDashes" } else { "" };


#Version number. 21, 22, or future
$ver = $Version

$channl = if ($Channel -eq 'Preview') { "preview" } else { "release" }
$source = "https://aka.ms/ssms/$ver/$channl/vs_$Edition.exe";


$languageParams = $languages.Split(',') | ForEach-Object { "--addProductLang $($_.Trim())" } 


# $channelVer="VisualStudio.$ver.$Channel"

$LoadParams = switch ($Workloads) {
    "All Workloads" { "--allWorkloads" }
    "All with Recommended" { "--allWorkloads --includeRecommended" }
    "All with Optional" { "--allWorkloads --includeOptional" }
    "All with Recommended and Optional" { "--allWorkloads --includeRecommended --includeOptional" }
    "Complete" { "--all" }
    Default { "" }
}

$loads = ($WorkloadList -replace "\+", ";includeRecommended" -replace "\*", ";includeOptional").split(",") | ? -Property Length -GT 0 | % { "--add  Microsoft.VisualStudio.Workload.$($_.trim())" }
$comps = $Components.split(",") | ? -Property Length -GT 0 | % { "--add $($_.trim())" }

if ($LoadParams -ne "")
{ $loads = "" }

$reboot = if ($restart -eq "No restart") { "--noRestart" } else { "" }


$dest = ( "${env:Temp}\vs_ssms.exe");

try {
    Invoke-WebRequest  -UseBasicParsing -Uri $source  -OutFile $dest
}
catch {
    Write-Error "Failed to download ssms installer";
}

$myParams = " --productid Microsoft.VisualStudio.Product.$edition $loadParams $loads $comps $languageParams $stringKey  $reboot --quiet  --wait  "
$myParams2 = $myParams.Split(" ");


"& $dest $myParams2"

try {      
    & $dest $myParams2 
}
catch {
    Write-Error 'Failed to install SSMS';
}













