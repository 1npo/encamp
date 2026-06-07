#!/usr/bin/bash
#
# Defines functions used to install user- and system-level configuration files
#

_import() {
    local script_dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))

    source "${script_dir}/../settings.sh"
    source "${script_dir}/utils.sh"
}
_import; unset -f _import

install_user_configs() {
    local configs_dir="${SHARE_DIR}/configs/user"
    local packages=("$@")
    if [ ${#packages[@]} -eq 0 ]; then
        log "No dotfile packages to stow."
        return 0
    fi
    for pkg in "${packages[@]}"; do
        stow --dir="${configs_dir}" --target="${HOME}" --restow "${pkg}"
    done
}

install_system_configs() {
    local configs_dir="${SHARE_DIR}/configs/system"
    local host=$(hostname -s)

    if [ ! -d "${configs_dir}/${host}" ]; then
        log "Error: no system configs found for host '${host}' in ${configs_dir}"
        return 1
    fi

    _copy_dir() {
        local src_dir="$1"
        [ -d "${src_dir}" ] || return 0
        find "${src_dir}" -type f | while IFS= read -r src; do
            local dest="/${src#${src_dir}/}"
            sudo mkdir -p "$(dirname "${dest}")"
            sudo cp "${src}" "${dest}"
        done
    }

    _copy_dir "${configs_dir}/_base"
    _copy_dir "${configs_dir}/${host}"
}