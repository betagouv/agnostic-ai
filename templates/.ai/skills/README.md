# Skills

Skills are **model-invoked** capabilities that extend your AI assistant with specialized knowledge, workflows, and tool integrations. Unlike commands (user-invoked) or agents (workflow orchestrators), Skills are **automatically activated** by the AI when it determines they're relevant to your task.

## What are Skills?

Skills allow you to:
- **Share domain expertise** - Package specialized knowledge for your team
- **Reduce repetitive prompting** - AI remembers patterns automatically
- **Compose workflows** - Multiple Skills work together when needed
- **Progressive disclosure** - Unbounded context via lazy loading

## IDE Support

| IDE | Status | Notes |
|-----|--------|-------|
| **Claude Code** | ✅ Supported | Native support since October 2025 |
| **Cursor** | 🔜 Coming Soon | Prepared for future support |

## File Structure

Each Skill is a directory containing a `SKILL.md` file:

```
my-skill/
├── SKILL.md              (required - YAML frontmatter + instructions)
├── REFERENCE.md          (optional - detailed docs loaded on-demand)
├── examples/             (optional - code examples)
└── scripts/              (optional - helper scripts)
```

## SKILL.md Format

```markdown
---
name: "skill-name"
description: "What it does AND when to use it. Be specific about triggers."
version: 1.0.0                    # optional
dependencies: python>=3.8         # optional
allowed-tools: Read, Grep, Glob   # optional - restricts tool access
---

# Skill Instructions

[Imperative form instructions here - max ~500 lines]

Use progressive disclosure - link to REFERENCE.md for extensive details.
```

## Naming Conventions

- **name**: lowercase, hyphens only, max 64 chars
- Use gerund form: "processing-pdfs" not "pdf-processor"
- Be specific: "analyzing-typescript-performance" not "code-helper"

## Description Best Practices

Your description is CRITICAL for AI discovery. Include:

1. **What**: What the Skill does
2. **When**: When to use it (explicit triggers)
3. **When NOT**: Clear boundaries

**Good Example:**
```yaml
description: "Apply agnostic-ai coding standards and architecture patterns. Use when writing or reviewing code for this project. Do not use for documentation tasks."
```

**Bad Example:**
```yaml
description: "Helps with code"  # Too vague, no triggers
```

## Creating Skills

### Using the Command

In your IDE:
```
/core:skill-create <action> <name>

Examples:
/core:skill-create create analyzing-api-performance
/core:skill-create edit my-skill
```

### Manual Creation

1. Create a directory: `.ai/skills/my-skill/`
2. Create `SKILL.md` with YAML frontmatter
3. Test activation: The AI should load it when relevant

## Plugin Skills vs Custom Skills

**Plugin Skills**: Located in `.ai/skills/<plugin-name>/`
- Installed via `.ai/cli plugins add`
- Shared across team via plugins
- Updated with `.ai/cli update`

**Custom Skills**: Located in `.ai/skills/` (root level)
- Project-specific skills you create
- Committed to git for team sharing
- No prefix required

## Skills vs Commands vs Agents

| Feature | Skills | Commands | Agents |
|---------|--------|----------|--------|
| **Invocation** | Model-invoked (automatic) | User-invoked (`/command`) | Task tool or `@mention` |
| **Purpose** | Domain knowledge, standards | Workflow shortcuts | Multi-step orchestration |
| **When to use** | "I want AI to remember X" | "I need a shortcut for Y" | "Automate Z workflow" |
| **Best for** | Coding standards, patterns | Utility scripts | Planning, analysis |

## Examples

See `core/` folder for example Skills included in the core plugin.

## Learn More

- [Claude Skills Documentation](https://docs.claude.com/en/docs/claude-code/skills)
- [Official Skills Repository](https://github.com/anthropics/skills)
- [Skill Authoring Best Practices](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices)
