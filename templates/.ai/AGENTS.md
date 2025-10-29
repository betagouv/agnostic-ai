# AI Configuration for {{PROJECT_NAME}}

> Central configuration file for all AI assistants working on this project

## 📁 Project Structure

This project uses a unified `.ai/` folder to configure all AI tools (Claude Code, Cursor, Windsurf, GitHub Copilot, etc.).

```
.ai/
├── AGENTS.md              # This file - main configuration
├── config.jsonc           # Configuration (committed, supports comments)
├── cli                    # Plugin manager CLI
├── context/               # Project knowledge and guidelines
│   ├── ARCHITECTURE.template.md  # System architecture (run .ai/cli migrate)
│   ├── OVERVIEW.template.md      # Project overview (run .ai/cli migrate)
│   ├── TESTING.template.md       # Testing strategy (run .ai/cli migrate)
│   ├── DATABASE.template.md      # Database schema (run .ai/cli migrate)
│   ├── GIT-WORKFLOW.md           # Git workflow (from git plugin)
│   └── <lang>/                   # Language-specific (from lang-* plugins)
├── commands/              # Custom slash commands (from plugins)
├── agents/                # Specialized agents (from plugins)
├── avatars/               # AI behavior profiles
└── scripts/               # Validation and utility scripts
```

**Note**: Language-specific contexts (node/, typescript/, etc.) are added via plugins.
Run `.ai/cli plugins add lang-node` to add Node.js context, for example.

## 🎯 How to Use This Configuration

### For AI Models

When working on this codebase, you should:

1. **Read this file first** - It contains the main project directives
2. **Check context folders** - Language/framework-specific guidelines are in `.ai/context/<language>/`
3. **Look for local documentation** - Each module may have:
   - `README.md` - Module overview and usage
   - `AGENTS.md` or `CLAUDE.md` - AI-specific directives for that module

**Example**: When working in a Node.js module:
- Read `.ai/context/node/` for Node.js best practices
- Check the module's `README.md` for module-specific context
- Check for `AGENTS.md` in the module folder for additional AI directives

## 📚 Context Organization

### Global Context

All cross-cutting concerns and project-wide guidelines should be documented in `.ai/context/` or this file.

### Module-Specific Context

For module or feature-specific directives, create an `AGENTS.md` (or `README.md`) in that module's folder:

```
src/
├── auth/
│   ├── AGENTS.md          # Authentication-specific AI directives
│   └── ...
└── billing/
    ├── AGENTS.md          # Billing-specific AI directives
    └── ...
```

## 🎯 Project Information

**Project**: {{PROJECT_NAME}}
**Description**: {{PROJECT_DESC}}
**Tech Stack**: {{FRAMEWORK}}

### Architecture and Overview
- Read from `.ai/context/ARCHITECTURE.md` and `.ai/context/OVERVIEW.md`


## 💡 Development Guidelines

- Follow language-specific conventions in `.ai/context/<language>/`

### Code Style
- Read from `.ai/context/CODING-STYLE.md`

### Testing
- Read from `.ai/context/TESTING.md`

### Documentation
- Update AGENTS.md when adding features
- Document complex algorithms in comments
- Keep AGENTS.md files up to date

## 🔧 Commands Available

Custom slash commands are available in `.ai/commands/`. Check that folder for available automation.

**Commands** are user-invoked shortcuts (e.g., `/core:migrate`, `/github:code-pr-create`):
- Triggered explicitly by typing `/command-name`
- Best for: Workflow shortcuts, utility scripts
- Location: `.ai/commands/<plugin>/` or `.ai/commands/` (custom)

## 👥 AI Agents

Specialized agents are configured in `.ai/agents/` for complex tasks like codebase exploration, deep search, etc.

**Agents** are workflow orchestrators for multi-step processes:
- Invoked via `@agent-name` mention or Task tool
- Best for: Multi-step analysis, planning, orchestration
- Location: `.ai/agents/<plugin>/` or `.ai/agents/` (custom)

## 🎯 Skills

Skills are **model-invoked** capabilities in `.ai/skills/` that AI assistants load automatically when relevant.

**Skills** are auto-activated by AI based on task context:
- No manual invocation - AI decides when to use them
- Best for: Coding standards, domain expertise, specialized workflows
- Location: `.ai/skills/<plugin>/` or `.ai/skills/` (custom)
- Current support: Claude Code (full), Cursor (coming soon)

### Skills vs Commands vs Agents

| Feature | Skills | Commands | Agents |
|---------|--------|----------|--------|
| **Invocation** | Model-invoked (automatic) | User-invoked (`/command`) | Task tool or `@mention` |
| **Purpose** | Domain knowledge, standards | Workflow shortcuts | Multi-step orchestration |
| **When to use** | "I want AI to remember X" | "I need a shortcut for Y" | "Automate Z workflow" |

Create Skills with `/core:skill-create`, Commands with `/core:command-create`, Agents with `/core:agent-create`.

---

**Note for AI Models**: This configuration is version-controlled. Always respect the guidelines defined here and in the context folders.
