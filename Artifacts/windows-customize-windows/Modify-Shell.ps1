

# Refresh Desktop Ability
$Code = @'

[DllImport("shell32.dll")]
static extern void SHGetSetSettings (ref SHELLSTATE lpss, SSF dwMask, bool bSet);

[StructLayout(LayoutKind.Sequential)]
public struct SHELLSTATE {
    public uint flags_1;
    public uint dwWin95Unused;
    public uint uWin95Unused;
    public int  lParamSort;
    public int  iSortDirection;
    public uint version;
    public uint uNotUsed;
    public uint flags_2;

    public bool fShowAllObjects {
        get {return (flags_1 & 0x00000001u) == 0x00000001u;}
        set {if (value) {flags_1 |= 0x00000001u;} else {flags_1 &= ~0x00000001u;}}
    }
    public bool fShowExtensions {
        get {return (flags_1 & 0x00000002u) == 0x00000002u;}
        set {if (value) {flags_1 |= 0x00000002u;} else {flags_1 &= ~0x00000002u;}}
    }
    //...
}

[Flags]
public enum SSF : uint {
    SSF_SHOWALLOBJECTS       = 0x00000001,
    SSF_SHOWEXTENSIONS       = 0x00000002,
    // ...
}

public static void showExtensions(){
    SHELLSTATE ss = new SHELLSTATE();
    ss.fShowExtensions=true;
    SHGetSetSettings(ref ss, SSF.SSF_SHOWEXTENSIONS, true);
}

'@ ;


Add-Type -MemberDefinition $Code -Namespace WinAPI -Name Explore;

# Refresh desktop icons
[WinAPI.Explore]::showExtensions();