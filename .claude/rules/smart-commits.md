# Smart Commits: repository rules

These rules extend the `smart-commits` skills (`smart-commits`, `commit`, `commit-message`) for this repository. Follow the skill's workflow, with these additions. Where a rule here conflicts with a skill default, this file wins.

## Branch names

Branch names follow this grammar:

```
branch-name     = trunk-branch / prefixed-branch
trunk-branch    = "features" / "main" / "templates"
prefixed-branch = type "/" description
type            = "feature" / "feat" / "bugfix" / "fix"
                / "hotfix" / "release" / "chore"
description     = desc-segment *("-" desc-segment)
desc-category   = "features" / "templates" / "workflows"
desc-segment    = desc-category-(1*(ALPHA / DIGIT) *("." 1*(ALPHA / DIGIT)))
ALPHA           = %x61-7A   ; lowercase a-z
DIGIT           = %x30-39   ; 0-9
```

Examples: `feat/features-lla`, `chore/features-hello-features-color`.

## 1. Read the changes (extends)

In addition to the skill's reads, check the current branch (`git branch --show-current`). Decide where each staged change belongs **by the paths it touches**, not only by its commit type:

| Change touches | Belongs on |
|---|---|
| `src/<feature-id>/` or `test/<feature-id>/` (or a template id) | a branch for that work, never directly on `features` |
| repo root: `.gitignore`, root `README.md`, `.github/` | local `features`, committed directly |
| `src/<feature-id>/NOTES.md` | `chore/features-<feature-id>-note`, in a commit of its own |

If staged changes belong to different places, don't commit them together. Tell the user which files go to which branch.

## 2. Write the message (overrides)

- **Type by placement:**
  - On `features`, commit only `chore:`, `ci:`, `perf:`, or `docs:` that isn't for one feature.
  - `feat:`, `fix:`, `build:`, `refactor:` and `test:` commits for a feature go on the matching `feat/`, `fix/` or `bugfix/`, `hotfix/` or `release/` branch, created from local `features`.
  - A feature's `NOTES.md` is committed as `docs:` on its `-note` branch.
- **Scope (overrides the skill's default):** for feature work, the scope is the feature id, e.g. `chore(lla): ...`, `feat(lla): ...`. Root work on `features` takes no feature scope.
- **Splitting (overrides "suggest"):** splitting is required, not suggested. Make one commit per feature. Keep root changes separate from feature changes. A `NOTES.md` always gets its own commit.

## 3. Commit (extends)

- Keep the skill's rule: show the message and wait for confirmation before `git commit`.
- Create every prefixed branch from local `features`.
- Merge `chore/` branches into `features` **locally**, and only after the user approves.

## Push and pull requests (extends "never push")

- Never push or open a PR unless the user explicitly asks.
- Only `feat/`, `fix/`, `hotfix/` and `release/` branches that came from local `features` may be pushed.
- They merge into remote `features` **only** through a PR with base `features`.
- `features`, `main`, `templates` and `chore/` branches are never pushed or PR'd.
