# Tarball hosting

Type: grilling
Status: resolved
Blocked by: 01

## Question

For stage two, where are the `devcontainer-feature-<id>.tgz` files hosted (HTTPS required, see "Feature tarball references"), and how are they produced?

## Proposal

GitHub Releases on `iamchriswick/devcontainers`, from the `features` branch. Production: the spec names only `devcontainers/action`; whether the CLI has a packaging command is unverified and must be checked before this is decided.

## Answer

GitHub Releases on `iamchriswick/devcontainers`. Source: user's answer.

## Comments

- 2026-11-02 (audit session): production. `devcontainer features package <target> [-o ./output]` writes one `devcontainer-feature-<id>.tgz` per Feature plus `devcontainer-collection.json` (devcontainers/cli `src/spec-node/devContainersSpecCLI.ts:104`, `collectionCommonUtils/packageCommandImpl.ts:71`). It writes an uncompressed tar under the `.tgz` name (`tar.create` without gzip, `packageCommandImpl.ts:68`); the CLI reads it back with `tar.x`. Unverified: that `tar.x` detects the format automatically. Templates have no `package` command.
