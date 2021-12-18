
function Add-LocalAdminUser
{
    [CmdletBinding()]
    param(
        [string] $UserName,
        [string] $Password,
        [string] $Description = 'DevTestLab artifact installer',
        [switch] $Overwrite = $true
    )

    if ($Overwrite)
    {
        Remove-LocalAdminUser -UserName $UserName
    }

    $computer = [ADSI]"WinNT://$env:ComputerName"
    $user = $computer.Create("User", $UserName)
    $user.SetPassword($Password)
    $user.Put("Description", $Description)
    $user.SetInfo()

    $group = [ADSI]"WinNT://$env:ComputerName/Administrators,group"
    $group.add("WinNT://$env:ComputerName/$UserName")

    return $user
}

function Remove-LocalAdminUser
{
    [CmdletBinding()]
    param(
        [string] $UserName
    )

    if ([ADSI]::Exists('WinNT://./' + $UserName))
    {
        $computer = [ADSI]"WinNT://$env:ComputerName"
        $computer.Delete('User', $UserName)
        try
        {
            gwmi win32_userprofile | ? { $_.LocalPath -like "*$UserName*" -and -not $_.Loaded } | % { $_.Delete() }
        }
        catch
        {
            "Errors removing user..."
            # Ignore any errors, specially with locked folders/files. It will get cleaned up at a later time, when another artifact is installed.
        }
        "User removed!"
    }
}

function Set-LocalAccountTokenFilterPolicy
{
    [CmdletBinding()]
    param(
        [int] $Value = 1
    )

    $oldValue = 0

    $regPath ='HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
    $policy = Get-ItemProperty -Path $regPath -Name LocalAccountTokenFilterPolicy -ErrorAction SilentlyContinue

    if ($policy)
    {
        $oldValue = $policy.LocalAccountTokenFilterPolicy
    }

    if ($oldValue -ne $Value)
    {
        Set-ItemProperty -Path $regPath -Name LocalAccountTokenFilterPolicy -Value $Value
    }

    return $oldValue
}

function Invoke-Update
{
    [CmdletBinding()]
    param(
        [string] $UserName,
        [string] $Password
    )

    $secPassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential("$env:COMPUTERNAME\$($UserName)", $secPassword)
    $content = @"
    whoami | Out-File -FilePath "c:\ProgramData\temp\out.txt";
    (Get-WmiObject `
       -Namespace "root\cimv2\mdm\dmmap" `
       -Class "MDM_EnterpriseModernAppManagement_AppManagement01" `
    ).UpdateScanMethod() | Out-File -FilePath "c:\ProgramData\temp\out.txt" -append;
    Start-Sleep -s 240;
    "Waited 4 minutes" |  Out-File -FilePath "c:\ProgramData\temp\out.txt" -append;
"@


    $content | Out-File "c:\ProgramData\temp\update.ps1" 

    $oldPolicyValue = Set-LocalAccountTokenFilterPolicy
    try
    {
        Invoke-Command -ComputerName $env:COMPUTERNAME -Credential $credential -FilePath "c:\ProgramData\temp\update.ps1"  | Out-Default
    }
    finally
    {
        Set-LocalAccountTokenFilterPolicy -Value $oldPolicyValue | Out-Null
    }
}

###################################################################################################
#
# Main execution block.
#


    Enable-PSRemoting -Force -SkipNetworkProfileCheck

    $ProgressPreference = "SilentlyContinue"
    $UserName = 'SpecialEricUser'
    $Password = 'Allo12345678!'
    Add-LocalAdminUser -UserName $UserName -Password $password 

    New-Item -Path "c:\ProgramData" -Name "temp" -ItemType Directory 



    Invoke-Update -UserName $UserName -Password $Password

    # $dockerGroup = ([ADSI]"WinNT://$env:ComputerName/docker-users,group")
 
    # if ($dockerGroup)
    # {
    #     # grant local users to docker-desktop
    #     ([ADSI]"WinNT://$env:ComputerName").Children | ? { $_.SchemaClassName -eq 'user' } | % { try { $dockerGroup.add($_.Path) } catch {} }
    # }

    Remove-LocalAdminUser -UserName $UserName

   # Remove-Item -Path "c:\ProgramData\DockInstall" -Force -Recurse


