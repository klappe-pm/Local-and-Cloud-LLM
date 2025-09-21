# Git Ignore Requirements & Best Practices

*Essential .gitignore configuration for AI development projects*

## 🚨 Critical Security Requirements

### MUST IGNORE - Security Critical
These patterns MUST be in every .gitignore to prevent credential leaks:

```gitignore
# Environment variables and secrets
.env
.env.*
.env.local
.env.production
.env.development
*.env

# API Keys and credentials
*api_key*
*apikey*
*.key
*.pem
*.cert
*.secret
*credentials*
*token*
secrets/
keys/

# Configuration files with potential secrets
config.json
config.local.json
settings.local.json
claude_desktop_config.json
```

## ⚠️ CRITICAL: Obsidian Projects

**IMPORTANT**: For Obsidian-based projects, ALWAYS exclude:
- `.obsidian/` - Contains workspace configs, plugins, and user-specific settings
- `.trash/` - Contains deleted files that shouldn't be in version control

## 📁 Project-Specific Patterns

### AI/ML Project Files
```gitignore
# Model files (often large)
*.ckpt
*.h5
*.pkl
*.pt
*.pth
*.safetensors
*.bin
models/
checkpoints/

# Dataset files
data/
datasets/
*.csv
*.parquet
*.tfrecord

# Jupyter/IPython
.ipynb_checkpoints/
*.ipynb_checkpoints
*-checkpoint.ipynb

# Vector databases
*.faiss
*.ann
embeddings/
vectordb/
```

### Development Environment
```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
.venv
pip-log.txt
pip-delete-this-directory.txt
.pytest_cache/
.coverage
*.cover
.hypothesis/

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*
package-lock.json
yarn.lock
pnpm-lock.yaml

# Build outputs
dist/
build/
*.egg-info/
.eggs/
target/
out/
```

### IDE & Editor Files
```gitignore
# Visual Studio Code
.vscode/
*.code-workspace
.history/

# JetBrains IDEs
.idea/
*.iml
*.iws
*.ipr
.idea_modules/

# Sublime Text
*.sublime-project
*.sublime-workspace

# Vim
*.swp
*.swo
*~
.netrwhist

# Emacs
*~
\#*\#
.\#*
```

### Operating System Files
```gitignore
# macOS
.DS_Store
.AppleDouble
.LSOverride
._*
.Spotlight-V100
.Trashes

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini
$RECYCLE.BIN/
*.lnk

# Linux
.directory
.Trash-*
```

### Logs & Temporary Files
```gitignore
# Logs
*.log
logs/
*.log.*
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Temporary files
*.tmp
*.temp
*.bak
*.backup
*.old
.tmp/
tmp/
temp/
```

### Local Development Files
```gitignore
# Local environment scripts
load_env.sh
setup_local.sh
*.local.sh

# Local configuration
*.local
local_settings.py
config.local.js
settings.local.json

# Development databases
*.sqlite
*.sqlite3
*.db
db.sqlite3
local.db
```

## 📋 Complete Template for AI Projects

Here's a comprehensive .gitignore template for AI/ML projects:

```gitignore
# ========================================
# SECURITY CRITICAL - NEVER COMMIT THESE
# ========================================

# Environment variables and secrets
.env
.env.*
*.env
!example.env

# API Keys and credentials
*api_key*
*apikey*
*.key
*.pem
*.cert
*.secret
*credentials*
*token*
secrets/
keys/

# Configuration with potential secrets
config.json
config.local.json
settings.local.json
claude_desktop_config.json

# ========================================
# AI/ML SPECIFIC
# ========================================

# Model files
*.ckpt
*.h5
*.pkl
*.pt
*.pth
*.safetensors
*.bin
models/
checkpoints/
weights/

# Datasets
data/
datasets/
*.csv
*.parquet
*.tfrecord
raw_data/

# Jupyter
.ipynb_checkpoints/
*-checkpoint.ipynb

# Vector databases
*.faiss
*.ann
embeddings/
vectordb/
chromadb/

# ========================================
# DEVELOPMENT
# ========================================

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
.venv
*.egg-info/
.pytest_cache/
.coverage
htmlcov/

# Node.js
node_modules/
npm-debug.log*
yarn-error.log*
package-lock.json
yarn.lock
pnpm-lock.yaml

# Build outputs
dist/
build/
out/
target/

# ========================================
# IDE & EDITORS
# ========================================

# VS Code
.vscode/
*.code-workspace

# JetBrains
.idea/
*.iml

# Others
*.sublime-*
*.swp
*~

# ========================================
# OS FILES
# ========================================

# macOS
.DS_Store
._*

# Windows
Thumbs.db
Desktop.ini

# Linux
.directory

# ========================================
# LOGS & TEMP
# ========================================

# Logs
*.log
logs/
*.log.*

# Temporary
*.tmp
*.temp
*.bak
tmp/
temp/

# ========================================
# LOCAL DEVELOPMENT
# ========================================

# Local scripts
load_env.sh
setup_local.sh
*.local.sh

# Local configs
*.local
local_settings.*

# Local databases
*.sqlite
*.sqlite3
*.db
local.db

# ========================================
# PROJECT SPECIFIC (customize as needed)
# ========================================

# MCP servers
mcp-servers.log

# Ollama models
.ollama/

# Cache
.cache/
__pycache__/
```

## 🔧 Usage Instructions

### Creating a New .gitignore
1. Copy the complete template above
2. Save as `.gitignore` in your project root
3. Customize the PROJECT SPECIFIC section
4. Commit the .gitignore file (but never the ignored files!)

### Adding to Existing .gitignore
```bash
# Append security-critical patterns
cat >> .gitignore << 'EOF'
# Security - NEVER COMMIT
.env
*.key
*api_key*
*credentials*
EOF
```

### Verifying .gitignore Works
```bash
# Check if files are being ignored
git status --ignored

# Check what would be added
git add --dry-run .

# Remove already tracked files that should be ignored
git rm --cached filename
```

## ⚠️ Common Mistakes to Avoid

### 1. Adding Secrets Before .gitignore
**Problem**: Files tracked before adding .gitignore remain in history
**Solution**: 
```bash
git rm --cached .env
git commit -m "Remove tracked .env file"
```

### 2. Using Weak Patterns
**Bad**: `api_key.txt` (too specific)
**Good**: `*api_key*` (catches variations)

### 3. Forgetting Local Variants
**Bad**: Only ignoring `.env`
**Good**: Ignoring `.env*` to catch `.env.local`, `.env.prod`, etc.

### 4. Not Ignoring Large Files
**Important**: Add model files (`*.pkl`, `*.h5`) before they're committed

### 5. Ignoring Too Much
**Don't ignore**:
- `requirements.txt` / `package.json` (needed for dependencies)
- `README.md` (project documentation)
- `.gitignore` itself
- Example/template files (like `example.env`)

## 🛡️ Security Best Practices

### 1. Defense in Depth
- Use multiple patterns for the same sensitive data
- Include both specific files and wildcards
- Consider folder-level ignores for sensitive directories

### 2. Regular Audits
```bash
# Find potentially sensitive files
find . -name "*key*" -o -name "*secret*" -o -name "*.pem"

# Check git history for secrets
git log --name-only --diff-filter=A | grep -E "(key|secret|token|password)"
```

### 3. Pre-commit Hooks
Install a pre-commit hook to check for secrets:
```bash
# Install pre-commit
pip install pre-commit

# Add to .pre-commit-config.yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
```

### 4. Use Example Files
Instead of committing actual config:
```bash
# Create example file
cp .env .env.example
# Edit .env.example to remove actual values
# Commit .env.example, ignore .env
```

## 📝 Project-Specific Additions

For Kevin's AI Development Environment, also consider:

```gitignore
# Claude Desktop
claude_desktop_config.json
.claude/

# MCP Servers
mcp-servers.log
*.mcp.log

# Qwen3 local
qwen3-mcp/

# Ollama
.ollama/
ollama.log

# IMPORTANT: Obsidian Configuration
# The entire .obsidian folder should be excluded
.obsidian/
.trash/

# Alternative (if you want to track some configs):
# .obsidian/workspace.json
# .obsidian/workspace-mobile.json
```

## 🔍 Validation Checklist

Before committing, verify:
- [ ] No `.env` files will be committed
- [ ] No files with "key", "secret", "token" in the name
- [ ] No configuration files with credentials
- [ ] Large model files are ignored
- [ ] OS-specific files are ignored
- [ ] IDE settings are ignored
- [ ] Temporary and log files are ignored
- [ ] Local development scripts are ignored

---

*Remember: It's easier to prevent leaking secrets than to remove them from git history!*

*Last Updated: December 2024*