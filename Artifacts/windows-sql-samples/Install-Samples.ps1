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
  [bool] $adventureWorks2016_EXT,
  [bool] $adventureWorksDW2016_EXT,
  [bool] $adventureWorks2017,
  [bool] $adventureWorksDW2017,
  [bool] $wideWorldImporters,
  [bool] $wideWorldImportersDW,
  [bool] $wideWorldInMemory, 
  [string] $instanceName,
  [string] $backupPath,
  [string] $samplePath,
  [bool] $downloadOnly,
  [bool] $setupOnly,
  [bool] $Uninstall
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
    $cmdpath=""
    if (test-path "C:\Program Files\Microsoft SQL Server\110\Tools\Binn\sqlcmd.exe")
    {$cmdpath="C:\Program Files\Microsoft SQL Server\110\Tools\Binn\sqlcmd.exe";}

    if (test-path "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\SQLCMD.EXE")
    {$cmdpath="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\SQLCMD.EXE";}

    if (test-path "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE")
    {$cmdpath="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE";}

    return $cmdpath;
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
    $editionString = Run-Sql $sqlName "SELECT SERVERPROPERTY ('edition') as x";
    
    if  (($editionString | Select-String '(\w+) Edition') -match  '(\w+) Edition' )
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



function DownloadInstall-Database   
{
  Param([parameter(Position=1)]
      [string] $db_name, 
      [parameter(Position=2)]
      [string] $url,
      [parameter(Position=3)]
      [string] $extrafileRestore
    )
     if($downloadFiles){
        "Downloading $db_name..."
         $DownloadedDest="$env:temp\$db_name.bak"
         Download-File $url  $DownloadedDest
         copy $DownloadedDest $backupPath
         del $DownloadedDest -ErrorAction SilentlyContinue  
     }
      if($setupFiles){
        $datafile= $db_name+"_data";
        $logfile=$db_name+"_log"

        "Installing $db_name..."
        $cmd="

        DROP DATABASE IF EXISTS $db_name;
        RESTORE DATABASE $db_name
            FROM DISK = '$backupPath\$db_name.bak'
        WITH   
            MOVE '$datafile' 
            TO '$samplePath\$dataFile.mdf', 
            $extrafileRestore
            MOVE '$logfile' 
            TO '$samplePath\$logfile.ldf';
        GO
    
        ALTER AUTHORIZATION ON DATABASE::$db_name TO sa;
        "

        run-sql $sqlName $cmd

        }
}

function Download-File
{
    Param([parameter(Position=1)]
      $Source, 
      [parameter(Position=2)]
      $Destination
    )

    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
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

    
if ([string]$samplePath -eq "")
{
    $samplePath= "C:\dbSamples"
}

if ([string]$backupPath -eq "")
{
    $backupPath= "C:\dbBackup"
}

New-Item -type directory -path $backupPath -InformationAction SilentlyContinue -ErrorAction SilentlyContinue
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
        Download-File  "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks2012/adventure-works-2012-oltp-lt-data-file.mdf" "$env:temp\AdventureWorksLT2012_Data.mdf"
        Copy-Item  -Path "$env:temp\AdventureWorksLT2012_Data.mdf" -Destination $backupPath
        del "$env:temp\AdventureWorksLT2012_Data.mdf" -ErrorAction SilentlyContinue
    }

    if ($setupFiles)
    {
        "Installing AdventureWorks LT 2012..."
              Copy-Item  -Path "$backupPath\AdventureWorksLT2012_Data.mdf" -Destination $samplePath
    
        $cmd="
        DROP DATABASE IF EXISTS AdventureWorksLT2012;
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
    DownloadInstall-Database "AdventureWorks2014" `
           "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2014.bak"   
}

###----------------------------------------------------

If($adventureWorksDW2014)
{
    DownloadInstall-Database "AdventureWorksDW2014" `
           "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2014.bak" 
    
}

###------------------------------------------------------
if ($adventureWorks2016)
{
    DownloadInstall-Database "AdventureWorks2016" `
           "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2016.bak" 
}

###------------------------------------------------------
If($adventureWorksDW2016)
{
  DownloadInstall-Database "AdventureWorksDW2016" `
           "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2016.bak"  
}




###------------------------------------------------------
if ($adventureWorks2016_EXT)
{
  DownloadInstall-Database "AdventureWorks2016_EXT" `
           "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2016_EXT.bak" `
            " MOVE 'AdventureWorks2016_EXT_mod' TO '$samplePath\AdventureWorks2016_mod', "
}
###----------------------------------------------------

If($adventureWorksDW2016_EXT)
{
  DownloadInstall-Database "AdventureWorksDW2016_EXT" `
           "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2016_EXT.bak" 
}


###----------------------------------------------------

if ($adventureWorks2017)
{
  DownloadInstall-Database "AdventureWorks2017" `
           "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak" 
}


###----------------------------------------------------


If($adventureWorksDW2017)
{
  DownloadInstall-Database "AdventureWorksDW2017" `
           "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2017.bak"  
}



$SqlFeature=if ($wideWorldInMemory)  {"Full"} else {"Standard"}
###-------------------------------------------------------------------------------
# Code to detect if we are using LocalDB, in which case we want
# to force the Standard version.  
if ($sqlname -ieq '(localdb)\MSSQLLocalDB')
{
    $SqlFeature="Standard"
}

   
if ($wideWorldImporters)
{
    if($downloadFiles){
        "Downloading Wide World Importers..."
        Download-File "https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-$SqlFeature.bak"    "$env:temp\WideWorldImporters-$SqlFeature.bak"

        Copy-Item  -Path "$env:temp\WideWorldImporters-*.bak" -Destination $backupPath

        del "$env:temp\WideWorldImporters*.bak" -ErrorAction SilentlyContinue
    }
    if($setupFiles){
        "Installing Wide World Importers..."
        $part=""
        if ($SqlFeature -eq "Full") 
        { $part = " MOVE 'WWI_InMemory_Data_1' TO '$samplePath\WWI_InMemory_Data_1', " };

        $cmd="
        DROP DATABASE IF EXISTS WideWorldImporters;
        RESTORE DATABASE WideWorldImporters
            FROM DISK = '$backupPath\WideWorldImporters-$SqlFeature.bak'
        WITH REPLACE,  
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

        Copy-Item "$env:temp\WideWorldImportersDW-*.bak" -Destination $backupPath
        del "$env:temp\WideWorldImportersDW-*.bak" -ErrorAction SilentlyContinue

    }
    if($setupFiles){
        "Installing Wide World Importers DW..."
        $part=""
        if ($SqlFeature -eq "Full") 
        {  $part =  " MOVE 'WWIDW_InMemory_Data_1' TO '$samplePath\WWIDW_InMemory_Data_1', "  };


        $cmd="
        DROP DATABASE IF EXISTS WideWorldImportersDW;
        RESTORE DATABASE WideWorldImportersDW
            FROM DISK = '$backupPath\WideWorldImportersDW-$SqlFeature.bak'
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
      DROP DATABASE IF EXISTS WideWorldImportersDW;
      DROP DATABASE IF EXISTS WideWorldImporters;
      DROP DATABASE IF EXISTS AdventureWorksLT2012;
      DROP DATABASE IF EXISTS AdventureWorksDW2014;
      DROP DATABASE IF EXISTS AdventureWorks2014;
      DROP DATABASE IF EXISTS AdventureWorksDW2016;
      DROP DATABASE IF EXISTS AdventureWorks2016;
      DROP DATABASE IF EXISTS AdventureWorksDW2016_EXT;
      DROP DATABASE IF EXISTS AdventureWorks2016_EXT;
      DROP DATABASE IF EXISTS AdventureWorksDW2017;
      DROP DATABASE IF EXISTS AdventureWorks2017;
      "
   run-sql $sqlName "SELECT Name FROM sys.databases"

   rd "C:\DbSamples" -Recurse 
}


 & "C:\Program Files\Microsoft SQL Server\130\Tools\Binn\SqlLocalDB.exe" stop

