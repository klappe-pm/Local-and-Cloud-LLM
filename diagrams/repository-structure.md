# Repository Structure Documentation

## Diagram-Folder Tree

### GitHub Repository Structure (Public)
```
Local-and-Cloud-LLM/
├── diagrams/
│   └── repository-structure.md
├── github/
│   ├── GITHUB_PUSH_INSTRUCTIONS.md
│   └── scripts/
│       └── github-setup.sh
├── Model API/
│   ├── API_SETUP_INSTRUCTIONS.md
│   ├── Models.md
│   └── README.md
├── orchestrator/
│   ├── __init__.py
│   ├── agents/
│   ├── decomposer/
│   │   └── prompt_analyzer.py
│   ├── executors/
│   ├── router/
│   └── templates/
├── src/
│   ├── api/
│   ├── data/
│   ├── models/
│   └── utils/
├── tests/
├── .env.example
├── .gitignore
├── LICENSE
└── README.md
```

### Local Development Structure (Complete)
```
Local-and-Cloud-LLM/
├── .claude/
├── .trash/
│   └── scripts/
├── 0-Inbox/
├── 1-Tasks/
├── 2-Roadmap/
├── config/
├── diagrams/
│   └── repository-structure.md
├── docker/
├── github/
│   ├── GITHUB_PUSH_INSTRUCTIONS.md
│   └── scripts/
│       └── github-setup.sh
├── Model API/
│   ├── API_SETUP_INSTRUCTIONS.md
│   ├── Models.md
│   └── README.md
├── orchestrator/
│   ├── __init__.py
│   ├── agents/
│   ├── decomposer/
│   │   └── prompt_analyzer.py
│   ├── executors/
│   ├── router/
│   └── templates/
├── prompts/
│   ├── examples/
│   └── templates/
├── src/
│   ├── api/
│   ├── data/
│   ├── models/
│   └── utils/
├── tests/
├── z-gitignore/               # EXCLUDED FROM GITHUB
│   ├── architecture/
│   │   └── SECRETS_MANAGEMENT.md
│   ├── cloud/
│   ├── keys/                  # API KEYS - NEVER SYNC
│   │   ├── Claude API Key.md
│   │   ├── Gemini API Key.md
│   │   ├── Grok API Key.md
│   │   ├── OpenAI API Key.md
│   │   └── OpenRouter API Key.md
│   ├── notebooks/
│   ├── notes/
│   ├── outputs/
│   ├── requirements/
│   │   ├── GITIGNORE_REQUIREMENTS.md
│   │   ├── Open Requirements.md
│   │   └── Project Initialization.md
│   ├── x-Templates/
│   ├── y-Archive/
│   └── z-Meta/
├── .env                       # LOCAL ONLY
├── .env.example
├── .gitignore
├── LICENSE
└── README.md
```

## Diagram-File Tree

### Core Functional Files (GitHub)
```
Configuration Files:
├── .env.example                    # Template for API keys
├── .gitignore                      # Security patterns
└── LICENSE                         # MIT license

Documentation:
├── README.md                       # Main project documentation
├── Model API/
│   ├── README.md                   # API documentation overview
│   ├── API_SETUP_INSTRUCTIONS.md  # Setup guide for new projects
│   └── Models.md                   # Available models reference
└── diagrams/
    └── repository-structure.md     # This file

GitHub Integration:
├── github/
│   ├── GITHUB_PUSH_INSTRUCTIONS.md
│   └── scripts/
│       └── github-setup.sh

Core Application:
├── orchestrator/
│   ├── __init__.py
│   ├── decomposer/
│   │   └── prompt_analyzer.py
│   └── [other components]/
├── src/
│   ├── api/                        # API interface modules
│   ├── data/                       # Data processing
│   ├── models/                     # Model configurations
│   └── utils/                      # Utility functions
└── tests/                          # Test suites
```

### Personal/Development Files (Local Only)
```
Personal API Keys (z-gitignore/keys/):
├── Claude API Key.md               # Anthropic API key
├── Gemini API Key.md               # Google API key
├── Grok API Key.md                 # X.AI API key
├── OpenAI API Key.md               # OpenAI API key
└── OpenRouter API Key.md           # OpenRouter API key

Personal Documentation (z-gitignore/):
├── architecture/
│   └── SECRETS_MANAGEMENT.md       # Personal security notes
├── requirements/
│   ├── GITIGNORE_REQUIREMENTS.md   # Security best practices
│   ├── Open Requirements.md        # Open tasks
│   └── Project Initialization.md   # Personal setup notes
├── notebooks/                      # Jupyter notebooks
├── notes/                          # Personal notes
├── outputs/                        # Generated content
└── [personal folders]/

Development Environment:
├── .env                            # Actual API keys (never sync)
├── 0-Inbox/                        # Obsidian inbox
├── 1-Tasks/                        # Task management
├── 2-Roadmap/                      # Project planning
├── .claude/                        # Claude Desktop config
├── .trash/                         # Obsidian trash
├── config/                         # Local configurations
├── docker/                         # Docker files
└── prompts/                        # Prompt templates and examples
```

### File Categories Summary

**Always Sync to GitHub:**
- Core application code (`orchestrator/`, `src/`)
- Public documentation (`README.md`, `Model API/`)
- Configuration templates (`.env.example`)
- Setup scripts (`github/scripts/`)
- Tests (`tests/`)

**Never Sync to GitHub:**
- API keys (`z-gitignore/keys/`)
- Personal notes and documentation (`z-gitignore/`)
- Local environment files (`.env`)
- Obsidian-specific folders (`.obsidian/`, `.trash/`, `0-Inbox/`, etc.)
- Local development artifacts

**Purpose:**
This structure enables a clean, secure, reusable architecture that separates personal/sensitive data from the functional codebase that can be shared across projects.