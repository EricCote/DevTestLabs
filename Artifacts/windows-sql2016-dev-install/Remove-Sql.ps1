﻿

$uninstall=@"

;SQL Server 2016 Configuration File
[OPTIONS]

; Specifies a Setup work flow, like INSTALL, UNINSTALL, or UPGRADE. This is a required parameter. 

ACTION="Uninstall"

IACCEPTSQLSERVERLICENSETERMS="True"

; Specifies that SQL Server Setup should not display the privacy statement when ran from the command line. 

SUPPRESSPRIVACYSTATEMENTNOTICE="True"

; Use the /ENU parameter to install the English version of SQL Server on your localized Windows operating system. 

ENU="False"

; Setup will not display any user interface. 

QUIET="True"

; Setup will display progress only, without any user interaction. 

QUIETSIMPLE="False"

; Parameter that controls the user interface behavior. Valid values are Normal for the full UI,AutoAdvance for a simplied UI, and EnableUIOnServerCore for bypassing Server Core setup GUI block. 

;UIMODE="Normal"

; Specifies features to install, uninstall, or upgrade. The list of top-level features include SQL, AS, RS, IS, MDS, and Tools. The SQL feature will install the Database Engine, Replication, Full-Text, and Data Quality Services (DQS) server. The Tools feature will install shared components. 

FEATURES=SQLENGINE,REPLICATION,ADVANCEDANALYTICS,FULLTEXT,DQ,POLYBASE,AS,RS,SQL_SHARED_MR,DQC,CONN,IS,MDS,Tools

; Displays the command line parameters usage 

HELP="False"

; Specifies that the detailed Setup log should be piped to the console. 

INDICATEPROGRESS="False"

; Specifies that Setup should install into WOW64. This command line argument is not supported on an IA64 or a 32-bit system. 

X86="False"

; Specify a default or named instance. MSSQLSERVER is the default instance for non-Express editions and SQLExpress for Express editions. This parameter is required when installing the SQL Server Database Engine (SQL), Analysis Services (AS), or Reporting Services (RS). 

INSTANCENAME="MSSQLSERVER"

"@;


Set-Content "$env:temp\uninstall.ini" $uninstall

& "$env:programFiles\Microsoft SQL Server\130\Setup Bootstrap\SQLServer2016\setup.exe" /ConfigurationFile="$env:temp\uninstall.ini"  | Out-Default



