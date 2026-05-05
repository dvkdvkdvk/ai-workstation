"""
AI Assistant Router - Picks the BEST model for each task
Uses 100% FREE local models via Ollama + LiteLLM

Models: qwen2.5vl (layout analysis), llama3.2:1b (10M context), llama3.2:1b (flexible vision)
"""
import os
from litellm import completion

api_base = "http://localhost:11434"

# Model routing based on task type
MODEL_ROUTER = {
    "code": "ollama/qwen2.5vl",            # Layout analysis & JSON grounding
    "ui": "ollama/llama3.2:1b",            # Flexible image aspect ratios
    "text": "ollama/llama3.2:1b",           # Lightweight text generation
    "chat": "ollama/llama3.2:1b",          # Ultra-long context (10M tokens)
    "math": "ollama/qwen2.5vl",           # Layout analysis for math
    "tools": "ollama/llama3.2:1b",         # Native multimodal reasoning
    "figma": "ollama/qwen2.5vl",          # Layout analysis for Figma
    "multimodal": "ollama/llama3.2:1b",    # Native multimodal reasoning
}

def ask_ai(task_type: str, prompt: str, tools=None):
    """Route to the best model for the task"""
    model = MODEL_ROUTER.get(task_type, "ollama/qwen2.5vl")
    print(f"Using model: {model.split('/')[-1]} (task: {task_type})")
    
    kwargs = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "api_base": api_base,
    }
    if tools:
        kwargs["tools"] = tools
        kwargs["tool_choice"] = "auto"
    
    response = completion(**kwargs)
    return response.choices[0].message.content

print("="*60)
print("LOCAL AI ASSISTANT - Task Router")
print("="*60 + "\n")

# Test different tasks
print("1. CODE TASK: Write a React component")
print("-"*60)
result = ask_ai("code", "Write a simple React button component with TypeScript")
print(f"Result:\n{result}\n")

print("2. UI TASK: Design a landing page")
print("-"*60)
result = ask_ai("ui", "Describe a modern landing page layout for a SaaS product")
print(f"Result:\n{result}\n")

print("3. TEXT TASK: Write a professional email")
print("-"*60)
result = ask_ai("text", "Write a follow-up email after a job interview")
print(f"Result:\n{result}\n")

print("="*60)
print("Available Models:")
print("="*60)
import os
os.system("ollama list")
