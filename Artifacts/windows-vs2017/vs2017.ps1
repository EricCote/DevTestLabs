[CmdletBinding()]
Param ( 
[string] $edition = "enterprise",
[bool]  $preview = $true,
[bool]  $aspnet = $true,
[bool]  $netcore = $true,
[bool]  $desktop = $true,
[bool]  $azure = $true,
[bool]  $data = $true,
[string] $languages =  "en-US", 
[string] $key = ""  )


#Let's prepare a version of the key with no dashes.
$keyNoDashes=$key.ToUpper().Replace("-","");
# the param "--productKey" is only sent when there is a $key
$stringKey= if ($key) {"--productKey"} else {""};

#The web source always points to the latest release of Visual Studio 2017 Enterprise. 
$WebSourceEnt = "https://aka.ms/vs/15/release/vs_Enterprise.exe";
$WebSourcePro = "https://aka.ms/vs/15/release/vs_Professional.exe";
$WebSourceCom = "https://aka.ms/vs/15/release/vs_Community.exe";

switch ($edition.Substring(0,3)) 
{ 
  "ent" {$WebSource=$WebSourceEnt} 
  "pro" {$WebSource=$WebSourcePro} 
  default {$WebSource=$WebSourceCom}
}

$languages=$languages.Split(",").Trim()

$languageParams=@();

foreach ($lang in $languages) {
    $languageParams += @("--addProductLang", $lang)
}




$channel="VisualStudio.15.Release"
$workloads=@()

if ($Preview)
{
   $websource = $Websource.Replace("release","pre")
   $channel="VisualStudio.15.Preview"
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

$dest = ( "${env:Temp}\vs_setup.exe");

try
{
    (New-Object System.Net.WebClient).DownloadFile($WebSource, $dest);
}
catch
{
    Write-Error "Failed to download vs2017 installer";
}


try
{
     & $dest `
         --channelid $channel `
         --productid Microsoft.VisualStudio.Product.$edition `
         $workloads `
         $languageParams `         $stringKey $keyNoDashes `         --includeRecommended --quiet --wait `
              | Out-Default;
}
catch
{
    Write-Error 'Failed to install VS2017';
}

#let's print the key.
#"This is the key: " + $key;

#Other activation method.
#try
#{
#  & "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\StorePID.exe" NJVYC-BMHX2-G77MM-4XJMR-6Q8QF 8860 | Out-Null;
#}
#catch
#{
#   Write-Error 'Failed to activate VS2017';
#}



