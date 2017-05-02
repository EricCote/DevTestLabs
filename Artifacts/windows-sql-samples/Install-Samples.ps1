#https://download.microsoft.com/download/F/6/4/F6444AC3-ACF7-4024-BD31-3CACA2DA62DC/SQLServer2016CTP3Samples.zip
#https://download.microsoft.com/download/F/6/4/F6444AC3-ACF7-4024-BD31-3CACA2DA62DC/AdventureWorksDW2016CTP3.bak
#https://download.microsoft.com/download/F/6/4/F6444AC3-ACF7-4024-BD31-3CACA2DA62DC/AdventureWorks2016CTP3.bak


function detect-localdb 
{ 
  if ((Get-childItem -ErrorAction Ignore -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server Local DB\Installed Versions\").Length -gt 0) 
  {
   return $true
  } else { return $false }
}



function Get-ServerName
{
    $svr=""
    if((Get-ItemProperty -ErrorAction Ignore "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL\" ).MSSQLSERVER.Length -gt  0)
    { $svr="." }
    elseif  ((Get-childItem -ErrorAction Ignore -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server Local DB\Installed Versions\").Length -gt 0) 
    { $svr="(localdb)\MSSQLLocalDB" }

    return $svr
}



function Run-Sql
{
    param 
    (
        [parameter(position=1,mandatory=$true)] $sqlString
    )   

    $sqlcmd=""
    if (test-path "C:\Program Files\Microsoft SQL Server\110\Tools\Binn\sqlcmd.exe")
    {$sqlcmd="C:\Program Files\Microsoft SQL Server\110\Tools\Binn\sqlcmd.exe";};

    if (test-path "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\SQLCMD.EXE")
    {$sqlcmd="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\SQLCMD.EXE";};

    if (test-path "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE")
    {$sqlcmd="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE";};

    $svr=Get-ServerName

    return & $sqlcmd -S $svr -E -Q $SqlString
}

function Get-SqlEdition
{   
    $aString = Run-Sql "SELECT SERVERPROPERTY ('edition') as x";
    
    if  (($aString | Select-String '(\w+) Edition') -match  '(\w+) Edition' )
    {return $Matches[1];}

}

function Get-SqlYear
{
  
    $versionString = Run-Sql "SELECT @@Version";
   
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

if (Get-ServerName -neq '')
{

    if ((Get-ServerName) -eq '(localdb)\MSSQLLocalDB')
    {
        
        & "C:\Program Files\Microsoft SQL Server\130\Tools\Binn\SqlLocalDB.exe" start 
        & "C:\Program Files\Microsoft SQL Server\130\Tools\Binn\SqlLocalDB.exe" info mssqllocaldb  
    }

    #get codeplex-Version
    $codeplexVersion= Get-CodeplexVersion
     
    New-Item -type directory -path C:\aw -InformationAction SilentlyContinue -ErrorAction SilentlyContinue
    $Acl = Get-Acl "C:\aw"
    $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("BUILTIN\Users","FullControl","ContainerInherit,ObjectInherit","None","Allow")
    $Acl.AddAccessRule($ar)
    Set-Acl "C:\aw" $Acl

    add-type -AssemblyName System.IO.Compression.FileSystem



    ###-------------------------------------------------------------------------------

    if($AwLt)
    {
        "Downloading AdventureWorks LT 2012..."

        $FileNameAWLT2012 = Join-path $dl "AdventureWorksLT2012_Data.mdf";
        Download-File  "http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=msftdbprodsamples&DownloadId=354847&FileTime=129764108568330000&Build=$codeplexVersion" $FileNameAWLT2012
        Copy-Item  -Path $FileNameAWLT2012 -Destination 'c:\aw\'


        "Installing AdventureWorks LT 2012..."
        $cmd="
        CREATE DATABASE AdventureWorksLT2012 ON 
        ( FILENAME = N'C:\aw\AdventureWorksLT2012_Data.mdf' )
         FOR ATTACH_REBUILD_LOG  ;
        GO
        ALTER AUTHORIZATION ON DATABASE::AdventureWorksLT2012 TO sa;
        "

        run-sql $cmd
        del $FileNameAWLT2012 -ErrorAction SilentlyContinue
    
    }

    ###------------------------------------------------------
    if ($Aw)
    {
        "Downloading AdventureWorks 2014..."
        $FileNameAW2014=Join-path $dl  "Adventure Works 2014 Full Database Backup.zip"
        Download-File "http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=msftdbprodsamples&DownloadId=880661&FileTime=130507138100830000&Build=$codeplexVersion" $FileNameAW2014


        [system.io.compression.zipFile]::ExtractToDirectory($FileNameAW2014,'c:\aw\')

        "Installing AdventureWorks 2014..."
        $cmd="
        RESTORE DATABASE AdventureWorks2014
          FROM DISK = 'C:\AW\AdventureWorks2014.bak'
        WITH   
          MOVE 'AdventureWorks2014_Data' 
          TO 'C:\AW\AdventureWorks_data.mdf', 
          MOVE 'AdventureWorks2014_Log' 
          TO 'C:\AW\AdventureWorks_log.ldf';
        GO
    
        ALTER AUTHORIZATION ON DATABASE::AdventureWorks2014 TO sa;
        "

        run-sql $cmd
    
        del $FileNameAW2014 -ErrorAction SilentlyContinue
    }

    ###----------------------------------------------------

    If($AwDw)
    {
        "Downloading AdventureWorks DW 2014..."
        $FileNameAWDW2014=Join-path $dl  "Adventure Works DW 2014 Full Database Backup.zip"

        Download-File "http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=msftdbprodsamples&DownloadId=880664&FileTime=130511246406570000&Build=$codeplexVersion" $FileNameAWDW2014


        add-type -AssemblyName System.IO.Compression.FileSystem
        [system.io.compression.zipFile]::ExtractToDirectory($FileNameAWDW2014,'c:\aw\')


        "Installing AdventureWorks DW 2014..."

        $cmd="
        RESTORE DATABASE AdventureWorksDW2014
          FROM DISK = 'C:\AW\AdventureWorksDW2014.bak'
        WITH   
          MOVE 'AdventureWorksDW2014_Data' 
          TO 'C:\AW\AdventureWorksDW_data.mdf', 
          MOVE 'AdventureWorksDW2014_Log' 
          TO 'C:\AW\AdventureWorksDW_log.ldf';
        GO
    
        ALTER AUTHORIZATION ON DATABASE::AdventureWorksDW2014 TO sa;
        "
        
        run-sql $cmd

        del $FileNameAWDW2014 -ErrorAction SilentlyContinue
    }


    ###-------------------------------------------------------------------------------
    # Code to detect if we are using the full version of wwi (with in memory databases)
    # or the Standard version.
   
   
    $SqlFeature="Full"
    if ((Get-ServerName) -eq '(localdb)\MSSQLLocalDB')
    {
        $SqlFeature="Standard"
    }
    #pre-sp1 version could only do in-memory databases with enterprise or dev edition
    # $SqlFeature="Standard"
    # if(("Enterprise","Developer") -contains (Get-SqlEdition))
    # { $SqlFeature="Full" }
   
    if ($Wwi)
    {
        "Downloading Wide World Importers..."
        Download-File ("https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-" + $SqlFeature + ".bak")  (Join-path $dl  ("WideWorldImporters-$SqlFeature.bak"))

        Copy-Item  -Path (Join-path $dl  "WideWorldImporters-*.bak") -Destination 'c:\aw\'

        "Installing Wide World Importers..."
        $part=""
        if ($SqlFeature -eq "Full") 
        {  $part = " MOVE 'WWI_InMemory_Data_1' TO 'c:\AW\WideWorldImporters_InMemory_Data_1', " };

        $cmd="
        RESTORE DATABASE WideWorldImporters
          FROM DISK = 'C:\AW\WideWorldImporters-$SqlFeature.bak'
        WITH   
          MOVE 'WWI_Primary' 
          TO 'C:\AW\WideWorldImporters.mdf', 
          MOVE 'WWI_UserData' 
          TO 'C:\AW\WideWorldImporters_UserData.ndf',
           $part
          MOVE 'WWI_Log' 
          TO 'C:\AW\WideWorldImporters.ldf';
        GO
        ALTER AUTHORIZATION ON DATABASE::WideWorldImporters TO sa;
        "

        Run-Sql $cmd

        del (Join-path $dl  "WideWorldImporters*.bak") -ErrorAction SilentlyContinue
    }

    ###-------------------------------------------------------------------------------


    if($WwiDw)
    {
        "Downloading Wide World Importers..."
        Download-File "https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImportersDW-$SqlFeature.bak" (Join-path $dl "WideWorldImportersDW-$SqlFeature.bak")


        Copy-Item  -Path (Join-path $dl  "WideWorldImportersDW-*.bak") -Destination 'c:\aw\'


        "Installing Wide World Importers..."
        $part=""
        if ($SqlFeature -eq "Full") 
        {  $part =  " MOVE 'WWIDW_InMemory_Data_1' TO 'c:\AW\WideWorldImportersDW_InMemory_Data_1', "  };


        $cmd="
        RESTORE DATABASE WideWorldImportersDW
          FROM DISK = 'C:\AW\WideWorldImportersDW-$SqlFeature.bak'
        WITH   
          MOVE 'WWI_Primary' 
          TO 'C:\AW\WideWorldImportersDW.mdf', 
          MOVE 'WWI_UserData' 
          TO 'C:\AW\WideWorldImportersDW_UserData.ndf',
          $part 
          MOVE 'WWI_Log' 
          TO 'C:\AW\WideWorldImportersDW.ldf';
        GO
        ALTER AUTHORIZATION ON DATABASE::WideWorldImportersDW TO sa;
        "

        run-sql $cmd

        del (Join-path $dl  "WideWorldImporters*.bak") -ErrorAction SilentlyContinue
    }

}
else
{
    "No SQL Server detected!"
}

if ($Uninstall)
{
    run-sql "
      DROP DATABASE WideWorldImportersDW;
      DROP DATABASE WideWorldImporters;
      DROP DATABASE AdventureWorksLT2012;
      DROP DATABASE AdventureWorksDW2014;
      DROP DATABASE AdventureWorks2014;
      "
    
    rd c:\aw -Recurse 
}
