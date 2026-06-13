#!/usr/bin/env bats

load 'test_helper'

UTILS="${SCRIPTS_DIR}/lib/utils.sh"

setup() {
    setup_mock_env
}

teardown() {
    teardown_mock_env
}

# --- log ---

@test "log outputs ===> prefix" {
    source "${UTILS}"
    run log "hello"
    [ "$status" -eq 0 ]
    [ "$output" = "===> hello" ]
}

@test "log passes all arguments as one message" {
    source "${UTILS}"
    run log "foo" "bar"
    [ "$status" -eq 0 ]
    [ "$output" = "===> foo bar" ]
}

@test "log with empty string outputs ===> prefix only" {
    source "${UTILS}"
    run log ""
    [ "$status" -eq 0 ]
    [[ "$output" =~ ^"===>" ]]
}

# --- VERSION ---

@test "VERSION is set from VERSION file" {
    source "${UTILS}"
    local expected
    expected=$(cat "${PROJECT_ROOT}/VERSION")
    [ -n "${VERSION}" ]
    [ "${VERSION}" = "${expected}" ]
}

# --- run_step ---

@test "run_step skips when check_cmd is in PATH" {
    run bash -c "source '${UTILS}'; dummy() { echo 'ran'; }; run_step dummy bash"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Skipping dummy" ]]
    [[ ! "$output" =~ "ran" ]]
}

@test "run_step runs func when check_cmd is empty string" {
    run bash -c "source '${UTILS}'; marker() { echo 'marker ran'; }; run_step marker ''"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "marker ran" ]]
}

@test "run_step runs func when check_cmd is not in PATH" {
    run bash -c "source '${UTILS}'; marker() { echo 'marker ran'; }; run_step marker '__not_a_real_cmd_xyz__'"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "marker ran" ]]
}

@test "run_step forwards extra args to func" {
    run bash -c "source '${UTILS}'; echo_args() { echo \"args: \$*\"; }; run_step echo_args '' arg1 arg2"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "args: arg1 arg2" ]]
}

@test "run_step logs Running and Finished on success" {
    run bash -c "source '${UTILS}'; noop() { :; }; run_step noop ''"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Running noop" ]]
    [[ "$output" =~ "Finished running noop" ]]
}

@test "run_step exits with func exit code on failure" {
    run bash -c "source '${UTILS}'; bad() { return 5; }; run_step bad ''"
    [ "$status" -eq 5 ]
}

@test "run_step logs error message on failure" {
    run bash -c "source '${UTILS}'; bad() { return 1; }; run_step bad ''"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error: bad failed" ]]
}

@test "run_step calls cleanup on exit code 130" {
    run bash -c "source '${UTILS}'; interrupted() { return 130; }; run_step interrupted ''"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Ctrl-C" ]]
}

# --- cleanup ---

@test "cleanup exits with status 1" {
    run bash -c "source '${UTILS}'; cleanup"
    [ "$status" -eq 1 ]
}

@test "cleanup logs Ctrl-C message" {
    run bash -c "source '${UTILS}'; cleanup"
    [[ "$output" =~ "Ctrl-C" ]]
}