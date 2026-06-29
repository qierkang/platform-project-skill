# README Rules

## Template Sources

Follow the shared README style and gate:

- `wiki/topics/README生成模板规范.md`
- `wiki/references/README生成规则模板.md`
- `wiki/references/README标准母版成品.md`
- `~/.claude/scripts/readme-gate.py`

## Required Behavior

- Generate a complete, practical README, not a minimal stub.
- Preserve real existing content for old projects.
- Include author information:
  - `xyqierkang@gmail.com`
  - `https://github.com/qierkang`
- Use direct image syntax for display images:
  - Correct: `![架构图](./assets/platform/architecture/zh-CN/example.png)`
  - Incorrect for display: fenced `md` code block wrapping the image syntax
- Default to a Simplified Chinese root `README.md`.
- Add `docs/README_en.md` and link it from the root language navigation.
- Reference `zh-CN` images from Chinese README files and `en` images from the English README.

## Root README Image Paths

Use:

```text
./assets/...
```

## Subproject README Image Paths

Use:

```text
../assets/...
```

## Open Source Baseline Files

When a project is intended to be published publicly on GitHub, the README is not enough.
The following baseline files MUST exist (the new-project template ships them; existing-project
upgrades should add the missing ones):

- `LICENSE` — MIT by default. Bundled in `assets/templates/omni-platform/LICENSE`; new projects
  inherit it automatically. `check-project-baseline.sh` FAILs a new project that lacks it.
- `.gitignore` — ignore `.DS_Store`, `node_modules/`, `dist/`, real `.env` files, editor dirs.
- `CONTRIBUTING.md` — contribution guide with local validation steps and a pre-PR checklist.
- `CHANGELOG.md` — follow Keep a Changelog + Semantic Versioning.
- `.github/workflows/ci.yml` — at minimum run `bash -n` on scripts and the README gate.
- `.github/ISSUE_TEMPLATE/` — bug and feature templates lower the contribution barrier.
- Required English documentation at `docs/README_en.md`; optional Traditional Chinese documentation
  at `docs/README_zh-tw.md`. Keep working cross-links from the root README navigation.

Before publishing, run a release-safety scan: no hardcoded secrets, no real `.env`, no noise
files (`.DS_Store` / `node_modules` / `dist`), and no internal business names or absolute user
paths leaking outside governance/clean-up records.

## Validation

Run:

```bash
~/.claude/scripts/readme-gate.py --readme README.md
```

If the project has subproject README files, run the same gate for each one.
