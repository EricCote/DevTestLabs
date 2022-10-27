$UseLightNotDark = 0


#DarkTheme Apps
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -name AppsUseLightTheme `
    -Value $UseLightNotDark -PropertyType dword `
    -Force | out-null  

#DarkTheme System
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -name SystemUsesLightTheme `
    -Value $UseLightNotDark -PropertyType dword `
    -Force | out-null  



#use accent color with Start, search and taskbar
#0 = Don't use accent
#1 = Show color on Start, taskbar, and action center
#2 = Show color only on taskbar
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -name ColorPrevalence `
    -Value 1 -PropertyType dword `
    -Force | out-null  

#use accent color with title bars
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\DWM" `
    -name ColorPrevalence `
    -Value 1 -PropertyType dword `
    -Force | out-null  



#accent color for title bars,  #format a,b,g,r 
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\DWM" `
    -name AccentColor `
    -Value 0xff6547ea -PropertyType dword `
    -Force | out-null


#accent color with title bars of inactive windows
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\DWM" `
    -name AccentColorInactive `
    -Value 0xff6547ea -PropertyType dword `
    -Force | out-null  



#set accent color for,  #format a,r,g,b 
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\DWM" `
    -name ColorizationAfterglow `
    -Value 0xc4ea4765 -PropertyType dword `
    -Force | out-null
    
#set accent color,  #format a,r,g,b
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\DWM" `
    -name ColorizationColor `
    -Value 0xc4ea4765 -PropertyType dword `
    -Force | out-null



#set accent color for borders #format a,b,g,r 
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" `
    -name AccentColorMenu `
    -Value 0xff6547ea -PropertyType dword `
    -Force | out-null

#set accent for start menu  #format a,b,g,r 
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" `
    -name StartColorMenu `
    -Value 0xff4024c1 -PropertyType dword `
    -Force | out-null

#set accent for start menu
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" `
    -name AccentPalette `
    -Value ([byte[]]( `
            0xf8, 0xaf, 0xc4, 0x00, `
            0xef, 0x8c, 0xa5, 0x00, `
            0xe0, 0x4e, 0x6e, 0x00, `
            0xda, 0x37, 0x59, 0x00, `
            0xc1, 0x24, 0x40, 0x00, `
            0x92, 0x1b, 0x2c, 0x00, `
            0x62, 0x0a, 0x10, 0x00, `
            0x88, 0x17, 0x98, 0x00  ` 
    )) `
    -PropertyType binary `
    -Force | out-null




#Enable Tranparency (Ignored with non-GPU system)
New-ItemProperty -path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -name EnableTransparency `
    -Value 1 -PropertyType dword `
    -Force | out-null  


#Change mouse cursor size
New-ItemProperty -path "HKCU:Control Panel\Cursors" `
    -name CursorBaseSize `
    -Value 70 -PropertyType dword `
    -Force | out-null 

