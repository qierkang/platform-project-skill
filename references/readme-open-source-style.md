# Open Source README Style Rules

> Canonical style source: `platform-project-skill/README.md`. When rewriting README files for public-facing projects or skill packages, preserve this structure and visual rhythm unless the user explicitly asks for a smaller internal README.

## Hard Rule

For README rebuild tasks, use `platform-project-skill/README.md` as the first local exemplar, ahead of generic README templates. Do not produce a minimal README when the request is "重构 README", "开源 README", "按新版格式", or similar.

## Required Top Structure

The root `README.md` MUST keep this order:

1. H1 project name.
2. HTML keyword comment:
   - `<!-- Keywords: ... -->`
   - include search terms for project category, AI agent usage, framework/runtime, and public discovery.
3. Required full-width social preview image:
   - use `<div align="center"><img ... width="100%"></div>`
   - every README rebuilt with this open-source style MUST include `assets/social-preview.png` or `assets/social-preview.svg` near the top.
   - if missing, generate a project-specific social preview with `image_gen`, save it under `assets/`, reference it from README, and register it in `assets/asset-manifest.json` when the project uses asset manifests.
   - `assets/social-preview.png` is the GitHub Settings upload image and MUST be smaller than 1 MiB (`1048576` bytes). If an `image_gen` result exceeds this limit, compress or regenerate it before registration and before reporting the README ready.
   - if the image changes, increment cache-busting query, for example `?v=4`.
4. Centered hero block:
   - `<strong>` one-line value proposition.
   - `<em>` Chinese supporting line or bilingual supporting line.
   - tool/format compatibility line using `<code>SKILL.md</code>` or the project equivalent.
   - short slogan line.
   - Star guidance line.
5. Centered navigation block:
   - quick start anchor.
   - language links when available.
   - workflow/platform/design anchor.
   - FAQ anchor.
6. Centered badge block:
   - License.
   - Version.
   - Status.
   - primary language/runtime/tooling.
   - template/category badge when applicable.
   - PRs welcome when public.
   - compatibility badge when relevant.
   - CI badge when public CI exists.
   - Stars badge when public GitHub repo exists.
7. Horizontal rule.
8. Direct Markdown image for the main README visual:
   - `![...](./assets/...)`
   - never wrap display images in fenced code blocks.
9. Horizontal rule.

## Required Main Sections

After the top structure, keep these sections in this order unless the project type makes a section impossible. If a section is not applicable, keep the heading and state the boundary briefly.

1. `## 为什么需要 <Project Name>？`
   - describe real pain points.
   - use 4-6 bullets with concrete before/after friction.
   - add a bold transition sentence that explains what the project turns into a repeatable process.
   - include one direct invocation or command example when the project is a skill/tool.
   - include a compact value table with 4-6 rows.
2. `## 项目概述`
   - one dense paragraph explaining what it is, who it is for, and what outcome it creates.
   - include an English blockquote summary.
   - include the Star guidance blockquote line: `If this saves you time, a ⭐ helps others find it.`
3. `## 核心特色`
   - 5 bullets.
   - each bullet starts with bold feature name.
   - each bullet must describe concrete mechanics, not marketing filler.
4. `## 与同类方案对比`
   - comparison table.
   - first row is the current project in bold.
   - include 4-6 capability columns.
5. `## 工作流总览`
   - scenario/route/description table for skills and tools.
   - process/stage/output table for product or app projects.
   - include a short "not sure" guidance line when routing exists.
6. `## 快速开始`
   - include `### 前置条件`.
   - include install/setup commands.
   - include primary usage command.
   - for generated structures, use `<details><summary>...</summary>` with a concise tree.
   - include additional workflow images directly when available.
7. `## 功能模块`
   - use `###` subsections for major domains.
   - each domain has 3-5 concrete bullets.
8. `## 技术栈`
   - table with `层级 / 技术或资产 / 说明`.
   - include skill entry, rules, scripts, templates/assets, visual generation, README gate when relevant.
9. `## 系统架构`
   - include `### 工作流设计`.
   - include a text architecture diagram.
   - include `### 架构说明`.
   - include a direct Markdown resource-map image when available.
10. `## 目录结构`
    - concise tree, not a full repository dump.
    - include comments explaining key files.
11. `## 命令参考`
    - command table for scripts/CLI/API.
12. `## 开发指南`
    - split into `###` subsections for common modification paths.
    - include safe/unsafe editing boundaries.
13. `## 开发与验证`
    - include ordered validation commands.
    - explicitly state what counts as pass/fail.
14. `## 项目状态`
    - current status, version stage, maintenance mode, compatibility, known risks/evidence link.
15. `## 常见问题`
    - use `<details>` blocks.
    - each answer includes a concrete command or boundary when applicable.
16. `## 参与贡献`
    - include Issue, feature proposal, script change, document change guidance.
    - include links to CONTRIBUTING, Issues, PRs when public.
    - include English contributor note when the project has English docs.
17. `## 版本说明`
    - version table.
    - link to `CHANGELOG.md`.
18. `## 致谢`
    - link real upstream projects/tools only.
19. `## Star History · Star 历史`
    - include Star callout.
    - include star-history chart only when a public GitHub repo exists.
20. `## 许可证`
    - license name and copyright owner.
21. `## 作者`
    - include `xyqierkang@gmail.com`.
    - include `https://github.com/qierkang`.

## Visual And Badge Rules

- Use `style=for-the-badge` for top badges to match `platform-project-skill`.
- Use centered HTML blocks for hero, nav, and badges.
- Use a full-width social preview before the text hero; this is mandatory for open-source README rebuilds.
- Use direct Markdown image syntax for display images.
- Root README image paths use `./assets/...`.
- Chinese root README references `zh-CN` images.
- English README references `en` images.
- If no public GitHub repository exists yet, omit live CI/stars/star-history badges instead of inventing URLs.
- If a public GitHub repository exists, include PRs, CI, Stars, Issues, PR, and Star History links.

## Content Quality Rules

- Every section must contain project-specific facts.
- Do not leave template placeholders or generic filler.
- Do not claim public GitHub, CI, stars, Product Hunt, npm, Docker image, or hosted demo unless verified.
- Preserve real existing content during old-project upgrades, but reorganize it into this structure.
- If the README becomes longer than an internal token-budget preference, do not remove this structure first; move deep reference details to `docs/` and keep the top README as a complete public overview.
- The README can exceed old line-count limits. README quality is gated by content structure, image links, no placeholders, and validation scripts, not by a fixed line count.
- Missing social preview image is a README style failure for this template. Generate one instead of silently omitting the block.

## Language Rules

- Root `README.md` defaults to Simplified Chinese.
- Add `docs/README_en.md` for English.
- `docs/README_en.md` MUST be a full English counterpart, not a condensed abstract. It should preserve the same top hero, nav, badges, main visual, pain points, overview, features, comparison, workflow, quick start, modules, tech stack, architecture, directory, commands, development guide, validation, status, FAQ, contribution, version, acknowledgements, Star History, license, and author structure unless a section is truly impossible.
- Add `docs/README_zh-tw.md` when Traditional Chinese documentation is requested or already exists.
- The language nav must be visible near the top hero.
- Keep translated README files structurally equivalent where possible; English images must use `assets/.../en/...`.

## Validation Checklist

Before reporting README work as done:

```bash
~/.claude/scripts/readme-gate.py --readme README.md
```

If the project has a local README gate, run it too. Also verify:

- `docs/README_en.md` exists when the root README links English docs.
- `docs/README_en.md` is structurally equivalent to the root README and uses English `en` image assets.
- Main README display image paths exist.
- Social preview exists at `assets/social-preview.*` and is referenced near the top of README.
- `assets/social-preview.png`, when present, is smaller than 1 MiB (`1048576` bytes).
- `assets/asset-manifest.json` contains all generated README images when asset rules apply.
- No fenced code block wraps display images.
- No unverified public badges or links.
- Author email and GitHub are present.
