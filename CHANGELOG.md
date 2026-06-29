# Changelog

本项目所有重要变更记录于此。格式遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

All notable changes to this project are documented here. Format based on [Keep a Changelog](https://keepachangelog.com/), versioning follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- 双语 README 架构图资产：从 GitHub v0.3.0 恢复 4 张原始中文图，并保留 4 张英文图，按 `assets/architecture/{zh-CN,en}/` 分区登记
- 新项目双语图片契约：7 类必需图片均生成 `zh-CN` 与 `en` 两套，共 14 张；默认中文 README 使用中文图，英文 README 使用英文图
- 项目概述英文 TL;DR 下方新增 Star 引导文案
- 多语言文档：英文 `docs/README_en.md`、繁体中文 `docs/README_zh-tw.md`，支持国际用户与英文 SEO
- GitHub Actions CI 工作流（`.github/workflows/ci.yml`）：脚本语法检查 + README gate
- `LICENSE`（MIT）写入 skill 根目录与 `omni-platform` 母版，新项目自动继承
- `CONTRIBUTING.md` 贡献指南（中英双语）
- GitHub Issue 模板：`bug_report.yml` + `feature_request.yml`
- README 首屏英文标语前置 + keyword meta，新增"与同类方案对比"表格和"参与贡献"章节
- README 徽章新增 CI 状态与 GitHub Stars 动态徽章

### Changed
- `check-project-baseline.sh`：新增 LICENSE 检查，新项目缺失判 FAIL，老项目判 WARN
- README 首屏改为英文标语前置，提升 GitHub 搜索可见性

## [0.3.0] - 2026-06-25

### Added
- 双路径工作流：新项目初始化（`new`）与老项目 AI 升级（`existing`）统一覆盖
- 资产注册校验：`register-asset.sh` + `verify-assets.sh`，检测孤儿图
- README gate 集成到完成门禁，`STATE=initialization_done` 才允许报告完成

## [0.2.0] - 2026-06

### Added
- 老项目升级脚本 `upgrade-existing-project.sh`，落地非侵入式（non-invasive）原则
- `.gitignore`-aware 与语言感知的升级逻辑

## [0.1.0] - 2026-06

### Added
- 新项目初始化脚本 `create-platform-project.sh`
- `omni-platform` 母版内置，离线可用

[Unreleased]: https://github.com/qierkang/platform-project-skill/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/qierkang/platform-project-skill/releases/tag/v0.3.0
[0.2.0]: https://github.com/qierkang/platform-project-skill/releases/tag/v0.2.0
[0.1.0]: https://github.com/qierkang/platform-project-skill/releases/tag/v0.1.0
