

#https://c2rsetup.officeapps.live.com/c2r/download.aspx?productReleaseID=O365ProPlusRetail&platform=X86&language=en-us&version=O16GA&source=O16OLSO365
#https://c2rsetup.officeapps.live.com/c2r/download.aspx?TaxRegion=IR&version=O16GA&language=fr-FR&Source=O16HUP&platform=x86&ProductreleaseID=ProPlusRetail
#https://c2rsetup.officeapps.live.com/c2r/download.aspx?language=en-US&Source=O16HUP&ProductreleaseID=ProPlusRetail&platform=x86&act=1&TaxRegion=SG&version=O16GA&token=PYMX3-N8CKJ-222J7-RFTKY-HT9X7
#https://c2rsetup.officeapps.live.com/c2r/download.aspx?productReleaseID=O365ProPlusRetail&platform=X86&language=en-us&TaxRegion=pr&version=O16GA&source=O15OLSO365&Br=1


#   $fileSource = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?productReleaseID=ProPlusRetail&platform=X86&language=en-us&TaxRegion=pr&version=O16GA&source=O15HUP&Br=1"
#   $fileDest= ($tempFolder + "office.exe")

$tempFolder= ${env:Temp};

$OdtFolder = $tempFolder;
$OdtSource = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_8008-3601.exe";
$fileDest= ($tempFolder + "OdtOffice.exe");

$wc = new-object System.Net.WebClient ;
$wc.DownloadFile($OdtSource, $fileDest) ; 
$wc.Dispose();    

$xml= @"
<Configuration>

  <Add OfficeClientEdition="32" Channel="Current">
    <Product ID="ProPlusRetail">
      <Language ID="en-us" />
      <Language ID="fr-fr" />
    </Product>
  </Add>

  <Updates Enabled="TRUE" Channel="Current" />
  <Display Level="None" AcceptEULA="TRUE" /> 
  <!--  <Property Name="AUTOACTIVATE" Value="1" />  -->

</Configuration>
"@
    

& $fileDest  /extract:"$OdtFolder" /quiet | out-null ; 

$conf=(Join-Path $OdtFolder "configuration.xml") ;
Set-Content $conf $xml ;

"Installing Office 2016.  Might take a while."
& (Join-Path $OdtFolder "setup.exe")   /configure "$conf"   | out-null ;

