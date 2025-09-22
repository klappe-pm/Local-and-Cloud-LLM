# Local and Cloud LLM Development Environment

A comprehensive AI development environment integrating local and cloud-based Large Language Models (LLMs) with MCP server orchestration.

## 🚀 Overview

This repository contains configuration and documentation for managing multiple AI model providers through a unified interface, including:

- **Cloud Providers**: Anthropic Claude, Google Gemini, OpenAI GPT-4, X.AI Grok
- **Local Models**: Ollama-managed models (Qwen, CodeLlama, Llama)
- **MCP Integration**: Claude Desktop with enhanced MCP servers
- **API Management**: Secure, project-specific API key configuration

## 📋 Features

- ✅ Multi-provider AI model access
- ✅ Secure API key management
- ✅ MCP server integration for Claude Desktop
- ✅ Local model support via Ollama
- ✅ Comprehensive documentation and setup guides
- ✅ Git-ready with security best practices

## 🗂 Project Structure

See the complete repository structure documentation in the [diagrams folder](diagrams/repository-structure.md), which includes:
- GitHub repository structure (public files)
- Local development structure (complete)
- File organization by category
- Security and sync guidelines

## 🛠 Quick Setup

### 1. Clone the Repository

```bash
git clone https://github.com/klappe-pm/Local-and-Cloud-LLM.git
cd "Local and Cloud LLM"
```

### 2. Set Up API Keys

```bash
# Create .env file with your API keys
cp .env.example .env
# Edit .env with your actual keys

# Load environment
source ./load_env.sh
```

### 3. Configure Claude Desktop

Update MCP servers in Claude Desktop configuration:
- Location: `~/Library/Application Support/Claude/claude_desktop_config.json`
- See `Model API/API_SETUP_INSTRUCTIONS.md` for detailed configuration

### 4. Install Local Models (Optional)

```bash
# Install Ollama
brew install ollama

# Pull models
ollama pull llama3.2
ollama pull codellama:34b
ollama pull qwen2.5-coder:32b  # Large model - 19GB
```

## 🔑 Available Providers

| Provider | Models | Status | Access Method |
|----------|--------|--------|---------------|
| Google Gemini | Flash, Pro | ✅ Active | MCP Zen Server |
| OpenAI | GPT-4.1, O3, O4 | ✅ Active | MCP Zen Server |
| X.AI | Grok-3 | ✅ Active | MCP Zen Server |
| Anthropic | Claude Opus 4.1 | ✅ Active | Claude Desktop |
| Local/Ollama | Llama, CodeLlama, Qwen | ✅ Active | localhost:11434 |
| OpenRouter | Multiple | 🔴 Configured | Not detected by MCP |

## 📚 Documentation

- **[API Setup Instructions](API%20Key%20Set-up%20Guide.md)**: Complete setup guide
- **[Available Models](Models.md)**: Model reference and selection guide
- **[Repository Structure](diagrams/repository-structure.md)**: Complete folder and file organization

## 🔒 Security

This project follows security best practices:

- API keys are stored in `.env` files (never committed)
- Comprehensive `.gitignore` prevents credential leaks
- Project-specific configuration (not global)
- Regular key rotation recommended

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

**Important**: Never commit API keys or sensitive information!

## 📝 License

MIT License - See [LICENSE](LICENSE) file for details

## 👤 Author

Kevin Lappe

## 🔗 Links

- [Claude Desktop](https://claude.ai)
- [Ollama](https://ollama.ai)
- [MCP Protocol](https://modelcontextprotocol.io)

---

*Last Updated: December 2024*
