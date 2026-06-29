# Completion Report Template

模型在向用户报告"初始化完成"前，**必须** 用以下结构输出（不允许省略任何段，不允许编造数据）。

## 模板

```markdown
## 初始化完成报告 — <project-slug>

### 1. Scaffold (STATE=scaffold_done)
- 派生路径：<absolute-path>
- 命名替换：slug=<slug> / display=<display-name> / chinese=<中文名>
- 三端目录：<base>-front, <base>-mobile, <base>-server

### 2. 资产生成 (STATE=asset_done)
| image_type | path | sha256 (前12位) | generated_at | generated_by |
|---|---|---|---|---|
| platform-architecture | … | … | … | image_gen |
| platform-design-baseline | … | … | … | image_gen |
| front-ui-draft | … | … | … | image_gen |
| mobile-ui-draft | … | … | … | image_gen |
| server-architecture | … | … | … | image_gen |
- 已校验：全部 ≠ 母版 hash ✅
- README ↔ manifest 双向一致 ✅
- 无孤儿图 ✅

### 3. README 引用更新
- 根 README：<n> 处图片引用
- 子项目 README：<n>(front) / <n>(mobile) / <n>(server)

### 4. 校验 (STATE=validation_done)
- verify-assets.sh        → STATE=asset_done
- check-project-baseline  → STATE=validation_done
- readme-gate.py          → pass=true
- docker compose config   → exit 0

### 5. 未完成项 / 已知风险
- 无 / <逐条列出>

### 6. 最终状态
- STATE=initialization_done ✅
```

## 触发规则

- 任意一个 `STATE=*_failed` 出现 → 回复改为"阶段性进展报告"，不能用"完成"措辞
- 表格里任意一行的 `generated_by` 不是 `image_gen` → 必须在第 5 段显式说明原因
- 任意"未完成项"非空 → 必须在第 6 段把状态改为 `STATE=partial_done` 而不是 `initialization_done`

## 反模式（禁止）

- ❌ 不出表格，只写"已生成 5 张图"
- ❌ 表格里 sha256 列填"已生成"等文字
- ❌ 校验段写"已通过"但不附 STATE 行
- ❌ 用"基本完成 / 大致完成"等模糊措辞替代 STATE
