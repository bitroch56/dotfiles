$ErrorActionPreference = 'Stop'

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw 'winget was not found. Install or update App Installer from the Microsoft Store, then run this script again.'
}

$catalogPath = Join-Path $PSScriptRoot 'apps-windows.json'
if (-not (Test-Path -LiteralPath $catalogPath -PathType Leaf)) {
    throw "Application catalog not found: $catalogPath"
}

$catalog = Get-Content -LiteralPath $catalogPath -Raw -Encoding UTF8 | ConvertFrom-Json
if (-not $catalog.categories) {
    throw "Application catalog has no categories: $catalogPath"
}

$failures = [System.Collections.Generic.List[string]]::new()

foreach ($category in $catalog.categories) {
    Write-Host "`n=== $($category.name) ===" -ForegroundColor Cyan

    foreach ($app in $category.apps) {
        Write-Host "`nInstallation de $($app.name) ($($app.id))..."
        & winget install --id $app.id --exact --source winget --accept-package-agreements --accept-source-agreements
        $exitCode = $LASTEXITCODE

        if ($exitCode -ne 0) {
            $failures.Add("$($app.name) ($($app.id)) : code de sortie $exitCode")
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Host "`nÉchecs d'installation :" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host " - $failure" -ForegroundColor Red
    }
    exit 1
}

Write-Host "`nAll WinGet installations completed without errors." -ForegroundColor Green
