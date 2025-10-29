---
name: "writing-documentation"
description: "Documentation standards for agnostic-ai project. Use when writing or updating README.md, AGENTS.md, context files, or other markdown documentation. Do not use for code comments."
version: 1.0.0
---

# Documentation Standards for Agnostic AI

When writing documentation for agnostic-ai, follow these guidelines:

## Documentation Hierarchy

### 1. README.md (User-Facing)
- **Purpose**: First impression, quick start, feature overview
- **Audience**: New users, potential adopters
- **Tone**: Friendly, concise, example-driven
- **Structure**: Problem → Solution → Quick Start → Details

### 2. AGENTS.md (AI-Facing)
- **Purpose**: Configuration and instructions for AI assistants
- **Audience**: AI models (Claude, Cursor, etc.)
- **Tone**: Direct, imperative, technical
- **Structure**: Context organization → Guidelines → Commands/Agents/Skills

### 3. Context Files (AI Knowledge)
- **Purpose**: Domain-specific knowledge and patterns
- **Audience**: AI models working on specific tasks
- **Location**: `.ai/context/<topic>/`
- **Format**: Technical, examples, patterns

## README.md Structure

### Required Sections

```markdown
# Project Title - One-line description

> Key benefit statement

## ⚡ TLDR - Quick Start
[3-5 commands to get started]

## 🎯 The Problem
[What pain point does this solve?]

## ✨ The Solution
[How does this solve it?]

## 📦 Installation
[Step-by-step setup]

## 🔌 Plugin System
[Available plugins and how to use them]

## 🚀 Quick Start
[Common workflows]

## 🛠️ CLI Commands
[Command reference]

## 🎯 Core Features
[Detailed feature documentation]

## 🤝 Contributing
[How to contribute]

## 📄 License
```

### Formatting Guidelines

**Use Emojis for Section Headers**
- Makes sections scannable
- Consistent icons across documentation
- Common ones: 🎯 (goals), 📦 (install), 🔌 (plugins), 🚀 (quick start), 🛠️ (tools)

**Code Blocks with Language**
```markdown
```bash
# Always specify language
npm install
```
```

**Clear Examples**
```markdown
# ✅ Good Example
Shows working code with context

# ❌ Bad Example
Shows what NOT to do
```

**Tables for Comparisons**
| Feature | Option A | Option B |
|---------|----------|----------|
| Speed   | Fast     | Slow     |

## AGENTS.md Structure

### Required Sections

```markdown
# AI Configuration for [project]

## 📁 Project Structure
[How .ai/ folder is organized]

## 🎯 How to Use This Configuration
[Instructions for AI models]

## 📚 Context Organization
[Where to find what]

## 🎯 Project Information
[Basic project details]

## 💡 Development Guidelines
[Coding standards, testing, docs]

## 🔧 Commands Available
[Slash commands]

## 👥 AI Agents
[Available agents]

## 🎯 Skills
[Available skills]

---
**Note for AI Models**: Version-controlled configuration
```

### Tone and Style

**Imperative for Instructions**
```markdown
✅ "Follow these conventions"
❌ "You should follow these conventions"

✅ "Read from .ai/context/"
❌ "Please read from .ai/context/"
```

**Technical and Precise**
```markdown
✅ "Symlink .ai/commands/ to .claude/commands/"
❌ "Connect the commands folder"
```

## Context Files Structure

### File Naming

- `CODE-STYLE.md` - Language/framework conventions
- `TESTING.md` - Testing patterns and practices
- `ARCHITECTURE.md` - System design and patterns
- `DATABASE.md` - Schema and queries
- `GIT-WORKFLOW.md` - Version control practices

### Content Structure

```markdown
# [Topic Name]

Brief introduction paragraph.

## [Major Section]

### [Subsection]

- Guideline
- Example
- Pattern

## Examples

### Example 1: [Scenario]
```[language]
[code]
```

### Example 2: [Scenario]
```[language]
[code]
```

## Anti-Patterns

### ❌ DON'T
- Bad practice with explanation

### ✅ DO
- Good practice with explanation

## See Also
- Related documentation links
```

## Command Documentation

When documenting commands in README or command files:

### Command Signature
```markdown
### `/namespace:command-name`

Brief one-line description.

**Usage:**
```bash
/namespace:command-name <required> [optional]
```

**Examples:**
```bash
/core:skill-create create my-skill
/github:code-pr-create
```
```

### Command Frontmatter
```yaml
---
allowed-tools: Read, Write, Edit
argument-hint: <action> <name>
description: One-line description
---
```

## Writing Guidelines

### Be Concise

```markdown
✅ "Install agnostic-ai with one command"
❌ "You can easily install the agnostic-ai tool by running a simple command"
```

### Use Active Voice

```markdown
✅ "The installer creates symlinks"
❌ "Symlinks are created by the installer"
```

### Show, Don't Tell

```markdown
✅
```bash
.ai/cli plugins add lang-node
```
Result: Commands available in .claude/commands/lang-node/

❌
"You can add plugins by running the CLI command and then they will be available in your IDE"
```

### Provide Context

```markdown
✅ "Skills are model-invoked (Claude decides when to use them)"
❌ "Skills are model-invoked"
```

### Include Examples

Every major feature should have:
1. Code example
2. Expected output
3. Common use case

## Markdown Best Practices

### Headers

```markdown
# H1 - Page title only
## H2 - Major sections
### H3 - Subsections
#### H4 - Rarely needed
```

### Lists

```markdown
# Unordered for items without sequence
- Item 1
- Item 2

# Ordered for steps
1. First step
2. Second step
```

### Links

```markdown
# Internal links (relative)
See [installation guide](INSTALL.md)

# External links (absolute)
Learn more at [docs.example.com](https://docs.example.com)

# Reference-style for repeated links
[Claude Code][cc-docs] supports Skills.

[cc-docs]: https://docs.claude.com/claude-code
```

### Code Formatting

```markdown
# Inline code for commands, variables, paths
Run `npm install` to install dependencies.

# Code blocks for examples
```bash
npm install
npm start
```
```

## Directory Structure Documentation

Use tree format with annotations:

```markdown
```
your-project/
├── .ai/                          # ✅ Commit this
│   ├── AGENTS.md                 # Main config
│   ├── commands/                 # Slash commands
│   └── skills/                   # Auto-activated
│
├── .claude/                      # ❌ Generated
│   └── commands/                 # → .ai/commands/
```
```

## Tables

### Comparison Tables

```markdown
| Feature | Skills | Commands | Agents |
|---------|--------|----------|--------|
| **Invoke** | Auto | Manual | Task tool |
| **Purpose** | Knowledge | Shortcuts | Workflows |
```

### Plugin Tables

```markdown
| Plugin | Description | Contains |
|--------|-------------|----------|
| **core** | Essential | Commands, agents |
| **git** | Git automation | `/code-commit` |
```

## Documentation Anti-Patterns

### ❌ DON'T

**Vague Descriptions**
```markdown
❌ "This is a great tool"
✅ "Unified .ai/ configuration works with Claude Code and Cursor"
```

**Missing Context**
```markdown
❌ "Run the command"
✅ "Run `.ai/cli configure` to set up IDE symlinks"
```

**No Examples**
```markdown
❌ "You can create skills"
✅ "Create skills with `/core:skill-create create my-skill`"
```

**Outdated Information**
```markdown
❌ Keep dates/versions in main docs
✅ Use version-agnostic language or link to changelog
```

**Wall of Text**
```markdown
❌ Long paragraphs without structure
✅ Use headers, lists, code blocks for scannability
```

### ✅ DO

**Clear Structure**
```markdown
## Problem → Solution → Example
```

**Actionable Steps**
```markdown
1. Run this command
2. Verify output
3. Next step
```

**Expected Results**
```markdown
```bash
.ai/cli plugins add lang-node
```

Output:
```
✓ Commands → .ai/commands/lang-node/
```
```

## Style Guide

### Punctuation

- **Headers**: No period at end
- **Lists**: No period for fragments, period for sentences
- **Code blocks**: Follow language conventions

### Capitalization

- **Headers**: Title case (e.g., "Writing Documentation")
- **Commands**: Lowercase (e.g., `/code-commit`)
- **Proper nouns**: Capitalize (e.g., "Claude Code", "Cursor")

### Abbreviations

- **First use**: Full term + abbreviation (e.g., "Command Line Interface (CLI)")
- **Subsequent**: Abbreviation only (e.g., "CLI")

## Review Checklist

Before publishing documentation:

- [ ] Headers use appropriate emojis
- [ ] Code blocks specify language
- [ ] Examples are working and tested
- [ ] Links are valid
- [ ] No spelling/grammar errors
- [ ] Consistent formatting
- [ ] Clear structure (scannable)
- [ ] Appropriate tone for audience
- [ ] No outdated information
- [ ] Cross-references are accurate

## Summary

Documentation in agnostic-ai should be:

1. **Clear**: Easy to understand at first reading
2. **Concise**: No unnecessary words
3. **Complete**: All information needed
4. **Current**: Up to date with latest changes
5. **Consistent**: Follows established patterns
6. **Correct**: Accurate and tested

Good documentation is as important as good code!
