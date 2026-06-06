#!/usr/bin/bash
#
# Defines functions used to download, build, and install specific applications
#

source ../config.sh
source ../utils.sh

install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

install_uv() {
    curl -LsSf https://astral.sh/uv/install.sh | sh

    if [[ "$CREATE_GENERAL_VENV" == "true" ]]; then
        log "Creating general Python venv in '${VENV_DIR}'..."
        uv venv "$VENV_DIR"
    fi
}

install_bitwarden() (
    cd /tmp
    curl -LsSf https://bitwarden.com/download/?app=cli&platform=linux -o bw.zip
    unzip bw.zip
    chmod +x bw
    mv bw "$BIN_DIR"
    rm bw.zip
)

install_neovim() (
    cd "$CACHE_DIR"
    git clone https://github.com/neovim/neovim
    cd neovim
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    if [[ -n "$1" ]]; then
        cd build
        cpack -G DEB
        sudo dpkg -i "nvim-linux-${ARCH}.deb"
    else
        sudo make install
    fi
)
