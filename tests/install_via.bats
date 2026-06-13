#!/usr/bin/env bats

load 'test_helper'

setup() {
    setup_mock_env
    make_pass_through_sudo
    make_mock_cmd "apt-get" 0
    make_mock_cmd "cargo" 0
    source "${SCRIPTS_DIR}/lib/install_via.sh"
    # Override VENV_PYTHON after settings.sh sets it
    VENV_PYTHON="${MOCK_BIN}/python"
    make_mock_cmd "python" 0
}

teardown() {
    teardown_mock_env
}

# --- install_via_apt ---

@test "install_via_apt returns 1 with no packages" {
    run install_via_apt
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Nothing to install" ]]
}

@test "install_via_apt calls apt-get update" {
    run install_via_apt curl git
    [ "$status" -eq 0 ]
    assert_mock_called "apt-get" "update"
}

@test "install_via_apt calls apt-get install with package list" {
    run install_via_apt curl git
    [ "$status" -eq 0 ]
    assert_mock_called "apt-get" "install"
}

# --- install_via_cargo ---

@test "install_via_cargo returns 1 with no packages" {
    run install_via_cargo
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Nothing to install" ]]
}

@test "install_via_cargo calls cargo install with packages" {
    run install_via_cargo ripgrep bat
    [ "$status" -eq 0 ]
    assert_mock_called "cargo" "install"
}

# --- install_via_pip ---

@test "install_via_pip returns 1 with no packages" {
    run install_via_pip
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Nothing to install" ]]
}

@test "install_via_pip calls python -m pip install with packages" {
    run install_via_pip requests numpy
    [ "$status" -eq 0 ]
    assert_mock_called "python" "pip install"
}
