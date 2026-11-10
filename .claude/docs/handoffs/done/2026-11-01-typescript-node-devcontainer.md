# Handoff: typescript-node dev container Template and Features (wayfinder map)

Date: 2026-11-01

## Read first

- Transcript of this session: [549249ce-579c-463f-a90e-1ccbf749f9ce.jsonl](../../../projects/-home-iamchriswick/549249ce-579c-463f-a90e-1ccbf749f9ce.jsonl) (`/home/iamchriswick/.claude/projects/-home-iamchriswick/549249ce-579c-463f-a90e-1ccbf749f9ce.jsonl`)
- Map: [map.md](../../wayfinder/todo/2026-11-01-typescript-node-devcontainer/map.md) (`/home/iamchriswick/.claude/docs/wayfinder/todo/2026-11-01-typescript-node-devcontainer/map.md`)
- Issues: [issues/](../../wayfinder/todo/2026-11-01-typescript-node-devcontainer/issues/) (`/home/iamchriswick/.claude/docs/wayfinder/todo/2026-11-01-typescript-node-devcontainer/issues/`)

## Where the work lives

- Map: `~/.claude/docs/wayfinder/todo/2026-11-01-typescript-node-devcontainer/map.md`. Its Destination, Notes, "Decided before charting", Decisions so far, Not yet specified and Out of scope are the record; not repeated here.
- Issues: `~/.claude/docs/wayfinder/todo/2026-11-01-typescript-node-devcontainer/issues/01-…16-*.md`.
  - Resolved: 01–16 (05 superseded and 06 lapsed, see their Comments).
- Source material: `~/TMP/.devcontainer/` (`devcontainer.json`, `devcontainer-template.json`, `Dockerfile` as an example only, `.config/**`).

## Standing instructions from the user (this session)

- Facts are found online by the agent (docs, reference repos, source code), never asked of the user. Decisions are put to the user via `AskUserQuestion`, with the recommendation first, only when genuinely the user's.
- No additions beyond what the user decided. Do not re-ask decided items.
- Questions from the user are answered, not acted on.
- Template is named "Node.js & TypeScript". Separate concerns: Claude Code and every other tool is a Feature the user adds.
- Follow the documented, recommended setup (Claude Code docs, Dev Container spec), not workarounds. Every claim is backed by facts and links to the docs.
- An example the user posts shows an approach; build from it, don't review it line by line.
- Write no code unless asked.

## State of `~/projects/devcontainers`

The `iamchriswick/devcontainers` clone was emptied at the user's request (`.git` and starter content deleted). Only `.claude/.cc-writes` (created by Claude Code) remains. No repo, worktrees or starters are set up.

## Suggested skills

- `mattpocock-skills:wayfinder`: work through the map.
- `mattpocock-skills:grilling` and `mattpocock-skills:domain-modeling`: required by wayfinder for grilling issues.
- `devcontainers`: when Dev Container guidance is needed (user's instruction).

Per `~/.claude/rules/specs-plans-handoffs.md` → Handoffs: once read and understood, move this file to `./.claude/docs/handoffs/done/` with `git mv`.
