export GPG_TTY=$(tty)

# Personal
for file in $HOME/.zsh/config/* ; do source "$file"; done

# Cargo
source "$HOME/.local/bin/env"

# Oh-my-ZSH
ZSH_THEME="galnet"
plugins=(git)
export ZSH="$HOME/.zsh/oh-my-zsh"
source "$ZSH/oh-my-zsh.sh"
