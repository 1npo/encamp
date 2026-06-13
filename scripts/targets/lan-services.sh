#!/usr/bin/bash
#
# Provision a machine that provides network services to the LAN
#

_import() {
    local script_dir=$(dirname $(realpath "${BASH_SOURCE[0]}"))

    source "${script_dir}/../settings.sh"
    source "${script_dir}/../lib/utils.sh"
    source "${script_dir}/../lib/install_via.sh"
    source "${script_dir}/../lib/install_app.sh"
    source "${script_dir}/../lib/install_services.sh"
    source "${script_dir}/../lib/install_configs.sh"
}
_import; unset -f _import

packages() {
    local PACKAGES_APT=(
        rsyslog
        postgresql
        nginx
        multitail

        # protonmail-bridge dependencies
        libxcb-cursor0
        libsecret-1-0
        libpulse-mainloop-glib0
        fonts-dejavu
    )
    local PACKAGES_PIP=(pypiserver)

    run_step install_via_apt        ""              "${PACKAGES_APT[@]}"
    run_step install_via_pip        ""              "${PACKAGES_PIP[@]}"
    run_step install_proton_bridge  proton-bridge
    run_step install_ubooquity
}

config_user() {
    local CONFIGS=(ubooquity)
    run_step install_user_configs "" "${CONFIGS[@]}"
}

config_system() {
    run_step install_system_configs
}

services() {
    local USER_SERVICES=(
        ubooquity.service
        protonmail-bridge.service
    )
    run_step install_user_services "" "${USER_SERVICES[@]}"
    run_step install_system_services
}
