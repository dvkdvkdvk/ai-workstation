# AI Workstation - Complete Setup Guide

Your standard AI development environment with 550+ skills.

## What's Included

### Core Stack
| Component | Purpose | Auto-Start |
|-----------|---------|----------|
| **Ollama** | Local AI models (free) | ✅ brew services |
| **LiteLLM Proxy** | OpenAI-compatible API | ✅ localhost:4000 |
| **OpenCode** | Main IDE with 6 skills auto-loaded | ✅ on app open |
| **Pinokio** | 1-click AI app installer | ✅ manual open |
| **Raycast** | Quick launcher + AI shortcuts | ✅ manual open |

### Local AI Models (100% Free)
| Model | Size | Best For |
|-------|------|----------|
| `codellama` | 3.8GB | Code expert, building apps |
| `llama3.2:1b` | 1.3GB | UI/UX design, Figma |
| `phi3:mini` | 2.2GB | Fast text, writing |
| `gemma:2b` | 1.7GB | Alternative/chat |

### Auto-Loaded Skills (6 core)
When you **open OpenCode**, these load automatically:

1. **frontend-design** - Distinctive UI creation (avoid generic AI aesthetics)
2. **ui-ux-pro-max** - 67 styles, 96 palettes, 57 font pairings
3. **vercel-react-best-practices** - 70 React/Next.js performance rules  
4. **web-artifacts-builder** - React + Tailwind + shadcn/ui bundler
5. **design-auditor** - 19 professional design rules (WCAG, accessibility)
6. **theme-factory** - 10 professional themes with fonts/colors

### Community Skills Installed (550+)
- **alirezarezvani/claude-skills** - 225+ skills (engineering, marketing, product, C-level)
- **borghei/claude-skills** - 225+ skills (11 platforms: Claude Code, Codex, Gemini, Cursor, etc.)
- **OneWave-AI/claude-skills** - 100 skills (sales, business automation, content)

## Quick Start

### On Current Machine
```bash
# 1. Start everything
/Users/dkialka/ai-workstation.sh

# 2. Open OpenCode
# Skills auto-load from ~/.config/opencode/opencode.json

# 3. Test it
python3 /Users/dkialka/ai-assistant/ultimate.py "build me a React login page"
```

### On New Machine - One Command
```bash
# Download and run the installer
curl -fsSL https://raw.githubusercontent.com/dkialka/ai-workstation/main/ai-workstation-installer.sh -o /tmp/install.sh
chmod +x /tmp/install.sh
/tmp/install.sh
```

Or manually:
```bash
git clone https://github.com/dkialka/ai-workstation.git
cd ai-workstation
./ai-workstation-installer.sh
```

## Configuration Files

### OpenCode Config
Location: `~/.config/opencode/opencode.json`

Auto-loads these 6 skills on every OpenCode startup.

### AI Assistant Scripts
Location: `~/ai-assistant/`

- `ultimate.py` - Master assistant (all 6 skills + smart routing)
- `smart-workstation.py` - Auto-selects best model per query
- `router.py` - Basic model routing

## Usage

### In OpenCode (skills auto-loaded)
Just ask naturally:
- "Build me a React dashboard with shadcn/ui"
- "Design a modern landing page (use ui-ux-pro-max)"  
- "Audit this Figma design for accessibility (19 rules)"
- "Apply the Ocean Depths theme to my app"

### CLI Quick Commands
```bash
# Smart auto-routing (picks best model automatically)
python3 ~/ai-assistant/smart-workstation.py "build a login form"
python3 ~/ai-assistant/smart-workstation.py "write a blog post"  
python3 ~/ai-assistant/smart-workstation.py "design a dashboard"

# Test local AI
curl http://localhost:4000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"ollama/llama3.2:1b","messages":[{"role":"user","content":"hi"}]}'
```

## Verify Installation
```bash
# Check Ollama models
ollama list

# Check OpenCode config
cat ~/.config/opencode/opencode.json

# Check services running
ps aux | grep -E "ollama|litellm" | grep -v grep

# Test LiteLLM proxy
curl http://localhost:4000/health
```

## Replicate on New Machine

1. **Copy these files** to new machine:
   - `~/.config/opencode/opencode.json`
   - `~/ai-assistant/` (entire folder)
   - `~/ai-workstation.sh`
   - `~/ai-workstation-installer.sh`

2. **Run installer** (or manually install):
   - Homebrew, Ollama, Python3, Pinokio, Raycast
   - Pull Ollama models: `ollama pull codellama llama3.2:1b phi3:mini`
   - Install Python deps: `pip3 install 'litellm[proxy]'`
   - Copy skills to `~/.claude/skills/` and `~/.agents/skills/`

3. **Open OpenCode** - skills auto-load!

## File Structure
```
~
├── .config/opencode/opencode.json    # OpenCode config (6 skills auto-load)
├── .claude/skills/                      # Claude skills
│   ├── frontend-design/
│   ├── ui-ux-pro-max/
│   ├── vercel-react-best-practices/
│   ├── web-artifacts-builder/
│   ├── design-auditor/
│   ├── theme-factory/
│   ├── alirezarezvani/                # 225+ community skills
│   ├── borghei/                       # 225+ community skills  
│   └── onewave-ai/                    # 100+ community skills
├── ai-assistant/                        # AI assistant scripts
│   ├── ultimate.py                     # Master assistant
│   ├── smart-workstation.py           # Auto model selection
│   └── router.py                      # Basic routing
├── ai-workstation.sh                    # Start all services
└── ai-workstation-installer.sh           # One-click installer
```

Your AI Workstation is ready! 🚀
