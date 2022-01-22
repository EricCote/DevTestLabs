$ProgressPreference = 'SilentlyContinue'


$page = (Invoke-WebRequest "https://www.microsoft.com/en-us/download/confirmation.aspx?id=49117"  -UseBasicParsing).RawContent;
$page -match '{url:\"(.*?)\"';
$OdtSource = $matches[1];

$tempFolder= $env:Temp;

$OdtFolder = $tempFolder;
$fileDest= ("$tempFolder\OdtOffice.exe");

Invoke-WebRequest -UseBasicParsing -Uri $OdtSource -OutFile $fileDest

$xml= @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="PerpetualVL2021">
    <Product ID="ProPlus2021Volume" PIDKEY="FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH">
      <Language ID="en-us" />
      <Language ID="fr-ca" />
      <!--  <ExcludeApp ID="Teams" />  -->
    </Product>
  </Add>

  <Updates Enabled="TRUE" Channel="PerpetualVL2021" />
  <Display Level="None" AcceptEULA="TRUE" /> 
  <!--  <Property Name="AUTOACTIVATE" Value="1" />  -->

</Configuration>
"@
    

& $fileDest  /extract:"$OdtFolder" /quiet | out-null ; 

$conf=(Join-Path $OdtFolder "configuration.xml") ;
$xml | Out-File  -FilePath $conf -Encoding utf8;

"Installing Office 2021.  Might take a while."
###  & (Join-Path $OdtFolder "setup.exe")   /configure "$conf"   | out-default ;

##################################
#hide first run dialog 
##################################
New-PSDrive HKU Registry HKEY_USERS | out-default
& REG LOAD "HKU\Default" "C:\Users\Default\NTUSER.DAT" | out-default

# #Create Registry key 
# New-Item "HKU:\Default\SOFTWARE\Microsoft\Office\16.0\Common" `
#                  -force | out-null


# #Create Registry value
# New-ItemProperty -Path "HKU:\Default\SOFTWARE\Microsoft\Office\16.0\Common" `
#                  -Name "PrivacyNoticeShown" `
#                  -Value 2 -PropertyType dword `
#                  -Force | out-null


# #Create Registry key 
# New-Item "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Common\General" `
#                  -force | out-null

# #Create Registry value
# New-ItemProperty -Path "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Common\General" `
#                  -Name "ShownFirstRunOptin" `
#                  -Value 1 -PropertyType dword `
#                  -Force | out-null

# #Create Registry key 
# New-Item "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Registration" `
#                  -force | out-null

# #Create Registry value
# New-ItemProperty -Path "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Registration" `
#                  -Name "AcceptAllEulas" `
#                  -Value 1 -PropertyType dword `
#                  -Force | out-null

#Create Registry key 
New-Item "HKU:\Default\SOFTWARE\Microsoft\Office\16.0\Common\Privacy\SettingsStore\Anonymous" `
                 -force | out-null

#Create Registry value
New-ItemProperty -Path "HKU:\Default\SOFTWARE\Microsoft\Office\16.0\Common\Privacy\SettingsStore\Anonymous" `
                 -Name "OptionalConnectedExperiencesNoticeVersion" `
                 -Value 2 -PropertyType dword `
                 -Force | out-null
  

#Create Registry key 
New-Item "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Teams" `
                 -force | out-null

#Create Registry value
New-ItemProperty -Path "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Teams" `
                 -Name "PreventFirstLaunchAfterInstall" `
                 -Value 1 -PropertyType dword `
                 -Force | out-null




[gc]::Collect()

& REG UNLOAD HKU\Default | out-null
Remove-PSDrive HKU


