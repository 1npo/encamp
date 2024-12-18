#!/usr/bin/bash

source ../functions.sh

PACKAGES_APT=(
	zsh
	neovim
	tmux
	fzf
	btop
	rclone
	pass
	curl
	ufw
	wireguard
	zip
	unzip
	snapd
	python3
	python3-pip
	jq
)
PACKAGES_PIP=(
	uv
	wheel
	setuptools
	requests
	dateutils
)

update_apt
update_pip
install_apt ${PACKAGES_APT[@]}
install_pip ${PACKAGES_PIP[@]}
install_bin_from_zip "Bitwarden CLI" "bitwarden.zip" "bw" "https://vault.bitwarden.com/download/?app=cli&platform=linux"
