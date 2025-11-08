
# https://oofhours.com/2021/10/27/customize-the-windows-11-start-menu/

# To list apps ids
# run:  shell:Appsfolder
#and then group by "App User Model ID" (AUMId)

$currentDevice = "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device"
$defaultDevice = "HKLM:\SOFTWARE\Microsoft\PolicyManager\providers\B5292708-1619-419B-9923-E5D9F3925E71\default\device"

$json = Get-Content -Path ".\LayoutModification.json" -Raw

New-Item -Path $currentDevice -Name Start -Force | Out-Null


New-Item -Path $defaultDevice -Name Start -Force | Out-Null


New-ItemProperty -path "$currentDevice\Start" -name "ConfigureStartPins_ProviderSet" -value 1 -Force | Out-Null
New-ItemProperty -path "$currentDevice\Start" -name "ConfigureStartPins_WinningProvider" -value "B5292708-1619-419B-9923-E5D9F3925E71" -Force | Out-Null


New-ItemProperty -path "$defaultDevice\Start" -name "ConfigureStartPins_LastWrite" -value 1 -Force | Out-Null
New-ItemProperty -path "$defaultDevice\Start" -name "ConfigureStartPins" -value $json -PropertyType String -Force | Out-Null
New-ItemProperty -path "$currentDevice\Start" -name "ConfigureStartPins" -value $json -PropertyType String  -Force | Out-Null

# set taskbar
mkdir c:\programData\script -Force | out-null
Copy-Item ./taskbar.xml c:\ProgramData\script\taskbar.xml | out-null

mkdir 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Force | out-null
Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
    -name "StartLayoutFile" `
    -value "C:\ProgramData\script\taskbar.xml" `
    -force | out-null;
Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
    -name "ReapplyStartLayoutEveryLogon" `
    -value 1 -Force | out-null;
Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
    -name "LockedStartLayout" `
    -value 1 -Force | out-null;

                 

# The following is a temp fix
#$file = Get-Content -Path "C:\Program Files\Azure Data Studio\azuredatastudio.VisualElementsManifest.xml" -Raw
#$file -replace 'Code - OSS', 'Azure Data Studio' | Set-Content -Path  "C:\Program Files\Azure Data Studio\azuredatastudio.VisualElementsManifest.xml"
