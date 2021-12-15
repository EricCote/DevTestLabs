
$UserLanguageList = New-WinUserLanguageList -Language "fr-CA"
$UserLanguageList.Add("en-US")

Set-WinUserLanguageList -LanguageList $UserLanguageList -force

#-------------------------------------------------------------------------

$unattend = Get-Content "C:\windows\panther\Unattend.xml"

$unattend = $unattend.Replace('<settings pass="oobeSystem" wasPassProcessed="true">',
@"
<settings pass="oobeSystem" wasPassProcessed="true">
  <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <InputLocale>040c:0000040c;0809:00000809</InputLocale>
    <SystemLocale>fr-CA</SystemLocale>
    <UILanguage>fr-CA</UILanguage>
    <UserLocale>fr-CA</UserLocale>
    <UILanguageFallback>en-US</UILanguageFallback>
  </component>
"@
)

$unattend | Set-Content "C:\windows\panther\Unattend.xml"

#--------------------------------------------------------------

$oobe = @"
<FirstExperience>
  <oobe>
    <defaults>
      <language>3084</language>
      <location>39</location>
      <keyboard>0809:00000809</keyboard>
      <timezone>Eastern Standard Time</timezone>
      <adjustForDST>true</adjustForDST>
    </defaults>
  </oobe>
</FirstExperience>
"@

New-Item -Path "C:\windows\System32\oobe" -Name "info" -ItemType "directory"

$oobe | Set-Content "C:\windows\System32\oobe\info\oobe.xml"

#--------------------------------------------------------------

& C:\Windows\System32\oobe\oobeldr.exe /system
