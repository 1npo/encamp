---
name: docs-readme
description: How to write a project's README.md. Use when creating, rewriting, or updating a README in any language or project type. Covers structure, tone, and what to leave out. Part of `docs-project`.
---

# README

The README is the front door: concise, impactful, immediately useful. A reader should know within seconds what this is, and within a minute be able to try it.

## Required order

1. **Title and one-line description.** What it is and what problem it solves, in plain words. No slogans.
2. **Visual** (if the project has any UI, TUI, CLI output, or visual result): a screenshot, GIF, or sample output, right below the description. Skip for projects with nothing to show; don't add decoration.
3. **Usage examples.** The most common real use, with commands/code and expected output. Up front, before installation details, so the value is visible first.
4. **Install / quick start.** Minimal steps to get running. Exact commands. Prerequisites in one line.
5. **Links** to the user guide and developer guide (`docs/user-guide.md`, `docs/developer-guide.md`).
6. **License**, always, as the last section (or nearly): name the license and link the `LICENSE` file.

Optional, only if useful: a short feature list, supported platforms, status/stability note.

## Rules

- Short. If it's growing past roughly one screen or two, move the detail into the user guide and link to it.
- No full option references, architecture, contribution workflow, or troubleshooting; those belong in the guides.
- Lead with the user's problem and outcome, not the implementation or tech stack (mention the stack only if it affects the reader).
- Badges: only ones that carry information (CI status, version). At most a few, below the title.
- Every command and example must be tested; screenshots must match the current version.
- Update the README when the headline usage, install steps, or scope changes.

## Skeleton

````markdown
# name

One sentence: what it is and what it does for you.

![screenshot or demo](docs/images/demo.png)

## Usage

```sh
name do-the-thing input.txt
# expected output
```

## Install

```sh
<exact install command>
```

## Documentation

- [User guide](docs/user-guide.md)
- [Developer guide](docs/developer-guide.md)

## License

MIT. See [LICENSE](LICENSE).
````
