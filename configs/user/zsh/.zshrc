export GPG_TTY=$(tty)

# Oh-my-ZSH
ZSH_THEME="galnet"
plugins=(git)
export ZSH="$HOME/.zsh/oh-my-zsh"
source "$ZSH/oh-my-zsh.sh"

# Personal
for file in $HOME/.zsh/config/* ; do source "$file"; done

