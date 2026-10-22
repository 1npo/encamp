---
name: docs-user-guide
description: How to write and maintain a project's user guide (docs/user-guide.md). Use when creating the guide, or whenever a change affects user-visible behavior, options, commands, configuration, or output. Part of `docs-project`.
---

# User Guide

A comprehensive, always-current reference and tutorial for people who *use* the project (not those who modify it). Every project has one.

## Currency rule

Any change to user-visible behavior (features, commands, flags, config keys, defaults, output formats, UI, errors, removals) updates the user guide in the same change. A feature isn't done until it's documented here.

## Contents

Include whatever applies, in roughly this order:

1. **Overview**: what the project does and key concepts/terms, briefly.
2. **Installation**: all supported methods and platforms, prerequisites, upgrade and uninstall.
3. **Getting started**: a tutorial that takes a new user from zero to a first useful result.
4. **Usage by task**: how to accomplish each common goal, with examples and expected output. Organize by what the user wants to do, not by internal modules.
5. **Reference**: every command, option, config key, environment variable, file format, and keybinding, with defaults and types. Complete and scannable (tables).
6. **Configuration**: where config lives, precedence, annotated example.
7. **Troubleshooting / FAQ**: real errors with their causes and fixes.
8. **Limitations and known issues** if any.

## Rules

- Comprehensive: if users can do it or see it, it's documented. Completeness matters more here than in the README.
- Task-oriented, with copy-pasteable examples. Include screenshots where visual.
- Document defaults and error behavior, not just the happy path.
- No implementation details unless they change what the user sees; those go in the developer guide.
- Remove documentation for removed features; note renames/removals in the changelog if the project keeps one.
- Large guides: split into `docs/user-guide/` with an `index.md` that links every page.
