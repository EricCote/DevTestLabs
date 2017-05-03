
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



uninstall-program "Microsoft SQL Server Data Tools - Visual Studio 2015" 
uninstall-program "Microsoft SQL Server Data Tools - enu*"
uninstall-program "SSDT" 
uninstall-program "Prerequisites for SSDT*" 

uninstall-program "Microsoft Visual Studio 2015 Shell (Integrated)" 
uninstall-program "Microsoft Visual Studio 2015 Shell (Isolated)" 

uninstall-program "Microsoft SQL Server 2016 Management Objects*" 
uninstall-program "Microsoft SQL Server 2014 Management Objects*"

uninstall-program "Microsoft Help Viewer 2.2"

uninstall-program "Microsoft System CLR Types for SQL Server *"
Uninstall-Program "Active Directory Authentication Library for SQL Server"
uninstall-program "Microsoft SQL Server 2016 T-SQL ScriptDom*"
Uninstall-Program "Microsoft SQL Server 2016 LocalDB*"

uninstall-program "Microsoft Visual Studio Tools for Applications 2015 Language Support"  
uninstall-program "Microsoft Visual Studio Tools for Applications 2015" 


uninstall-program "Microsoft AS OLE DB Provider for SQL Server vNext CTP2.0"  
uninstall-program "Microsoft SQL Server  vNext  Analysis Management Objects CTP2.0" 
uninstall-program "Microsoft SQL Server  vNext  ADOMD.NET CTP2.0"
uninstall-program "Microsoft SQL Server 2012 Native Client*"
 

#Uninstall-Program "IIS Express Application Compatibility Database for x64"
#Uninstall-Program "IIS Express Application Compatibility Database for x86"
#C:\Windows\system32\sdbinst.exe -u "C:\Windows\AppPatch\Custom\{ad846bae-d44b-4722-abad-f7420e08bcd9}.sdb" -q
#C:\Windows\system32\sdbinst.exe -u "C:\Windows\AppPatch\Custom\Custom64\{08274920-8908-45c2-9258-8ad67ff77b09}.sdb" -q


uninstall-program "Microsoft Visual C++ 2013 Redistributable (x86)*"
uninstall-program "Microsoft Visual C++ 2013 Redistributable (x64)*"

uninstall-program "Microsoft Visual C++ 2015 Redistributable (x86)*"
uninstall-program "Microsoft Visual C++ 2015 Redistributable (x64)*"

uninstall-program "Microsoft Visual C++ 2010  x86 Redistributable - *"

Uninstall-Program * -list

rd "C:\Program Files\Microsoft SQL Server" -recurse -force
rd "C:\Program Files (x86)\Microsoft SQL Server" -recurse -force
rd "C:\Program Files (x86)\Microsoft Visual Studio 14.0" -recurse -force
