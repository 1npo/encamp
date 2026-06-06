#!/usr/bin/bash
#
# Defines functions for stowing dotfile packages
#

stow_configs() {
    local configs_dir="${SHARE_DIR}/encamp/config-user/configs"
    local packages=("$@")
    if [ ${#packages[@]} -eq 0 ]; then
        log "No dotfile packages to stow."
        return 0
    fi
    for pkg in "${packages[@]}"; do
        stow --dir="${configs_dir}" --target="${HOME}" --restow "${pkg}"
    done
}