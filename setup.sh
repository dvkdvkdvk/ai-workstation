#!/usr/bin/env bash
set -euo pipefail

# ── Colours ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }

# ── Preflight ────────────────────────────────────────────────────────────────
info "Checking prerequisites..."

if ! command -v docker &>/dev/null; then
  echo "Docker is not installed. Install it from https://docs.docker.com/get-docker/" >&2
  exit 1
fi

if ! docker compose version &>/dev/null; then
  echo "Docker Compose v2 is required. Update Docker Desktop or install the plugin." >&2
  exit 1
fi

# ── .env ─────────────────────────────────────────────────────────────────────
if [[ ! -f .env ]]; then
  warn ".env not found – copying from .env.example"
  cp .env.example .env
  warn "Edit .env and replace all 'change_me_*' values before re-running."
  exit 0
fi

if grep -q 'change_me' .env; then
  warn ".env still contains placeholder values – please edit them before starting."
  exit 1
fi

# ── Start ─────────────────────────────────────────────────────────────────────
info "Pulling latest images..."
docker compose pull

info "Starting the AI workstation stack..."
docker compose up -d

info "Stack is up!"
echo ""
echo "  Open WebUI  → http://localhost:3000"
echo "  LangFlow    → http://localhost:7860"
echo "  n8n         → http://localhost:5678"
echo "  Qdrant      → http://localhost:6333"
echo "  Ollama API  → http://localhost:11434"
echo ""
info "To pull a model: docker exec -it ollama ollama pull llama3"
