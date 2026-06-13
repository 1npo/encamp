PROJECT_ROOT="${BATS_TEST_DIRNAME}/.."
SCRIPTS_DIR="${PROJECT_ROOT}/scripts"

setup_mock_env() {
    TEST_TMPDIR="$(mktemp -d)"
    MOCK_BIN="${TEST_TMPDIR}/bin"
    MOCK_LOG="${TEST_TMPDIR}/mock.log"
    TEST_HOME="${TEST_TMPDIR}/home"

    mkdir -p "${MOCK_BIN}" "${TEST_HOME}"
    touch "${MOCK_LOG}"

    export HOME="${TEST_HOME}"
    export MOCK_BIN MOCK_LOG TEST_TMPDIR
    export PATH="${MOCK_BIN}:${PATH}"
}

teardown_mock_env() {
    rm -rf "${TEST_TMPDIR}"
}

make_mock_cmd() {
    local name="$1"
    local exit_code="${2:-0}"
    local body="${3:-}"

    {
        printf '#!/usr/bin/bash\n'
        printf 'echo "%s: $*" >> "${MOCK_LOG}"\n' "${name}"
        [[ -n "${body}" ]] && printf '%s\n' "${body}"
        printf 'exit %s\n' "${exit_code}"
    } > "${MOCK_BIN}/${name}"
    chmod +x "${MOCK_BIN}/${name}"
}

make_pass_through_sudo() {
    cat > "${MOCK_BIN}/sudo" << 'MOCK_EOF'
#!/usr/bin/bash
echo "sudo: $*" >> "${MOCK_LOG}"
"$@"
MOCK_EOF
    chmod +x "${MOCK_BIN}/sudo"
}

make_noop_sudo() {
    cat > "${MOCK_BIN}/sudo" << 'MOCK_EOF'
#!/usr/bin/bash
echo "sudo: $*" >> "${MOCK_LOG}"
exit 0
MOCK_EOF
    chmod +x "${MOCK_BIN}/sudo"
}

fail() {
    echo "FAIL: $*" >&2
    return 1
}

assert_mock_called() {
    local name="$1"
    local substring="${2:-}"
    if [[ -n "${substring}" ]]; then
        grep -qE "^${name}:.*${substring}" "${MOCK_LOG}" || \
            fail "Expected mock '${name}' to be called with '${substring}'. Log:$(printf '\n'; cat "${MOCK_LOG}")"
    else
        grep -q "^${name}:" "${MOCK_LOG}" || \
            fail "Expected mock '${name}' to be called. Log:$(printf '\n'; cat "${MOCK_LOG}")"
    fi
}

assert_mock_not_called() {
    local name="$1"
    if grep -q "^${name}:" "${MOCK_LOG}"; then
        fail "Expected mock '${name}' NOT to be called, but it was. Log:$(printf '\n'; cat "${MOCK_LOG}")"
    fi
}