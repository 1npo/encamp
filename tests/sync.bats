#!/usr/bin/env bats

load 'test_helper'

SYNC="${SCRIPTS_DIR}/sync.sh"

run_sync() {
    run env HOME="${TEST_HOME}" PATH="${MOCK_BIN}:${PATH}" bash "${SYNC}" "$@"
}

# Runs sync.sh with MOCK_GIT_DIRTY=1 to simulate a dirty working tree.
run_sync_dirty() {
    run env HOME="${TEST_HOME}" PATH="${MOCK_BIN}:${PATH}" MOCK_GIT_DIRTY=1 bash "${SYNC}" "$@"
}

setup() {
    setup_mock_env
    # Git mock: outputs dirty status when MOCK_GIT_DIRTY is set, clean otherwise.
    make_mock_cmd "git" 0 'if [[ "$*" == *"status"* ]] && [[ -n "${MOCK_GIT_DIRTY}" ]]; then echo "M  file.txt"; fi'
    make_mock_cmd "stow" 0
}

teardown() {
    teardown_mock_env
}

# --- Argument validation ---

@test "sync.sh exits 1 with no arguments" {
    run_sync
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "sync.sh exits 1 with invalid command" {
    run_sync "deploy"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "invalid command" ]]
}

# --- push ---

@test "sync.sh push logs Nothing to commit when working tree is clean" {
    run_sync "push"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Nothing to commit" ]]
}

@test "sync.sh push does not call git add when working tree is clean" {
    run_sync "push"
    [ "$status" -eq 0 ]
    assert_mock_called "git" "status"
    ! grep -qE "^git:.*add" "${MOCK_LOG}"
}

@test "sync.sh push calls git add then commit then push when tree is dirty" {
    run_sync_dirty "push"
    [ "$status" -eq 0 ]
    assert_mock_called "git" "add"
    assert_mock_called "git" "commit"
    assert_mock_called "git" "push"
}

@test "sync.sh push uses default commit message when none supplied" {
    run_sync_dirty "push"
    [ "$status" -eq 0 ]
    assert_mock_called "git" "Update config-user"
}

@test "sync.sh push uses custom message when supplied" {
    run_sync_dirty "push" "my custom message"
    [ "$status" -eq 0 ]
    assert_mock_called "git" "my custom message"
}

# --- pull ---

@test "sync.sh pull calls git pull" {
    run_sync "pull"
    [ "$status" -eq 0 ]
    assert_mock_called "git" "pull"
}

@test "sync.sh pull warns when no targets file exists" {
    run_sync "pull"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "no targets recorded" ]]
}

@test "sync.sh pull re-stows for each target in state file" {
    local state_dir="${TEST_HOME}/.local/state/encamp"
    mkdir -p "${state_dir}"
    echo "headless-workstation" > "${state_dir}/targets"
    run_sync "pull"
    [ "$status" -eq 0 ]
    assert_mock_called "stow"
}
