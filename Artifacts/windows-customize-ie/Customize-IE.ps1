          
$main="hklm:\Software\Policies\Microsoft\Internet Explorer\Main" 
$Zone="hklm:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones"

New-Item -Path $main -Force
New-ItemProperty -Path $main -Name "DisableFirstRunCustomize"  -Value 1 -PropertyType Dword 


$ext = "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext"
$clsid = "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID"

New-Item -Path $clsid -Force
New-ItemProperty -Path $ext -Name "ListBox_Support_CLSID"  -Value 1 -PropertyType Dword 
New-ItemProperty -Path $clsid -Name "{31D09BA0-12F5-4CCE-BE8A-2923E76605DA}"  -Value "1"



#for($i=0; $i -le 4; $i++)
#{
#New-Item -Path "$zone\$i" -Force
#New-ItemProperty -Path "$zone\$i" -Name "1208"  -Value 0 -PropertyType Dword 
#}

#remove-item -path "$zone" -force -recurse

