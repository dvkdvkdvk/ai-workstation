"""
YOUR LOCAL AI ASSISTANT - Complete System
100% FREE - Runs on Ollama + LiteLLM

Capabilities:
✅ Build apps & check/fix code (Qwen2.5-VL - layout analysis)
✅ Create high-end UIs (Pixtral 12B - flexible image ratios)
✅ Write professional text (Pixtral 12B - lightweight)
✅ Long context chat & multimodal reasoning (Llama 4 Scout - 10M tokens)
✅ Figma design review (Qwen2.5-VL - JSON grounding)
"""
import os
import json
from litellm import completion

api_base = "http://localhost:11434"

# Model Router - picks best model for each task
MODELS = {
    "code": "ollama/qwen2.5vl",           # Layout analysis & JSON grounding
    "build_app": "ollama/qwen2.5vl",       # App development
    "fix_code": "ollama/qwen2.5vl",        # Debug & fix
    "ui_design": "ollama/llama3.2:1b",     # Flexible image aspect ratios
    "figma": "ollama/qwen2.5vl",          # Layout analysis for Figma
    "text": "ollama/llama3.2:1b",           # Lightweight text generation
    "write": "ollama/llama3.2:1b",          # Writing tasks
    "web": "ollama/qwen2.5vl",            # Web tasks with layout analysis
    "chat": "ollama/llama3.2:1b",          # Ultra-long context chat (10M tokens)
    "multimodal": "ollama/llama3.2:1b",    # Native multimodal reasoning
}

def ask(task_type: str, prompt: str, system: str = None):
    """Smart routing to best model for the task"""
    model = MODELS.get(task_type, "ollama/qwen2.5vl")
    model_name = model.split('/')[-1]
    
    messages = []
    if system:
        messages.append({"role": "system", "content": system})
    messages.append({"role": "user", "content": prompt})
    
    print(f"🤖 Using: {model_name} | Task: {task_type}")
    
    response = completion(
        model=model,
        messages=messages,
        api_base=api_base,
    )
    return response.choices[0].message.content

# ============ EXAMPLE USAGES ============

print("="*60)
print("🚀 LOCAL AI ASSISTANT - Ready to Work!")
print("="*60 + "\n")

# 1. CODE EXPERT - Build an app
print("1. 🛠️  CODE EXPERT: Build a React todo app")
print("-"*60)
result = ask(
    "build_app",
    "Create a simple React todo app with add/delete functionality. Include TypeScript types."
)
print(f"{result}\n")

# 2. CODE REVIEW - Check & fix code  
print("2. 🔍 CODE REVIEW: Fix broken code")
print("-"*60)
broken_code = """
function addNumbers(a, b) {
    return a - b;  // Bug here
}
"""
result = ask(
    "fix_code",
    f"Review and fix this code:\n{broken_code}\nExplain the bug."
)
print(f"{result}\n")

# 3. UI DESIGN - High-end interface
print("3. 🎨 UI DESIGN: Modern dashboard layout")
print("-"*60)
result = ask(
    "ui_design",
    "Design a modern admin dashboard layout. Describe: header, sidebar, main content, widgets, colors, spacing."
)
print(f"{result}\n")

# 4. FIGMA - Edit/Review designs
print("4. 🎯 FIGMA HELPER: Design review")
print("-"*60)
result = ask(
    "figma",
    """Review this Figma design brief and suggest improvements:
    "Login page with email, password, and submit button. Blue theme."
    Include: layout tips, accessibility, UX improvements."""
)
print(f"{result}\n")

# 5. WRITE TEXT - Professional writing
print("5. ✍️  TEXT WRITING: Technical blog post")
print("-"*60)
result = ask(
    "write",
    "Write a 200-word blog post intro about the benefits of local AI models vs cloud APIs."
)
print(f"{result}\n")

print("="*60)
print("✅ ALL TASKS COMPLETE - 100% FREE & LOCAL!")
print("="*60)
print("""
Quick Commands:
  ask("code", "Your coding question")
  ask("ui_design", "Describe a component")
  ask("figma", "Review my design")
  ask("write", "Write something")
  ask("fix_code", "Debug this code...")
""")
