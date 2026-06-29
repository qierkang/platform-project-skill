# Known Risks & Watchlist

## Open Risks (按 0.2.0 持续观察)

### R-001 母版 drift
- 母版 (`assets/templates/omni-platform/`) 与外部真实 omni-platform 项目易脱节
- **应对**：每次外部母版变更后必须跑 `scripts/sync-omni-template.sh <source>`，并在 `governance/CHANGELOG.md` 记录
- **检测**：派生新项目时若用户反馈"模板里没有 X"，立即评估是否需要同步

### R-002 graphify hook 在没装 Python 的机器上静默失败
- `.claude/settings.json` 里的 hook 用 `command -v python3 >/dev/null 2>&1 &&` 保护，不会报错但也不会跑 graphify
- **应对**：派生项目的 README 显式提示需要 `python3 + graphify` 才能让 hook 生效

### R-003 老项目的 `assets/` 用作框架约定路径
- Go embed / Java resources / Python 包，根 `assets/` 可能有特殊语义
- **应对**：`upgrade-existing-project.sh` 默认不写 `assets/platform/*`，必须显式 `--with-assets`
- **检测**：升级前看 `.gitignore`、`go.mod`、`pom.xml`，有疑问问用户

### R-004 触发词冲突
- skill description 和"新项目初始化标准"、"项目初始化"、"创建项目"等用户全局规则可能撞车
- **应对**：跑 skill 前显式确认"用 platform-project-skill 还是通用初始化脚本？"

### R-005 PNG 资产体积偏大（4×1.5MB）
- skill 自带的 4 张架构图每次加载都是潜在 token / 网络成本
- **应对**：模型不要主动 Read PNG，只在派生产物里引用路径

### R-006 名称替换误伤
- `omni-platform` 是子串：若用户业务字符串恰好含该 substring，会被一并替换
- **应对**：派生后必跑 `check-project-baseline.sh` 的残留扫描；目前长串 `omni-platform-{front,mobile,server}` 已优先匹配

## Closed Risks (0.2.x 已修)

| ID | 描述 | 修复版本 |
|---|---|---|
| C-101 | scaffold 完成被误报为初始化完成（adaishu-site-platform 实战暴露） | 0.3.0 (状态机 + verify-assets + 报告模板) |
| C-102 | 无 asset-manifest，无法机读判断 image_gen 是否真跑过 | 0.3.0 |
| C-103 | 无模板图 hash 黑名单，"拿占位图蒙混"无法识别 | 0.3.0 |
| C-104 | README ↔ 资产无双向校验，孤儿图和未登记引用都不报错 | 0.3.0 |
| C-105 | check-baseline 输出无机读 STATE 行，模型容易"自由发挥" | 0.3.0 |
| C-106 | workflow 无 Stop Conditions，image_gen 可被静默跳过 | 0.3.0 |

## Closed Risks (0.1.x 已修)

| ID | 描述 | 修复版本 |
|---|---|---|
| C-001 | 母版含 `/Users/qierkang/...` 绝对路径 | 0.2.0 |
| C-002 | `pnpm-lock.yaml` 被 perl 替换破坏 | 0.2.0 (rsync + perl 跳过) |
| C-003 | `POSTGRES_DB=omni_platform` 下划线版从不替换 | 0.2.0 |
| C-004 | graphify hook 写死绝对路径 | 0.2.0 |
| C-005 | 子项目 README 含绝对 cd 路径 | 0.2.0 |
| C-006 | `star-billiards-platform` / `报销台账` 业务残留 | 0.2.0 |
| C-007 | `upgrade-existing-project.sh` 盲建 `assets/platform/*` | 0.2.0 (默认 SKIP) |
| C-008 | `upgrade-existing-project.sh` 与 `.claude/CLAUDE.md` 重复 | 0.2.0 |
| C-009 | `upgrade-existing-project.sh` 不感知 `.gitignore` | 0.2.0 |
| C-010 | `upgrade-existing-project.sh` 对所有语言用 Node 模板 | 0.2.0 |
| C-011 | `check-project-baseline.sh` SIGPIPE 风险 | 0.2.0 (循环+break) |
| C-012 | `sync-omni-template.sh` 无来源校验，`--delete` 可能误删 | 0.2.0 |
| C-013 | SKILL.md 罗列 9 个 references + 嵌入规则，渐进加载形同虚设 | 0.2.0 (削到 32 行 + INDEX) |
| C-014 | 缺 hybrid 路径 references | 0.2.0 (workflow-hybrid.md) |
