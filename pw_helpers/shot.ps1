param([string]$Out)
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinApi {
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
  public struct RECT { public int L; public int T; public int R; public int B; }
}
"@
[WinApi]::SetProcessDPIAware() | Out-Null
Start-Sleep -Milliseconds 600
$h = [WinApi]::GetForegroundWindow()
$r = New-Object WinApi+RECT
[WinApi]::GetWindowRect($h, [ref]$r) | Out-Null
$x = $r.L; $y = $r.T; $w = $r.R - $r.L; $hh = $r.B - $r.T
if ($w -lt 200 -or $hh -lt 150) {
  $b = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
  $x = $b.X; $y = $b.Y; $w = $b.Width; $hh = $b.Height
}
$bmp = New-Object System.Drawing.Bitmap $w, $hh
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($x, $y, 0, 0, $bmp.Size)
$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
