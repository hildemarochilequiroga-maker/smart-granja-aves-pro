$files = Get-ChildItem -Path lib -Recurse -Include *.dart | Where-Object { 
    $content = Get-Content $_.FullName -Raw
    $content -cmatch "([a-zA-Z_])S\.of\(context\)\."
}

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    $content = $content -creplace "([a-zA-Z_])S\.of\(context\)\.", "`$1l."
    Set-Content -Path $f.FullName -Value $content
}

flutter analyze > analyze_out3.txt
Get-Content analyze_out3.txt | Select-Object -First 30