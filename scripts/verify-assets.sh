#!/usr/bin/env bash
set -euo pipefail

# 用法:
#   verify-assets.sh <project-path>
#
# 校验项 (任何一条失败 → 非零退出):
#   A. assets/asset-manifest.json 存在
#   B. manifest.required 全部 generated_at != null
#   C. manifest 中每条记录的图片文件存在 且 sha256 匹配文件实际 hash
#   D. manifest 中每条记录的 sha256 不在 governance/template-image-hashes.json 中 (模板占位图复用)
#   E. README/子项目 README 中所有本地图片引用 都能在 manifest (required + extra) 中找到 (杜绝孤儿图)
#   F. manifest 中每张登记的图都至少被一个 README 引用 (杜绝孤立产物)
#
# 退出码:
#   0 → STATE=asset_done
#   1 → STATE=asset_failed (有 FAIL)
#   2 → 用法错误

PROJECT_PATH="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HASH_REGISTRY="$SKILL_ROOT/governance/template-image-hashes.json"

if [[ -z "$PROJECT_PATH" ]]; then
  echo "usage: verify-assets.sh <project-path>" >&2
  exit 2
fi
if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "FAIL project path not found: $PROJECT_PATH" >&2
  exit 1
fi
PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"

python3 - "$PROJECT_PATH" "$HASH_REGISTRY" <<'PY'
import hashlib, json, re, sys
from pathlib import Path

project = Path(sys.argv[1]).resolve()
hash_registry_path = Path(sys.argv[2])

manifest_path = project / "assets" / "asset-manifest.json"
fails = []
warns = []
oks = []

# A: manifest 存在
if not manifest_path.is_file():
    print("FAIL A. assets/asset-manifest.json 不存在")
    print("STATE=asset_failed")
    sys.exit(1)
oks.append("A. asset-manifest.json 存在")

manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
required = manifest.get("required", []) or []
extra = manifest.get("extra", []) or []

# 模板 hash 集合
template_hashes = set()
if hash_registry_path.is_file():
    reg = json.loads(hash_registry_path.read_text(encoding="utf-8"))
    template_hashes = {e["sha256"] for e in reg.get("images", [])}

# B + C + D
for entry in required:
    rel = entry.get("path", "")
    sha = entry.get("sha256")
    generated_at = entry.get("generated_at")
    image_abs = project / rel

    if not generated_at:
        fails.append(f"B. required 未生成: {rel} (generated_at=null)")
        continue
    if not image_abs.is_file():
        fails.append(f"C. required 文件缺失: {rel}")
        continue
    real_sha = hashlib.sha256(image_abs.read_bytes()).hexdigest()
    if sha and sha != real_sha:
        fails.append(f"C. sha256 不匹配 {rel}: manifest={sha[:12]} actual={real_sha[:12]}")
        continue
    if real_sha in template_hashes:
        fails.append(f"D. 占位图复用 (与母版 hash 相同): {rel} sha={real_sha[:12]}")
        continue
    oks.append(f"B+C+D ok required: {rel}")

# extra 也跑 C+D
for entry in extra:
    rel = entry.get("path", "")
    sha = entry.get("sha256")
    image_abs = project / rel
    if not image_abs.is_file():
        warns.append(f"extra 文件缺失（已登记）: {rel}")
        continue
    real_sha = hashlib.sha256(image_abs.read_bytes()).hexdigest()
    if sha and sha != real_sha:
        warns.append(f"extra sha256 不匹配 {rel}: manifest={sha[:12]} actual={real_sha[:12]}")
    if real_sha in template_hashes:
        fails.append(f"D. extra 占位图复用: {rel} sha={real_sha[:12]}")

# E + F: README ↔ manifest 双向校验
SKIP_DIRS = {"assets", "references", "examples", "governance",
             "node_modules", "dist", "graphify-out", ".git"}

readme_image_refs = []  # (readme_path, image_rel_to_project)
for readme in project.rglob("README.md"):
    if any(p in SKIP_DIRS for p in readme.relative_to(project).parts[:-1]):
        continue
    text = readme.read_text(encoding="utf-8", errors="ignore")
    for img in re.findall(r"!\[[^\]]*\]\(([^)]+)\)", text):
        if img.startswith(("http://", "https://", "#")):
            continue
        try:
            target = (readme.parent / img).resolve()
        except Exception:
            continue
        try:
            rel = target.relative_to(project)
        except ValueError:
            continue  # 跨项目引用，忽略
        readme_image_refs.append((readme.relative_to(project), str(rel)))

manifest_paths = {e["path"] for e in required + extra}

# E: 所有 README 引用必须在 manifest (去重)
seen_e = set()
for readme_rel, img_rel in readme_image_refs:
    if img_rel in manifest_paths:
        continue
    key = (str(readme_rel), img_rel)
    if key in seen_e:
        continue
    seen_e.add(key)
    fails.append(f"E. README 引用未登记: {readme_rel} → {img_rel}")

# F: manifest 中每张 required 图必须被至少一个 README 引用 (extra 不强制)
referenced = {img for _, img in readme_image_refs}
for entry in required:
    if entry.get("path") not in referenced:
        warns.append(f"F. required 未被任何 README 引用 (孤儿图): {entry.get('path')}")

# ---- 输出 ----
for line in oks:
    print(f"OK {line}")
for line in warns:
    print(f"WARN {line}")
for line in fails:
    print(f"FAIL {line}")

if fails:
    print("STATE=asset_failed")
    sys.exit(1)
print("STATE=asset_done")
sys.exit(0)
PY
