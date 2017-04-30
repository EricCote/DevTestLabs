(
  [string] $userlogin
)


$user="$env:computerName\$userlogin"

if ($userlogin -eq "" -or $userlogin -eq "0" ) 
{
    $user="BUILTIN\Users"
}


& "$env:programFiles\Microsoft SQL Server\130\Setup Bootstrap\SQLServer2016\setup.exe" /q `
                       /Action=CompleteImage `
                       /SuppressPrivacyStatementNotice `
                       /IAcceptROpenLicenseTerms `
                       /IAcceptSqlServerLicenseTerms `
                       /InstanceName=MSSQLSERVER `
                       /InstanceID=MSSQLSERVER `
                       /RsInstallMode="DefaultNativeMode" `
                       /AsSysAdminAccounts="$user" `
                       /AsServerMode="TABULAR" `
                       /SqlSvcInstantFileInit `
                       /SqlSysAdminAccounts="$user" "NT AUTHORITY\SYSTEM"  `
                       /PID="22222-00000-00000-00000-00000" `
                       | Out-Default


                      