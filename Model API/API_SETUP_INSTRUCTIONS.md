# API Setup Instructions for New Projects

## Quick Setup (Copy & Paste)

### 1. Create `.env` file in your new project:
```bash
cat > .env << 'EOF'
# API Keys for this project only
ANTHROPIC_API_KEY=sk-ant-api03-YOUR-KEY-HERE
OPENROUTER_API_KEY=sk-or-v1-YOUR-KEY-HERE
GOOGLE_API_KEY=AIzaSy-YOUR-KEY-HERE
XAI_API_KEY=xai-YOUR-KEY-HERE
OPENAI_API_KEY=sk-proj-YOUR-KEY-HERE

# Local Model Paths
QWEN3_MCP_PATH=/Users/kevinlappe/qwen3-mcp
OLLAMA_MODELS_PATH=/Users/kevinlappe/.ollama

# Local API Endpoints (for Ollama)
CUSTOM_API_URL=http://localhost:11434/v1
EOF
```

### 2. Create `load_env.sh` script:
```bash
cat > load_env.sh << 'EOF'
#!/bin/bash
# Source this file to load project-specific API keys
# Usage: source ./load_env.sh

if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
    echo "✅ Loaded API keys for this project"
    echo "Available providers:"
    [ -n "$ANTHROPIC_API_KEY" ] && echo "  • Anthropic (Claude)"
    [ -n "$OPENROUTER_API_KEY" ] && echo "  • OpenRouter (All models)"
    [ -n "$GOOGLE_API_KEY" ] && echo "  • Google (Gemini)"
    [ -n "$XAI_API_KEY" ] && echo "  • X.AI (Grok)"
    [ -n "$OPENAI_API_KEY" ] && echo "  • OpenAI (GPT-4, O3)"
    [ -n "$QWEN3_MCP_PATH" ] && echo "  • Qwen3 Local: $QWEN3_MCP_PATH"
    [ -n "$OLLAMA_MODELS_PATH" ] && echo "  • Ollama Models: $OLLAMA_MODELS_PATH"
else
    echo "❌ No .env file found in current directory"
fi
EOF
chmod +x load_env.sh
```

### 3. Create `.gitignore`:
```bash
cat > .gitignore << 'EOF'
# Environment variables
.env
load_env.sh

# API Keys - Never commit these!
*.key
*.secret
*api_key*

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Logs
*.log
EOF
```

### 4. Update Claude Desktop Configuration:
Edit `/Users/kevinlappe/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "claude-code-mcp-enhanced": {
      "command": "npx",
      "args": ["github:grahama1970/claude-code-mcp-enhanced"],
      "env": {
        "ANTHROPIC_API_KEY": "YOUR-ANTHROPIC-API-KEY",
        "CLAUDE_API_KEY": "YOUR-ANTHROPIC-API-KEY",
        "CLAUDE_MODEL": "claude-opus-4-1-20250805",
        "MCP_CLAUDE_DEBUG": "false",
        "MCP_HEARTBEAT_INTERVAL_MS": "15000",
        "MCP_EXECUTION_TIMEOUT_MS": "1800000",
        "PORT": "27125"
      },
      "executionTimeoutMs": 1800000
    },
    "zen": {
      "command": "/Users/kevinlappe/.local/bin/zen-mcp-server-wrapper",
      "args": [],
      "env": {
        "ANTHROPIC_API_KEY": "YOUR-ANTHROPIC-API-KEY",
        "OPENROUTER_API_KEY": "YOUR-OPENROUTER-API-KEY",
        "GOOGLE_API_KEY": "YOUR-GOOGLE-API-KEY",
        "XAI_API_KEY": "YOUR-XAI-API-KEY",
        "OPENAI_API_KEY": "YOUR-OPENAI-API-KEY",
        "PORT": "27126"
      },
      "executionTimeoutMs": 1800000
    }
  }
}
```

### 5. Load the environment:
```bash
source ./load_env.sh
```

## One-Line Setup Script

Copy and run this entire command to set up everything at once:

```bash
mkdir -p "$(pwd)" && \
cat > .env << 'EOF'
ANTHROPIC_API_KEY=sk-ant-api03-YOUR-KEY-HERE
OPENROUTER_API_KEY=sk-or-v1-YOUR-KEY-HERE
GOOGLE_API_KEY=AIzaSy-YOUR-KEY-HERE
XAI_API_KEY=xai-YOUR-KEY-HERE
OPENAI_API_KEY=sk-proj-YOUR-KEY-HERE
QWEN3_MCP_PATH=/Users/kevinlappe/qwen3-mcp
OLLAMA_MODELS_PATH=/Users/kevinlappe/.ollama
CUSTOM_API_URL=http://localhost:11434/v1
EOF
&& cat > load_env.sh << 'EOF'
#!/bin/bash
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
    echo "✅ Loaded API keys for this project"
else
    echo "❌ No .env file found"
fi
EOF
&& chmod +x load_env.sh && echo ".env" >> .gitignore && echo "load_env.sh" >> .gitignore && echo "✅ API setup complete! Run: source ./load_env.sh"
```

## Available Models After Setup

See `Models.md` for complete list of available models.

## Usage in Warp.dev or Claude Code

1. Navigate to your project directory
2. Run the setup commands above
3. Load environment: `source ./load_env.sh`
4. All models are now available through MCP servers

## Security Notes

⚠️ **NEVER commit `.env` file to git**
⚠️ **Keep API keys secure and rotate regularly**
⚠️ **The `.gitignore` file will prevent accidental commits**

## Testing Your Setup

After running `source ./load_env.sh`, test with:

```bash
# Check if keys are loaded
echo $ANTHROPIC_API_KEY | cut -c1-30
echo $OPENAI_API_KEY | cut -c1-30
echo $GOOGLE_API_KEY | cut -c1-20

# Test with curl (example for OpenAI)
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY" | head -n 5
```

## Troubleshooting

- **Keys not loading?** Make sure to use `source ./load_env.sh` not just `./load_env.sh`
- **Permission denied?** Run `chmod +x load_env.sh`
- **Working in new terminal?** You need to run `source ./load_env.sh` each session
- **MCP servers not working?** Restart Claude Desktop after updating configuration

---

*Generated: December 2024*
*For: Kevin Lappe's AI Development Environment*