# Emacs keybindings

The config uses Evil for Vim-style modal editing. Press `i` to insert, `Esc` to
return to normal mode, and use `h j k l`, `w`, `b`, `d`, `c`, `y`, `/`, and `u`
as in Vim. Press `C-z` to switch to Emacs state and again to return to Evil.

In normal and visual states, `Space` is the leader key. This avoids reaching
for Ctrl for the custom shortcuts. Evil documents built-in leader support; the
specific Space mappings here follow common community setups.

## Org notes: `Space n`

| Keys | Action |
| --- | --- |
| `Space n a` | Open agenda |
| `Space n c` | Open capture menu |
| `Space n t` | Capture a task |
| `Space n n` | Capture a note |
| `Space n j` | Capture a journal entry |
| `Space n p` | Capture a project |

Inside Org files, the built-in keys are also useful: `TAB` folds a heading,
`M-RET` inserts a heading, `C-c C-t` changes its TODO state, `C-c C-s` sets a
schedule, and `C-c C-d` sets a deadline.

## Projects: `Space p`

`p` switches projects, `f` finds a project file, `g` searches project files,
`b` switches to a project buffer, and `c` compiles the project.

## Coding and navigation: `Space` shortcuts

| Keys | Action |
| --- | --- |
| `Space b b` | Buffer list (`ibuffer`) |
| `Space b r` | Recent files |
| `Space c d` | Duplicate line or region |
| `Space c c` | Compile |
| `Space c e` | Start Eglot for the current project |
| `Space c f` | Find a project file |
| `Space c g` | Search project files |
| `M-.` | Find definition (`xref`) |
| `M-,` | Return from definition |

The earlier `C-c n` bindings remain available in Emacs state. Emacs defaults
such as `C-x C-f` and `C-g` also remain available. Org uses the `evil-org`
integration for modal heading, list, and table editing. Eglot needs a language
server installed for the language.
