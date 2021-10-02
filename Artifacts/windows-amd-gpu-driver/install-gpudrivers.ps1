$ProgressPreference = 'SilentlyContinue'

 $Compute=Invoke-RestMethod -Headers @{"Metadata"="true"} -URI http://169.254.169.254/metadata/instance/compute?api-version=2017-08-01 -Method get
 if ($Compute.vmSize -cnotmatch "Standard_N[C|V]\d")  
 {
    return 'No gpu has to be installed'
 }  


$result = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Azure/azhpc-extensions/master/AmdGPU/resources.json" -ContentType "application/json" 
$link = $result.OS[0].Version[0].Driver[0].DirLink

Invoke-WebRequest -UseBasicParsing -Uri $link -OutFile "$env:TEMP\azuredriver.exe"
& "$env:TEMP\azuredriver.exe"   /S /D=$env:TEMP\AzureDrivers  | Out-Null

