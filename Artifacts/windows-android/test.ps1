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


        [System.Environment]::SetEnvironmentVariable('Path', "$path;C:\android\cmdline-tools\latest\bin;C:\android\cmdline-tools\tools\bin", [System.EnvironmentVariableTarget]::Machine)
     
        
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
        sdkmanager  "system-images;android-30;google_apis_playstore;x86"

       # C:\android\extras\intel\Hardware_Accelerated_Execution_Manager\silent_install.bat
       #sc query intelhaxm
       #sc config intelhaxm start= disabled

     "n" |  avdmanager --verbose create avd --force --name "generic_10" --package "system-images;android-30;google_apis_playstore;x86" 


     install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
     Dism /Online /Enable-Feature:HypervisorPlatform

     # emulator -avd generic_10 -gpu angle_redirect -verbose -accel on -no-boot-anim  -feature -QEMU_AUDIO_DRV =none
