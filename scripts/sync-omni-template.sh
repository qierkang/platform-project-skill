#!/usr/bin/env bash
set -euo pipefail

# 用法:
#   sync-omni-template.sh <source-omni-platform-path>
#
# 安全保护:
#   - source 必须包含 omni-platform-{front,mobile,server} 三件套
#   - source 必须包含 docker-compose.yml 与 package.json
#   - 否则拒绝执行 rsync --delete，避免覆盖 skill 自带 assets

SOURCE_PATH="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_PATH="$SKILL_ROOT/assets/templates/omni-platform"

if [[ -z "$SOURCE_PATH" ]]; then
  echo "usage: sync-omni-template.sh <source-omni-platform-path>" >&2
  exit 2
fi

if [[ ! -d "$SOURCE_PATH" ]]; then
  echo "error: source path not found: $SOURCE_PATH" >&2
  exit 1
fi

SOURCE_PATH="$(cd "$SOURCE_PATH" && pwd)"

# 来源结构验证
required=(
  "omni-platform-front"
  "omni-platform-mobile"
  "omni-platform-server"
  "docker-compose.yml"
  "package.json"
)
missing=()
for item in "${required[@]}"; do
  [[ -e "$SOURCE_PATH/$item" ]] || missing+=("$item")
done

if [[ "${#missing[@]}" -gt 0 ]]; then
  echo "error: source does not look like a valid omni-platform template:" >&2
  echo "  $SOURCE_PATH" >&2
  echo "missing required entries:" >&2
  printf '  - %s\n' "${missing[@]}" >&2
  echo "refusing to run rsync --delete." >&2
  exit 1
fi

# 防止 source==target 误覆盖
if [[ "$SOURCE_PATH" == "$TARGET_PATH" ]]; then
  echo "error: source path equals target path; nothing to sync." >&2
  exit 1
fi

mkdir -p "$TARGET_PATH"
rsync -a --delete \
  --exclude ".DS_Store" \
  --exclude "node_modules" \
  --exclude "dist" \
  --exclude "tmp" \
  --exclude "/screenshots" \
  --exclude "pnpm-lock.yaml" \
  --exclude "yarn.lock" \
  --exclude "package-lock.json" \
  "$SOURCE_PATH/" "$TARGET_PATH/"

# 自动刷新模板图 sha256 注册表
HASH_REGISTRY="$SKILL_ROOT/governance/template-image-hashes.json"
python3 - "$TARGET_PATH" "$HASH_REGISTRY" <<'PY'
import hashlib, json, sys
from datetime import date
from pathlib import Path
target, registry = Path(sys.argv[1]), Path(sys.argv[2])
entries = []
for png in sorted((target / "assets").rglob("*.png")):
    rel = str(png.relative_to(target))
    sha = hashlib.sha256(png.read_bytes()).hexdigest()
    entries.append({"path": rel, "sha256": sha, "size": png.stat().st_size})
registry.parent.mkdir(parents=True, exist_ok=True)
registry.write_text(json.dumps({
    "schema_version": 1,
    "generated_at": str(date.today()),
    "source": "assets/templates/omni-platform/",
    "note": "派生项目图片 sha256 不允许命中本表（视为占位图未替换）。由 sync-omni-template.sh 自动刷新。",
    "images": entries,
}, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"REFRESHED template-image-hashes.json ({len(entries)} entries)")
PY

cat > "$TARGET_PATH/VERSION.md" <<EOF
# Omni Platform Template Version

- Template name: \`omni-platform\`
- Snapshot date: \`$(date +%F)\`
- Source: synced via \`scripts/sync-omni-template.sh\`
- Skill: \`platform-project-skill\`

## Notes

- This template is the official mother template for new platform projects.
- Refresh this snapshot only with \`scripts/sync-omni-template.sh\` or a deliberate manual sync.
- Excluded local noise: \`.DS_Store\`, \`node_modules\`, \`dist\`, \`tmp\`, \`screenshots\`, lock files.
EOF

# 记录 sync 来源到 governance/CHANGELOG.md
CHANGELOG="$SKILL_ROOT/governance/CHANGELOG.md"
if [[ -f "$CHANGELOG" ]]; then
  {
    echo ""
    echo "## sync-omni-template @ $(date +%F)"
    echo ""
    echo "- Source: \`$SOURCE_PATH\`"
    echo "- Target: \`$TARGET_PATH\`"
  } >> "$CHANGELOG"
fi

echo "SYNCED=$TARGET_PATH"
echo "SOURCE=$SOURCE_PATH"
