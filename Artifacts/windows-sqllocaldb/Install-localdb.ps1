$ProgressPreference = 'SilentlyContinue'

# $sourceSqlLocalDb2017="https://download.microsoft.com/download/E/F/2/EF23C21D-7860-4F05-88CE-39AA114B014B/SqlLocalDB.msi";
# $sourceSqlLocalDb2019="https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SqlLocalDB.msi";
$sourceSqlLocalDb="https://download.microsoft.com/download/3/8/d/38de7036-2433-4207-8eae-06e247e17b25/SqlLocalDB.msi"
$SqlLocalDb=  "$env:temp\SqlLocalDB.msi"

# $sourceOdbc2016 = "https://download.microsoft.com/download/E/6/B/E6BFDC7A-5BCD-4C51-9912-635646DA801E/msodbcsql_17.1.0.1_x64.msi"
# $sourceOdbc2017 = "https://download.microsoft.com/download/6/b/3/6b3dd05c-678c-4e6b-b503-1d66e16ef23d/en-US/17.6.1.1/x64/msodbcsql.msi"
# $sourceOdbc2019="https://go.microsoft.com/fwlink/?linkid=2168524"
$sourceOdbc="https://go.microsoft.com/fwlink/?linkid=2249006"
$odbc = "$env:temp\msodbcsql.msi"


# $sourceCmdLineUtil2016 = "https://download.microsoft.com/download/C/8/8/C88C2E51-8D23-4301-9F4B-64C8E2F163C5/x64/MsSqlCmdLnUtils.msi"
# $sourceCmdLineUtil2017 = "https://download.microsoft.com/download/0/e/6/0e63d835-3513-45a0-9cf0-0bc75fb4269e/EN/x64/MsSqlCmdLnUtils.msi"
# $sourceCmdLineUtil2019 = "https://go.microsoft.com/fwlink/?linkid=2142258"
$sourceCmdLineUtil="https://go.microsoft.com/fwlink/?linkid=2230791"
$CmdLineUtil = "$env:temp\MsSqlCmdLnUtils.msi"

# $SourceOledb2019 = "https://go.microsoft.com/fwlink/?linkid=2164384"
$SourceOledb = "https://go.microsoft.com/fwlink/?linkid=2248728"
$OleDb = "$env:temp\MsOleDbSql.msi"


Invoke-WebRequest -UseBasicParsing -Uri  $sourceSqlLocalDb -OutFile $SqlLocalDb
Invoke-WebRequest -UseBasicParsing -Uri  $sourceOdbc -OutFile $odbc
Invoke-WebRequest -UseBasicParsing -Uri  $SourceOledb -OutFile $OleDb
Invoke-WebRequest -UseBasicParsing -Uri  $sourceCmdLineUtil -OutFile $CmdLineUtil

#Start-Process  "msiexec"  -argumentlist "/quiet /i ""$SqlLocalDb"" IACCEPTSQLLOCALDBLICENSETERMS=YES" -Wait 
#Start-Process  "msiexec"  -argumentlist "/quiet /i ""$odbc"" IACCEPTMSODBCSQLLICENSETERMS=YES" -Wait 
#Start-Process  "msiexec"  -argumentlist "/quiet /i ""$CmdLineUtil"" IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES" -Wait 

& msiexec /i "$SqlLocalDb" IACCEPTSQLLOCALDBLICENSETERMS=YES /quiet | out-default
& msiexec /i "$odbc" IACCEPTMSODBCSQLLICENSETERMS=YES /quiet | out-default
& msiexec /i "$OleDb" IACCEPTMSOLEDBSQLLICENSETERMS=YES /quiet | out-default
& msiexec /i "$CmdLineUtil" IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES /quiet | out-default


Remove-Item $SqlLocalDb
Remove-Item $odbc
Remove-Item $OleDb
Remove-Item $CmdLineUtil

