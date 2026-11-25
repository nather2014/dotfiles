#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source_file="$repo_dir/config/emacs/init.el"
target_dir="$HOME/.config/emacs"
target_file="$target_dir/init.el"

if ! command -v pacman >/dev/null 2>&1; then
    echo "This setup script requires EndeavourOS or another pacman-based system." >&2
    exit 1
fi

sudo pacman -S --needed emacs

mkdir -p "$target_dir" "$HOME/org"

emacs --batch --quick --eval "(progn
  (require 'package)
  (setq package-user-dir \"$target_dir/elpa\")
  (add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\") t)
  (package-initialize)
  (unless (and (package-installed-p 'evil) (package-installed-p 'evil-org))
    (package-refresh-contents))
  (unless (package-installed-p 'evil) (package-install 'evil))
  (unless (package-installed-p 'evil-org) (package-install 'evil-org)))"

if [[ -L "$target_file" ]] && [[ "$(readlink -f -- "$target_file")" == "$source_file" ]]; then
    echo "Emacs config already points to this repository."
else
    if [[ -e "$target_file" || -L "$target_file" ]]; then
        backup="$target_file.backup-$(date +%Y%m%d-%H%M%S)"
        mv -- "$target_file" "$backup"
        echo "Saved the previous Emacs init file as $backup"
    fi
    ln -s -- "$source_file" "$target_file"
fi

create_org_file() {
    local name="$1" title="$2" heading="${3:-}"
    local path="$HOME/org/$name"
    if [[ ! -e "$path" ]]; then
        {
            printf '#+title: %s\n\n' "$title"
            if [[ -n "$heading" ]]; then
                printf '* %s\n' "$heading"
            fi
        } > "$path"
    fi
}

create_org_file inbox.org Inbox Tasks
create_org_file notes.org Notes Notes
create_org_file journal.org Journal
create_org_file projects.org Projects Projects

echo "Emacs is installed. Start it with: emacs"
echo "Org files are in ~/org. Use C-c n a for agenda and C-c n c to capture."
