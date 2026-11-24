Get-ChildItem 'C:\Users\gouta\.gradle\daemon' -Recurse -Filter '*.log' | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | ForEach-Object { 
    Write-Host "Log file: $($_.FullName)"
    Get-Content $_.FullName -Tail 25
}
