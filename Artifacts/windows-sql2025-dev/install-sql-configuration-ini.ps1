﻿$prepare=@"
;SQL Server 2025 Configuration File
[OPTIONS]

; Specifies a Setup work flow, like INSTALL, UNINSTALL, or UPGRADE. This is a required parameter. 

ACTION="Install"

; Use the /ENU parameter to install the English version of SQL Server on your localized Windows operating system. 

ENU="True"

; Indicates whether the supplied product key is covered by Service Assurance. 

PRODUCTCOVEREDBYSA="False"

; Specifies that SQL Server Setup should not display the privacy statement when ran from the command line. 

SUPPRESSPRIVACYSTATEMENTNOTICE="False"

; Setup will not display any user interface. 

QUIET="False"

; Setup will display progress only, without any user interaction. 

QUIETSIMPLE="False"

; Parameter that controls the user interface behavior. Valid values are Normal for the full UI,AutoAdvance for a simplied UI, and EnableUIOnServerCore for bypassing Server Core setup GUI block. 

UIMODE="Normal"

; Specify whether SQL Server Setup should discover and include product updates. The valid values are True and False or 1 and 0. By default SQL Server Setup will include updates that are found. 

UpdateEnabled="True"

; If this parameter is provided, then this computer will use Microsoft Update to check for updates. 

USEMICROSOFTUPDATE="True"

; Specifies that SQL Server Setup should not display the paid edition notice when ran from the command line. 

SUPPRESSPAIDEDITIONNOTICE="False"

; Specify the location where SQL Server Setup will obtain product updates. The valid values are "MU" to search Microsoft Update, a valid folder path, a relative path such as .\MyUpdates or a UNC share. By default SQL Server Setup will search Microsoft Update or a Windows Update service through the Window Server Update Services. 

UpdateSource="MU"

; Specifies features to install, uninstall, or upgrade. The list of top-level features include SQL, AS, IS, DQ and MDS. The SQL feature will install the Database Engine, Replication, Full-Text, and Data Quality Services (DQS) server. 

FEATURES=SQLENGINE,REPLICATION,ADVANCEDANALYTICS,FULLTEXT,POLYBASECORE,AS,IS,IS_MASTER,IS_WORKER

; Displays the command line parameters usage. 

HELP="False"

; Specifies that the detailed Setup log should be piped to the console. 

INDICATEPROGRESS="False"

; Specify a default or named instance. MSSQLSERVER is the default instance for non-Express editions and SQLExpress for Express editions. This parameter is required when installing the SQL Server Database Engine (SQL), or Analysis Services (AS). 

INSTANCENAME="MSSQLSERVER"

; Specify the root installation directory for shared components.  This directory remains unchanged after shared components are already installed. 

INSTALLSHAREDDIR="C:\Program Files\Microsoft SQL Server"

; Specify the root installation directory for the WOW64 shared components.  This directory remains unchanged after WOW64 shared components are already installed. 

INSTALLSHAREDWOWDIR="C:\Program Files (x86)\Microsoft SQL Server"

; Specify the Instance ID for the SQL Server features you have specified. SQL Server directory structure, registry structure, and service names will incorporate the instance ID of the SQL Server instance. 

INSTANCEID="MSSQLSERVER"

; Account for SQL Server PolyBase Engine: Domain\User or system account. 

PBENGSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE"

; Startup type for the SQL Server PolyBase Engine. 

PBENGSVCSTARTUPTYPE="Automatic"

; Account for SQL Server PolyBase Data Movement Service: Domain\User or system account. 

PBDMSSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE"

; Startup type for the SQL Server PolyBase Data Movement Service. 

PBDMSSVCSTARTUPTYPE="Automatic"

; Port range for PolyBase Services (inclusive). 

PBPORTRANGE="16450-16460"

; Startup type for the SQL Server CEIP service. 

SQLTELSVCSTARTUPTYPE="Automatic"

; Account for SQL Server CEIP service: Domain\User or system account. 

SQLTELSVCACCT="NT Service\SQLTELEMETRY"

; Startup type for the SQL Server Analysis Services CEIP service. 

ASTELSVCSTARTUPTYPE="Automatic"

; Account for SQL Server Analysis Services CEIP service: Domain\User or system account. 

ASTELSVCACCT="NT Service\SSASTELEMETRY"

; Startup type for the SQL Server Integration Services CEIP service. 

ISTELSVCSTARTUPTYPE="Automatic"

; Account for SQL Server Integration Services CEIP service: Domain\User or system account. 

ISTELSVCACCT="NT Service\SSISTELEMETRY170"

; Specify the installation directory. 

INSTANCEDIR="C:\Program Files\Microsoft SQL Server"

; Agent account name. 

AGTSVCACCOUNT="NT Service\SQLSERVERAGENT"

; Auto-start service after installation.  

AGTSVCSTARTUPTYPE="Manual"

; Startup type for Integration Services. 

ISSVCSTARTUPTYPE="Automatic"

; Account for Integration Services: Domain\User or system account. 

ISSVCACCOUNT="NT Service\MsDtsServer170"

; Startup type for Integration Services Scale Out Master service. 

ISMASTERSVCSTARTUPTYPE="Automatic"

; Account for Integration Services Scale Out Master service: Domain\User or system account. 

ISMASTERSVCACCOUNT="NT Service\SSISScaleOutMaster170"

; Port for Integration Services Scale Out Master. 

ISMASTERSVCPORT="8391"

; The CNs in the certificate used to protect communication with Integration Services Scale Out Worker. 

ISMASTERSVCSSLCERTCN="CN=nrique001; CN=10.0.0.11"

; Startup type for Integration Services Scale Out Worker service. 

ISWORKERSVCSTARTUPTYPE="Automatic"

; Account for Integration Services Scale Out Worker service: Domain\User or system account. 

ISWORKERSVCACCOUNT="NT Service\SSISScaleOutWorker170"

; Master endpoint. 

ISWORKERSVCMASTER="https://nrique001:8391"

; The name of the account that the Analysis Services service runs under. 

ASSVCACCOUNT="NT Service\MSSQLServerOLAPService"

; Controls the service startup type setting after the service has been created. 

ASSVCSTARTUPTYPE="Automatic"

; The collation to be used by Analysis Services. 

ASCOLLATION="Latin1_General_CI_AS"

; The location for the Analysis Services data files. 

ASDATADIR="C:\Program Files\Microsoft SQL Server\MSAS17.MSSQLSERVER\OLAP\Data"

; The location for the Analysis Services log files. 

ASLOGDIR="C:\Program Files\Microsoft SQL Server\MSAS17.MSSQLSERVER\OLAP\Log"

; The location for the Analysis Services backup files. 

ASBACKUPDIR="C:\Program Files\Microsoft SQL Server\MSAS17.MSSQLSERVER\OLAP\Backup"

; The location for the Analysis Services temporary files. 

ASTEMPDIR="C:\Program Files\Microsoft SQL Server\MSAS17.MSSQLSERVER\OLAP\Temp"

; The location for the Analysis Services configuration files. 

ASCONFIGDIR="C:\Program Files\Microsoft SQL Server\MSAS17.MSSQLSERVER\OLAP\Config"

; Specifies whether or not the MSOLAP provider is allowed to run in process. 

ASPROVIDERMSOLAP="1"

; Specifies the list of administrator accounts that need to be provisioned. 

ASSYSADMINACCOUNTS="nrique001\afi"

; Specifies the server mode of the Analysis Services instance. Valid values are MULTIDIMENSIONAL and TABULAR. The default value is TABULAR. 

ASSERVERMODE="TABULAR"

; Startup type for the SQL Server service. 

SQLSVCSTARTUPTYPE="Automatic"

; Level to enable FILESTREAM feature at (0, 1, 2 or 3). 

FILESTREAMLEVEL="0"

; The max degree of parallelism (MAXDOP) server configuration option. 

SQLMAXDOP="4"

; Set to "1" to enable RANU for SQL Server Express. 

ENABLERANU="False"

; Specifies a Windows collation or an SQL collation to use for the Database Engine. 

SQLCOLLATION="SQL_Latin1_General_CP1_CI_AS"

; Account for SQL Server service: Domain\User or system account. 

SQLSVCACCOUNT="NT Service\MSSQLSERVER"

; Set to "True" to enable instant file initialization for SQL Server service. If enabled, Setup will grant Perform Volume Maintenance Task privilege to the Database Engine Service SID. This may lead to information disclosure as it could allow deleted content to be accessed by an unauthorized principal. 

SQLSVCINSTANTFILEINIT="False"

; Windows account(s) to provision as SQL Server system administrators. 

SQLSYSADMINACCOUNTS="nrique001\afi"

; The number of Database Engine TempDB files. 

SQLTEMPDBFILECOUNT="4"

; Specifies the initial size of a Database Engine TempDB data file in MB. 

SQLTEMPDBFILESIZE="8"

; Specifies the automatic growth increment of each Database Engine TempDB data file in MB. 

SQLTEMPDBFILEGROWTH="64"

; Specifies the initial size of the Database Engine TempDB log file in MB. 

SQLTEMPDBLOGFILESIZE="8"

; Specifies the automatic growth increment of the Database Engine TempDB log file in MB. 

SQLTEMPDBLOGFILEGROWTH="64"

; Provision current user as a Database Engine system administrator for SQL Server 2025 Express. 

ADDCURRENTUSERASSQLADMIN="False"

; Specify 0 to disable or 1 to enable the TCP/IP protocol. 

TCPENABLED="1"

; Specify 0 to disable or 1 to enable the Named Pipes protocol. 

NPENABLED="0"

; Startup type for Browser Service. 

BROWSERSVCSTARTUPTYPE="Disabled"

; User account for Launchpad Service. 

EXTSVCACCOUNT="NT Service\MSSQLLaunchpad"

; User account for Full-text Filter Daemon Host. 

FTSVCACCOUNT="NT Service\MSSQLFDLauncher"

; Use SQLMAXMEMORY to minimize the risk of the OS experiencing detrimental memory pressure. 

SQLMAXMEMORY="2147483647"

; Use SQLMINMEMORY to reserve a minimum amount of memory available to the SQL Server Memory Manager. 

SQLMINMEMORY="0"


"@

set-content "$env:temp\prepare.ini"  $prepare

& $isoFileletter\setup.exe /ConfigurationFile="$env:temp\prepare.ini"  | Out-Default