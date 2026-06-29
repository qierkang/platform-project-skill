# Hybrid Workflow (Existing Template / Base Project Fork)

Use this workflow when target already contains an existing project that itself was derived from a template (or another platform base), and the user wants to align it back to the omni-platform母版 without losing business code.

## Decision Tree

1. 跑 `scripts/inspect-project.sh <project-path>`，确认：
   - `PROJECT_TYPE` 是 `existing`
   - `HAS_PACKAGE_JSON / HAS_DOCKER` 等结构与 omni-platform 是否吻合
2. 列出三类目录：
   - **业务目录** — 与母版命名一致（如 `*-front / *-mobile / *-server`）→ 保留
   - **AI 接手层** — `AGENTS.md / CLAUDE.md / START-HERE.md / docs/ai-upgrade/` → 走老项目升级流程补齐
   - **基线设施** — `docker-compose.yml / .env.example / scripts/util-*` → 仅在缺失时补母版版本
3. 如果用户要"重对齐"业务代码到母版规范，**必须显式确认**：
   - 是否允许重命名子项目目录（默认不允许）
   - 是否允许覆盖现有 `docker-compose.yml`（默认追加文档，不覆盖）

## Hybrid Steps

1. 先按 `workflow-existing-project.md` 跑非侵入升级（默认不带 `--with-assets`/`--with-platform-docs`）
2. 用 `diff` 对比 `assets/templates/omni-platform/` 与目标的基线设施差异，列出建议清单
3. 让用户选择对建议清单中的哪些项做"采纳/拒绝"
4. 采纳的项手动同步，不要批量 rsync 覆盖
5. 全程将每个采纳/拒绝决策写入 `docs/ai-upgrade/report-老项目AI能力升级.md` 的 "Hybrid Decisions" 段

## Stop Conditions

- 用户要求"强制对齐母版" → 先生成对比清单，并明确告诉用户哪些是破坏性操作
- 目标项目的目录命名不是 `*-platform` 家族 → 不要强行重命名
- 目标项目的技术栈与母版差异巨大（如 Vue / Django） → 仅做 AI 接手层升级，不动业务

## Output Contract

- 升级报告必须包含 "Hybrid Decisions" 段，逐条列出采纳/拒绝
- 不要静默覆盖 `docker-compose.yml` / `.env.example` / `package.json`
