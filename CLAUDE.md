# devcontainers

Forked from [devcontainers/feature-starter](https://github.com/devcontainers/feature-starter). Before working on a feature, read `README.md` and follow its links, plus the starter's [`test/`](https://github.com/devcontainers/feature-starter/tree/main/test), [`.github/workflows/`](https://github.com/devcontainers/feature-starter/tree/main/.github/workflows) and [devcontainers/action](https://github.com/devcontainers/action). They show which files a new feature needs and how it is tested and published.

Specific to this repo:

- `test.yaml` and `validate.yml` live on `features`; `publish_features.yaml` and `release_features.yaml` live on `main`.
- `.claude/` is a Docker volume mount (see `.devcontainer/devcontainer.json`), not the bind-mounted checkout.
