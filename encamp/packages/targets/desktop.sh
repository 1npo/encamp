#!/usr/bin/bash
#
# Install packages on targets with graphical desktop environments
#

source ../../config.sh
source ../install_via.sh
source ../install_app.sh

PACKAGES_APT=(

)
PACKAGES_CARGO=(

)
PACKAGES_PIP=(

)

run_step install_via_apt    ""      "${PACKAGES_APT[@]}"
run_step install_rust       cargo
run_step install_via_cargo  ""      "${PACKAGES_CARGO[@]}"
run_step install_uv         uv
run_step install_via_pip    ""      "${PACKAGES_PIP[@]}"
run_step install_bitwarden  bw
run_step install_neovim     nvim    "deb"
