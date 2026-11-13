# hb:commit: use smart-commits instead

Never use the `hb:commit` skill in this repository. Commit with the `smart-commits` skill and follow `.claude/rules/smart-commits.md`.

`hb:commit` commits without confirmation and only to the current branch, which breaks this repo's commit rules. If the user invokes `/hb:commit`, follow the `smart-commits` workflow instead.
