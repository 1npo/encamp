#!/usr/bin/bash

source ../functions.sh

PACKAGES_APT=(
	vlc
	qbittorrent
	kde-plasma-desktop
	xdg-open
)
PACKAGES_SNAP=(
	obsidian
)

update_apt
install_apt ${PACKAGES_APT[@]}

update_snap
install_snap ${PACKAGES_SNAP[@]}

install_dpkg "VSCode" "vscode.deb" "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

install_fonts