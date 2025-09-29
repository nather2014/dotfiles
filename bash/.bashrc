# ~/.bashrc - minimal & fast

# History
HISTCONTROL=ignoredups:erasedups
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Prompt
PS1='\w\$ '

# Aliases
alias ls='ls --color=auto -F'
alias ll='ls -lh --color=auto'
alias la='ls -A --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias e='nvim'

# FZF integration (if installed)
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='find . -type f 2>/dev/null'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='find . -type d 2>/dev/null'
fi

# PATH additions (add ~/bin if it exists)
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# Less colors
export LESS='-R'


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
eval "$(zoxide init bash)"


