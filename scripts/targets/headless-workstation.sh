#!/usr/bin/bash
#
# Provision a machine that serves as a headless workstation
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
    local PACKAGES_APT=(irssi rtorrent)
    run_step install_via_apt "" "${PACKAGES_APT[@]}"
    run_step install_herdr herdr
    run_step install_dotnet_runtime dotnet
    # No skip check: the runtime puts `dotnet` in $PATH without an SDK, and apt upgrades an older SDK
    run_step install_dotnet_sdk ""
}

config_user() {
    local CONFIGS=(irssi herdr)
    run_step install_user_configs "" "${CONFIGS[@]}"
}

config_system() {
    run_step install_system_configs
}

services() {
    local USER_SERVICES=(
        cmg-util.service
        cmg-util.timer
    )
    run_step install_user_services "" "${USER_SERVICES[@]}"
    # run_step install_system_services
}
