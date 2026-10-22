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
5. **Documentation links**, split by audience (see [Documentation section](#documentation-section)).
6. **License**, always, as the last section (or nearly): name the license and link the `LICENSE` file.

Optional, only if useful: a short feature list, supported platforms, status/stability note.

## Rules

- Short. If it's growing past roughly one screen or two, move the detail into the user guide and link to it.
- No full option references, architecture, contribution workflow, or troubleshooting; those belong in the guides.
- Lead with the user's problem and outcome, not the implementation or tech stack (mention the stack only if it affects the reader).
- Badges: only ones that carry information (CI status, version). At most a few, below the title.
- Every command and example must be tested; screenshots must match the current version.
- Update the README when the headline usage, install steps, or scope changes.

## Documentation section

Group links by audience. Each group is a lead-in line linking the guide, then a bulleted list of links to the important top-level sections of that guide (`guide.md#section`), not just the guide itself:

- `For users, in the [user guide](docs/user-guide.md):` getting started, common tasks, scheduling/deployment, troubleshooting, and any detail docs a user needs (configuration reference, supported sites).
- `For contributors, in the [developer guide](docs/developer-guide.md):` the "adding X" recipes, testing, and code conventions.

Link only sections that exist, and check that each anchor resolves. Keep each list to the handful a reader is most likely to want; the guides' tables of contents cover the rest.

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

For users, in the [user guide](docs/user-guide.md):

- [Getting started](docs/user-guide.md#getting-started)
- [Usage by task](docs/user-guide.md#usage-by-task)
- [Troubleshooting](docs/user-guide.md#troubleshooting)

For contributors, in the [developer guide](docs/developer-guide.md):

- [Getting started](docs/developer-guide.md#getting-started)
- [Testing](docs/developer-guide.md#testing)
- [Code conventions](docs/developer-guide.md#code-conventions)

## License

MIT. See [LICENSE](LICENSE).
````
