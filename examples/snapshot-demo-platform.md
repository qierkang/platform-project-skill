# Snapshot: 派生 demo-platform 的真实产物

> 真机回归证据 — 用于回答"派生出来真的能跑吗？"

## 派生命令

```bash
bash scripts/create-platform-project.sh demo-platform /tmp/platform-skill-smoke "Demo Platform" "演示平台"
```

## 派生产物（裁剪前 40 个文件）

```text
./AGENTS.md
./CLAUDE.md
./README.md
./START-HERE.md
./VERSION.md
./assets/README.md
./assets/demo-front/design/front-ui-design-draft.png
./assets/demo-front/screenshots/front-dashboard-concept.png
./assets/demo-mobile/design/mobile-ui-design-draft.png
./assets/demo-mobile/screenshots/mobile-home-concept.png
./assets/demo-server/architecture/server-architecture-concept.png
./assets/platform/architecture/demo-platform-overview-prompt.md
./assets/platform/architecture/demo-platform-overview.png
./assets/platform/design/demo-platform-design-baseline.png
./demo-front/Dockerfile
./demo-front/README.md
./demo-front/index.html
./demo-front/package.json
./demo-front/src/main.tsx
./demo-front/tsconfig.json
./demo-front/vite.config.ts
./demo-mobile/Dockerfile
./demo-mobile/README.md
./demo-mobile/index.html
./demo-mobile/package.json
./demo-mobile/src/main.tsx
./demo-mobile/tsconfig.json
./demo-mobile/vite.config.ts
./demo-server/Dockerfile
./demo-server/README.md
./demo-server/package.json
./demo-server/src/main.ts
./demo-server/tsconfig.json
./docker-compose.yml
./docs/INDEX.md
...
```

## 命名替换证据

- `omni-platform-{front,mobile,server}` → `demo-{front,mobile,server}` ✅
- `Omni Platform` (display name) → `Demo Platform` ✅
- `通用平台项目初始化模板` → `演示平台` ✅
- `omni-platform-overview.png` → `demo-platform-overview.png` ✅
- `omni-platform-design-baseline.png` → `demo-platform-design-baseline.png` ✅
- `POSTGRES_DB=omni_platform` → `POSTGRES_DB=demo_platform` ✅
- `container_name: omni-platform-postgres` → `container_name: demo-platform-postgres` ✅
- `name: "omni-platform"` (package.json) → `name: "demo-platform"` ✅
- `pnpm --filter omni-platform-front` → `pnpm --filter demo-front` ✅

## 残留扫描结果

```text
$ grep -rn "/Users/qierkang|omni-platform|Omni Platform|通用平台项目初始化模板|star-billiards|报销台账" \
    --include="*.md" --include="*.yml" --include="*.json" --include="*.sh"

VERSION.md:1:# Demo Platform (Derived from omni-platform)
VERSION.md:6:- Derived from: `omni-platform` (platform-project-skill)
```

仅有 `VERSION.md` 里两条"派生溯源"是**有意保留**的，其余全部清空。

## 验证命令

```bash
$ docker compose config -q      # exit 0
$ scripts/check-project-baseline.sh /tmp/platform-skill-smoke/demo-platform
OK README.md
OK AGENTS.md
OK CLAUDE.md
OK assets
OK docs
OK no generated noise
OK no template-source residue
OK README image markdown is renderable
OK README image paths exist

$ python3 ~/.claude/scripts/readme-gate.py --readme README.md
{"pass": true, "missing_sections": [], "placeholder_hits": [], ...}
```

## 已知特性（不是 bug）

- `pnpm-lock.yaml` 不再随母版下发，派生项目首次需运行 `pnpm install` 重建 lock —— 避免 lock 因命名替换被破坏。
- `VERSION.md` 保留"Derived from omni-platform"溯源信息。
- `.claude/settings.json` 的 graphify hook 使用 `${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel || pwd)}`，跟随项目根目录自动定位，不再带绝对路径。
