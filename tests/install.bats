#!/usr/bin/env bats

load 'test_helper'

INSTALL="${PROJECT_ROOT}/install.sh"

setup() {
    setup_mock_env
    TEST_SHARE="${TEST_HOME}/.local/share/encamp"
    TEST_BIN="${TEST_HOME}/.local/bin"
    # Create stub scripts so install.sh can chmod them after symlinking
    mkdir -p "${TEST_SHARE}/scripts"
    touch "${TEST_SHARE}/scripts/main.sh"
    touch "${TEST_SHARE}/scripts/sync.sh"
    make_mock_cmd "git" 0
}

teardown() {
    teardown_mock_env
}

# --- git prerequisite check ---

@test "install.sh exits 1 when git is not in PATH" {
    # Remove git from MOCK_BIN (setup creates it for other tests) then use explicit bash path
    rm -f "${MOCK_BIN}/git"
    run env HOME="${TEST_HOME}" PATH="${MOCK_BIN}" /bin/bash "${INSTALL}"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "git is required" ]]
}

# --- repository cloning ---

@test "install.sh clones repo on fresh install" {
    run env HOME="${TEST_HOME}" PATH="${MOCK_BIN}:${PATH}" bash "${INSTALL}"
    [ "$status" -eq 0 ]
    assert_mock_called "git" "clone"
}

@test "install.sh skips git clone when repo already exists" {
    mkdir -p "${TEST_SHARE}/.git"
    run env HOME="${TEST_HOME}" PATH="${MOCK_BIN}:${PATH}" bash "${INSTALL}"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "already exists" ]]
    assert_mock_not_called "git"
}

@test "install.sh logs done after successful install" {
    run env HOME="${TEST_HOME}" PATH="${MOCK_BIN}:${PATH}" bash "${INSTALL}"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Done" ]]
}

# --- symlinks ---

@test "install.sh creates encamp symlink in BIN_DIR" {
    run env HOME="${TEST_HOME}" PATH="${MOCK_BIN}:${PATH}" bash "${INSTALL}"
    [ "$status" -eq 0 ]
    [ -L "${TEST_BIN}/encamp" ]
}

@test "install.sh creates encamp-sync symlink in BIN_DIR" {
    run env HOME="${TEST_HOME}" PATH="${MOCK_BIN}:${PATH}" bash "${INSTALL}"
    [ "$status" -eq 0 ]
    [ -L "${TEST_BIN}/encamp-sync" ]
}

@test "install.sh encamp symlink points to main.sh" {
    run env HOME="${TEST_HOME}" PATH="${MOCK_BIN}:${PATH}" bash "${INSTALL}"
    [ "$status" -eq 0 ]
    local target
    target="$(readlink "${TEST_BIN}/encamp")"
    [ "${target}" = "${TEST_SHARE}/scripts/main.sh" ]
}

@test "install.sh encamp-sync symlink points to sync.sh" {
    run env HOME="${TEST_HOME}" PATH="${MOCK_BIN}:${PATH}" bash "${INSTALL}"
    [ "$status" -eq 0 ]
    local target
    target="$(readlink "${TEST_BIN}/encamp-sync")"
    [ "${target}" = "${TEST_SHARE}/scripts/sync.sh" ]
}
