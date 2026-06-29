# New Project Workflow

> 配套必读：[state-model.md](state-model.md)、[completion-report-template.md](completion-report-template.md)、[assets-rules.md](assets-rules.md)、[name-replacement-rules.md](name-replacement-rules.md)

## Goal

Create a new `*-platform` project that closely follows `assets/templates/omni-platform/`，并通过三段状态机晋升到 `initialization_done`。

## Inputs

- Project Chinese name（**必须** 显式提供，否则 manifest 中文名为占位）
- Project English slug（缺省由用户场景推导，结尾必须 `-platform`）
- Target parent directory
- Optional business domain / port requirements

## Steps

### A. scaffold

1. 创建：`scripts/create-platform-project.sh <slug> <parent> "<Display Name>" "<中文名>"`
2. 校验脚本输出含 `STATE=scaffold_done`
3. 母版占位图已被脚本删除；`assets/asset-manifest.json` 与包含 14 项（7 类 × 2 语言）的 `assets/.asset-todo.json` 已就位

### B. asset（**禁止跳过**）

4. 读 `assets/.asset-todo.json`，按 `image_type + locale` 逐张调用 `image_gen`：
   - 7 类图片全部生成 `zh-CN` 与 `en` 两套，共 14 张
   - 路径统一为 `assets/<scope>/<category>/<locale>/<filename>.png`
   - `zh-CN` 只使用简体中文标签（代码标识符除外）
   - `en` 只使用英文标签
5. 每张图落盘后立即：`scripts/register-asset.sh <project-path> <image-relative-path> [prompt-file]`
6. 跑 `scripts/verify-assets.sh <project-path>`，必须看到 `STATE=asset_done`

### C. README 引用同步

7. 更新默认中文根 `README.md`、`assets/README.md` 与子项目 README，引用 `zh-CN` 图片
8. 更新 `docs/README_en.md`，引用全部对应的 `en` 图片

### D. validation

9. `scripts/check-project-baseline.sh <project-path>` → `STATE=validation_done`
10. `~/.claude/scripts/readme-gate.py --readme <README.md>`（根 + 三个子项目各一次）
11. `cd <project> && docker compose config -q`

### E. report

12. 按 [completion-report-template.md](completion-report-template.md) 输出最终回复

## Stop Conditions（**任何一个触发都不能继续宣称完成**）

| 触发条件 | 状态 | 动作 |
|---|---|---|
| 任一 image_gen 失败或被跳过 | `asset_failed` | 不允许进入 step 9；回复明确列出未生成的 image_type |
| `verify-assets.sh` 报 hash 命中模板黑名单 | `asset_failed` | 该图必须重新 image_gen |
| `verify-assets.sh` 报"孤儿图" | `asset_failed`（warn 升级为 fail） | 必须把图加进至少一个 README，或从 manifest 中剔除 |
| `check-project-baseline.sh` 任一 FAIL | `validation_failed` | 修复后重跑 |
| docker compose config 非零 | `validation_failed` | 修复 docker-compose.yml |
| README gate `pass:false` | `validation_failed` | 修复 README |

## Output Contract

最终产物：

- 根 `README.md / AGENTS.md / CLAUDE.md / START-HERE.md / VERSION.md / LICENSE`（`LICENSE` 随 omni-platform 母版自带 MIT，缺失会被 `check-project-baseline.sh` 判 FAIL）
- `assets/asset-manifest.json`（required 全部 generated_at != null）
- `assets/.asset-todo.json`（可选保留作为审计痕迹，或在 initialization_done 后删除）
- `<base>-front / <base>-mobile / <base>-server`
- `docker-compose.yml`、`docs/`
- `graphify-out/GRAPH_REPORT.md`（实际跑过 graphify 时）

## Important Limits

- Do not create a new structure from memory when the bundled template exists.
- Do not leave visible `omni-platform` residue unless the project itself is still named `omni-platform`.
- Do not place README display images in fenced code blocks.
- Do not generate final images with Mermaid/SVG/HTML as substitutes for `image_gen`.
- Do not write `initialization_done` 在用户面前，除非 verify-assets + check-baseline + readme-gate + docker compose 四项都 PASS。
