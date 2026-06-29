# START HERE

## AI 最小接手顺序

1. `AGENTS.md`
2. `README.md`
3. `docs/INDEX.md`
4. `docs/documents/spec-平台母版派生说明.md`
5. 按任务进入 `omni-platform-front/`、`omni-platform-mobile/` 或 `omni-platform-server/`

## 什么时候读完整 docs

- 写需求：读 `docs/requirements/`
- 做 UI：读 `docs/design/DESIGN.md` 和 `docs/design/UI交互设计规范.md`
- 做后端：读 `docs/design/技术方案.md`、`docs/api/`、`omni-platform-server/README.md`
- 做部署：读 `docs/deployment/` 和 `docker-compose.yml`
- 做验收：读 `docs/testing/`、`docs/control/`、`docs/release/`

## 这个项目验证什么

- 平台型项目是否按 `*-platform` 命名
- 根目录是否同时具备 `README.md / AGENTS.md / CLAUDE.md / assets / docs`
- 是否采用 `*-front / *-mobile / *-server` 三端拆分
- 是否提供 Docker 部署基线
- 是否把架构图、设计图、流程图沉淀到 `assets/`
- 是否让 AI 先读短入口，再按任务读取对应文档，避免一次性吞完整 docs

## 推荐命令

- 环境检查：`pnpm doctor`
- 安装全部依赖：`pnpm install:all`
- 构建全部子项目：`pnpm build`
- Docker 启动：`pnpm docker:up`
