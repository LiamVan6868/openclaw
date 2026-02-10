#!/usr/bin/env bash
set -euo pipefail

echo "=== OpenClaw Daytona Sandbox Setup ==="

# Ensure corepack is enabled and pnpm is available
corepack enable 2>/dev/null || sudo corepack enable
corepack prepare pnpm@10.23.0 --activate 2>/dev/null || true

echo "[1/4] Installing dependencies..."
pnpm install --frozen-lockfile

echo "[2/4] Building UI..."
pnpm ui:build

echo "[3/4] Building project..."
pnpm build

echo "[4/4] Copying .env.example to .env..."
if [ ! -f .env ]; then
  cp .env.example .env
  echo "  -> .env created from .env.example. Please update with your API keys."
else
  echo "  -> .env already exists, skipping."
fi

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Quick start:"
echo "  pnpm dev          - Start development mode"
echo "  pnpm gateway:dev  - Start gateway in dev mode"
echo "  pnpm test         - Run unit tests"
echo "  pnpm check        - Run format + type check + lint"
echo ""
echo "Ports forwarded:"
echo "  18789 - Gateway"
echo "  18790 - Bridge"
echo "  5173  - UI dev server"
