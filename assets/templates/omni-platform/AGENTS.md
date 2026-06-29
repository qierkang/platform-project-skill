# Omni Platform — Agents 规则文件

## 项目信息

- **项目名**：Omni Platform
- **中文名**：通用平台项目初始化模板
- **项目根目录**：当前工作树根（以 `git rev-parse --show-toplevel` 为准）
- **项目定位**：用于验证新的平台型项目初始化规则是否满足多端拆分、文档分层、Docker 部署和视觉资产落盘要求。

## 子项目结构

```text
omni-platform-server/    后端服务基线（API / Auth / Health / Config）
omni-platform-front/     管理后台基线（PC Admin）
omni-platform-mobile/    移动端基线（H5 / 移动 Web）
```

## 根目录约束

- `assets/`：存放架构图、设计图、流程图和视觉资产
- `docs/`：存放需求、设计、架构、测试、部署、接口与过程文档
- `README.md`：必须按共享模板生成并通过 gate
- 所有项目级 `README.md` 必须包含作者信息：
  - 作者：`xyqierkang@gmail.com`
  - GitHub：`https://github.com/qierkang`
- `AGENTS.md`：面向 Codex 的项目接手口径
- `CLAUDE.md`：面向 Claude / 通用模型的项目接手口径

## 文档与资产结构

```text
assets/
├── platform/
│   ├── architecture/
│   ├── design/
│   └── flow/
├── omni-platform-front/
│   ├── screenshots/
│   └── design/
├── omni-platform-mobile/
│   ├── screenshots/
│   └── design/
└── omni-platform-server/
    ├── architecture/
    └── api/

docs/
├── requirements/
├── design/
├── architecture/
├── testing/
├── deployment/
├── api/
├── documents/
├── scripts/
└── pages/
```

## Docker 约定

- 根目录统一提供 `docker-compose.yml`
- 各子项目可各自带 `Dockerfile`
- 本地默认通过 `docker compose up -d postgres redis server front mobile` 启动
- 端口统一由根级 `.env` 管理

## 开发规则

1. 平台级配置优先收口到根目录 `.env`、`docker-compose.yml` 和 `docs/deployment/`
2. 业务与工程入口先在 README 和 START-HERE 中解释清楚，再扩代码
3. 架构图、流程图优先生成到 `assets/`，不要散落在 `docs/`
4. 任何新截图、临时文件、验证文件只能放当前项目的 `screenshots/` 和 `tmp/`

## AI 省 Token 接手规则

1. 首次进入项目先读 `AGENTS.md`、`START-HERE.md`、`README.md` 和 `docs/INDEX.md`
2. 不要默认通读整个 `docs/`；按任务类型读取对应子目录
3. 不要读取 `node_modules/`、`dist/`、`graphify-out/cache/`、`tmp/`、`screenshots/`
4. 前端任务优先读 `omni-platform-front/README.md` 和 `omni-platform-front/src/main.tsx`
5. 移动端任务优先读 `omni-platform-mobile/README.md` 和 `omni-platform-mobile/src/main.tsx`
6. 服务端任务优先读 `omni-platform-server/README.md` 和 `omni-platform-server/src/main.ts`
7. 架构问题先读 `graphify-out/GRAPH_REPORT.md`，不要读取 `graphify-out/cache/`

## Assets 规则

1. `assets/` 采用“根级统一资产仓 + 按平台与子项目分区”的方式，不在 `omni-platform-front / mobile / server` 内再重复创建独立 `assets/`
2. 平台总图、总流程图、统一设计规范统一放到：
   - `assets/platform/architecture/`
   - `assets/platform/design/`
   - `assets/platform/flow/`
3. 管理端专属截图、设计稿放到：
   - `assets/omni-platform-front/screenshots/`
   - `assets/omni-platform-front/design/`
4. 移动端专属截图、设计稿放到：
   - `assets/omni-platform-mobile/screenshots/`
   - `assets/omni-platform-mobile/design/`
5. 服务端专属架构图、接口说明图放到：
   - `assets/omni-platform-server/architecture/`
   - `assets/omni-platform-server/api/`
6. 根 README 引用资产时使用 `./assets/...`；子项目 README 引用资产时使用 `../assets/...`
7. 同一张图只保留一份正式版本，避免在多个子项目目录内复制同一图片
8. 资产分层说明以 `assets/README.md` 为准；后续新增图片目录时，先补该说明文件，再补图片与 README 引用
9. README 中用于展示的图片必须直接写成 `![说明](路径)`，不得放入 ```md 代码块；只有“引用示例”才允许使用代码块

## 设计图生成规则

1. 平台母版默认至少保留一张“平台设计基线图”，固定放到 `assets/platform/design/omni-platform-design-baseline.png`
2. 如果存在管理端子项目，默认补一张偏 UI 设计稿风格的管理端图，固定放到 `assets/omni-platform-front/design/front-ui-design-draft.png`
3. 如果存在移动端子项目，默认补一张偏 UI 设计稿风格的移动端图，固定放到 `assets/omni-platform-mobile/design/mobile-ui-design-draft.png`
4. 上述图片必须通过 `image_gen` 生成最终视觉图，不得用 Mermaid、SVG、HTML 截图或本地脚本伪装成最终图片
5. 新增设计图后，必须同步更新 `assets/README.md`、根 README 和对应子项目 README 的引用路径
