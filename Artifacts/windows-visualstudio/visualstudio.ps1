[CmdletBinding()]
Param ( 
[string] $edition = "enterprise",
[string] $vsVersion = "2022",
[string]  $preview = "Release",
[string] $workloads= "data,netweb",
[string] $languages =  "en-US", 
[string] $key = ""  )


#Let's prepare a version of the key with no dashes.
$keyNoDashes=$key.ToUpper().Replace("-","");
# the param "--productKey" is only sent when there is a $key
$stringKey= if ($key) {"--productKey"} else {""};


#Version number. 2017=15, 2019=16, 2022=17
$ver=if ($vsVersion -eq "2017") {"15"} elseif ($vsVersion -eq "2019") {"16"} else {"17"}
$prev =if($preview -eq 'Preview') {"pre"} else {"release"}
$source = "https://aka.ms/vs/$ver/$prev/vs_$Edition.exe";


$languageParams=$languages.Split(',') | where {$_ -ne "en-US"} | % { "--addProductLang $($_.Trim())" } 

$prev =if($preview ) {"Preview"} else {"Release"}

$channel="VisualStudio.$ver.$preview"

$loads = ($workloads -replace "\+", ";includeRecommended" -replace "\*",";includeOptional").split(",") | ? -Property Length -GT 0 | % { "--add  Microsoft.VisualStudio.Workload.$($_.trim())"}


$dest = ( "${env:Temp}\vs_setup.exe");

try
{
    (New-Object System.Net.WebClient).DownloadFile($source, $dest);
}
catch
{
    Write-Error "Failed to download vs2022 installer";
}

$myParams =  " --productid Microsoft.VisualStudio.Product.$edition $loads $languageParams $stringKey $keyNoDashes --quiet  --wait  "
$myParams2 = $myParams.Split(" ");


try
{      
      & $dest $myParams2 | Out-Default;
}
catch
{
    Write-Error 'Failed to install Visual studio';
}


"& $dest $myParams"


