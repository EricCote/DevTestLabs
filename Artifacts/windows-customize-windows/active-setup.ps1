
function Add-ActiveSetupScript {

    param ( 
        [Parameter(Position=0)]
        $ScriptName,
        [Parameter(Position=1)]
        $ScriptPath    
    )

    $null= mkdir C:\ProgramData\Active -force

    Copy-Item -Path $ScriptPath -Destination "C:\ProgramData\Active\$ScriptName.ps1"
  
    $activePath = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\$ScriptName"
    $null = mkdir $activePath -force
    Set-ItemProperty $activePath -name "(Default)"  -Value "$ScriptName"
    Set-ItemProperty $activePath -Name IsInstalled -Value 1
    Set-ItemProperty $activePath -Name StubPath -Value "cmd.exe /c `"start /min `"Script`" powershell C:\ProgramData\Active\$ScriptName.ps1 ^>c:\ProgramData\Active\out.txt`""
    Set-ItemProperty $activePath -Name Version -Value "1,0,0,0"
}


Add-ActiveSetupScript  "ShellScript"  ".\Modify-Shell.ps1"