#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
packages_file="$repo_dir/packages/arch-explicit.txt"
sway_source="$repo_dir/config/sway"
sway_target="$HOME/.config/sway"

if [[ "${1:-}" != "--config-only" ]]; then
    if ! command -v pacman >/dev/null 2>&1; then
        echo "This package list is for EndeavourOS (pacman)." >&2
        exit 1
    fi

    mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' "$packages_file")
    if ((${#packages[@]})); then
        sudo pacman -Syu --needed "${packages[@]}"
    fi
fi

if [[ "${1:-}" != "--packages-only" ]]; then
    mkdir -p "$HOME/.config"

    if [[ -L "$sway_target" ]] && [[ "$(readlink -f -- "$sway_target")" == "$sway_source" ]]; then
        echo "Sway config already points to this repository."
        exit 0
    fi

    if [[ -e "$sway_target" || -L "$sway_target" ]]; then
        backup="$sway_target.backup-$(date +%Y%m%d-%H%M%S)"
        mv -- "$sway_target" "$backup"
        echo "Saved the previous Sway config as $backup"
    fi

    ln -s -- "$sway_source" "$sway_target"
    echo "Linked Sway config to $sway_source"
fi
