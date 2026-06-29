# Omni Platform — Claude 规则文件

## 项目信息

- **项目名**：Omni Platform（通用平台项目初始化模板）
- **项目根目录**：当前工作树根（以 `git rev-parse --show-toplevel` 为准）
- **用途**：验证平台型项目母版的新初始化规则

## 项目结构

```text
omni-platform-server/    服务端
omni-platform-front/     管理后台
omni-platform-mobile/    移动端
assets/                  架构图、设计图、流程图
docs/                    需求、设计、架构、测试、部署、接口、交付文档
```

## 启动与部署

- 根目录 `docker-compose.yml` 负责统一编排
- 子项目 `Dockerfile` 负责各自构建
- 本项目默认只面向 `local / dev` 场景验证

## 首次接手建议

1. 先看 `START-HERE.md`
2. 再看 `README.md`
3. 再看 `docs/INDEX.md`
4. 按任务进入三个子项目目录，不要默认通读全部 docs
