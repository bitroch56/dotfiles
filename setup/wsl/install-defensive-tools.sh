#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    printf 'Run this installer as root through the WSL setup script.\n' >&2
    exit 1
fi

if [[ ! -r /etc/os-release ]]; then
    printf 'Cannot identify this Linux distribution.\n' >&2
    exit 1
fi

source /etc/os-release

packages=(
    git
    python3
    python3-venv
    yara
    sleuthkit
    tshark
    volatility3
    binwalk
    libimage-exiftool-perl
    jq
    file
)

if [[ "${ID:-}" == "kali" ]]; then
    packages+=(ghidra)
elif [[ "${ID:-}" != "ubuntu" ]]; then
    printf 'Unsupported distribution: %s\n' "${ID:-unknown}" >&2
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update

available=()
missing=()
for package in "${packages[@]}"; do
    candidate="$(apt-cache policy "$package" 2>/dev/null | sed -n 's/^  Candidate: //p')"
    if [[ -n "${candidate}" && "${candidate}" != "(none)" ]]; then
        available+=("$package")
    else
        missing+=("$package")
    fi
done

if [[ "${#missing[@]}" -gt 0 ]]; then
    printf 'Unavailable in the configured %s repositories: %s\n' \
        "${ID}" "${missing[*]}" >&2
fi

if [[ "${#available[@]}" -eq 0 ]]; then
    printf 'No analysis packages are available to install.\n' >&2
    exit 1
fi

apt-get install --yes --no-install-recommends "${available[@]}"
printf 'Installed in %s: %s\n' "${ID}" "${available[*]}"

if [[ "${#missing[@]}" -gt 0 ]]; then
    exit 2
fi
