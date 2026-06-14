export GPG_TTY=$(tty)

# Personal
for file in $HOME/.zsh/config/* ; do source "$file"; done

# Cargo
source "$HOME/.local/bin/env"

# Oh My ZSH
export ZSH="$HOME/.zsh/oh-my-zsh"
ZSH_THEME="galnet"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"
