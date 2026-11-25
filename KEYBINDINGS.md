# Emacs keybindings

This setup leaves Emacs' standard keybindings in place. Evil is installed but
disabled by default; run `M-x evil-mode` if you want to turn on Vim-style modal
editing. In an Org buffer, run `M-x evil-org-mode` for its Vim-style Org keys.

## Editing and movement

| Keys | Action |
| --- | --- |
| `C-f`, `C-b`, `C-n`, `C-p` | Move forward, backward, down, up |
| `C-a`, `C-e` | Beginning or end of line |
| `M-f`, `M-b` | Move forward or backward by word |
| `C-s`, `C-r` | Search forward or backward |
| `M-<`, `M->` | Beginning or end of buffer |
| `C-g` | Cancel the current command |

## Files and buffers

| Keys | Action |
| --- | --- |
| `C-x C-f` | Open a file |
| `C-x C-s` | Save the current file |
| `C-x b` | Switch buffer |
| `C-x k` | Kill buffer |
| `C-x C-b` | List buffers |
| `C-x 2`, `C-x 3` | Split window below or right |
| `C-x 1`, `C-x 0` | Keep current window or close it |
| `M-x` | Run any named command |

## Org notes

Org's standard commands remain available: `C-c C-t` changes a heading's TODO
state, `C-c C-s` schedules it, `C-c C-d` sets a deadline, and `C-c C-c`
completes an action or closes a capture. Run `M-x org-agenda` for the agenda
and `M-x org-capture` to create a task, note, journal entry, or project.

## Coding

In programming buffers, `M-.` jumps to a definition and `M-,` returns. Run
`M-x project-find-file` or `M-x project-switch-project` to navigate projects,
`M-x compile` to build, and `M-x eglot` to start language-server support.
