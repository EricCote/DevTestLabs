
##################################
#remove first run dialog and eula
##################################
New-PSDrive HKU Registry HKEY_USERS | out-null

& REG LOAD HKU\Default C:\Users\Default\NTUSER.DAT | out-null


#Create Registry key 
        New-Item "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Common\General" `
                 -force | out-null

#Create Registry value
New-ItemProperty -Path "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Common\General" `
                 -Name "ShownFirstRunOptin" `
                 -Value 1 -PropertyType dword `
                 -Force | out-null

#Create Registry key 
        New-Item "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Registration" `
                 -force | out-null

#Create Registry value
New-ItemProperty -Path "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Registration" `
                 -Name "AcceptAllEulas" `
                 -Value "1" -PropertyType dword `
                 -Force | out-null

[gc]::Collect()

& REG UNLOAD HKU\Default | out-null
Remove-PSDrive HKU


