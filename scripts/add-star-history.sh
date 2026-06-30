#!/usr/bin/env bash
set -euo pipefail

PROJECT_PATH="${1:-}"
REPOSITORY="${2:-}"

if [[ -z "$PROJECT_PATH" || -z "$REPOSITORY" ]]; then
  echo "usage: add-star-history.sh <project-path> <owner>/<repo>" >&2
  exit 2
fi

if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "error: project path not found: $PROJECT_PATH" >&2
  exit 1
fi

if [[ ! "$REPOSITORY" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
  echo "error: repository must use owner/repo format" >&2
  exit 2
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"

for readme in "$PROJECT_PATH/README.md" "$PROJECT_PATH/docs/README_en.md"; do
  if [[ ! -f "$readme" ]]; then
    echo "error: required README not found: $readme" >&2
    exit 1
  fi
done

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh is required to verify the public repository" >&2
  exit 1
fi

visibility="$(gh repo view "$REPOSITORY" --json visibility --jq '.visibility' 2>/dev/null || true)"
if [[ "$visibility" != "PUBLIC" ]]; then
  echo "error: repository is not publicly available: $REPOSITORY" >&2
  exit 1
fi

python3 - "$PROJECT_PATH" "$REPOSITORY" <<'PY'
import re
import sys
from pathlib import Path

project = Path(sys.argv[1])
repository = sys.argv[2]
start = "<!-- star-history:start -->"
end = "<!-- star-history:end -->"
chart = f"""<!-- star-history:start -->
<a href="https://www.star-history.com/?type=date&repos={repository.replace('/', '%2F')}">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos={repository}&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos={repository}&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos={repository}&type=date&legend=top-left" />
 </picture>
</a>
<!-- star-history:end -->"""

for path in (project / "README.md", project / "docs" / "README_en.md"):
    text = path.read_text(encoding="utf-8")
    if start in text and end in text:
        pattern = re.compile(re.escape(start) + r".*?" + re.escape(end), re.DOTALL)
        updated = pattern.sub(chart, text, count=1)
    else:
        heading = "## Star History · Star 历史"
        if heading in text:
            updated = text.replace(heading, f"{heading}\n\n{chart}", 1)
        else:
            license_match = re.search(r"(?m)^## (许可证|License)\s*$", text)
            block = f"\n\n---\n\n{heading}\n\n{chart}\n"
            if license_match:
                updated = text[:license_match.start()] + block + "\n" + text[license_match.start():]
            else:
                updated = text.rstrip() + block + "\n"
    path.write_text(updated, encoding="utf-8")
    print(f"UPDATED {path}")
PY

echo "STAR_HISTORY_UPDATED=$REPOSITORY"
