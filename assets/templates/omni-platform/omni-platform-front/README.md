# Omni Platform Front

<div align="center">
  <strong>通用平台母版管理端 · React + Vite · 后台壳工程 · 对接 omni-platform-server</strong>
  <br>
  <br>
  <p>这是 <code>omni-platform</code> 的管理端子工程，用于承接平台首页、后台导航、工作台、配置页和后续业务模块页面。</p>
  <p>适合继续派生中后台系统、运营平台和行业解决方案管理端。</p>
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

先看整体平台分层，再回到当前管理端在其中承担的角色。

![管理端示意图](../assets/omni-platform-front/screenshots/zh-CN/front-dashboard-concept.png)

![管理端 UI 设计稿](../assets/omni-platform-front/design/zh-CN/front-ui-design-draft.png)

## 📋 项目概述

`Omni Platform Front` 是平台母版中的管理端工程，当前以最小可构建 React + Vite 壳工程存在，为后续后台首页、配置中心、菜单体系、工作台和业务模块提供承载入口。

- 它做什么：承接平台管理端页面、导航、布局、接口联调和后台业务模块。
- 为什么做它：把后台管理端从根工程和移动端彻底拆开，避免多端代码混放。
- 目标用户：需要快速派生后台系统的前端团队和全栈团队。
- 适用场景：中后台、运营平台、管理平台、行业 SaaS 管理端。
- 它承担什么角色：作为平台母版的 Web Admin 前端入口，对接 `omni-platform-server`。

## 🎯 核心特色

- **独立管理端工程**：目录与移动端、服务端完全分离，便于单独开发、构建和部署。
- **母版定位明确**：当前强调“后台壳 + 接手入口 + 二开边界”，而不是塞入演示型假业务。
- **对接服务端简单**：默认只需配置 API 地址即可接入 `omni-platform-server`。
- **构建链路轻量**：基于 `React + Vite + TypeScript`，可快速启动和派生。
- **适合继续扩展**：后续可直接补登录页、首页、菜单、权限、工作台和真实业务模块。

## 👀 在线演示 / 效果预览

- 演示地址：`http://127.0.0.1:7061`
- 文档地址：`../docs/`
- API 文档：`http://127.0.0.1:7060/meta`
- 视频演示：`未配置`

### 截图预览

![项目架构图](../assets/platform/architecture/zh-CN/omni-platform-overview.png)
![管理端示意图](../assets/omni-platform-front/screenshots/zh-CN/front-dashboard-concept.png)
![管理端 UI 设计稿](../assets/omni-platform-front/design/zh-CN/front-ui-design-draft.png)

- 当前示意图已落到 `../assets/omni-platform-front/screenshots/zh-CN/front-dashboard-concept.png`
- 当前 UI 设计稿已落到 `../assets/omni-platform-front/design/zh-CN/front-ui-design-draft.png`

## 🚦 项目状态

- 当前状态：`初始化完成`
- 版本阶段：`Template Alpha`
- 维护方式：`持续迭代`
- 兼容范围：`Node 20+ / pnpm 10+ / 现代浏览器 / Docker 本地编排`

当前版本更适合做派生管理端母版，而不是直接原样上线生产。

## 📌 版本说明

- 当前版本：`1.0.0-alpha`
- 版本定位：`管理端初始化母版`
- 本轮重点：`补齐子工程 README、明确职责边界、保留后续首页与权限扩展入口`
- 后续方向：`继续补首页母版、登录页母版、菜单与权限示例`

## 🧩 功能模块

### 页面壳与布局层

- 承接平台首页、布局框架、页面容器和导航入口
- 适合继续补侧栏、头部栏、标签页和面包屑
- 作为所有后台页面的共同外壳

### 业务页面承载层

- 可承接运营配置、权限、台账、审批、查询和报表页面
- 默认按模块继续拆分 `src/` 内页面和组件
- 与真实业务 API 通过环境变量解耦

### 联调与状态展示层

- 对接 `/health`、`/meta` 等基础接口
- 适合继续补 API 请求封装、错误态和加载态
- 为后续工作台和状态看板提供展示基座

## 🛠️ 技术栈

| 层级 | 技术 | 说明 |
|---|---|---|
| 前端框架 | React 18 | 管理端视图层 |
| 构建工具 | Vite 7 | 本地开发与构建 |
| 语言 | TypeScript 5 | 类型约束 |
| 渲染 | React DOM | 浏览器渲染入口 |
| 部署 | Dockerfile + Nginx 静态托管思路 | 便于容器化交付 |
| 开发工具 | pnpm | 依赖与脚本管理 |

关键依赖：

- `react`：承载组件化后台页面。
- `vite`：保证快速启动与轻量构建。

## 🏗️ 系统架构

### 架构设计

```text
┌────────────────────────────────────────────┐
│                View Layer                  │
│   Pages / Layouts / Navigation / Widgets   │
└────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────┐
│            Interaction Layer               │
│  State / Forms / Requests / Route Guards   │
└────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────┐
│              Integration Layer             │
│       HTTP API / Env Config / Errors       │
└────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────┐
│            Backend Dependency              │
│         omni-platform-server APIs          │
└────────────────────────────────────────────┘
```

### 架构说明

- 当前工程负责管理端展示和交互，不承载服务端逻辑。
- 页面能力通过 API 与 `omni-platform-server` 解耦连接。
- 后续建议把布局、页面、组件、请求层继续分目录收口。
- 视觉规则默认对齐 [DESIGN.md](../docs/design/DESIGN.md)。

## 📁 目录结构

```text
.
├── src/
├── index.html
├── package.json
├── tsconfig.json
├── vite.config.ts
├── Dockerfile
└── README.md
```

### 目录说明

| 目录 / 文件 | 说明 |
|---|---|
| `src/` | 管理端源码入口，后续承接页面、布局、组件和请求封装 |
| `index.html` | Vite 入口 HTML |
| `package.json` | 前端启动、构建、预览命令入口 |
| `vite.config.ts` | Vite 开发与构建配置 |
| `Dockerfile` | 管理端容器化构建入口 |

构建后的 `dist/` 是本地产物，不作为母版源码目录保留。

## 🚀 快速开始

### 环境要求

- `Node >= 20`
- `pnpm >= 10`
- `现代浏览器`
- `可选：Docker >= 24`

### 安装依赖

```bash
cd <项目根目录>/omni-platform-front
pnpm install
```

### 配置环境变量

当前版本默认复用根项目环境变量，重点关注：

| 变量名 | 是否必填 | 说明 |
|---|---|---|
| `API_BASE_URL` | 是 | 管理端请求的服务端地址 |
| `FRONT_PORT` | 是 | 本地或容器内管理端端口 |

### 启动项目

```bash
pnpm dev
```

### 默认访问地址

- Web：`http://127.0.0.1:7061`
- API：`http://127.0.0.1:7060`

## 🔧 开发指南

### 常用命令

| 命令 | 说明 |
|---|---|
| `pnpm dev` | 启动管理端开发服务 |
| `pnpm build` | 构建管理端产物 |
| `pnpm preview` | 本地预览构建结果 |

### 关键配置入口

| 配置项 | 文件路径 | 说明 |
|---|---|---|
| 前端脚本 | `package.json` | 定义开发、构建、预览命令 |
| 构建配置 | `vite.config.ts` | 端口、插件、构建行为 |
| 类型配置 | `tsconfig.json` | TypeScript 编译规则 |
| 容器配置 | `Dockerfile` | 镜像构建入口 |

### 常见改动位置

| 需求类型 | 建议改动位置 |
|---|---|
| 首页 / 工作台 | `src/` 下首页与布局模块 |
| 菜单 / 导航 | `src/` 下导航、布局组件 |
| API 对接 | `src/` 下请求封装层 |
| 页面样式 | `src/` 下页面和组件样式文件 |

## 🧪 开发与验证

当前建议的最小验证顺序：

1. `pnpm build`
2. 浏览器访问 `http://127.0.0.1:7061`
3. 对接 `http://127.0.0.1:7060/meta` 检查联通性

## 🤝 与其他子项目的关系

- 上游母版入口：[`../README.md`](../README.md)
- 设计与交付文档：[`../docs/INDEX.md`](../docs/INDEX.md)
- 服务端依赖：[`../omni-platform-server/README.md`](../omni-platform-server/README.md)
- 移动端同级工程：[`../omni-platform-mobile/README.md`](../omni-platform-mobile/README.md)

## 👤 作者

- 作者：`xyqierkang@gmail.com`
- GitHub：[https://github.com/qierkang](https://github.com/qierkang)

## 📄 许可证

当前项目默认按内部模板仓库使用，许可证口径以根项目为准。
