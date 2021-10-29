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


mkdir HKLM:\Software\Policies\Microsoft\Edge  -Force | out-null
#Stop nagging default browser  
New-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Edge" -name  "DefaultBrowserSettingEnabled" -Value 0 -Force | Out-Null

#hide first run popups
New-ItemProperty -path "HKLM:\Software\Policies\Microsoft\Edge" -name "HideFirstRunExperience" -value 1 -Force | Out-Null
#New-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -name "WelcomePageOnOSUpgradeEnabled" -value 0 -Force | Out-Null

########################################################
#Remove edge what's new page:
#you need to create two files in profile to get rid of it.  

# New-Item -Path "C:\Users\Default\AppData\Local\Microsoft\Edge\" -Name "User Data" -ItemType "directory" -Force

# $content = @"
# { 
#     "browser": {
#         "browser_version_of_last_seen_whats_new": "200"
#     }
# }
# "@   
       
# $content | Out-File "C:\Users\Default\AppData\Local\Microsoft\Edge\User Data\Local State" -Force -Encoding utf8



$content = @"
{
  "bookmark_bar": {
    "show_only_on_ntp": false
  },
  "default_search_provider": {
    "enabled": true,
    "search_url": "www.google.com"
  },
  "browser": {
    "browser_version_of_last_seen_whats_new": "200"
  }
}
"@

$content | Out-File "C:\Program Files (x86)\Microsoft\Edge\Application\initial_preferences"  -Force -Encoding utf8

