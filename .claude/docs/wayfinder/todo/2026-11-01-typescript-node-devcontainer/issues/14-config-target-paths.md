# .config target paths

Type: grilling
Status: resolved
Blocked by: 08

## Question

Where does each Feature install its `.config` file in the user's home?

## Answer

Source: user's answers (audit session, 2026-11-02). All paths are under `$_REMOTE_USER_HOME`, each tool's documented default.

- `starship`: `rose-pine.toml` → `~/.config/starship.toml` (https://starship.rs/config/).
- `eza`: `rose-pine.yml` → `~/.config/eza/theme.yml` (https://github.com/eza-community/eza/blob/main/man/eza_colors-explanation.5.md).
- `git-delta`: `delta.gitconfig` → `~/.config/git/delta.gitconfig`, added with `git config --global include.path ~/.config/git/delta.gitconfig` run as the user (https://git-scm.com/docs/git-config#FILES, https://dandavison.github.io/delta/configuration.html).
- `zsh`: `.zshrc` → `~/.zshrc`, replacing the image's file, no backup (https://zsh.sourceforge.io/Doc/Release/Files.html).
