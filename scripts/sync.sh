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
    # SHARE_DIR is stowed into $HOME, so its files are live config: a conflict marker in one breaks whatever reads it.
    # Local edits (made through ~/.claude/skills, systemctl, ...) are carried across the pull only when they apply
    # cleanly. When they do not, upstream wins, the edits stay in a stash, and the pull fails loudly.
    # `git pull --autostash` is not used: it exits 0 even when re-applying the stash leaves conflict markers.
    local repo="${SHARE_DIR}" stashed="" conflicted
    if [ -n "$(git -C "${repo}" diff --name-only --diff-filter=U)" ]; then
        log "Error: ${repo} has unresolved merge conflicts. Resolve them (git -C ${repo} status), then run again"
        return 1
    fi
    git -C "${repo}" fetch --quiet || { log "Error: git fetch failed"; return 1; }
    if [ -n "$(git -C "${repo}" status --porcelain --untracked-files=no)" ]; then
        git -C "${repo}" stash push --quiet -m "encamp-sync pull $(date '+%Y-%m-%d %H:%M')" || { log "Error: could not stash local changes in ${repo}"; return 1; }
        stashed="yes"
    fi
    if ! git -C "${repo}" merge --ff-only --quiet '@{upstream}'; then
        log "Error: ${repo} has local commits and cannot fast-forward. Push or reset them, then run again"
        [ -n "${stashed}" ] && git -C "${repo}" stash pop --quiet
        return 1
    fi
    if [ -n "${stashed}" ]; then
        if git -C "${repo}" stash apply --quiet 2>/dev/null; then
            git -C "${repo}" stash drop --quiet
        else
            conflicted=$(git -C "${repo}" diff --name-only --diff-filter=U)
            # Put the conflicted files back to upstream so no conflict marker reaches a live file; keep the other local edits
            [ -n "${conflicted}" ] && git -C "${repo}" checkout HEAD -- ${conflicted}
            git -C "${repo}" reset --quiet
            log "Error: local edits in ${repo} conflict with upstream. Upstream was kept for:"
            log "${conflicted:-  (no file reported)}"
            log "Your edits are in $(git -C "${repo}" stash list -n 1 --format='%gd (%gs)'). Make them in the source repo, then: git -C ${repo} stash drop"
            return 1
        fi
    fi
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
