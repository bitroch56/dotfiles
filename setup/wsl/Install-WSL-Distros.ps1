$ErrorActionPreference = 'Continue'

$wslCommand = Get-Command wsl.exe -ErrorAction SilentlyContinue
if (-not $wslCommand) {
    throw 'wsl.exe was not found. Use a supported Windows 11 installation with WSL available.'
}

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run this script from an elevated PowerShell window.'
}

$null = & wsl.exe --status 2>&1
$statusExitCode = $LASTEXITCODE
if ($statusExitCode -ne 0) {
    Write-Host 'Installing the WSL components without a Linux distribution...'
    & wsl.exe --install --no-distribution
    $installExitCode = $LASTEXITCODE

    if ($installExitCode -ne 0) {
        throw "WSL component installation failed with exit code $installExitCode."
    }

    Write-Host 'Restart Windows, then run this script again to install Ubuntu and Kali.'
    exit 0
}

& wsl.exe --update
$updateExitCode = $LASTEXITCODE
if ($updateExitCode -ne 0) {
    throw "WSL update failed with exit code $updateExitCode."
}

& wsl.exe --set-default-version 2
$versionExitCode = $LASTEXITCODE
if ($versionExitCode -ne 0) {
    throw "Could not set WSL 2 as the default with exit code $versionExitCode."
}

$installedOutput = & wsl.exe --list --quiet 2>&1
$listExitCode = $LASTEXITCODE
if ($listExitCode -ne 0) {
    throw "Could not list installed WSL distributions; exit code $listExitCode."
}

$installedDistros = @(
    $installedOutput | ForEach-Object {
        if ($null -ne $_) {
            $_.ToString().Replace(([char]0).ToString(), [string]::Empty).Trim()
        }
    } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
)

foreach ($distro in @('Ubuntu', 'kali-linux')) {
    if ($installedDistros -contains $distro) {
        Write-Host "$distro is already installed."
        continue
    }

    Write-Host "Installing $distro..."
    & wsl.exe --install --distribution $distro --no-launch
    $distroExitCode = $LASTEXITCODE
    if ($distroExitCode -ne 0) {
        throw "Installation of $distro failed with exit code $distroExitCode."
    }
}

Write-Host 'Both distributions are installed. Open each once with "wsl --distribution Ubuntu" and "wsl --distribution kali-linux" to create its Linux user.'
