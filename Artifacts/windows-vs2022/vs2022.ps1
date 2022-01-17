[CmdletBinding()]
Param ( 
[string] $edition = "enterprise",
[string] $vsVersion = "2017",
[string]  $preview = "Release",
[string] $workloads= "",
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

$source

$languageParams=$languages.Split(',') | % { "--addProductLang $($_.Trim())" }

$prev =if($preview ) {"Preview"} else {"Release"}

$channel="VisualStudio.$ver.$preview"

$loads = ($workloads -replace "\+", ";includeRecommended" -replace "\*",";includeOptional").split(",") | % { "--add  Microsoft.VisualStudio.Workload.$($_.trim())"}


$dest = ( "${env:Temp}\vs_setup.exe");

try
{
    (New-Object System.Net.WebClient).DownloadFile($WebSource, $dest);
}
catch
{
    Write-Error "Failed to download vs2022 installer";
}


try
{      
      & $dest `
         --channelid $channel `
         --productid Microsoft.VisualStudio.Product.$edition `
         $loads `
         $languageParams `
         $stringKey $keyNoDashes `
         --includeRecommended --quiet --wait `
              | Out-Null;
}
catch
{
    Write-Error 'Failed to install Visual studio';
}


"& $dest --channelid $channel --productid Microsoft.VisualStudio.Product.$edition $loads $languageParams $stringKey $keyNoDashes --includeRecommended --quiet --wait "


#let's print the key.
#"This is the key: " + $key;
#Other activation method.
#try
#{
#  & "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\StorePID.exe" NJVYC-BMHX2-G77MM-4XJMR-6Q8QF 8860 | Out-Null;
#}
#catch
#{
#   Write-Error 'Failed to activate VS2019';
#}
