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

# --- install_external_skills ---

make_skill_origin() {
    ORIGIN="${TEST_TMPDIR}/origin"
    git init -q -b main "${ORIGIN}"
    echo "1.0.0" > "${ORIGIN}/VERSION"
    git -C "${ORIGIN}" add VERSION
    git -C "${ORIGIN}" -c user.name=t -c user.email=t@t commit -q -m one
    EXTERNAL_SKILLS=("dossier ${ORIGIN}")
}

@test "install_external_skills clones a skill that is missing" {
    rm -f "${MOCK_BIN}/git"
    make_skill_origin
    run install_external_skills
    [ "$status" -eq 0 ]
    [ "$(cat "${HOME}/.claude/skills/dossier/VERSION")" = "1.0.0" ]
}

@test "install_external_skills pulls new commits into an existing clone" {
    rm -f "${MOCK_BIN}/git"
    make_skill_origin
    install_external_skills
    echo "1.1.0" > "${ORIGIN}/VERSION"
    git -C "${ORIGIN}" -c user.name=t -c user.email=t@t commit -q -am two
    run install_external_skills
    [ "$status" -eq 0 ]
    [ "$(cat "${HOME}/.claude/skills/dossier/VERSION")" = "1.1.0" ]
}

@test "install_external_skills replaces a stale stow symlink with a clone" {
    rm -f "${MOCK_BIN}/git"
    make_skill_origin
    mkdir -p "${HOME}/.claude/skills"
    ln -s "${TEST_TMPDIR}/gone" "${HOME}/.claude/skills/dossier"
    run install_external_skills
    [ "$status" -eq 0 ]
    [ ! -L "${HOME}/.claude/skills/dossier" ]
    [ -d "${HOME}/.claude/skills/dossier/.git" ]
}

@test "install_external_skills leaves a clone with local changes alone" {
    rm -f "${MOCK_BIN}/git"
    make_skill_origin
    install_external_skills
    echo "edited" > "${HOME}/.claude/skills/dossier/VERSION"
    echo "1.1.0" > "${ORIGIN}/VERSION"
    git -C "${ORIGIN}" -c user.name=t -c user.email=t@t commit -q -am two
    run install_external_skills
    [ "$status" -eq 0 ]
    [[ "$output" =~ "local changes" ]]
    [ "$(cat "${HOME}/.claude/skills/dossier/VERSION")" = "edited" ]
}
