# Feature tarball references

Type: research
Status: resolved
Blocked by:

## Question

For distribution stage two (directly referenced tarballs): how is a Feature referenced by tarball in `devcontainer.json`, what must the tarball be named and contain, and how is it produced?

## Answer

- Syntax: the HTTPS URL is the key in `features`, e.g. `"https://github.com/user/repo/releases/devcontainer-feature-go.tgz": { "optionA": "value" }`. Format `https://<uri-to-feature-tgz>`. Source: https://containers.dev/implementors/features/ (Referencing a Feature).
- The URL must be HTTPS. The file must be named `devcontainer-feature-<featureId>.tgz` and contains the entire contents of the Feature sub-directory; files outside it are not included. Source: https://containers.dev/implementors/features-distribution/ (Directly referencing a tarball, Packaging).
- The spec names no CLI command for producing the tarball; the reference packaging implementation it names is the GitHub Action (`devcontainers/action`). Source: same page.
