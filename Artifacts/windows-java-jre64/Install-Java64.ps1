

#Download Java JRE 64 bits
$Source = "http://numericalchameleon.net/get_java_win64bit"
$JavaExe = "$env:temp\java.exe"
$OptionFile = "$env:temp\java_options.txt"

(New-Object System.Net.WebClient).DownloadFile($Source, $JavaExe)

$content = @"
INSTALL_SILENT=Enable
AUTO_UPDATE=Enable
REBOOT=Disable
SPONSORS=Disable
REMOVEOUTOFDATEJRES=Enable
"@ ;

# Create options file
Set-Content $OptionFile $content

#Running the java installer
& $JavaExe INSTALLCFG=$OptionFile | Out-Default

