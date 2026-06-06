#!/usr/bin/bash
#
# Install packages on targets that serve as headless workstations
#

_setup() {
    local script_dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))

    source "${script_dir}/../../config.sh"
    source "${script_dir}/../../utils.sh"
    source "${script_dir}/../install_via.sh"
    source "${script_dir}/../install_app.sh"
}
_setup; unset -f _setup

PACKAGES_APT=(irssi rtorrent)

run_step install_via_apt "" "${PACKAGES_APT[@]}"
