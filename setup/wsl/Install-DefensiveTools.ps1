$ErrorActionPreference = 'Continue'

if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    throw 'wsl.exe was not found. Run Install-WSL-Distros.ps1 first.'
}

$distros = @('Ubuntu', 'kali-linux')
$installedOutput = & wsl.exe --list --quiet 2>&1
$listExitCode = $LASTEXITCODE
if ($listExitCode -ne 0) {
    throw "Could not list WSL distributions; exit code $listExitCode."
}

$installedDistros = @(
    $installedOutput | ForEach-Object {
        if ($null -ne $_) {
            $_.ToString().Replace(([char]0).ToString(), [string]::Empty).Trim()
        }
    } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
)

$missingDistros = @($distros | Where-Object { $installedDistros -notcontains $_ })
if ($missingDistros.Count -gt 0) {
    throw "Install these distributions first: $($missingDistros -join ', ')."
}

$scriptPath = Join-Path $PSScriptRoot 'install-defensive-tools.sh'
if (-not (Test-Path -LiteralPath $scriptPath -PathType Leaf)) {
    throw "Linux tools script not found: $scriptPath"
}

$installFailures = [System.Collections.Generic.List[string]]::new()

foreach ($distro in $distros) {
    $userIdOutput = & wsl.exe --distribution $distro --exec id --user 2>&1
    $userIdExitCode = $LASTEXITCODE
    if ($userIdExitCode -ne 0) {
        throw "Could not check the default user in $distro; exit code $userIdExitCode."
    }

    $userId = ($userIdOutput -join '').Trim()
    if ($userId -eq '0') {
        throw "Open $distro once and create a normal Linux user before installing tools."
    }

    $linuxScriptPathOutput = & wsl.exe --distribution $distro --exec wslpath -a $scriptPath 2>&1
    $pathExitCode = $LASTEXITCODE
    if ($pathExitCode -ne 0) {
        throw "Could not convert the tools script path for $distro; exit code $pathExitCode."
    }

    $linuxScriptPath = ($linuxScriptPathOutput -join '').Trim()
    Write-Host "Installing the defensive analysis baseline in $distro..."
    & wsl.exe --distribution $distro --user root --exec bash $linuxScriptPath
    $installExitCode = $LASTEXITCODE
    if ($installExitCode -ne 0) {
        $installFailures.Add("$distro (exit code $installExitCode)")
    }
}

if ($installFailures.Count -gt 0) {
    throw "Defensive tools installation failed in: $($installFailures -join ', '). Review the package availability details above."
}

Write-Host 'The defensive analysis baseline was installed in Ubuntu and Kali.'
