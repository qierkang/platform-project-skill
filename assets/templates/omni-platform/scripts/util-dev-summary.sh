#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "项目根目录: $ROOT_DIR"
echo "前端目录: $ROOT_DIR/omni-platform-front"
echo "移动端目录: $ROOT_DIR/omni-platform-mobile"
echo "服务端目录: $ROOT_DIR/omni-platform-server"
echo "推荐启动顺序:"
echo "1. pnpm dev:server"
echo "2. pnpm dev:front"
echo "3. pnpm dev:mobile"
