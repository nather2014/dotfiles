# fzf keybindings + completion
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

# better ls
alias ls="eza --color=always --group-directories-first"

# cat but readable
alias cat="bat"

# quick fuzzy cd
alias c="cd $(fd -td . | fzf)"

# fuzzy file open with nvim or code (pick one)
alias f="fzf --preview 'bat --style=numbers --color=always {}'"

# open nnn
alias n="nnn"
