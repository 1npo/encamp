HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh/history
EDITOR="/usr/bin/nvim"
TERM="screen-256color"
USER_BIN_DIR="$HOME/bin"
PATH="$PATH:$USER_BIN_DIR"
VIMRC="~/.vimrc"
TMUXRC="~/.tmux.conf"
PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lical/lib"
CFLAGS="-O3 -ffast-math -march=native"
LS_COLORS="$(vivid generate molokai)"
SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.sock"
