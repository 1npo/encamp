# Configs

## Content

- [Configs](#configs)
  - [Content](#content)
  - [Overview](#overview)
  - [User configurations](#user-configurations)
    - [Adding or modifying user configurations](#adding-or-modifying-user-configurations)
  - [System configurations](#system-configurations)
    - [Adding system configurations for a new host](#adding-system-configurations-for-a-new-host)
    - [Important note](#important-note)
  - [Synchronizing configurations across machines](#synchronizing-configurations-across-machines)

## Overview

Configuration files are split into two categories: **user configs** and **system configs**.

They're stored in `configs/user/` and `configs/system/` respectively.

## User configurations

**Location:** `configs/user/`

User configs are dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each subdirectory is a stow package, and its contents mirror the structure relative to `$HOME`. For example, `stow` will symlink `configs/user/git/.gitconfig` to `~/.gitconfig`.

Each target's `config_user` function lists which packages to stow for that machine type. Running `encamp <target> config-user` calls `stow --restow` on each package idempotently, which updates the symlinks to reflect the current state of the repo.

### Adding or modifying user configurations

1. Add or edit files inside the appropriate package directory under `configs/user/`
2. If adding a new package:
   1. Create the directory and populate it with files mirroring their target paths relative to `$HOME`
   2. Add the new package name to the `config_user` function in the relevant target script(s)
3. Run `encamp-sync push` to commit and push the change

## System configurations

**Location:** `configs/system/`

System configs are plain files that get copied (with `sudo`) to their absolute paths on the filesystem. Unlike user configs, stow is not used here.

The directory structure mirrors the filesystem root. For example, `configs/system/portal/etc/network/interfaces` gets copied to `/etc/network/interfaces` on the host named `portal`.

There are two layers:

| Directory | Applied to |
|---|---|
| `configs/system/_base/` | Installed on every host, regardless of hostname |
| `configs/system/<hostname>/` | Installed only the host with this hostname |

The `_base` layer is applied first, then the host-specific layer overwrites any overlapping files.

### Adding system configurations for a new host

1. Create `configs/system/<hostname>/`
2. Add files using the full path structure relative to `/`
    - For example, to manage `/etc/foo/bar.conf`, create `configs/system/<hostname>/etc/foo/bar.conf`
3. Run `encamp <target> config-system` on that host to apply the changes

### Important note

Unlike user configurations, system configurations are copied, not symlinked.

Files that already exist on the machine at the same path(s) defined in `configs/system/` will be overwritten by the files in `configs/system/`.

Changes made to these files on the machine will not be reflected back into the repo automatically.

If you change these files on the machine, you must also apply those changes to the corresponding files in `configs/system/`.

Once you've applied the changes to `configs/system/`, use `encamp-sync` to keep the repo up to date on the remote and each machine in the fleet.

## Synchronizing configurations across machines

`encamp-sync` doesn't synchronize system configurations. See the [important note](#important-note) above for more information.

`encamp-sync` synchronizes user configurations across machines with git and stow.

- `encamp-sync push [message]` does the following:
  1. Stages all changes in the repository
  2. Commits the changes with the given message (or a default timestamped message)
  3. Pushes the changes to the remote

- `encamp-sync pull` does the following:
  1. Pulls from the remote
  2. Re-stows all user config packages for each target recorded in `~/.local/state/encamp/targets`



