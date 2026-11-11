#!/usr/bin/bash
#
# Defines functions used to install user- and system-level configuration files
#

_import() {
    local script_dir=$(dirname $(realpath "${BASH_SOURCE[0]}"))

    source "${script_dir}/../settings.sh"
    source "${script_dir}/utils.sh"
}
_import; unset -f _import

# Skills that live in their own repository. They are cloned into ~/.claude/skills/<name> (not stowed, and not
# vendored into this repository), and updated by every pull, so a release of the skill is live after the next sync.
EXTERNAL_SKILLS=("dossier https://github.com/1npo/dossier.git")

install_user_configs() {
    local configs_dir="${SHARE_DIR}/configs/user"
    local packages=("$@")
    if [ ${#packages[@]} -eq 0 ]; then
        log "No dotfile packages to stow."
        return 0
    fi
    for pkg in "${packages[@]}"; do
        local ignore=()
        if [ "${pkg}" = "claude" ]; then
            # Leftovers of a skill that used to live in this repository must not be stowed over its clone
            local entry
            for entry in "${EXTERNAL_SKILLS[@]}"; do ignore+=(--ignore="^/\\.claude/skills/${entry%% *}\$"); done
        fi
        stow --dir="${configs_dir}" --target="${HOME}" "${ignore[@]}" --restow "${pkg}"
        [ "${pkg}" = "claude" ] && install_external_skills
    done
    return 0
}

install_external_skills() {
    local skills_dir="${HOME}/.claude/skills" entry name url dest
    mkdir -p "${skills_dir}"
    for entry in "${EXTERNAL_SKILLS[@]}"; do
        name="${entry%% *}"; url="${entry#* }"; dest="${skills_dir}/${name}"
        # A symlink here is the stow link to a copy that used to live in this repository
        [ -L "${dest}" ] && rm "${dest}"
        if [ ! -e "${dest}" ]; then
            log "Cloning skill ${name} from ${url}"
            git clone --quiet "${url}" "${dest}" || log "Warning: could not clone skill ${name}"
        elif [ ! -d "${dest}/.git" ]; then
            log "Warning: ${dest} exists and is not a git clone; leaving it alone"
        elif [ -n "$(git -C "${dest}" status --porcelain --untracked-files=no)" ]; then
            log "Warning: ${dest} has local changes; not updating skill ${name}. Make changes in the skill's own repository"
        else
            git -C "${dest}" pull --ff-only --quiet || log "Warning: could not update skill ${name}"
        fi
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