# Developer Guide

## Contents

- [Developer Guide](#developer-guide)
  - [Contents](#contents)
  - [Project Layout](#project-layout)
  - [Extending Encamp](#extending-encamp)
    - [Adding a New Target](#adding-a-new-target)
    - [Adding Configuration Files](#adding-configuration-files)
    - [Updating the Version](#updating-the-version)
  - [Testing](#testing)
    - [Prerequisites](#prerequisites)
    - [Running the Tests](#running-the-tests)
    - [Test Organization](#test-organization)
    - [Mock Infrastructure](#mock-infrastructure)
    - [Writing a New Test](#writing-a-new-test)
    - [Known Failing Tests](#known-failing-tests)

## Project Layout

```
encamp/
├── install.sh          # Bootstrap script (run once on a new machine)
├── VERSION             # Version string
├── configs/
│   ├── user/           # Dotfiles as stow packages
│   └── system/
│       ├── _base/      # Applied to every host
│       └── <hostname>/ # Applied only to that host
├── docs/               # Project documentation
└── scripts/
    ├── main.sh         # encamp <target> <module>
    ├── sync.sh         # encamp-sync push|pull
    ├── settings.sh     # User-adjustable settings
    ├── lib/            # Shared library functions
    └── targets/        # One script per target
```

See [architecture.md](architecture.md) for a detailed description of how the scripts work together.

## Extending Encamp

### Adding a New Target

1. Create `scripts/targets/<name>.sh` and implement the four functions: `packages`, `config_user`, `config_system`, and `services`.
2. Add `<name>` to the `TARGETS` array in `scripts/settings.sh`.
3. Add any dotfiles to `configs/user/` and any system configs to `configs/system/<hostname>/`.

See [architecture.md](architecture.md) for the full checklist.

> **Note:** `settings.bats` will automatically catch any target script that is missing from the `TARGETS` array.

### Adding Configuration Files

User configs go in `configs/user/<package>/` as a [GNU stow](https://www.gnu.org/software/stow/) package — the directory tree mirrors `$HOME`. System configs go in `configs/system/_base/` (for all hosts) or `configs/system/<hostname>/` (for one host), mirroring the root filesystem (`/`).

See [configs.md](configs.md) for more detail.

### Updating the Version

Edit the `VERSION` file at the project root. The version string is read at runtime by `scripts/lib/utils.sh` and printed when encamp starts.

## Testing

### Prerequisites

Install bats-core and its helper libraries:

```sh
sudo apt install bats bats-assert bats-support
```

Minimum required version: **bats 1.11**. Verify with:

```sh
bats --version
```

### Running the Tests

Run the full test suite from the project root:

```sh
bats tests/
```

Run a single test file:

```sh
bats tests/utils.bats
```

Run a single test by name:

```sh
bats --filter "log outputs" tests/utils.bats
```

### Test Organization

Tests live in the `tests/` directory. Each file covers one script or library module.

| File | Covers |
|---|---|
| `utils.bats` | `log`, `run_step`, `cleanup`, `VERSION` |
| `install_via.bats` | `install_via_apt`, `install_via_cargo`, `install_via_pip` |
| `install_configs.bats` | `install_user_configs`, `install_system_configs` |
| `install_services.bats` | `install_user_services`, `install_system_services` |
| `settings.bats` | `TARGETS` array, directory variables, directory creation |
| `main.bats` | `encamp` CLI — argument validation and state file recording |
| `sync.bats` | `encamp-sync` CLI — push/pull behavior |
| `install.bats` | `install.sh` bootstrap — git check, cloning, symlinks |

Shared setup helpers are in `tests/test_helper.bash`, which every test file loads.

### Mock Infrastructure

Tests never invoke real system commands. `test_helper.bash` provides a mock system:

- **`setup_mock_env()`** — creates a temporary `$HOME`, a `MOCK_BIN` directory prepended to `$PATH`, and a `MOCK_LOG` file. Call this at the top of every `setup()`.
- **`teardown_mock_env()`** — deletes the temporary directories. Call this in every `teardown()`.
- **`make_mock_cmd name [exit_code] [body]`** — creates an executable stub in `MOCK_BIN`. Every invocation is appended to `MOCK_LOG` as `name: <args>`.
- **`make_pass_through_sudo()`** — creates a `sudo` stub that forwards its arguments (so `sudo apt-get` finds the `apt-get` mock).
- **`make_noop_sudo()`** — creates a `sudo` stub that logs and exits 0 without doing anything.
- **`assert_mock_called name [substring]`** — fails the test if `name` was never called, optionally checking that the call included `substring`.
- **`assert_mock_not_called name`** — fails the test if `name` was called at all.

Example:

```bash
setup() {
    setup_mock_env
    make_mock_cmd "stow" 0
    source "${SCRIPTS_DIR}/lib/install_configs.sh"
}

@test "install_user_configs calls stow" {
    SHARE_DIR="${TEST_TMPDIR}/share"
    mkdir -p "${SHARE_DIR}/configs/user"
    run install_user_configs git
    [ "$status" -eq 0 ]
    assert_mock_called "stow" "--restow git"
}
```

### Writing a New Test

1. Add a `@test` block to the relevant `.bats` file.
2. Call `setup_mock_env()` in `setup()` if not already done.
3. Create any mocks your test needs with `make_mock_cmd`.
4. For functions that call `exit`, use `run bash -c "source ...; func_call"` rather than calling the function directly.
5. Use `run` to capture output and status, then assert with `[ "$status" -eq ... ]` and `[[ "$output" =~ "..." ]]`.

### Known Failing Tests

These tests document known bugs and are expected to fail until the underlying issue is fixed.

| Test | File | Bug |
|---|---|---|
| `every target file has a matching entry in TARGETS` | `settings.bats` | `iot-node.sh` exists in `scripts/targets/` but `iot-node` is not listed in `TARGETS` in `settings.sh` |
| `install_system_services finds services at configs/system not encamp/configs/system` | `install_services.bats` | `install_system_services` looks in `${SHARE_DIR}/encamp/configs/...` — since `SHARE_DIR` already ends in `encamp`, the segment is doubled and services are never found |
