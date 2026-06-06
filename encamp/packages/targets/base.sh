#!/usr/bin/bash
#
# Install base packages on all targets
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
)
PACKAGES_CARGO=(
    vivid
    cargo-deb
)
PACKAGES_PIP=(
    pandas
    numpy
    matplotlib
    openpyxl
    uvicorn
    requests
    dateutils
)

run_step install_via_apt    ""      "${PACKAGES_APT[@]}"
run_step install_rust       cargo
run_step install_via_cargo  ""      "${PACKAGES_CARGO[@]}"
run_step install_uv         uv
run_step install_via_pip    ""      "${PACKAGES_PIP[@]}"
run_step install_bitwarden  bw
run_step install_neovim     nvim    "deb"
