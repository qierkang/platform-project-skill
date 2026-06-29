# Docker 部署说明

## 默认方式

```bash
cp .env.example .env
docker compose up -d --build
```

## 编排内容

- PostgreSQL
- Redis
- omni-platform-server
- omni-platform-front
- omni-platform-mobile

## 参考来源

- `docker-compose.yml`（根目录统一编排）
- `omni-platform-server/Dockerfile`（服务端镜像）
- `omni-platform-front/Dockerfile`（管理端镜像）
- `omni-platform-mobile/Dockerfile`（移动端镜像）

## 派生项目建议

- 上线时可在 `docker-compose.yml` 基础上派生 `docker-compose.deploy.yml`，单独承载生产环境差异（domain、TLS、外部存储挂载、远程数据库）
- 持久化目录通过 `volumes:` 段统一收口，避免在多个 service 内重复散落
