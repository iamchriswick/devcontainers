# claudeConfigDir default value

Type: grilling
Status: resolved
Blocked by: 05

## Question

`claudeConfigDir` is substituted into the Template's `mounts` target and `containerEnv.CLAUDE_CONFIG_DIR`. Those are plain strings: no shell, and no variable gives the user's home (only `${containerEnv:VAR}`, which works in `remoteEnv` only). Source: https://containers.dev/implementors/json_reference/ (variables). With `remoteUser` and `containerUser` unused, the default choice "the user's home `.claude`" must be a literal path. What are the exact values of the `claudeConfigDir` option (proposals and default)?

## Proposal

`"proposals": ["/home/node/.claude", "${containerWorkspaceFolder}/.claude"]`, `"default": "/home/node/.claude"`. `node` is the image's `remoteUser` (see "Feature users and lifecycle commands").

## Answer

`claudeConfigDir`: string, `"proposals": ["/home/node/.claude", "${containerWorkspaceFolder}/.claude"]`, `"default": "/home/node/.claude"`, matching the `containerUser` default `node`. Proposals are free text in the GUI, so a user who picks another `containerUser` types the matching path.

Why not `/home/${templateOption:containerUser}/.claude`: `replaceTemplatedValues` (devcontainers/cli `containerTemplatesOCI.ts`) does one `String.replace` pass over each file's original text, so a `${templateOption:…}` inside another option's value is left unreplaced in `devcontainer.json`.

## Comments

- 2026-11-02 (audit session): lapsed. Claude config moved out of the Template into the `claude-code-config` Feature (issue 08); `claudeConfigDir` no longer exists.
