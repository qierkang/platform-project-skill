# 平台初始化架构说明

## 目标

本模板用于验证平台型项目初始化规则，重点不是业务实现，而是结构、资产、文档、部署和接手入口是否一次到位。

## 分层

- 表现层：`omni-platform-front`、`omni-platform-mobile`
- 应用层：`omni-platform-server`
- 基础设施层：`docker-compose.yml` 中的 PostgreSQL、Redis
- 资产层：`assets/platform/*` 与 `assets/omni-platform-front|mobile|server/*`
- 文档层：`docs/*`

## 关键边界

- 视觉资产只进 `assets/`
- 文档只进 `docs/`
- 部署基线只在根目录统一编排
- 多端代码不混放
