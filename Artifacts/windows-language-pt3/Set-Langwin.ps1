
param(
  [string] $lang="en-CA"
)

"Language set is: $lang"

#Get the unattend.xml file content
$unattend = Get-Content "C:\windows\panther\Unattend.xml" -raw

$inputLocale="0409:00000409;1009:00011009;0c0c:00011009"

if ($lang -match "fr") 
{$inputLocale= "0c0c:00011009;1009:00011009"}

if ($lang -match "en-CA") 
{$inputLocale= "1009:00011009;0c0c:00011009"}

#add intl section, (if it doesn't exist yet)
$Count = [regex]::matches($unattend,"Microsoft-Windows-International-Core").count

#If it doesn't exist, we add the international settings in the file
if ($Count -eq 0) {
  $unattend = $unattend.Replace('<settings pass="oobeSystem" wasPassProcessed="true">',
  @"
  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <InputLocale>$inputLocale</InputLocale>
      <SystemLocale>$lang</SystemLocale>
      <UILanguage>$lang</UILanguage>
      <UserLocale>$lang</UserLocale>
      <UILanguageFallback>en-US</UILanguageFallback>
    </component>
"@
  )
}


if ($Count -eq 1) {
  $unattend = $unattend.Replace('<settings pass="oobeSystem" wasPassProcessed="true">','<settings pass="oobeSystem">')
}


#Let's remove the userAccounts part
#we don't want to create the accounts a second time (leads to errors?) 
$unattend= $unattend -replace "(?ms)<UserAccounts>.*?</UserAccounts>", ""

#Save unattend.xml
$unattend | Set-Content "C:\windows\panther\Unattend.xml" -encoding utf8


#This registry value says that the last part of unattended.xml 
#(step7, oobeSystem) has not completed and needs to run again.
#see: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/update-windows-settings-and-scripts-create-your-own-answer-file-sxs?view=windows-11
New-ItemProperty `
   -path "HKLM:\SYSTEM\Setup\Status\UnattendPasses" `
   -name "oobeSystem" `
   -value 0  `
   -Force | Out-Null


#--------------------------------------------------------------

# Lets run the last part of unattended.xml again. And set the language.
& C:\Windows\System32\oobe\oobeldr.exe /system


# Start-Sleep -Seconds 20


# restart-computer


#------------------------------------------------------------------
# We could try to set the current language list...  
# but this fails because it gets reset by oobe during first login

# $UserLanguageList = New-WinUserLanguageList -Language "fr-CA"
# $UserLanguageList.Add("en-US")

# Set-WinUserLanguageList -LanguageList $UserLanguageList -force

#-------------------------------------------------------------------------



#--------------------------------------------------------------
#We could create a oobe.xml file in the oobe folder.  
# I dont remember if this works with the unattended process during first login.

# $oobe = @"
# <FirstExperience>
#   <oobe>
#     <defaults>
#       <language>3084</language>
#       <location>39</location>
#       <keyboard>0809:00000809</keyboard>
#       <timezone>Eastern Standard Time</timezone>
#       <adjustForDST>true</adjustForDST>
#     </defaults>
#   </oobe>
# </FirstExperience>
# "@

# New-Item -Path "C:\windows\System32\oobe" -Name "info" -ItemType "directory"

# $oobe | Set-Content "C:\windows\System32\oobe\info\oobe.xml"

#---------------------------------------------------------------