

$saPassword="afi12345!"
$saPassword


$complete= @"
;SQL Server 2016 Configuration File
[OPTIONS]

; Specifies a Setup work flow, like INSTALL, UNINSTALL, or UPGRADE. This is a required parameter. 

ACTION="CompleteImage"

;----

IACCEPTSQLSERVERLICENSETERMS="True"

; Specifies that SQL Server Setup should not display the privacy statement when ran from the command line. 

SUPPRESSPRIVACYSTATEMENTNOTICE="False"

; By specifying this parameter and accepting Microsoft R Open and Microsoft R Server terms, you acknowledge that you have read and understood the terms of use. 

IACCEPTROPENLICENSETERMS="True"

; Use the /ENU parameter to install the English version of SQL Server on your localized Windows operating system. 

ENU="True"

; Setup will not display any user interface. 

QUIET="True"

; Setup will display progress only, without any user interaction. 

QUIETSIMPLE="False"

; Parameter that controls the user interface behavior. Valid values are Normal for the full UI,AutoAdvance for a simplied UI, and EnableUIOnServerCore for bypassing Server Core setup GUI block. 

;UIMODE="Normal"

; If this parameter is provided, then this computer will use Microsoft Update to check for updates. 

USEMICROSOFTUPDATE="True"

; Displays the command line parameters usage 

HELP="False"

; Specifies that the detailed Setup log should be piped to the console. 

INDICATEPROGRESS="False"

; Specifies that Setup should install into WOW64. This command line argument is not supported on an IA64 or a 32-bit system. 

X86="False"

; Specify a default or named instance. MSSQLSERVER is the default instance for non-Express editions and SQLExpress for Express editions. This parameter is required when installing the SQL Server Database Engine (SQL), Analysis Services (AS), or Reporting Services (RS). 

INSTANCENAME="MSSQLSERVER"

; Specify the Instance ID for the SQL Server features you have specified. SQL Server directory structure, registry structure, and service names will incorporate the instance ID of the SQL Server instance. 

INSTANCEID="MSSQLSERVER"

; Specifies which mode report server is installed in.  
; Default value: “FilesOnly”  

RSINSTALLMODE="DefaultNativeMode"

; PolybasePdwUserNameConfigDescription 

PBENGSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE"

; PolybasePdwStartupConfigDescription 

PBENGSVCSTARTUPTYPE="Automatic"

; PolybaseDmsUserNameConfigDescription 

PBDMSSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE"

; PolybaseDmsStartupConfigDescription 

PBDMSSVCSTARTUPTYPE="Automatic"

; PolybaseScaleOutDescription 

PBSCALEOUT="False"

; PolybasePortRangeDescription 

PBPORTRANGE="16450-16460"

; TelemetryUserNameConfigDescription 

SQLTELSVCACCT="NT Service\SQLTELEMETRY"

; TelemetryStartupConfigDescription 

SQLTELSVCSTARTUPTYPE="Automatic"

; ASTelemetryStartupConfigDescription 

ASTELSVCSTARTUPTYPE="Automatic"

; ASTelemetryUserNameConfigDescription 

ASTELSVCACCT="NT Service\SSASTELEMETRY"

; TelemetryStartupConfigDescription 

ISTELSVCSTARTUPTYPE="Automatic"

; TelemetryUserNameConfigDescription 

ISTELSVCACCT="NT Service\SSISTELEMETRY130"

; Agent account name 

AGTSVCACCOUNT="NT Service\SQLSERVERAGENT"

; Auto-start service after installation.  

AGTSVCSTARTUPTYPE="Manual"

; Startup type for Integration Services. 

ISSVCSTARTUPTYPE="Automatic"

; Account for Integration Services: Domain\User or system account. 

ISSVCACCOUNT="NT Service\MsDtsServer130"

; The name of the account that the Analysis Services service runs under. 

ASSVCACCOUNT="NT Service\MSSQLServerOLAPService"

; Controls the service startup type setting after the service has been created. 

ASSVCSTARTUPTYPE="Automatic"

; The collation to be used by Analysis Services. 

ASCOLLATION="Latin1_General_CI_AS"

; The location for the Analysis Services data files. 

ASDATADIR="C:\Program Files\Microsoft SQL Server\MSAS13.MSSQLSERVER\OLAP\Data"

; The location for the Analysis Services log files. 

ASLOGDIR="C:\Program Files\Microsoft SQL Server\MSAS13.MSSQLSERVER\OLAP\Log"

; The location for the Analysis Services backup files. 

ASBACKUPDIR="C:\Program Files\Microsoft SQL Server\MSAS13.MSSQLSERVER\OLAP\Backup"

; The location for the Analysis Services temporary files. 

ASTEMPDIR="C:\Program Files\Microsoft SQL Server\MSAS13.MSSQLSERVER\OLAP\Temp"

; The location for the Analysis Services configuration files. 

ASCONFIGDIR="C:\Program Files\Microsoft SQL Server\MSAS13.MSSQLSERVER\OLAP\Config"

; Specifies whether or not the MSOLAP provider is allowed to run in process. 

ASPROVIDERMSOLAP="1"

; Specifies the list of administrator accounts that need to be provisioned. 

;ASSYSADMINACCOUNTS="$env:computername\afi"

; Specifies the server mode of the Analysis Services instance. Valid values are MULTIDIMENSIONAL and TABULAR. The default value is MULTIDIMENSIONAL. 

ASSERVERMODE="TABULAR"

; Startup type for the SQL Server service. 

SQLSVCSTARTUPTYPE="Automatic"

; Level to enable FILESTREAM feature at (0, 1, 2 or 3). 

FILESTREAMLEVEL="0"

; Set to "1" to enable RANU for SQL Server Express. 

ENABLERANU="False"

; Specifies a Windows collation or an SQL collation to use for the Database Engine. 

SQLCOLLATION="SQL_Latin1_General_CP1_CI_AS"

; Account for SQL Server service: Domain\User or system account. 

SQLSVCACCOUNT="NT Service\MSSQLSERVER"

; Set to "True" to enable instant file initialization for SQL Server service. If enabled, Setup will grant Perform Volume Maintenance Task privilege to the Database Engine Service SID. This may lead to information disclosure as it could allow deleted content to be accessed by an unauthorized principal. 

SQLSVCINSTANTFILEINIT="True"

; Windows account(s) to provision as SQL Server system administrators. 

;SQLSYSADMINACCOUNTS="$env:computername\afi" "NT AUTHORITY\SYSTEM" 

; The number of Database Engine TempDB files. 

SQLTEMPDBFILECOUNT="2"

; Specifies the initial size of a Database Engine TempDB data file in MB. 

SQLTEMPDBFILESIZE="8"

; Specifies the automatic growth increment of each Database Engine TempDB data file in MB. 

SQLTEMPDBFILEGROWTH="64"

; Specifies the initial size of the Database Engine TempDB log file in MB. 

SQLTEMPDBLOGFILESIZE="8"

; Specifies the automatic growth increment of the Database Engine TempDB log file in MB. 

SQLTEMPDBLOGFILEGROWTH="64"

; Provision current user as a Database Engine system administrator for %SQL_PRODUCT_SHORT_NAME% Express. 

ADDCURRENTUSERASSQLADMIN="False"

; Specify 0 to disable or 1 to enable the TCP/IP protocol. 

TCPENABLED="0"

; Specify 0 to disable or 1 to enable the Named Pipes protocol. 

NPENABLED="0"

; Startup type for Browser Service. 

BROWSERSVCSTARTUPTYPE="Disabled"

; Specifies which account the report server NT service should execute under.  When omitted or when the value is empty string, the default built-in account for the current operating system.
; The username part of RSSVCACCOUNT is a maximum of 20 characters long and
; The domain part of RSSVCACCOUNT is a maximum of 254 characters long. 

RSSVCACCOUNT="NT Service\ReportServer"

; Specifies how the startup mode of the report server NT service.  When 
; Manual - Service startup is manual mode (default).
; Automatic - Service startup is automatic mode.
; Disabled - Service is disabled 

RSSVCSTARTUPTYPE="Automatic"

; Add description of input argument EXTSVCACCOUNT 

EXTSVCACCOUNT="NT Service\MSSQLLaunchpad"

; Add description of input argument FTSVCACCOUNT 

FTSVCACCOUNT="NT Service\MSSQLFDLauncher"

PID="22222-00000-00000-00000-00000"

"@;

set-content "$env:temp\complete.ini"  $complete

& "$env:programFiles\Microsoft SQL Server\130\Setup Bootstrap\SQLServer2016\setup.exe" `
           /ConfigurationFile="$env:temp\complete.ini"  `
           /SAPWD="$saPassword" `
           /SqlSysAdminAccounts="$env:computername\afi" "NT AUTHORITY\SYSTEM" `
           /AsSysAdminAccounts="$env:computername\afi" `
           /iAcceptSqlServerLicenseTerms | Out-Default


