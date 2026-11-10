# Local and tarball-stage testing

Type: grilling
Status: resolved
Blocked by: 02

## Question

`devcontainer templates apply` only works from an OCI registry (see "Template testing before ghcr.io"), and local Features must sit in `.devcontainer/<id>/` of the project that uses them (https://containers.dev/implementors/features-distribution/, Addendum: Locally Referenced). How are the Template and Features tested in stage one (local) and stage two (tarball)?

## Proposal

- Stage one: the template-starter smoke test (copy `src/typescript-node`, replace each `${templateOption:x}` with its default, `devcontainer up`), with the Features copied into the test copy's `.devcontainer/<id>/` and referenced as `./<id>`. Features on their own: the feature-starter's tests.
- Stage two: the same smoke test with the Features referenced by tarball URL (see "Tarball hosting").

## Answer

Follow the reference repos.
- Features (`devcontainers/feature-starter`): `devcontainer features test` builds and execs Features from the local source tree. Each Feature has `test/<feature>/test.sh`; `test/<feature>/scenarios.json` holds named `devcontainer.json` snippets that set options, each with a same-named `.sh` that must exit 0; `test/_global/` holds scenarios not tied to one Feature. Example: `devcontainer features test -f dotnet --base-image ubuntu`. Source: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
- Template (`devcontainers/template-starter`): `./.github/actions/smoke-test/build.sh <template-id>` then `./.github/actions/smoke-test/test.sh <template-id>`, with `test/<template-id>/test.sh`. Source: template-starter README.
