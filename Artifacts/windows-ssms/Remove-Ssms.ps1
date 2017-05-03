
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
                "$($items[0]) $($items[1]) /quiet" 
                & ($items[0]) $items[1] /quiet | Out-default;
        }

    }
}





#$ssms= "$env:Temp\SSMS-setup-enu.exe"
#& $ssms /uninstall /quiet | Out-Null

#$ssdt= "$env:Temp\SSDTSetup.exe"
#& $ssdt /uninstall /quiet | Out-Null


uninstall-program "*Data tools for*"  -list

uninstall-program "*Data tools*" -list
uninstall-program "*ssdt*"  -list
uninstall-program "Microsoft Visual Studio 2015 Shell (Integrated)" -list

#-----------------------------------------------------------------------------------

uninstall-program "Microsoft SQL Server Management Studio*" 
uninstall-program "Microsoft Visual Studio 2015 Shell (Isolated)" 

uninstall-program "Microsoft Visual Studio Tools for Applications 2015 Language Support"
uninstall-program "Microsoft Visual Studio Tools for Applications 2015"

uninstall-program "Microsoft Help Viewer 2.2"
uninstall-program "Microsoft SQL Server 2014 Management Objects*" 
uninstall-program "Microsoft System CLR Types for SQL Server 2014"
Uninstall-Program "Active Directory Authentication Library for SQL Server"
Uninstall-Program "Microsoft SQL Server Data-Tier Application Framework (x86)"

uninstall-program "Microsoft Visual C++ 2013 Redistributable (x86)*"
uninstall-program "Microsoft Visual C++ 2013 Redistributable (x64)*"
uninstall-program "Microsoft Visual C++ 2015 Redistributable (x86)*"
uninstall-program "Microsoft Visual C++ 2015 Redistributable (x64)*"
#--------------------------------------------------------------------------
#uninstall-program "Microsoft Visual C++ 2010  x86 Redistributable*"
#uninstall-program "Microsoft Visual C++ 2010  x64 Redistributable*" 


#rd "C:\Program Files\Microsoft SQL Server" -recurse -force
#rd "C:\Program Files (x86)\Microsoft SQL Server" -recurse -force
rd "C:\Program Files (x86)\Microsoft Visual Studio 14.0" -recurse -force


