$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.21.102-hotspot"
$env:ANDROID_HOME = "D:\tools\android-sdk"
$env:ANDROID_SDK_ROOT = "D:\tools\android-sdk"
$env:PATH = "D:\tools\flutter\bin;$env:JAVA_HOME\bin;D:\tools\android-sdk\cmdline-tools\latest\bin;D:\tools\android-sdk\platform-tools;$env:PATH"

& "D:\tools\flutter\bin\flutter.bat" @args
