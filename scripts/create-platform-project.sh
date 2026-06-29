#!/usr/bin/env bash
set -euo pipefail

# 用法:
#   create-platform-project.sh <project-slug> <target-parent> [display-name] [chinese-name]
#
# 例:
#   create-platform-project.sh my-platform /path/to/parent "My Platform" "我的平台"
#
# 派生后产物:
#   <target-parent>/<project-slug>/
#       ├── <base>-front/
#       ├── <base>-mobile/
#       ├── <base>-server/
#       └── ...

PROJECT_SLUG="${1:-}"
TARGET_PARENT="${2:-}"
DISPLAY_NAME_ARG="${3:-}"
CHINESE_NAME_ARG="${4:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$SKILL_ROOT/assets/templates/omni-platform"

if [[ -z "$PROJECT_SLUG" || -z "$TARGET_PARENT" ]]; then
  echo "usage: create-platform-project.sh <project-slug> <target-parent> [display-name] [chinese-name]" >&2
  exit 2
fi

if [[ "$PROJECT_SLUG" != *-platform ]]; then
  echo "error: project slug should end with -platform: $PROJECT_SLUG" >&2
  exit 2
fi

if [[ ! "$PROJECT_SLUG" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "error: project slug must be lowercase kebab-case: $PROJECT_SLUG" >&2
  exit 2
fi

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  echo "error: template not found: $TEMPLATE_DIR" >&2
  exit 1
fi

mkdir -p "$TARGET_PARENT"
TARGET_DIR="$(cd "$TARGET_PARENT" && pwd)/$PROJECT_SLUG"

if [[ -e "$TARGET_DIR" && -n "$(find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
  echo "error: target directory exists and is not empty: $TARGET_DIR" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
rsync -a --delete \
  --exclude ".DS_Store" \
  --exclude "node_modules" \
  --exclude "dist" \
  --exclude "tmp" \
  --exclude "/screenshots" \
  --exclude "pnpm-lock.yaml" \
  --exclude "yarn.lock" \
  --exclude "package-lock.json" \
  "$TEMPLATE_DIR/" "$TARGET_DIR/"

BASE_SLUG="${PROJECT_SLUG%-platform}"
BASE_SLUG_UNDERSCORE="$(printf '%s' "$BASE_SLUG" | tr '-' '_')"
SLUG_UNDERSCORE="${BASE_SLUG_UNDERSCORE}_platform"

front_slug="${BASE_SLUG}-front"
mobile_slug="${BASE_SLUG}-mobile"
server_slug="${BASE_SLUG}-server"

# 显示名: 缺省时把 base slug 转成 Title Case
if [[ -z "$DISPLAY_NAME_ARG" ]]; then
  DISPLAY_NAME="$(printf '%s' "$BASE_SLUG" | awk -F'-' '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) substr($i,2)} print}' OFS=' ') Platform"
else
  DISPLAY_NAME="$DISPLAY_NAME_ARG"
fi

# 中文名: 缺省时复用 PROJECT_SLUG 作为中文识别（用户应显式提供，避免空中文名）
if [[ -z "$CHINESE_NAME_ARG" ]]; then
  CHINESE_NAME="$PROJECT_SLUG"
  echo "warning: chinese name not provided, falling back to slug: $CHINESE_NAME" >&2
else
  CHINESE_NAME="$CHINESE_NAME_ARG"
fi

# 1) 重命名子工程目录
[[ -d "$TARGET_DIR/omni-platform-front" ]]  && mv "$TARGET_DIR/omni-platform-front"  "$TARGET_DIR/$front_slug"
[[ -d "$TARGET_DIR/omni-platform-mobile" ]] && mv "$TARGET_DIR/omni-platform-mobile" "$TARGET_DIR/$mobile_slug"
[[ -d "$TARGET_DIR/omni-platform-server" ]] && mv "$TARGET_DIR/omni-platform-server" "$TARGET_DIR/$server_slug"

# 2) 重命名 assets 子目录
[[ -d "$TARGET_DIR/assets/omni-platform-front" ]]  && mv "$TARGET_DIR/assets/omni-platform-front"  "$TARGET_DIR/assets/$front_slug"
[[ -d "$TARGET_DIR/assets/omni-platform-mobile" ]] && mv "$TARGET_DIR/assets/omni-platform-mobile" "$TARGET_DIR/assets/$mobile_slug"
[[ -d "$TARGET_DIR/assets/omni-platform-server" ]] && mv "$TARGET_DIR/assets/omni-platform-server" "$TARGET_DIR/assets/$server_slug"

# 3) 文本替换 (perl, 二进制和锁文件跳过)
#    顺序很关键: 长的先替换，避免 omni-platform 提前吃掉 omni-platform-front
escape() { printf '%s' "$1" | sed 's/[\/&]/\\&/g; s/[$@]/\\&/g'; }

safe_front="$(escape "$front_slug")"
safe_mobile="$(escape "$mobile_slug")"
safe_server="$(escape "$server_slug")"
safe_slug="$(escape "$PROJECT_SLUG")"
safe_slug_underscore="$(escape "$SLUG_UNDERSCORE")"
safe_base="$(escape "$BASE_SLUG")"
safe_display="$(escape "$DISPLAY_NAME")"
safe_chinese="$(escape "$CHINESE_NAME")"

while IFS= read -r file; do
  case "$file" in
    *.png|*.jpg|*.jpeg|*.webp|*.gif|*.pdf|*.zip|*.ico|*.woff|*.woff2|*.ttf|*.otf|*.mp4|*.mp3) continue ;;
    */pnpm-lock.yaml|*/yarn.lock|*/package-lock.json|*.lock) continue ;;
    */node_modules/*|*/dist/*|*/.git/*) continue ;;
  esac
  perl -0pi -e "
    s/omni-platform-front/$safe_front/g;
    s/omni-platform-mobile/$safe_mobile/g;
    s/omni-platform-server/$safe_server/g;
    s/omni_platform/$safe_slug_underscore/g;
    s/omni-platform/$safe_slug/g;
    s/通用平台项目初始化模板/$safe_chinese/g;
    s/Omni Platform/$safe_display/g;
  " "$file"
done < <(find "$TARGET_DIR" -type f)

# 4) 更新 VERSION.md 元数据
if [[ -f "$TARGET_DIR/VERSION.md" ]]; then
  cat > "$TARGET_DIR/VERSION.md" <<EOF
# ${DISPLAY_NAME} (Derived from omni-platform)

- Project slug: \`${PROJECT_SLUG}\`
- Display name: \`${DISPLAY_NAME}\`
- Chinese name: \`${CHINESE_NAME}\`
- Derived from: \`omni-platform\` (platform-project-skill)
- Derived date: \`$(date +%F)\`
- Next: run \`pnpm install\` then \`docker compose config -q\` to verify.
EOF
fi

# 5) 重置 graphify 占位报告
if [[ -f "$TARGET_DIR/graphify-out/GRAPH_REPORT.md" ]]; then
  cat > "$TARGET_DIR/graphify-out/GRAPH_REPORT.md" <<EOF
# Graph Report - ${PROJECT_SLUG}

> 派生后占位报告。请运行 \`python3 -c "from graphify.watch import _rebuild_code; from pathlib import Path; _rebuild_code(Path('.'))"\` 或对应 graphify 命令重新生成。
EOF
fi

# 6) 删除母版自带的 PNG（这些是占位图，必须由 image_gen 替换），保留目录骨架
if [[ -d "$TARGET_DIR/assets" ]]; then
  find "$TARGET_DIR/assets" -type f -name "*.png" -delete
fi

# 7) 创建双语资产目录
for locale in zh-CN en; do
  mkdir -p \
    "$TARGET_DIR/assets/platform/architecture/$locale" \
    "$TARGET_DIR/assets/platform/design/$locale" \
    "$TARGET_DIR/assets/$front_slug/design/$locale" \
    "$TARGET_DIR/assets/$front_slug/screenshots/$locale" \
    "$TARGET_DIR/assets/$mobile_slug/design/$locale" \
    "$TARGET_DIR/assets/$mobile_slug/screenshots/$locale" \
    "$TARGET_DIR/assets/$server_slug/architecture/$locale"
done

# 8) 生成 .asset-todo.json (7 类图片 × 2 种语言)
cat > "$TARGET_DIR/assets/.asset-todo.json" <<EOF
{
  "schema_version": 1,
  "project_slug": "${PROJECT_SLUG}",
  "created_at": "$(date -u +%FT%TZ)",
  "todo": [
    { "image_type": "platform-architecture",     "locale": "zh-CN", "path": "assets/platform/architecture/zh-CN/${PROJECT_SLUG}-overview.png" },
    { "image_type": "platform-architecture",     "locale": "en",    "path": "assets/platform/architecture/en/${PROJECT_SLUG}-overview.png" },
    { "image_type": "platform-design-baseline",  "locale": "zh-CN", "path": "assets/platform/design/zh-CN/${PROJECT_SLUG}-design-baseline.png" },
    { "image_type": "platform-design-baseline",  "locale": "en",    "path": "assets/platform/design/en/${PROJECT_SLUG}-design-baseline.png" },
    { "image_type": "front-ui-draft",            "locale": "zh-CN", "path": "assets/${front_slug}/design/zh-CN/front-ui-design-draft.png" },
    { "image_type": "front-ui-draft",            "locale": "en",    "path": "assets/${front_slug}/design/en/front-ui-design-draft.png" },
    { "image_type": "front-dashboard-concept",   "locale": "zh-CN", "path": "assets/${front_slug}/screenshots/zh-CN/front-dashboard-concept.png" },
    { "image_type": "front-dashboard-concept",   "locale": "en",    "path": "assets/${front_slug}/screenshots/en/front-dashboard-concept.png" },
    { "image_type": "mobile-ui-draft",           "locale": "zh-CN", "path": "assets/${mobile_slug}/design/zh-CN/mobile-ui-design-draft.png" },
    { "image_type": "mobile-ui-draft",           "locale": "en",    "path": "assets/${mobile_slug}/design/en/mobile-ui-design-draft.png" },
    { "image_type": "mobile-home-concept",       "locale": "zh-CN", "path": "assets/${mobile_slug}/screenshots/zh-CN/mobile-home-concept.png" },
    { "image_type": "mobile-home-concept",       "locale": "en",    "path": "assets/${mobile_slug}/screenshots/en/mobile-home-concept.png" },
    { "image_type": "server-architecture",       "locale": "zh-CN", "path": "assets/${server_slug}/architecture/zh-CN/server-architecture-concept.png" },
    { "image_type": "server-architecture",       "locale": "en",    "path": "assets/${server_slug}/architecture/en/server-architecture-concept.png" }
  ],
  "note": "请用 image_gen 生成 7 类 × 2 语言共 14 张图，落盘后调用 scripts/register-asset.sh 登记到 asset-manifest.json"
}
EOF

# 9) 注入项目专属的 asset-manifest.json (替换 __PROJECT_*__ 占位符)
MANIFEST="$TARGET_DIR/assets/asset-manifest.json"
if [[ -f "$MANIFEST" ]]; then
  perl -0pi -e "
    s/__PROJECT_SLUG__/$safe_slug/g;
    s/__PROJECT_FRONT__/$safe_front/g;
    s/__PROJECT_MOBILE__/$safe_mobile/g;
    s/__PROJECT_SERVER__/$safe_server/g;
  " "$MANIFEST"
fi

# 10) 输出结果（明确 STATE）
cat <<EOF
STATE=scaffold_done
CREATED=$TARGET_DIR
SLUG=$PROJECT_SLUG
DISPLAY_NAME=$DISPLAY_NAME
CHINESE_NAME=$CHINESE_NAME
FRONT=$front_slug
MOBILE=$mobile_slug
SERVER=$server_slug
DB_NAME=$SLUG_UNDERSCORE

ASSET_TODO=$TARGET_DIR/assets/.asset-todo.json
ASSET_MANIFEST=$TARGET_DIR/assets/asset-manifest.json

WARN scaffold 完成 ≠ 初始化完成。还差 2 步:
  1) 对 .asset-todo.json 列出的 14 张双语图运行 image_gen 生成；落盘后用 register-asset.sh 登记
  2) 跑 verify-assets.sh + check-project-baseline.sh + readme-gate.py + docker compose config -q

NEXT_GENERATE=for each todo: image_gen → bash "$SKILL_ROOT/scripts/register-asset.sh" "$TARGET_DIR" <image-path> [prompt]
NEXT_VERIFY=bash "$SKILL_ROOT/scripts/verify-assets.sh" "$TARGET_DIR" && bash "$SKILL_ROOT/scripts/check-project-baseline.sh" "$TARGET_DIR"
EOF
