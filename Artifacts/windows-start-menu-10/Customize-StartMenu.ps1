
New-PSDrive HKU Registry HKEY_USERS | out-null
&reg load hku\def "C:\users\default user\NTUSER.DAT"

$lang=""

try{
    $lang=Get-ItemPropertyValue "HKU:\def\Control Panel\International\User Profile" "WindowsOverride" -ErrorAction SilentlyContinue;
} 
catch{}

if ($lang -eq "")
{
  $lang=(Get-ItemPropertyValue "HKU:\def\Control Panel\International\User Profile" "Languages")[0];
}

$lang

[System.GC]::Collect();
&reg unload hku\def
Remove-PSDrive HKU

$en = if ($lang -eq "en-US") {$true}else{$false};

$life = if ($en){"Life at a glance"}else{"Coup d'oeil sur les activités"};
$play = if ($en){"Play and explore"}else{"Jouer et explorer"};
$nav= if ($en){"Browsers"}else{"Navigateurs"};
$desc= if ($en){"Finds and displays information and Web sites on the Internet."}else{"Navigue sur Internet."}

if (test-path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\Skype for Business 2016.lnk")
{
    Rename-Item -NewName "Skype Business 2016.lnk" -Path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\Skype for Business 2016.lnk";
}

if (test-path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\OneDrive for Business.lnk")
{
    Rename-Item -NewName "OneDrive Business.lnk" -Path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\OneDrive for Business.lnk";
}


$office="";
if (test-path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\Access 2016.lnk")
{   $office=@"     

        <start:Group Name="Office">
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Access 2016.lnk" /> 
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Excel 2016.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\OneDrive Business.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\OneNote 2016.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Outlook 2016.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\PowerPoint 2016.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="4" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Publisher 2016.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="4" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Skype Business 2016.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="4" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Word 2016.lnk" />
        </start:Group>
"@;
}

$dev="";
$innerDev="";
if (test-path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk")
{    $innerDev = $innerDev + @"

          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk" />
"@
      $vsCodeBar=@"  
      
        <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk" />
"@
}

if (test-path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\Visual Studio 2017.lnk")
{    $innerDev = $innerDev + @"

          <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Visual Studio 2017.lnk" />
"@
      $vsBar=@"  
      
        <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Internet Explorer.lnk" />
        <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Visual Studio 2017.lnk" />
"@         
}
else
{
     $officeBar=@"

        <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Outlook 2016.lnk" />
        <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Excel 2016.lnk" />
        <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Word 2016.lnk" />
"@
}

if (test-path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\Blend for Visual Studio 2017.lnk")
{    $innerDev = $innerDev + @"

          <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Blend for Visual Studio 2017.lnk" />
"@
}

if (test-path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\Visual Studio 2017 Preview.lnk")
{    $innerDev = $innerDev + @"

          <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Visual Studio 2017 Preview.lnk" />
"@
}

#if (test-path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\Visual Studio 2017 Preview.lnk")
#{    $innerDev = $innerDev + @"
#
#          <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Visual Studio 2017 Preview.lnk" />
#"@
#}





if ($innerDev -eq "")
{ $dev  = "" }
else
{
  $dev= @"

        <start:Group Name="Dev">  $innerDev
        </start:Group>
"@
}

if (test-path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\Mozilla Firefox.lnk")
{    $firefox = @"

          <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Mozilla Firefox.lnk" />
"@
     $firefoxBar = @"

        <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Mozilla Firefox.lnk" />
"@
}
if (test-path "$env:AllUsersProfile\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk")
{    $chrome = @"

          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" />
"@
     $chromeBar = @"

        <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" />
"@
}


$xml = @"
<?xml version="1.0" encoding="utf-8"?>
<LayoutModificationTemplate
    xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
    xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
    xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
    xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
    Version="1">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride  LayoutCustomizationRestrictionType="OnlySpecifiedGroups">
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6" >   $office       
        <start:Group Name="$Nav"> $firefox $chrome
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Internet Explorer.lnk" />
          <start:Tile Size="2x2" Column="2" Row="0" AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" />
        </start:Group>  $dev
        <start:Group Name="$Life">
          <start:Tile Size="2x2" Column="0" Row="0" AppUserModelID="microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar" />
          <start:Tile Size="4x2" Column="2" Row="0" AppUserModelID="microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail" />
          <start:Tile Size="4x2" Column="2" Row="4" AppUserModelID="Microsoft.WindowsStore_8wekyb3d8bbwe!App" />
          <start:Tile Size="2x2" Column="4" Row="2" AppUserModelID="Microsoft.People_8wekyb3d8bbwe!x4c7a3b7dy2188y46d4ya362y19ac5a5805e5x" />
          <start:Tile Size="4x2" Column="0" Row="2" AppUserModelID="Microsoft.BingWeather_8wekyb3d8bbwe!App" />
          <start:Tile Size="2x2" Column="0" Row="4" AppUserModelID="Microsoft.WindowsCalculator_8wekyb3d8bbwe!App" />
        </start:Group>
        <start:Group Name="$Play">
          <start:Tile Size="2x2" Column="0" Row="0" AppUserModelID="Microsoft.XboxApp_8wekyb3d8bbwe!Microsoft.XboxApp" />
          <start:Tile Size="4x2" Column="2" Row="0" AppUserModelID="Microsoft.WindowsMaps_8wekyb3d8bbwe!App" />
        </start:Group>
      </defaultlayout:StartLayout>
    </StartLayoutCollection>
  </DefaultLayoutOverride>
  <CustomTaskbarLayoutCollection>
    <defaultlayout:TaskbarLayout>
      <taskbar:TaskbarPinList>  $officeBar  $chromeBar $firefoxBar  $vsBar $vsCodeBar
      </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
 </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
"@

if(!(Test-Path "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Internet Explorer.lnk")) {
  $Shell = New-Object -ComObject ("WScript.Shell")
  $ShortCut = $Shell.CreateShortcut("$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Internet Explorer.lnk")
  $ShortCut.TargetPath="${env:ProgramFiles(x86)}\Internet Explorer\iexplore.exe"
  $ShortCut.WorkingDirectory = "%HOMEDRIVE%%HOMEPATH%";
  $ShortCut.WindowStyle = 1;
  $ShortCut.Description = $desc;
  $ShortCut.Save()
}

set-content "C:\users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" $xml -encoding utf8 

Remove-Item "$env:PUBLIC\desktop\*.*"


