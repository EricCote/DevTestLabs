$source = 'https://dl.google.com/android/repository/commandlinetools-win-7302050_latest.zip'


$temp = "$env:temp"

$wc = new-object System.Net.WebClient

$wc.DownloadFile($Source, "$temp\commandlinetools.zip")
$wc.Dispose()

Expand-Archive -Path "$temp\commandlinetools.zip" -DestinationPath "c:\android\cmdline-tools"

choco install jre8 -y --force


Rename-Item C:\android\cmdline-tools\cmdline-tools  tools

[System.Environment]::SetEnvironmentVariable('JAVA_HOME', 'C:\Program Files\Java\jre1.8.0_291', [System.EnvironmentVariableTarget]::Machine)

[System.Environment]::SetEnvironmentVariable('ANDROID_SDK_ROOT', 'C:\android', [System.EnvironmentVariableTarget]::Machine)

$path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')


[System.Environment]::SetEnvironmentVariable('Path', "$path;C:\android\cmdline-tools\latest\bin;c:\android\emulator;c:\android\platform-tools;C:\android\cmdline-tools\tools\bin", [System.EnvironmentVariableTarget]::Machine)


#This will allow to have access to refreshenv
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv


#To accept all licences
for($i=0;$i -lt 30;$i++) { $response += "y`n"}; $response | sdkmanager --licenses

sdkmanager  "cmdline-tools;latest"
sdkmanager  "extras;intel;Hardware_Accelerated_Execution_Manager"
sdkManager  "emulator"
sdkManager  "platforms;android-30"
sdkmanager  "platform-tools"

sdkmanager  "skiaparser;1"  
sdkmanager  "system-images;android-30;google_apis_playstore;x86_64"

# C:\android\extras\intel\Hardware_Accelerated_Execution_Manager\silent_install.bat
#sc query intelhaxm
#sc config intelhaxm start= disabled

"n" |  avdmanager --verbose create avd --force --name "generic_12" --package "system-images;android-30;google_apis_playstore;x86_64" 


Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -All -NoRestart

$result = get-content "$env:userprofile\.android\avd\generic_12.avd\config.ini"

$result -replace "hw.keyboard = no", "hw.keyboard = yes" -replace "hw.ramSize = 96M", "hw.ramSize = 1024M" -replace "vm.heapSize = 64M", "vm.heapSize = 1024M"  | out-file "$env:userprofile\.android\avd\generic_12.avd\config.ini"   -Encoding utf8

#Restart-Computer

#$env:path= "$env:path;c:\android\emulator"

# install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
# Dism /Online /Enable-Feature:HypervisorPlatform

#angle_indirect

# emulator -avd generic_12 -gpu swiftshader_indirect  -accel on -no-boot-anim -no-audio  