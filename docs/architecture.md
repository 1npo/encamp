# Architecture

## Contents

- [Architecture](#architecture)
  - [Contents](#contents)
  - [Overview](#overview)
  - [Directory structure](#directory-structure)
  - [Script execution flow](#script-execution-flow)
  - [Settings](#settings)
  - [State](#state)
  - [Adding a new target](#adding-a-new-target)

## Overview

encamp is a collection of Bash scripts that install packages, deploy configuration files, and enable systemd services on a Debian machine. It is organized around two central concepts: **targets** and **modules**.

A **target** is a named machine type (e.g. `desktop`, `lan-services`). It determines which packages, configs, and services get installed. Every target script defines the same four functions — `packages`, `config_user`, `config_system`, and `services` — which encamp calls as appropriate.

A **module** is one of those four functions, or `all` to run all of them. When you run `encamp <target> <module>`, it sources the target script and calls the corresponding function(s).

## Directory structure

```
encamp/
├── install.sh                  # Bootstrap script
├── VERSION                     # Version string
├── configs/
│   ├── user/                   # User dotfiles, organized as stow packages
│   │   ├── git/
│   │   ├── zsh/
│   │   └── ...
│   └── system/
│       ├── _base/              # Config files applied to every host
│       └── <hostname>/         # Config files applied only to that host
├── docs/
│   ├── guides/                 # Step-by-step setup guides
│   └── *.md                    # Project documentation (this file and others)
└── scripts/
    ├── main.sh                 # Entry point: encamp <target> <module>
    ├── sync.sh                 # Sync tool: encamp-sync push|pull
    ├── settings.sh             # User-adjustable settings
    └── lib/
    │   ├── utils.sh            # Common utilities for logging and running functions
    │   ├── install_via.sh      # Functions for installing apps via package managers
    │   ├── install_app.sh      # Functions for installing specific applications
    │   ├── install_configs.sh  # Functions for installing user and system configurations
    │   └── install_services.sh # Functions that enable user- and system-level systemd services
    └── targets/
        ├── base.sh
        ├── desktop.sh
        ├── headless-workstation.sh
        ├── lan-services.sh
        └── iot-node.sh
```

## Script execution flow

1. `install.sh` is run once on a new machine. It clones the repository to `SHARE_DIR` and creates the following symlinks:
    - `main.sh` -> `~/.local/bin/encamp`
    - `sync.sh` -> `~/.local/binencamp-sync`
2. `encamp <target> <module>` does the following:
    1. Sources `settings.sh` and `lib/utils.sh`
    2. Validates user inputs or prints usage information
    3. Caches a list of targets deployed on this machine
    4. Sources the target script
    5. Calls the requested module function(s)
      - Each module function calls `run_step` in `lib/utils.sh` for each step
1. `run_step <func> [check_cmd] [args...]` does the following:
    - Calls `func`
    - If `check_cmd` is provided and already in `$PATH`, the step is skipped
    - On non-zero exit, encamp aborts
    - The given arguments are passed to the function being run in that step, such as `install_via_apt`

## Settings

`settings.sh` defines the list of valid targets, directory paths, architecture, and general-purpose Python venv settings.

Edit this file as needed to customize these before running encamp on a new machine.

| Variable | Default | Purpose |
|---|---|---|
| `TARGETS` | *(list)* | Valid target names |
| `ARCH` | `x86_64` | Used when downloading architecture-specific binaries |
| `BIN_DIR` | `~/.local/bin` | Where command symlinks are placed |
| `SHARE_DIR` | `~/.local/share/encamp` | Where the repository is cloned to |
| `STATE_DIR` | `~/.local/state/encamp` | Where the log file and list of installed targets is stored |
| `CACHE_DIR` | `~/.cache/encamp` | Where temporary/install files are stored |
| `CREATE_GENERAL_VENV` | `true` | Whether to create a general-purpose Python venv |
| `VENV_DIR` | `~/.venv` | Path to the general Python venv |

## State

encamp records which targets have been applied to a machine in `~/.local/state/encamp/targets`, one target name per line. This is used by `encamp-sync pull` to know which target scripts to re-stow after pulling updated configs.

## Adding a new target

1. Create `scripts/targets/<name>.sh`.
2. Implement the four functions: `packages`, `config_user`, `config_system`, `services`.
3. Add the target name to the `TARGETS` array in `settings.sh`.
4. Add any user config packages to `configs/user/` and any system configs to `configs/system/<hostname>/`.
