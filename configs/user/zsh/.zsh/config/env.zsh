HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh/history

export EDITOR="/usr/bin/nvim"
export SHELL="/usr/bin/zsh"
export TERM="screen-256color"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_DATA_HOME="$HOME/.local/share"

# NOTE: If a Python binary/script exists in multiple directories in $PATH, I want to use the first
# one that appears in this list:
#
#	1. The local project's `.venv/bin`
#	2. The user's local binaries folder (~/.local/bin)
#	3. The user's general-purpose `~/.venv/bin`
export PATH_USER_ZIG="$HOME/.local/bin/zig-x86_64-linux-0.15.2"
export PATH_USER=".venv/bin:$HOME/.local/bin:$HOME/.venv/bin:$HOME/.cargo/bin:$PATH_USER_ZIG"
export PATH_SYSTEM="/usr/local/bin:/usr/bin:/bin:/usr/games"
export PATH="$PATH_USER:$PATH_SYSTEM"

export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lical/lib"
export CFLAGS="-O3 -ffast-math -march=native"

export SSH_AUTH_SOCK=/run/user/1000/ssh-agent.sock;

export BRIDGE_SMTP_PW="$(pass proton-bridge-smtp)"
export RCLONE_PASSWORD_COMMAND='pass rclone/config'

export LS_COLORS="$(vivid generate molokai)"
export DISABLE_AUTO_TITLE="true"
export ELECTRON_OZONE_PLATFORM_HINT="wayland"
