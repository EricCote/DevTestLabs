$ProgressPreference = 'SilentlyContinue'

wsl.exe --update --web-download  | out-default


Restart-Computer
