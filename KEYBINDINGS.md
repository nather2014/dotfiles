# Emacs keybindings

This config follows Doom Emacs' Evil keybinding layout, without the full Doom
distribution. Press `i` to insert, `Esc` to return to normal mode, and use
`h j k l`, `w`, `b`, `d`, `c`, `y`, `/`, and `u` as in Vim. `C-z` switches to
Emacs state and again returns to Evil. `Space` is the leader in normal and
visual states.

## Files: `Space f`

| Keys | Action |
| --- | --- |
| `Space f f` | Find file |
| `Space f r` | Recent files |
| `Space f s` | Save file |
| `Space .` | Find file |

## Buffers: `Space b`

| Keys | Action |
| --- | --- |
| `Space b b` | Switch buffer |
| `Space b B` | List all buffers (`ibuffer`) |
| `Space b d` | Kill current buffer |

## Projects: `Space p`

`p` switches projects, `f` finds a project file, `g` searches project files,
`b` switches to a project buffer, and `c` compiles the project. `Space Space`
also finds a project file.

## Search: `Space s`

`s` searches this buffer, `p` searches project files, and `i` jumps to a symbol
in the current file.

## Code: `Space c`

| Keys | Action |
| --- | --- |
| `Space c c` | Compile |
| `Space c e` | Start Eglot |
| `Space c r` | Rename symbol through Eglot |
| `Space c a` | Eglot code actions |
| `Space c f` | Format buffer through Eglot |

Install a language server for the language, then run `Space c e` in a project
buffer.

## Notes: `Space n`

| Keys | Action |
| --- | --- |
| `Space n a` | Open agenda |
| `Space n n` | Open capture menu |
| `Space n t` | Capture a task |
| `Space n c` | Capture a note |
| `Space n j` | Capture a journal entry |
| `Space n p` | Capture a project |

Inside Org files, `Space m` is the local leader: `a` agenda, `c` capture, `t`
change TODO state, `s` schedule, `d` set deadline, and `l` store link. `TAB`
folds a heading and `M-RET` inserts a heading. Evil-Org adds Vim-style heading,
list, and table editing.

## Windows: `Space w`

`v` split right, `s` split below, `d` close window, `o` keep only this window,
`w` switch window, and `h j k l` move between windows.

## Help and quit

`Space h f` describe function, `Space h k` describe key, `Space h v` describe
variable, `Space h m` describe mode, and `Space q q` quit Emacs.

The earlier `C-c n` bindings remain available in Emacs state. Standard Emacs
keys such as `C-x C-f` and `C-g` also remain available.
