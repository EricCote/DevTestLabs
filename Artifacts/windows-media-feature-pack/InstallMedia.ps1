
$tempFolder=${env:Temp};

$BuildVersion=[Environment]::OSVersion.Version.Build
$OsVersion=[Environment]::OSVersion.Version.Major 
$isServer= (Gwmi  Win32_OperatingSystem).productType -gt 1


[string] $url = $null;

#detect windows version for client
if (-NOT $isserver)
{
    #Are we on a Windows version 8+? does it have acces to "Get-WindowsOptionalFeature"?
    if (Get-Command -Name Get-WindowsOptionalFeature -ErrorAction SilentlyContinue) 
    {   
        #Test for media features on Windows 8+
        [string] $mediaRpt = (Get-WindowsOptionalFeature -online -FeatureName MediaPlayback).State ;
    }
    else
    {    
        #Test for media features on old Windows 7  
        $dism = (& dism /online /get-featureinfo /featurename:MediaPlayback);
        [string] $mediaRpt = ([regex]"State : (\w+)").Match($dism).Groups[1].Value ;    
    }
   

    #detect if windows media playback is not installed
    if ($mediaRpt -ne 'Enabled' -and $OsVersion -eq 10 )
    {
        if ($BuildVersion -le 15063) #creator's edition (1703) 
        {
            $url="http://download.microsoft.com/download/9/E/C/9EC0EC2C-8151-468A-95A3-2F2AD6A2AC13/Microsoft-Windows-MediaFeaturePack-OOB-Package.msu"
        }    
             
        if ($BuildVersion -le 14393) #anniversary edition  (1607)
        {
            $url="https://download.microsoft.com/download/1/3/F/13F19BF0-17CF-4D0F-938C-41D0489C3FE6/KB3133719-x64.msu.msu"
        }
            
        if ($BuildVersion -le 10586) #november 2015 update (1511)
        {
            $url="https://download.microsoft.com/download/B/E/3/BE302763-5BFD-4209-9C98-02DF5B2DB452/KB3099229_x64.msu"
        }
           
        if ($BuildVersion -le 10240) #RTM original (1507)
        {
            $url="http://download.microsoft.com/download/7/F/2/7F2E00A7-F071-41CA-A35B-00DC536D4227/Windows10-KB3010081-x64.msu"
        }
    }

    if ($mediaRpt -ne 'Enabled' -and $OsVersion -eq 6 )
    {
        $BuildVersion = ([Regex]"(?'ver'\d+)\.\d+\.(?'build'\d+)").Match((cmd /c ver)[1]).Groups['build'].Value

        if ($BuildVersion -le 9600) #Windows 8.1 
        {
            $url="https://download.microsoft.com/download/8/9/7/89775613-432E-4ECF-93A9-5BAFCB5B7807/Windows8.1-KB2929699-x64.msu"
        }           
        if ($BuildVersion -le 9200) #Windows 8.0
        {
            $url="https://download.microsoft.com/download/7/A/D/7AD12930-3AA6-4040-81CF-350BF1E99076/Windows6.2-KB2703761-x64.msu"
        }
        if ($BuildVersion -le 7601) #Windows 7 SP1
        {
            $url="https://download.microsoft.com/download/B/9/B/B9BED058-8669-490E-BA61-D502E4E8BEB1/Windows6.1-KB968211-x64-RefreshPkg.msu"
        }
     }
     
             
    if ($url) {
        "Downloading Media Pack...."
        $wc = new-object System.Net.WebClient ;
        $wc.DownloadFile($url,  "$tempFolder\Win-Media-Pack.msu");
        $wc.Dispose();    

        "Installing Media Pack..."
        $wusaArgs =  "`"$tempFolder\Win-Media-Pack.msu`" /quiet /norestart"
        Start-Process wusa.exe -ArgumentList $wusaArgs -Wait

        "Media Pack finished installing. The PC neds to restart to complete the installation."
    }
}

