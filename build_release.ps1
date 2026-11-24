$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.21.102-hotspot"
$env:ANDROID_HOME = "D:\tools\android-sdk"
$env:ANDROID_SDK_ROOT = "D:\tools\android-sdk"
$env:PATH = "D:\tools\flutter\bin;$env:JAVA_HOME\bin;D:\tools\android-sdk\cmdline-tools\latest\bin;D:\tools\android-sdk\platform-tools;$env:PATH"

Set-Location "D:\ShikshaEdge\android-app\android"
Write-Host "Stopping Gradle daemons..."
& ".\gradlew.bat" --stop

Set-Location "D:\ShikshaEdge\android-app"
if (Test-Path "build") {
    Write-Host "Cleaning build directory..."
    Remove-Item -Recurse -Force "build" -ErrorAction SilentlyContinue
}

Write-Host "Building release APK..."
& "D:\tools\flutter\bin\flutter.bat" build apk --release
