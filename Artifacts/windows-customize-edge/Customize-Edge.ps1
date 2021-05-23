$edgeEnterpriseMSIUri = 'https://edgeupdates.microsoft.com/api/products?view=enterprise'


$response = Invoke-WebRequest -Uri $edgeEnterpriseMSIUri -Method Get -ContentType "application/json" -UseBasicParsing -ErrorVariable InvokeWebRequestError
$jsonObj = ConvertFrom-Json $([String]::new($response.Content));

$selectedIndex = [array]::indexof($jsonObj.Product, "Stable");

$LatestEdgeUrl = ($jsonObj[$selectedIndex].Releases | `
            Where-Object { $_.Architecture -eq "x64" -and $_.Platform -eq "Windows"}  | `
        Sort-Object $_.ReleaseId -Descending)[0].Artifacts[0].Location;


#download edge
Invoke-WebRequest -Uri $LatestEdgeUrl -OutFile "$env:temp\edge.msi" -UseBasicParsing;

#install edge
msiexec /q /i "$env:temp\edge.msi"  ALLUSERS=1;



mkdir HKLM:\Software\Policies\Microsoft\Edge 

#hide first run popups
New-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Edge" -name "HideFirstRunExperience" -value 1
#Stop nagging default browser  
New-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Edge" -name  "DefaultBrowserSettingEnabled" -Value 0


