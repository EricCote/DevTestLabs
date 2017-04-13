#cleans up the previous Sysprep
set-ItemProperty -Path "HKLM:\system\Setup\Status\SysprepStatus" -Name "CleanupState" -Type DWord -Value "2"
set-ItemProperty -Path "HKLM:\system\Setup\Status\SysprepStatus" -Name "GeneralizationState" -Type DWord -Value "7"

& msdtc.exe -uninstall
& msdtc.exe -install

