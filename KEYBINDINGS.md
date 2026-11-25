# Emacs keybindings

The config uses Emacs' standard keys for editing and gives notes and tools
short, mnemonic prefixes.

## Org notes: `C-c n`

| Keys | Action |
| --- | --- |
| `C-c n a` | Open agenda |
| `C-c n c` | Open capture menu |
| `C-c n t` | Capture a task |
| `C-c n n` | Capture a note |
| `C-c n j` | Capture a journal entry |
| `C-c n p` | Capture a project |

Inside Org files, the built-in keys are also useful: `TAB` folds a heading,
`M-RET` inserts a heading, `C-c C-t` changes its TODO state, `C-c C-s` sets a
schedule, and `C-c C-d` sets a deadline.

## Projects: `C-c p`

This is Emacs' built-in `project.el` keymap. Common keys include `p` to switch
projects, `f` to find a project file, `g` to search project files, `b` to switch
to a project buffer, and `c` to compile the project.

## Coding and navigation: `C-c m`

| Keys | Action |
| --- | --- |
| `C-c m b` | Buffer list (`ibuffer`) |
| `C-c m r` | Recent files |
| `C-c m d` | Duplicate line or region |
| `C-c m c` | Compile |
| `C-c m e` | Start Eglot for the current project |
| `C-c m f` | Find a project file |
| `C-c m g` | Search project files |
| `C-c m p` | Switch project |
| `M-.` | Find definition (`xref`) |
| `M-,` | Return from definition |

All other Emacs defaults remain available, including `C-x C-f` to open a file,
`C-x b` to switch buffers, `C-x 2` / `C-x 3` to split windows, and `C-g` to
cancel a command. Eglot needs a language server installed for the language.
