#!/usr/bin/env bats

load 'test_helper'

setup() {
    setup_mock_env
    make_noop_sudo
    make_mock_cmd "stow" 0
    make_mock_cmd "hostname" 0 'echo "testhost"'
    source "${SCRIPTS_DIR}/lib/install_configs.sh"
    # Override SHARE_DIR to use test temp dir
    SHARE_DIR="${TEST_TMPDIR}/share"
    mkdir -p "${SHARE_DIR}/configs/user"
}

teardown() {
    teardown_mock_env
}

# --- install_user_configs ---

@test "install_user_configs returns 0 with no packages" {
    run install_user_configs
    [ "$status" -eq 0 ]
    [[ "$output" =~ "No dotfile packages to stow" ]]
}

@test "install_user_configs calls stow for each package" {
    run install_user_configs git zsh
    [ "$status" -eq 0 ]
    local stow_calls
    stow_calls=$(grep -c "^stow:" "${MOCK_LOG}")
    [ "${stow_calls}" -eq 2 ]
}

@test "install_user_configs passes --dir pointing to configs/user" {
    run install_user_configs git
    [ "$status" -eq 0 ]
    assert_mock_called "stow" "configs/user"
}

@test "install_user_configs passes --target pointing to HOME" {
    run install_user_configs git
    [ "$status" -eq 0 ]
    assert_mock_called "stow" "${HOME}"
}

@test "install_user_configs passes --restow and package name" {
    run install_user_configs git
    [ "$status" -eq 0 ]
    assert_mock_called "stow" "--restow git"
}

# --- install_system_configs ---

@test "install_system_configs returns 1 when no host config dir exists" {
    run install_system_configs
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error: no system configs found" ]]
}

@test "install_system_configs returns 0 when host config dir exists" {
    mkdir -p "${SHARE_DIR}/configs/system/testhost"
    run install_system_configs
    [ "$status" -eq 0 ]
}

@test "install_system_configs copies _base files when _base dir exists" {
    mkdir -p "${SHARE_DIR}/configs/system/_base/etc"
    echo "base config" > "${SHARE_DIR}/configs/system/_base/etc/base.conf"
    mkdir -p "${SHARE_DIR}/configs/system/testhost"
    run install_system_configs
    [ "$status" -eq 0 ]
    assert_mock_called "sudo" "cp"
}

@test "install_system_configs skips _base when _base dir is absent" {
    mkdir -p "${SHARE_DIR}/configs/system/testhost"
    run install_system_configs
    [ "$status" -eq 0 ]
    assert_mock_not_called "sudo"
}

@test "install_system_configs copies host-specific files" {
    mkdir -p "${SHARE_DIR}/configs/system/testhost/etc"
    echo "host config" > "${SHARE_DIR}/configs/system/testhost/etc/host.conf"
    run install_system_configs
    [ "$status" -eq 0 ]
    assert_mock_called "sudo" "cp"
}
