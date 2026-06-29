#!/usr/bin/env bash
set -euo pipefail

# 非侵入式老项目 AI 接手层升级
#
# 用法:
#   upgrade-existing-project.sh <project-path> [--with-assets] [--with-platform-docs] [--dry-run]
#
# 默认行为 (保守模式):
#   - 只补 AGENTS.md / CLAUDE.md / START-HERE.md / docs/ai-upgrade/ 升级报告
#   - 不强建 assets/platform/{architecture,design,flow}
#   - 不强建 docs/{requirements,design,...}
#   - 检测 .gitignore, 跳过被 ignore 的目录
#   - 检测 .claude/CLAUDE.md, 已存在则不再写根 CLAUDE.md
#   - 按项目类型 (Node/Java/Go/Python/Rust/Other) 生成差异化 AGENTS.md
#
# 选项:
#   --with-assets         追加 assets/platform/{architecture,design,flow}
#   --with-platform-docs  追加 docs/{requirements,design,...}
#   --dry-run             打印计划，不真正写文件

PROJECT_PATH=""
WITH_ASSETS=0
WITH_PLATFORM_DOCS=0
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-assets) WITH_ASSETS=1; shift ;;
    --with-platform-docs) WITH_PLATFORM_DOCS=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help)
      sed -n '1,30p' "$0"
      exit 0
      ;;
    *)
      if [[ -z "$PROJECT_PATH" ]]; then
        PROJECT_PATH="$1"
      else
        echo "error: unexpected argument: $1" >&2
        exit 2
      fi
      shift
      ;;
  esac
done

if [[ -z "$PROJECT_PATH" ]]; then
  echo "usage: upgrade-existing-project.sh <project-path> [--with-assets] [--with-platform-docs] [--dry-run]" >&2
  exit 2
fi

if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "error: project path not found: $PROJECT_PATH" >&2
  exit 1
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------- inspect ----------
inspect_out="$(bash "$SCRIPT_DIR/inspect-project.sh" "$PROJECT_PATH")"
eval "$inspect_out"   # 注入 HAS_*、PROJECT_TYPE 等

# ---------- 语言/类型识别 ----------
PROJECT_LANG="other"
if [[ "${HAS_PACKAGE_JSON:-0}" -eq 1 ]]; then
  PROJECT_LANG="node"
elif [[ "${HAS_MAVEN:-0}" -eq 1 || "${HAS_GRADLE:-0}" -eq 1 ]]; then
  PROJECT_LANG="java"
elif [[ -f "$PROJECT_PATH/go.mod" ]] || [[ -n "$(find "$PROJECT_PATH" -maxdepth 3 -name 'go.mod' -print -quit 2>/dev/null)" ]]; then
  PROJECT_LANG="go"
elif [[ -f "$PROJECT_PATH/pyproject.toml" || -f "$PROJECT_PATH/requirements.txt" || -f "$PROJECT_PATH/setup.py" ]]; then
  PROJECT_LANG="python"
elif [[ -f "$PROJECT_PATH/Cargo.toml" ]]; then
  PROJECT_LANG="rust"
fi

# ---------- .gitignore 感知 ----------
is_ignored() {
  local target="$1"
  if [[ -d "$PROJECT_PATH/.git" || -f "$PROJECT_PATH/.git" ]]; then
    (cd "$PROJECT_PATH" && git check-ignore --quiet "$target" 2>/dev/null) && return 0
  fi
  return 1
}

# ---------- planning ----------
PLAN=()
plan_add() { PLAN+=("$1"); }

if [[ ! -f "$PROJECT_PATH/AGENTS.md" ]]; then
  plan_add "ADD  AGENTS.md (lang=$PROJECT_LANG)"
fi

if [[ ! -f "$PROJECT_PATH/CLAUDE.md" && ! -f "$PROJECT_PATH/.claude/CLAUDE.md" ]]; then
  plan_add "ADD  CLAUDE.md"
elif [[ -f "$PROJECT_PATH/.claude/CLAUDE.md" && ! -f "$PROJECT_PATH/CLAUDE.md" ]]; then
  plan_add "SKIP CLAUDE.md (.claude/CLAUDE.md already exists)"
fi

if [[ ! -f "$PROJECT_PATH/START-HERE.md" ]]; then
  plan_add "ADD  START-HERE.md"
fi

if ! is_ignored "docs/ai-upgrade"; then
  plan_add "ADD  docs/ai-upgrade/report-老项目AI能力升级.md"
else
  plan_add "SKIP docs/ai-upgrade (gitignored)"
fi

if [[ "$WITH_ASSETS" -eq 1 ]]; then
  if is_ignored "assets"; then
    plan_add "SKIP assets/platform/* (gitignored)"
  else
    plan_add "ADD  assets/platform/{architecture,design,flow}/"
  fi
else
  plan_add "SKIP assets/platform/* (use --with-assets to enable)"
fi

if [[ "$WITH_PLATFORM_DOCS" -eq 1 ]]; then
  if is_ignored "docs"; then
    plan_add "SKIP docs/* (gitignored)"
  else
    plan_add "ADD  docs/{requirements,design,architecture,testing,deployment,api}/"
  fi
else
  plan_add "SKIP docs/* (use --with-platform-docs to enable)"
fi

echo "===== upgrade plan ====="
echo "PROJECT_PATH=$PROJECT_PATH"
echo "PROJECT_TYPE=${PROJECT_TYPE:-unknown}"
echo "PROJECT_LANG=$PROJECT_LANG"
echo "WITH_ASSETS=$WITH_ASSETS"
echo "WITH_PLATFORM_DOCS=$WITH_PLATFORM_DOCS"
for item in "${PLAN[@]}"; do
  echo "  - $item"
done
echo "========================"

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "DRY_RUN=1, no files written."
  exit 0
fi

agents_lang_block() {
  case "$PROJECT_LANG" in
    node)
      cat <<'EOF'
## 语言/技术栈

- Node.js 项目，使用 `pnpm` 或对应包管理器
- 阅读 `package.json` 了解 scripts 和依赖
- 入口可能在 `src/`、`app/`、`pages/` 之一
EOF
      ;;
    java)
      cat <<'EOF'
## 语言/技术栈

- Java 项目，构建系统为 Maven (`pom.xml`) 或 Gradle (`build.gradle`)
- 主代码位于 `src/main/java/`，资源位于 `src/main/resources/`
- 不要在根目录创建无关 `assets/` 目录，资源走 Maven/Gradle 标准约定
EOF
      ;;
    go)
      cat <<'EOF'
## 语言/技术栈

- Go 项目，依赖通过 `go.mod` 管理
- 阅读 `cmd/`、`internal/`、`pkg/` 了解模块布局
- 注意 `assets/` 可能是 `//go:embed` 使用的目录，不要随意写入文件
EOF
      ;;
    python)
      cat <<'EOF'
## 语言/技术栈

- Python 项目，依赖可能用 `pyproject.toml` / `requirements.txt` / `setup.py`
- 包结构通常在 `src/<package>/` 或同名顶层包目录
- 不要在根目录创建无关 `assets/` 目录
EOF
      ;;
    rust)
      cat <<'EOF'
## 语言/技术栈

- Rust 项目，依赖通过 `Cargo.toml` 管理
- 主代码在 `src/`，二进制在 `src/bin/` 或 `src/main.rs`
EOF
      ;;
    *)
      cat <<'EOF'
## 语言/技术栈

- 未识别到主流构建系统，请阅读 README 和根目录文件了解项目结构。
EOF
      ;;
  esac
}

if [[ ! -f "$PROJECT_PATH/AGENTS.md" ]]; then
  {
    cat <<'EOF'
# AI Project Handoff Rules

## First Read

1. README.md
2. START-HERE.md
3. AGENTS.md
4. graphify-out/GRAPH_REPORT.md when available

EOF
    agents_lang_block
    cat <<'EOF'

## Existing Project Boundary

- 保留现有源码结构、构建系统、技术栈、业务命名。
- 不要重命名业务目录、不要替换框架、不要全仓格式化，除非用户显式要求。
- 仅补 AI 接手所需的文档与资产；不改业务行为。

## Assets

- 视觉资产优先放到 `assets/` 根级；若项目已有自己的资产约定，沿用原结构。
- README 展示图必须直接写 `![label](path)`，不能放进 fenced code block。
EOF
  } > "$PROJECT_PATH/AGENTS.md"
  echo "WROTE $PROJECT_PATH/AGENTS.md"
fi

if [[ ! -f "$PROJECT_PATH/CLAUDE.md" && ! -f "$PROJECT_PATH/.claude/CLAUDE.md" ]]; then
  cat > "$PROJECT_PATH/CLAUDE.md" <<'EOF'
# AI Project Handoff (Claude)

本项目已通过 `platform-project-skill` 补齐非侵入式 AI 接手层。

修改代码前请阅读：

1. `README.md`
2. `START-HERE.md`
3. `AGENTS.md`
4. `graphify-out/GRAPH_REPORT.md` (when available)
5. `docs/ai-upgrade/report-老项目AI能力升级.md`

未经用户明确许可，不要重命名业务目录、替换构建系统、改写部署流程，或者全仓格式化。
EOF
  echo "WROTE $PROJECT_PATH/CLAUDE.md"
fi

if [[ ! -f "$PROJECT_PATH/START-HERE.md" ]]; then
  cat > "$PROJECT_PATH/START-HERE.md" <<'EOF'
# Start Here

This is an existing project upgraded with an AI handoff layer.

## Suggested Reading Order

1. README.md
2. AGENTS.md
3. CLAUDE.md (or .claude/CLAUDE.md)
4. docs/ai-upgrade/report-老项目AI能力升级.md
5. graphify-out/GRAPH_REPORT.md (when available)

## Boundary

- Preserve existing source structure, build tools, and business names.
- Refactor only when the user explicitly asks.
EOF
  echo "WROTE $PROJECT_PATH/START-HERE.md"
fi

if ! is_ignored "docs/ai-upgrade"; then
  mkdir -p "$PROJECT_PATH/docs/ai-upgrade"
  REPORT="$PROJECT_PATH/docs/ai-upgrade/report-老项目AI能力升级.md"
  if [[ ! -f "$REPORT" ]]; then
    {
      cat <<EOF
# 老项目 AI 能力升级报告

## Project

- Project path: \`$PROJECT_PATH\`
- Project lang: \`$PROJECT_LANG\`
- Project type: \`${PROJECT_TYPE:-unknown}\`
- Upgrade date: \`$(date +%F)\`

## Added Files

- AGENTS.md (when missing)
- CLAUDE.md (only when no .claude/CLAUDE.md exists)
- START-HERE.md (when missing)
- docs/ai-upgrade/ (this report)
EOF
      [[ "$WITH_ASSETS" -eq 1 ]] && echo "- assets/platform/{architecture,design,flow}/"
      [[ "$WITH_PLATFORM_DOCS" -eq 1 ]] && echo "- docs/{requirements,design,architecture,testing,deployment,api}/"
      cat <<'EOF'

## Intentionally Unchanged

- 源码目录结构
- 构建/打包/部署系统
- 业务模块命名
- 现有 README 业务段落（仅在缺失时新建）

## Risks

- 若项目已有 `assets/` 用作 `//go:embed` 或框架约定路径，本脚本默认不写入；如需视觉资产请显式传 `--with-assets`。
- 若项目目录被 `.gitignore` 忽略，本脚本会跳过对应位置。

## Next Recommendations

- 生成架构图/设计图/流程图 (使用 image_gen)，落到 `assets/` 后再更新 README。
- 评估是否需要 `graphify`，按需运行并落 `graphify-out/GRAPH_REPORT.md`。
- 检查并增强 README（保留既有业务内容）。
EOF
    } > "$REPORT"
    echo "WROTE $REPORT"
  fi
fi

if [[ "$WITH_ASSETS" -eq 1 ]] && ! is_ignored "assets"; then
  mkdir -p \
    "$PROJECT_PATH/assets/platform/architecture" \
    "$PROJECT_PATH/assets/platform/design" \
    "$PROJECT_PATH/assets/platform/flow"
  echo "WROTE $PROJECT_PATH/assets/platform/{architecture,design,flow}/"
fi

if [[ "$WITH_PLATFORM_DOCS" -eq 1 ]] && ! is_ignored "docs"; then
  for sub in requirements design architecture testing deployment api; do
    mkdir -p "$PROJECT_PATH/docs/$sub"
  done
  echo "WROTE $PROJECT_PATH/docs/{requirements,design,architecture,testing,deployment,api}/"
fi

echo "UPGRADED=$PROJECT_PATH"
