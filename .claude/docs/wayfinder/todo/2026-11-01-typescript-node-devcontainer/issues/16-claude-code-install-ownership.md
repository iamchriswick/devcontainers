# Claude Code install ownership

Type: grilling
Status: resolved
Blocked by:

## Question

Anthropic's Feature installs Claude Code as root, so the non-root user can't auto-update it. How is that fixed?

## Answer

Source: user's answers (audit session, 2026-11-02).

- Superseded: the user's own `claude-code` Feature (issue 08) installs Claude Code with the native installer as `$_REMOTE_USER`, so the install belongs to the user and Anthropic's Feature is not used.
- Facts: Anthropic's Feature v1.0.5 runs `npm install -g @anthropic-ai/claude-code` as root with no `chown` (https://github.com/anthropics/devcontainer-features/blob/main/src/claude-code/install.sh); updates then fail with EACCES (https://github.com/anthropics/devcontainer-features/issues/27). The install location (binary) and `~/.claude` (config) are separate folders.
