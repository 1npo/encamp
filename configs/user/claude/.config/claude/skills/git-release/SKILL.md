---
name: git-release
description: How to bump a project's version and release it. Use when the user says bump, release, cut a version, or ship a new version, in a repo they author. Bumping triggers a release, which CI performs on push to main.
---

# Bump and Release

## Rules

- Versions are SemVer (`MAJOR.MINOR.PATCH`). If the user doesn't say which part, infer it from the changes since the last tag (breaking -> major, feature -> minor, fix/docs -> patch) and state your choice.
- Use the language-specific bump tool; never hand-edit version strings. Find it in the `<lang>-projects` skill (Python: `py-projects`). If the language has no tool there yet, say so and ask rather than improvising.
- Claude never creates release tags. CI tags and publishes when a push to `main` contains a new version. A bump is therefore a release, and merging it to `main` is what triggers it.

## Steps

1. Make sure the work to release is merged to `main` (see `git-workflow`), the tree is clean, and tests pass.
2. Create a branch `chore/release-X.Y.Z` from `main`.
3. Run the bump tool on that branch. It edits the version file(s) (and lockfile) and prints the new version.
4. Commit as `Bump version to X.Y.Z` (see `git-commit`).
5. Merge into `main` with `--no-ff` and push `main`, as in `git-workflow`.
6. Report the new version, and that CI will tag `vX.Y.Z` and publish. Check with `git ls-remote --tags origin vX.Y.Z` if asked.

## CI

- The release workflow (`release.yaml` in `py-projects/templates/.github/workflows/`) runs the test workflow, then tags `vX.Y.Z` if that tag doesn't exist yet, then publishes.
- Publishing is currently a no-op echo. PyPI (public apps) and a self-hosted Gitea (private apps) are planned.
- If a repo has no release workflow, say so instead of tagging locally; offer to add it from the template.
