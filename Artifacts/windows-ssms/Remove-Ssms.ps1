
function Uninstall-Program {
    Param([parameter(Position = 1)]
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
            % -Process { $unstr = $_.UninstallString.Replace("\Package Cache\", "\Package_Cache\" ).Replace("  ", " ") ;
            $items = ($unstr.split(" ", 2));
            $items[0] = $items[0].Replace("\Package_Cache\", "\Package Cache\" ).Replace("`"", "") ;
            $items[1] = $items[1].Replace("/I", "/x");
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


# Comma-separated list of individual components. See <a href='https://learn.microsoft.com/en-us/ssms/install/workload-component-ids'>Reference</a> 
#         <br /><br/>


# Install all workloads? Or install a few from a list? 
#         <br /><br/>
#         <dl>
#         <dt>Select Below</dt>  
#           <dd>Installs specific workloads from the \"Workload List\" (see below)</dd> 
#         <dt>All Workloads</dt>  
#           <dd>Installs all workloads with the basic required components</dd> 
#         <dt>All with Recommended</dt>  
#           <dd>Installs all workloads with recommended components</dd> 
#         <dt>All with Optional</dt>  
#           <dd>Installs all workloads with optional components</dd> 
#         <dt>All with Recommended and Optional</dt>  
#           <dd>Installs all workloads with recommended and optional components</dd>   
#         <dt>Complete</dt>  
#           <dd>Installs all workloads with all components, including unaffiliated components</dd> 
#         </dl>



# Comma-separated list of workloads. See <a href='https://learn.microsoft.com/en-us/ssms/install/workload-component-ids'>Reference</a>  <br />
#       <br />Use a suffix to include additional components:
#       <br /> 
#       [+
#     ] include recommended,
#     [*
#     ] include optional,
#     [+*
#     ] include recommended and optional 
#       <br />  <br />
#       Ex: AI+,BI+,HybridAndMigration+
#       <br />  <br />
#        <br />  <br />
#       <dl>
#       <dt>AI</dt>  
#         <dd>AI-powered assistants</dd>  
#       <dt>BI</dt>  
#         <dd>Business intelligence, Analytics, Integration, Reports</dd>  
#       <dt>CodeTools</dt>  
#         <dd>Tools to help with code (Git, Query Hint)</dd>  
#       <dt>HybridAndMigration</dt>  
#         <dd>Assess database upgrade readiness, and move your data with ease.</dd>  
#       </dl>



#  <br />
#       <dl>
#       <dt>cs-CZ</dt>  
#         <dd>Czech</dd>
#       <dt>de-DE</dt>  
#         <dd>German</dd>
#       <dt>en-US</dt>  
#         <dd>English</dd>
#       <dt>es-ES</dt>  
#         <dd>Spanish</dd>
#       <dt>fr-FR</dt>  
#         <dd>French</dd>
#       <dt>it-IT</dt>  
#         <dd>Italian</dd>
#       <dt>ja-JP</dt>  
#         <dd>Japanese</dd>
#       <dt>ko-KR</dt>  
#         <dd>Korean</dd>
#       <dt>pl-PL</dt>  
#         <dd>Polish</dd>
#       <dt>pt-BR</dt>  
#         <dd>Portuguese - Brazil</dd>
#       <dt>ru-RU</dt>  
#         <dd>Russian</dd>
#       <dt>tr-TR</dt>  
#         <dd>Turkish</dd>
#       <dt>zh-CN</dt>  
#         <dd>Chinese - Simplified</dd>
#       <dt>zh-TW</dt>  
#         <dd>Chinese - Traditional</dd>
#       </dl>

#  <br />Use a suffix to include additional components:
#       <br /> 
#       [+
#       ] include recommended,
#       [*
#       ] include optional,
#       [+*
#       ] include recommended and optional 
#       <br />  <br />
#       Ex: AI+,BI+,HybridAndMigration+
#       <br />  <br />
#       <dl>
#       <dt>AI</dt>  
#         <dd>AI-powered assistants</dd>  
#       <dt>BI</dt>  
#         <dd>Business intelligence, Analytics, Integration, Reports</dd>  
#       <dt>CodeTools</dt>  
#         <dd>Tools to help with code (Git, Query Hint)</dd>  
#       <dt>HybridAndMigration</dt>  
#         <dd>Assess database upgrade readiness, and move your data with ease.</dd>  
#       </dl>
      