# Handoff: the `behavioral-guidelines` skill in `iamchriswick/skills`

Date: 2026-11-01

## Goal

The user wants their behavioral guidelines for Claude Code applied across all their projects and environments, including dev containers. The guidelines are `behavioral-guidelines`, one of the skills in `https://github.com/iamchriswick/skills`.

## Agreed

- **Repository:** `https://github.com/iamchriswick/skills`, a Claude Code plugin that collects the user's skills. Its structure takes inspiration from `https://github.com/mattpocock/skills`.
- **The skill:** `skills/productivity/behavioral-guidelines/SKILL.md`, with its examples in `skills/productivity/behavioral-guidelines/references/EXAMPLES.md`. The link from `SKILL.md` to `EXAMPLES.md` works.
- **Always on:** the plugin gets a `hooks/` folder with a SessionStart hook. The guidelines load automatically at the start of every session, not only when Claude or the user calls the skill.
- **Distribution:** the user will add the marketplace in Claude Desktop, so the plugin becomes one of their synced plugins.
- **Not part of this work:** `https://github.com/iamchriswick/claude-plugin-pro-tools` and `https://github.com/iamchriswick/claude-skills`.

## Current status

As of `main` at commit `684f177`:

- **Done:**
  - `.claude-plugin/marketplace.json` and `.claude-plugin/plugin.json` exist;
  - `skills/productivity/behavioral-guidelines/SKILL.md` exists;
  - `skills/productivity/behavioral-guidelines/references/EXAMPLES.md` exists;
  - the link from `SKILL.md` to `EXAMPLES.md` works.
- **Broken:**
  1. **`.claude-plugin/plugin.json` isn't valid JSON.** Line 4 is missing the opening quote: `"description": A collection of …`. Claude Code can't load the plugin until it's fixed.
  2. **`SKILL.md` has no frontmatter.** It starts with `# CLAUDE.md`, with no `---` block holding `name` and `description`, so Claude has nothing that tells it when to use the skill.
- **Not started:**
  - the `hooks/` folder and its SessionStart hook;
  - GitHub workflows;
  - Husky and commit checks;
  - worktree setup;
  - the design doc.

## Open to your suggestions

The user wants your proposals on everything here. Nothing in this list is decided:

- workspace and repo structure;
- Conventional Commits;
- Husky;
- GitHub workflows, which the repo needs;
- Claude Code hooks;
- developing each skill, `skills/<category>/<skill-name>`, in its own worktree, for example with a `WorktreeCreate` hook (https://code.claude.com/docs/en/hooks#worktreecreate), entering an existing one with `EnterWorktree` and leaving with `ExitWorktree`.

## Next session

Bring the user your suggestions for each area above, with the alternatives you considered, and let them decide. Write the design from their decisions and get their approval before building. The two fixes under **Current status** → **Broken** are part of that build.

## Suggested skills

- `superpowers:brainstorming`: to work through the open areas with the user and reach an approved design.
- `superpowers:writing-plans`: once the design is approved.
- `superpowers-developing-for-claude-code:developing-claude-code-plugins`: for the plugin, its manifests and its hooks.
- `superpowers-developing-for-claude-code:working-with-claude-code`: for Claude Code's documentation on hooks, `WorktreeCreate`, `EnterWorktree` and `ExitWorktree`.
