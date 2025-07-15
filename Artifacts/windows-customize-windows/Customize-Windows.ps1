
[CmdletBinding()]
param(
    [switch] $RoundedCorners
    [string] $TimeZone
    [switch] $AdminUAC
)



#Set eastern time zone
tzutil /s "$TimeZone"

#disable new network popup.  All new networks are now considered "public"
new-Item HKLM:\System\CurrentControlSet\Control\Network\NewNetworkWindowOff -Force | out-null

# is this a serverOS?
$isServer = (Get-WmiObject  Win32_OperatingSystem).productType -gt 1
if ($isServer) {
    #enable sound
    Set-Service audiosrv -startuptype automatic  | out-null
    start-service audiosrv | out-null

    #disable server manager at login
    Get-ScheduledTask -TaskName "ServerManager" | Disable-ScheduledTask 
}

#Disable OneDrive Sync
mkdir 'HKLM:\Software\Policies\Microsoft\Windows\OneDrive' -Force | out-null
New-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Windows\OneDrive" -name "DisableFileSyncNGSC" -value 1 | out-null

#disable ie fist run popups
# mkdir 'HKLM:\Software\Microsoft\Internet Explorer\Main' -Force | out-null
# New-ItemProperty -path "HKLM:\Software\Microsoft\Internet Explorer\Main" -name "DisableFirstRunCustomize" -value 1 | Out-Null

# Edge: Stop nagging default browser 
# mkdir 'HKLM:\Software\Policies\Microsoft\Edge' -Force | out-null
# New-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Edge" -name  "DefaultBrowserSettingEnabled" -Value 0 | Out-Null

# Edge: hide first run popups 
# New-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Edge" -name "HideFirstRunExperience" -value 1 | Out-Null


# disable "Choose Privacy Settings for your device"
# Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" `
#                  -name "PrivacyConsentStatus" `
#                  -value 1


mkdir 'HKLM:\Software\Policies\Microsoft\Windows\OOBE' -Force | out-null
# disable "Choose Privacy Settings for your device"
Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" `
    -name "DisablePrivacyExperience" `
    -value 1 -Force | out-null


#The "skip oobe" is already provided by Azure scripting
# Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" `
#                  -name "SkipUserOOBE" `
#                  -value 1
# Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" `
#                  -name "SkipMachineOOBE" `
#                  -value 1


# Allow sideload of apps
Set-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Windows\Appx" `
    -name "AllowAllTrustedApps" `
    -value 1 `
    -force | out-null

#Enable Dev Mode
mkdir "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -force | Out-Null
Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" `
    -name "AllowDevelopmentWithoutDevLicense" `
    -value 1 `
    -force | out-null

# Set-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Windows\Appx" `
#     -name "AllowDevelopmentWithoutDevLicense" `
#     -value 1 `
#     -force | out-null


#enable UAC on Administrator account
if ($AdminUAC) {
    #mkdir "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -force | Out-Null
    Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
        -name "FilterAdministratorToken" `
        -value 1 `
        -force | out-null
    }


if ($RoundedCorners) {
    # enable rounded corners on Windows 11
    # mkdir "HKLM:\SOFTWARE\Microsoft\Windows\DWM" -force | Out-Null
    Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\DWM" `
        -name "ForceEffectMode" `
        -value 2 `
        -force | out-null
}

# overrides default file associations to chrome                 
# Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" `
#                  -name "DefaultAssociationsConfiguration" `
#                  -value "c:\windows\system32\OverrideAssociations.xml" `
#                  -force | out-null

# $xml =  @"
# <?xml version="1.0" encoding="UTF-8"?>
# <DefaultAssociations>
#   <Association Identifier="http" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
#   <Association Identifier="https" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
# </DefaultAssociations>
# "@      
# $xml | Out-File -Encoding utf8 -FilePath "c:\windows\system32\OverrideAssociations.xml"

$xml = Get-Content "C:\Windows\System32\OEMDefaultAssociations.xml"
$ids = @( ".htm", ".html", "http", "https")
$xml2 = $xml
# 
#$ids | ForEach-Object { $xml2 = $xml2.replace("Identifier=`"$_`" ProgId=`"MSEdgeHTM`" ApplicationName=`"Microsoft Edge`"", "Identifier=`"$_`" ProgId=`"FirefoxHTML-308046B0AF4A39CB`" ApplicationName=`"Firefox`"") }
$ids | ForEach-Object { $xml2 = $xml2.replace("Identifier=`"$_`" ProgId=`"MSEdgeHTM`" ApplicationName=`"Microsoft Edge`"", "Identifier=`"$_`" ProgId=`"ChromeHTML`" ApplicationName=`"Google Chrome`"") }
$xml2 | Out-File  "C:\Windows\System32\OEMDefaultAssociations.xml" -Encoding ascii


##################################
# work with default user registry
##################################
New-PSDrive HKU Registry HKEY_USERS | out-null
& REG LOAD "HKU\Default" "C:\Users\Default\NTUSER.DAT"  | out-null

# Show file extensions
New-ItemProperty -path "HKU:Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -name HideFileExt `
    -Value 0 -PropertyType dword `
    -Force | out-null

# Hide TaskView (win11)                  
New-ItemProperty -path "HKU:Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -name ShowTaskViewButton `
    -Value 0 -PropertyType dword `
    -Force | out-null   
                    
# Hide Chat     (win11)              
# New-ItemProperty -path "HKU:Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
#     -name TaskbarMn `
#     -Value 0 -PropertyType dword `
#     -Force | out-null   
                 
# more pins / less recommended  in start menu (win11, 22h2) 0=default, 1=more pins, 2=more recommendations
New-ItemProperty -path "HKU:Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -name Start_Layout `
    -Value 1 -PropertyType dword `
    -Force | out-null   
                 
# Terminal: Set default terminal to Windows Terminal
New-Item -path "HKU:Default\Console\%%Startup" -force | out-null

New-ItemProperty -path "HKU:Default\Console\%%Startup" `
    -name DelegationConsole `
    -Value "{2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69}" `
    -PropertyType string `
    -Force | out-null   

New-ItemProperty -path "HKU:Default\Console\%%Startup" `
    -name DelegationTerminal `
    -Value "{E12CFF52-A866-4C77-9A90-F570A7AA2C6B}" `
    -PropertyType string `
    -Force | out-null   
                     

#Create Registry key 
# New-Item "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Teams" `
#     -force | out-null

# #Remove Teams Startup
# New-ItemProperty -Path "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Teams" `
#     -Name "PreventFirstLaunchAfterInstall" `
#     -Value 1 -PropertyType dword `
#     -Force | out-null

# Hide Search 

# New-ItemProperty -path "HKU:Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
# -name SearchboxTaskbarMode `
# -Value 0 -PropertyType dword `
# -Force | out-null   

# Hide widgets  (win10/11)                 
# New-ItemProperty -path "HKU:Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
#     -name TaskbarDa `
#     -Value 0 -PropertyType dword `
#     -Force | out-null       


#Hide Widgets Workaround
#https://forums.mydigitallife.net/threads/taskbarda-widgets-registry-change-is-now-blocked.88547/page-2

set-location  c:\windows\system32

Copy-Item (Get-Command reg).Source ".\reg5.exe"
& ".\reg5.exe" add HKU\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarDa /t REG_DWORD /d 0 /f
& ".\reg5.exe" query HKU\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarDa
Remove-Item ".\reg5.exe"



#for explanation: https://stackoverflow.com/questions/25438409/reg-unload-and-new-key
Remove-PSDrive HKU 
[gc]::Collect()
[gc]::WaitForPendingFinalizers()

& REG UNLOAD "HKU\Default" | out-default


