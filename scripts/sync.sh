#!/usr/bin/bash
#
# Sync the encamp repository with the remote
#

SCRIPT_DIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))

source "${SCRIPT_DIR}/settings.sh"
source "${SCRIPT_DIR}/lib/utils.sh"

if [ $# -lt 1 ]; then
    log ""
    log "Usage: $0 <command> [message]"
    log ""
    log "Available commands: push, pull"
    log ""
    log "Examples:"
    log "  $0 pull"
    log "  $0 push"
    log "  $0 push 'Update zsh config'"
    log ""
    exit 1
fi

COMMAND="$1"
MESSAGE="${2:-"Update config-user $(date '+%Y-%m-%d %H:%M')"}"

if [[ ! "$COMMAND" =~ ^(push|pull)$ ]]; then
    log "Error: invalid command '${COMMAND}'. Must be one of: push, pull"
    exit 1
fi

sync_push() {
    if [ -z "$(git -C "${SHARE_DIR}" status --porcelain)" ]; then
        log "Nothing to commit, working tree clean"
        return 0
    fi
    git -C "${SHARE_DIR}" add -A
    git -C "${SHARE_DIR}" commit -m "${MESSAGE}"
    git -C "${SHARE_DIR}" push
}

sync_pull() {
    git -C "${SHARE_DIR}" pull
    if [ ! -f "${STATE_DIR}/targets" ]; then
        log "Warning: no targets recorded in ${STATE_DIR}/targets, skipping re-stow"
        log "Run main.sh to set targets for this machine"
        return 0
    fi
    while IFS= read -r target; do
        log "Re-stowing config-user for target: ${target}"
        source "${SCRIPT_DIR}/targets/${target}.sh"
        config_user
    done < "${STATE_DIR}/targets"
}

case "$COMMAND" in
    push) run_step sync_push "" ;;
    pull) run_step sync_pull "" ;;
esac
