---
name: claude-planning-docs
description: Where Claude puts the planning, working memory, and handoff files it generates while building or working on a project, and how it names them. Use when creating a project, starting or resuming work on one, or writing any plan (including plans split into sessions or phases), priming prompt, progress note, memory, or handoff file. Not for documentation the project ships, which lives in `docs-project`.
---

# Claude Planning Docs

These are the files Claude writes for itself or for the next session while working on a project, not documentation for the project's users or maintainers: initial prompts, plans, working memory files, progress notes, and handoffs.

## Location

- Put all of them under `docs/plans/`. Don't put them in the repo root, `docs/` itself, or anywhere else.

## Naming

- Prefix every filename with a 3-digit sequence number, starting at `000`, followed by a hyphen and a kebab-case name: `000-initial-prompt.md`, `001-plan.md`, `002-handoff.md`.
- To add a file, use the next number after the highest one already in `docs/plans/`. Don't reuse or renumber existing files.
- Update an existing file in place when it is the same document (e.g. the working memory file). Create a new numbered file when it is a new document (e.g. a new handoff).

## Plans split into sessions or phases

The user starts each session by typing one line, such as "Start phase 1 as outlined in docs/plans/004-plan.md". Write the plan so that line is enough. Never hand the user a prompt to copy and paste.

- Give each phase its own heading, `## Phase <n>: <title>`, and use the same name everywhere.
- Make each phase section self-contained. It holds everything the session needs:
  - what to read first, and the skills to load;
  - numbered steps, with the order that matters;
  - the deliverables, and how each is checked;
  - the cut line;
  - the acceptance criteria;
  - the branch and release steps.
- Write that content as normal plan text. Don't put it in a fenced "paste this" block.
- Don't write separate prompt files or clipboard helper scripts.
- Anything every phase shares (conventions, constraints) goes once in a section near the top. Each phase says to read it.
- Each phase starts by checking what earlier phases recorded or cut (git log, CHANGELOG, the plan itself) and picks up any work moved to it.
- When a session should record results (timings, decisions, what was cut), it writes them back into the plan under that phase.
- A priming prompt that asks for such a plan must ask for this format too.
- End the reply that delivers the plan with the exact line the user can type to start the first phase.
