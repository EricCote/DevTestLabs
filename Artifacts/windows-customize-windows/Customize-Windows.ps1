
#Set eastern time zone
tzutil /s "Eastern Standard Time"

#disable new network popup.  All new networks are now considered "public"
new-Item HKLM:\System\CurrentControlSet\Control\Network\NewNetworkWindowOff -Force | out-null

# is this a serverOS?
$isServer= (Get-WmiObject  Win32_OperatingSystem).productType -gt 1
if($isServer){
    #enable sound
    Set-Service audiosrv -startuptype automatic  | out-null
    start-service audiosrv | out-null

    #Disable IE protection
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 | out-null
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 | out-null

    #disable server manager at login
    Get-ScheduledTask -TaskName "ServerManager" | Disable-ScheduledTask 
}

#Disable OneDrive Sync
mkdir 'HKLM:\Software\Policies\Microsoft\Windows\OneDrive' -Force | out-null
New-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Windows\OneDrive" -name "DisableFileSyncNGSC" -value 1 | out-null

#disable ie fist run popups
mkdir 'HKLM:\Software\Microsoft\Internet Explorer\Main' -Force | out-null
New-ItemProperty -path "HKLM:\Software\Microsoft\Internet Explorer\Main" -name "DisableFirstRunCustomize" -value 1 | Out-Null

#Stop nagging default browser  
mkdir 'HKLM:\Software\Policies\Microsoft\Edge' -Force | out-null
New-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Edge" -name  "DefaultBrowserSettingEnabled" -Value 0 | Out-Null

#hide first run popups
New-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Edge" -name "HideFirstRunExperience" -value 1 | Out-Null


# disable "Choose Privacy Settings for your device"
# Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" `
#                  -name "PrivacyConsentStatus" `
#                  -value 1


mkdir 'HKLM:\Software\Policies\Microsoft\Windows\OOBE' -Force | out-null
# disable "Choose Privacy Settings for your device"
Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" `
                 -name "DisablePrivacyExperience" `
                 -value 1 -Force | out-null

# Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" `
#                  -name "SkipUserOOBE" `
#                  -value 1
# Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" `
#                  -name "SkipMachineOOBE" `
#                  -value 1

# set taskbar
mkdir c:\programData\script -Force | out-null
Copy-Item ./taskbar.xml c:\ProgramData\script\taskbar.xml | out-null

mkdir 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Force | out-null
Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
                 -name "StartLayoutFile" `
                 -value "C:\ProgramData\script\taskbar.xml" `
                 -force | out-null;
Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
                 -name "LockedStartLayout" `
                 -value 1 -Force | out-null;
Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
                 -name "ReapplyStartLayoutEveryLogon" `
                 -value 1 -Force | out-null;
                 

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

#enable UAC on Administrator account
                
#mkdir "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -force | Out-Null
Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
                 -name "FilterAdministratorToken" `
                 -value 1 `
                 -force | out-null


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

#for explanation: https://stackoverflow.com/questions/25438409/reg-unload-and-new-key
[gc]::Collect()
[gc]::WaitForPendingFinalizers()
Start-Sleep -Seconds 1
& REG UNLOAD "HKU\Default" | out-default
Start-Sleep -Seconds 1

Remove-PSDrive HKU 
