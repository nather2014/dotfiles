#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_dir"

if ! command -v pacman >/dev/null 2>&1 || ! command -v systemctl >/dev/null 2>&1; then
    echo "Auto-sync setup requires EndeavourOS and systemd." >&2
    exit 1
fi

if [[ "$(git branch --show-current)" != "main" ]]; then
    echo "Check out the main branch before enabling auto-sync." >&2
    exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
    echo "Commit or discard local changes before enabling auto-sync." >&2
    exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
    git remote add origin https://github.com/nather2014/dotfiles.git
fi

git fetch origin main

if ! git merge-base --is-ancestor HEAD origin/main; then
    if git merge-base --is-ancestor origin/main HEAD; then
        git merge --ff-only origin/main
    elif [[ "$(git rev-parse HEAD^{tree})" == "$(git rev-parse origin/main^{tree})" ]]; then
        git reset --hard origin/main
    else
        echo "Local main and origin/main have different changes; reconcile them first." >&2
        exit 1
    fi
fi

git branch --set-upstream-to=origin/main main
git config --local user.name "Akhilnath"
git config --local user.email "7021535+nather2014@users.noreply.github.com"

sudo pacman -S --needed inotify-tools

service_dir="$HOME/.config/systemd/user"
mkdir -p "$service_dir"
cat > "$service_dir/dotfiles-autosync.service" <<UNIT
[Unit]
Description=Automatically commit and sync dotfiles to GitHub
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/bash "$repo_dir/autosync.sh"
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
UNIT

systemctl --user daemon-reload
systemctl --user enable --now dotfiles-autosync.service
echo "Auto-sync is enabled. Check it with: systemctl --user status dotfiles-autosync.service"
