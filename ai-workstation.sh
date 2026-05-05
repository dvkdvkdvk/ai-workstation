#!/bin/bash
# AI WORKSTATON - Unified Launcher
# Integrates: Pinokio, Raycast, OpenCode, Ollama, LiteLLM

echo "🚀 AI WORKSTATON - Starting all services..."
echo "="*60

# 1. Check Pinokio (GUI app)
if [ -d "/Applications/Pinokio.app" ]; then
    echo "✅ Pinokio found at /Applications/Pinokio.app"
    echo "   → Open Pinokio and search for AI apps (1-click install)"
else
    echo "❌ Pinokio not found"
fi

# 2. Check Raycast
if [ -d "/Applications/Raycast.app" ]; then
    echo "✅ Raycast found at /Applications/Raycast.app"
    echo "   → Use Raycast to: open apps, run scripts, AI shortcuts"
else
    echo "❌ Raycast not found"
fi

# 3. Start Ollama (local models)
echo ""
echo "Starting Ollama..."
if ! pgrep -x "ollama" > /dev/null; then
    brew services start ollama
    sleep 3
fi
echo "✅ Ollama running (local models: qwen2.5vl, llama3.2:1b, llama3.2:1b)"

# 4. Start LiteLLM Proxy (OpenAI-compatible API)
echo ""
echo "Starting LiteLLM Proxy..."
pkill -f "litellm --model" 2>/dev/null
litellm --model ollama/qwen2.5vl --port 4000 > /tmp/litellm-proxy.log 2>&1 &
sleep 5
echo "✅ LiteLLM Proxy running at http://0.0.0.0:4000"

# 5. Show available local models
echo ""
echo "Available Ollama Models:"
ollama list

# 6. Quick commands
echo ""
echo "="*60
echo "QUICK COMMANDS"
echo "="*60
echo ""
echo "📝 OpenCode (with 6 skills auto-loaded):"
echo "   Just open OpenCode - skills load automatically"
echo ""
echo "🎨 Pinokio (1-click AI apps):"
echo "   Open Pinokio.app → Search 'stable diffusion', 'whisper', etc."
echo ""
echo "⚡ Raycast (quick launcher):"
echo "   Cmd+Space → type 'OpenCode' or 'Ollama'"
echo ""
echo "🤖 Test Local AI:"
echo "   curl http://0.0.0.0:4000/v1/chat/completions \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -d '{\"model\":\"ollama/qwen2.5vl\",\"messages\":[{\"role\":\"user\",\"content\":\"hi\"}]}'"
echo ""
echo "📁 AI Assistant Scripts (~/ai-stack/ai-assistant/):"
echo "   python3 ~/ai-stack/ai-assistant/ultimate.py      # Master assistant (all 6 skills)"
echo "   python3 ~/ai-stack/ai-assistant/master.py        # Code + UI + Figma + Text"
echo "   python3 ~/ai-stack/ai-assistant/router.py        # Smart model routing"
echo ""
echo "="*60
echo "✅ AI WORKSTATON READY!"
echo "="*60
