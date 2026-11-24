Write-Host "=== Installing Android SDK Components ==="

$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.21.102-hotspot"
$env:ANDROID_HOME = "D:\tools\android-sdk"
$env:ANDROID_SDK_ROOT = "D:\tools\android-sdk"
$env:PATH = "D:\tools\flutter\bin;C:\Program Files\Microsoft\jdk-17.0.21.102-hotspot\bin;D:\tools\android-sdk\cmdline-tools\latest\bin;D:\tools\android-sdk\platform-tools;$env:PATH"

$sdkmanager = "D:\tools\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat"

Write-Host "Installing platform-tools, platforms;android-34, and build-tools;34.0.0..."
# Accept licenses input via standard input
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = $sdkmanager
$processInfo.Arguments = "--sdk_root=D:\tools\android-sdk platform-tools ""platforms;android-34"" ""build-tools;34.0.0"""
$processInfo.UseShellExecute = $false
$processInfo.RedirectStandardInput = $true
$processInfo.RedirectStandardOutput = $true
$processInfo.RedirectStandardError = $true

$proc = [System.Diagnostics.Process]::Start($processInfo)
# Feed 'y' if prompted
$sw = $proc.StandardInput
for ($i = 0; $i -lt 20; $i++) {
    $sw.WriteLine("y")
}
$sw.Flush()

$output = $proc.StandardOutput.ReadToEnd()
$err = $proc.StandardError.ReadToEnd()
$proc.WaitForExit()

Write-Host $output
if ($err) { Write-Host "ERR: $err" }

Write-Host "=== Accepting all Android licenses ==="
$licInfo = New-Object System.Diagnostics.ProcessStartInfo
$licInfo.FileName = $sdkmanager
$licInfo.Arguments = "--sdk_root=D:\tools\android-sdk --licenses"
$licInfo.UseShellExecute = $false
$licInfo.RedirectStandardInput = $true
$licInfo.RedirectStandardOutput = $true
$licInfo.RedirectStandardError = $true

$licProc = [System.Diagnostics.Process]::Start($licInfo)
$licSw = $licProc.StandardInput
for ($i = 0; $i -lt 30; $i++) {
    $licSw.WriteLine("y")
}
$licSw.Flush()
$licOut = $licProc.StandardOutput.ReadToEnd()
$licProc.WaitForExit()
Write-Host $licOut

Write-Host "=== Configuring Flutter ==="
& "D:\tools\flutter\bin\flutter.bat" config --android-sdk "D:\tools\android-sdk"
& "D:\tools\flutter\bin\flutter.bat" doctor -v
