#!/usr/bin/bash
#
# Configure user dotfiles on all targets
#

_setup() {
    local script_dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))

    source "${script_dir}/../../config.sh"
    source "${script_dir}/../../utils.sh"
    source "${script_dir}/../stow_configs.sh"
}
_setup; unset -f _setup

CONFIGS=(
    git
    zsh
    nvim
    tmux
    sqlite
    ssh
    smb
    systemd
)

run_step stow_configs "" "${CONFIGS[@]}"