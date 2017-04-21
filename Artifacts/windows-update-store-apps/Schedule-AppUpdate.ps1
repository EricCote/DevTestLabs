
New-PSDrive HKU Registry HKEY_USERS | out-null
&reg load hku\def "C:\users\default user\NTUSER.DAT"

"hive loaded"

New-item -path "hku:\def\Software\Microsoft\Windows\CurrentVersion\RunOnce" -force
"path created"

Set-ItemProperty  -path "hku:\def\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "update" -Value 'schtasks /run /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update"'
"update runonce with a new value"

[System.GC]::Collect();
"first collect"
[System.GC]::WaitForPendingFinalizers();
"wait"
[System.GC]::Collect();
"second collect"

&reg unload hku\def
"hive unloaded"

Remove-PSDrive HKU
"Remove psdrive"

 
