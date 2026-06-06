#!/usr/bin/bash
#
# Defines utility functions used by the other encamp scripts
#

VERSION=$(cat ../VERSION)

log() {
    echo "===> $*"
    echo "===> $*" >&2
}

run_step() {
    local func="$1"
    local check_cmd="$2"
    shift 2
    if [[ -n "$check_cmd" ]] && command -v "$check_cmd" &>/dev/null; then
        log "Skipping ${func}: '${check_cmd}' is already in \$PATH"
        return 0
    fi
    log "Running ${func}..."
    "$func" "$@"
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        log "ERROR: ${func} failed with exit code ${exit_code}"
        return $exit_code
    fi
    log "Finished running ${func}"
}

cleanup() {
    log "Received Ctrl-C from user, quitting..."
    exit 1
}