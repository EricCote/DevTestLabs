#$source = "http://go.microsoft.com/fwlink/?LinkID=799009"
#$dest =  "$env:userprofile\downloads\SQLServer2016-SSEI-Dev.exe"    

#& $dest /ConfigurationFile=C:\sqlsource\ConfigurationFile.ini  /iAcceptSqlServerLicenseTerms /mediaPath=c:\sqlSource /ENU


#Download SqlServer 2016 SP1
$source = "https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLServer2016SP1-FullSlipstream-x64-ENU-DEV.iso"
$isoFile =  "$env:temp\SQLServer2016SP1-FullSlipstream-x64-ENU-DEV.iso"    

$wc = new-object System.Net.WebClient
$wc.DownloadFile($Source,$isoFile)
$wc.Dispose()


#remove newer c++ redistribuable 
& "C:\ProgramData\Package Cache\{f1e7e313-06df-4c56-96a9-99fdfd149c51}\VC_redist.x64.exe"  /uninstall  /quiet    
& "C:\ProgramData\Package Cache\{c239cea1-d49e-4e16-8e87-8c055765f7ec}\VC_redist.x86.exe"  /uninstall  /quiet


Mount-DiskImage $isoFile
$mountedVolume = Get-DiskImage -ImagePath $isoFile | Get-Volume
$isoFileLetter = "$($mountedVolume.DriveLetter):"




$prepare=@"
;SQL Server 2016 Configuration File
[OPTIONS]

; Specifies a Setup work flow, like INSTALL, UNINSTALL, or UPGRADE. This is a required parameter. 

ACTION="PrepareImage"

IACCEPTSQLSERVERLICENSETERMS="True"

; Specifies that SQL Server Setup should not display the privacy statement when ran from the command line. 

SUPPRESSPRIVACYSTATEMENTNOTICE="True"

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

; Specify whether SQL Server Setup should discover and include product updates. The valid values are True and False or 1 and 0. By default SQL Server Setup will include updates that are found. 

UpdateEnabled="True"

; Specifies features to install, uninstall, or upgrade. The list of top-level features include SQL, AS, RS, IS, MDS, and Tools. The SQL feature will install the Database Engine, Replication, Full-Text, and Data Quality Services (DQS) server. The Tools feature will install shared components. 

FEATURES=SQLENGINE,REPLICATION,ADVANCEDANALYTICS,FULLTEXT,DQ,POLYBASE,AS,RS,SQL_SHARED_MR,DQC,CONN,IS,MDS

; Specify the location where SQL Server Setup will obtain product updates. The valid values are "MU" to search Microsoft Update, a valid folder path, a relative path such as .\MyUpdates or a UNC share. By default SQL Server Setup will search Microsoft Update or a Windows Update service through the Window Server Update Services. 

UpdateSource="MU"

; Displays the command line parameters usage 

HELP="False"

; Specifies that the detailed Setup log should be piped to the console. 

INDICATEPROGRESS="False"

; Specifies that Setup should install into WOW64. This command line argument is not supported on an IA64 or a 32-bit system. 

X86="False"

; Specify the root installation directory for shared components.  This directory remains unchanged after shared components are already installed. 

INSTALLSHAREDDIR="C:\Program Files\Microsoft SQL Server"

; Specify the root installation directory for the WOW64 shared components.  This directory remains unchanged after WOW64 shared components are already installed. 

INSTALLSHAREDWOWDIR="C:\Program Files (x86)\Microsoft SQL Server"

; Specify the Instance ID for the SQL Server features you have specified. SQL Server directory structure, registry structure, and service names will incorporate the instance ID of the SQL Server instance. 

INSTANCEID="MSSQLSERVER"

; Specify the installation directory. 

INSTANCEDIR="C:\Program Files\Microsoft SQL Server"

"@

set-content "$env:temp\prepare.ini"  $prepare

& $isoFileletter\setup.exe /ConfigurationFile="$env:temp\prepare.ini"  | Out-Default

Dismount-DiskImage $isoFile




