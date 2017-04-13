

#The web source always points to the latest release of Visual Studio 2017 Community. 
$WebSource = "https://aka.ms/vs/15/release/vs_Community.exe";
$dest = ( "${env:Temp}\vs_Community.exe");

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
        --productid Microsoft.VisualStudio.Product.Community `
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
        --includeRecommended --passive | Out-Null;
}
catch
{
    Write-Error 'Failed to install VS2017';
}
