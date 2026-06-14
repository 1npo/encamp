#!/usr/bin/bash
#
# Provision a base installation on all targets
#

_import() {
    local script_dir=$(dirname $(realpath "${BASH_SOURCE[0]}"))

    source "${script_dir}/../settings.sh"
    source "${script_dir}/../lib/utils.sh"
    source "${script_dir}/../lib/install_via.sh"
    source "${script_dir}/../lib/install_app.sh"
    source "${script_dir}/../lib/install_services.sh"
    source "${script_dir}/../lib/install_configs.sh"
}
_import
unset -f _import

packages() {
    local PACKAGES_APT=(
        zsh
        fd-find
        fzf
        jq
        zip
        unzip
        btop
        tmux
        lnav
        curl
        stow
        pass
        ufw
        rsync
        rclone
        samba
        smbclient
        wireguard
        openvpn
        ca-certificates
        psmisc
        python3
        build-essential
        default-jre
        ninja-build
        gettext
        cmake
        git
        figlet
    )
    local PACKAGES_CARGO=(
        vivid
        cargo-deb
    )
    local PACKAGES_PIP=(
        pandas
        numpy
        matplotlib
        openpyxl
        uvicorn
        requests
        dateutils
    )

    run_step install_via_apt "" "${PACKAGES_APT[@]}"
    run_step install_rust cargo
    run_step install_via_cargo "" "${PACKAGES_CARGO[@]}"
    run_step install_uv uv
    run_step install_via_pip "" "${PACKAGES_PIP[@]}"
    run_step install_bitwarden bw
    run_step install_neovim nvim "deb"
}

config_user() {
    local CONFIGS=(
        git
        zsh
        nvim
        tmux
        sqlite
        ssh
        smb
        systemd
        rclone
        python_keyring
        gnupg
    )
    run_step install_user_configs "" "${CONFIGS[@]}"
}

config_system() {
    run_step install_system_configs ""
}

services() {
    local USER_SERVICES=(
        gpg-agent.service
        ssh-agent.service
    )
    run_step install_user_services "" "${USER_SERVICES[@]}"
    # run_step install_system_services
}
