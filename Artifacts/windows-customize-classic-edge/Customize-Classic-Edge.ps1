
$script=@"
do {
     Start-Sleep -Milliseconds 2000;
} While (!(Test-Path -path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe"));
 
new-item "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FirstRun"  -Force  | out-null;
new-item "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" -Force   | out-null;

new-itemproperty "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FirstRun" -Name "LastFirstRunVersionDelivered" -Value 1 -Type DWORD -Force | out-null ;
new-itemproperty "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" -Name IE10TourShown -Value 1 -Type DWORD -Force | out-null;

"@ ;

new-item "c:\programdata\scripts" -type directory -force | Out-Null;
set-content  "c:\programdata\scripts\EdgeWelcome.ps1"  $script -encoding UTF8;


New-Item -Path   "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{EdgeWelcome}"  -Value "EdgeWelcome" -force | Out-Null;
new-itemproperty "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{EdgeWelcome}" -Name "Version" -Value "1,0,0,0" -PropertyType String -Force | Out-Null ;
new-itemproperty "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{EdgeWelcome}" -Name "StubPath" -Value "powershell.exe -NoProfile  -ExecutionPolicy ByPass -WindowStyle Hidden -File `"$env:ProgramData\scripts\EdgeWelcome.ps1`"" -PropertyType String -Force | Out-Null;
new-itemproperty "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{EdgeWelcome}" -Name "Enabled" -Value 1 -PropertyType dword -Force | Out-Null;


