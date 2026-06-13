#!/usr/bin/bash
#
# Defines functions for enabling systemd user and system services
#

_import() {
    local script_dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))

    source "${script_dir}/../settings.sh"
    source "${script_dir}/utils.sh"
}
_import; unset -f _import

install_user_services() {
    local services=("$@")
    if [ ${#services[@]} -eq 0 ]; then
        log "No user services to enable."
        return 0
    fi
    local service_dir="${HOME}/.config/systemd/user"
    for svc in "${services[@]}"; do
        if [ ! -f "${service_dir}/${svc}" ]; then
            log "Error: service definition not found: ${service_dir}/${svc}"
            return 1
        fi
    done
    systemctl --user daemon-reload
    systemctl --user enable "${services[@]}"
}

install_system_services() {
    local host=$(hostname -s)
    local service_dir="${SHARE_DIR}/configs/system/${host}/etc/systemd/system"
    if [ ! -d "${service_dir}" ]; then
        log "No system services found for host '$(hostname -s)', skipping."
        return 0
    fi
    local services=()
    while IFS= read -r f; do
        services+=("$(basename "${f}")")
    done < <(find "${service_dir}" -name "*.service" -type f)
    if [ ${#services[@]} -eq 0 ]; then
        log "No system services to enable."
        return 0
    fi
    sudo systemctl --daemon-reload
    sudo systemctl --enable "${services[@]}"
}