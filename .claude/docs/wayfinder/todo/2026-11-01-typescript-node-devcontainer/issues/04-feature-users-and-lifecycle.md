# Feature users and lifecycle commands

Type: research
Status: resolved
Blocked by:

## Question

Which user and home do `_CONTAINER_USER`, `_CONTAINER_USER_HOME`, `_REMOTE_USER` and `_REMOTE_USER_HOME` resolve to on `mcr.microsoft.com/devcontainers/typescript-node:5-24-trixie` when `devcontainer.json` sets neither `remoteUser` nor `containerUser`? Which user runs a Feature's lifecycle commands, and can they read the Feature's option values?

## Answer

Image facts
- Image config (amd64, read from mcr.microsoft.com): `"User": "root"`. `devcontainer.metadata` label: `"remoteUser": "node"` (from javascript-node and typescript-node), no `containerUser`.
- Neither the `typescript-node` nor `javascript-node` Dockerfile has a `USER` line. The `node` user has passwordless sudo (`common-utils` with `username: node`, `main.sh:515-519`). Source: devcontainers/images, devcontainers/features.

How the variables resolve (devcontainers/cli)
- `findContainerUsers` (`src/spec-node/containerFeatures.ts`): `containerUser = <last containerUser in merged metadata> || composeServiceUser || imageUser`; `remoteUser = <last remoteUser in merged metadata> || containerUser`.
- `_REMOTE_USER_HOME` / `_CONTAINER_USER_HOME` are each user's `passwd` home (`getent passwd <user> | cut -d: -f6`). Source: `src/spec-configuration/containerFeaturesConfiguration.ts`.
- Spec: `_CONTAINER_USER` is the container's user (`containerUser`, compose `user`, Dockerfile `USER`, or inherited from the base image); "If no `remoteUser` is configured, `_REMOTE_USER` is set to the same value as `_CONTAINER_USER`." Source: https://containers.dev/implementors/features/
- Result for this image: `_CONTAINER_USER=root`, `_CONTAINER_USER_HOME=/root`, `_REMOTE_USER=node`, `_REMOTE_USER_HOME=/home/node`. Derived from the facts above; not observed in a running build.

Lifecycle commands
- The spec does not say which user runs lifecycle commands; `install.sh` runs as root. Source: Features spec, devcontainer.json reference.
- CLI: Feature lifecycle commands run through the same path as `devcontainer.json` ones (`runLifecycleCommand`, `src/spec-common/injectHeadless.ts`), as `remoteUser || containerInfo.Config.User || 'root'` (`createContainerProperties`, `src/spec-node/utils.ts`). Where the caller takes `remoteUser` from is not shown in that file.
- Feature option values are environment variables for `install.sh` at build time. The spec says nothing about them being readable by the Feature's lifecycle commands at runtime.
