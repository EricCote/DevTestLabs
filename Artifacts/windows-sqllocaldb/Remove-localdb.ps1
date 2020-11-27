
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

#-----------------------------------------------------------------------------------

Uninstall-Program "Microsoft SQL Server 2019 LocalDB "
Uninstall-Program "Microsoft Command Line Utilities 15 for SQL Server" 
Uninstall-Program "Microsoft ODBC Driver 17 for SQL Server"
Uninstall-Program "Microsoft Visual C++ 2015-2019 Redistributable (x64) - 14.28.29325"


rd "C:\Program Files\Microsoft SQL Server" -recurse -force
 
