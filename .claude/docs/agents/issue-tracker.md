# Issue tracker: Local Markdown

Issues and specs for each repo live as markdown files under `./.claude/docs/` in that repo. Paths below are relative to the current repo's root and follow `~/.claude/rules/specs-plans-handoffs.md`.

## Conventions

- The spec is `./.claude/docs/specs/todo/YYYY-MM-DD-<topic>-design.md`
- Implementation issues are one file per ticket at `./.claude/docs/tickets/todo/YYYY-MM-DD-<topic>/NN-<slug>.md`, numbered from `01`, never a single combined tickets file
- Triage state is recorded as a `Status:` line near the top of each issue file (see `triage-labels.md` for the role strings)
- Comments and conversation history append to the bottom of the file under a `## Comments` heading
- Moving specs, ticket directories and maps to `done/` follows `~/.claude/rules/specs-plans-handoffs.md` (use `git mv`)

## When a skill says "publish to the issue tracker"

Create a new file under `./.claude/docs/tickets/todo/YYYY-MM-DD-<topic>/` (creating the directory if needed).

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or the issue number directly.

## Wayfinding operations

Used by `/wayfinder`. The **map** is a file with one **child** file per ticket.

- **Map**: `./.claude/docs/wayfinder/todo/YYYY-MM-DD-<effort>/map.md` (the Notes / Decisions-so-far / Fog body).
- **Child ticket**: `./.claude/docs/wayfinder/todo/YYYY-MM-DD-<effort>/issues/NN-<slug>.md`, numbered from `01`, with the question in the body. A `Type:` line records the ticket type (`research`/`prototype`/`grilling`/`task`); a `Status:` line records `claimed`/`resolved`.
- **Blocking**: a `Blocked by: NN, NN` line near the top. A ticket is unblocked when every file it lists is `resolved`.
- **Frontier**: scan the map's `issues/` directory for files that are open, unblocked, and unclaimed; first by number wins.
- **Claim**: set `Status: claimed` and save before any work.
- **Resolve**: append the answer under an `## Answer` heading, set `Status: resolved`, then append a context pointer (gist + link) to the map's Decisions-so-far in `map.md`.
