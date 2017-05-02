#https://download.microsoft.com/download/F/6/4/F6444AC3-ACF7-4024-BD31-3CACA2DA62DC/SQLServer2016CTP3Samples.zip
#https://download.microsoft.com/download/F/6/4/F6444AC3-ACF7-4024-BD31-3CACA2DA62DC/AdventureWorksDW2016CTP3.bak
#https://download.microsoft.com/download/F/6/4/F6444AC3-ACF7-4024-BD31-3CACA2DA62DC/AdventureWorks2016CTP3.bak


param
(
  [bool] $adventureWorksLT2012,
  [bool] $adventureWorks2014,
  [bool] $adventureWorksDW2014,
  [bool] $adventureWorks2016,
  [bool] $adventureWorksDW2016,
  [bool] $wideWorldImporters,
  [bool] $wideWorldImportersDW,
  [bool] $wideWorldInMemory, 
  [bool] $setupOnly,
  [bool] $downloadOnly,
  [string] $instanceName,
  [string] $backupPath,
  [string] $samplePath
)

$downloadFiles = if($setupOnly){$false} else {$true}
$setupFiles= if($downloadOnly){$false} else {$true}


#not used
function detect-localdb 
{ 
  if ((Get-childItem -ErrorAction Ignore  `
       -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server Local DB\Installed Versions\").Length -gt 0) 
  { return $true; } else { return $false; }
}



function Get-ServerName
{
    Param([parameter(Position=1)]
      [string] $instanceName
    )

    $svr=""
    if ($instanceName -eq "")
    {
        if((Get-ItemProperty -ErrorAction Ignore `
            -path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL\").MSSQLSERVER.Length -gt  0)
        { $svr="." ;}
        elseif  ((Get-childItem -ErrorAction Ignore `
            -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server Local DB\Installed Versions\").Length -gt 0) 
        { $svr="(localdb)\MSSQLLocalDB"; }
    }
    elseif ($instanceName -notmatch "\\")
    {
        $svr=".\$instanceName";
    }
    else 
    {   $svr=$instanceName   }
    return $svr;
}



function Get-SqlCmdPath
{
    $path=""
    if (test-path "C:\Program Files\Microsoft SQL Server\110\Tools\Binn\sqlcmd.exe")
    {$path="C:\Program Files\Microsoft SQL Server\110\Tools\Binn\sqlcmd.exe";}

    if (test-path "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\SQLCMD.EXE")
    {$path="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\SQLCMD.EXE";}

    if (test-path "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE")
    {$path="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE";}

    return $path;
}



function Run-Sql
{
    param 
    (
         [parameter(position=1,mandatory=$true)] $svr
        ,[parameter(position=2,mandatory=$true)] $sqlString
    )   

    return & $sqlcmd -S $svr -E -Q $SqlString;
}

function Get-SqlEdition
{   
    $aString = Run-Sql $sqlName "SELECT SERVERPROPERTY ('edition') as x";
    
    if  (($aString | Select-String '(\w+) Edition') -match  '(\w+) Edition' )
    {return $Matches[1];}

}

function Get-SqlYear
{
    $versionString = Run-Sql $sqlName "SELECT @@Version";
   
    if (($versionString  | Select-String 'Microsoft SQL Server (\d+)') -match  'Microsoft SQL Server (\d+)' )
    {
        return [int]::Parse($Matches[1]);
    }
    else 
    {
        return 0
    }
}

function Get-codeplexVersion
{
   $response= Invoke-WebRequest -UseBasicParsing -uri "http://www.codeplex.com/";
   if ($response.RawContent -match "<li>Version \d+\.\d+\.\d+\.(\d+)</li>")
   {   return $Matches[1]; };
}

function Download-File
{
    Param([parameter(Position=1)]
      $Source, 
      [parameter(Position=2)]
      $Destination
    )

    $wc = new-object System.Net.WebClient
    $wc.DownloadFile($Source,$Destination)
    $wc.Dispose()
}


#----------------------------------------------------------


$sqlcmd=Get-SqlCmdPath
$sqlName=Get-ServerName $instanceName

if ($sqlName -eq "")
{return "No SQL Server Detected";}

if ($sqlName -match "(localdb)")
{
    & "C:\Program Files\Microsoft SQL Server\130\Tools\Binn\SqlLocalDB.exe" start 
    # & "C:\Program Files\Microsoft SQL Server\130\Tools\Binn\SqlLocalDB.exe" info mssqllocaldb  
}

#get codeplex-Version
$codeplexVersion= Get-CodeplexVersion
    
if ($samplePath -eq "")
{
    $samplePath= "C:\aw"
}
New-Item -type directory -path $samplePath -InformationAction SilentlyContinue -ErrorAction SilentlyContinue
$Acl = Get-Acl $samplePath
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("BUILTIN\Users","FullControl","ContainerInherit,ObjectInherit","None","Allow")
$Acl.AddAccessRule($ar)
Set-Acl $samplePath $Acl

add-type -AssemblyName System.IO.Compression.FileSystem


###-------------------------------------------------------------------------------

if($adventureWorksLT2012)
{
    if ($downloadFiles)
    {
        "Downloading AdventureWorks LT 2012..."
        Download-File  "http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=msftdbprodsamples&DownloadId=354847&FileTime=129764108568330000&Build=$codeplexVersion" "$env:temp\AdventureWorksLT2012_Data.mdf"
        Copy-Item  -Path "$env:temp\AdventureWorksLT2012_Data.mdf" -Destination $samplePath
        del "$env:temp\AdventureWorksLT2012_Data.mdf" -ErrorAction SilentlyContinue
    }

    if ($setupFiles)
    {
        "Installing AdventureWorks LT 2012..."
        $cmd="
        CREATE DATABASE AdventureWorksLT2012 ON 
        ( FILENAME = N'$samplePath\AdventureWorksLT2012_Data.mdf' )
            FOR ATTACH_REBUILD_LOG  ;
        GO
        ALTER AUTHORIZATION ON DATABASE::AdventureWorksLT2012 TO sa;
        "
        
        run-sql $sqlName $cmd

    }
}

###------------------------------------------------------
if ($adventureWorks2014)
{
    if($downloadFiles){

        "Downloading AdventureWorks 2014..."
      
        $FileNameAW2014="$env:temp\Adventure Works 2014 Full Database Backup.zip"
        Download-File "http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=msftdbprodsamples&DownloadId=880661&FileTime=130507138100830000&Build=$codeplexVersion"  $FileNameAW2014

        [system.io.compression.zipFile]::ExtractToDirectory($FileNameAW2014,$samplePath)
        del $FileNameAW2014 -ErrorAction SilentlyContinue
    }

    if($setupFiles){
        "Installing AdventureWorks 2014..."
        $cmd="
        RESTORE DATABASE AdventureWorks2014
            FROM DISK = '$samplePath\AdventureWorks2014.bak'
        WITH   
            MOVE 'AdventureWorks2014_Data' 
            TO '$samplePath\AdventureWorks_data.mdf', 
            MOVE 'AdventureWorks2014_Log' 
            TO '$samplePath\AdventureWorks_log.ldf';
        GO
    
        ALTER AUTHORIZATION ON DATABASE::AdventureWorks2014 TO sa;
        "

        run-sql $sqlName $cmd
    
    }
}

    ###----------------------------------------------------

If($adventureWorksDW2014)
{
    if($downloadFiles){
        "Downloading AdventureWorks DW 2014..."
        $FileNameAWDW2014="$env:temp\Adventure Works DW 2014 Full Database Backup.zip"

        Download-File "http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=msftdbprodsamples&DownloadId=880664&FileTime=130511246406570000&Build=$codeplexVersion" $FileNameAWDW2014

        [system.io.compression.zipFile]::ExtractToDirectory($FileNameAWDW2014,$samplePath)
        del $FileNameAWDW2014 -ErrorAction SilentlyContinue
    }

    if($setupFiles){
        "Installing AdventureWorks DW 2014..."

        $cmd="
        RESTORE DATABASE AdventureWorksDW2014
            FROM DISK = '$samplePath\AdventureWorksDW2014.bak'
        WITH   
            MOVE 'AdventureWorksDW2014_Data' 
            TO '$samplePath\AdventureWorksDW_data.mdf', 
            MOVE 'AdventureWorksDW2014_Log' 
            TO '$samplePath\AdventureWorksDW_log.ldf';
        GO
    
        ALTER AUTHORIZATION ON DATABASE::AdventureWorksDW2014 TO sa;
        "
        
        run-sql $sqlName $cmd
    }
}


###------------------------------------------------------
if ($adventureWorks2016)
{
    if($downloadFiles){

        "Downloading AdventureWorks 2016 CTP3..."
      
        $FileNameAW2016="$env:temp\AdventureWorks2016CTP3.bak"
        Download-File "https://download.microsoft.com/download/F/6/4/F6444AC3-ACF7-4024-BD31-3CACA2DA62DC/AdventureWorks2016CTP3.bak"  $FileNameAW2016
        copy $FileNameAW2016 $samplePath
        del $FileNameAW2016 -ErrorAction SilentlyContinue
    }

    if($setupFiles){
        "Installing AdventureWorks 2016 CTP3..."
        $cmd="
        RESTORE DATABASE AdventureWorks2016CTP3
            FROM DISK = '$samplePath\AdventureWorks2016CTP3.bak'
        WITH   
            MOVE 'AdventureWorks2016CTP3_Data' 
            TO '$samplePath\AdventureWorks2016_data.mdf',
            MOVE 'AdventureWorks2016CTP3_mod'
            TO '$samplePath\AdventureWorks2016_mod',
            MOVE 'AdventureWorks2016CTP3_Log' 
            TO '$samplePath\AdventureWorks2016_log.ldf';
        GO
    
        ALTER AUTHORIZATION ON DATABASE::AdventureWorks2016CTP3 TO sa;
        "

        run-sql $sqlName $cmd
    
    }
}

    ###----------------------------------------------------

If($adventureWorksDW2016)
{
    if($downloadFiles){
        "Downloading AdventureWorks DW 2016..."
        $FileNameAWDW2016="$env:temp\AdventureWorksDW2016CTP3.bak"

        Download-File "https://download.microsoft.com/download/F/6/4/F6444AC3-ACF7-4024-BD31-3CACA2DA62DC/AdventureWorksDW2016CTP3.bak" $FileNameAWDW2016
        copy $FileNameAWDW2016 $samplePath
        del $FileNameAWDW2016 -ErrorAction SilentlyContinue
    }


    if($setupFiles){
        "Installing AdventureWorks DW 2016..."

        $cmd="
        RESTORE DATABASE AdventureWorksDW2016CTP3
            FROM DISK = '$samplePath\AdventureWorksDW2016CTP3.bak'
        WITH   
            MOVE 'AdventureWorksDW2014_Data' 
            TO '$samplePath\AdventureWorksDW2016_data.mdf', 
            MOVE 'AdventureWorksDW2014_Log' 
            TO '$samplePath\AdventureWorksDW2016_log.ldf';
        GO
    
        ALTER AUTHORIZATION ON DATABASE::AdventureWorksDW2016CTP3 TO sa;
        "
        
        run-sql $sqlName $cmd
    }
}

   
   
$SqlFeature=if ($wideWorldInMemory)  {"Full"} else {"Standard"}
###-------------------------------------------------------------------------------
# Code to detect if we are using the full version of wwi (with in memory databases)
# or the Standard version.  Not necessary with sp1
#if ((Get-ServerName) -eq '(localdb)\MSSQLLocalDB')
#{
#    $SqlFeature="Standard"
#}
#pre-sp1 version could only do in-memory databases with enterprise or dev edition
# $SqlFeature="Standard"
# if(("Enterprise","Developer") -contains (Get-SqlEdition))
# { $SqlFeature="Full" }
   
if ($wideWorldImporters)
{
    if($downloadFiles){
        "Downloading Wide World Importers..."
        Download-File ("https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-$SqlFeature.bak")    "$env:temp\WideWorldImporters-$SqlFeature.bak"

        Copy-Item  -Path "$env:temp\WideWorldImporters-*.bak" -Destination $samplePath

        del "$env:temp\WideWorldImporters*.bak" -ErrorAction SilentlyContinue
    }
    if($setupFiles){
        "Installing Wide World Importers..."
        $part=""
        if ($SqlFeature -eq "Full") 
        { $part = " MOVE 'WWI_InMemory_Data_1' TO '$samplePath\WideWorldImporters_InMemory_Data_1', " };

        $cmd="
        RESTORE DATABASE WideWorldImporters
            FROM DISK = '$samplePath\WideWorldImporters-$SqlFeature.bak'
        WITH   
            MOVE 'WWI_Primary' 
            TO '$samplePath\WideWorldImporters.mdf', 
            MOVE 'WWI_UserData' 
            TO '$samplePath\WideWorldImporters_UserData.ndf',
            $part
            MOVE 'WWI_Log' 
            TO '$samplePath\WideWorldImporters.ldf';
        GO
        ALTER AUTHORIZATION ON DATABASE::WideWorldImporters TO sa;
        "

        Run-Sql $sqlName $cmd
    }

}

###-------------------------------------------------------------------------------


if($wideWorldImportersDW)
{
    if($downloadFiles) {
        "Downloading Wide World Importers DW..."
        Download-File "https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImportersDW-$SqlFeature.bak" "$env:temp\WideWorldImportersDW-$SqlFeature.bak"

        Copy-Item "$env:temp\WideWorldImportersDW-*.bak" -Destination $samplePath
        del "$env:temp\WideWorldImportersDW-*.bak" -ErrorAction SilentlyContinue

    }
    if($setupFiles){
        "Installing Wide World Importers DW..."
        $part=""
        if ($SqlFeature -eq "Full") 
        {  $part =  " MOVE 'WWIDW_InMemory_Data_1' TO '$samplePath\WideWorldImportersDW_InMemory_Data_1', "  };


        $cmd="
        RESTORE DATABASE WideWorldImportersDW
            FROM DISK = '$samplePath\WideWorldImportersDW-$SqlFeature.bak'
        WITH   
            MOVE 'WWI_Primary' 
            TO '$samplePath\WideWorldImportersDW.mdf', 
            MOVE 'WWI_UserData' 
            TO '$samplePath\WideWorldImportersDW_UserData.ndf',
            $part 
            MOVE 'WWI_Log' 
            TO '$samplePath\WideWorldImportersDW.ldf';
        GO
        ALTER AUTHORIZATION ON DATABASE::WideWorldImportersDW TO sa;
        "

        run-sql $sqlName $cmd
    }
        
}



if ($Uninstall)
{
    run-sql $sqlName "
      DROP DATABASE WideWorldImportersDW;
      DROP DATABASE WideWorldImporters;
      DROP DATABASE AdventureWorksLT2012;
      DROP DATABASE AdventureWorksDW2014;
      DROP DATABASE AdventureWorks2014;
      DROP DATABASE AdventureWorksDW2016CTP3;
      DROP DATABASE AdventureWorks2016CTP3;
      "
    
    rd c:\aw -Recurse 
}


