

######################################################################


$ErrorActionPreference = "Stop"

# Hide any progress bars, due to downloads and installs of remote components.
$ProgressPreference = "SilentlyContinue"

# Ensure we force use of TLS 1.2 for all downloads.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Discard any collected errors from a previous execution.
$Error.Clear()

# Allow certian operations, like downloading files, to execute.
Set-ExecutionPolicy Bypass -Scope Process -Force

###################################################################################################
#
# Functions used in this script.
#

function Get-TempPassword
{
    [CmdletBinding()]
    param(
        [int] $length = 43
    )

    $sourceData = $null
    33..126 | % { $sourceData +=,[char][byte]$_ }

    1..$length | % { $tempPassword += ($sourceData | Get-Random) }

    return $tempPassword
}

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
            # Ignore any errors, specially with locked folders/files. It will get cleaned up at a later time, when another artifact is installed.
        }
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

function install-Docker
{
    [CmdletBinding()]
    param(
        [string] $UserName,
        [string] $Password, 
        [string] $filename
    )

    $secPassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential("$env:COMPUTERNAME\$($UserName)", $secPassword)
    $content = @"
        & $filename install --quiet | out-default

"@



    $content | Out-File "c:\ProgramData\DockInstall\dock.ps1"

    

    $oldPolicyValue = Set-LocalAccountTokenFilterPolicy
    try
    {
        Invoke-Command -ComputerName $env:COMPUTERNAME -Credential $credential -FilePath "c:\ProgramData\DockInstall\dock.ps1"  | Out-Default
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


    # Validate-Params       #if password or username is specified, BOTH must be specified
    # Validate-Environment  #validate windows 10 version number

   # Ensure-PowerShell -Version $PSVersionRequired  #ensure version of powershell 3 or more

 #   Install-PackageProvider -Name NuGet -Force -ErrorAction SilentlyContinue | Out-Null  #add Nuget to use the next 2 lines
  #  Install-Module -Name DockerMsftProvider -Repository PSGallery -Force -ErrorAction SilentlyContinue | Out-Null
   # Install-Package -Name docker -ProviderName DockerMsftProvider -Force -ErrorAction SilentlyContinue | Out-Null


    Enable-WindowsOptionalFeature -Online -FeatureName containers -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

    Enable-PSRemoting -Force -SkipNetworkProfileCheck


    $ProgressPreference = "SilentlyContinue"
    $UserName = 'artifactInstaller'
    $Password = 'Allo12345678!'
    Add-LocalAdminUser -UserName $UserName -Password $password 

    New-Item -Path "c:\ProgramData" -Name "DockInstall" -ItemType Directory 

    $filename="c:\ProgramData\DockInstall\installDocker.exe"

    Invoke-WebRequest -uri "https://desktop.docker.com/win/stable/amd64/Docker%20Desktop%20Installer.exe" -UseBasicParsing -OutFile $filename
 
   
    # use the GA version of docker for windows and disable checksum checks (checksum is always outdated in the nuget package)
    Install-Docker -UserName $UserName -Password $Password -Filename $filename

    $dockerGroup = ([ADSI]"WinNT://$env:ComputerName/docker-users,group")
 
    if ($dockerGroup)
    {
        # grant local users to docker-desktop
        ([ADSI]"WinNT://$env:ComputerName").Children | ? { $_.SchemaClassName -eq 'user' } | % { try { $dockerGroup.add($_.Path) } catch {} }
    }

    Remove-LocalAdminUser -UserName $UserName

    Remove-Item -Path "c:\ProgramData\DockInstall" -Force





