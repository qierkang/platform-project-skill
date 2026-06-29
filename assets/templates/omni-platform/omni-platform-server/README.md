# Omni Platform Server

<div align="center">
  <strong>通用平台母版服务端 · Fastify + TypeScript · API 基线 · 对接前端与移动端</strong>
  <br>
  <br>
  <p>这是 <code>omni-platform</code> 的服务端子工程，用于承接平台 API、健康检查、元信息接口和后续业务模块扩展。</p>
  <p>适合继续派生登录鉴权、台账模块、文件服务、数据库接入和业务接口层。</p>
</div>

第一次接手这个子工程，建议先看 [根目录 README.md](../README.md) 和 [docs/INDEX.md](../docs/INDEX.md)。

<div align="center">

[![License](https://img.shields.io/badge/license-Internal-blue.svg)](#-许可证)
[![Version](https://img.shields.io/badge/version-1.0.0--alpha-informational.svg)](#-版本说明)
[![Status](https://img.shields.io/badge/status-初始化完成-success.svg)](#-项目状态)
[![CI](https://img.shields.io/badge/CI-manual--verified-brightgreen.svg)](#-开发与验证)

</div>

---

## 🗺️ 架构图

先看整体平台分层，再理解当前服务端在多端体系中的职责边界。

![项目架构图](../assets/platform/architecture/zh-CN/omni-platform-overview.png)

## 📋 项目概述

`Omni Platform Server` 是平台母版中的服务端工程，当前以最小可运行 Fastify + TypeScript API 壳工程存在，主要提供健康检查、平台元信息和后续业务扩展入口。

- 它做什么：承接 API 服务、配置读取、基础接口和未来业务模块。
- 为什么做它：把服务端逻辑从前端工程中完全拆开，统一平台级 API 边界。
- 目标用户：需要快速派生后端服务的 Node / 全栈团队。
- 适用场景：中后台 API、移动端 API、初始化模板服务端、轻量平台服务。
- 它承担什么角色：作为平台母版的统一 API 服务，对接管理端和移动端。

## 🎯 核心特色

- **最小 API 基线**：当前已内置 `/health` 与 `/meta`，便于联调和编排验证。
- **环境变量驱动**：项目名、版本、端口等元信息可通过环境变量统一带出。
- **多端共享服务**：管理端和移动端默认都依赖当前服务端。
- **扩展入口清楚**：后续可直接继续补登录、权限、数据库、缓存和业务模块。
- **容器化友好**：已纳入根项目 `docker-compose.yml`，适合作为统一 API 容器运行。

## 👀 在线演示 / 效果预览

- 服务地址：`http://127.0.0.1:7060`
- 健康检查：`http://127.0.0.1:7060/health`
- 元信息接口：`http://127.0.0.1:7060/meta`
- 文档地址：`../docs/`

### 接口预览

```bash
curl http://127.0.0.1:7060/health
curl http://127.0.0.1:7060/meta
```

### 架构预览

![服务端架构图](../assets/omni-platform-server/architecture/zh-CN/server-architecture-concept.png)

## 🚦 项目状态

- 当前状态：`初始化完成`
- 版本阶段：`Template Alpha`
- 维护方式：`持续迭代`
- 兼容范围：`Node 20+ / pnpm 10+ / Docker 本地编排`

当前版本更适合做派生服务端母版，而不是直接原样上线生产。

## 📌 版本说明

- 当前版本：`1.0.0-alpha`
- 版本定位：`服务端初始化母版`
- 本轮重点：`补齐子工程 README、固化基础接口、保留后续业务模块扩展入口`
- 后续方向：`继续补登录鉴权、数据库接入、缓存和业务 API 模块`

## 🧩 功能模块

### 基础接口层

- 提供健康检查接口 `/health`
- 提供平台元信息接口 `/meta`
- 为前端和移动端提供最小联调目标

### 配置与运行层

- 从环境变量读取端口、项目名、版本号
- 统一输出当前平台运行元信息
- 便于 Docker 和本地开发共用同一套口径

### 业务扩展层

- 可继续补登录鉴权、租户、字典、台账、审批等业务模块
- 可继续接入 PostgreSQL、Redis、文件服务和第三方 API
- 作为平台 API 的统一承载层

## 🛠️ 技术栈

| 层级 | 技术 | 说明 |
|---|---|---|
| 服务框架 | Fastify 5 | API 服务框架 |
| 语言 | TypeScript 5 | 类型约束 |
| 运行时 | Node.js 20+ | 服务端运行环境 |
| 跨域 | @fastify/cors | 多端联调支持 |
| 环境配置 | dotenv | 加载环境变量 |
| 开发工具 | tsx / pnpm | 本地开发与脚本管理 |

关键依赖：

- `fastify`：承载 API 路由和服务启动。
- `dotenv`：保证服务端可从环境变量读取平台配置。

## 🏗️ 系统架构

### 架构设计

```text
┌────────────────────────────────────────────┐
│               Client Layer                 │
│   omni-platform-front / mobile clients     │
└────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────┐
│                API Layer                   │
│        Routes / Hooks / Middleware         │
└────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────┐
│              Service Layer                 │
│   Config / Health / Meta / Business APIs   │
└────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────┐
│          Infrastructure Layer              │
│   Env / PostgreSQL / Redis / Docker        │
└────────────────────────────────────────────┘
```

### 架构说明

- 当前服务端保持最小路由集，重点验证服务启动、编排和联调入口。
- 前端与移动端统一通过 HTTP 接入当前服务端。
- 后续建议把路由、服务、配置、插件和领域模块继续拆目录。
- 数据库和缓存依赖已在根项目 Compose 中预留。

## 📁 目录结构

```text
.
├── src/
├── package.json
├── tsconfig.json
├── Dockerfile
└── README.md
```

### 目录说明

| 目录 / 文件 | 说明 |
|---|---|
| `src/` | 服务端源码入口，当前包含主启动文件 |
| `package.json` | 服务启动与构建命令入口 |
| `tsconfig.json` | TypeScript 编译配置 |
| `Dockerfile` | 服务端镜像构建入口 |

编译后的 `dist/` 是本地产物，不作为母版源码目录保留。

## 🚀 快速开始

### 环境要求

- `Node >= 20`
- `pnpm >= 10`
- `可选：PostgreSQL / Redis`
- `可选：Docker >= 24`

### 安装依赖

```bash
cd <项目根目录>/omni-platform-server
pnpm install
```

### 配置环境变量

当前版本默认复用根项目环境变量，重点关注：

| 变量名 | 是否必填 | 说明 |
|---|---|---|
| `SERVER_PORT` | 是 | 服务监听端口 |
| `PROJECT_NAME` | 是 | 平台显示名 |
| `PROJECT_SLUG` | 是 | 平台标识 |
| `PROJECT_VERSION` | 是 | 平台版本 |
| `FRONT_PORT` | 是 | 返回给 `/meta` 的管理端端口 |
| `MOBILE_PORT` | 是 | 返回给 `/meta` 的移动端端口 |

### 启动项目

```bash
pnpm dev
```

### 默认访问地址

- API：`http://127.0.0.1:7060`
- Health：`http://127.0.0.1:7060/health`
- Meta：`http://127.0.0.1:7060/meta`

## 🔧 开发指南

### 常用命令

| 命令 | 说明 |
|---|---|
| `pnpm dev` | 启动服务端开发模式 |
| `pnpm build` | 编译服务端 TypeScript |

### 关键配置入口

| 配置项 | 文件路径 | 说明 |
|---|---|---|
| 服务入口 | `src/main.ts` | 定义服务注册与路由 |
| 脚本入口 | `package.json` | 定义开发和构建命令 |
| 类型配置 | `tsconfig.json` | TypeScript 编译规则 |
| 容器配置 | `Dockerfile` | 镜像构建入口 |

### 常见改动位置

| 需求类型 | 建议改动位置 |
|---|---|
| 新增接口 | `src/` 下路由和服务模块 |
| 配置项扩展 | `src/main.ts` 或后续配置模块 |
| 数据库接入 | 新增数据库和仓储层目录 |
| 鉴权与权限 | 新增插件、中间件和认证模块 |

## 🧪 开发与验证

当前建议的最小验证顺序：

1. `pnpm build`
2. `curl http://127.0.0.1:7060/health`
3. `curl http://127.0.0.1:7060/meta`

## 🤝 与其他子项目的关系

- 上游母版入口：[`../README.md`](../README.md)
- 设计与交付文档：[`../docs/INDEX.md`](../docs/INDEX.md)
- 管理端消费者：[`../omni-platform-front/README.md`](../omni-platform-front/README.md)
- 移动端消费者：[`../omni-platform-mobile/README.md`](../omni-platform-mobile/README.md)

## 👤 作者

- 作者：`xyqierkang@gmail.com`
- GitHub：[https://github.com/qierkang](https://github.com/qierkang)

## 📄 许可证

当前项目默认按内部模板仓库使用，许可证口径以根项目为准。
