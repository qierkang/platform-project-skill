# Contributing to Platform Project Skill

感谢你愿意为这个项目贡献！无论是 Bug 报告、功能建议、文档改进还是脚本优化，都非常欢迎。

Thanks for your interest in contributing! Bug reports, feature requests, documentation improvements, and script optimizations are all welcome. **You may contribute in either English or Chinese.**

---

## 贡献方式 / Ways to Contribute

### 1. 报告 Bug / Report a Bug

提 Issue 前请附上：

- `scripts/inspect-project.sh <path>` 的输出
- 最小复现步骤
- 你的环境：操作系统、Bash 版本（`bash --version`）、使用的 AI Agent（Claude Code / Codex / Cursor）

When filing a bug, please include the output of `scripts/inspect-project.sh`, minimal reproduction steps, and your environment (OS, Bash version, AI agent).

### 2. 功能建议 / Feature Request

先开 Issue 讨论方向，确认可行后再提 PR，避免无效劳动。

Please open an issue to discuss the direction first before submitting a large PR.

### 3. 提交代码 / Submit Code

```bash
# 1. Fork 并克隆
git clone https://github.com/<your-name>/platform-project-skill.git
cd platform-project-skill

# 2. 创建分支
git checkout -b fix/your-fix-name

# 3. 修改后本地验证（必须全绿）
for f in scripts/*.sh; do bash -n "$f" && echo "ok: $f"; done
~/.claude/scripts/readme-gate.py --readme README.md
scripts/check-project-baseline.sh .

# 4. 提交并推送
git commit -m "fix: 描述你的修改"
git push -u origin fix/your-fix-name
```

---

## 提交前检查清单 / Pre-PR Checklist

提 PR 前请确认以下全部通过 —— CI 也会自动验证这些：

- [ ] 所有脚本通过 `bash -n <script>` 语法校验
- [ ] README 通过 `~/.claude/scripts/readme-gate.py --readme README.md`（`pass: true`）
- [ ] 没有引入 `.DS_Store` / `node_modules` / `dist` 等噪音文件
- [ ] README 展示图用 `![说明](路径)` 直接引用，不放进代码块
- [ ] 修改母版 `assets/templates/omni-platform/` 时，走 `sync-omni-template.sh`，不手动编辑
- [ ] 提交信息遵循 [Conventional Commits](https://www.conventionalcommits.org/)：`feat:` / `fix:` / `docs:` / `refactor:` / `chore:`

---

## 代码规范 / Code Standards

- **脚本**：每个 Bash 脚本保持单一职责，可独立调用；改完必须过 `bash -n`
- **规则文档**：详细规则放 `references/`，`SKILL.md` 保持极简，只写触发条件和路由
- **非侵入原则**：老项目升级逻辑绝不能修改、移动或删除用户的已有文件
- **母版唯一来源**：新项目结构只能来自 `omni-platform` 母版，禁止从记忆重建

---

## 行为准则 / Code of Conduct

请保持友善和尊重。我们欢迎所有水平的贡献者。

Please be kind and respectful. We welcome contributors of all skill levels.

---

## 需要帮助？ / Need Help?

- 提 [Issue](https://github.com/qierkang/platform-project-skill/issues)
- Email: xyqierkang@gmail.com
