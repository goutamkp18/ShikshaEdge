Write-Host "=== Setting up ShikshaEdge Development Environment ==="

$toolsDir = "D:\tools"
$sdkDir = "D:\tools\android-sdk"
$flutterDir = "D:\tools\flutter"
$jdkDir = "C:\Program Files\Microsoft\jdk-17.0.21.102-hotspot"

# 1. Create directories
if (!(Test-Path $toolsDir)) {
    New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null
}
if (!(Test-Path $sdkDir)) {
    New-Item -ItemType Directory -Path $sdkDir -Force | Out-Null
}

# 2. Download Android cmdline-tools with curl (much faster than Invoke-WebRequest)
$cmdlineLatestDir = "$sdkDir\cmdline-tools\latest"
if (!(Test-Path "$cmdlineLatestDir\bin\sdkmanager.bat")) {
    Write-Host "Downloading Android Command-line tools with curl..."
    $zipPath = "$toolsDir\commandlinetools.zip"
    $url = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
    
    & curl.exe -L -o $zipPath $url
    Write-Host "Extracting Command-line tools..."
    
    $tempExtract = "$toolsDir\cmdline_temp"
    if (Test-Path $tempExtract) { Remove-Item -Recurse -Force $tempExtract }
    
    # Use tar.exe (fast native Windows tool) to extract zip
    New-Item -ItemType Directory -Path $tempExtract -Force | Out-Null
    & tar.exe -xf $zipPath -C $tempExtract
    
    $targetParent = "$sdkDir\cmdline-tools"
    if (!(Test-Path $targetParent)) { New-Item -ItemType Directory -Path $targetParent -Force | Out-Null }
    if (Test-Path $cmdlineLatestDir) { Remove-Item -Recurse -Force $cmdlineLatestDir }
    Move-Item "$tempExtract\cmdline-tools" $cmdlineLatestDir -Force
    Remove-Item -Recurse -Force $tempExtract
    Remove-Item -Force $zipPath
    Write-Host "Android Command-line tools installed at $cmdlineLatestDir"
} else {
    Write-Host "Android Command-line tools already installed."
}

# 3. Clone Flutter SDK with git
if (!(Test-Path "$flutterDir\bin\flutter.bat")) {
    Write-Host "Cloning Flutter stable SDK..."
    & git clone --depth 1 -b stable https://github.com/flutter/flutter.git $flutterDir
    Write-Host "Flutter SDK cloned successfully."
} else {
    Write-Host "Flutter SDK already exists."
}

# 4. Configure Environment Variables permanently for CurrentUser
Write-Host "Configuring Environment Variables..."
[Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkDir, "User")
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $sdkDir, "User")
[Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $sdkDir, "User")

$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathsToAdd = @(
    "$flutterDir\bin",
    "$jdkDir\bin",
    "$cmdlineLatestDir\bin",
    "$sdkDir\platform-tools"
)

$updatedPath = $currentPath
foreach ($p in $pathsToAdd) {
    if ($updatedPath -notlike "*$p*") {
        $updatedPath = "$p;$updatedPath"
    }
}
[Environment]::SetEnvironmentVariable("Path", $updatedPath, "User")
Write-Host "Environment variables configured successfully."
