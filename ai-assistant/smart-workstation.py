"""
SMART AI WORKSTATON - Auto-selects best model for EVERY query
Uses Ollama to run models, LiteLLM to route intelligently
"""
import os
import re
from litellm import completion

api_base = "http://localhost:11434"

# Model capabilities (learned from testing)
MODEL_CAPABILITIES = {
    "codellama": {
        "strengths": ["code", "debug", "refactor", "algorithm"],
        "speed": "medium",
        "quality": "high_code",
        "size": "3.8GB"
    },
    "llama3.2:1b": {
        "strengths": ["chat", "ui_design", "figma", "general", "summary"],
        "speed": "fast",
        "quality": "medium",
        "size": "1.3GB"
    },
    "phi3:mini": {
        "strengths": ["text", "write", "summarize", "fast_tasks"],
        "speed": "very_fast",
        "quality": "medium",
        "size": "2.2GB"
    },
    "gemma:2b": {
        "strengths": ["chat", "general", "creative"],
        "speed": "fast",
        "quality": "medium",
        "size": "1.7GB"
    }
}

# Smart router - auto-detects best model
def smart_ask(prompt: str, task_type: str = None, system: str = None):
    """
    Auto-selects best model based on task analysis.
    Override with task_type if you know what you want.
    """
    
    # Auto-detect task if not specified
    if task_type is None:
        task_type = detect_task_type(prompt)
    
    # Select best model for this task
    model = select_best_model(task_type)
    model_name = model.split('/')[-1]
    
    print(f"🤖 Auto-selected: {model_name}")
    print(f"   Task detected: {task_type}")
    print(f"   Reason: {get_selection_reason(task_type, model)}\n")
    
    messages = []
    if system:
        messages.append({"role": "system", "content": system})
    messages.append({"role": "user", "content": prompt})
    
    response = completion(
        model=model,
        messages=messages,
        api_base=api_base,
    )
    return response.choices[0].message.content

def detect_task_type(prompt: str) -> str:
    """Analyze prompt to detect task type"""
    prompt_lower = prompt.lower()
    
    # Code patterns
    code_keywords = ["code", "function", "class", "debug", "fix", "refactor", 
                    "react", "component", "javascript", "python", "typescript",
                    "bug", "error", "syntax", "compile", "test"]
    if any(kw in prompt_lower for kw in code_keywords):
        return "code"
    
    # UI/Design patterns
    ui_keywords = ["ui", "design", "component", "layout", "figma", "dashboard",
                   "page", "interface", "style", "css", "tailwind", "shadcn"]
    if any(kw in prompt_lower for kw in ui_keywords):
        return "ui_design"
    
    # Writing patterns
    write_keywords = ["write", "email", "blog", "article", "document", 
                      "text", "content", "copy", "paragraph"]
    if any(kw in prompt_lower for kw in write_keywords):
        return "text"
    
    # Figma patterns
    if "figma" in prompt_lower:
        return "figma"
    
    # Default to general chat
    return "chat"

def select_best_model(task_type: str) -> str:
    """Select best Ollama model for task type"""
    mapping = {
        "code": "ollama/codellama",
        "ui_design": "ollama/llama3.2:1b",
        "figma": "ollama/llama3.2:1b",
        "text": "ollama/phi3:mini",
        "write": "ollama/phi3:mini",
        "chat": "ollama/llama3.2:1b",
        "general": "ollama/llama3.2:1b"
    }
    return mapping.get(task_type, "ollama/llama3.2:1b")

def get_selection_reason(task_type: str, model: str) -> str:
    """Explain why this model was selected"""
    model_name = model.split('/')[-1]
    caps = MODEL_CAPABILITIES.get(model_name, {})
    strengths = caps.get("strengths", [])
    return f"Best for: {', '.join(strengths[:3])}"

# ============ EXAMPLES ============

print("="*60)
print("🚀 SMART AI WORKSTATON - Auto Model Selection")
print("="*60 + "\n")

# Test 1: Auto-detect code task
print("Test 1: Auto-detecting task type...")
result = smart_ask("Write a React component for a login form")
print(f"Result: {result[:100]}...\n")

# Test 2: Auto-detect UI task
print("Test 2: Auto-detecting task type...")
result = smart_ask("Design a modern dashboard layout with dark mode")
print(f"Result: {result[:100]}...\n")

# Test 3: Auto-detect writing task
print("Test 3: Auto-detecting task type...")
result = smart_ask("Write a professional email to follow up after a job interview")
print(f"Result: {result[:100]}...\n")

# Test 4: Override with specific task
print("Test 4: Manual override...")
result = smart_ask("Explain quantum computing", task_type="text")
print(f"Result: {result[:100]}...\n")

print("="*60)
print("✅ SMART WORKSTATON READY!")
print("="*60)
print("""
Just use smart_ask("your query") - it auto-selects the best model!

Examples:
  smart_ask("Build me a React login page")     # → codellama
  smart_ask("Design a landing page")           # → llama3.2:1b  
  smart_ask("Write a blog post")               # → phi3:mini
  smart_ask("Review my Figma design")         # → llama3.2:1b

Override: smart_ask("query", task_type="code")
""")
