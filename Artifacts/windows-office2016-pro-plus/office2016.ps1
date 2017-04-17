

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


$sys32="$env:windir\system32"
$lic16="${env:ProgramFiles(x86)}\Microsoft Office\root\Licenses16"
$off16="${env:ProgramFiles(x86)}\Microsoft Office\Office16"

#& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\ProPlusDemoR_BypassTrial180-pl.xrm-ms"
#& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\ProPlusDemoR_BypassTrial180-ppd.xrm-ms"
#& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\ProPlusDemoR_BypassTrial180-ul-oob.xrm-ms"


#Make it an Office VL Licence so we'll then have a 25 day grace period.
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\ProPlusVL_KMS_Client-ppd.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\ProPlusVL_KMS_Client-ul.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\ProPlusVL_KMS_Client-ul-oob.xrm-ms"

& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\ProjectProVL_KMS_Client-ppd.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\ProjectProVL_KMS_Client-ul-oob.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\ProjectProVL_KMS_Client-ul.xrm-ms"

& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\VisioProVL_KMS_Client-ppd.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\VisioProVL_KMS_Client-ul-oob.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\VisioProVL_KMS_Client-ul.xrm-ms"

& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\client-issuance-bridge-office.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\client-issuance-root.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\client-issuance-root-bridge-test.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\client-issuance-stil.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\client-issuance-ul.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\client-issuance-ul-oob.xrm-ms"
& cscript //nologo $sys32\slmgr.vbs /ilc "$lic16\pkeyconfig-office.xrm-ms"

#kms generic key from Microsoft
#from this page: https://technet.microsoft.com/en-us/library/dn385360(v=office.16).aspx
& cscript //nologo "$off16\ospp.vbs" /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99  

#& cscript //nologo "$off16\ospp.vbs" /sethst:kms.myenterprise.com
#& cscript //nologo "$off16\ospp.vbs" /act

#& cscript //nologo "$off16\ospp.vbs" /dstatus
#& cscript //nologo "$off16\ospp.vbs" /dstatusall
#& cscript //nologo "$off16\ospp.vbs" /dinstid
#& cscript //nologo "$off16\ospp.vbs" /dhistoryacterr

