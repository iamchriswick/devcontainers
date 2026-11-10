# Feature dependencies

Type: grilling
Status: resolved
Blocked by: 08

## Question

How are the dependencies between `zsh`, `starship` and `claude-code` expressed (`dependsOn` installs the dependency; `installsAfter` only orders it if selected; https://containers.dev/implementors/features/)? Starship is decided to depend on Claude Code. Starship also writes to `.zshrc`, which the `zsh` Feature installs.

## Proposal

- `starship`: `dependsOn` `claude-code` (the decision), `installsAfter` `zsh` (so its `.zshrc` line lands after the zsh config is installed).
- `zsh`, `git-delta`, `eza`, `claude-code`: no dependencies.
- Open: when `starship` is selected without `zsh`, it skips the `.zshrc` line.

## Answer

Source: user's answers (audit session, 2026-11-01/02), with the facts below.

- `starship`: `installsAfter` `zsh` and `claude-code` (orders only, installs nothing). `dependsOn` the community Starship Feature.
- `zsh` installs your `.zshrc` without the `eval "$(starship init zsh)"` line; `starship` appends that line to whatever `~/.zshrc` exists (yours, or the image's).
- `customizeClaudeCodeProfile=true` without `claude-code`: the profile is appended to `starship.toml`; adding `statusLine` is skipped.
- `git-delta`, `eza`: `dependsOn` their community Features.
- `claude-code-config`: `dependsOn` `claude-code`.
- Facts: `dependsOn` installs the dependency, `installsAfter` only orders (https://containers.dev/implementors/features/). `dependsOn` follows the semantics of the `features` object: a local id is resolved from the folder holding `devcontainer.json` and must stay inside `.devcontainer/` (devcontainers/cli `src/spec-configuration/containerFeaturesConfiguration.ts:840-860`), so the local form is `./<id>` and the published form the ghcr.io id.

## Comments

- 2026-11-02 (audit session): `claude-code` `installsAfter` `zsh`, so the `zsh` Feature's replacement of `~/.zshrc` doesn't drop `claude-code`'s PATH line (user's answer; see issue 08 comment).
