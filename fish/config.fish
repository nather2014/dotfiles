# Auto start sway on tty1
if test -z "$DISPLAY" -a (tty) = /dev/tty1
    exec sway
end

# PATH & editor
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PATH $HOME/.local/bin $PATH

# Minimal prompt: just show current folder
function fish_prompt
    set_color green
    echo -n (basename (pwd)) ""
    set_color normal
end

# Aliases
alias ll='ls -lh'
alias la='ls -lha'
alias gst='git status'
alias gco='git checkout'
alias zz='systemctl suspend'
alias off='poweroff'
alias v='nvim'

# Auto-start tmux
if status is-interactive; and not set -q TMUX; and command -q tmux
    tmux attach -t main 2>/dev/null; or tmux new -s main
    exit
end
