
New-PSDrive HKU Registry HKEY_USERS | out-null
&reg load hku\def "C:\users\default user\NTUSER.DAT"

New-item -path "hku:\def\Software\Microsoft\Windows\CurrentVersion\RunOnce" -force

Set-ItemProperty  -path "hku:\def\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "update" -Value 'schtasks /run /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update"'

[System.GC]::Collect();
&reg unload hku\def
Remove-PSDrive HKU

