[CmdletBinding()]
Param ( 
    [string] $Edition = "Enterprise",
    [string] $VsVersion = "2022",
    [string] $Channel = "Release",
    [string] $Workloads = "Select",
    [string] $WorkloadList = "data,netweb",
    [string] $languages = "en-US", 
    [string] $Key = "",
    [string] $Components = "",
    [string] $Restart = "No Restart"
)

$ProgressPreference = 'SilentlyContinue'

#Let's prepare a version of the key with no dashes.
$keyNoDashes = $key.ToUpper().Replace("-", "");
# the param "--productKey" is only sent when there is a $key
$stringKey = if ($key) { "--productKey $keyNoDashes" } else { "" };


#Version number. 2017=15, 2019=16, 2022=17, 2026=18, 2029=19
$ver = if ($vsVersion -eq "2017") { "15" } elseif ($vsVersion -eq "2019") { "16" } elseif ($vsVersion -eq "2022") { "17" } elseif ($VsVersion -eq "2026") { "18" } else { "19" }

$channl = if ($Channel -eq 'Preview') { "pre" } elseif ($Channel -eq 'Insiders') { "insiders" } elseif ($vsVersion -lt "2026") { "release" } else {"stable" }
$source = "https://aka.ms/vs/$ver/$channl/vs_$Edition.exe";


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


$dest = ( "${env:Temp}\vs_setup.exe");
"a"
try {
    Invoke-WebRequest  -UseBasicParsing -Uri $source  -OutFile $dest
}
catch {
    Write-Error "Failed to download VS installer";
}

"$source"

$myParams = " --productid Microsoft.VisualStudio.Product.$edition $loadParams $loads $comps $languageParams $stringKey  $reboot --quiet  --wait  "
$myParams2 = $myParams.Split(" ");


try {      
    & $dest $myParams2 | Out-Null;
}
catch {
    Write-Error 'Failed to install Visual studio';
}

"c"
"& $dest $myParams2"


