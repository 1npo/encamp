#!/usr/bin/env bats

load 'test_helper'

setup() {
    setup_mock_env
    source "${SCRIPTS_DIR}/settings.sh"
}

teardown() {
    teardown_mock_env
}

# --- TARGETS array ---

@test "TARGETS array is defined and non-empty" {
    [ "${#TARGETS[@]}" -gt 0 ]
}

# Known-failing test: iot-node has a target script but is missing from settings.sh TARGETS.
# This test will fail until settings.sh is updated to include 'iot-node' in TARGETS.
@test "every target file has a matching entry in TARGETS" {
    for target_file in "${SCRIPTS_DIR}/targets/"*.sh; do
        local target_name
        target_name=$(basename "${target_file}" .sh)
        local found=false
        for t in "${TARGETS[@]}"; do
            [[ "${t}" == "${target_name}" ]] && found=true && break
        done
        if [[ "${found}" != "true" ]]; then
            fail "Target script '${target_name}.sh' exists but '${target_name}' is not in TARGETS in settings.sh"
        fi
    done
}

@test "every TARGETS entry has a corresponding target script" {
    for target in "${TARGETS[@]}"; do
        [ -f "${SCRIPTS_DIR}/targets/${target}.sh" ] || \
            fail "TARGETS contains '${target}' but scripts/targets/${target}.sh does not exist"
    done
}

# --- Directory variables ---

@test "BIN_DIR is under HOME" {
    [[ "${BIN_DIR}" == "${HOME}"* ]]
}

@test "STATE_DIR is under HOME" {
    [[ "${STATE_DIR}" == "${HOME}"* ]]
}

@test "SHARE_DIR is under HOME" {
    [[ "${SHARE_DIR}" == "${HOME}"* ]]
}

@test "CACHE_DIR is under HOME" {
    [[ "${CACHE_DIR}" == "${HOME}"* ]]
}

# --- Directory creation ---

@test "settings.sh creates BIN_DIR on source" {
    [ -d "${BIN_DIR}" ]
}

@test "settings.sh creates STATE_DIR on source" {
    [ -d "${STATE_DIR}" ]
}

@test "settings.sh creates SHARE_DIR on source" {
    [ -d "${SHARE_DIR}" ]
}

@test "settings.sh creates CACHE_DIR on source" {
    [ -d "${CACHE_DIR}" ]
}

# --- Other settings ---

@test "ARCH is set to x86_64 by default" {
    [ "${ARCH}" = "x86_64" ]
}
