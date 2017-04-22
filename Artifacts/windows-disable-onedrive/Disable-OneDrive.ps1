

New-Item "HKLM:\Software\Policies\Microsoft\Windows\OneDrive" -force | out-null;
New-ItemProperty  "HKLM:\Software\Policies\Microsoft\Windows\OneDrive" -Name DisableFileSyncNGSC -Value 1 -PropertyType dword | Out-Null;



 

