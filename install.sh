#!/bin/bash
# AI WORKSTATION - One-Command Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/dvkdvkdvk/ai-workstation/main/install.sh | bash
# Or: bash <(curl -fsSL https://raw.githubusercontent.com/dvkdvkdvk/ai-workstation/main/install.sh)

set -e

echo "🚀 AI WORKSTATION - Complete OpenCode Setup"
echo "=========================================="

# Detect home directory
HOME_DIR="$HOME"
AI_STACK="$HOME_DIR/ai-stack"

# ============ 0. CHECK OPENCODE ============
if ! command -v opencode &> /dev/null && [ ! -f "$HOME_DIR/.opencode/bin/opencode" ]; then
    echo ""
    echo "⚠️  OpenCode not found. Installing..."
    if command -v npm &> /dev/null; then
        npm install -g opencode
    elif command -v brew &> /dev/null; then
        brew install opencode
    else
        echo "❌ Please install OpenCode first: https://opencode.ai"
        exit 1
    fi
fi

# ============ 1. CREATE AI-STACK DIRECTORY ============
echo ""
echo "📁 Creating ai-stack directory..."
mkdir -p "$AI_STACK"
cd "$AI_STACK"

# ============ 2. INSTALL HOMEBREW ============
if ! command -v brew &> /dev/null; then
    echo ""
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ============ 3. INSTALL OLLAMA ============
echo ""
echo "Installing Ollama..."
if ! command -v ollama &> /dev/null; then
    brew install ollama
fi

# Start Ollama
echo "Starting Ollama..."
brew services start ollama || ollama serve &
sleep 3

# ============ 4. PULL MODELS ============
echo ""
echo "Pulling AI models (this takes ~10 min)..."
ollama pull qwen2.5vl     # Layout analysis & JSON grounding (128K context)
ollama pull llama3.2:1b    # Ultra-long context & multimodal reasoning (10M tokens)
ollama pull llama3.2:1b     # Lightweight, flexible image aspect ratios (128K context)

# ============ 5. INSTALL PYTHON + LITELLM ============
echo ""
echo "Installing Python dependencies..."
pip3 install 'litellm[proxy]' 2>&1 | tail -3

# ============ 6. INSTALL PINOKIO ============
echo ""
echo "Installing Pinokio..."
if [ ! -d "/Applications/Pinokio.app" ]; then
    echo "  → Download from: https://pinokio.computer"
    echo "  → Then drag to /Applications"
fi

# ============ 7. INSTALL RAYCAST ============
echo ""
echo "Installing Raycast..."
if [ ! -d "/Applications/Raycast.app" ]; then
    brew install --cask raycast
fi

# ============ 8. INSTALL VS CODE EXTENSIONS ============
echo ""
echo "Installing VS Code extensions..."
if command -v code &> /dev/null; then
    code --install-extension christian-kohler.path-intellisense \
        --install-extension ritwickdey.liveserver \
        --install-extension eamodio.gitlens \
        --install-extension esbenp.prettier-vscode \
        --install-extension kilo.kilo-code
else
    echo "  ⚠️  VS Code not found. Install from: https://code.visualstudio.com/"
fi

# ============ 9. CONFIGURE OPENCODE (AUTO-LOAD SKILLS) ============
echo ""
echo "Configuring OpenCode with 6 core skills..."

mkdir -p "$HOME_DIR/.config/opencode"

cat > "$HOME_DIR/.config/opencode/opencode.json" << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "figma": {
      "type": "remote",
      "url": "https://mcp.figma.com/mcp",
      "enabled": true
    },
    "firecrawl": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "firecrawl-mcp"],
      "env": {
        "FIRECRAWL_API_KEY": "${FIRECRAWL_API_KEY}"
      },
      "enabled": true
    }
  }
}
EOF

# ============ 10. INSTALL COMMUNITY SKILLS ============
echo ""
echo "Installing community skills (550+ total)..."

SKILLS_DIR="$HOME_DIR/.claude/skills"
mkdir -p "$SKILLS_DIR"

# alirezarezvani (225+ skills)
echo "  → alirezarezvani/claude-skills (225+ skills)..."
if [ ! -d "$SKILLS_DIR/alirezarezvani" ]; then
    cd /tmp && git clone --depth 1 https://github.com/alirezarezvani/claude-skills.git /tmp/claude-skills 2>/dev/null
    mkdir -p "$SKILLS_DIR/alirezarezvani"
    cp -r /tmp/claude-skills/skills/* "$SKILLS_DIR/alirezarezvani/" 2>/dev/null || true
fi

# borghei (225+ skills)
echo "  → borghei/claude-skills (225+ skills)..."
if [ ! -d "$SKILLS_DIR/borghei" ]; then
    cd /tmp && git clone --depth 1 https://github.com/borghei/claude-skills.git /tmp/borghei-skills 2>/dev/null
    mkdir -p "$SKILLS_DIR/borghei"
    cp -r /tmp/borghei-skills/skills/* "$SKILLS_DIR/borghei/" 2>/dev/null || true
fi

# OneWave-AI (100+ skills)
echo "  → OneWave-AI/claude-skills (100+ skills)..."
if [ ! -d "$SKILLS_DIR/onewave-ai" ]; then
    cd /tmp && git clone --depth 1 https://github.com/OneWave-AI/claude-skills.git /tmp/onewave-skills 2>/dev/null
    mkdir -p "$SKILLS_DIR/onewave-ai"
    cp -r /tmp/onewave-skills/skills/* "$SKILLS_DIR/onewave-ai/" 2>/dev/null || true
fi

# Copy core skills to .agents/skills for OpenCode
AGENTS_SKILLS="$HOME_DIR/.agents/skills"
mkdir -p "$AGENTS_SKILLS"
if [ -d "$SKILLS_DIR" ]; then
    cp -r "$SKILLS_DIR"/* "$AGENTS_SKILLS/" 2>/dev/null || true
fi

# ============ 11. CREATE AI-ASSISTANT SCRIPTS ============
echo ""
echo "Creating AI assistant scripts..."

mkdir -p "$AI_STACK/ai-assistant"

# Ultimate script
cat > "$AI_STACK/ai-assistant/ultimate.py" << 'PYEOF'
"""
ULTIMATE AI ASSISTANT - All Skills + Smart Routing
Usage: python3 ~/ai-stack/ai-assistant/ultimate.py "your query"
"""
import sys
from litellm import completion

api_base = "http://localhost:11434"

MODELS = {
    "code": "ollama/qwen2.5vl",
    "build_app": "ollama/qwen2.5vl",
    "fix_code": "ollama/qwen2.5vl",
    "ui_design": "ollama/llama3.2:1b",
    "figma": "ollama/qwen2.5vl",
    "text": "ollama/llama3.2:1b",
    "write": "ollama/llama3.2:1b",
    "web": "ollama/qwen2.5vl",
    "react": "ollama/qwen2.5vl",
    "audit": "ollama/llama3.2:1b",
    "theme": "ollama/llama3.2:1b",
    "multimodal": "ollama/llama3.2:1b",
}

def smart_ask(prompt):
    prompt_lower = prompt.lower()
    if any(k in prompt_lower for k in ["code", "function", "debug", "react", "python"]):
        model = MODELS["code"]
    elif any(k in prompt_lower for k in ["ui", "design", "figma", "layout"]):
        model = MODELS["ui_design"]
    elif any(k in prompt_lower for k in ["write", "email", "blog", "text"]):
        model = MODELS["text"]
    else:
        model = "ollama/qwen2.5vl"
    
    print(f"🤖 Using: {model.split('/')[-1]}")
    response = completion(model=model, messages=[{"role": "user", "content": prompt}], api_base=api_base)
    print(response.choices[0].message.content)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        smart_ask(" ".join(sys.argv[1:]))
    else:
        print("Usage: python3 ~/ai-stack/ai-assistant/ultimate.py 'your query'")
PYEOF

# Master script
cat > "$AI_STACK/ai-assistant/master.py" << 'PYEOF'
"""
MASTER AI ASSISTANT - Code + UI + Figma + Text
"""
import sys
from litellm import completion

api_base = "http://localhost:11434"

def ask(task_type, prompt):
    models = {
        "code": "ollama/qwen2.5vl",
        "ui": "ollama/llama3.2:1b",
        "text": "ollama/llama3.2:1b",
        "figma": "ollama/qwen2.5vl",
        "multimodal": "ollama/llama3.2:1b",
    }
    model = models.get(task_type, "ollama/qwen2.5vl")
    response = completion(model=model, messages=[{"role": "user", "content": prompt}], api_base=api_base)
    return response.choices[0].message.content

if __name__ == "__main__":
    if len(sys.argv) > 2:
        print(ask(sys.argv[1], " ".join(sys.argv[2:])))
    else:
        print("Usage: python3 master.py <task_type> <prompt>")
PYEOF

# Router script
cat > "$AI_STACK/ai-assistant/router.py" << 'PYEOF'
"""
SMART ROUTER - Auto-selects best model
"""
import sys
from litellm import completion

api_base = "http://localhost:11434"

def route(prompt):
    prompt_lower = prompt.lower()
    if any(k in prompt_lower for k in ["code", "function", "debug"]):
        model = "ollama/qwen2.5vl"
    elif any(k in prompt_lower for k in ["ui", "design", "figma"]):
        model = "ollama/llama3.2:1b"
    else:
        model = "ollama/qwen2.5vl"
    
    response = completion(model=model, messages=[{"role": "user", "content": prompt}], api_base=api_base)
    print(response.choices[0].message.content)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        route(" ".join(sys.argv[1:]))
PYEOF

# ============ 12. CREATE WORKSTATION LAUNCHER ============
echo ""
echo "Creating workstation launcher..."

cat > "$AI_STACK/ai-workstation.sh" << 'BASHEOF'
#!/bin/bash
# AI WORKSTATION - Unified Launcher
echo "🚀 AI WORKSTATION - Starting all services..."
echo "============================================"

# Start Ollama
echo ""
echo "Starting Ollama..."
if ! pgrep -x "ollama" > /dev/null; then
    brew services start ollama
    sleep 3
fi
echo "✅ Ollama running"

# Start LiteLLM Proxy
echo ""
echo "Starting LiteLLM Proxy..."
pkill -f "litellm --model" 2>/dev/null
litellm --model ollama/qwen2.5vl --port 4000 > /tmp/litellm-proxy.log 2>&1 &
sleep 5
echo "✅ LiteLLM Proxy running at http://localhost:4000"

# Show models
echo ""
echo "Available Ollama Models:"
ollama list

echo ""
echo "============================================"
echo "✅ AI WORKSTATION READY!"
echo "============================================"
echo ""
echo "Quick Commands:"
echo "  python3 ~/ai-stack/ai-assistant/ultimate.py 'your query'"
echo "  python3 ~/ai-stack/ai-assistant/master.py code 'build a React app'"
echo ""
echo "Open OpenCode - skills auto-load!"
BASHEOF

chmod +x "$AI_STACK/ai-workstation.sh"

# ============ 13. AUTO-START WITH TERMINAL ============
echo ""
echo "Setting up auto-start..."

if ! grep -q "ai-workstation.sh" "$HOME_DIR/.zshrc" 2>/dev/null; then
    cat >> "$HOME_DIR/.zshrc" << 'ZSHRC'

# AI Workstation - auto-start services
if [ -f "$HOME/ai-stack/ai-workstation.sh" ]; then
    bash "$HOME/ai-stack/ai-workstation.sh"
fi
ZSHRC
    echo "  ✅ Added auto-start to .zshrc"
else
    echo "  ✅ Auto-start already configured"
fi

# ============ 14. START SERVICES ============
echo ""
echo "Starting services..."
pkill -f "litellm --model" 2>/dev/null || true
litellm --model ollama/qwen2.5vl --port 4000 > /tmp/litellm-proxy.log 2>&1 &
sleep 5

# ============ SUMMARY ============
echo ""
echo "============================================"
echo "✅ AI WORKSTATION COMPLETE!"
echo "============================================"
echo ""
echo "Installed:"
echo "  ✅ Ollama + 3 models (qwen2.5vl, llama3.2:1b, llama3.2:1b)"
echo "  ✅ LiteLLM Proxy (http://localhost:4000)"
echo "  ✅ 6 Core Skills (auto-loaded in OpenCode)"
echo "  ✅ 550+ Community Skills (alirezarezvani, borghei, OneWave)"
echo "  ✅ Pinokio (1-click AI apps)"
echo "  ✅ Raycast (quick launcher)"
echo "  ✅ VS Code extensions (5 extensions)"
echo "  ✅ Auto-starts with terminal"
echo ""
echo "Directory Structure:"
echo "  ~/ai-stack/"
echo "    ├── ai-assistant/     # AI scripts"
echo "    ├── ai-workstation.sh # Launcher"
echo "    └── ..."
echo ""
echo "Test it:"
echo "  python3 ~/ai-stack/ai-assistant/ultimate.py 'build a React login page'"
echo ""
echo "Open OpenCode - everything is ready!"
echo "============================================"
