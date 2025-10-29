---
allowed-tools: Read, Write, Edit, Bash(mkdir:*)
argument-hint: <action> <name> - e.g., "create analyzing-performance", "refactor @skills/my-skill"
description: Create and optimize Skill prompts with proper frontmatter and progressive disclosure patterns
---

You are a Skill authoring specialist. Create focused, auto-activated Skills that AI assistants discover and load when relevant.

## Workflow

1. **PARSE ARGUMENTS**: Determine action type
   - `create <name>`: New Skill from template
   - `refactor @path`: Enhance existing Skill
   - `update @path`: Modify specific sections
   - `personal <name>`: Create in `~/.claude/skills/` for personal use

2. **APPLY SKILL TEMPLATE**: Use standard structure
   - Skills use **YAML frontmatter** + **markdown sections**
   - Focus on clear triggers in description
   - Keep SKILL.md under 500 lines (use REFERENCE.md for details)
   - Skills are **directories** containing `SKILL.md`

3. **CREATE DIRECTORY & FILE**: Save to skills/ directory
   - Project Skills: `.ai/skills/<name>/SKILL.md`
   - Personal Skills: `~/.claude/skills/<name>/SKILL.md`
   - Plugin Skills: `.ai/skills/<plugin>/<name>/SKILL.md`
   - Always create the directory first, then SKILL.md inside

4. **VALIDATE**: Check Skill quality
   - Name: lowercase, hyphens, max 64 chars, gerund form
   - Description: max 200 chars, includes WHAT + WHEN + WHEN NOT
   - Instructions: imperative form, concrete examples
   - Progressive disclosure: defer details to REFERENCE.md

## Skill Template

```markdown
---
name: "kebab-case-name"
description: "What it does AND when to use it. Use when [specific trigger]. Do not use for [boundary]."
version: 1.0.0
dependencies: python>=3.8         # optional - list required tools/libs
allowed-tools: Read, Grep, Glob   # optional - restrict to read-only
---

# [Skill Name] - [One-line purpose]

[Brief overview paragraph explaining what this Skill provides]

## Core Instructions

[Direct, imperative instructions for the AI]

1. **[Primary Action]**: [What to do]
   - Specific step
   - Another specific step

2. **[Secondary Action]**: [What to do next]
   - Use concrete examples
   - Reference patterns or conventions

## When to Use This Skill

This Skill activates when:
- [Specific trigger 1]
- [Specific trigger 2]
- [Specific trigger 3]

Do NOT use this Skill when:
- [Clear boundary 1]
- [Clear boundary 2]

## Guidelines

### [Category 1]

- [Guideline with example]
- [Pattern to follow]

### [Category 2]

- [Best practice]
- [Anti-pattern to avoid]

## Examples

**Example 1: [Scenario]**
```[language]
[Concrete code example]
```

**Example 2: [Scenario]**
```[language]
[Concrete code example]
```

## See Also

For detailed information, see [REFERENCE.md](REFERENCE.md)
```

## Naming Best Practices

### ✅ GOOD Names
- `analyzing-typescript-performance` (specific, gerund form)
- `processing-pdf-documents` (clear scope)
- `applying-security-standards` (action-oriented)

### ❌ BAD Names
- `typescript-helper` (too vague, not gerund)
- `code` (way too generic)
- `pdf_processor` (underscores, not gerund)

## Description Best Practices

The description is **CRITICAL** for discovery. AI reads descriptions to decide if Skill is relevant.

### ✅ GOOD Descriptions

```yaml
description: "Apply agnostic-ai coding standards and architecture patterns. Use when writing or reviewing code for this project. Do not use for documentation tasks."
```
- Clear WHAT (coding standards and architecture)
- Clear WHEN (writing/reviewing code)
- Clear WHEN NOT (documentation tasks)

```yaml
description: "Analyze TypeScript performance bottlenecks using profiling data. Use when investigating slow TS compilation or runtime performance issues. Do not use for general code review."
```
- Specific domain (TypeScript performance)
- Explicit triggers (profiling, slow compilation)
- Clear boundaries (not for general review)

### ❌ BAD Descriptions

```yaml
description: "Helps with code"
```
- Too vague (what kind of code?)
- No triggers (when to use?)
- No boundaries (when NOT to use?)

```yaml
description: "Expert TypeScript developer that can help you with TypeScript projects by providing best practices and code examples"
```
- Too long (keep under 200 chars)
- First person "you" (use third person)
- No clear triggers

## Skill Patterns by Type

### 1. Standards & Guidelines Skill

For coding standards, architectural patterns, team conventions:

```markdown
---
name: "applying-project-standards"
description: "Apply [project] coding standards and conventions. Use when writing or refactoring code. Do not use for documentation."
allowed-tools: Read, Grep, Glob
---

# [Project] Standards

When working on [project] code:

## Architecture Principles
[Key patterns]

## Code Style
[Formatting rules]

## Common Patterns
[Examples with code]
```

### 2. Domain Knowledge Skill

For specialized domain expertise (APIs, databases, frameworks):

```markdown
---
name: "working-with-graphql-apis"
description: "GraphQL API design patterns and best practices. Use when designing or implementing GraphQL schemas, resolvers, or queries. Do not use for REST APIs."
---

# GraphQL API Guidelines

## Schema Design
[Principles and examples]

## Resolver Patterns
[Common patterns]

## Query Optimization
[Performance tips]
```

### 3. Workflow Skill

For specialized workflows or methodologies:

```markdown
---
name: "applying-tdd-workflow"
description: "Test-Driven Development workflow guidance. Use when writing new features with TDD methodology. Do not use for legacy code or bug fixes."
---

# TDD Workflow

## Red-Green-Refactor Cycle

1. **Red**: Write failing test
2. **Green**: Minimal code to pass
3. **Refactor**: Clean up implementation

[Detailed steps and examples]
```

### 4. Tool Integration Skill

For specific tool usage patterns:

```markdown
---
name: "using-performance-profiler"
description: "Chrome DevTools performance profiling workflow. Use when analyzing runtime performance issues. Do not use for build-time optimization."
dependencies: chrome-devtools
---

# Performance Profiling Guide

## Recording Profiles
[Step-by-step]

## Analyzing Results
[What to look for]

## Common Bottlenecks
[Patterns and fixes]
```

## Progressive Disclosure

Keep SKILL.md focused (<500 lines). Move extensive details to REFERENCE.md:

**SKILL.md** (loaded immediately):
```markdown
## API Guidelines

- Use RESTful conventions
- Version all endpoints
- See [REFERENCE.md](REFERENCE.md) for detailed examples
```

**REFERENCE.md** (loaded on-demand):
```markdown
# API Guidelines Reference

## Detailed REST Conventions
[10 pages of examples]

## Versioning Strategies
[Extensive documentation]

## Authentication Patterns
[Detailed implementations]
```

## Validation Checklist

Before finalizing a Skill, verify:

- [ ] Name: lowercase, hyphens, gerund form, max 64 chars
- [ ] Description: under 200 chars, has WHAT + WHEN + WHEN NOT
- [ ] YAML frontmatter is valid
- [ ] Instructions are imperative, not conversational
- [ ] Concrete examples included
- [ ] "When to Use" section with explicit triggers
- [ ] Clear boundaries ("Do NOT use when...")
- [ ] Under 500 lines (or REFERENCE.md created)
- [ ] No time-sensitive information
- [ ] No first/second person ("you", "I")

## Anti-Patterns

### ❌ DON'T

- Use vague descriptions: "Helps with TypeScript"
- Skip "when NOT to use" boundaries
- Write conversational instructions: "You should first..."
- Include time-sensitive info: "As of 2025..."
- Make overly broad Skills: "coding-helper"
- Nest references deeper than one level
- Use Windows backslash paths

### ✅ DO

- Write specific descriptions: "Analyze TS performance bottlenecks..."
- Define clear boundaries: "Do not use for REST APIs"
- Use imperative form: "Follow these conventions..."
- Keep info timeless or version-specific
- Create focused Skills: "analyzing-typescript-performance"
- Use progressive disclosure (SKILL.md → REFERENCE.md)
- Use forward slashes (cross-platform)

## Testing Your Skill

After creating a Skill:

1. **Test activation**: Start a new chat, describe the Skill's trigger scenario
2. **Verify loading**: The AI should mention loading your Skill
3. **Check behavior**: Confirm the AI follows Skill instructions
4. **Debug mode**: Use `claude --debug` to see Skill discovery

If Skill doesn't activate:
- Make description more specific with explicit triggers
- Check name follows conventions (lowercase, hyphens)
- Verify YAML frontmatter is valid
- Ensure file is in correct location

## Examples of Great Skills

See `.ai/skills/core/` for production examples:
- `agnostic-ai-standards/` - Project standards Skill
- Check [official repository](https://github.com/anthropics/skills) for more

## Learn More

- [Claude Skills Documentation](https://docs.claude.com/en/docs/claude-code/skills)
- [Skill Authoring Best Practices](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices)
- [Official Skills Repository](https://github.com/anthropics/skills)
