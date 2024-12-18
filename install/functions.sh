#!/usr/bin/bash

function update_pip() {
	python3 -m pip install --upgrade pip
}

function update_apt() {
	sudo apt update && sudo apt upgrade -y
}

function install_apt() {
	packages=$@
	echo "Installing ${#packages[@]} packages via apt (${packages[@]})..."
	sudo apt install -y ${packages[@]}
}

function install_python() {
	packages=$@
	echo "Installing ${#packages[@]} packages via pip (${packages[@]})..."
	pip install --upgrade ${packages[@]}
}

function install_bin_from_zip() {
	pkgname=$1
	shift
	zipname=$1
	shift
	binname=$1
	shift
	url=$1

	cwd=`pwd`
	cd /tmp
	echo "Downloading $pkgname..."
	curl -Lso $zipname $url
	echo "Installing $pkgname..."
	unzip $zipname
	mv $binname $USER_BIN_DIR
	rm -fr $zipname
	cd $cwd
}

function install_dpkg() {
	pkgname=$1
	shift
	debname=$1
	shift
	url=$1

	cwd=`pwd`
	cd /tmp
	echo "Downloading $pkgname..."
	curl -Lso $debname $url
	echo "Installing $pkgname..."
	sudo dpkg -i $pkgname
	cd $cwd
}

function install_rust() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

function install_fonts() {
	echo "Downloading fonts from Google Drive..."
	echo "Unpacking fonts..."
	echo "Installing fonts..."
}

function bw_login() {
	if [[ -z "${BW_CLIENTID}" ]]; then
		echo "Bitwarden Client ID: "
		read -n BW_CLIENTID
		export BW_CLIENTID="$BW_CLIENTID"

	if [[ -z "${BW_CLIENTSECRET}" ]]; then
		echo "Bitwarden Client Secret: "
		read -n BW_CLIENTSECRET
		export BW_CLIENTSECRET="$BW_CLIENTSECRET"

	echo "Logging in to Bitwarden..."
	bw login --apikey
}

function bw_unlock() {
	if [[ -z "${BW_SESSION}" ]]; then
		export BW_SESSION=$(bw unlock --raw)
}
