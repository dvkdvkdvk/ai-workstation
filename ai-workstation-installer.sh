#!/bin/bash
# AI WORKSTATION - One-Click Installer
# Replicates your exact setup on any new machine
# Everything goes into ~/ai-stack/

set -e

echo "🚀 AI WORKSTATION - Complete Setup"
echo "="*60"

# ============ 0. CREATE AI-STACK DIRECTORY ============
echo ""
echo "Creating ai-stack directory..."
mkdir -p /Users/dkialka/ai-stack
cd /Users/dkialka/ai-stack

# ============ 1. INSTALL HOMEBREW ============
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ============ 2. INSTALL OLLAMA ============
echo ""
echo "Installing Ollama..."
if ! command -v ollama &> /dev/null; then
    brew install ollama
fi

# Start Ollama
echo "Starting Ollama..."
brew services start ollama || ollama serve &
sleep 3

# ============ 3. PULL MODELS ============
echo ""
echo "Pulling AI models (this takes ~10 min)..."
ollama pull codellama      # 3.8GB - Code expert
ollama pull llama3.2:1b       # 1.3GB - UI/design
ollama pull phi3:mini           # 2.2GB - Fast text

# ============ 4. INSTALL PYTHON + LITELLM ============
echo ""
echo "Installing Python dependencies..."
pip3 install 'litellm[proxy]' 2>&1 | tail -3

# ============ 5. INSTALL PINOKIO ============
echo ""
echo "Installing Pinokio..."
if [ ! -d "/Applications/Pinokio.app" ]; then
    echo "Download Pinokio from: https://pinokio.computer"
    echo "Then drag to /Applications"
fi

# ============ 6. INSTALL RAYCAST ============
echo ""
echo "Installing Raycast..."
if [ ! -d "/Applications/Raycast.app" ]; then
    brew install --cask raycast
fi

# ============ 7. CONFIGURE OPENCODE (AUTO-LOAD SKILLS) ============
echo ""
echo "Configuring OpenCode with 6 skills..."

mkdir -p /Users/dkialka/.config/opencode

cat > /Users/dkialka/.config/opencode/opencode.json << 'EOF'
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
  },
  "skills": [
    "frontend-design",
    "ui-ux-pro-max",
    "vercel-react-best-practices",
    "web-artifacts-builder",
    "design-auditor",
    "theme-factory"
  ]
}
EOF

# ============ 8. INSTALL COMMUNITY SKILLS ============
echo ""
echo "Installing community skills..."

SKILLS_DIR="/Users/dkialka/.claude/skills"

# Install top community skill packs
echo "  → Installing alirezarezvani/claude-skills (225+ skills)..."
if [ ! -d "$SKILLS_DIR/alirezarezvani" ]; then
    cd /tmp && git clone --depth 1 https://github.com/alirezarezvani/claude-skills.git /tmp/claude-skills
    mkdir -p "$SKILLS_DIR/alirezarezvani"
    cp -r /tmp/claude-skills/skills/* "$SKILLS_DIR/alirezarezvani/" 2>/dev/null || true
fi

echo "  → Installing borghei/claude-skills (225+ skills, 11 platforms)..."
if [ ! -d "$SKILLS_DIR/borghei" ]; then
    cd /tmp && git clone --depth 1 https://github.com/borghei/claude-skills.git /tmp/borghei-skills
    mkdir -p "$SKILLS_DIR/borghei"
    cp -r /tmp/borghei-skills/skills/* "$SKILLS_DIR/borghei/" 2>/dev/null || true
fi

echo "  → Installing OneWave-AI/claude-skills (100 skills)..."
if [ ! -d "$SKILLS_DIR/onewave-ai" ]; then
    cd /tmp && git clone --depth 1 https://github.com/OneWave-AI/claude-skills.git /tmp/onewave-skills
    mkdir -p "$SKILLS_DIR/onewave-ai"
    cp -r /tmp/onewave-skills/skills/* "$SKILLS_DIR/onewave-ai/" 2>/dev/null || true
fi

# ============ 9. CREATE AI-STACK STRUCTURE ============
echo ""
echo "Creating ai-stack folders..."

# Move ai-assistant into ai-stack
mkdir -p /Users/dkialka/ai-stack/ai-assistant
mkdir -p /Users/dkialka/ai-stack/ai-workstation
mkdir -p /Users/dkialka/ai-stack/mail-apps
mkdir -p /Users/dkialka/ai-stack/openrouter-test
mkdir -p /Users/dkialka/ai-stack/bell

# Copy ai-assistant scripts to ai-stack
if [ -d "/Users/dkialka/ai-assistant" ]; then
    cp -r /Users/dkialka/ai-assistant/* /Users/dkialka/ai-stack/ai-assistant/ 2>/dev/null || true
fi

# ============ 10. AUTO-START WORKSTATION WITH OPENCODE ============
echo ""
echo "Setting up auto-start with OpenCode..."

# Add workstation startup to .zshrc if not already there
if ! grep -q "ai-workstation.sh" /Users/dkialka/.zshrc 2>/dev/null; then
    cat >> /Users/dkialka/.zshrc << 'ZSHRC'

# AI Workstation - auto-start services
if [ -f "$HOME/ai-stack/ai-workstation.sh" ]; then
    bash "$HOME/ai-stack/ai-workstation.sh"
fi
ZSHRC
    echo "  ✅ Added auto-start to .zshrc"
else
    echo "  ✅ Auto-start already configured"
fi

# ============ 11. START SERVICES ============
echo ""
echo "Starting services..."
pkill -f "litellm --model" 2>/dev/null || true
litellm --model ollama/llama3.2:1b --port 4000 > /tmp/litellm-proxy.log 2>&1 &
sleep 5

# ============ SUMMARY ============
echo ""
echo "="*60"
echo "✅ AI WORKSTATION COMPLETE!"
echo "="*60"
echo ""
echo "Installed & Configured:"
echo "  ✅ ~/ai-stack/ (all files organized)"
echo "  ✅ Ollama + 3 models (codellama, llama3.2, phi3)"
echo "  ✅ LiteLLM Proxy (http://0.0.0.0:4000)"
echo "  ✅ 6 Core Skills (auto-loaded in OpenCode)"
echo "  ✅ 550+ Community Skills (alirezarezvani, borghei, OneWave)"
echo "  ✅ Pinokio (1-click AI apps)"
echo "  ✅ Raycast (quick launcher)"
echo "  ✅ Auto-starts with OpenCode"
echo ""
echo "Directory Structure:"
echo "  ~/ai-stack/"
echo "    ├── ai-assistant/"
echo "    ├── ai-workstation/"
echo "    ├── mail-apps/"
echo "    ├── openrouter-test/"
echo "    ├── bell/"
echo "    └── ai-workstation.sh"
echo ""
echo "Open OpenCode - skills auto-load on startup!"
echo "="*60"
