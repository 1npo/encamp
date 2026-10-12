---
name: git-commit
description: How to make git commits for this user, including the identity to commit under. Use whenever creating a git commit in any repository. Branching, merging, and pushing live in `git-workflow`.
---

# Git Commits

## Identity

- Author and commit as Claude, never under the user's git identity.
- Set the identity per command; never change the repo's or the global git config:

  ```sh
  git -c user.name="Claude Opus 5.5" -c user.email="noreply@anthropic.com" commit ...
  ```

  Use the name of the model actually running if it isn't Opus 5.5.
- After committing, confirm with `git log -1 --format='%an <%ae> | %cn <%ce>'`.
- Don't rewrite already-pushed commits that were made under the user's name.

## Finishing

- Keep any attribution trailer the session requires (e.g. `Co-Authored-By:`).
- Don't commit to `main` directly in repos the user authors. Branch, merge, and push as described in `git-workflow`.
- Version bumps follow `git-release`.
