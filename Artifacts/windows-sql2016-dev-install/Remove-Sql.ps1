

function Uninstall-Program
{
    Param([parameter(Position=1)]
        $Name,
        [switch] $List
    )

    $programs = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*) + `
      (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*)  | `
      Select-Object DisplayName, UninstallString | `
      ? DisplayName -like $name ;

    if ($programs -eq $null) {
        return "No programs found with the name: " + $name;
    }

    if ($list) {
        return $programs;
    }
    else {
     
        $programs | `
        % -Process {  $unstr=$_.UninstallString.Replace("\Package Cache\","\Package_Cache\" ).Replace("  "," ") ;
                $items = ($unstr.split(" ",2));
                $items[0]= $items[0].Replace("\Package_Cache\","\Package Cache\" ).Replace("`"", "") ;
                $items[1]= $items[1].Replace("/I","/x"); 
                & ($items[0]) $items[1] /quiet | Out-Null;
        }

    }
 }




& "$env:programFiles\Microsoft SQL Server\130\Setup Bootstrap\SQLServer2016\setup.exe" /q `
                       /Action=uninstall `
                       /IAcceptSqlServerLicenseTerms `
                       /Features=SQL,AS,RS,IS,DQC,MDS,SQL_SHARED_MR,Tools `
                       /InstanceName=MSSQLSERVER | Out-default


uninstall-program "Microsoft Visual Studio Tools for Applications 2015 Language Support"  
uninstall-program "Microsoft Visual Studio Tools for Applications 2015" 

uninstall-program "Microsoft help viewer 1.1"

uninstall-program "Microsoft SQL Server Data-Tier Application Framework (x86)" 
uninstall-program "Microsoft SQL Server 2012 Native Client*" 
Uninstall-Program "Microsoft ODBC Driver 13 for SQL Server"
Uninstall-Program "Microsoft SQL Server 2016 T-SQL Language Service*"

uninstall-program "Microsoft MPI *" 

uninstall-program "Microsoft Visual C++ 2015 Redistributable (x86)*"
uninstall-program "Microsoft Visual C++ 2015 Redistributable (x64)*"
uninstall-program "Microsoft Visual C++ 2010  x86 Redistributable*"
uninstall-program "Microsoft Visual C++ 2010  x64 Redistributable*" 

Uninstall-Program * -list

rd "C:\Program Files\Microsoft SQL Server" -recurse -force
rd "C:\Program Files (x86)\Microsoft SQL Server" -recurse -force
rd "C:\Program Files (x86)\Microsoft Visual Studio 14.0" -recurse -force
