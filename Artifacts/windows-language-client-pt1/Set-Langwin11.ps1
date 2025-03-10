Install-Language -Language "fr-CA" 

New-PSDrive HKU Registry HKEY_USERS | out-null
& REG LOAD "HKU\Default" "C:\Users\Default\NTUSER.DAT"  | out-null

New-ItemProperty -path "HKU:Default\Control Panel\International\Geo" `
  -name Name `
  -PropertyType String `
  -Value "ca" `
  -Force | out-null   

New-ItemProperty -path "HKU:Default\Control Panel\International\Geo" `
  -name Nation `
  -PropertyType dword `
  -Value 39 `
  -Force | out-null       


#for explanation: https://stackoverflow.com/questions/25438409/reg-unload-and-new-key
Remove-PSDrive HKU 
[gc]::Collect()
[gc]::WaitForPendingFinalizers()

& REG UNLOAD "HKU\Default" | out-default