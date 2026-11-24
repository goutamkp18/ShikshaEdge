$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.21.102-hotspot"
$env:ANDROID_HOME = "D:\tools\android-sdk"
$env:ANDROID_SDK_ROOT = "D:\tools\android-sdk"
$env:PATH = "D:\tools\flutter\bin;C:\Program Files\Microsoft\jdk-17.0.21.102-hotspot\bin;D:\tools\android-sdk\cmdline-tools\latest\bin;D:\tools\android-sdk\platform-tools;$env:PATH"

$sdkmanager = "D:\tools\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat"
Write-Host "Installing platforms;android-36 and build-tools..."
# Pass 'y' in case of license prompt
$proc = Start-Process -FilePath $sdkmanager -ArgumentList "--sdk_root=D:\tools\android-sdk", "platforms;android-36", "build-tools;36.0.0", "build-tools;34.0.0" -NoNewWindow -Wait -PassThru

Write-Host "Accepting licenses..."
$licInfo = New-Object System.Diagnostics.ProcessStartInfo
$licInfo.FileName = $sdkmanager
$licInfo.Arguments = "--sdk_root=D:\tools\android-sdk --licenses"
$licInfo.UseShellExecute = $false
$licInfo.RedirectStandardInput = $true
$licInfo.RedirectStandardOutput = $true
$licProc = [System.Diagnostics.Process]::Start($licInfo)
$licSw = $licProc.StandardInput
for ($i = 0; $i -lt 20; $i++) {
    $licSw.WriteLine("y")
}
$licSw.Flush()
$licProc.WaitForExit()

Write-Host "Running flutter doctor..."
& "D:\tools\flutter\bin\flutter.bat" doctor -v
