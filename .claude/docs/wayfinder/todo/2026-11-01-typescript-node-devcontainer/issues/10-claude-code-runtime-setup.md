# Claude Code runtime setup

Type: grilling
Status: resolved
Blocked by: 05, 08

## Question

`CLAUDE_CONFIG_DIR` only exists at runtime (set by the Template's `containerEnv`, and with `${containerWorkspaceFolder}` resolved by the tool). A Feature's option values are only available to `install.sh` at build time, and lifecycle commands run as the remote user (see "Feature users and lifecycle commands"). How do `claude-code` (ownership of `CLAUDE_CONFIG_DIR`, the settings file, sandbox) and `starship` (`statusLine` into `settings.json`) apply their work to `CLAUDE_CONFIG_DIR`?

## Proposal

- `install.sh` (root, build time) writes a script into the image with the chosen option values baked in, and the Feature's `postCreateCommand` runs it as the remote user.
- `claude-code` script: `sudo chown` `$CLAUDE_CONFIG_DIR` to the user (`node` has passwordless sudo), then merges `.config/claude/settings.json` into `$CLAUDE_CONFIG_DIR/settings.json` with `jq` when `settings` is `default`.
- `sandbox: true`: `install.sh` installs `bubblewrap` and `socat`; the script adds `"sandbox": { "enableWeakerNestedSandbox": true }` (see "Claude Code sandbox requirements on Linux").
- `starship` with `customizeClaudeCodeProfile`: its script merges `statusLine` from `.config/claude/statusLine.json` into `$CLAUDE_CONFIG_DIR/settings.json`.

## Answer

Source: user's answers (audit session, 2026-11-01/02), with the facts below.

- `claude-code` writes your `settings.json` at build time into `$_REMOTE_USER_HOME/.claude`, only when no `settings.json` exists. With `sandbox=true` it installs `bubblewrap` and `socat` and sets `"sandbox": { "enableWeakerNestedSandbox": true }`. `starship` with `customizeClaudeCodeProfile` adds `statusLine` the same way.
- `claude-code-config` then moves that content into `/usr/local/share/claude-config` and links `~/.claude` to it (issue 08). Docker copies image content into a volume only when the volume is empty, so the settings seed the volume once, when it is first created.
- Accepted consequence: an existing volume never receives later settings (e.g. sandbox or the Starship profile added afterwards).
- Ownership: the folder is owned by `$_REMOTE_USER` in the image; nothing chowns at runtime, so containers with another UID can't take the shared volume.
- Facts:
  - "By default, content at the target destination gets copied into a mounted volume if empty" (https://docs.docker.com/engine/storage/volumes/); moby's `copyExistingContents` "copies from the source to the destination and ensures the ownership is appropriately set" (https://github.com/moby/moby/blob/master/daemon/container/container_unix.go).
  - `ln -s` onto an existing directory creates the link inside it (https://www.gnu.org/software/coreutils/manual/html_node/ln-invocation.html), hence move-then-link.
  - `install.sh` runs as root; dev containers run unprivileged unless `privileged` is set; bubblewrap needs `enableWeakerNestedSandbox` there (https://code.claude.com/docs/en/sandboxing).
  - Anthropic's reference creates and chowns its config folder before mounting (https://github.com/anthropics/claude-code/blob/main/.devcontainer/Dockerfile).
