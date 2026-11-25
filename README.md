# f15 dotfiles

Sway config and the explicitly installed pacman package list from `f15` (EndeavourOS).
The package list is a snapshot of this machine, including hardware and system packages,
plus `brightnessctl`, `inotify-tools`, and `playerctl` for the Sway config and auto-sync service.

## Install

Clone this repository on an EndeavourOS machine, review
`packages/arch-explicit.txt`, then run:

```bash
./install.sh
```

The script installs the listed packages with `pacman` and links `config/sway` to
`~/.config/sway`. If a Sway config already exists, it moves it to a timestamped
backup first. To only link the config, run `./install.sh --config-only`; to only
install packages, run `./install.sh --packages-only`.

The package list includes system and GPU driver packages. Review it before
installing on different hardware or another Arch-based distribution.

## Sync

This repository is hosted at `https://github.com/nather2014/dotfiles`. On another
machine, clone it and run the installer. Run `setup-autosync.sh` to have edits
committed and pushed automatically. Without the service, sync manually with
`git add`, `git commit`, and `git push`.

```bash
git clone https://github.com/nather2014/dotfiles.git
cd dotfiles
./install.sh
```

To automatically commit and push edits from this checkout, run this once on
EndeavourOS:

```bash
./setup-autosync.sh
```

It enables a systemd user service that watches the repository, waits briefly for
file writes to settle, commits changes, and pushes them to `main`. The service
retries after network failures. `.gitignore` excludes common key and environment
files from this public repository. Review new files before adding them because
the repository is public.
