#!/usr/bin/bash
#
# Defines functions used to download, build, and install specific applications
#

_setup() {
    local script_dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))

    source "${script_dir}/../config.sh"
    source "${script_dir}/../utils.sh"
}
_setup; unset -f _setup

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
    cd "$CACHE_DIR"
    deb_file=$(curl -fsSL -OJ "https://bitwarden.com/download/?app=cli&platform=linux" -w "%{filename_effective}")
    unzip "$deb_file"
    chmod +x bw
    mv bw "$BIN_DIR"
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

install_kitty() {
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
}

install_obsidian() (
    cd "$CACHE_DIR"
    latest=$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest)
    deb_url=$(echo "$latest" | jq -r '.assets[].browser_download_url | select(test("amd64\\.deb$"))')
    deb_file=$(basename "$deb_url")
    curl -fsSL -o "$(basename "$deb_url")" "$deb_url"
    sudo dpkg -i "$deb_file"
)

install_vscode() (
    cd "$CACHE_DIR"
    deb_file=$(curl -fsSL -OJ "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -w "%{filename_effective}")
    sudo dpkg -i "$deb_file"
)

install_proton_bridge() (
    # Proton has decided they want to make it difficult for their users to download their
    # deb files programmatically, so we need to scrape the URL from the knowledge base
    # page. There's no guarantee this method will work in the future.
    cd "$CACHE_DIR"
    deb_url=$(curl -s https://proton.me/support/installing-bridge-linux-deb-file \
    | grep -oP 'https://proton\.me/download/bridge/protonmail-bridge_[\d.]+-\d+_amd64\.deb' \
    | head -1)
    deb_file=$(curl -fsSL -OJ "$deb_url" -w "%{filename_effective}")
    sudo dpkg -i "$deb_file"
)

install_ubooquity() (
    cd "$CACHE_DIR"
    download_url="http://vaemendis.net/ubooquity/service/download.php"
    zip_url=$(curl -fsSLI -o /dev/null -w "%{url_effective}" "${download_url}")
    zip_file=$(basename "$zip_url")
    curl -fsSL -O $zip_url
    unzip $zip_file
    mv Ubooquity.jar "$BIN_DIR"
)
