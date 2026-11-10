# Feature target user and home

Type: grilling
Status: resolved
Blocked by: 04

## Question

The Features are decided to use `_CONTAINER_USER` and `_CONTAINER_USER_HOME`. Per "Feature users and lifecycle commands", on this image with neither `remoteUser` nor `containerUser` set, those resolve to `root` and `/root`, while `_REMOTE_USER` / `_REMOTE_USER_HOME` resolve to `node` and `/home/node` (from the image's metadata). Which pair do the Features use to install the zsh, Starship, git-delta, eza and Claude Code config files?

## Proposal

`_REMOTE_USER` / `_REMOTE_USER_HOME`: on this image they point at `node`, the user VS Code and lifecycle commands run as, so the config files land in the home of the user who uses them. Needs the user's decision; it changes an earlier decision.

## Answer

The user sets `containerUser`: a Template option `containerUser` (default `node`) is substituted into `devcontainer.json` as `"containerUser": "${templateOption:containerUser}"`. The Features use `_CONTAINER_USER` / `_CONTAINER_USER_HOME`, which then resolve to the chosen user and their home (`containerUser` from the merged metadata, see "Feature users and lifecycle commands"). Source: user's answer.

## Comments

- 2026-11-02 (audit session): superseded by issue 07. The user dropped the `containerUser` option; no `containerUser` is set and Features use `_REMOTE_USER` / `_REMOTE_USER_HOME`.
