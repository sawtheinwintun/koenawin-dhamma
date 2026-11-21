# Renders the launcher icon and native splash PNGs from assets/branding/*.svg with headless Chrome.
# Run from the project root:  powershell -File tools\icons\render_icons.ps1
# Then:                       dart run flutter_launcher_icons; dart run flutter_native_splash:create

$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$page = (Resolve-Path "tools\icons\render.html").Path -replace '\\', '/'
$out = "assets\branding\png"
New-Item -ItemType Directory -Force $out | Out-Null

foreach ($v in @('full', 'fg', 'bg', 'splash')) {
    $size = if ($v -eq 'splash') { 1152 } else { 1024 }
    $file = Join-Path (Resolve-Path $out) "icon_$v.png"
    & $chrome --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files `
        --default-background-color=00000000 --virtual-time-budget=3000 `
        --window-size="$size,$size" --screenshot="$file" "file:///$page`?v=$v" 2>$null | Out-Null
    Write-Output "$v -> $file"
}
