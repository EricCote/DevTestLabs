
New-PSDrive HKU Registry HKEY_USERS | out-null
&reg load hku\def "C:\users\default user\NTUSER.DAT"

new-item "HKU:\def\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FirstRun" -Force  | out-null
new-item "HKU:\def\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" -force   | out-null

new-itemproperty "HKU:\def\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FirstRun" -Name "LastFirstRunVersionDelivered" -Value 1 -Type DWORD -Force | out-null 
new-itemproperty "HKU:\def\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" -Name IE10TourShown -Value 1 -Type DWORD -Force | out-null
""

[System.GC]::Collect();
&reg unload hku\def
Remove-PSDrive HKU