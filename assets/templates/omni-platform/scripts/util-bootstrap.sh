#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT_DIR"

if [ ! -f ".env" ]; then
  cp .env.example .env
  echo "[bootstrap] 已从 .env.example 复制 .env"
fi

pnpm install -r
echo "[bootstrap] 依赖安装完成"
