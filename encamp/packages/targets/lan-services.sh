#!/usr/bin/bash
#
# Install packages on targets that provide network services to the LAN
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
    rsyslog
    postgresql
    nginx
    multitail
)
PACKAGES_PIP=(pypiserver)

run_step install_via_apt        ""              "${PACKAGES_APT[@]}"
run_step install_via_pip        ""              "${PACKAGES_PIP[@]}"
run_step install_proton_bridge  proton-bridge
run_step install_ubooquity
