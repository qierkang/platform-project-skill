# omni-platform 字典配置

## 字典类型清单

| 字典类型 | 说明 | 当前状态 |
|---|---|---|
| `platform_stage` | 平台交付阶段 | 建议保留 |
| `platform_app_type` | 子项目类型 | 建议保留 |
| `platform_check_status` | 验证状态 | 建议保留 |

## 字典详情

### platform_stage

| 值 | 名称 |
|---|---|
| `requirement` | 需求 |
| `design` | 设计 |
| `development` | 开发 |
| `testing` | 测试 |
| `release` | 发布 |

### platform_app_type

| 值 | 名称 |
|---|---|
| `front` | 管理端 |
| `mobile` | 移动端 |
| `server` | 服务端 |

### platform_check_status

| 值 | 名称 |
|---|---|
| `todo` | 待处理 |
| `in_progress` | 进行中 |
| `done` | 已完成 |
| `blocked` | 阻塞 |

## 执行说明

- 本文件是字典配置模板，不直接执行。
- 派生真实项目时，优先把业务字典追加到本文件，再生成 SQL 或初始化脚本。
