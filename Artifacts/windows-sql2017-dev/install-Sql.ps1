#https://go.microsoft.com/fwlink/?linkid=853015  EVAL
#https://go.microsoft.com/fwlink/?linkid=853016  DEV
#https://go.microsoft.com/fwlink/?linkid=853017  EXPRESS
   

#https://download.microsoft.com/download/5/A/7/5A7065A2-C81C-4A31-9972-8A31AC9388C1/SQLServer2017-SSEI-Dev.exe
#https://download.microsoft.com/download/5/2/2/522EE642-941E-47A6-8431-57F0C2694EDF/SQLServer2017-SSEI-Eval.exe
#https://download.microsoft.com/download/5/E/9/5E9B18CC-8FD5-467E-B5BF-BADE39C51F73/SQLServer2017-SSEI-Expr.exe

#SQLServer2017-SSEI-expr.exe /action=download /MediaPath=C:\media /MediaType=advanced /lang=en-US /quiet
#SQLServer2017-SSEI-expr.exe /action=download /MediaPath=C:\media /MediaType=core /lang=en-US /quiet
#SQLServer2017-SSEI-expr.exe /action=download /MediaPath=C:\media /MediaType=localdb /lang=en-US /quiet

#SQLServer2017-SSEI-dev.exe  /action=download /MediaPath=C:\media /MediaType=iso /lang=en-US /quiet
#SQLServer2017-SSEI-eval.exe /action=download /MediaPath=C:\media /MediaType=iso /lang=en-US /quiet


#$dest =  "$env:userprofile\downloads\SQLServer2016-SSEI-Dev.exe"    

#& $dest /ConfigurationFile=C:\sqlsource\ConfigurationFile.ini  /iAcceptSqlServerLicenseTerms /mediaPath=c:\sqlSource /ENU

Param
(
   [string] $sqlEdition = "dev",            #3 values possible: eval, dev, express
   [string] $installType= "normalInstall",  #3 values possible: normalInstall, prepareBeforeImage, completeAfterDeploy
   [string] $components = "SQL",
   [string] $instanceName = "MSSQLSERVER",
   [array]  $admins= @("localmachine\afi","NT AUTHORITY\SYSTEM"),
   [string] [AllowEmptyString()] $prodid="",	
   [bool]   $reporting = $false,
   [bool]   $analysis = $false,
   [bool]   $tabular=$false,
   [bool]   $integration = $false,
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


try
{
    $temp = (New-Object System.Security.Principal.NTAccount($admins[0] -replace "localmachine\\", "$env:computername\")).Translate([System.Security.Principal.SecurityIdentifier]).Value
}
catch
{ 
    $admins[0]="BUILTIN\Users"
}


#for each logon, replace Localmachine by the computername, add quotes around, and join them in a single string.
$adminString= ($admins | ForEach-Object  {($_ -replace "localmachine\\", "$env:computername\") -replace "(.+)", '"$1"'} )  -join " " -replace '^\"(.+)\"', '$1'

"Liste: " + $adminString

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




#function to download ssei, and download the iso or files
#download-fromSsei

if ($installType -ne "completeAfterDeploy" )
{
    #Download SqlServer 2017 iso (dev or eval)
    if ($sqlEdition -eq "dev" -or $sqlEdition -eq "eval")
    {
       if ($sqlEdition -eq "dev") 
                {$isofile="SQLServer2017-x64-ENU-Dev.iso";
                 $source="https://go.microsoft.com/fwlink/?linkid=853016"} 
                else 
                {$isofile="SQLServer2017-x64-ENU.iso";
                 $source="https://go.microsoft.com/fwlink/?linkid=853015"}

        $SSEIFile="$env:temp\sql2017.exe"

        $wc = new-object System.Net.WebClient
        $wc.DownloadFile($Source,$SSEIFile)
        $wc.Dispose()


        & $SSEIFile /action=download /mediapath=c:\sqlISO /mediatype=ISO language=en-US /Quiet | Out-Default
         
      

        #Remove-VC-Redist-2017
        

        #Mount iso
        Mount-DiskImage $isoFile
        $mountedVolume = Get-DiskImage -ImagePath $isoFile | Get-Volume
        $isoFileLetter = "$($mountedVolume.DriveLetter):"

        $setupFile= "$isoFileletter\setup.exe"

    }
    else #Download SqlServer 2017 Express
    {


        $source="https://go.microsoft.com/fwlink/?linkid=853017"
        $SSEIFile="$env:temp\sql2017.exe" 
    
        $wc = new-object System.Net.WebClient
        $wc.DownloadFile($Source,$SSEIFile)
        $wc.Dispose()


        & $SSEIFile   /action=download /mediapath=c:\sqlISO /mediatype=Core /language=en-US /quiet | Out-Default

        $setupFile="c:\sqlISO\SQLEXPR_x64_ENU.exe"
       # $instanceName="SQLexpress"

    }
}

$adminString2 = $adminString ;

if ($installType -eq "normalInstall") 
{
    $pidString = if ([string]$prodid -ne ''){ "/PID=`"$prodid`""} else {""}


     &  "$setupFile" /q `
                       /Action=install `
                       $features `
                       /SuppressPrivacyStatementNotice `
                       /IAcceptROpenLicenseTerms `
                       /IAcceptSqlServerLicenseTerms `
                       /InstanceName=$instanceName `
                       /RsInstallMode="DefaultNativeMode" `
                       /SqlSysAdminAccounts= $adminString2 `
                       /AsSysAdminAccounts= $adminString2 `
                       /AsServerMode=$ASMode `
                       /SqlSvcInstantFileInit `
                       $pidString `
                       | Out-Default

             #            &  "$setupFile" /q `
             #          /Action=uninstall `
             #          $features `
             #          /SuppressPrivacyStatementNotice `
             #          /IAcceptROpenLicenseTerms `
             #          /IAcceptSqlServerLicenseTerms `
             #          /InstanceName=sqlexpress `
             #          $pidString `
             #          | Out-Default

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
                    /InstanceID=$instanceName `
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
                       /InstanceName=$instanceName `
                       /InstanceID=$instanceName `
                       /RsInstallMode="DefaultNativeMode" `
                       /SqlSysAdminAccounts= $adminString `
                       /AsSysAdminAccounts= $adminString `
                       /AsServerMode=$ASMode `
                       /SqlSvcInstantFileInit `
                       $pidString `
                       | Out-Default
 }



#& $isoFileletter\setup.exe /q `
#                       /Action=install `
#                       /Features=SQL,AS,RS,IS,DQC,MDS,ADVANCEDANALYTICS `
#                       /SuppressPrivacyStatementNotice `
#                       /IAcceptROpenLicenseTerms `
#                       /IAcceptSqlServerLicenseTerms `
#                       /InstanceName=MSSQLSERVER `
#                       /RsInstallMode="DefaultNativeMode" `
#                       /AsSysAdminAccounts="$env:computerName\afi" `
#                       /AsServerMode="TABULAR" `
#                       /SqlSvcInstantFileInit `
#                       /SqlSysAdminAccounts="$env:computerName\afi" "NT AUTHORITY\SYSTEM"  `
#                       | Out-Default

if ($isoFile) {
    Dismount-DiskImage $isoFile
}

