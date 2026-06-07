# encamp

A lightweight tool for provisioning a fleet of Debian machines and keeping their user configurations synchronized.

## Contents

- [encamp](#encamp)
  - [Contents](#contents)
  - [Installation](#installation)
  - [Usage](#usage)
    - [encamp](#encamp-1)
      - [Examples](#examples)
    - [encamp-sync](#encamp-sync)
      - [Examples](#examples-1)
  - [Documentation](#documentation)
    - [Guides](#guides)
    - [Project Documentation](#project-documentation)
  - [GenAI Usage Disclosure](#genai-usage-disclosure)

## Installation

Run the bootstrap script on the target machine:

```sh
curl -fsSL https://raw.githubusercontent.com/1npo/encamp/main/install.sh | bash
```

This clones the repository to `~/.local/share/encamp` and adds `encamp` and `encamp-sync` to `~/.local/bin` as symlinks.

## Usage

### encamp

```
encamp <target> [module]
```

**Targets** define the machine type:

| Target | Description |
|---|---|
| `base` | Common baseline for all machines |
| `desktop` | Machines with a graphical desktop environment |
| `headless-workstation` | Machines serving as workstations without a GUI |
| `lan-services` | Machines providing network services to the LAN |
| `iot-node` | Machines that are embedded or small IoT devices |

**Modules** select what to install:

| Module | Description |
|---|---|
| `all` | Installs everything (default) |
| `packages` | Installs applications (via curl or a package manager) |
| `config-user` | Installs user configurations (via stow) |
| `config-system` | Installs system configuration (per hostname) |
| `services` | Enables systemd user and system services |

#### Examples

Set up a fresh desktop machine:

```sh
encamp base all
encamp desktop all
```

Install desktop-specific packages only:

```sh
encamp desktop packages
```

Apply desktop-specific user configurations only:

```sh
encamp desktop config-user
```

### encamp-sync

Synchronizes user configurations with the git remote.

```
encamp-sync <command> [message]
```

| Command | Description |
|---|---|
| `pull` | Pull latest changes from the remote and re-stow configurations |
| `push <message>` | Commit local configuration changes and push them to the remote |

#### Examples

```sh
encamp-sync pull
encamp-sync push "updated zsh config"
```

## Documentation

### Guides

See [docs/guides/](docs/guides/) for instructions on how to perform some manual setups.

- [Bitwarden with pass](docs/guides/bitwarden-with-pass.md)
- [GPG agent, pass, and keyring](docs/guides/gpg-agent-pass-keyring.md)
- [GPG agent](docs/guides/gpg-agent.md)
- [Niri with DankMaterialShell](docs/guides/niri-with-dmr.md)
- [Neovim plugins](docs/guides/nvim-plugins.md)
- [SSH agent](docs/guides/ssh-agent.md)
- [tmux plugins](docs/guides/tmux-plugins.md)

### Project Documentation

See [docs/](docs/) for reference materials to help you understand and maintain this project.

| Document | Description |
|---|---|
| [Architecture](docs/architecture.md) | How `encamp` is structured and how its components work together |
| [Configs](docs/configs.md) | How user and system configurations are organized and managed |
| [Adding a new machine](docs/new-machine.md) | A checklist for onboarding a new host |

## GenAI Usage Disclosure

Claude Sonnet 4.6 (Low Effort) was used in the development of this project in the following capacities.

Everything in this project, except the items listed below, was developed and written by me.

- Writing the first draft of this README.md
- Writing the first drafts of the project documentation
- Troubleshooting errors
- Suggesting and implementing various best practice changes:
  - Reorganizing the project layout to reduce complexity and number of files needed
  - Implementing the following code using the conventions and style used in other modules:
    - `scripts/lib/install_services.sh`
    - `scripts/lib/install_configs.sh`
    - `scripts/sync.sh`
    - `install.sh`
    - The following functions in `scripts/lib/install_app.sh`:
      - `install_obsidian`
      - `install_proton_bridge`
    - The method used in the header of all scripts to safely import the library scripts
    - The `run_step` function in `scripts/lib/utils.sh`
