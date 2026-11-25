param(
    [Parameter(Mandatory = $true)][string]$SelectionPath,
    [Parameter(Mandatory = $true)][string]$EventPath,
    [Parameter(Mandatory = $true)][string]$StopPath
)

$ErrorActionPreference = 'Stop'
$writer = [System.IO.StreamWriter]::new($EventPath, $false, [System.Text.UTF8Encoding]::new($false))
$writer.AutoFlush = $true

function Send-Event {
    param([string]$Type, [string]$Id, [string]$State, [string]$Message)
    $writer.WriteLine((@{ type = $Type; id = $Id; state = $State; message = $Message } | ConvertTo-Json -Compress))
}

function Invoke-CommandStep {
    param([string]$File, [string[]]$Arguments, [string]$Id)
    try {
        & $File @Arguments 2>&1 | ForEach-Object {
            $line = $_.ToString().Trim()
            if ($line) { Send-Event -Type 'log' -Id $Id -Message $line }
        }
        return $LASTEXITCODE
    }
    catch {
        Send-Event -Type 'log' -Id $Id -Message $_.Exception.Message
        return 1
    }
}

try {
    $selection = Get-Content -LiteralPath $SelectionPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $catalogPath = Join-Path $PSScriptRoot 'windows\apps-windows.json'
    $catalog = Get-Content -LiteralPath $catalogPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $knownApps = @{}
    foreach ($category in $catalog.categories) {
        foreach ($app in $category.apps) { $knownApps[[string]$app.id] = [string]$app.name }
    }

    $items = @($selection.items)
    $wslState = 'not-selected'
    foreach ($item in $items) {
        $id = [string]$item.id
        if (Test-Path -LiteralPath $StopPath) {
            Send-Event -Type 'status' -Id $id -State 'skipped' -Message 'Arrêt demandé'
            continue
        }

        if ($id -eq 'tools' -and $wslState -in @('failed', 'restart')) {
            Send-Event -Type 'status' -Id $id -State 'skipped' -Message 'Terminer WSL avant les outils'
            continue
        }

        Send-Event -Type 'status' -Id $id -State 'running' -Message 'Installation en cours'
        $code = 1
        if ($id.StartsWith('app:')) {
            $packageId = $id.Substring(4)
            if (-not $knownApps.ContainsKey($packageId)) {
                Send-Event -Type 'status' -Id $id -State 'failed' -Message 'Paquet absent du catalogue'
                continue
            }
            if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
                Send-Event -Type 'status' -Id $id -State 'failed' -Message 'WinGet introuvable : installer App Installer'
                continue
            }
            $code = Invoke-CommandStep -File 'winget.exe' -Id $id -Arguments @(
                'install', '--id', $packageId, '--exact', '--source', 'winget',
                '--accept-package-agreements', '--accept-source-agreements',
                '--disable-interactivity', '--silent'
            )
        }
        elseif ($id -eq 'wsl' -or $id -eq 'tools') {
            $scriptName = if ($id -eq 'wsl') { 'Install-WSL-Distros.ps1' } else { 'Install-DefensiveTools.ps1' }
            $scriptPath = Join-Path $PSScriptRoot "wsl\$scriptName"
            $code = Invoke-CommandStep -File 'powershell.exe' -Id $id -Arguments @(
                '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $scriptPath
            )
        }
        else {
            Send-Event -Type 'status' -Id $id -State 'failed' -Message 'Étape inconnue'
            continue
        }

        if ($id -eq 'wsl') {
            $wslState = if ($code -eq 10) { 'restart' } elseif ($code -eq 0) { 'done' } else { 'failed' }
        }
        if ($code -eq 10 -and $id -eq 'wsl') {
            Send-Event -Type 'status' -Id $id -State 'restart' -Message 'Redémarrer Windows, puis relancer'
        }
        elseif ($code -eq 0) {
            Send-Event -Type 'status' -Id $id -State 'done' -Message 'Terminé'
        }
        else {
            Send-Event -Type 'status' -Id $id -State 'failed' -Message "Échec (code $code) — voir le journal"
        }
    }
    Send-Event -Type 'finished' -Message 'Exécution terminée'
}
catch {
    Send-Event -Type 'fatal' -Message $_.Exception.Message
    exit 1
}
finally {
    $writer.Dispose()
}
