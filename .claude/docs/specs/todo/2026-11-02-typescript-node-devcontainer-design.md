# Node.js & TypeScript dev container Template and Features: design

Date: 2026-11-02
Map: [map.md](../../wayfinder/todo/2026-11-01-typescript-node-devcontainer/map.md) (issues 01–16 hold every decision with its source; this spec only collects them)

## Intent

A Dev Container setup built only from spec-native pieces: one Dev Container Template that picks the image, and Features the user picks for every tool. No Dockerfile. Every install, `chown`, config setup and copy of the files in `~/TMP/.devcontainer/.config/` is done by Template and Feature properties.

Principles:
- Follow the Dev Container specs (https://containers.dev/implementors/templates/, https://containers.dev/implementors/features/, https://containers.dev/implementors/json_reference/) and the Claude Code docs' recommended setup.
- Separation of concerns: the Template is "Node.js & TypeScript" only. Claude Code and every other tool is a Feature the user adds. Features are shared by every Template in the repo.
- Features act for `_REMOTE_USER` / `_REMOTE_USER_HOME`, never a hardcoded user.

## Repo and distribution

- Repo `iamchriswick/devcontainers` (public). Orphan branches, each a git worktree under `~/projects/devcontainers/`:
  - `main`: `README.md` and `.github/workflows/release.yaml`.
  - `templates`: from `devcontainers/template-starter`. `src/typescript-node/devcontainer-template.json`, `src/typescript-node/.devcontainer/devcontainer.json`, `test/typescript-node/test.sh`, and the starter's test workflows.
  - `features`: from `devcontainers/feature-starter`. `src/<id>/devcontainer-feature.json`, `src/<id>/install.sh`, each Feature's `.config` files inside its own `src/<id>/`, `test/<id>/`, and the starter's test workflows.
- Setup order: create the repo and the three worktrees, then clone the starters into their branches.
- Release workflow on `main`: `workflow_dispatch` with an input `templates` | `features`; the job checks out that branch and publishes it with `devcontainers/action`, namespaces `iamchriswick/devcontainers/templates` and `iamchriswick/devcontainers/features`. The docs pull request uses `gh pr create --base templates|features`. Enable "Allow GitHub Actions to create and approve pull requests" in the repo settings (off by default). Before publishing `templates`, a step reads https://mcr.microsoft.com/v2/devcontainers/typescript-node/tags/list and rewrites the `imageVariant` proposals (latest + the last LTS lines, trixie only).
- Distribution in three stages:
  1. Local: Features copied into the test project's `.devcontainer/<id>/` and referenced as `./<id>`.
  2. Tarball: `devcontainer features package <src> -o ./output` produces `devcontainer-feature-<id>.tgz`, hosted on GitHub Releases of `iamchriswick/devcontainers` and referenced by HTTPS URL.
  3. OCI: `ghcr.io/iamchriswick/devcontainers/templates/typescript-node` and `ghcr.io/iamchriswick/devcontainers/features/<id>`, after all testing.

## Template `typescript-node`

`devcontainer-template.json`:
- `id: typescript-node`, `version: 0.1.0`, `name: "Node.js & TypeScript"`, `description: "Develop Node.js based applications in TypeScript. Optional Features set up zsh, Starship, git-delta, eza and Claude Code."`
- Options:
  - `imageVariant`: string, `proposals` `["trixie", "26-trixie", "24-trixie", "22-trixie"]` (regenerated at release), `default` `"trixie"` (Microsoft's latest, Node 24 today).
  - `name`: string, `default` `"${containerWorkspaceFolderBasename}"`.

`.devcontainer/devcontainer.json`:
- `"name": "${templateOption:name}"`, `"runArgs": ["--name", "${templateOption:name}"]`.
- `"image": "mcr.microsoft.com/devcontainers/typescript-node:5-${templateOption:imageVariant}"`.
- `features`: `ghcr.io/devcontainers/features/github-cli:1`. `python` is not listed; the user adds it in the Feature picker.
- No `containerUser`, no `remoteUser`, no Claude config. `root` is never offered.

## Features

Every Feature starts at `version: 0.1.0`. `install.sh` runs as root at build time; it writes into `$_REMOTE_USER_HOME` and gives files to `$_REMOTE_USER`. `dependsOn` uses `./<id>` in the local stage and the ghcr.io id once published.

| id | Installs / does | Options | Dependencies |
|---|---|---|---|
| `zsh` | Your `.zshrc` → `~/.zshrc` (replaces the image's file). Its `.zshrc` has no `starship init` line and loads the `eza` plugin only with `(( $+commands[eza] )) && plugins+=(eza)`. Relies on the image's Oh My Zsh; clones `zsh-syntax-highlighting` into `$ZSH_CUSTOM/plugins/` only if neither `$ZSH/plugins/` nor `$ZSH_CUSTOM/plugins/` has it. `customizations.vscode.settings`: `terminal.integrated.defaultProfile.linux: zsh`. | none | none |
| `starship` | `rose-pine.toml` → `~/.config/starship.toml`; appends `eval "$(starship init zsh)"` to whatever `~/.zshrc` exists. | `customizeClaudeCodeProfile` (boolean, `false`): appends `customize-claude-code-profile.toml` to `starship.toml` and adds `statusLine` from `statusLine.json` to Claude's `settings.json`; without `claude-code`, only the profile is appended. | `dependsOn` `ghcr.io/devcontainers-extra/features/starship:1`; `installsAfter` `zsh`, `claude-code` |
| `git-delta` | `delta.gitconfig` → `~/.config/git/delta.gitconfig`; `git config --global include.path ~/.config/git/delta.gitconfig` run as the user. | none | `dependsOn` `ghcr.io/devcontainer-community/devcontainer-features/delta:1` |
| `eza` | `rose-pine.yml` → `~/.config/eza/theme.yml`. | none | `dependsOn` `ghcr.io/devcontainers-extra/features/eza:1` |
| `claude-code` | Claude Code with the native installer, run as `$_REMOTE_USER` (https://code.claude.com/docs/en/setup). `customizations.vscode.extensions`: `anthropic.claude-code`. Appends the docs' `export PATH="$HOME/.local/bin:$PATH"` to the user's `~/.bashrc` and `~/.zshrc`, because the installer doesn't change PATH (https://code.claude.com/docs/en/troubleshoot-install). Writes your `settings.json` into `$_REMOTE_USER_HOME/.claude` only when none exists. No version option. | `sandbox` (boolean, `false`): installs `bubblewrap` and `socat`, adds `"sandbox": { "enableWeakerNestedSandbox": true }`. `settings` (string enum `["default"]`, `default` `"default"`): your `.config/claude/settings.json`. | `installsAfter` `zsh` |
| `claude-code-config` | Optional persistent config. `mounts`: `{ "source": "devcontainers-claude-code-config", "target": "/usr/local/share/claude-config", "type": "volume" }`. `containerEnv`: `"CLAUDE_CONFIG_DIR": "/usr/local/share/claude-config"`. `install.sh`: create that folder owned by `$_REMOTE_USER`, move any existing `$_REMOTE_USER_HOME/.claude` contents into it, remove the empty folder, link `$_REMOTE_USER_HOME/.claude` to it. | none | `dependsOn` `claude-code` |

Notes on `claude-code-config` (sources in issues 08 and 10):
- `CLAUDE_CONFIG_DIR` must equal the volume's mount path and be absolute (https://code.claude.com/docs/en/devcontainer#persist-authentication-and-settings-across-rebuilds, https://code.claude.com/docs/en/env-vars). A Feature's `mounts` and `containerEnv` are literal, so the path can't depend on the user; the image users differ (`node`, `vscode`, `codespace`).
- Docker copies the image folder into the volume only when the volume is empty, with ownership (https://docs.docker.com/engine/storage/volumes/; moby `copyExistingContents`). So the settings, the sandbox setting and Starship's `statusLine` seed the volume once, when it is first created. An existing volume never receives later settings (accepted).
- One volume is shared by every container using the Feature. Nothing chowns it at runtime.

## Tests

Layout per https://github.com/devcontainers/cli/blob/main/docs/features/test.md and the template-starter.

- Each Feature's `test/<id>/test.sh`: the binary runs (`starship`, `eza`, `delta`, `claude` with `--version`); each config file is at its path above; `zsh`: `zsh-syntax-highlighting` present; `claude-code-config`: `CLAUDE_CONFIG_DIR` is `/usr/local/share/claude-config`, owned by the user, and `~/.claude` links to it.
- `scenarios.json`: `claude-code` `sandbox=true` (`bwrap` and `socat` exist; `settings.json` has `enableWeakerNestedSandbox`); `claude-code` `settings=default` (`settings.json` from your file); `starship` `customizeClaudeCodeProfile=true` with `claude-code` (`statusLine` present) and without it (profile appended, no `statusLine`).
- Template `test/typescript-node/test.sh`: the container starts with the option defaults; `node`, `npm` and `gh` run.

## Checks during the build

Not settleable before a real run. Each is checked at its stage:

| Check | Stage | Source of the doubt |
|---|---|---|
| ghcr.io accepts the four-level namespaces `iamchriswick/devcontainers/{templates,features}/<id>` | First publish (OCI) | No source found (map, Not yet specified) |
| The CLI reads the uncompressed tar that `devcontainer features package` writes under the `.tgz` name | Tarball stage | `packageCommandImpl.ts:68` (issue 12) |
| `code` is on PATH in dev container shells, so the Oh My Zsh `vscode` plugin prints no warning | First container | Unverified (issue 15) |

## Out of scope

- VS Code extensions as Features (beyond `claude-code`'s `anthropic.claude-code`), and editor settings.
- Listing the collection on the containers.dev index.
- Other operating systems; all planned Templates are Linux on the same Debian base.

## Future expansion

- `claude-code` `settings` value `individual`, once its grouping is decided.
- A Feature that installs and sets up Next.js (if no Next/Nuxt/etc. project already exists in the workspace) and shadcn/ui.
