



$script=@"
do {
     Start-Sleep -Milliseconds 2000
} While (!(Test-Path -path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe"))
 

new-item "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FirstRun"  -Force  | out-null;
new-item "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main"    | out-null;

new-itemproperty "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FirstRun" -Name "LastFirstRunVersionDelivered" -Value 1 -Type DWORD -Force | out-null ;
new-itemproperty "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" -Name IE10TourShown -Value 1 -Type DWORD -Force | out-null;

"@

new-item "$env:ProgramData\scripts" -directory -force

sc "$env:ProgramData\scripts\EdgeWelcome.ps1"  $script

New-Item -Path   "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\EdgeWelcome" -type Directory 
new-itemproperty "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\EdgeWelcome" -Name "Version" -Value "1,0,0,0" -PropertyType String -Force 
new-itemproperty "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\EdgeWelcome" -Name "StubPath" -Value "powershell.exe  -NoProfile -ExecutionPolicy ByPass -File `"$env:ProgramData\scripts\EdgeWelcome.ps1`"" -PropertyType ExpandString -Force


