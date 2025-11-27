 
Param
(
    [string] $sqlEdition = "dev", #3 values possible: eval, dev, express
    [string] $installType = "normalInstall", #3 values possible: normalInstall, prepareBeforeImage, completeAfterDeploy
    [string] $components = "SQL",
    [string] $instanceName = "MSSQLSERVER",
    [array]  $admins = @("localmachine\afi", "NT AUTHORITY\SYSTEM"),
    [string] [AllowEmptyString()] $prodid = "",
    [switch]   $Replication = $false,	
    [switch]   $RPython = $false,
    [switch]   $FullText = $false,
    [switch]   $PolyBase = $false,
    [switch]   $Analysis = $false,
    [switch]   $Tabular = $false,
    [switch]   $Integration = $false,
    [switch]   $KeepISOFolder = $false


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

$arrayFeatures = @($components)

if ($Replication) { $arrayFeatures += "Replication" } 
if ($RPython) { $arrayFeatures += "AdvancedAnalytics" }
if ($FullText) { $arrayFeatures += "FullText" } 
if ($PolyBase) { $arrayFeatures += "PolyBaseCore" }
if ($Analysis) { $arrayFeatures += "AS" }
if ($Integration) { $arrayFeatures += "IS" }

$features = "/Features=" + ($arrayFeatures -join ",")

$ASMode = if ($tabular) { "TABULAR" }else { "MULTIDIMENSIONAL" }


#download ssei, and download the iso or files
if ($installType -ne "completeAfterDeploy" ) {
    #Download SqlServer 2022 iso (dev or eval)
    if ($sqlEdition -eq "dev" -or $sqlEdition -eq "eval") {
        if ($sqlEdition -eq "dev") {
            $isofile = "SQLServer2025-x64-ENU-Dev.iso";
            $source = "https://go.microsoft.com/fwlink/?linkid=2342429"
        } 
        else {
            # "eval" 
            $isofile = "SQLServer2025-x64-ENU.iso";
            $source = "https://go.microsoft.com/fwlink/?linkid=2342429"
        }

        $SSEIFile = "$env:temp\sql2025.exe"

        Invoke-WebRequest -Uri $source -OutFile $SSEIFile -UseBasicParsing 

        
        # #get link to latest version of CU (Cummulative Update) from download page
        # $page = (Invoke-WebRequest "https://www.microsoft.com/en-us/download/details.aspx?id=105013"  -UseBasicParsing).RawContent
        # $page -match '\"url\":\"(.*?)\"'
        # $cuSource = $matches[1]

        # #create folder    
        # New-Item -Path c:\ -Name sqlCU  -ItemType Directory -Force

        # #download SQL Install in temp
        # $wc = new-object System.Net.WebClient
        # $wc.DownloadFile($Source, $SSEIFile)

        # #download CU install in ISO Folder
        # $wc.DownloadFile($cuSource, "c:\sqlCU\SQLServer2022-cu-x64.exe")
        # $wc.Dispose()

        #Launch setup to download ISO Folder
        & $SSEIFile /action=download /mediapath=c:\sqlISO /mediatype=ISO /language=en-US /Quiet | Out-Default
         
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
        /IAcceptSqlServerLicenseTerms `
        /InstanceName=$instanceName `
        /SqlSysAdminAccounts= $adminString `
        /AsSysAdminAccounts= $adminString `
        /AsServerMode=$ASMode `
        /SqlSvcInstantFileInit `
        /tcpEnabled=1 `
        /AgtSvcStartupType=automatic `
        /UpdateEnabled=true `
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



 
