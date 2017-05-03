

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


$sourceSqlLocalDb="https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SqlLocalDB.msi";
$SqlLocalDb=  "$env:temp\SqlLocalDB.msi"

$sourceOdbc = "https://download.microsoft.com/download/D/5/E/D5EEF288-A277-45C8-855B-8E2CB7E25B96/x64/msodbcsql.msi"
$odbc = "$env:temp\msodbcsql.msi"

$sourceCmdLineUtil = "https://download.microsoft.com/download/C/8/8/C88C2E51-8D23-4301-9F4B-64C8E2F163C5/Command%20Line%20Utilities%20MSI%20files/amd64/MsSqlCmdLnUtils.msi"
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

