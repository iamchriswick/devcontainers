# Feature ids and options

Type: grilling
Status: resolved
Blocked by: 05

## Question

What are the `id`, options, option types and defaults of each Feature: `zsh`, `starship`, `git-delta`, `eza`, `claude-code`?

## Proposal

- `zsh`: no options. Installs `.config/zsh/.zshrc` (backing up the existing one) and sets `terminal.integrated.defaultProfile.linux: zsh` through its `customizations.vscode.settings`.
- `starship`: `customizeClaudeCodeProfile` boolean, default `false`. Installs `rose-pine.toml` as `~/.config/starship.toml` and adds `eval "$(starship init zsh)"` to `.zshrc`.
- `git-delta`: no options. Installs git-delta and `.config/git/delta.gitconfig` as `~/.config/git/config`.
- `eza`: no options. Installs eza and `.config/eza/rose-pine.yml` as `~/.config/eza/theme.yml`.
- `claude-code`: `sandbox` boolean, default `false`; `settings` enum `["default", "individual"]`, default `"default"` (how "individual" is grouped is out of scope for now).

## Answer

Source: user's answers (audit session, 2026-11-01/02), with the facts below.

- Ids: `zsh`, `starship`, `git-delta`, `eza`, `claude-code`, `claude-code-config`. Every Feature starts at version `0.1.0`.
- Option types are `boolean` or `string` (`enum` or `proposals`); option ids become upper-case environment variables for `install.sh` (https://containers.dev/implementors/features/).
- `zsh`: no options. Sets `terminal.integrated.defaultProfile.linux: zsh` through its `customizations` (fixed metadata; options can't change it).
- `starship`: `customizeClaudeCodeProfile`, boolean, default `false`.
- `git-delta`, `eza`: no options. Themes become options when more configs are added.
- Binaries for starship, eza and delta come from community Features (`dependsOn`, issue 09): `ghcr.io/devcontainers-extra/features/starship:1`, `ghcr.io/devcontainers-extra/features/eza:1`, `ghcr.io/devcontainer-community/devcontainer-features/delta:1` (listed on https://containers.dev/features).
- `claude-code`: the user's own Feature, replacing `ghcr.io/anthropics/devcontainer-features/claude-code`. Fact: Anthropic's v1.0.5 has `"options": {}` and runs `npm install -g` as root (https://github.com/anthropics/devcontainer-features/blob/main/src/claude-code/install.sh). Installs with the native installer as `$_REMOTE_USER`, as documented (https://code.claude.com/docs/en/setup); adds the `anthropic.claude-code` extension. Options: `sandbox`, boolean, default `false`; `settings`, string enum `["default", "individual"]`, default `"default"` (grouping of "individual" out of scope).
- `claude-code-config`:
  - `mounts`: `source=devcontainers-claude-code-config`, `target=/usr/local/share/claude-config`, `type=volume`.
  - `containerEnv`: `CLAUDE_CONFIG_DIR=/usr/local/share/claude-config`.
  - `install.sh`: creates `/usr/local/share/claude-config` owned by `$_REMOTE_USER`, moves any existing `$_REMOTE_USER_HOME/.claude` contents into it, removes the empty folder, links `$_REMOTE_USER_HOME/.claude` to it.
  - Facts: `CLAUDE_CONFIG_DIR` must be set to the volume's mount path (https://code.claude.com/docs/en/devcontainer#persist-authentication-and-settings-across-rebuilds), as an absolute path, and all settings, session history and plugins live under it (https://code.claude.com/docs/en/env-vars); a path outside the home is used in the docs (https://code.claude.com/docs/en/claude-apps-gateway-deploy, `/tmp/.claude`). A Feature's `mounts` and `containerEnv` are literal; only `install.sh` knows the user (devcontainers/cli `src/spec-node/imageMetadata.ts:58-67`). The image users differ: typescript-node `node`, python and base `vscode`, universal `codespace` (image metadata).

## Comments

- 2026-11-02 (audit session): `settings` ships with only `default` in 0.1.0; `individual` is deferred to the map's Future expansion until its grouping is decided (user's answer).
- 2026-11-02 (audit session): `claude-code` appends `export PATH="$HOME/.local/bin:$PATH"` to the user's `~/.bashrc` and `~/.zshrc` (user's answer). Fact: the native installer places `claude` at `~/.local/bin/claude` and doesn't change PATH; the documented fix is that line in the shell config (https://code.claude.com/docs/en/troubleshoot-install). The image's PATH has no `~/.local/bin` (image config).
