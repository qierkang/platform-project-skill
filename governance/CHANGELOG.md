# Changelog

## 0.3.0

资产强制校验版本。修复 adaishu-site-platform 实战暴露的"scaffold 误报为初始化完成"问题。

### 新增

- **状态机** [references/state-model.md](../references/state-model.md)：scaffold_done < asset_done < validation_done < initialization_done
- **完成报告模板** [references/completion-report-template.md](../references/completion-report-template.md)：禁止"完成"措辞滥用
- **资产登记** [scripts/register-asset.sh](../scripts/register-asset.sh) + [assets/templates/omni-platform/assets/asset-manifest.json](../assets/templates/omni-platform/assets/asset-manifest.json)
- **资产校验** [scripts/verify-assets.sh](../scripts/verify-assets.sh)：B+C+D+E+F 五道校验（生成检查、hash 一致、模板黑名单、README↔manifest 双向一致、孤儿图）
- **模板图 hash 注册表** [governance/template-image-hashes.json](template-image-hashes.json)：7 条模板图 sha256，sync-omni-template.sh 自动刷新

### 改造

- `scripts/create-platform-project.sh`:
  - 派生后**删除母版自带 PNG**（强制 image_gen 重新生成）
  - 落 `.asset-todo.json` 待办清单（7 张图）
  - 注入项目专属 asset-manifest.json（占位符替换）
  - 输出 `STATE=scaffold_done` + 显式 WARN "scaffold 完成 ≠ 初始化完成"
- `scripts/check-project-baseline.sh`:
  - 集成 verify-assets.sh（strict 模式必跑，existing 模式降级为 WARN）
  - 末尾输出 `STATE=validation_done` 或 `STATE=validation_failed`
- `scripts/sync-omni-template.sh`:
  - sync 后自动重算 `governance/template-image-hashes.json`
- `SKILL.md` (0.2.0 → 0.3.0):
  - 加 **State Model** 段（硬约束）
  - 加 **Reporting Gate** 段（强制按模板回复）
  - 加 register-asset 调用要求
- `references/workflow-new-project.md`：
  - 拆 A-scaffold / B-asset / C-readme / D-validation / E-report 五阶段
  - 加 Stop Conditions 表格（任一触发禁止进入下一阶段）
- `references/assets-rules.md`：
  - Image Generation Gate 升级为硬规则（5 条）
- `references/INDEX.md`：
  - 新增 "State & Reporting" 段

### 真机回归（8 场景全过）

1. ✅ scaffold → STATE=scaffold_done，PNG 已删除，manifest+todo 就位
2. ✅ 未生成图 verify → 7 张全 FAIL B + STATE=asset_failed
3. ✅ 拿模板图蒙混 → FAIL D 占位图复用（hash 命中黑名单）
4. ✅ 生成 7 张项目专属图 + 注册 → STATE=asset_done
5. ✅ 完整 baseline → STATE=validation_done
6. ✅ extra bucket 孤儿图 → 静默（按设计）
7. ✅ README typo 引用未登记图 → FAIL E
8. ✅ existing 模式无 manifest → WARN 降级，不卡死

## 0.2.0

生产级硬化版本。覆盖 14 项 P0/P1 修复，详见 [RISKS.md](RISKS.md) 的 Closed Risks 段。

- **模板清理**：清除母版所有 `/Users/qierkang/...` 绝对路径、`star-billiards-platform` / `报销台账` 业务残留
- **graphify hook**：改为 `${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel || pwd)}`，不再写死绝对路径，且在无 python3 环境下静默退化
- **create 脚本**：
  - 新增 `<display-name>` `<chinese-name>` 可选参数（避免把 `Omni Platform` 压成 kebab-case）
  - 新增 `omni_platform` 下划线替换（解决多项目共享同一 PostgreSQL 数据库名）
  - rsync + perl 跳过 `pnpm-lock.yaml / yarn.lock / package-lock.json` 以及更多二进制后缀
  - 派生后重写 `VERSION.md` 与 `graphify-out/GRAPH_REPORT.md` 占位
  - 增加 slug 合法性校验（lowercase kebab-case）
- **upgrade 脚本**：
  - 必跑 `inspect-project.sh`，按 Node/Java/Go/Python/Rust 生成差异化 AGENTS.md
  - 默认不再创建 `assets/platform/*` 与 `docs/*`，需显式 `--with-assets` / `--with-platform-docs`
  - `.gitignore` 感知（`git check-ignore`），ignored 路径跳过
  - 已存在 `.claude/CLAUDE.md` 时不再写根 `CLAUDE.md`
  - 新增 `--dry-run`
- **baseline 脚本**：
  - 修 `find | head` 的 SIGPIPE 兼容性问题
  - 增加"模板源残留"扫描（绝对路径 + 业务名）
- **sync 脚本**：来源结构校验，缺三件套时拒绝 `--delete`；记录到 CHANGELOG
- **SKILL.md**：削到 32 行，规则下沉，新增 `references/INDEX.md`
- **新增 references/workflow-hybrid.md**：补齐基座派生路径
- **examples/snapshot-demo-platform.md**：派生 demo-platform 的真机回归证据
- **governance/RISKS.md**：登记 Open Risks 与 Closed Risks

## 0.1.0-alpha

- Created `platform-project-skill`.
- Added dual workflow for new platform projects and existing project AI upgrades.
- Bundled `omni-platform` as the official mother template.
- Added architecture assets, references, scripts, examples, and governance files.
- Fixed new-project creation after real test:
  - root remains `<base>-platform`
  - subprojects become `<base>-front / <base>-mobile / <base>-server`
  - assets subfolders are renamed with the same base
  - platform overview and design baseline image files are renamed with the project slug
  - root-level `screenshots/` is excluded, but `assets/*/screenshots/` is preserved
  - baseline checker now verifies README image paths exist
- Fixed existing-project validation after testing `reimburseflow`:
  - added `--existing` mode to avoid failing on pre-existing `node_modules`, `dist`, or `.DS_Store`
  - accepted `.claude/CLAUDE.md` as a valid Claude handoff file
  - upgraded existing-project script to create `assets/README.md`
  - upgraded existing-project report with project type, detected stack, and scanned scope
