$files = Get-ChildItem -Path lib -Recurse -Include *.dart
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

foreach ($f in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    
    # Check if there is BOM, if so remove it.
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $text = [System.Text.Encoding]::UTF8.GetString($bytes, 3, $bytes.Length - 3)
        [System.IO.File]::WriteAllText($f.FullName, $text, $utf8NoBom)
        Write-Host "Removed BOM and saved as UTF-8 for $($f.Name)"
        continue
    }

    # Check if it's valid UTF8. We can try to decode.
    $isValidUtf8 = $true
    try {
        $decoder = [System.Text.Encoding]::UTF8.GetDecoder()
        $decoder.Fallback = [System.Text.DecoderExceptionFallback]::new()
        $null = $decoder.GetCharCount($bytes, 0, $bytes.Length)
    } catch {
        $isValidUtf8 = $false
    }

    if (-not $isValidUtf8) {
        # It's likely ANSI (Windows-1252), read as Default, write as UTF-8
        $text = [System.Text.Encoding]::Default.GetString($bytes)
        [System.IO.File]::WriteAllText($f.FullName, $text, $utf8NoBom)
        Write-Host "Converted from ANSI to UTF-8 for $($f.Name)"
    }
}
