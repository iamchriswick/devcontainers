# Tests for the Features and the Template

Type: grilling
Status: resolved
Blocked by: 08, 10, 11

## Question

What does each Feature's test and the Template's test check?

## Proposal

- Each Feature: its binary runs (`starship`, `delta`, `eza`, `claude`) and its config file exists at its target in the user's home.
- `starship` with `customizeClaudeCodeProfile`: `starship.toml` contains the `[profiles]` block and `settings.json` contains `statusLine`.
- `claude-code`: `$CLAUDE_CONFIG_DIR` is owned by the user; with `sandbox`, `bwrap` and `socat` exist.
- Template: the container builds with the option defaults and `CLAUDE_CONFIG_DIR` equals the `claudeConfigDir` default.

## Answer

Source: user's answers (audit session, 2026-11-01/02). Layout per issue 11 (https://github.com/devcontainers/cli/blob/main/docs/features/test.md).

- Each Feature's `test.sh`: the binary runs (`starship`, `eza`, `delta`, `claude` with `--version`) and each config file is at its issue 14 path (`~/.config/starship.toml`, `~/.config/eza/theme.yml`, `~/.config/git/delta.gitconfig` + `include.path`, `~/.zshrc`); `zsh`: `zsh-syntax-highlighting` present. `claude-code-config`: `CLAUDE_CONFIG_DIR` is `/usr/local/share/claude-config`, owned by the user, `~/.claude` links to it.
- `scenarios.json`, one per option: `claude-code` `sandbox=true` (`bwrap` and `socat` exist, `settings.json` has `enableWeakerNestedSandbox`); `claude-code` `settings=default` (`settings.json` from your file); `starship` `customizeClaudeCodeProfile=true` with `claude-code` (`statusLine` present) and without it (profile appended, no `statusLine`).
- Template `test.sh`: the container starts with the option defaults; `node`, `npm` and `gh` run. No Claude or other Feature checks.
