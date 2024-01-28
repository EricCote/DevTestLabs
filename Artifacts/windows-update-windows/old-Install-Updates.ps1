$tempFolder= ${env:Temp};

#This function will set the "update other Microsoft products" checkbox.
function Configure-MSUpdate
{
    $ServiceManager = New-Object -ComObject "Microsoft.Update.ServiceManager"
    $ServiceManager.ClientApplicationID = "My App"
    $status=$ServiceManager.QueryServiceRegistration("7971f918-a847-4430-9279-4a52d1efe18d").RegistrationState
    if ($status -lt 3)
    {
        $ServiceManager.AddService2( "7971f918-a847-4430-9279-4a52d1efe18d",7,"")
    }
}

#call the function
Configure-MSUpdate

#this will call the powershell script to detect, download and install the updates. 
#This script will NOT restart the computer. 
& ".\Get-WindowsUpdates.ps1" -Install -EulaAccept -verbose
        


