
#Set eastern time zone
tzutil /s "Eastern Standard Time"


#enable sound
Set-Service audiosrv -startuptype automatic
start-service audiosrv


#disable new network popup.  All new networks are now considered "public"
new-Item HKLM:\System\CurrentControlSet\Control\Network\NewNetworkWindowOff


#Disable IE protection
function Disable-IEESC{
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
}
Disable-IEESC;

#disable ie fist run popups
mkdir 'HKLM:\Software\Microsoft\Internet Explorer'
mkdir 'HKLM:\Software\Microsoft\Internet Explorer\Main'
New-ItemProperty -path "HKLM:\Software\Microsoft\Internet Explorer\Main" -name "DisableFirstRunCustomize" -value 1;


#disable server manager at login
Get-ScheduledTask -TaskName "ServerManager" | Disable-ScheduledTask

##################################
# Show file extensions
##################################
New-PSDrive HKU Registry HKEY_USERS | out-null
& REG LOAD HKU\Default C:\Users\Default\NTUSER.DAT | out-null

#Create Registry Item 
        New-ItemProperty -path "HKU:Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
                         -name HideFileExt `
                         -Value 0 -PropertyType dword `
                         -Force | out-null

[gc]::Collect()

& REG UNLOAD HKU\Default | out-null
Remove-PSDrive HKU








