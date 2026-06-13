#!/usr/bin/bash
#
# Entry point for encamp
#

SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")

source "${SCRIPT_DIR}/settings.sh"
source "${SCRIPT_DIR}/lib/utils.sh"

trap cleanup INT
trap cleanup SIGINT

log "Starting encamp v${VERSION}"

MODULES=(
    all
    config-user
    config-system
    packages
    services
)

TARGETS_PATTERN=$(IFS="|"; echo "${TARGETS[*]}")
TARGETS_STRING=$((IFS=","; echo "${TARGETS[*]}") | sed 's/,/, /g')

MODULES_PATTERN=$(IFS="|"; echo "${MODULES[*]}")
MODULES_STRING=$((IFS=","; echo "${MODULES[*]}") | sed 's/,/, /g')

if [ $# -lt 1 ]; then
    log ""
    log "Usage: $0 [target] <module>"
    log ""
    log "Available targets: ${TARGETS_STRING}"
    log "Available modules: ${MODULES_STRING}"
    log ""
    log "Example: $0 base all"
    exit 1
fi

TARGET="${1:-base}"
MODULE="${2:-all}"

if [[ ! "$TARGET" =~ ^($TARGETS_PATTERN)$ ]]; then
    log "Error: invalid target '$TARGET'. Must be one of: $TARGETS_STRING"
    exit 1
fi

if [[ ! "$MODULE" =~ ^($MODULES_PATTERN)$ ]]; then
    log "Error: invalid module '$MODULE'. Must be one of: $MODULES_STRING"
    exit 1
fi

grep -qxF "${TARGET}" "${STATE_DIR}/targets" 2>/dev/null || echo "${TARGET}" >> "${STATE_DIR}/targets"

log "Encamping on this target: ${TARGET}"
log "Encamping this module: ${MODULE}"

source "${SCRIPT_DIR}/targets/${TARGET}.sh"

case "$MODULE" in
    all)           packages; config_user; config_system; services ;;
    packages)      packages ;;
    config-user)   config_user ;;
    config-system) config_system ;;
    services)      services ;;
esac