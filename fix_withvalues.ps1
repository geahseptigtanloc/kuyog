Get-ChildItem -Path 'c:\flutter_projects\kuyog\lib' -Recurse -Filter '*.dart' | ForEach-Object {
    $f = $_.FullName
    $c = Get-Content $f -Raw
    if ($c -match 'withValues') {
        $c -replace '\.withValues\(alpha: ', '.withOpacity(' | Set-Content $f -NoNewline
        Write-Host "Fixed: $f"
    }
}
