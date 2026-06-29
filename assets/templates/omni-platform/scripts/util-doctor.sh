#!/usr/bin/env bash
set -euo pipefail

echo "[doctor] checking docker"
docker --version
docker compose version

echo "[doctor] checking node"
node --version

echo "[doctor] checking pnpm"
pnpm --version
