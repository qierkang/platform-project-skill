# References Index

> 按需加载。SKILL.md 不会预热这些文件 — 模型应在确定路径后才 Read 对应规则。

## Workflow files (load one based on route)

| File | When to load |
|---|---|
| [workflow-new-project.md](workflow-new-project.md) | 新项目 / 空目标目录 |
| [workflow-existing-project.md](workflow-existing-project.md) | 已有代码的项目 |
| [workflow-hybrid.md](workflow-hybrid.md) | 已有项目想从 omni-platform 母版重塑（基座派生） |

## State & Reporting (HARD RULE)

| File | Use when |
|---|---|
| [state-model.md](state-model.md) | 任何新项目流程必读 — 定义 scaffold/asset/validation/initialization_done |
| [completion-report-template.md](completion-report-template.md) | 准备向用户报告"完成"前必读 |

## Rule files (load only the rule needed for the task)

| File | Use when |
|---|---|
| [non-invasive-upgrade.md](non-invasive-upgrade.md) | 任何修改老项目时必读 |
| [platform-rules.md](platform-rules.md) | 设计新项目目录结构、命名、根文件清单 |
| [readme-rules.md](readme-rules.md) | 撰写或校验 README |
| [readme-open-source-style.md](readme-open-source-style.md) | 重构开源 README 或要求按 `platform-project-skill/README.md` 新版样式生成 README |
| [github-publish.md](github-publish.md) | 把 skill / 项目发布到 GitHub 公开仓库（安全扫描、社区文件、social preview、Topics/Homepage、首次发布后 Star History 二次提交、隔离发布） |
| [assets-rules.md](assets-rules.md) | 设计 assets/ 布局或生成图片 |
| [graphify-rules.md](graphify-rules.md) | 决定是否生成 / 刷新 graphify |
| [name-replacement-rules.md](name-replacement-rules.md) | 派生新项目时做名称替换 |
| [upgrade-report-template.md](upgrade-report-template.md) | 写老项目升级报告 |

## Loading discipline

- SKILL.md → route file → rule file(s) → scripts → assets。逐层加载，不要一次性读完。
- 单个任务通常只需要 1 个 workflow + 1-3 个 rule。
- 模板内容（`assets/templates/omni-platform/`）不要全量 Read；用 `find` 列结构，再按需 Read。
