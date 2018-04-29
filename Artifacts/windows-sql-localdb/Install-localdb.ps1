
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


$sourceSqlLocalDb="https://download.microsoft.com/download/E/F/2/EF23C21D-7860-4F05-88CE-39AA114B014B/SqlLocalDB.msi";
$SqlLocalDb=  "$env:temp\SqlLocalDB.msi"

$sourceOdbc = "https://download.microsoft.com/download/E/6/B/E6BFDC7A-5BCD-4C51-9912-635646DA801E/msodbcsql_17.1.0.1_x64.msi"
$odbc = "$env:temp\msodbcsql.msi"

$sourceCmdLineUtil = "https://download.microsoft.com/download/C/8/8/C88C2E51-8D23-4301-9F4B-64C8E2F163C5/x64/MsSqlCmdLnUtils.msi"
$CmdLineUtil = "$env:temp\MsSqlCmdLnUtils.msi"

Download-File $sourceSqlLocalDb $SqlLocalDb
Download-File $sourceOdbc $odbc
Download-File $sourceCmdLineUtil $CmdLineUtil

#Start-Process  "msiexec"  -argumentlist "/quiet /i ""$SqlLocalDb"" IACCEPTSQLLOCALDBLICENSETERMS=YES" -Wait 
#Start-Process  "msiexec"  -argumentlist "/quiet /i ""$odbc"" IACCEPTMSODBCSQLLICENSETERMS=YES" -Wait 
#Start-Process  "msiexec"  -argumentlist "/quiet /i ""$CmdLineUtil"" IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES" -Wait 

& msiexec /i "$SqlLocalDb" IACCEPTSQLLOCALDBLICENSETERMS=YES /quiet | out-default
& msiexec /i "$odbc" IACCEPTMSODBCSQLLICENSETERMS=YES /quiet | out-default
& msiexec /i "$CmdLineUtil" IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES /quiet | out-default


del $SqlLocalDb
del $odbc
del $CmdLineUtil

