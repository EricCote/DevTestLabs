# This script does 2 things:
# exit start menu after first start
# deletes the Teams icon from the desktop

Add-Type  @"
 using System;
 using System.Runtime.InteropServices;
 using System.Text;
public class APIFuncs
   {
    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
   public static extern int GetWindowText(IntPtr hwnd,StringBuilder
lpString, int cch);
    [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
   public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
       public static extern Int32 GetWindowThreadProcessId(IntPtr hWnd,out
Int32 lpdwProcessId);
    [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
       public static extern Int32 GetWindowTextLength(IntPtr hWnd);
    }
"@

$wshell = New-Object -ComObject wscript.shell;


$seconds=60
$sb="" 
while(($sb.ToString() -ne "Search") -and ($seconds -gt 0))
{
$w = [apifuncs]::GetForegroundWindow()
$len = [apifuncs]::GetWindowTextLength($w)
$sb = New-Object text.stringbuilder -ArgumentList ($len + 1)
$null = [apifuncs]::GetWindowText($w,$sb,$sb.Capacity)
write-host "Window Title: $($sb.tostring())  $seconds"
Start-Sleep 1
$seconds -=1
} 
if ($seconds -gt 0)
{
    $wshell.SendKeys("{ESC}")
    "still had $seconds when we dismissed start menu"
} else {
    "Timeout of start menu"
}


$seconds = 60
While ( -not (test-path "$env:USERPROFILE\desktop\Microsoft Teams.lnk") -and ($seconds -gt 0)) {
    Start-Sleep 1
    $seconds -= 1
}

if ($seconds -gt 0)
{
    remove-item "$env:USERPROFILE\desktop\Microsoft Teams.lnk" -force
        "still had $seconds when we deleted teams icon on desktop"
}  else
{
    "Timeout of teams link"
}
