#!/usr/bin/bash
#
# Defines functions used to install packages via package managers
#

_import() {
    local script_dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))

    source "${script_dir}/../settings.sh"
    source "${script_dir}/utils.sh"
}
_import; unset -f _import

install_via_apt() {
    local packages=("$@")
    if [ ${#packages[@]} -eq 0 ]; then
        log "Nothing to install."
        return 1
    fi
    sudo apt-get update -qq
    install=(
        sudo apt-get
        -q
        -y
        -o Dpkg::Progress-Fancy=0
        -o Dpkg::Use-Pty=0
        install
        "${packages[@]}"
    )
    "${install[@]}"
}

install_via_cargo() {
    local packages=("$@")
    if [ ${#packages[@]} -eq 0 ]; then
        log "Nothing to install."
        return 1
    fi
    cargo install "${packages[@]}"
}

install_via_pip() {
    local packages=("$@")
    if [ ${#packages[@]} -eq 0 ]; then
        log "Nothing to install."
        return 1
    fi
    $VENV_PYTHON -m pip install "${packages[@]}"
}
