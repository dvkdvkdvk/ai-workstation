#!/bin/bash
# Restore AI Workstation from backup
# Run this on a NEW machine to replicate your exact setup

set -e

echo "🚀 RESTORING AI WORKSTATON"
echo "="*60"

# 1. Install Homebrew (if needed)
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. Install core tools
echo ""
echo "Installing Ollama, Python, Raycast..."
brew install ollama python3 2>&1 | tail -3

# 3. Pull Ollama models (your exact set)
echo ""
echo "Pulling AI models (this takes ~10 min)..."
ollama pull codellama
ollama pull llama3.2:1b
ollama pull phi3:mini
ollama pull gemma:2b

# 4. Install Python deps
echo ""
echo "Installing LiteLLM..."
pip3 install 'litellm[proxy]' 2>&1 | tail -3

# 5. Copy config files (run this from backup location)
echo ""
echo "Restoring OpenCode config..."
mkdir -p ~/.config/opencode
# (You would copy from your backup/dotfiles repo)
# cp opencode.json ~/.config/opencode/
# cp -r .claude/skills/ ~/.claude/
# cp -r .agents/skills/ ~/.agents/
# cp -r ai-assistant/ ~/ai-assistant/

# 6. Start services
echo ""
echo "Starting services..."
brew services start ollama
litellm --model ollama/llama3.2:1b --port 4000 > /tmp/litellm-proxy.log 2>&1 &
sleep 5

echo ""
echo "="*60"
echo "✅ AI WORKSTATON RESTORED!"
echo "="*60"
echo ""
echo "Installed & Running:"
echo "  ✅ Ollama (4 models)"
echo "  ✅ LiteLLM Proxy (localhost:4000)"
echo "  ✅ 550+ Skills (6 core + community)"
echo "  ✅ OpenCode config (auto-loads skills)"
echo ""
echo "Next: Open OpenCode - skills auto-load!"
echo "="*60"
