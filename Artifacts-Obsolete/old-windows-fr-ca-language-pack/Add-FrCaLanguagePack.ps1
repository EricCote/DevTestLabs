$tempFolder= ${env:Temp};

$BuildVersion=[Environment]::OSVersion.Version.Build
$OsVersion=[Environment]::OSVersion.Version.Major 
$isServer= (Gwmi  Win32_OperatingSystem).productType -gt 1


$LanguagePackSource=""

if (-NOT $isserver -and $OsVersion -eq 10 )  #Windows 10 
{   

  if ($BuildVersion -le 17134) #1803 
  {
    $LanguagePackSource = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2018/04/lp_fc01872ba8ba1a65ac5d67bad4940e7a4514ed72.cab"
  }

  if ($BuildVersion -le 16299) #1709 Fall Creator's update
  {
    $LanguagePackSource = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2017/10/lp_f8ff8608dc2014b6a2ec44459b01a81f04d928a9.cab"
  }

  if ($BuildVersion -le 15063) #1703 Creator's update
  {
    $LanguagePackSource = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2017/03/lp_8cbb51723015e2557115f1471d696451abae68e1.cab"
  }
  if ($BuildVersion -le 14393) #1607 anniversary update
  { 
    $LanguagePackSource = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/07/lp_a63abaa1136ce9bd7a50ae1eaf54f1a58500c1a7.cab"
  }         
  if ($BuildVersion -le 10586) #1511  November update
  {
    $LanguagePackSource = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/11/lp_7f834b68030b2e216d529c565305ea0ee8bb2489.cab"
  }
  if ($BuildVersion -le 10240) #RTM version
  {
    $LanguagePackSource = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/07/lp_8f6e1d4cb3972edef76030b917020b7ee6cf6582.cab"
  }
}
       
if ($isServer)  #Windows Server
{   
  if ($OsVersion -eq 10) #Windows Server 2016
  {
    $LanguagePackSource = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/09/lp_84495308108c7684657c4be5f032341565f47410.cab";
  }
  if ($OsVersion -eq 8)  #Windows Server 2012R2
  {
    $LanguagePackSource = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2014/11/windows8.1-kb3012997-x64-fr-fr-server_f5e444a46e0b557f67a0df7fa28330f594e50ea7.cab";
  }   
} 
    
if (-NOT $isServer -and $OsVersion -eq 8)  #Windows 8.1
{
  $LanguagePackSource = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2014/11/windows8.1-kb3012997-x64-fr-fr-client_134770b2c1e1abaab223d584d0de5f3b4d683697.cab"
}       


if ($LanguagePackSource -ne $null)  
{      
    $filename = Join-Path  $tempFolder  "lang.cab"
  
    $wc = new-object System.Net.WebClient ;
    $wc.DownloadFile($LanguagePackSource,  $filename);
    $wc.Dispose();      

    if ((Get-WindowsPackage -Online -PackagePath ($filename)).PackageState -eq "NotPresent")
    {
      Add-WindowsPackage -Online -PackagePath ($filename)
    }
}

