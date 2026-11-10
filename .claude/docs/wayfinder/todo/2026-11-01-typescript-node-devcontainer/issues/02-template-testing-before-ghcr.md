# Template testing before ghcr.io

Type: research
Status: resolved
Blocked by:

## Question

Can the Template be applied from a local folder or a tarball (before it is on ghcr.io), and how is `${templateOption:x}` substituted when it is applied?

## Answer

- `devcontainer templates apply` fetches only from an OCI registry. `--template-id` is described as "Reference to a Template in a supported OCI registry"; `fetchTemplate` resolves it with `getRef` and fetches the manifest and blob from the registry, with no path for a local folder or tarball. Source: devcontainers/cli `src/spec-node/templatesCLI/apply.ts`, `src/spec-configuration/containerTemplatesOCI.ts`.
- On apply, each extracted file has every match of `/\${templateOption:\s*(\w+?)\s*}/g` replaced by the chosen value; an option with no value becomes an empty string (`return options[token] || '';`). Source: `containerTemplatesOCI.ts` (`replaceTemplatedValues`).
- `devcontainers/template-starter` smoke test (`.github/actions/smoke-test/build.sh`) copies `src/<id>`, replaces each `${templateOption:x}` with the option's `default` using `sed`, then runs `devcontainer up` on the result. Source: template-starter repo, read in this session.
