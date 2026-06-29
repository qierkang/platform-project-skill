# README Rules

## Template Sources

Follow the shared README style and gate:

- `platform-project-skill/README.md` — canonical open-source README exemplar for local rewrites
- `references/readme-open-source-style.md` — exact structure/style rules extracted from the exemplar
- `wiki/topics/README生成模板规范.md`
- `wiki/references/README生成规则模板.md`
- `wiki/references/README标准母版成品.md`
- `~/.claude/scripts/readme-gate.py`

## Required Behavior

- Generate a complete, practical README, not a minimal stub.
- When the request is README rewrite/refactor/open-source polish, MUST load `references/readme-open-source-style.md` and follow the `platform-project-skill/README.md` structure. Do not omit hero, nav, badges, main image, pain-point section, English summary, comparison table, workflow overview, quick start, modules, tech stack, architecture, directory, command reference, development guide, validation, status, FAQ, contribution, version, acknowledgements, Star History, license, and author unless the project truly lacks the verified public data for that section.
- Open-source README rebuilds MUST include a full-width social preview image near the top. If the target project lacks `assets/social-preview.*`, generate one with `image_gen`, save it under `assets/`, reference it from README, and register it in `assets/asset-manifest.json` when present.
- `assets/social-preview.png` MUST be smaller than 1 MiB (`1048576` bytes). If `image_gen` produces a larger PNG, compress or regenerate it before registration, validation, commit, or GitHub upload.
- Preserve real existing content for old projects.
- Include author information:
  - `xyqierkang@gmail.com`
  - `https://github.com/qierkang`
- Use direct image syntax for display images:
  - Correct: `![架构图](./assets/platform/architecture/zh-CN/example.png)`
  - Incorrect for display: fenced `md` code block wrapping the image syntax
- Default to a Simplified Chinese root `README.md`.
- Add `docs/README_en.md` and link it from the root language navigation.
- `docs/README_en.md` must be a complete English counterpart, not a short summary. Keep the same open-source README structure as the root README: social preview, hero, nav, badges, main image, pain points, overview, features, comparison, workflow, quick start, modules, tech stack, architecture, directory, command reference, development guide, validation, status, FAQ, contribution, version, acknowledgements, Star History, license, and author.
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
When `docs/README_en.md` exists, inspect it for structural parity with the root README; do not treat a short English abstract as a valid English README.
