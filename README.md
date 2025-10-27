# Agnostic AI - Unified Configuration for AI Coding Tools

> **🚀 Ultra-Simple Setup** - One command, choose your IDE, and you're ready to code with AI!

> Share one AI configuration across all your AI coding tools - write once, use everywhere

## ⚡ TLDR - Quick Start

```bash
# 1. Install agnostic-ai
curl -fsSL https://raw.githubusercontent.com/betagouv/agnostic-ai/main/install.sh | bash

# 2. Migrate your existing documentation (optional)
.ai/cli migrate             # Shows instructions

# 3. Use commands to build features
# In your IDE (Claude Code/Cursor):
/core:feature-create        # Scaffold new features with EPCT methodology
/core:command-create        # Create custom commands
/core:agent-create          # Create specialized agents

# 4. Enable MCP servers (optional - AI superpowers!)
.ai/cli mcp install         # Install MCP templates
.ai/cli mcp list            # See available servers (GitHub, Notion, Airtable, etc.)
.ai/cli mcp use github      # Enable GitHub MCP server
.ai/cli mcp unuse github    # Disable when not needed (saves tokens!)
```

**That's it!** Your AI configuration is ready and version-controlled in `.ai/`

## 🎯 The Problem

Modern development teams face a configuration nightmare when using AI assistants:

**Different IDEs, Different Configs** 🤯
- Your team uses Claude Code, Cursor, Windsurf, or other AI tools
- Each tool requires its own configuration format
- You end up duplicating commands, agents, and guidelines across tools
- Changes need to be manually synced everywhere
- No single source of truth = configuration drift

## ✨ The Solution

**AI CLI provides a single `.ai/` folder that works with all AI coding tools**, with a **modular plugin system** to install only what you need.

### Key Benefits

- ✅ **Ultra-fast setup** - One question: which IDE?
- ✅ **Modular plugins** - Install only what you need
- ✅ **Write once, use everywhere** - One configuration, all IDEs
- ✅ **Git-friendly** - Commit only `.ai/`, configs are generated
- ✅ **Easy updates** - `.ai/cli update` to get latest
- ✅ **Team synchronization** - Everyone gets the same setup
- ✅ **Works everywhere** - Any bash system (macOS, Linux, WSL)

## 📦 Installation

### One-Command Setup

```bash
curl -fsSL https://raw.githubusercontent.com/betagouv/agnostic-ai/main/install.sh | bash
```

**What happens:**

1. **Creates `.ai/` structure**
   - Sets up `AGENTS.md` (main configuration)
   - Creates `context/`, `commands/`, `agents/`, `avatars/` folders

2. **Installs core plugin automatically**
   - Essential commands: `/core:migrate`, `/core:command-create`, `/core:agent-create`, etc.
   - Essential agents: `explore-codebase`, `prompt-engineering`, `fast-coder`

3. **Creates `.ai/config.jsonc`** (committed to git)
   - Stores installed plugins
   - Shared across the team with JSONC format (supports comments)

4. **Asks which IDE(s) you want to configure**
   - Claude Code
   - Cursor
   - You can select multiple (e.g., "1 2" for both)
   - Creates symlinks for each selected IDE
   - Updates `.gitignore` automatically

### Result

```
your-project/
├── .ai/                          # ✅ Commit this (source of truth)
│   ├── AGENTS.md                 # Main config file
│   ├── config.jsonc              # ✅ Configuration (committed, supports comments)
│   ├── cli                       # Plugin manager CLI
│   ├── commands/                 # Commands (plugins + custom)
│   │   ├── core/                 # Core plugin
│   │   ├── git/                  # Git plugin
│   │   ├── github/               # GitHub plugin
│   │   └── my-command.md         # Custom command at root
│   ├── agents/                   # Agents (plugins + custom)
│   │   ├── core/                 # Core plugin
│   │   ├── github/               # GitHub plugin
│   │   └── my-agent.md           # Custom agent at root
│   ├── context/                  # Context (plugins + custom)
│   │   ├── core/                 # Core plugin
│   │   ├── lang-node/            # Lang-node plugin
│   │   └── my-context.mdc        # Custom context at root
│   └── avatars/                  # AI behavior profiles
│       └── my-avatar.md          # Custom avatar
│
├── .claude/                      # ❌ Generated (gitignored)
│   ├── CLAUDE.md                 # → .ai/AGENTS.md
│   ├── commands/                 # → .ai/commands/
│   ├── agents/                   # → .ai/agents/
│   ├── context/                  # → .ai/context/
│   └── output-styles/            # → .ai/avatars/
│
└── .cursor/                      # ❌ Generated (gitignored)
    ├── rules/                    # Directory with symlinks
    │   ├── main.mdc              # → .ai/AGENTS.md
    │   ├── core/                 # → .ai/context/core/
    │   ├── lang-node/            # → .ai/context/lang-node/
    │   └── *.md                  # → .ai/context/*.md
    ├── commands/                 # → .ai/commands/
    └── agents/                   # → .ai/agents/
```

## 🔌 Plugin System

### Available Plugins

```bash
# List all available plugins
.ai/cli plugins list

# Output:
#   ✓ core (installed)
#     github
#     code-quality
#     git
#     image-manipulation
#     lang-node
#     lang-typescript
#     lang-go
#     lang-ruby
#     lang-vue
```

### Plugin Overview

| Plugin | Description | Contains |
|--------|-------------|----------|
| **core** | Essential commands & agents | `/core:migrate`, `/core:command-create`, `/core:agent-create`, `/core:deep-search`, `fast-coder`, `explore-codebase` |
| **github** | GitHub workflow automation | `/github:code-issue-process`, `/github:code-pr-create`, `/github:code-pr-process-comments` |
| **code-quality** | Code analysis & optimization | `/code-quality:code-analyse`, `/code-quality:code-ci`, `/code-quality:code-clean`, `/code-quality:code-explain`, `/code-quality:code-optimize` |
| **git** | Git commit automation | `/git:code-commit` |
| **image-manipulation** | Image processing | `/image-manipulation:image2md` |
| **lang-node** | Node.js context & tools | Node.js code style, dependencies, performance, testing, `/lang-node:code-fix` |
| **lang-typescript** | TypeScript context | TypeScript code style and best practices |
| **lang-go** | Go context | Go code style and idioms |
| **lang-ruby** | Ruby context | Ruby code style and conventions |
| **lang-vue** | Vue.js context | Vue.js patterns and best practices |

### Install Plugins

```bash
# Install a plugin
.ai/cli plugins add lang-node

# Install multiple plugins
.ai/cli plugins add lang-typescript
.ai/cli plugins add github
.ai/cli plugins add code-quality

# Plugins are added to .ai/ and listed in .ai/config.jsonc
```

### Update

```bash
# Update agnostic-ai and all installed plugins
.ai/cli update

# Checks git status first (must be clean)
# Downloads latest version
# Re-installs your plugins
# Updates IDE configuration
```

## 🚀 Quick Start

### 1. Install

```bash
curl -fsSL https://raw.githubusercontent.com/betagouv/agnostic-ai/main/install.sh | bash
```

Or if `.ai` folder is already installed, use `.ai/cli configure`

### 2. Migrate Existing Documentation

```bash
# Run from terminal
.ai/cli migrate

# This will show instructions for your IDE
# Then open your IDE (Claude Code or Cursor) and run:
/core:migrate
```

This command:
- Finds all documentation in your codebase
- Extracts relevant sections
- Organizes them into `.ai/context/` files
- Removes extracted content from original files


### 3. Add Plugins (Optional)

```bash
# See what's available
.ai/cli plugins list

# Install language support
.ai/cli plugins add lang-node
.ai/cli plugins add lang-typescript

# Install GitHub integration
.ai/cli plugins add github
```


### 4. Commit Your Configuration

```bash
git add .ai/
git commit -m "feat: add AI configuration"
git push
```

**Note:** `.ai/config.jsonc` is committed and shared across the team!

<!-- This section has been moved to .ai/context/ARCHITECTURE.md -->

## 🛠️ CLI Commands

### IDE Configuration

```bash
# Configure IDE symlinks (can run multiple times to add more IDEs)
.ai/cli configure
```

### Plugin Management

```bash
# List available plugins
.ai/cli plugins list

# Install a plugin
.ai/cli plugins add <plugin-name>

# Examples
.ai/cli plugins add lang-node
.ai/cli plugins add github
.ai/cli plugins add code-quality
```

### Update

```bash
# Update agnostic-ai and installed plugins
.ai/cli update
```

### MCP Server Management

```bash
# Install MCP server templates
.ai/cli mcp install

# List available MCP servers
.ai/cli mcp list

# Enable MCP server(s) for your IDE(s)
.ai/cli mcp use <server-name> [server-name...]

# Examples
.ai/cli mcp use github              # Enable GitHub integration
.ai/cli mcp use notion airtable     # Enable multiple servers
.ai/cli mcp use filesystem sqlite   # Local tools

# Disable MCP server(s) - Don't forget to disable unused servers to save tokens!
.ai/cli mcp unuse <server-name> [server-name...]

# Examples
.ai/cli mcp unuse github            # Disable GitHub when not working on PRs
.ai/cli mcp unuse notion airtable   # Disable multiple servers
```

**💡 Tip:** Only enable MCP servers you're actively using. Each enabled server consumes tokens in every conversation, so disable them when not needed to save costs!

**Available MCP Servers (14 pre-configured):**
- **airtable** - Airtable database operations
- **context7** - Up-to-date library documentation
- **filesystem** - File system operations
- **github** - GitHub API integration
- **gmail** - Gmail search and drafts
- **google-calendar** - Calendar management
- **google-drive** - Drive, Sheets, and Docs access
- **make** - Make.com scenario integration
- **next-devtools** - Next.js development tools
- **notion** - Notion workspace integration
- **postgres** - PostgreSQL database access
- **sqlite** - SQLite database access
- **stripe** - Stripe payment processing
- **trello** - Trello board management

**Setup:** Add required API keys to `.env.local` (gitignored)

### Help

```bash
# Show help
.ai/cli help
```

## 📚 Core Plugin Commands

Once installed, you have access to these commands:

### `/core:migrate`

Migrate existing documentation to `.ai/context/` files
(Run `.ai/cli migrate` from terminal first to see instructions)

### `/core:command-create`

Create a new slash command

### `/core:agent-create`

Create a new specialized agent

### `/core:context-cleanup`

Optimize and clean up context files

### `/core:deep-search`

Perform deep research on a topic

### `/core:avatar-create`

Create a new AI personality/output style

### `/core:feature-create`

Scaffold a new feature with EPCT methodology

## 🔄 Daily Workflow

### Adding a Plugin

```bash
# Discover available plugins
.ai/cli plugins list

# Install what you need
.ai/cli plugins add code-quality

# Commands appear instantly in your IDE
/code-quality:code-analyse
```

### Updating

```bash
# Get latest updates
.ai/cli update

# Your installed plugins are automatically updated
```

### Team Synchronization

```bash
# Pull changes
git pull

# Configuration is in .ai/config.jsonc - shared across the team
# If new plugins were added, they'll be automatically available

# Configure your IDE locally (each dev chooses their own IDE)
.ai/cli configure
```

**Note:** IDE configuration is local (gitignored) - each developer can use different IDEs!

## 🎯 IDE Support

| IDE | Status | Configuration |
|-----|--------|---------------|
| **Claude Code** | ✅ Full | `.claude/` (symlinks) |
| **Cursor** | ✅ Full | `.cursor/` (symlinks) |
| **Others** | 🔜 Coming | [Contribute!](templates/ides/CONTRIBUTE.md) |

## ⚡ Shell Aliases for Claude CLI

Speed up your Claude CLI workflow with convenient aliases:

```bash
alias cc="claude --dangerously-skip-permissions"
alias ccc="claude --dangerously-skip-permissions -c"
```

**Why it's safe:** The agnostic-ai configuration includes a PreToolsBash hook that intercepts potentially destructive commands before execution, giving you speed without compromising safety.

📖 **Full setup guide:** [templates/ides/claude/SHELL-SETUP.md](templates/ides/claude/SHELL-SETUP.md)

## 🤝 Contributing

Want to add support for your favorite IDE or create a plugin?

See **[templates/ides/CONTRIBUTE.md](templates/ides/CONTRIBUTE.md)** for IDE integration guide.

For plugins, just create a folder in `templates/plugins/` with your plugin name and structure:

```
templates/plugins/my-plugin/
├── commands/
│   └── my-command.md
├── agents/
│   └── my-agent.md
└── context/
    └── MY-CONTEXT.md
```

## 🙏 Acknowledgments

**Original Idea & Development**

This project was created by:
- [Martin Ratinaud](https://github.com/martinratinaud) - Original concept and lead developer
- [Maxime Dréau](https://github.com/totakoko) - Co-creator and architecture

**Inspiration**

This project was heavily inspired by [@Melvynx](https://github.com/Melvynx)'s excellent [aiblueprint](https://github.com/Melvynx/aiblueprint). Thank you!

To get the most out of this project and AI-assisted development, we recommend [Melvynx's AI Blueprint training](https://aiblueprint.dev/?ref=aJmHMnVnfaK) to understand how to best work with AI assistants.

## 📄 License

MIT

## 💬 Support

- **Issues**: [GitHub Issues](https://github.com/betagouv/agnostic-ai/issues)
- **Discussions**: [GitHub Discussions](https://github.com/betagouv/agnostic-ai/discussions)
- **Mattermost**: [Beta Gouv AI Channel](https://mattermost.incubateur.net/betagouv/channels/domaine-dev-ai-workflows)

---

**Made with ❤️ for developers who want to share AI configuration across all their AI coding tools**
