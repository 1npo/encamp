---
name: py-projects
description: Conventions for creating, structuring, and maintaining Python projects, including the version bump tool. Use when working on a Python project, and whenever bumping or releasing one. Not for other languages. (Structure and Setup sections are still TODO.)
---

# Python Project Conventions

## Structure

- TODO

## Setup

- TODO

## Versioning

- The version lives in one place: `_version.py` (`__version__ = 'X.Y.Z'`, wired up with `[tool.hatch.version] path = "_version.py"` and `dynamic = ["version"]`). Older projects with a static `version` in `pyproject.toml` are also supported by the tool.
- Bump with `scripts/bump.py` in this skill's directory, run from the project root:

  ```sh
  python3 ~/.config/claude/skills/py-projects/scripts/bump.py {major|minor|patch|X.Y.Z}
  ```

  Use `--dry-run` to preview and `--project DIR` to target another directory. It updates the version file and `uv.lock` (via `uv lock`), prints the new version, and does not touch git.
- Commit, merge, tag, and push as described in `git-release`. Don't tag; CI does.

## Templates

`templates/` holds the starting files for a new project. Copy them in and replace the `{{placeholders}}` (`project_name`, `package_name`, `description`):

- `pyproject.toml`: hatchling, dynamic version from `_version.py`, ruff, pytest, uv dev group.
- `_version.py`: starts at `0.1.0`.
- `.github/workflows/integration.yaml`: ruff + pytest on non-`main` branches and PRs; also callable by other workflows.
- `.github/workflows/release.yaml`: on push to `main`, runs integration, then tags `vX.Y.Z` if untagged and publishes (no-op echo for now).

## Finishing

- TODO
