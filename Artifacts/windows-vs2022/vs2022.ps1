[CmdletBinding()]
Param ( 
[string] $edition = "enterprise",
[bool]  $preview = $true,
[bool]  $aspnet = $true,
[bool]  $netcore = $true,
[bool]  $desktop = $true,
[bool]  $azure = $true,
[bool]  $data = $true,
[bool]  $node = $true,
[string] $languages =  "en-US", 
[string] $key = ""  )


#Let's prepare a version of the key with no dashes.
$keyNoDashes=$key.ToUpper().Replace("-","");
# the param "--productKey" is only sent when there is a $key
$stringKey= if ($key) {"--productKey"} else {""};

#The web source always points to the latest release of Visual Studio 2022 Enterprise. 

$WebSourceEnt = "https://aka.ms/vs/17/release/vs_enterprise.exe";
$WebSourcePro = "https://aka.ms/vs/17/release/vs_professional.exe";
$WebSourceCom = "https://aka.ms/vs/17/release/vs_community.exe";

switch ($edition.Substring(0,3)) 
{ 
  "ent" {$WebSource=$WebSourceEnt} 
  "pro" {$WebSource=$WebSourcePro} 
  default {$WebSource=$WebSourceCom}
}


$langs=$languages.Split(',').Trim()

$langs

$languageParams=@();

foreach ($lang in $langs) {
    $languageParams += @("--addProductLang", $lang)
}

$languageParams

convertto-json $languageParams

$channel="VisualStudio.17.Release"
$workloads=@()

if ($Preview)
{
   $websource = $Websource.Replace("release","pre")
   $channel="VisualStudio.17.Preview"
}

if ($aspnet){
   $workloads += @("--add", "Microsoft.VisualStudio.Workload.NetWeb")
}
if ($netcore){
   $workloads += @("--add", "Microsoft.VisualStudio.Workload.NetCoreTools")
}
if ($desktop){
   $workloads += @("--add", "Microsoft.VisualStudio.Workload.ManagedDesktop")
}
if ($azure){
   $workloads += @("--add", "Microsoft.VisualStudio.Workload.Azure")
}
if ($data){
   $workloads += @("--add", "Microsoft.VisualStudio.Workload.Data")
}
if ($node){
   $workloads += @("--add", "Microsoft.VisualStudio.Workload.Node")
}

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
         $workloads `
         $languageParams `
         $stringKey $keyNoDashes `
         --includeRecommended --quiet --wait `
              | Out-Null;
}
catch
{
    Write-Error 'Failed to install VS2022';
}


"& $dest --channelid $channel --productid Microsoft.VisualStudio.Product.$edition $workloads $($languageParams) $stringKey $keyNoDashes --includeRecommended --quiet --wait "

convertto-json $languageParams

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
