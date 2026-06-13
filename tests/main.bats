#!/usr/bin/env bats

load 'test_helper'

MAIN="${SCRIPTS_DIR}/main.sh"

run_main() {
    run env HOME="${TEST_HOME}" PATH="${MOCK_BIN}:${PATH}" bash "${MAIN}" "$@"
}

setup() {
    setup_mock_env
}

teardown() {
    teardown_mock_env
}

# --- Argument validation ---

@test "main.sh exits 1 with no arguments" {
    run_main
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "main.sh exits 1 with invalid target" {
    run_main "not_a_real_target" "all"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "invalid target" ]]
}

@test "main.sh exits 1 with invalid module" {
    run_main "base" "not_a_real_module"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "invalid module" ]]
}

@test "main.sh accepts a valid target with no module and defaults to all" {
    make_mock_cmd "stow" 0
    make_noop_sudo
    make_mock_cmd "systemctl" 0
    make_mock_cmd "hostname" 0 'echo "testhost"'
    mkdir -p "${TEST_HOME}/.config/systemd/user"
    # headless-workstation config_system needs a host config dir to exist
    mkdir -p "${TEST_HOME}/.local/share/encamp/configs/system/testhost"
    run_main "headless-workstation"
    [ "$status" -eq 0 ]
}

# --- State file ---

@test "main.sh records target in state file on successful run" {
    make_mock_cmd "stow" 0
    run_main "base" "config-user"
    [ "$status" -eq 0 ]
    local state_file="${TEST_HOME}/.local/state/encamp/targets"
    [ -f "${state_file}" ]
    grep -q "^base$" "${state_file}"
}

@test "main.sh does not duplicate target in state file on repeated runs" {
    make_mock_cmd "stow" 0
    run_main "base" "config-user"
    run_main "base" "config-user"
    local state_file="${TEST_HOME}/.local/state/encamp/targets"
    local count
    count=$(grep -c "^base$" "${state_file}")
    [ "${count}" -eq 1 ]
}

@test "main.sh records each distinct target separately" {
    make_mock_cmd "stow" 0
    make_mock_cmd "hostname" 0 'echo "testhost"'
    run_main "base" "config-user"
    run_main "headless-workstation" "config-user"
    local state_file="${TEST_HOME}/.local/state/encamp/targets"
    grep -q "^base$" "${state_file}"
    grep -q "^headless-workstation$" "${state_file}"
}
