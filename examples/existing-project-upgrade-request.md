# Existing Project Upgrade Request Example

User request:

```text
使用 platform-project-skill 帮我升级这个老项目：/path/to/existing-project。只补 AI 接手能力，不要改业务代码。
```

Expected route:

- Load `references/workflow-existing-project.md`
- Load `references/non-invasive-upgrade.md`
- Run `scripts/inspect-project.sh /path/to/existing-project`
- Run `scripts/upgrade-existing-project.sh /path/to/existing-project --dry-run` 先看计划
- 确认后再去掉 `--dry-run` 执行；如需视觉资产追加 `--with-assets`
- Generate upgrade report under `docs/ai-upgrade/` (脚本会自动生成)
- Run `scripts/check-project-baseline.sh --existing /path/to/existing-project`

