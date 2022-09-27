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




& "$env:programFiles\Microsoft SQL Server\150\Setup Bootstrap\SQL2019\setup.exe" /q `
                       /Action=uninstall `
                       /IAcceptSqlServerLicenseTerms `
                       /Features=SQL,AS,RS,IS,DQC,MDS,SQL_SHARED_MR,Tools `
                       /InstanceName=MSSQLSERVER | Out-default

uninstall-program "Microsoft SQL Server Management Studio*" 
uninstall-program "Azure Data Studio" 
& "C:\Program Files\Azure Data Studio\unins000.exe" /SILENT

uninstall-program "Microsoft Visual Studio Tools for Applications 2017" 
Uninstall-Program "Microsoft SQL Server 2019 T-SQL Language Service*"
Uninstall-Program "Microsoft MPI *"

Uninstall-Program "Microsoft ODBC Driver 17 for SQL Server"
Uninstall-Program "Microsoft OLE DB Driver for SQL Server"

uninstall-program "Microsoft Visual C++ 2017 Redistributable (x86)*"
uninstall-program "Microsoft Visual C++ 2017 Redistributable (x64)*"
uninstall-program "Microsoft Visual C++ 2013 Redistributable (x86)*"
uninstall-program "Microsoft Visual C++ 2013 Redistributable (x64)*" 

Uninstall-Program * -list

rd "C:\Program Files\Microsoft SQL Server" -recurse -force
rd "C:\Program Files (x86)\Microsoft SQL Server" -recurse -force
