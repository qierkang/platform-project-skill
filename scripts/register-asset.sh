#!/usr/bin/env bash
set -euo pipefail

# 用法:
#   register-asset.sh <project-path> <image-relative-path> [prompt-file-relative] [--generated-by image_gen]
#
# 示例:
#   register-asset.sh /tmp/demo-platform assets/platform/architecture/zh-CN/demo-platform-overview.png
#   register-asset.sh /tmp/demo-platform assets/demo-front/design/en/front-ui-design-draft.png assets/prompts/front-en.md
#
# 作用:
#   把指定图片登记到 <project>/assets/asset-manifest.json:
#     - 若该路径在 required 列表 → 更新对应 entry
#     - 否则 → 追加到 extra
#   同时计算 sha256，自动填 generated_at（当前时间 ISO8601）。
#
# 退出码:
#   0 成功；2 用法错误；1 图片不存在或 manifest 缺失

PROJECT_PATH=""
IMAGE_REL=""
PROMPT_REL=""
GENERATED_BY="image_gen"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --generated-by) GENERATED_BY="$2"; shift 2 ;;
    -h|--help) sed -n '1,20p' "$0"; exit 0 ;;
    *)
      if [[ -z "$PROJECT_PATH" ]]; then PROJECT_PATH="$1"
      elif [[ -z "$IMAGE_REL" ]]; then IMAGE_REL="$1"
      elif [[ -z "$PROMPT_REL" ]]; then PROMPT_REL="$1"
      else echo "error: unexpected arg: $1" >&2; exit 2; fi
      shift ;;
  esac
done

if [[ -z "$PROJECT_PATH" || -z "$IMAGE_REL" ]]; then
  echo "usage: register-asset.sh <project-path> <image-relative-path> [prompt-file-relative]" >&2
  exit 2
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"
IMG_ABS="$PROJECT_PATH/$IMAGE_REL"
MANIFEST="$PROJECT_PATH/assets/asset-manifest.json"

[[ -f "$IMG_ABS" ]]    || { echo "error: image not found: $IMG_ABS" >&2; exit 1; }
[[ -f "$MANIFEST" ]]   || { echo "error: manifest not found: $MANIFEST" >&2; exit 1; }

python3 - "$MANIFEST" "$IMAGE_REL" "${PROMPT_REL:-}" "$GENERATED_BY" "$IMG_ABS" <<'PY'
import hashlib, json, sys
from datetime import datetime, timezone
from pathlib import Path

manifest_path, image_rel, prompt_rel, generated_by, image_abs = sys.argv[1:6]
sha = hashlib.sha256(Path(image_abs).read_bytes()).hexdigest()
now = datetime.now(timezone.utc).isoformat(timespec="seconds")

m = json.loads(Path(manifest_path).read_text(encoding="utf-8"))
hit = False
for entry in m.get("required", []):
    if entry.get("path") == image_rel:
        entry["sha256"] = sha
        entry["generated_at"] = now
        entry["generated_by"] = generated_by
        if prompt_rel:
            entry["prompt_file"] = prompt_rel
        hit = True
        break
if not hit:
    m.setdefault("extra", []).append({
        "image_type": "extra",
        "path": image_rel,
        "prompt_file": prompt_rel or None,
        "sha256": sha,
        "generated_at": now,
        "generated_by": generated_by,
    })
if m.get("generated_at") is None:
    m["generated_at"] = now
Path(manifest_path).write_text(json.dumps(m, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"REGISTERED path={image_rel} sha={sha[:12]} bucket={'required' if hit else 'extra'}")
PY
