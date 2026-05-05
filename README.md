# AI Workstation - One Command Install

Share this with anyone - they'll get your exact OpenCode setup!

## One-Command Install

```bash
curl -fsSL https://raw.githubusercontent.com/dkialka/ai-workstation/main/install.sh | bash
```

Or download and run:

```bash
curl -O https://raw.githubusercontent.com/dkialka/ai-workstation/main/install.sh
bash install.sh
```

## What Gets Installed

✅ **Ollama** - Local AI models (codellama, llama3.2, phi3)
✅ **LiteLLM Proxy** - OpenAI-compatible API at localhost:4000
✅ **OpenCode Skills** - 6 core + 550+ community skills auto-load
✅ **Pinokio** - 1-click AI app installer
✅ **Raycast** - Quick launcher
✅ **AI Assistant Scripts** - Smart model routing in `~/ai-stack/ai-assistant/`

## After Install

1. **Open OpenCode** - Skills auto-load on startup
2. **Everything auto-starts** - Ollama + LiteLLM fire up with terminal

## Directory Structure

```
~/ai-stack/
├── ai-assistant/          # AI scripts (ultimate.py, master.py, router.py)
├── ai-workstation.sh      # Launcher (auto-runs on terminal open)
├── install.sh             # This installer
├── bell/                  # Bell HTML files
├── mail-apps/             # MailReplyApp
└── openrouter-test/       # OpenRouter API tests
```

## Test It

```bash
python3 ~/ai-stack/ai-assistant/ultimate.py "build a React login page"
```

## Manual Steps (if needed)

- **Pinokio**: Download from https://pinokio.computer → drag to /Applications
- **OpenCode**: `npm install -g opencode`

---

**To share:** Push `ai-stack/` to GitHub, then others can install with the curl command above!
