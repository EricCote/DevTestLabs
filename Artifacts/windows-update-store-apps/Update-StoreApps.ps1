function Update-MicrosoftStoreApps{
    Write-Host "Updating Microsoft Store applications."
    (Get-WmiObject `
          -Namespace "root\cimv2\mdm\dmmap" `
          -Class "MDM_EnterpriseModernAppManagement_AppManagement01" `
    ).UpdateScanMethod() | Out-Null
}

Update-MicrosoftStoreApps




# New-PSDrive HKU Registry HKEY_USERS | out-null
# &reg load hku\def "C:\users\default user\NTUSER.DAT"


# New-item -path "hku:\def\Software\Microsoft\Windows\CurrentVersion\RunOnce" -force  | out-null
# Set-ItemProperty  -path "hku:\def\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "update" -Value 'schtasks /run /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update"'
# ""


# [System.GC]::Collect();
# [System.GC]::WaitForPendingFinalizers();
# [System.GC]::Collect();

# &reg unload hku\def
# Remove-PSDrive HKU


 
