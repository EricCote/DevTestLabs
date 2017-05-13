[CmdletBinding()]
Param ( [string] $key = ""  )

# $key will contain "a" when it is called with no params as an artifact.  
# Let's remove "a" when it is passed.
if ($key -eq "a") {
  $key = "";
}

#Let's prepare an uppercase version of the key with no dashes.
$keyNoDashes=$key.ToUpper().Replace("-","");
# the param "--productKey" is only sent when there is a $key
$stringKey= if ($key) {"--productKey"} else {""};

#The web source always points to the latest release of Visual Studio 2017 Professional. 
$WebSource = "https://aka.ms/vs/15/release/vs_professional.exe";
$dest = ( "${env:Temp}\vs_professional.exe");

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
    & $dest  `
        --channelid  VisualStudio.15.Release `
        --productid Microsoft.VisualStudio.Product.Professional `
        --add Microsoft.VisualStudio.Workload.NetWeb  `
        --add Microsoft.VisualStudio.Workload.NetCoreTools `
        --add Microsoft.VisualStudio.Workload.ManagedDesktop `
        --add Microsoft.VisualStudio.Workload.Azure `
        --add Microsoft.VisualStudio.Workload.Data `
        --add Component.GitHub.VisualStudio `
        --add Microsoft.NetCore.ComponentGroup.DevelopmentTools `
        --add Microsoft.Net.Core.Component.SDK `
        --add Microsoft.VisualStudio.Component.PowerShell.Tools `
        --add Microsoft.VisualStudio.Component.VC.CoreIde `
        $stringKey $keyNoDashes `
        --addProductLang fr-FR --addProductLang en-US `
        --includeRecommended --quiet --wait | Out-Null;
}
catch
{
    Write-Error 'Failed to install VS2017';
}

#let's print the key.
"This is the key: " + $key;

#Other activation method.
#try
#{
#   & "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\StorePID.exe" $key 8862 | Out-Null
#}
#catch
#{
#    Write-Error 'Failed to activate VS2017'
#}



