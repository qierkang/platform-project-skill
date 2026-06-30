# GitHub Publish Rules

发布一个 skill / 项目到 GitHub 公开仓库时的完整规范。涵盖发布前安全审查、社区基线文件、social preview 设计、缓存绕过、仓库元数据。
README 内容规则见 [readme-rules.md](readme-rules.md)。

## 1. Release-safety scan (发布前必做)

公开前必须扫描，任一命中即阻断：

- 无硬编码密钥 / token：`grep -rInE "(api[_-]?key|secret|password|token|bearer)[\"' ]*[:=]"`，排除 `example/placeholder/your-`
- 无真实 `.env`（只能有 `.env.example`，且其中是占位默认值如 `postgres/postgres`）
- 无噪音文件：`.DS_Store` / `node_modules` / `dist` / `__pycache__`
- 无内部业务名 / 绝对用户路径泄露到代码与文档（governance/ 清理记录里作为"被检测示例"出现属正常）
- 顶层必须有 `.gitignore`

## 2. Open-source baseline files (社区健康度)

新仓库必须具备，缺失会拉低 GitHub Community Standards 与 Trending 权重：

- `LICENSE`（MIT 默认，随 omni-platform 母版自带）
- `.gitignore`
- `CONTRIBUTING.md`（本地验证步骤 + pre-PR checklist）
- `CHANGELOG.md`（Keep a Changelog + SemVer）
- `.github/workflows/ci.yml`（至少跑 `bash -n` + README gate）
- `.github/ISSUE_TEMPLATE/`（bug + feature）
- 默认根 `README.md` 使用简体中文；必须提供 `docs/README_en.md` 并在 nav 交叉链接。中文 README 引用 `zh-CN` 图片，英文 README 引用 `en` 图片；`docs/README_zh-tw.md` 可选。

## 3. Social preview image (品牌卡片)

- 标准尺寸 `1280×640`（2:1）。**不要为消除空白而裁掉比例** —— GitHub 卡片按 2:1 显示。
- 产出两份：`assets/social-preview.svg`（矢量，嵌 README hero）+ `assets/social-preview.png`（GitHub Settings 上传只收 PNG/JPG，不收 SVG）。
- `assets/social-preview.png` 必须小于 1 MiB (`1048576` bytes)。超过该限制时 GitHub Settings 可能上传失败，必须压缩或重新生成后再发布。
- 设计：固定深色品牌卡片，全 hardcoded hex（不随明暗模式反转）；坐标精确锁死，文字用绝对 x/y 定位，避免"被容器缩放后错位"。
- 内容充实优先于留白填充：右侧空白用"一条命令 → 产出结构"的终端输出叙事填充（命令 + ✓ 生成的关键文件/目录），比堆装饰更有说服力。
- 渲染验证（本地无 rsvg/cairosvg 时用 Chrome headless）：

```bash
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
"$CHROME" --headless=new --disable-gpu --hide-scrollbars \
  --force-device-scale-factor=2 --window-size=1280,640 \
  --screenshot=/tmp/verify.png "file:///path/to/wrap.html"   # wrap.html 用 <img src=svg> 固定 1280x640
```

- social preview 在 GitHub 站内**看不到**，只在外部平台（微信/Slack/Twitter/飞书）分享链接时显示。要在仓库页直接看到图，必须把 SVG 嵌进 README hero。

## 4. GitHub image cache busting (关键陷阱)

GitHub 通过 camo CDN 缓存 README 里的图片。更新图片源文件后，页面仍显示旧图。
**解法**：给图片 URL 加版本查询参数，每次更新递增：

```html
<img src="./assets/social-preview.svg?v=3" ...>
```

`?v=2 → ?v=3 → ...` 让 camo 当成新 URL 重新拉取，无需重命名文件。

## 5. Repo metadata (发现性)

发布后用 `gh` 设置，提升 GitHub Explore / Trending 命中：

```bash
# Topics（Explore 分类的最强信号）
gh repo edit <owner>/<repo> --add-topic claude-code --add-topic ai-agent \
  --add-topic skill --add-topic scaffold --add-topic codex --add-topic cursor \
  --add-topic developer-tools --add-topic project-template

# About 描述 + Homepage（About 下方显示带链接图标的地址）
gh repo edit <owner>/<repo> --description "<一句话英文价值主张>" \
  --homepage "https://github.com/<owner>/<repo>"
```

## 6. Isolated publish (隔离发布，绝不污染父仓库)

skill 常嵌在更大的工作区仓库内。发布成独立公开仓库时，**禁止**在 skill 目录直接 `git init`：

```bash
# 复制到独立 staging（排除 .git/噪音）再发布
STAGING="$(mktemp -d)"
rsync -a --exclude '.git' --exclude '.DS_Store' --exclude 'node_modules' --exclude 'dist' \
  "<skill-dir>/" "$STAGING/"
cd "$STAGING" && git init -b main && git add -A && git commit -m "feat: initial public release"
gh repo create <owner>/<repo> --public --source=. --push
```

## 7. Workflow scope 限制

OAuth token 缺 `workflow` scope 时，含 `.github/workflows/*.yml` 的 push 会被拒。
两种处理：先移除 workflow 文件 push 主体 → 让用户 `gh auth refresh -h github.com -s workflow` 授权后单独补；或一开始就引导授权。

## 8. 更新远端单文件 (无需整仓 clone)

只改一两个文件时，用 `gh api` 直接 PUT 更新（文本/二进制都用 base64）：

```bash
SHA="$(gh api repos/<owner>/<repo>/contents/README.md --jq .sha)"
gh api repos/<owner>/<repo>/contents/README.md -X PUT \
  -f message="docs: ..." -f content="$(base64 -i README.md)" -f sha="$SHA"
```

多文件或要保持 git 历史连续时，clone 远端 → 复制改动 → commit → push。

## 9. Star History 两阶段发布（新仓库强制）

新仓库在首次推送前还不存在，README 不得预先伪造 Star History 链接。必须分两次提交：

1. 完成 README、双语图片、社区文件、安全扫描和 baseline 校验。
2. 创建公开仓库并首次推送。
3. 设置 About description、Topics、Homepage。
4. 确认仓库可公开访问后执行：

```bash
scripts/add-star-history.sh <project-path> <owner>/<repo>
```

5. 重新执行根 README、英文 README、资产和 baseline 校验。
6. 单独提交并推送：

```bash
git add README.md docs/README_en.md
git commit -m "docs: add Star History"
git push
```

已有公开仓库可在首次文档提交中直接保留真实 Star History；脚本仍应执行一次以校验并统一链接格式。
