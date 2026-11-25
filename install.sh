#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
packages_file="$repo_dir/packages/arch-explicit.txt"
sway_source="$repo_dir/config/sway"
sway_target="$HOME/.config/sway"
emacs_source="$repo_dir/config/emacs/init.el"
emacs_target="$HOME/.config/emacs/init.el"

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

    link_config() {
        local source="$1" target="$2"
        if [[ -L "$target" ]] && [[ "$(readlink -f -- "$target")" == "$source" ]]; then
            echo "Config already linked: $target"
            return
        fi
        if [[ -e "$target" || -L "$target" ]]; then
            local backup="$target.backup-$(date +%Y%m%d-%H%M%S)"
            mv -- "$target" "$backup"
            echo "Saved previous config as $backup"
        fi
        ln -s -- "$source" "$target"
        echo "Linked $target to $source"
    }

    link_config "$sway_source" "$sway_target"
    mkdir -p "$HOME/.config/emacs"
    link_config "$emacs_source" "$emacs_target"
fi
