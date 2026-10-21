---
name: c-projects
description: Conventions for creating, structuring, and maintaining C projects, including code formatting. Use when working on a C project (including Pebble apps). Not for other languages. (Structure and Setup sections are still TODO.)
---

# C Project Conventions

## Structure

- TODO

## Setup

- TODO

## Formatting

- Every C project uses the Linux kernel's `.clang-format`, placed at the project root. Copy it from `templates/.clang-format` in this skill's directory:

  ```sh
  cp ~/.claude/skills/c-projects/templates/.clang-format .
  ```

  Don't edit it per project; if a rule seems wrong, say so and ask.
- If a project has no `.clang-format`, add it and reformat in a separate commit (`Add .clang-format and reformat C sources`) before other changes, so style churn stays out of real diffs.
- Format all C sources and headers before committing:

  ```sh
  clang-format -i $(git ls-files '*.c' '*.h')
  ```

  Skip vendored or generated code (e.g. `build/`, `node_modules/`).
- The style is the kernel's: tabs (width 8), 80 columns, function braces on their own line, `*` bound to the name.

## Finishing

- Before finishing, check formatting with `clang-format --dry-run --Werror` on the changed files and make sure the project builds.
