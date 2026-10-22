---
name: py-projects
description: Conventions for creating, structuring, and maintaining Python projects, including the version bump tool. Use when working on a Python project, and whenever bumping or releasing one. Not for other languages. (Structure and Setup sections are still TODO.)
---

# Python Project Conventions

## Structure

- Use a standard `src/`-based project layout

## Project Management

- Use `uv` for project management

## Versioning

- The version lives in one place: `_version.py` (`__version__ = 'X.Y.Z'`, wired up with `[tool.hatch.version] path = "_version.py"` and `dynamic = ["version"]`). - Bump with Hatch, run from the project root:

  ```sh
  uvx hatch version <major|minor|patch>
  uv lock
  ```

  `hatch version` updates `_version.py` and prints the old and new versions; `uv lock` syncs the project's version in `uv.lock`. Neither touches git.
- Commit, merge, tag, and push as described in `git-release`. Don't tag; CI does.

## Templates

`templates/` holds the starting files for a new project. Copy them in and replace the `{{placeholders}}` (`project_name`, `package_name`, `description`):

- `pyproject.toml`: hatchling, dynamic version from `_version.py`, ruff, pytest, uv dev group.
- `_version.py`: starts at `0.1.0`.
- `.github/workflows/integration.yaml`: ruff + pytest on non-`main` branches and PRs; also callable by other workflows.
- `.github/workflows/release.yaml`: on push to `main`, runs integration, then tags `vX.Y.Z` if untagged and publishes (no-op echo for now).

## Finishing

- TODO
