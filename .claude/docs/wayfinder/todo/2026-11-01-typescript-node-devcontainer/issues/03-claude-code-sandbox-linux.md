# Claude Code sandbox requirements on Linux

Type: research
Status: resolved
Blocked by:

## Question

What does Claude Code's sandbox require on Linux, and what does it need inside a container?

## Answer

- Linux requires `bubblewrap` and `socat`. Debian/Ubuntu install: `sudo apt-get install bubblewrap socat`. Ripgrep is bundled with Claude Code. The seccomp filter is optional (`npm install -g @anthropic-ai/sandbox-runtime`). Source: https://code.claude.com/docs/en/sandboxing
- In an unprivileged container bubblewrap can't mount a fresh `/proc` (`Can't mount proc on /newroot/proc: Operation not permitted`). The documented fix is the Claude Code setting `"sandbox": { "enableWeakerNestedSandbox": true }`, to be used only when the outer container already provides the isolation needed. Source: same page.
