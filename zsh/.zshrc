# ~/.zshrc: installed by .devcontainer/Dockerfile from .devcontainer/.config/zsh/.zshrc
# Edit the source file and rebuild the container. Changes made here are lost on rebuild.

# ─── Oh My Zsh ────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

# No theme: Starship draws the prompt (see the bottom of this file)
ZSH_THEME=""

# Updates arrive with image rebuilds, not inside the container
zstyle ':omz:update' mode disabled

# ─── Plugin settings (must come before Oh My Zsh is sourced) ──────────────────
# vscode: which editor CLI to use: code | code-insiders | codium | cursor
VSCODE=code

# nvm: switch Node version automatically when a .nvmrc is found in the cwd
zstyle ':omz:plugins:nvm' autoload yes

# eza: settings for the `ls`-style aliases
zstyle ':omz:plugins:eza' 'dirs-first' yes   # group directories first
zstyle ':omz:plugins:eza' 'git-status' yes   # --git: show git status column
zstyle ':omz:plugins:eza' 'header'     yes   # -h: header row
zstyle ':omz:plugins:eza' 'links'      yes   # -H: hard link count
zstyle ':omz:plugins:eza' 'icons'      yes   # --icons: needs a Nerd Font

# ─── Plugins ──────────────────────────────────────────────────────────────────
# Bundled: $ZSH/plugins/    Custom: $ZSH_CUSTOM/plugins/
# Every plugin slows startup, so keep the list short.
plugins=(
  nvm
  eza
  git
  gh
  vscode
  zsh-syntax-highlighting   # must be last
)

source "$ZSH/oh-my-zsh.sh"

# ─── Aliases ──────────────────────────────────────────────────────────────────
alias reload="exec zsh"
alias zshconf="$EDITOR ~/.zshrc"
alias ohmyzshconf="$EDITOR ~/.oh-my-zsh"
alias starshipconf="$EDITOR ~/.config/starship.toml"

# ─── Prompt ───────────────────────────────────────────────────────────────────
eval "$(starship init zsh)"
