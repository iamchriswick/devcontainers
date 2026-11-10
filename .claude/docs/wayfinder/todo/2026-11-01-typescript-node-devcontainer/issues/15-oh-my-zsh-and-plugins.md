# Oh My Zsh and the .zshrc plugins

Type: grilling
Status: resolved
Blocked by: 08

## Question

Your `.zshrc` sets `ZSH="$HOME/.oh-my-zsh"` and loads `nvm`, `eza`, `git`, `gh`, `vscode` and `zsh-syntax-highlighting`. What provides Oh My Zsh and the plugins?

## Answer

Source: user's answers (audit session, 2026-11-02), with the facts below.

- Oh My Zsh: rely on the image. Fact: the typescript-node image ships it at `/home/node/.oh-my-zsh` through `common-utils` (`installOhMyZsh` default `true`; https://github.com/devcontainers/features/blob/main/src/common-utils/devcontainer-feature.json), seen in the image layer.
- `zsh-syntax-highlighting`: the `zsh` Feature clones it into `$ZSH_CUSTOM/plugins/` only if neither `$ZSH/plugins/` nor `$ZSH_CUSTOM/plugins/` has it. Fact: bundled in Oh My Zsh since 2026-09-10 (PR #14088) and present in the typescript-node image; older copies lack it.
- `eza` plugin: removed from the static `plugins` list and added with `(( $+commands[eza] )) && plugins+=(eza)` before Oh My Zsh is sourced. Fact: the plugin prints "zsh eza plugin: eza not found…" on every shell start when `eza` is missing (`plugins/eza/eza.plugin.zsh`, lines 1–4). The `gh` and `nvm` plugins return silently when their tool is missing.
- Unverified: whether `code` is on PATH in every dev container shell; if not, the `vscode` plugin prints "'code' flavour of VS Code not detected."
