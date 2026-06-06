#!/usr/bin/bash
#
# Entry point for running encamp scripts
#

source utils.sh
source targets.sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 [target] <all|dotfiles|packages|services>"
    exit 1
fi

TARGET="$1"
MODULE="${2:-all}"

case "$MODULE" in
    all|dotfiles|packages|services)
        ;;
    *)
        log "Error: invalid module '$MODULE'. Must be one of: all, dotfiles, packages, services"
        exit 1
        ;;
esac

log "Starting encamp v${VERSION}"
log "Target: ${TARGET}"
log "Module: ${MODULE}"

case "$MODULE" in
    all)
        ;;
    dotfiles)
        ;;
    packages)
        ;;
    services)
        ;;
    *)
esac
