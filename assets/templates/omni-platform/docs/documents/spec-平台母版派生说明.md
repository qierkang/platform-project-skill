# 平台母版派生说明

## 1. 适用对象

- 中后台平台
- SaaS 管理系统
- 行业解决方案平台
- 前后端分离且需要移动端协同的项目

## 2. 派生时必须替换的内容

- 项目目录名：`omni-platform`
- 三端目录名：
  - `omni-platform-front`
  - `omni-platform-mobile`
  - `omni-platform-server`
- README 中的项目名、端口、定位、模块描述
- `.env.example` 中的项目变量与数据库名
- Docker Compose 中的 service name、container name、volume name

## 3. 默认保留的母版能力

- 根目录 `assets/` 与 `docs/` 分层
- 根目录 `README.md / AGENTS.md / CLAUDE.md / START-HERE.md`
- 根目录 `docker-compose.yml`
- 根目录脚本：`doctor / install:all / build / docker:up / docker:down`

## 4. 默认建议的派生顺序

1. 复制母版目录
2. 替换项目名与三端目录名
3. 改 README、AGENTS、CLAUDE
4. 改 `.env.example` 与 `docker-compose.yml`
5. 在 `docs/requirements/` 补真实需求
6. 在 `assets/platform/architecture/` 补新的业务架构总图，并按子项目补 `assets/<子项目名>/...` 专属图片
