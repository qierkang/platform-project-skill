#!/usr/bin/env bash
set -euo pipefail

# 用法:
#   check-project-baseline.sh [--strict|--existing] <project-path>
#
# 模式:
#   --strict   (默认) 严格模式 — node_modules/dist/.DS_Store 视为 FAIL
#   --existing 老项目模式 — 上述视为 WARN

MODE="strict"
if [[ "${1:-}" == "--existing" ]]; then
  MODE="existing"
  shift
elif [[ "${1:-}" == "--strict" ]]; then
  MODE="strict"
  shift
fi

PROJECT_PATH="${1:-}"

if [[ -z "$PROJECT_PATH" ]]; then
  echo "usage: check-project-baseline.sh [--strict|--existing] <project-path>" >&2
  exit 2
fi

if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "FAIL project path not found: $PROJECT_PATH" >&2
  exit 1
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"
status=0

check_path() {
  local path="$1"
  if [[ -e "$PROJECT_PATH/$path" ]]; then
    echo "OK $path"
  else
    echo "WARN missing $path"
  fi
}

check_path "README.md"
check_path "AGENTS.md"
if [[ -f "$PROJECT_PATH/CLAUDE.md" || -f "$PROJECT_PATH/.claude/CLAUDE.md" ]]; then
  echo "OK CLAUDE.md"
else
  echo "WARN missing CLAUDE.md"
fi
# LICENSE：新项目必须存在（缺失即 FAIL），老项目降级为 WARN
if [[ -f "$PROJECT_PATH/LICENSE" || -f "$PROJECT_PATH/LICENSE.md" || -f "$PROJECT_PATH/LICENSE.txt" ]]; then
  echo "OK LICENSE"
elif [[ "$MODE" == "existing" ]]; then
  echo "WARN missing LICENSE"
else
  echo "FAIL missing LICENSE"
  status=1
fi
check_path "assets"
check_path "docs"

# ---- noise scan (SIGPIPE 安全) ----
noise_lines=()
while IFS= read -r line; do
  noise_lines+=("$line")
  if [[ "${#noise_lines[@]}" -ge 50 ]]; then
    break
  fi
done < <(find "$PROJECT_PATH" \( -name ".DS_Store" -o -name "node_modules" -o -name "dist" \) -prune -print 2>/dev/null || true)

if [[ "${#noise_lines[@]}" -gt 0 ]]; then
  if [[ "$MODE" == "existing" ]]; then
    echo "WARN generated noise exists in existing project (.DS_Store/node_modules/dist)"
    printf '  %s\n' "${noise_lines[@]}"
  else
    echo "FAIL generated noise found (.DS_Store/node_modules/dist)"
    printf '  %s\n' "${noise_lines[@]}"
    status=1
  fi
else
  echo "OK no generated noise"
fi

# ---- 残留扫描 (绝对路径 + 已知其他项目名) ----
# 注意：不能把用户当前项目中文名写死进禁用词，否则会误杀真实业务项目。
FORBIDDEN_RESIDUE_PATTERN="${PLATFORM_BASELINE_FORBIDDEN_RESIDUE_PATTERN:-/Users/[a-zA-Z0-9_.-]+/\\.codex|star-billiards-platform}"
residue=()
while IFS= read -r line; do
  residue+=("$line")
  if [[ "${#residue[@]}" -ge 30 ]]; then
    break
  fi
done < <(grep -rIn \
  --include="*.md" --include="*.yml" --include="*.yaml" \
  --include="*.json" --include="*.ts" --include="*.tsx" \
  --include="*.js" --include="*.jsx" --include="*.sh" \
  --exclude-dir=node_modules --exclude-dir=dist \
  --exclude-dir=.git --exclude-dir=graphify-out \
  --exclude-dir=governance --exclude-dir=references \
  --exclude="check-project-baseline.sh" \
  -E "$FORBIDDEN_RESIDUE_PATTERN" \
  "$PROJECT_PATH" 2>/dev/null || true)

if [[ "${#residue[@]}" -gt 0 ]]; then
  if [[ "$MODE" == "existing" ]]; then
    echo "WARN suspected residue (absolute path / other-project names):"
    printf '  %s\n' "${residue[@]}"
  else
    echo "FAIL residue from template source (absolute path / other-project names):"
    printf '  %s\n' "${residue[@]}"
    status=1
  fi
else
  echo "OK no template-source residue"
fi

# ---- README 校验 (代码块包图 + 路径存在) ----
set +e
python3 - "$PROJECT_PATH" "$MODE" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
mode = sys.argv[2]
bad = []
missing_images = []
skip_dirs = {
    "assets", "references", "examples", "governance",
    "node_modules", "dist", "graphify-out", ".git",
}
for path in root.rglob("README.md"):
    if any(part in skip_dirs for part in path.relative_to(root).parts[:-1]):
        continue
    try:
        text = path.read_text(encoding="utf-8", errors="ignore")
    except Exception:
        continue
    for match in re.finditer(r"```(?:md|markdown)\s+.*?!\[[^\]]+\]\([^)]+\).*?```", text, re.S):
        bad.append(str(path))
        break
    for image_path in re.findall(r"!\[[^\]]*\]\(([^)]+)\)", text):
        if image_path.startswith(("http://", "https://", "#")):
            continue
        try:
            resolved = (path.parent / image_path).resolve()
        except Exception:
            missing_images.append(f"{path}: {image_path}")
            continue
        if not resolved.exists():
            missing_images.append(f"{path}: {image_path}")

exit_code = 0
if bad:
    print("FAIL README image markdown inside fenced code block:")
    for item in bad:
        print(" ", item)
    exit_code = 1
if missing_images:
    if mode == "existing":
        print("WARN README image path does not exist (existing project mode):")
        for item in missing_images:
            print(" ", item)
    else:
        print("FAIL README image path does not exist:")
        for item in missing_images:
            print(" ", item)
        exit_code = 1
if not bad and not missing_images:
    print("OK README image markdown is renderable")
    print("OK README image paths exist")

sys.exit(exit_code)
PY
py_status=$?
set -e

if [[ "$py_status" -ne 0 ]]; then
  status=1
fi

# ---- 资产校验 (verify-assets.sh) ----
# 仅在 manifest 存在时跑（老项目模式或部分场景下可能无 manifest，此时仅 WARN）
SCRIPT_DIR_LOCAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$PROJECT_PATH/assets/asset-manifest.json" ]]; then
  echo "---- verify-assets ----"
  set +e
  bash "$SCRIPT_DIR_LOCAL/verify-assets.sh" "$PROJECT_PATH"
  va_status=$?
  set -e
  if [[ "$va_status" -ne 0 ]]; then
    if [[ "$MODE" == "existing" ]]; then
      echo "WARN verify-assets 失败（existing 模式下降级为 WARN）"
    else
      status=1
    fi
  fi
else
  echo "WARN assets/asset-manifest.json 不存在，跳过资产校验"
  if [[ "$MODE" != "existing" ]]; then
    echo "FAIL strict 模式下 manifest 必须存在 (由 create-platform-project.sh 自动生成)"
    status=1
  fi
fi

if [[ "$status" -eq 0 ]]; then
  echo "STATE=validation_done"
else
  echo "STATE=validation_failed"
fi

exit "$status"
