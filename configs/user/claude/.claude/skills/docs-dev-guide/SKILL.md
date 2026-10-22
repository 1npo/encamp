---
name: docs-dev-guide
description: How to write and maintain a project's developer guide (docs/developer-guide.md). Use when creating the guide, or whenever a change affects setup, architecture, build/test/release workflow, or conventions. Part of `docs-project`.
---

# Developer Guide

Everything a developer needs to maintain the project, from clone to release. Every project has one.

## Standard

**Concise, but complete enough that a competent developer with no LLM could navigate, modify, debug, and release the project.** Never assume the reader has an assistant, prior context, or the original author to ask. Prefer exact commands and file paths over explanation; link to code rather than restating it.

## Currency rule

Any change to setup, tooling, structure, architecture, data flow, conventions, or the build/test/release process updates this guide in the same change.

## Contents

1. **Overview**: purpose in two sentences, tech stack, and supported platforms/versions.
2. **Getting started**: prerequisites, clone, install dependencies, build, run, run tests; exact commands, verified from a clean checkout. State expected results.
3. **Repository layout**: annotated tree of top-level directories and key files; what lives where and why.
4. **Architecture**: components and their responsibilities, how data and control flow between them, key abstractions, external services/dependencies, and the important design decisions with their reasons (and rejected alternatives when non-obvious). Include a diagram when it clarifies (text-based, e.g. Mermaid or ASCII).
5. **How to make changes**: a recipe per common modification (add a feature/command/endpoint/option, change data format or schema, add a dependency, update docs, etc.) naming the files to touch and conventions to follow.
6. **Testing**: how tests are organized and run, how to add one, what's covered, how to test manually.
7. **Code conventions**: formatting, linting, naming, error handling, logging; the commands that enforce them.
8. **Configuration and environment**: settings, env vars, secrets handling, local vs. production differences.
9. **Build, release, and deploy**: versioning, release steps, CI/CD pipelines and what each does, where artifacts go.
10. **Debugging and troubleshooting**: common failures with causes and fixes, where logs live, how to reproduce issues, useful diagnostic commands.
11. **Gotchas**: non-obvious behavior, historical quirks, known limitations, tech debt.
12. **LLM prompts** (see below).

## LLM prompts section

Include a short set of tested, copy-pasteable prompts for common tasks (troubleshoot a failing test or build, add a feature in the project's style, review a change, update docs after a change, investigate a bug). Each prompt must:

- name the relevant files, docs, or skills to read first,
- state the project's conventions or constraints that matter,
- say what a good result looks like.

This section is a convenience. Nothing else in the guide may depend on it; every task must also be doable from the guide's other sections alone.

## Rules

- Verify instructions by following them literally from a clean state when feasible.
- Document the *why* where code can't (decisions, constraints, trade-offs); don't narrate what the code obviously does.
- Keep it navigable: a table of contents, stable headings, and links to files by relative path.
- Large guides: split into `docs/developer-guide/` with an `index.md` linking every page.
