#https://go.microsoft.com/fwlink/?linkid=866664  EVAL
#https://go.microsoft.com/fwlink/?linkid=866662  DEV
#https://go.microsoft.com/fwlink/?linkid=866658  EXPRESS
   

#https://download.microsoft.com/download/d/a/2/da259851-b941-459d-989c-54a18a5d44dd/SQL2019-SSEI-Dev.exe
#https://download.microsoft.com/download/4/8/6/486005eb-7aa8-4128-aac0-6569782b37b0/SQL2019-SSEI-Eval.exe
#https://download.microsoft.com/download/7/f/8/7f8a9c43-8c8a-4f7c-9f92-83c18d96b681/SQL2019-SSEI-Expr.exe

#SQLServer2019-SSEI-expr.exe /action=download /MediaPath=C:\media /MediaType=advanced /lang=en-US /quiet
#SQLServer2019-SSEI-expr.exe /action=download /MediaPath=C:\media /MediaType=core /lang=en-US /quiet
#SQLServer2019-SSEI-expr.exe /action=download /MediaPath=C:\media /MediaType=localdb /lang=en-US /quiet

#SQLServer2019-SSEI-dev.exe  /action=download /MediaPath=C:\media /MediaType=iso /lang=en-US /quiet
#SQLServer2019-SSEI-eval.exe /action=download /MediaPath=C:\media /MediaType=iso /lang=en-US /quiet


#$dest =  "$env:userprofile\downloads\SQLServer2016-SSEI-Dev.exe"    

#& $dest /ConfigurationFile=C:\sqlsource\ConfigurationFile.ini  /iAcceptSqlServerLicenseTerms /mediaPath=c:\sqlSource /ENU

Param
(
    [string] $sqlEdition = "dev", #3 values possible: eval, dev, express
    [string] $installType = "normalInstall", #3 values possible: normalInstall, prepareBeforeImage, completeAfterDeploy
    [string] $components = "SQL",
    [string] $instanceName = "MSSQLSERVER",
    [array]  $admins = @("localmachine\afi", "NT AUTHORITY\SYSTEM"),
    [string] [AllowEmptyString()] $prodid = "",	
    [bool]   $reporting = $false,
    [bool]   $analysis = $false,
    [bool]   $tabular = $false,
    [bool]   $integration = $false,
    [bool]   $dataQualityClient = $false,
    [bool]   $masterDataService = $false,
    [bool]   $RServices = $false,
    [bool]   $polyBase = $false,
    [bool]   $keepISOFolder = $false
)


#   [string] $sqlEdition = "dev";         #3 values possible: eval, dev, express
#    [string] $installType= "normalInstall";  #3 values possible: normalInstall, prepareBeforeImage, completeAfterDeploy
#    [string] $components = "SQL";
#    [string] $instanceName = "MSSQLSERVER";
#    [array]  $admins= @("localmachine\afi","NT AUTHORITY\SYSTEM");
#    [string] [AllowEmptyString()] $prodid="";	
#    [bool]   $reporting = $true;
#    [bool]   $analysis = $true;
#    [bool]   $tabular=$true;
#    [bool]   $integration = $true;
#    [bool]   $dataQualityClient = $true;
#    [bool]   $masterDataService = $true;
#    [bool]   $RServices = $true;
#    [bool]   $polyBase = $false;


$ProgressPreference = 'SilentlyContinue'

try {
    $temp = (New-Object System.Security.Principal.NTAccount($admins[0] -replace "localmachine\\", "$env:computername\")).Translate([System.Security.Principal.SecurityIdentifier]).Value
}
catch { 
    $admins[0] = "BUILTIN\Users"
}


#for each logon, replace Localmachine by the computername, add quotes around, and join them in a single string.
$adminString = ($admins | ForEach-Object { ($_ -replace "localmachine\\", "$env:computername\") -replace "(.+)", '"$1"' } ) -join " " -replace '^\"(.+)\"', '$1'

"Liste: " + $adminString

$arrayFeatures = @($components, "Tools")
if ($reporting) { $arrayFeatures += "RS" } 
if ($analysis) { $arrayFeatures += "AS" }
if ($integration) { $arrayFeatures += "IS" }
if ($dataQualityClient) { $arrayFeatures += "DQC" }
if ($masterDataService) { $arrayFeatures += "MDS" }
if ($RServices) { $arrayFeatures += "AdvancedAnalytics" }
if ($PolyBase) { $arrayFeatures += "PolyBase" }

$features = "/Features=" + ($arrayFeatures -join ",")

$ASMode = if ($tabular) { "TABULAR" }else { "MULTIDIMENSIONAL" }



#download ssei, and download the iso or files
if ($installType -ne "completeAfterDeploy" ) {
    #Download SqlServer 2022 iso (dev or eval)
    if ($sqlEdition -eq "dev" -or $sqlEdition -eq "eval") {
        if ($sqlEdition -eq "dev") {
            $isofile = "SQLServer2022-x64-ENU-Dev.iso";
            $source = "https://go.microsoft.com/fwlink/?linkid=2215158"
        } 
        else {
            # "eval" 
            $isofile = "SQLServer2022-x64-ENU.iso";
            $source = "https://go.microsoft.com/fwlink/?linkid=2162123"
        }

        $SSEIFile = "$env:temp\sql2022.exe"

        #get link to latest version of CU (Cummulative Update) from download page
        $page = (Invoke-WebRequest "https://www.microsoft.com/en-us/download/confirmation.aspx?id=105013"  -UseBasicParsing).RawContent
        $page -match '{url:\"(.*?)\"'
        $cuSource = $matches[1]

        #create folder    
        New-Item -Path c:\ -Name sqlCU  -ItemType Directory -Force

        #download SQL Install in temp
        $wc = new-object System.Net.WebClient
        $wc.DownloadFile($Source, $SSEIFile)

        #download CU install in ISO Folder
        $wc.DownloadFile($cuSource, "c:\sqlCU\SQLServer2022-cu-x64.exe")
        $wc.Dispose()

        #Launch setup to download ISO Folder
        & $SSEIFile /action=download /mediapath=c:\sqlISO /mediatype=ISO language=en-US /Quiet | Out-Default
         
        #Get ISO path
        $isoFile2 = "c:\sqlISO\$isoFile";

        #Mount iso
        Mount-DiskImage $isoFile2
        $mountedVolume = Get-DiskImage -ImagePath $isoFile2 | Get-Volume
        $isoFileLetter = "$($mountedVolume.DriveLetter):"

        #Launch Setup
        $setupFile = "$isoFileletter\setup.exe"

    }
    else {
        #Download SqlServer 2022 Express


        $source = "https://go.microsoft.com/fwlink/?linkid=2216019"
        $SSEIFile = "$env:temp\sql2022.exe" 
    
        $wc = new-object System.Net.WebClient
        $wc.DownloadFile($Source, $SSEIFile)
        $wc.Dispose()


        & $SSEIFile   /action=download /mediapath=c:\sqlISO /mediatype=Core /language=en-US /quiet | Out-Default

        $setupFile = "c:\sqlISO\SQLEXPR_x64_ENU.exe"
        # $instanceName="SQLexpress"

    }
}


if ($installType -eq "normalInstall") {
    $pidString = if ([string]$prodid -ne '') { "/PID=`"$prodid`"" } else { "" }


    &  "$setupFile" /q `
        /Action=install `
        $features `
        /SuppressPrivacyStatementNotice `
        /IAcceptROpenLicenseTerms `
        /IAcceptSqlServerLicenseTerms `
        /InstanceName=$instanceName `
        /SqlSysAdminAccounts= $adminString `
        /AsSysAdminAccounts= $adminString `
        /AsServerMode=$ASMode `
        /SqlSvcInstantFileInit `
        /tcpEnabled=1 `
        /AgtSvcStartupType=automatic `
        /UpdateEnabled=true `
        /UpdateSource="c:\sqlCU" `
        $pidString `
    | Out-Default

    # &  "$setupFile" /q `
    #    /Action=uninstall `
    #    $features `
    #    /InstanceName=$instanceName `
    #    /SuppressPrivacyStatementNotice `
    #    /IAcceptROpenLicenseTerms `
    #    /IAcceptSqlServerLicenseTerms `
    #    $pidString `
    #    | Out-Default

}

if ($installType -eq "prepareBeforeImage") {
    & $setupFile   /q `
        /Action=PrepareImage `
        $features `
        /SuppressPrivacyStatementNotice `
        /IAcceptROpenLicenseTerms `
        /IAcceptSqlServerLicenseTerms `
        /SqlSvcInstantFileInit `
        /InstanceID=$instanceName `
        /UpdateEnabled=true `
        /UpdateSource="c:\sqlCU" `
    | Out-Default
}


if ($installType -eq "completeAfterDeploy") {
    if ([string]$prodid -ne '') { 
        $pidString = "/PID=`"$prodid`""
    }
    elseif ($sqlEdition -eq 'dev') {
        $pidString = "/PID=`"22222-00000-00000-00000-00000`""
    }
    else 
    { $pidString = "" }

    & "$env:programFiles\Microsoft SQL Server\160\Setup Bootstrap\SQLServer2022\setup.exe" /q `
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
        /AgtSvcStartupType=automatic `
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

if ($isoFile2) {
    Dismount-DiskImage $isoFile2
}

if ($keepISOFolder -eq $false) {
    Remove-Item -Path "C:\sqlISO" -recurse -force
    Remove-Item -Path "C:\sqlCU" -recurse -force
}



