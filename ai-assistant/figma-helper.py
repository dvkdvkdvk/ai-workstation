"""
AI Assistant - Figma Design Helper
Uses Ollama to generate/edit Figma designs via code
"""
import os
from litellm import completion

api_base = "http://localhost:11434"

def figa_design_task(prompt: str):
    """Generate Figma design suggestions"""
    model = "ollama/qwen2.5vl"
    print(f"Using model: {model.split('/')[-1]} for Figma task\n")
    
    response = completion(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        api_base=api_base,
    )
    return response.choices[0].message.content

print("="*60)
print("FIGMA AI ASSISTANT (100% FREE)")
print("="*60 + "\n")

# Example: Create a Figma design prompt
figma_prompt = """
Create a Figma design specification for a modern SaaS landing page:

1. Hero section layout
2. Color scheme (3 colors with hex codes)
3. Typography (heading + body font)
4. Key components needed
5. Spacing system (8px grid)

Keep it concise and actionable for a designer.
"""

print("Task: Generate Figma design spec for SaaS landing page")
print("-"*60)
result = figa_design_task(figma_prompt)
print(f"Design Spec:\n{result}\n")

print("="*60)
print("What this enables:")
print("="*60)
print("""
✅ Generate UI specifications
✅ Suggest component structures  
✅ Create design system docs
✅ Describe layouts for Figma implementation
✅ Review design briefs and provide feedback

Note: You implement in Figma based on AI suggestions
      (direct Figma API integration requires separate setup)
""")
