# typescript-node dev container: Template and Features

Labels: wayfinder:map

## Destination

A spec for the `typescript-node` Dev Container Template and its Features, complete enough to plan and build from with nothing left to decide.

## Notes

- Domain: Dev Container Templates (https://containers.dev/implementors/templates/) and Features (https://containers.dev/implementors/features/), devcontainer.json reference (https://containers.dev/implementors/json_reference/). Follow these specs.
- Skills: `devcontainers` when guidance is needed. Research tickets: `mattpocock-skills:research`. Grilling tickets: `mattpocock-skills:grilling` and `mattpocock-skills:domain-modeling`.
- Source material: `~/TMP/.devcontainer/` (`devcontainer.json`, `devcontainer-template.json`, `.config/**`). The `Dockerfile` there is an example, not a template.

### Decided before charting

Method
- No Dockerfile. Every `chown`, install, config setup and copy of files from `.config/` is done with spec properties, Templates and Features.
- The Template chooses the `typescript-node` image version and what is installed. Anything installable as a Feature is a Feature, chosen by the user.
- Separation of concerns: the Template is "Node.js & TypeScript". Claude Code and every other tool is a Feature the user adds. Features are shared by all Templates in the repo.

Repo and distribution
- One public repo `iamchriswick/devcontainers`. `templates` and `features` are orphan branches; `main` keeps its own README.
- Local layout: `main`, `templates` and `features` as worktrees under `~/projects/devcontainers/`. The repo and worktrees are set up before the starters (`devcontainers/template-starter`, `devcontainers/feature-starter`) are cloned into their branches.
- Branch layout (user's diagram): `main` holds `.github/workflows/release.yaml` and `README.md`. `templates` holds `src/<id>/devcontainer-template.json` + `src/<id>/.devcontainer/devcontainer.json` and `test/<id>/test.sh`; this Template is `src/typescript-node/`. `features` holds `src/<id>/devcontainer-feature.json` + `install.sh` and `test/<id>/test.sh`. Each Feature's `.config` files sit inside its own `src/<id>/`, because only the Feature's folder is packaged (https://containers.dev/implementors/features-distribution/).
- Release: one workflow on `main`, started from `main`, with an input choosing `templates` or `features`; it checks out that branch and publishes it. Test workflows stay on their own branches.
- Release facts: the docs pull request needs `gh pr create --base templates|features`; the repo setting "Allow GitHub Actions to create and approve pull requests" is off by default (https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository).
- Release step: before publishing `templates`, the workflow reads https://mcr.microsoft.com/v2/devcontainers/typescript-node/tags/list and rewrites the `imageVariant` proposals (see issue 07).
- Distribution in stages: locally referenced Features, then directly referenced tarballs (`devcontainer features package`, hosted on GitHub Releases), then the OCI registry ghcr.io after all testing.
- Namespaces: `ghcr.io/iamchriswick/devcontainers/templates/<id>` and `ghcr.io/iamchriswick/devcontainers/features/<id>` (registry support for this depth unverified, see Not yet specified).

Template `typescript-node`
- Metadata: name "Node.js & TypeScript", version `0.1.0`, description "Develop Node.js based applications in TypeScript. Optional Features set up zsh, Starship, git-delta, eza and Claude Code."
- Image `mcr.microsoft.com/devcontainers/typescript-node:5-${templateOption:imageVariant}`. `imageVariant` proposals: `trixie` (default; Microsoft's latest), `26-trixie`, `24-trixie`, `22-trixie`. Debian trixie only.
- `name` (default `${containerWorkspaceFolderBasename}`) sets `name` and `runArgs --name <name>`.
- No user option, no `containerUser`, no `remoteUser`. `root` is never an option.
- Features: `github-cli` is in the Template's `features`; `python` is not listed (the user adds it in the Feature picker).
- No Claude config in the Template.

Features
- Every Feature starts at version `0.1.0`. Features use `_REMOTE_USER` and `_REMOTE_USER_HOME` for the user and home.
- `dependsOn` ids: `./<id>` in the local stage (resolved from the folder holding `devcontainer.json`, inside `.devcontainer/`), the ghcr.io id once published.
- `zsh`: installs the zsh config as `~/.zshrc`, replacing the image's file. Its `.zshrc` has no `starship init` line, and loads the `eza` plugin only when `eza` exists. Sets `terminal.integrated.defaultProfile.linux: zsh` through its `customizations` (fixed). Relies on the image's Oh My Zsh; clones `zsh-syntax-highlighting` only if missing. No options.
- `starship`: `dependsOn` the community Starship Feature; `installsAfter` `zsh` and `claude-code`. `rose-pine.toml` → `~/.config/starship.toml`; appends `eval "$(starship init zsh)"` to whatever `~/.zshrc` exists. Option `customizeClaudeCodeProfile` (boolean, default `false`): appends `customize-claude-code-profile.toml` to `starship.toml` and adds `statusLine` from `.config/claude/statusLine.json` to Claude's `settings.json`; without `claude-code`, only the profile is appended.
- `git-delta`: `dependsOn` the community delta Feature. `delta.gitconfig` → `~/.config/git/delta.gitconfig`, added with `include.path`. No options.
- `eza`: `dependsOn` the community eza Feature. `rose-pine.yml` → `~/.config/eza/theme.yml`. No options.
- `claude-code`: the user's own Feature (replaces Anthropic's). Installs Claude Code with the native installer as `$_REMOTE_USER`, as documented, and appends the docs' `export PATH="$HOME/.local/bin:$PATH"` to `~/.bashrc` and `~/.zshrc`; `installsAfter` `zsh`. Adds the `anthropic.claude-code` extension. Options: `sandbox` (boolean, default `false`: installs `bubblewrap` and `socat`, sets `enableWeakerNestedSandbox: true`); `settings` (enum `default` only in 0.1.0, default `default`; `individual` deferred). Writes `settings.json` at build time only when none exists. No Claude Code version option.
- `claude-code-config`: the optional persistent config. `dependsOn` `claude-code`. Mounts volume `devcontainers-claude-code-config` at `/usr/local/share/claude-config`; `containerEnv` `CLAUDE_CONFIG_DIR=/usr/local/share/claude-config`. `install.sh` creates that folder owned by `$_REMOTE_USER`, moves any existing `~/.claude` contents into it, and links `$_REMOTE_USER_HOME/.claude` to it.

## Decisions so far

- [Feature tarball references](issues/01-feature-tarball-references.md): HTTPS URL as the `features` key; file named `devcontainer-feature-<id>.tgz`; the spec names only `devcontainers/action` for packaging.
- [Template testing before ghcr.io](issues/02-template-testing-before-ghcr.md): `devcontainer templates apply` fetches only from OCI; the starter's smoke test substitutes defaults with `sed` and runs `devcontainer up`.
- [Claude Code sandbox requirements on Linux](issues/03-claude-code-sandbox-linux.md): `bubblewrap` + `socat`; in an unprivileged container, `enableWeakerNestedSandbox: true`.
- [Feature users and lifecycle commands](issues/04-feature-users-and-lifecycle.md): on this image `_CONTAINER_USER=root`, `_REMOTE_USER=node`; lifecycle commands run as the remote user; options are build-time only.
- [Feature target user and home](issues/05-feature-target-user.md): superseded by issue 07; no `containerUser`, Features use `_REMOTE_USER` / `_REMOTE_USER_HOME`.
- [Tarball hosting](issues/12-tarball-hosting.md): GitHub Releases on `iamchriswick/devcontainers`; tarballs from `devcontainer features package`.
- [Local and tarball-stage testing](issues/11-local-and-tarball-testing.md): follow the reference repos: `devcontainer features test` with `test/<feature>/` and `scenarios.json`; Template smoke test `build.sh` + `test.sh`.
- [claudeConfigDir default value](issues/06-claude-config-dir-default.md): lapsed; Claude config moved out of the Template.
- [Template metadata and options](issues/07-template-metadata-and-options.md): "Node.js & TypeScript" 0.1.0; `imageVariant` trixie-only, default `trixie`; `name` `${containerWorkspaceFolderBasename}`; no user option; `python` not listed.
- [Feature ids and options](issues/08-feature-ids-and-options.md): `zsh`, `starship`, `git-delta`, `eza`, `claude-code`, `claude-code-config`; options as listed above.
- [Feature dependencies](issues/09-feature-dependencies.md): Starship orders after `zsh`/`claude-code` without installing them; `claude-code-config` depends on `claude-code`; tool binaries from community Features.
- [Claude Code runtime setup](issues/10-claude-code-runtime-setup.md): settings at build time, only if missing; seed the volume when it is first created.
- [Tests for the Features and the Template](issues/13-tests.md): binaries + config paths; one scenario per option; Template image basics.
- [.config target paths](issues/14-config-target-paths.md): each tool's documented default path.
- [Oh My Zsh and the .zshrc plugins](issues/15-oh-my-zsh-and-plugins.md): rely on the image; clone `zsh-syntax-highlighting` if missing; `eza` plugin conditional.
- [Claude Code install ownership](issues/16-claude-code-install-ownership.md): superseded by the user's own `claude-code` Feature using the native installer.

## Not yet specified

- Whether ghcr.io accepts the four-level namespaces `iamchriswick/devcontainers/{templates,features}/<id>`: only checkable by a publish at the OCI stage.

## Out of scope

- Apt tools and `ENV` lines from the example Dockerfile (`DEVCONTAINER`, `SHELL`, `EDITOR`, `VISUAL`): excluded, the Dockerfile was an example, not a template.
- VS Code extensions as Features, and where their editor settings go: out of scope for now.
- Listing the collection on the containers.dev index (`collection-index.yml` in `devcontainers/devcontainers.github.io`): out of scope for now.
- Other operating systems: not considered for now; all planned Templates are Linux on the same Debian base.

## Future expansion

- `claude-code` `settings` value `individual` (choose individual settings from `.config/claude/settings.json`), added once its grouping is decided.
- A Feature that installs and sets up Next.js (if no Next/Nuxt/etc. project already exists in the workspace) and shadcn/ui.
