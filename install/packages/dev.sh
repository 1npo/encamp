#!/usr/bin/bash

source ../functions.sh

PACKAGES_APT=(
	build-essential
)
PACKAGES_PIP=(
	pandas
	numpy
	matplotlib
	openpyxl
	uvicorn
)

update_apt
update_pip

install_apt ${PACKAGES_APT[@]}
install_pip ${PACKAGES_PIP[@]}

install_rust
