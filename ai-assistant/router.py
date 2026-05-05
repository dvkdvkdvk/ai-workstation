"""
AI Assistant Router - Picks the BEST model for each task
Uses 100% FREE local models via Ollama + LiteLLM
"""
import os
from litellm import completion

api_base = "http://localhost:11434"

# Model routing based on task type
MODEL_ROUTER = {
    "code": "ollama/codellama",            # Best for code tasks
    "ui": "ollama/llama3.2:1b",          # Good for UI/design
    "text": "ollama/phi3:mini",            # Fast for text writing
    "chat": "ollama/llama3.2:1b",         # General chat
    "math": "ollama/phi3:mini",            # Math/calculations
    "tools": "ollama/llama3.2:1b",        # Tool calling
    "figma": "ollama/llama3.2:1b",       # Figma design tasks
}

def ask_ai(task_type: str, prompt: str, tools=None):
    """Route to the best model for the task"""
    model = MODEL_ROUTER.get(task_type, "ollama/llama3.2:1b")
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
