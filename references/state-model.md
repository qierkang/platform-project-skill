# State Model

平台项目初始化分四个状态，**禁止跨越**。模型在用户面前用"初始化完成"措辞，必须等到 `initialization_done`。

```
scaffold_done   ←  create-platform-project.sh 成功（仅复制 + 改名 + 文本替换，无图片）
asset_done      ←  verify-assets.sh 通过（manifest 全填 + 无模板 hash 复用 + README↔manifest 一致）
validation_done ←  check-project-baseline.sh 通过（含 verify-assets 子检查 + docker compose config -q）
initialization_done = scaffold_done ∧ asset_done ∧ validation_done
```

## 各状态的"必有产物"

### scaffold_done
- `<base>-{front,mobile,server}/` 三端目录存在
- `README.md / AGENTS.md / CLAUDE.md / START-HERE.md / VERSION.md` 已替换为目标项目身份
- `docker-compose.yml / .env.example / package.json` 命名替换完成
- `assets/asset-manifest.json` 模板拷贝完成（generated_at 全为 null）
- `assets/.asset-todo.json` 列出 14 项双语待生成清单（7 类图片 × `zh-CN` / `en`）

### asset_done
- `assets/asset-manifest.json` 的 `required[*]` 每条都 `generated_at != null` 且 `sha256` 实测匹配
- 每张 required 图的 sha256 ≠ `governance/template-image-hashes.json` 任一条目
- 项目内所有 README 引用的本地图都在 manifest 的 `required + extra` 中
- 没有"孤儿图"（required 图未被任何 README 引用）

### validation_done
- `check-project-baseline.sh` 全部 OK（含 verify-assets）
- README gate (`~/.claude/scripts/readme-gate.py`) pass=true
- `docker compose config -q` exit 0
- 无 noise（`.DS_Store / node_modules / dist`，严格模式）

### initialization_done
- 上面三个状态全部达成
- 输出按 `references/completion-report-template.md` 格式

## 退化规则

任何一步失败：
- **不允许** 继续向后推进
- **不允许** 对用户用"完成"措辞
- **必须** 在回复中明确写出当前状态（如 `STATE=asset_failed`）和阻塞原因

## 状态信号

脚本通过 stdout 输出 `STATE=...` 行作为机读信号：
- `scripts/create-platform-project.sh` 末尾输出 `STATE=scaffold_done`
- `scripts/verify-assets.sh` 末尾输出 `STATE=asset_done` 或 `STATE=asset_failed`
- `scripts/check-project-baseline.sh` 末尾输出 `STATE=validation_done` 或 `STATE=validation_failed`
