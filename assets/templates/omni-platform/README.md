# Omni Platform

<div align="center">
  <strong>通用平台项目初始化模板 · 多端拆分 · Docker 部署基线 · 文档与资产分层</strong>
  <br>
  <br>
  <p>用于验证平台型项目母版的新初始化规则，强调前后端与移动端分离、完整 README、统一部署入口以及架构资产落盘。</p>
  <p>适合后续继续派生中后台系统、行业解决方案或企业内部平台。</p>
</div>

第一次接手这个仓库，先看 [START-HERE.md](./START-HERE.md)。

<div align="center">

[简体中文](./README.md) · [English](./docs/README_en.md)

[![License](https://img.shields.io/badge/license-Internal-blue.svg)](#-许可证)
[![Version](https://img.shields.io/badge/version-1.0.0--alpha-informational.svg)](#-版本说明)
[![Status](https://img.shields.io/badge/status-初始化完成-success.svg)](#-项目状态)
[![CI](https://img.shields.io/badge/CI-manual--verified-brightgreen.svg)](#-开发与验证)

</div>

---

## 🗺️ 架构图

先看平台整体分层，再进入前端、移动端、服务端和 Docker 编排细节。

![项目架构图](./assets/platform/architecture/zh-CN/omni-platform-overview.png)

- 图资产目录：`./assets/platform/architecture/`
- 本次架构图提示词留档：`./assets/prompts/architecture-image-prompt-zh-CN.md`

![平台设计基线图](./assets/platform/design/zh-CN/omni-platform-design-baseline.png)

- 设计基线图目录：`./assets/platform/design/`

## 📋 项目概述

`Omni Platform` 是一个面向“平台型项目初始化”的通用模板工程，用于验证新的项目初始化口径是否符合以下要求：多端拆分、README 高还原、视觉资产归档、文档分层、Docker 部署基线。

- 它做什么：提供一个能直接复制派生的新平台型项目骨架。
- 为什么做它：避免每次初始化都重新发明目录结构、部署方式和接手口径。
- 目标用户：需要频繁孵化中后台、管理平台、移动协同项目的研发团队。
- 适用场景：管理后台、行业 SaaS、企业内部运营平台、前后端分离平台工程。
- 它承担什么角色：作为平台型项目初始化模板，沉淀结构规则、部署规则和文档规则。

## 🎯 核心特色

- **多端拆分明确**：根目录直接拆成 `omni-platform-front / omni-platform-mobile / omni-platform-server`，避免把所有代码混成单体工程。
- **README 作为强制入口**：按共享知识库模板生成完整成品，并保留 `START-HERE` 作为首次接手入口。
- **资产与文档分层**：`assets/` 专门存图，`docs/` 专门存需求、设计、架构、测试、部署等文档，职责边界清晰。
- **Docker 基线内置**：根目录预置 `docker-compose.yml`，子项目各自提供 `Dockerfile`，便于本地和开发环境统一编排。
- **适合继续二开**：当前既能做测试模板，也能继续派生真实业务平台项目。
- **根级统一命令**：已经补齐 `pnpm doctor / install:all / build / docker:up / docker:down` 这类母版级统一入口。

## 👀 在线演示 / 效果预览

- 演示地址：`未配置`
- 文档地址：`仓库内 docs/`
- API 文档：`预留为 http://127.0.0.1:7060/docs`
- 视频演示：`未配置`

### 截图预览

![项目架构图](./assets/platform/architecture/zh-CN/omni-platform-overview.png)
![平台设计基线图](./assets/platform/design/zh-CN/omni-platform-design-baseline.png)
![管理端 UI 设计稿](./assets/omni-platform-front/design/zh-CN/front-ui-design-draft.png)
![移动端 UI 设计稿](./assets/omni-platform-mobile/design/zh-CN/mobile-ui-design-draft.png)

- 平台设计基线图已落到 `./assets/platform/design/zh-CN/omni-platform-design-baseline.png`
- 管理端 UI 设计稿已落到 `./assets/omni-platform-front/design/zh-CN/front-ui-design-draft.png`
- 移动端 UI 设计稿已落到 `./assets/omni-platform-mobile/design/zh-CN/mobile-ui-design-draft.png`
- 真实业务派生后，建议继续补业务首页图、核心流程图和关键页面状态图

## 🚦 项目状态

- 当前状态：`初始化完成`
- 版本阶段：`Template Alpha`
- 维护方式：`持续迭代`
- 兼容范围：`macOS / Linux 本地开发，Docker 本地编排，Node 20+`

当前版本用于验证新的平台型项目初始化规则，本身更适合做派生母版，而不是直接原样上线生产。

## 🧩 功能模块

### 管理端模块（omni-platform-front）

- 平台首页、模块导航、状态看板
- 可承接后台管理、运营配置、权限和业务工作台
- 默认通过环境变量对接服务端 API
- 当前已具备可构建的 React + Vite 基础壳

### 移动端模块（omni-platform-mobile）

- H5 / 移动 Web 展示层骨架
- 可承接用户侧首页、消息、我的、轻业务流程
- 与管理端彻底分目录，避免相互污染
- 当前已具备可构建的 React + Vite 移动模板壳

### 服务端模块（omni-platform-server）

- 健康检查、配置读取、API 基础入口
- 可扩展登录鉴权、业务模块、数据库接入和文件服务
- 作为 Docker 编排里的核心 API 服务
- 当前已提供 `/health` 与 `/meta` 默认接口

### 文档与资产模块

- `assets/` 统一存放平台总图和 front / mobile / server 各自的视觉资产
- `docs/` 统一存放需求、设计、架构、测试、部署、接口与交付文档
- `START-HERE.md` 和 `README.md` 作为首次接手入口

## 🛠️ 技术栈

| 层级 | 技术 | 说明 |
|---|---|---|
| 前端 | React + Vite + TypeScript | 管理后台基线 |
| 移动端 | React + Vite + TypeScript | H5 / 移动 Web 基线 |
| 后端 | Node.js + Fastify + TypeScript | API 服务基线 |
| 数据层 | PostgreSQL + Redis | Docker 编排预置依赖 |
| 基础设施 | Docker Compose | 本地和开发环境统一启动 |
| 开发工具 | pnpm workspace / tsx / TypeScript | 构建与开发工具链 |

关键依赖：

- `docker compose`：统一启动数据库、缓存和三端服务。
- `README gate`：保证初始化出来的 README 不是极简空壳。

## 🏗️ 系统架构

### 架构设计

```text
┌────────────────────────────────────────────┐
│              Presentation Layer            │
│  omni-platform-front   omni-platform-mobile│
└────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────┐
│              Application Layer             │
│   REST API / Config / Health / Modules     │
└────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────┐
│                 Domain Layer               │
│   Platform Rules / Business Extensions     │
└────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────┐
│            Infrastructure Layer            │
│ PostgreSQL / Redis / Docker / File Assets  │
└────────────────────────────────────────────┘
```

### 架构说明

- 管理端、移动端和服务端彻底分目录，根目录只负责协调和编排。
- 平台级视觉资产不混放在文档目录，而是统一沉淀在 `assets/`。
- 文档层承载需求、设计、测试、部署与接口说明，便于交付和接手。
- Docker Compose 负责统一串联前端、移动端、后端、数据库和缓存。

## 📁 目录结构

```text
.
├── assets/
├── docs/
├── omni-platform-front/
├── omni-platform-mobile/
├── omni-platform-server/
├── scripts/
├── package.json
├── pnpm-workspace.yaml
├── docker-compose.yml
├── README.md
├── AGENTS.md
└── CLAUDE.md
```

### 目录说明

| 目录 / 文件 | 说明 |
|---|---|
| `assets/` | 根级统一视觉资产仓，按平台总图与各子项目分区管理 |
| `docs/` | 存放需求、设计、架构、测试、部署、接口和过程产物 |
| `omni-platform-front/` | 管理后台工程入口 |
| `omni-platform-mobile/` | 移动端工程入口 |
| `omni-platform-server/` | 服务端工程入口 |
| `package.json` | 根级统一命令入口，避免每次进入子项目执行 |
| `docker-compose.yml` | 根级统一部署编排入口 |
| `START-HERE.md` | 首次接手导航 |

## 🚀 快速开始

### 环境要求

- `Node >= 20`
- `pnpm >= 10`
- `Docker >= 24`
- `Docker Compose`

### 安装依赖

```bash
cd <项目根目录>
pnpm install:all
```

### 配置环境变量

复制示例配置：

```bash
cp .env.example .env
```

关键配置项：

| 变量名 | 是否必填 | 说明 |
|---|---|---|
| `SERVER_PORT` | 是 | 服务端端口 |
| `FRONT_PORT` | 是 | 管理后台端口 |
| `MOBILE_PORT` | 是 | 移动端端口 |
| `POSTGRES_DB` | 是 | PostgreSQL 数据库名 |
| `API_BASE_URL` | 是 | 前端和移动端对接的 API 地址 |

### 启动项目

```bash
docker compose up -d --build
```

如果只本地开发单独启动：

```bash
# 启动后端
cd omni-platform-server && pnpm dev

# 启动管理后台
cd omni-platform-front && pnpm dev

# 启动移动端
cd omni-platform-mobile && pnpm dev
```

### 默认访问地址

- Web：`http://127.0.0.1:7061`
- Mobile：`http://127.0.0.1:7062`
- API：`http://127.0.0.1:7060`

## 🔧 开发指南

### 常用命令

| 命令 | 说明 |
|---|---|
| `pnpm doctor` | 检查 Node、pnpm、Docker、Docker Compose |
| `pnpm install:all` | 安装全部三端依赖 |
| `docker compose up -d --build` | 启动完整本地平台 |
| `docker compose down` | 停止整个平台 |
| `pnpm dev:server` | 启动服务端开发模式 |
| `pnpm dev:front` | 启动管理后台开发模式 |
| `pnpm dev:mobile` | 启动移动端开发模式 |
| `pnpm build` | 构建全部子项目 |

### 关键配置入口

| 配置项 | 文件路径 | 说明 |
|---|---|---|
| 平台端口与地址 | `.env` | 根级统一端口与服务地址 |
| workspace 编排 | `pnpm-workspace.yaml` | 根级统一三端依赖安装入口 |
| Docker 编排 | `docker-compose.yml` | 整个平台部署入口 |
| 架构说明 | `docs/architecture/spec-平台初始化架构说明.md` | 平台分层与边界说明 |
| 部署说明 | `docs/deployment/spec-docker部署说明.md` | Docker 运行方式和挂载说明 |

### 常见改动位置

- 改管理后台优先看 `omni-platform-front/`
- 改移动端优先看 `omni-platform-mobile/`
- 改接口优先看 `omni-platform-server/`
- 改部署优先看 `docker-compose.yml` 和 `docs/deployment/`
- 改项目规则优先看 `README.md`、`AGENTS.md`、`CLAUDE.md`

### 二开建议

- 优先保留根级 `assets/`、`docs/`、Docker 编排和接手文件结构
- 新项目业务名称替换时，同步替换 `*-front / *-mobile / *-server`
- 若未来切到 Java / UniApp 等技术栈，保留目录命名和部署边界，不必强行保留当前实现语言
- 完整派生步骤可直接参考 `docs/documents/spec-平台母版派生说明.md`

### 环境边界

- 允许直接操作：`local`、`dev`
- 禁止直接操作：`test`、`uat`、`prod`
- 当前模板仅面向本地和开发环境初始化验证

## ✅ 开发与验证

### 代码检查

```bash
pnpm build --dir omni-platform-front
pnpm build --dir omni-platform-mobile
pnpm build --dir omni-platform-server
```

### 测试

```bash
当前模板未接入自动化测试，后续派生项目时补齐
```

### 构建

```bash
docker compose build
```

当前已验证：

- 根目录结构已按新平台规则创建
- `README.md / AGENTS.md / CLAUDE.md / assets / docs` 已齐备
- 三端目录已按 `*-front / *-mobile / *-server` 拆分
- Docker Compose 与三端 Dockerfile 已落盘
- 三端工程均已补成可构建最小母版

## 📦 部署说明

### Docker 部署

```bash
docker compose up -d --build
```

### 部署建议

- 本地开发优先使用根目录 `docker-compose.yml`
- 后续真实项目上线时，可在此基础上再拆开发版与部署版 compose 文件
- 若需要日志、构建产物、配置挂载，可在 `docker-compose.yml` 增加 `volumes` 段，并在 `.env` 中收口对应路径与端口

## 📌 版本说明

- 当前版本：`1.0.0-alpha`
- 版本定位：平台型项目初始化模板验证版
- 下一步建议：把该模板继续沉淀为可复用的正式平台母版

## 👤 作者

- 作者：`xyqierkang@gmail.com`
- GitHub：[https://github.com/qierkang](https://github.com/qierkang)

## 📄 许可证

当前项目默认为内部初始化模板，不对外开源；如后续要开放共享，再补正式许可证。
