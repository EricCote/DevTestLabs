
$tempFolder= ${env:Temp};

$OdtFolder = $tempFolder;
$OdtSource = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_14326-20404.exe";
$fileDest= ("$tempFolder\OdtOffice.exe");

$wc = new-object System.Net.WebClient ;
$wc.DownloadFile($OdtSource, $fileDest) ; 
$wc.Dispose();    

$xml= @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="PerpetualVL2021">
    <Product ID="ProPlus2021Volume" PIDKEY="FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH">
      <Language ID="en-us" />
      <Language ID="fr-fr" />
    </Product>
  </Add>

  <Updates Enabled="TRUE" Channel="PerpetualVL2021" />
  <Display Level="None" AcceptEULA="TRUE" /> 
  <!--  <Property Name="AUTOACTIVATE" Value="1" />  -->

</Configuration>
"@
    

& $fileDest  /extract:"$OdtFolder" /quiet | out-null ; 

$conf=(Join-Path $OdtFolder "configuration.xml") ;
Set-Content $conf $xml ;

"Installing Office 2021.  Might take a while."
& (Join-Path $OdtFolder "setup.exe")   /configure "$conf"   | out-null ;

##################################
#hide first run dialog 
##################################
New-PSDrive HKU Registry HKEY_USERS | out-null
& REG LOAD HKU\Default C:\Users\Default\NTUSER.DAT | out-null

#Create Registry key 
        New-Item "HKU:\Default\Software\Microsoft\Office\16.0\Common" `
                 -force | out-null

#Create Registry value
New-ItemProperty -Path "HKU:\Default\Software\Microsoft\Office\16.0\Common" `
                 -Name "PrivacyNoticeShown" `
                 -Value 2 -PropertyType dword `
                 -Force | out-null


#Create Registry key 
        New-Item "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Common\General" `
                 -force | out-null

#Create Registry value
New-ItemProperty -Path "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Common\General" `
                 -Name "ShownFirstRunOptin" `
                 -Value 1 -PropertyType dword `
                 -Force | out-null

#Create Registry key 
        New-Item "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Registration" `
                 -force | out-null

#Create Registry value
New-ItemProperty -Path "HKU:\Default\SOFTWARE\Policies\Microsoft\Office\16.0\Registration" `
                 -Name "AcceptAllEulas" `
                 -Value 1 -PropertyType dword `
                 -Force | out-null

[gc]::Collect()

& REG UNLOAD HKU\Default | out-null
Remove-PSDrive HKU

exit
