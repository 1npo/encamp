# Adding a new machine

This is the procedure for using `encamp` to provision a fresh Debian install.

## Contents

- [Adding a new machine](#adding-a-new-machine)
  - [Contents](#contents)
  - [1. Install encamp](#1-install-encamp)
  - [2. Set the hostname (if needed)](#2-set-the-hostname-if-needed)
  - [3. Add system configs for the new host (if needed)](#3-add-system-configs-for-the-new-host-if-needed)
  - [4. Add a new target type (if needed)](#4-add-a-new-target-type-if-needed)
  - [5. Run encamp on the new machine](#5-run-encamp-on-the-new-machine)
  - [6. Complete any manual setups](#6-complete-any-manual-setups)

## 1. Install encamp

```sh
curl -fsSL https://raw.githubusercontent.com/1npo/encamp-v2/main/install.sh | bash
```

This clones the repo and adds `encamp` and `encamp-sync` to `~/.local/bin`.

Make sure `~/.local/bin` is in your `$PATH` before continuing.

## 2. Set the hostname (if needed)

If needed, set or change the machine's hostname:

```sh
sudo hostnamectl set-hostname <hostname>
```

If the machine needs host-specific system configs (e.g. a static IP), there must be a directory under `configs/system/` that matches its hostname.

See [Configs](configs.md) for more information.

## 3. Add system configs for the new host (if needed)

If this machine needs host-specific system configuration:

1. Create `configs/system/<hostname>/` in the repo
2. Populate it with files using the full path structure relative to `/`
3. Commit and push the changes with `encamp-sync push`

See [Configs](configs.md) for more information.

## 4. Add a new target type (if needed)

If this machine doesn't fit any existing target, create a new one:

1. Create `scripts/targets/<name>.sh` and implement the four installer functions:
   - `packages`
   - `config_user`
   - `config_system`
   - `services`
2. Add the target name to the `TARGETS` array in `scripts/settings.sh`
3. Add any new user configurations for this target to `configs/user/` as stow packages
4. Commit and push the changes with `encamp-sync push`

See [Architecture](architecture.md) for a full explanation of how target scripts work.

## 5. Run encamp on the new machine

Install `base` first, then the machine-specific target:

```sh
encamp base all
encamp <target> all
```

If you only want to install certain modules, replace `all` with one of the following:

- `packages`
- `config-user`
- `config-system`
- `services`

## 6. Complete any manual setups

Some setup steps can't be automated.

Check the [guides](guides/) for anything relevant to this machine's configuration.

