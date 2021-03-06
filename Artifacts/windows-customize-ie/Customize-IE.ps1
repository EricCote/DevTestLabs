
$main="hklm:\Software\Policies\Microsoft\Internet Explorer\Main"
#Disable first run questions
New-Item -Path $main -Force
New-ItemProperty -Path $main -Name "DisableFirstRunCustomize"  -Value 1 -PropertyType Dword 


# allows to manage a list of add-ons to be allowed or denied by Internet Explorer.
New-ItemProperty -Path "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext" `
                -Name "ListBox_Support_CLSID"  -Value 1 -PropertyType Dword 


$clsid = "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID"
New-Item -Path $clsid -Force

#allows extension "Lync Browser Helper, Skype for Business Browser Helper"
New-ItemProperty -Path $clsid -Name "{31D09BA0-12F5-4CCE-BE8A-2923E76605DA}"  -Value 1

#allows extension "IEToEdge BHO (redirects modern sites to Edge)"
New-ItemProperty -Path $clsid -Name "{1FD49718-1D00-4B19-AF5F-070AF6D5D54C}"  -value 1

#1208: ActiveX controls and plug-ins: Allow previously unused ActiveX controls to run without prompt

#$Zone="hklm:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones"
#for($i=0; $i -le 4; $i++)
#{
#New-Item -Path "$zone\$i" -Force
#New-ItemProperty -Path "$zone\$i" -Name "1208"  -Value 0 -PropertyType Dword 
#}

#remove-item -path "$zone" -force -recurse

