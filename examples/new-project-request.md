# New Project Request Example

User request:

```text
使用 platform-project-skill 初始化一个新的 expense-ledger 平台项目，项目名叫 expense-ledger-platform，放到 /path/to/solutions/expense-ledger，中文名"费用台账平台"。
```

Expected route:

- Load `references/workflow-new-project.md`
- Run `scripts/create-platform-project.sh expense-ledger-platform /path/to/solutions/expense-ledger "Expense Ledger Platform" "费用台账平台"`
- 派生后跑 `pnpm install` 重建 lock
- Generate final project images with `image_gen`
- Run `scripts/check-project-baseline.sh /path/to/solutions/expense-ledger/expense-ledger-platform`
- Run README gate on root and subproject READMEs

