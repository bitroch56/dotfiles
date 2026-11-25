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

$outputPath = Join-Path $PSScriptRoot 'catalogue-applications.md'
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('# Catalogue des applications Windows')
$lines.Add('')
$lines.Add("> Versions et éditeurs relevés dans WinGet le **$(Get-Date -Format 'yyyy-MM-dd')**. WinGet installe la version la plus récente disponible au moment de l'installation ; ce catalogue est un instantané. Relance `.\setup\windows\Export-AppCatalogue.ps1` pour le mettre à jour.")
$lines.Add('')
$lines.Add('Les logos de marque sont utilisés quand ils sont disponibles ; les autres images sont des pictogrammes génériques et non des logos officiels.')
$lines.Add('')

foreach ($category in $catalog.categories) {
    $lines.Add("## $($category.name)")
    $lines.Add('')
    $lines.Add('| Logo / icône | Application | Version WinGet | Éditeur |')
    $lines.Add('|:--:|---|---:|---|')

    foreach ($app in $category.apps) {
        if (-not $app.id -or -not $app.name -or -not $app.logo) {
            throw "Application entry must have name, id, and logo fields: $($app | ConvertTo-Json -Compress)"
        }

        $metadata = & winget show --id $app.id --exact --source winget --output-locale en-US --accept-source-agreements --disable-interactivity 2>&1
        $exitCode = $LASTEXITCODE
        if ($exitCode -ne 0) {
            throw "WinGet could not retrieve metadata for $($app.name) ($($app.id)); exit code: $exitCode. Output: $($metadata -join ' ')"
        }

        $metadataText = $metadata -join [Environment]::NewLine
        $versionMatch = [regex]::Match($metadataText, '(?im)^Version:\s*(.+?)\s*$')
        $publisherMatch = [regex]::Match($metadataText, '(?im)^Publisher:\s*(.+?)\s*$')
        if (-not $versionMatch.Success -or -not $publisherMatch.Success) {
            throw "WinGet metadata for $($app.name) ($($app.id)) did not contain both Version and Publisher fields."
        }

        $name = ([string]$app.name).Replace('|', '\|')
        $version = $versionMatch.Groups[1].Value.Replace('|', '\|')
        $publisher = $publisherMatch.Groups[1].Value.Replace('|', '\|')
        $logo = [string]$app.logo
        $logoCell = '<img src="{0}" alt="{1}" width="28" height="28">' -f $logo, $name
        $lines.Add("| $logoCell | $name | $version | $publisher |")
    }

    $lines.Add('')
}

if ($catalog.manual) {
    $lines.Add('## Installation manuelle et options')
    $lines.Add('')
    $lines.Add('| Catégorie | Application | Installation | Remarque |')
    $lines.Add('|---|---|---|---|')

    foreach ($app in $catalog.manual) {
        if (-not $app.category -or -not $app.name -or -not $app.url -or -not $app.reason) {
            throw "Manual application entry must have category, name, url, and reason fields: $($app | ConvertTo-Json -Compress)"
        }

        $category = ([string]$app.category).Replace('|', '\|')
        $name = ([string]$app.name).Replace('|', '\|')
        $url = [string]$app.url
        $reason = ([string]$app.reason).Replace('|', '\|')
        $lines.Add("| $category | $name | [site officiel]($url) | $reason |")
    }

    $lines.Add('')
}

[System.IO.File]::WriteAllText(
    $outputPath,
    [string]::Join([Environment]::NewLine, $lines) + [Environment]::NewLine,
    [System.Text.UTF8Encoding]::new($false)
)

Write-Host "Application catalog written to $outputPath"
