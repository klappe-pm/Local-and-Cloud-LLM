---
dateCreated: 2025-09-21
dateRevised: 2025-09-21
---
# Available AI Models

## Currently Active Providers (via MCP Servers)

### 1. Google Gemini ✅
**Provider**: Google AI
**Access**: Direct API via Zen MCP

| Model | Context | Description | Aliases |
|-------|---------|-------------|---------|
| `gemini-2.0-flash` | 1M | Latest fast model | `flash2`, `flash-2.0` |
| `gemini-2.0-flash-lite` | 1M | Lightweight model | `flash-lite`, `flashlite` |
| `gemini-2.5-flash` | 1M | Ultra-fast processing | `flash`, `flash2.5` |
| `gemini-2.5-pro` | 1M | Extended reasoning with thinking mode | `pro`, `gemini-pro` |

### 2. OpenAI ✅
**Provider**: OpenAI
**Access**: Direct API via Zen MCP

| Model | Context | Description | Aliases |
|-------|---------|-------------|---------|
| `gpt-4.1-2025-04-14` | 1M | Advanced reasoning, complex analysis | `gpt4.1` |
| `o3` | 200K | Logical problems, systematic analysis | - |
| `o3-mini` | 200K | Balanced performance/speed | `o3mini` |
| `o3-pro-2025-06-10` | 200K | ⚠️ Professional grade (expensive) | `o3-pro` |
| `o4-mini` | 200K | Optimized for shorter contexts | `mini`, `o4mini` |

### 3. X.AI (Grok) ✅
**Provider**: X.AI
**Access**: Direct API via Zen MCP

| Model | Context | Description | Aliases |
|-------|---------|-------------|---------|
| `grok-3` | 131K | Advanced reasoning and analysis | `grok` |
| `grok-3-fast` | 131K | Higher performance variant | `grokfast`, `grok3-fast` |

### 4. Local Models (Ollama) ✅
**Provider**: Local/Ollama
**Access**: localhost:11434

| Model | Context | Description | Aliases |
|-------|---------|-------------|---------|
| `llama3.2` | 128K | Local Llama model | `local`, `local-llama`, `ollama-llama` |
| `codellama:34b` | 16K | Specialized for code | `codellama`, `code-llama` |

### 5. Anthropic Claude 🟡
**Provider**: Anthropic
**Access**: Via Claude Desktop (you're using Opus 4.1 right now!)

| Model | Context | Description | Status |
|-------|---------|-------------|--------|
| `claude-opus-4-1-20250805` | 200K | Most capable Claude model | ✅ Active (current session) |
| Claude 3.5 Sonnet | 200K | Latest Sonnet model | ❌ Requires direct integration |
| Claude 3 Opus | 200K | Previous Opus version | ❌ Requires direct integration |

### 6. OpenRouter 🔴
**Provider**: OpenRouter (Gateway)
**Access**: Not currently detected by MCP
**Note**: API key configured but not recognized by Zen MCP server

Would provide access to:
- All Claude models
- GPT-4 Turbo
- Mistral models
- Llama models
- 100+ other models

## Model Selection Guide

### For Code Generation
- **Best**: `gpt-4.1-2025-04-14`, Claude Opus 4.1 (current)
- **Fast**: `gemini-2.5-flash`, `o4-mini`
- **Local**: `codellama:34b`

### For Analysis & Reasoning
- **Best**: Claude Opus 4.1 (current), `o3`, `grok-3`
- **Balanced**: `gemini-2.5-pro`, `o3-mini`
- **Fast**: `gemini-2.5-flash`

### For Quick Tasks
- **Fastest**: `gemini-2.0-flash-lite`
- **Good Balance**: `o4-mini`, `gemini-2.5-flash`
- **Local**: `llama3.2`

### For Extended Context (>200K)
- **Best**: `gpt-4.1-2025-04-14` (1M), `gemini-2.5-pro` (1M)
- **Fast**: `gemini-2.5-flash` (1M)

## Usage Examples

### Via MCP Zen Server
```bash
# Using chat tool
mcp__zen__chat --model gemini-2.5-flash "Your prompt"
mcp__zen__chat --model gpt4.1 "Complex analysis task"
mcp__zen__chat --model grok-3 "Reasoning task"

# Using aliases
mcp__zen__chat --model flash "Quick task"
mcp__zen__chat --model pro "Deep analysis"
mcp__zen__chat --model mini "Balanced task"
```

### Via Direct API (with loaded environment)
```python
# OpenAI
from openai import OpenAI
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# Google Gemini
import google.generativeai as genai
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

# X.AI Grok
# Use OpenAI-compatible client with base_url="https://api.x.ai/v1"
```

## Cost Considerations

### Most Expensive
- `o3-pro-2025-06-10` - Professional grade, use sparingly
- `gpt-4.1-2025-04-14` - Premium pricing for 1M context

### Moderate Cost
- `o3`, `grok-3` - Standard reasoning model pricing
- `gemini-2.5-pro` - Google's premium tier

### Cost-Effective
- `gemini-2.5-flash`, `o3-mini`, `o4-mini`
- Good balance of performance and cost

### Free/Local
- `llama3.2`, `codellama:34b` - Run locally, no API costs
- Resource cost: local compute only

## Troubleshooting

### Model Not Available?
1. Check if API key is loaded: `echo $PROVIDER_API_KEY`
2. Restart Claude Desktop after config changes
3. Verify MCP server is running: `ps aux | grep mcp`

### OpenRouter Not Working?
- Currently not detected by Zen MCP server
- Consider using direct API integration instead

### Want Direct Claude API Access?
- Current setup uses Claude through Claude Desktop
- For external Claude access, need different MCP server or direct SDK

## Configuration Files

- **MCP Config**: `/Users/kevinlappe/Library/Application Support/Claude/claude_desktop_config.json`
- **API Keys**: Project `.env` file or shell environment
- **Zen MCP**: `/Users/kevinlappe/zen-mcp-server/`
- **Ollama Models**: `/Users/kevinlappe/.ollama/`

---

*Note: Model availability and pricing subject to change. Always verify current status with provider documentation.*