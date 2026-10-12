---
name: git-workflow
description: Branch, merge, and push strategy for repositories the user authors. Use whenever committing, finishing, or pushing work (features, fixes, docs, refactors) in a repo the user owns. Not for repos owned by others, where you follow their contribution rules.
---

# Git Workflow

## Which repos

- Applies to repos the user authored: remote owner is `1npo`, or `pyproject.toml`/package metadata lists them as author. Commits are made as Claude (see `git-commit`), so don't judge authorship from `git log`.
- Elsewhere (forks, other people's projects), follow that project's conventions instead.

## Strategy

- Never commit work directly to `main`. Every change (feature, bug fix, docs, config, refactor) goes on its own branch.
- Name branches `<type>/<short-kebab-description>`, with type one of `feat`, `fix`, `docs`, `refactor`, `test`, `chore`.
- Start from an up-to-date `main`. If already on `main` with uncommitted changes, create the branch first (`git switch -c ...`); the changes come along.
- GitHub has no branch protection on personal repos, so no PRs: merge locally.

## Finishing ("commit this" / "ship it")

1. Commit on the branch (see `git-commit`).
2. Switch to `main` and merge the branch with `git merge --no-ff <branch>`, so the branch stays visible in history.
3. Push `main` to the remote: `git push origin main`.
4. Delete the merged branch locally (`git branch -d`), and on the remote if it was ever pushed.

- If there's no remote, stop after the merge and say so.
- Stop and ask on merge conflicts or failing tests; don't resolve by guessing.
- A version bump + release follows the same path; see `git-release`.
