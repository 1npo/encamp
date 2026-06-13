#!/usr/bin/env bats

load 'test_helper'

setup() {
    setup_mock_env
    make_pass_through_sudo
    make_mock_cmd "systemctl" 0
    make_mock_cmd "hostname" 0 'echo "testhost"'
    source "${SCRIPTS_DIR}/lib/install_services.sh"
    SHARE_DIR="${TEST_TMPDIR}/share"
    mkdir -p "${TEST_HOME}/.config/systemd/user"
}

teardown() {
    teardown_mock_env
}

# --- install_user_services ---

@test "install_user_services returns 0 with no services" {
    run install_user_services
    [ "$status" -eq 0 ]
    [[ "$output" =~ "No user services to enable" ]]
}

@test "install_user_services returns 1 when service file is missing" {
    run install_user_services missing.service
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error: service definition not found" ]]
}

@test "install_user_services calls systemctl daemon-reload when services present" {
    touch "${TEST_HOME}/.config/systemd/user/foo.service"
    run install_user_services foo.service
    [ "$status" -eq 0 ]
    assert_mock_called "systemctl" "daemon-reload"
}

@test "install_user_services calls systemctl enable with service names" {
    touch "${TEST_HOME}/.config/systemd/user/foo.service"
    run install_user_services foo.service
    [ "$status" -eq 0 ]
    assert_mock_called "systemctl" "enable foo.service"
}

@test "install_user_services returns 1 if any service in list is missing" {
    touch "${TEST_HOME}/.config/systemd/user/foo.service"
    run install_user_services foo.service bar.service
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error: service definition not found" ]]
}

# --- install_system_services ---

@test "install_system_services returns 0 when no service dir exists" {
    run install_system_services
    [ "$status" -eq 0 ]
    [[ "$output" =~ "No system services" ]]
}

@test "install_system_services returns 0 when service dir is empty" {
    local svc_dir="${SHARE_DIR}/configs/system/testhost/etc/systemd/system"
    mkdir -p "${svc_dir}"
    run install_system_services
    [ "$status" -eq 0 ]
    [[ "$output" =~ "No system services" ]]
}

@test "install_system_services calls systemctl when service files exist" {
    local svc_dir="${SHARE_DIR}/configs/system/testhost/etc/systemd/system"
    mkdir -p "${svc_dir}"
    echo "[Unit]" > "${svc_dir}/test.service"
    run install_system_services
    [ "$status" -eq 0 ]
    assert_mock_called "systemctl"
}

@test "install_system_services finds services at configs/system not encamp/configs/system" {
    local correct_svc_dir="${SHARE_DIR}/configs/system/testhost/etc/systemd/system"
    mkdir -p "${correct_svc_dir}"
    echo "[Unit]" > "${correct_svc_dir}/test.service"
    run install_system_services
    [ "$status" -eq 0 ]
    assert_mock_called "systemctl"
}
