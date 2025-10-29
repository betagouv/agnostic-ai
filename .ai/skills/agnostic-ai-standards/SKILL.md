---
name: "agnostic-ai-standards"
description: "Apply agnostic-ai project coding standards, architecture patterns, and file organization conventions. Use when writing, reviewing, or refactoring code in agnostic-ai projects. Do not use for documentation-only tasks."
version: 1.0.0
allowed-tools: Read, Grep, Glob
---

# Agnostic AI Project Standards

When working on agnostic-ai codebases, follow these standards:

## Architecture Principles

### 1. IDE-Agnostic Design

All features must work across multiple IDEs:
- Source of truth: `.ai/` folder (committed to git)
- IDE configs: Generated via symlinks (gitignored)
- Pattern: `.ai/<type>/<plugin>/` → `.<ide>/<type>/`

### 2. Modular Plugin System

- **Core plugin**: Essential commands/agents (always installed)
- **Optional plugins**: Language-specific, integrations, tools
- **Plugin structure**: `commands/`, `agents/`, `context/`, `skills/`
- **Installation**: `.ai/cli plugins add <name>`

### 3. Template-Driven

- Templates in: `templates/.ai/` and `templates/plugins/`
- Variable substitution: `{{PROJECT_NAME}}`, `{{FRAMEWORK}}`
- Initialization: `install.sh` copies and customizes templates

## File Organization

### Naming Conventions

1. **Commands**: `kebab-case.md` (e.g., `code-commit.md`)
2. **Agents**: `kebab-case.md` (e.g., `explore-codebase.md`)
3. **Skills**: `kebab-case/SKILL.md` (directory with SKILL.md)
4. **Avatars**: `kebab-case.md` (e.g., `product-owner.md`)
5. **Context**: `UPPER-CASE.md` (e.g., `CODE-STYLE.md`)
6. **Templates**: `UPPER-CASE.template.md` (e.g., `ARCHITECTURE.template.md`)

### Directory Structure

```
.ai/
├── AGENTS.md                 # Main config
├── config.jsonc              # Installed plugins (committed, JSONC format)
├── cli                       # Plugin manager
├── commands/
│   ├── core/                 # Plugin commands
│   └── my-command.md         # Custom commands (root level)
├── agents/
│   ├── core/                 # Plugin agents
│   └── my-agent.md           # Custom agents (root level)
├── skills/
│   ├── core/                 # Plugin skills
│   └── my-skill/             # Custom skills (root level)
├── context/
│   ├── core/                 # Plugin context
│   ├── lang-*/               # Language plugins
│   └── my-context.md         # Custom context (root level)
└── avatars/
    └── my-avatar.md          # Custom avatars
```

## Coding Standards

### Bash Scripts

1. **Error handling**: Always use `set -e` at the top
2. **Symlinks**: Use relative paths for IDE compatibility
3. **Plugin copying**: Handle `commands/`, `agents/`, `context/`, `skills/`
4. **User feedback**: Echo clear progress messages

### Command Frontmatter

```yaml
---
allowed-tools: Bash(git :*), Bash(gh :*)  # Tool restrictions
description: One-line description           # Required
argument-hint: <action> <name>             # Optional
---
```

### Agent Frontmatter

```yaml
---
name: kebab-case-name
description: One-line capability statement
color: yellow|blue|green|red
---
```

### Skill Frontmatter

```yaml
---
name: "kebab-case-name"
description: "What it does AND when to use it. Be specific."
version: 1.0.0                    # optional
dependencies: python>=3.8         # optional
allowed-tools: Read, Grep, Glob   # optional
---
```

## Command Patterns

### Pattern 1: Numbered Workflow
For git, CI, EPCT processes:
```markdown
## Workflow
1. **ACTION**: Description
   - Specific step
   - **CRITICAL**: Important note
2. **NEXT**: Continue
```

### Pattern 2: Reference Format
For CLI tool wrappers:
```markdown
## [Category]
```bash
# Command examples
```
```

### Pattern 3: Section-Based
For analysis/research:
```markdown
## [Phase Name]
**Goal**: What this achieves
- Action items
```

## Testing & Validation

Before committing changes:

1. **Check for scripts**: Look for `package.json`, `lint`, `format`, `typecheck`
2. **Run formatters**: Ensure consistent code style
3. **Test in scope**: Only test what you changed
4. **Verify symlinks**: `.ai/cli configure` should work

## Documentation

### Where to Document

1. **Global context**: `.ai/context/` or `.ai/AGENTS.md`
2. **Plugin context**: `.ai/context/<plugin>/`
3. **Module-specific**: Module's `README.md` or `AGENTS.md`
4. **Architectural decisions**: `.ai/context/ARCHITECTURE.md`

### What to Document

- Only include what AI doesn't already know
- Use concrete examples over abstract descriptions
- Keep files under 500 lines (use REFERENCE.md for details)
- Update AGENTS.md when adding features

## Common Tasks

### Adding Plugin Support for Skills

When updating scripts to support a new artifact type:

1. Update `.ai/cli` - add_plugin() function
2. Update `install.sh` - core plugin installation
3. Update `update.sh` - plugin update loop
4. Update `templates/ides/*/init.sh` - symlink creation
5. Update documentation in README.md

### Creating Meta-Commands

Commands that create other artifacts (like skill-create):

1. Study existing: `command-create.md`, `agent-create.md`
2. Parse arguments: `$ARGUMENTS` contains user input
3. Provide templates: Include multiple patterns/examples
4. Save to correct location: `.ai/<type>/` or `.ai/<type>/<plugin>/`

## Anti-Patterns

### ❌ DON'T

- Create IDE-specific features without agnostic design
- Hardcode IDE paths (use symlinks instead)
- Skip error handling in bash scripts
- Use Windows backslash paths
- Add time-sensitive information to Skills
- Create overly broad Skill descriptions

### ✅ DO

- Design for multi-IDE support from the start
- Use relative symlinks for portability
- Handle errors gracefully with user feedback
- Use forward slashes (works on all platforms)
- Keep Skills focused and specific
- Write clear Skill descriptions with explicit triggers

## Progressive Disclosure

For complex instructions:

1. **SKILL.md**: Core instructions (~500 lines max)
2. **REFERENCE.md**: Detailed documentation (loaded on-demand)
3. **One level deep**: SKILL.md → REFERENCE.md only (no deeper nesting)

## Learn More

For detailed implementation examples, see:
- Existing commands in `.ai/commands/core/`
- Existing agents in `.ai/agents/core/`
- Plugin structure in `templates/plugins/`
- IDE integration in `templates/ides/`
