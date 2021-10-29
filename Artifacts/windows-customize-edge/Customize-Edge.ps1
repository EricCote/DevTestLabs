$ProgressPreference = 'SilentlyContinue'
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
msiexec /q /i "$env:temp\edge.msi"  ALLUSERS=1 | out-null


$PolPath = "HKLM:\Software\Policies\Microsoft\Edge"

mkdir $PolPath  -Force | out-null
#Stop nagging default browser  
New-ItemProperty -path $PolPath -name  "DefaultBrowserSettingEnabled" -Value 0 -Force | Out-Null

#hide first run popups
New-ItemProperty -path $PolPath -name "HideFirstRunExperience" -value 1 -Force | Out-Null

#specify search engine
New-ItemProperty -path "$PolPath/Recommended" -name "DefaultSearchProviderEnabled" -value 1 -Force | Out-Null
New-ItemProperty -path "$PolPath/Recommended" -name "DefaultSearchProviderSearchURL" -value "{google:baseURL}search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}ie={inputEncoding}" -Force | Out-Null
New-ItemProperty -path "$PolPath/Recommended" -name "DefaultSearchProviderName" -value "Google" -Force | Out-Null
New-ItemProperty -path "$PolPath/Recommended" -name "DefaultSearchProviderSuggestURL" -value "{google:baseURL}complete/search?output=chrome&q={searchTerms}" -Force | Out-Null

########################################################
#Remove edge what's new page:
#  
New-Item -Path "C:\Users\Default\AppData\Local\Microsoft\Edge\" -Name "User Data" -ItemType "directory" -Force

$content = @"
{ 
    "browser": {
        "browser_version_of_last_seen_whats_new": "200"
    }
}
"@   
       
$content | Out-File "C:\Users\Default\AppData\Local\Microsoft\Edge\User Data\Local State" -Force -Encoding utf8


# hide favorite bar, even on the new tab page. 
$content = @"
{
  "bookmark_bar": {
    "show_only_on_ntp": false
  }
}
"@

$content | Out-File "C:\Program Files (x86)\Microsoft\Edge\Application\initial_preferences"  -Force -Encoding utf8

$content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Enrollments\FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF] 
"EnrollmentState"=dword:00000001 
"EnrollmentType"=dword:00000000 
"IsFederated"=dword:00000000
 
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF]
"Flags"=dword:00d6fb7f
"AcctUId"="0x000000000000000000000000000000000000000000000000000000000000000000000000"
"RoamingCount"=dword:00000000
"SslClientCertReference"="MY;User;0000000000000000000000000000000000000000"
"ProtoVer"="1.2"
"@

$content | Out-File "$env:temp\fake-mdm.reg"  -Force -Encoding utf8

& reg import "$env:temp\fake-mdm.reg" | out-null
