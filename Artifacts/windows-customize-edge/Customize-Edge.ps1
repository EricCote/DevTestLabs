[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'

$edgeEnterpriseMSIUri = 'https://edgeupdates.microsoft.com/api/products?view=enterprise'


$response = Invoke-WebRequest -Uri $edgeEnterpriseMSIUri -Method Get -ContentType "application/json" -UseBasicParsing -ErrorVariable InvokeWebRequestError
$jsonObj = ConvertFrom-Json $([String]::new($response.Content));

$selectedIndex = [array]::indexof($jsonObj.Product, "Stable");

$LatestEdge = ($jsonObj[$selectedIndex].Releases | `
                Where-Object { $_.Architecture -eq "x64" -and $_.Platform -eq "Windows" }  | `
                Sort-Object { $_.ReleaseId } -Descending )[0];
        
        
$LatestEdgeUrl = $LatestEdge.Artifacts[0].Location;

#download edge
Invoke-WebRequest -Uri $LatestEdgeUrl -OutFile "$env:temp\edge.msi" -UseBasicParsing;


$PolPath = "HKLM:\Software\Policies\Microsoft\Edge"
$UpPath = "HKLM:\Software\Policies\Microsoft\EdgeUpdate"

New-Item -Type Directory -Path "$PolPath\Recommended"  -Force | out-null
New-Item -Type Directory -Path $UpPath  -Force | out-null

#Stop nagging default browser  
New-ItemProperty -path $PolPath -name  "DefaultBrowserSettingEnabled" -Value 0 -Force | Out-Null

#hide first run popups
New-ItemProperty -path $PolPath -name "HideFirstRunExperience" -value 1 -Force | Out-Null

# Disable Favorites Bar (looks ugly on default page)
New-ItemProperty -path $PolPath -name "FavoritesBarEnabled" -value 0 -Force | Out-Null

#specify search engine
New-ItemProperty -path "$PolPath\Recommended" -name "DefaultSearchProviderEnabled" -value 1 -Force | Out-Null
New-ItemProperty -path "$PolPath\Recommended" -name "DefaultSearchProviderSearchURL" -value "https://www.google.com/search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}ie={inputEncoding}" -Force | Out-Null
New-ItemProperty -path "$PolPath\Recommended" -name "DefaultSearchProviderName" -value "Google" -Force | Out-Null
New-ItemProperty -path "$PolPath\Recommended" -name "DefaultSearchProviderSuggestURL" -value "https://www.google.com/complete/search?output=chrome&q={searchTerms}" -Force | Out-Null
New-ItemProperty -path $UpPath -name "CreateDesktopShortcutDefault" -value 0 -Force | Out-Null
#New-ItemProperty -path $UpPath -name "CreateDesktopShortcut" -value 0 -Force | Out-Null

#install edge
& msiexec /q /i "$env:temp\edge.msi"  ALLUSERS=1 DONOTCREATEDESKTOPSHORTCUT=1 | out-null

Remove-Item -Path "$env:temp\edge.msi" -Force

Get-ChildItem -Path "C:\Users\Public\Desktop" -Name "Microsoft Edge.lnk"

#Remove-Item -Path "C:\Users\Public\Desktop\Microsoft Edge.lnk" -Force
 

### remove the "Edge Sign In Required" policy from the windows "cloud" version
#Remove-ItemProperty -path "HKCU:\Software\Policies\Microsoft\Edge" -name "BrowserSignin" 


########################################################
#1 Hide favorite bar, even on the new tab page. 
#2 Remove edge what's new page
#  


#$LatestEdgeVersion=($LatestEdge.ProductVersion  -split '\.')[0];

# $content = @"
# { 
#     "browser": {
#         "browser_version_of_last_seen_whats_new": "$LatestEdgeVersion"
#     },
#     "bookmark_bar": {
#       "show_only_on_ntp": false
#     }
# }
# "@   

# $content="{}";

# $content | Out-File "C:\Program Files (x86)\Microsoft\Edge\Application\initial_preferences"
      
# New-Item -Path "C:\Users\Default\AppData\Local\Microsoft\Edge\" -Name "User Data" -ItemType "directory" -Force
# $content | Out-File "C:\Users\Default\AppData\Local\Microsoft\Edge\User Data\Local State" -Force -Encoding utf8



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

$content -replace '\n', "`r`n" | Out-File "$env:temp\fake-mdm.reg"  -Force -Encoding unicode 

& reg import "$env:temp\fake-mdm.reg" | out-null

Remove-Item -Path "$env:temp\fake-mdm.reg" -Force
