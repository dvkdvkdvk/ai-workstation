# AI Workstation

A self-hosted AI stack for local development, running fully on your own hardware.

## Services

| Service | Description | Port |
|---------|-------------|------|
| [Ollama](https://ollama.ai) | Local LLM inference server | 11434 |
| [Open WebUI](https://openwebui.com) | Chat UI for Ollama | 3000 |
| [LangFlow](https://langflow.org) | Visual LLM workflow builder | 7860 |
| [Qdrant](https://qdrant.tech) | Vector database | 6333 |
| [n8n](https://n8n.io) | Workflow automation | 5678 |
| [PostgreSQL](https://postgresql.org) | Relational database | 5432 |

## Prerequisites

- Docker Engine 24+
- Docker Compose v2
- 16 GB RAM minimum (32 GB recommended for larger models)
- NVIDIA GPU with CUDA 12+ (optional, for GPU acceleration)

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/dvkdvkdvk/ai-workstation.git
cd ai-workstation

# 2. Copy and edit the environment file
cp .env.example .env
# Edit .env and set your passwords / API keys

# 3. Start the stack
./setup.sh

# 4. Open the UI
open http://localhost:3000
```

## GPU Acceleration

To enable NVIDIA GPU support for Ollama, uncomment the `deploy` block in
`docker-compose.yml` under the `ollama` service:

```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: all
          capabilities: [gpu]
```

## Data Persistence

All service data is stored in named Docker volumes (e.g. `ollama_data`,
`postgres_data`) managed by Docker. You can inspect them with
`docker volume ls` and find their physical location with
`docker volume inspect <name>`. To bind-mount a host path instead, replace the
named volume entry in `docker-compose.yml` with an absolute path, e.g.
`/mnt/data/ollama:/root/.ollama`.

## Updating

```bash
docker compose pull
docker compose up -d
```

## Stopping

```bash
docker compose down
```

To remove all data as well:

```bash
docker compose down -v
```

## License

MIT