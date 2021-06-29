Set-Location c:\  | Out-File C:\wow\out.txt

git clone https://github.com/EricCote/SSRS_Samples.git  | Out-File C:\wow\out.txt -append

Set-Location c:\SSRS_Samples | Out-File C:\wow\out.txt -append

& .\install-reports.ps1 | Out-File C:\wow\out.txt -append
