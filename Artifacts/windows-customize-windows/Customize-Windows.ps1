
#Set eastern time zone
tzutil /s "Eastern Standard Time"


#disable new network popup.  All new networks are now considered "public"
new-Item HKLM:\System\CurrentControlSet\Control\Network\NewNetworkWindowOff



function Disable-IEESC{
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
}

$isServer=$isServer= (Get-WmiObject  Win32_OperatingSystem).productType -gt 1
if($isServer){
    #enable sound
    Set-Service audiosrv -startuptype automatic
    start-service audiosrv

    #Disable IE protection
    Disable-IEESC;
    #disable server manager at login
    Get-ScheduledTask -TaskName "ServerManager" | Disable-ScheduledTask
}

#Disable OneDrive Sync
mkdir 'HKLM:\Software\Policies\Microsoft\Windows\OneDrive' -Force
New-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Windows\OneDrive" -name "DisableFileSyncNGSC" -value 1;

#disable ie fist run popups
mkdir 'HKLM:\Software\Microsoft\Internet Explorer\Main' -Force
New-ItemProperty -path "HKLM:\Software\Microsoft\Internet Explorer\Main" -name "DisableFirstRunCustomize" -value 1;

# disable "Choose Privacy Settings for your device"
# Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" `
#                  -name "PrivacyConsentStatus" `
#                  -value 1

# disable "Choose Privacy Settings for your device"
Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" `
                 -name "DisablePrivacyExperience" `
                 -value 1

# set taskbar
mkdir c:\programData\script -Force
Copy-Item ./taskbar.xml c:\programData\script\taskbar.xml

Set-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Windows\Explorer" `
                 -name "LockedStartLayout" `
                 -value 1

Set-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Windows\Explorer" `
                 -name "StartLayoutFile" `
                 -value "C:\ProgramData\script\taskbar.xml"





##################################
# work with default user registry
##################################
New-PSDrive HKU Registry HKEY_USERS | out-null
& REG LOAD HKU\Default C:\Users\Default\NTUSER.DAT | out-null

# Show file extensions
        New-ItemProperty -path "HKU:Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
                         -name HideFileExt `
                         -Value 0 -PropertyType dword `
                         -Force | out-null

[gc]::Collect()

& REG UNLOAD HKU\Default | out-null
Remove-PSDrive HKU








