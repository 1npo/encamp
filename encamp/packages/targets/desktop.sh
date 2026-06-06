#!/usr/bin/bash
#
# Install packages on targets with graphical desktop environments
#

_setup() {
    local script_dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))

    source "${script_dir}/../../config.sh"
    source "${script_dir}/../../utils.sh"
    source "${script_dir}/../install_via.sh"
    source "${script_dir}/../install_app.sh"
}
_setup; unset -f _setup

PACKAGES_APT=(
    alacritty
    kde-plasma-desktop
    xdg-open
    qbittorrent
    vlc
    feh
    steam
    fuzzel
)

run_step install_via_apt    ""      "${PACKAGES_APT[@]}"
run_step install_kitty      kitty
run_step install_vscode     code
run_step install_obsidian   obsidian