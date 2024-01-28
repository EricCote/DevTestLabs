[CmdletBinding()]
param(
    [ValidateSet("test1","test2")] 
    [string] $MyString = 'test1',
    [switch] $MyFlag
)


$MyString | Out-Default
$MyFlag | Out-Default

# report languages

# $OSInfo = Get-WmiObject -Class Win32_OperatingSystem
# $OSInfo.MUILanguages

#----------------------------------------------------------


# Error of 23h2 images: Security center is not properly shown
# fix to install the proper version of security center:


$secLink='https://www.winhelponline.com/apps/SecurityHealthSetup.exe'
invoke-webrequest -UseBasicParsing  $secLink -OutFile $env:TEMP\securityhealthsetup.exe
& $env:TEMP\securityhealthsetup.exe

#----------------------------------------------------------


