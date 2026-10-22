---
name: docs-project
description: Language-agnostic conventions for which documentation a project must contain and the rules all documentation follows. Use when creating a project, adding or changing features, or writing or updating any documentation. Details for each document live in `docs-readme`, `docs-user-guide`, and `docs-dev-guide`.
---

# Project Documentation

## Required documents

Every project has all four. Create them at project start, not "later".

| Document | Location | Audience | Skill |
|---|---|---|---|
| README | `README.md` (repo root) | Anyone landing on the repo | `docs-readme` |
| User guide | `docs/user-guide.md` (or `docs/user-guide/` once it outgrows one file) | People using the project | `docs-user-guide` |
| Developer guide | `docs/developer-guide.md` (or `docs/developer-guide/`) | People maintaining the project | `docs-dev-guide` |
| License | `LICENSE` (repo root) | Anyone reusing the code | see [License](#license) |

- Add other documents (changelog, contributing, ADRs) only when they have a real purpose. Don't create empty placeholders.
- Where a language ecosystem has its own conventional doc tooling or location, follow it in addition to these, not instead of them. The files above still exist. See the relevant language skill.

## License

- Default for every project the user authors: MIT, in a root `LICENSE` file, copyrighted to `Nick OMalley <nickpeteromalley@gmail.com>`.
- Copy `templates/LICENSE` and replace `{{year}}` with the current year (the project's creation year; don't rewrite it later).
- Use a different license only if the user says so. In repos owned by others, follow their license.
- The README names the license near the bottom (see `docs-readme`). Package metadata (e.g. `license` in `pyproject.toml`) must match.

## Rules for all documentation

- **Keep it in sync.** A change that alters behavior, options, setup, architecture, or workflow updates the affected docs in the same change. Docs that are out of date are bugs. Before finishing any task, ask which docs it touches.
- **One source of truth.** State each fact in one place and link to it from elsewhere. The README links to the guides; it doesn't duplicate them.
- **Concise.** Cut filler, history, and marketing. Prefer a table, list, or command over a paragraph.
- **Show, don't describe.** Prefer a runnable command or example with its expected output over prose about it.
- **Verified.** Commands and examples must work as written. Run them (or the closest equivalent) before documenting them. Never invent flags, paths, or output.
- **Plain markdown**, ATX headings (`#`), fenced code blocks with a language tag, relative links between docs.
- **Present tense, active voice, second person for instructions** ("Run `x`"), no "simply", "just", "obviously".
- **No stale scaffolding.** Remove TODO and template placeholder text before finishing. If something is genuinely unwritten, say so explicitly in one line rather than leaving boilerplate.

## Finishing

- Re-read changed docs top to bottom, and check that links and commands still resolve.
