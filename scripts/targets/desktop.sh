#!/usr/bin/bash
#
# Provision a machine with a graphical desktop environment
#

_import() {
    local script_dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))

    source "${script_dir}/../settings.sh"
    source "${script_dir}/../lib/utils.sh"
    source "${script_dir}/../lib/install_via.sh"
    source "${script_dir}/../lib/install_app.sh"
    source "${script_dir}/../lib/install_services.sh"
    source "${script_dir}/../lib/install_configs.sh"
}
_import; unset -f _import

packages() {
    local PACKAGES_APT=(
        alacritty
        kde-plasma-desktop
        xdg-open
        qbittorrent
        vlc
        feh
        steam
        fuzzel
    )

    run_step install_via_apt    ""          "${PACKAGES_APT[@]}"
    run_step install_kitty      kitty
    run_step install_vscode     code
    run_step install_obsidian   obsidian
}

config_user() {
    local CONFIGS=(
        dms
        fuzzel
        kitty
        niri
        irssi
    )
    run_step install_user_configs "" "${CONFIGS[@]}"
}

config_system() {
    run_step install_system_configs
}

services() {
    local USER_SERVICES=()
    run_step install_user_services "" "${USER_SERVICES[@]}"
    run_step install_system_services
}

