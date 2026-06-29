# Platform Project Skill — 繁體中文文件

<div align="center">
  <em>一套 SKILL.md 格式的 AI Agent 技能包，為 AI 輔助開發初始化平台專案、升級舊有程式碼庫。</em>
</div>

<div align="center">

[简体中文](../README.md) · **繁體中文** · [English](./README_en.md) · [快速開始](#快速開始) · [常見問題](#常見問題)

</div>

---

## 這是什麼？

`platform-project-skill` 是一套 `SKILL.md` 格式的技能包，供 AI Agent（Claude Code、Codex、Cursor、OpenClaw）使用。涵蓋兩種工作流：

- **新專案**：從內建的 `omni-platform` 母版複製 → 30 秒內產生完整骨架（`README`、`AGENTS.md`、`CLAUDE.md`、`docker-compose.yml`、`docs/`、前後端工程）。完全離線，無需網路。
- **舊專案**：以非侵入方式為任何程式碼庫補上 AI 接手層（`AGENTS.md`、`CLAUDE.md`、`START-HERE.md`），不動業務程式碼、目錄結構或技術棧。

### 為什麼用 SKILL.md？

`SKILL.md` 格式讓 AI Agent 能直接從自然語言發現並呼叫這個技能。你不用記指令——只要告訴 Agent 你的需求：

```
幫我初始化平台專案：path/to/SKILL.md
```

Agent 會讀取 `SKILL.md`，自動判斷路由（`new` / `existing` / `partial`），並執行對應腳本。

---

## 快速開始

### 安裝

```bash
# Codex 使用者
cp -r platform-project-skill ~/.codex/codex-workspace/ai-workspace/skills/

# OpenClaw 使用者
cp -r platform-project-skill ~/.openclaw/skills/
```

### 建立新平台專案

告訴你的 AI Agent：

```
幫我在 /path/to/parent 初始化一個平台專案
Skill: ~/.codex/codex-workspace/ai-workspace/skills/platform-project-skill/SKILL.md
```

或直接執行腳本：

```bash
scripts/create-platform-project.sh my-platform /path/to/parent "My Platform" "我的平台"
```

**30 秒內你會得到：**

```text
my-platform/
├── README.md              ← 已填入專案名、作者、版本
├── AGENTS.md              ← AI Agent 接手說明
├── CLAUDE.md              ← Claude Code 設定
├── START-HERE.md          ← 首次接手導覽
├── docker-compose.yml     ← 多服務編排
├── assets/                ← 架構圖目錄
├── docs/                  ← 需求 / 設計 / 測試文件模板
├── my-platform-front/     ← 前端工程（React + Vite）
├── my-platform-server/    ← 後端工程（含 Docker）
├── my-platform-mobile/    ← 行動端工程
├── scripts/               ← doctor / dev-summary 工具
└── graphify-out/          ← AI 可讀的程式碼知識圖譜基線
```

### 升級舊專案

```bash
# 保守模式：只新增 AGENTS.md、CLAUDE.md、START-HERE.md、升級報告
scripts/upgrade-existing-project.sh /path/to/existing-project

# 預覽所有變更但不寫檔
scripts/upgrade-existing-project.sh /path/to/existing-project --dry-run
```

**升級會新增什麼（以及絕不碰什麼）：**

| 升級新增 | 絕不更動 |
|---|---|
| `AGENTS.md` | 業務程式碼 |
| `CLAUDE.md` | 既有目錄結構 |
| `START-HERE.md` | 技術棧 / 框架 |
| `docs/ai-upgrade/upgrade-report.md` | 設定檔、`.gitignore` |

---

## 核心概念

### 雙路徑路由

同一個技能涵蓋兩種工作流，Agent 自動判斷路由：

| 觸發語 | 路由 | 核心腳本 |
|---|---|---|
| 「初始化平台專案」 | `new` | `scripts/create-platform-project.sh` |
| 「幫舊專案做 AI 升級」 | `existing` | `scripts/upgrade-existing-project.sh` |
| 「只補 README / 加 assets」 | `partial` | `references/` 中對應規則 |
| 不確定走哪條 | 先掃描 | `scripts/inspect-project.sh` |

### 非侵入原則

舊專案升級絕不修改已存在的檔案，只在現有結構之上補 AI 接手層。

### 驗證門禁

每次交付都必須通過 gate，Agent 才能宣稱完成：

```bash
# 1. 腳本語法檢查
for f in scripts/*.sh; do bash -n "$f" && echo "ok: $f"; done

# 2. README 完整性檢查
~/.claude/scripts/readme-gate.py --readme README.md

# 3. 完整基線驗證
scripts/check-project-baseline.sh /path/to/project
```

狀態模型：`scaffold_done → asset_done → validation_done → initialization_done`  
未達 `initialization_done` 前，Agent 不得使用「完成」字眼。

---

## 相容性

| Agent | 支援 | 安裝路徑 |
|---|---|---|
| Claude Code | ✅ | `~/.codex/codex-workspace/ai-workspace/skills/` |
| Codex CLI | ✅ | `~/.codex/codex-workspace/ai-workspace/skills/` |
| Cursor | ✅ | Cursor skills 目錄 |
| OpenClaw | ✅ | `~/.openclaw/skills/` |
| Windsurf | ✅ | Windsurf skills 目錄 |

需求：Bash 4.0+（macOS 內建即滿足）。選用：`image_gen`（產生最終架構圖時需要）。

---

## 常見問題

**升級會動到我的業務程式碼嗎？**  
不會。`upgrade-existing-project.sh` 只建立新檔案，絕不修改、移動或刪除既有檔案。

**架構圖可以用 Mermaid 或 SVG 取代 `image_gen` 嗎？**  
草稿討論可以；README 展示圖不行。最終展示圖必須是由 `image_gen` 產生並經 `register-asset.sh` 註冊的 `.png`。

**哪些 Agent 可以使用這個技能？**  
任何支援 `SKILL.md` 格式的 Agent：Claude Code、Codex、Cursor、OpenClaw、Windsurf。將技能目錄複製到對應路徑後重啟即可。

---

## 參與貢獻

歡迎 Issue 與 PR！詳見[主 README 的貢獻章節](../README.md#參與貢獻)與 [CONTRIBUTING.md](../CONTRIBUTING.md)。

---

## 授權

MIT License © 2026 [qierkang](https://github.com/qierkang)
