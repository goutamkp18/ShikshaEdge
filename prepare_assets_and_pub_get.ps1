$dirs = @(
    "D:\ShikshaEdge\android-app\assets\content",
    "D:\ShikshaEdge\android-app\assets\audio\en\mathematics",
    "D:\ShikshaEdge\android-app\assets\audio\kn\mathematics",
    "D:\ShikshaEdge\android-app\assets\audio\en\science",
    "D:\ShikshaEdge\android-app\assets\audio\kn\science",
    "D:\ShikshaEdge\android-app\assets\audio\en\english",
    "D:\ShikshaEdge\android-app\assets\audio\kn\english"
)
foreach ($d in $dirs) {
    if (!(Test-Path $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
    New-Item -ItemType File -Path (Join-Path $d ".gitkeep") -Force | Out-Null
}
Set-Location "D:\ShikshaEdge\android-app"
powershell -ExecutionPolicy Bypass -File "D:\ShikshaEdge\flutter_cmd.ps1" pub get
