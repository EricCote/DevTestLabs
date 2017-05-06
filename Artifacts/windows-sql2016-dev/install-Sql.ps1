#https://go.microsoft.com/fwlink/?LinkID=799009   #dev ssei
#https://go.microsoft.com/fwlink/?LinkID=799011   #eval ssei
#https://go.microsoft.com/fwlink/?LinkID=799012   #express ssei
#https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLEXPRADV_x64_ENU.exe #expressadvanced
#https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLEXPR_x64_ENU.exe    #express core
#https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SqlLocalDB.msi         #localdb
#https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLServer2016SP1-FullSlipstream-x64-ENU-DEV.iso
#https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLServer2016SP1-FullSlipstream-x64-ENU.iso
#$dest =  "$env:userprofile\downloads\SQLServer2016-SSEI-Dev.exe"    

#& $dest /ConfigurationFile=C:\sqlsource\ConfigurationFile.ini  /iAcceptSqlServerLicenseTerms /mediaPath=c:\sqlSource /ENU

Param
(
   [string] $sqlEdition = "dev",            #3 values possible: eval, dev, express
   [string] $installType= "normalInstall",  #3 values possible: normalInstall, prepareBeforeImage, completeAfterDeploy
   [string] $components = "SQL",
   [string] $instanceName = "MSSQLSERVER",
   [array]  $admins= @("localmachine\Users","NT AUTHORITY\SYSTEM"),
   [string] [AllowEmptyString()] $prodid="",	
   [bool]   $reporting = $true,
   [bool]   $analysis = $true,
   [bool]   $tabular=$true,
   [bool]   $integration = $true,
   [bool]   $dataQualityClient = $false,
   [bool]   $masterDataService = $false,
   [bool]   $RServices = $false,
   [bool]   $polyBase = $false
)


function Remove-VC-Redist-2017
{
    #remove newer c++ redistribuable from 2017
    $vcRemove32="C:\ProgramData\Package Cache\{c239cea1-d49e-4e16-8e87-8c055765f7ec}\VC_redist.x86.exe"
    $vcRemove64="C:\ProgramData\Package Cache\{f1e7e313-06df-4c56-96a9-99fdfd149c51}\VC_redist.x64.exe"
    if (Test-Path $vcRemove32)
    {
        & $vcRemove32  /uninstall  /quiet | Out-Default   
    }
    if (Test-Path $vcRemove64)
    {
        & $vcRemove64  /uninstall  /quiet | Out-Default   
    }
}



#for each logon, replace Localmachine by the computername, add quotes around, and join them in a single string.
$adminString= ($admins | ForEach-Object  {($_ -replace "localmachine\\", "$env:computername\") -replace "([\w\W]+)", '"$1"'} )  -join " "


$arrayFeatures = @($components)
if ($reporting)         {$arrayFeatures += "RS"} 
if ($analysis)          {$arrayFeatures += "AS"}
if ($integration)       {$arrayFeatures += "IS"}
if ($dataQualityClient) {$arrayFeatures += "DQC"}
if ($masterDataService) {$arrayFeatures += "MDS"}
if ($RServices)         {$arrayFeatures += "AdvancedAnalytics"}
if ($PolyBase)          {$arrayFeatures += "PolyBase"}

$features= "/Features=" + ($arrayFeatures -join ",")

$ASMode=if($tabular){"TABULAR"}else{"MULTIDIMENSIONAL"}


if ($installType -ne "completeAfterDeploy" )
{
    #Download SqlServer 2016 SP1 iso (dev or eval)
    if ($sqlEdition -eq "dev" -or $sqlEdition -eq "eval")
    {
        $source=if ($sqlEdition -eq "dev") 
                {"https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLServer2016SP1-FullSlipstream-x64-ENU-DEV.iso"} 
                else 
                {"https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLServer2016SP1-FullSlipstream-x64-ENU.iso"}
        $isoFile="$env:temp\sql2016.iso"

        $wc = new-object System.Net.WebClient
        $wc.DownloadFile($Source,$isoFile)
        $wc.Dispose()

        Remove-VC-Redist-2017
        

        #Mount iso
        Mount-DiskImage $isoFile
        $mountedVolume = Get-DiskImage -ImagePath $isoFile | Get-Volume
        $isoFileLetter = "$($mountedVolume.DriveLetter):"

        $setupFile= "$isoFileletter\setup.exe"

    }
    else #Download SqlServer 2016 SP1 Express
    {
        $source="https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLEXPRADV_x64_ENU.exe"
        $setupFile="$env:temp\SQLExpr2016.exe"    
    
        $wc = new-object System.Net.WebClient
        $wc.DownloadFile($Source,$setupFile)
        $wc.Dispose()

    }
}

if ($installType -eq "normalInstall") 
{
    $pidString = if ([string]$prodid -ne ''){ "/PID=`"$prodid`""} else {""}

    & $setupFile   /q `
                    /Action=install `
                    $features `
                    /SuppressPrivacyStatementNotice `
                    /IAcceptROpenLicenseTerms `
                    /IAcceptSqlServerLicenseTerms `
                    /SqlSvcInstantFileInit `
                    /InstanceName="$instanceName" `
                    /SqlSysAdminAccounts=$adminString  `
                    /AsSysAdminAccounts=$adminString `
                    /AsServerMode="$ASMode" `
                    /RsInstallMode="DefaultNativeMode" `
                    $pidString `
                    | Out-Default
}
if ($installType -eq "prepareBeforeImage") 
{
    & $setupFile   /q `
                    /Action=PrepareImage `
                    $features `
                    /SuppressPrivacyStatementNotice `
                    /IAcceptROpenLicenseTerms `
                    /IAcceptSqlServerLicenseTerms `
                    /SqlSvcInstantFileInit `
                    /InstanceID="$instanceName" `
                    | Out-Default
}


if ($installType -eq "completeAfterDeploy") 
{
    if ([string]$prodid -ne '')
    { 
        $pidString="/PID=`"$prodid`""
    }
    elseif ($sqlEdition -eq 'dev')
    {
        $pidString="/PID=`"22222-00000-00000-00000-00000`""
    }
    else 
    {    $pidString=""   }

    & "$env:programFiles\Microsoft SQL Server\130\Setup Bootstrap\SQLServer2016\setup.exe" /q `
                       /Action=CompleteImage `
                       /SuppressPrivacyStatementNotice `
                       /IAcceptROpenLicenseTerms `
                       /IAcceptSqlServerLicenseTerms `
                       /InstanceName="$instanceName" `
                       /InstanceID="$instanceName" `
                       /RsInstallMode="DefaultNativeMode" `
                       /SqlSysAdminAccounts=$adminString `
                       /AsSysAdminAccounts=$adminString `
                       /AsServerMode="$ASMode" `
                       /SqlSvcInstantFileInit `
                       $pidString `
                       | Out-Default
 }



& $isoFileletter\setup.exe /q `
                       /Action=install `
                       /Features=SQL,AS,RS,IS,DQC,MDS,ADVANCEDANALYTICS `
                       /SuppressPrivacyStatementNotice `
                       /IAcceptROpenLicenseTerms `
                       /IAcceptSqlServerLicenseTerms `
                       /InstanceName=MSSQLSERVER `
                       /RsInstallMode="DefaultNativeMode" `
                       /AsSysAdminAccounts="$env:computerName\afi" `
                       /AsServerMode="TABULAR" `
                       /SqlSvcInstantFileInit `
                       /SqlSysAdminAccounts="$env:computerName\afi" "NT AUTHORITY\SYSTEM"  `
                       | Out-Default


Dismount-DiskImage $isoFile


