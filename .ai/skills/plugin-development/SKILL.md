---
name: "plugin-development"
description: "Plugin development guidelines for agnostic-ai. Use when creating or modifying plugins in templates/plugins/. Do not use for general development tasks."
version: 1.0.0
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Plugin Development Guidelines

When creating or modifying plugins for agnostic-ai, follow these standards:

## Plugin Structure

Every plugin follows this structure:

```
templates/plugins/my-plugin/
├── commands/                  # Slash commands (optional)
│   ├── command1.md
│   └── command2.md
├── agents/                    # Background agents (optional)
│   ├── agent1.md
│   └── agent2.md
├── context/                   # Documentation & guidelines (optional)
│   ├── CONTEXT1.md
│   └── CONTEXT2.md
└── skills/                    # Auto-activated capabilities (optional)
    └── skill-name/
        └── SKILL.md
```

## Plugin Categories

### 1. Core Plugin
- **Location**: `templates/plugins/core/`
- **Purpose**: Essential commands and agents
- **Installation**: Always installed
- **Examples**: `/core:migrate`, `/core:skill-create`, `explore-codebase`

### 2. Language Plugins
- **Naming**: `lang-<language>` (e.g., `lang-node`, `lang-typescript`)
- **Purpose**: Language-specific coding standards and tools
- **Contents**: Primarily context files
- **Examples**: `lang-node/context/CODE-STYLE.md`

### 3. Integration Plugins
- **Examples**: `git`, `github`, `code-quality`
- **Purpose**: External tool integration
- **Contents**: Commands and agents for workflows
- **Examples**: `/github:code-pr-create`, `/git:code-commit`

### 4. Domain Plugins
- **Examples**: `image-manipulation`, custom business logic
- **Purpose**: Specific functionality domains
- **Contents**: Specialized commands and agents

## Creating a New Plugin

### Step 1: Create Directory Structure

```bash
mkdir -p templates/plugins/my-plugin/{commands,agents,context,skills}
```

### Step 2: Add Commands

Create `templates/plugins/my-plugin/commands/my-command.md`:

```yaml
---
allowed-tools: Bash(git:*), Read, Write
description: Brief one-line description
argument-hint: <action> <target>
---

You are a [role] specialist. [Purpose].

## Workflow

1. **PARSE**: Understand user intent
   - Extract arguments from $ARGUMENTS
   - Validate inputs

2. **EXECUTE**: Perform the action
   - Use allowed tools only
   - Provide clear feedback

3. **VERIFY**: Confirm success
   - Check results
   - Report to user

## Examples

[Concrete examples of usage]

## Anti-Patterns

### ❌ DON'T
- Common mistakes

### ✅ DO
- Best practices
```

### Step 3: Add Agents (Optional)

Create `templates/plugins/my-plugin/agents/my-agent.md`:

```yaml
---
name: my-agent
description: One-line capability statement for when to use this agent
color: blue
---

You are a [specialist]. [Core purpose].

## [Primary Phase]

[Direct instructions]
- Use tools appropriately
- Gather information systematically

## Output Format

[Exactly how to structure response]

## Execution Rules

- [Constraints]
- [Performance guidelines]

## Priority

[Primary goal] > [Secondary]. [Focus statement].
```

### Step 4: Add Context (Optional)

Create `templates/plugins/my-plugin/context/GUIDELINES.md`:

```markdown
# [Topic] Guidelines

## [Section 1]

- Guideline
- Pattern
- Example

## Examples

### Example 1
```[language]
[code]
```

## Anti-Patterns

### ❌ DON'T
[Bad practices]

### ✅ DO
[Good practices]
```

### Step 5: Add Skills (Optional)

Create `templates/plugins/my-plugin/skills/my-skill/SKILL.md`:

```yaml
---
name: "my-skill"
description: "What it does AND when to use it. Explicit triggers. When NOT to use."
version: 1.0.0
allowed-tools: Read, Grep, Glob
---

# [Skill Name]

[Brief purpose]

## Core Instructions

[Imperative instructions]

## When to Use

- [Trigger 1]
- [Trigger 2]

Do NOT use when:
- [Boundary 1]
- [Boundary 2]

## Guidelines

[Specific patterns and practices]

## Examples

[Concrete examples]
```

## Plugin Naming Conventions

### Command Names
```
Format: <verb>-<noun>.md
Examples:
  - code-commit.md
  - issue-process.md
  - pr-create.md
```

### Agent Names
```
Format: <role>-<specialty>.md
Examples:
  - explore-codebase.md
  - deep-search.md
  - fast-coder.md
```

### Skill Names
```
Format: <gerund>-<object>/SKILL.md
Examples:
  - analyzing-performance/
  - writing-tests/
  - reviewing-security/
```

### Context Names
```
Format: UPPER-CASE.md
Examples:
  - CODE-STYLE.md
  - TESTING.md
  - DEPENDENCIES.md
```

## Installation Process

When a user runs `.ai/cli plugins add my-plugin`:

1. **Copy commands** to `.ai/commands/my-plugin/`
2. **Copy agents** to `.ai/agents/my-plugin/`
3. **Copy context** to `.ai/context/my-plugin/`
4. **Copy skills** to `.ai/skills/my-plugin/`
5. **Update config** `.ai/config.jsonc` adds plugin to list
6. **IDE sync** Symlinks automatically include new plugin

## Command Patterns

### Pattern 1: Numbered Workflow
For sequential processes (git, CI, EPCT):

```markdown
## Workflow

1. **ACTION**: Description
   - Step detail
   - **CRITICAL**: Important note

2. **NEXT ACTION**: Continue
   - More details
```

### Pattern 2: Reference Format
For CLI tool wrappers:

```markdown
## [Category Name]

### [Subcategory]

```bash
# Command examples
tool command --flag
```

**Usage:**
- Explanation
- When to use
```

### Pattern 3: Section-Based Analysis
For research/analysis tasks:

```markdown
## [Phase Name]

**Goal**: What this achieves

- Action item 1
- Action item 2

**Output**: What to produce
```

## Testing Your Plugin

### Manual Testing

1. **Install plugin**:
   ```bash
   .ai/cli plugins add my-plugin
   ```

2. **Verify files copied**:
   ```bash
   ls -la .ai/commands/my-plugin/
   ls -la .ai/agents/my-plugin/
   ls -la .ai/context/my-plugin/
   ls -la .ai/skills/my-plugin/
   ```

3. **Test in IDE**:
   - Commands: Type `/my-plugin:my-command`
   - Agents: Verify in agents list
   - Context: Check AI references it
   - Skills: Test auto-activation

### Common Issues

**Commands not appearing:**
- Check `.ai/commands/my-plugin/` exists
- Verify `commands/` folder in plugin
- Restart IDE to refresh

**Agents not found:**
- Check `.ai/agents/my-plugin/` exists
- Verify frontmatter format
- Ensure `name` field matches filename

**Skills not activating:**
- Check description specificity
- Verify YAML frontmatter valid
- Ensure triggers are explicit
- Test with scenario matching description

## Plugin Dependencies

### Declaring Dependencies

In command or skill frontmatter:

```yaml
---
dependencies: jq, git, gh
---
```

### Checking Dependencies

In command workflow:

```markdown
1. **CHECK DEPENDENCIES**:
   ```bash
   if ! command -v jq &> /dev/null; then
       echo "Error: jq required"
       exit 1
   fi
   ```
```

## Distribution

### README for Plugin

Create `templates/plugins/my-plugin/README.md`:

```markdown
# My Plugin

Brief description of what this plugin provides.

## Contents

### Commands
- `/my-plugin:command1` - Description
- `/my-plugin:command2` - Description

### Agents
- `my-agent` - Description

### Context
- `GUIDELINES.md` - What it covers

### Skills
- `my-skill` - When it activates

## Installation

```bash
.ai/cli plugins add my-plugin
```

## Usage

[Examples of using the plugin]
```

### Contributing to Official Plugins

1. Test thoroughly on fresh installation
2. Follow all naming conventions
3. Include README.md
4. Document all commands/agents/skills
5. Submit PR to agnostic-ai repo

## Plugin Examples

### Minimal Plugin (Command Only)

```
templates/plugins/hello/
└── commands/
    └── greet.md
```

### Full-Featured Plugin

```
templates/plugins/code-quality/
├── README.md
├── commands/
│   ├── code-analyse.md
│   ├── code-ci.md
│   └── code-optimize.md
├── agents/
│   └── quality-checker.md
├── context/
│   └── QUALITY-STANDARDS.md
└── skills/
    └── reviewing-code/
        └── SKILL.md
```

## Best Practices

### Commands

1. **Single responsibility**: One command, one job
2. **Clear workflow**: Number steps for sequences
3. **Tool restrictions**: Use `allowed-tools` frontmatter
4. **User feedback**: Echo progress clearly
5. **Error handling**: Exit gracefully with messages

### Agents

1. **Focused purpose**: Specialized, not general
2. **Clear output format**: Specify exactly what to return
3. **Execution rules**: State constraints clearly
4. **Color coding**: Use appropriate color for type

### Context

1. **Concrete examples**: Show, don't just tell
2. **Anti-patterns**: Document what NOT to do
3. **Scannable**: Use headers and lists
4. **Up-to-date**: Remove obsolete information

### Skills

1. **Specific descriptions**: Include WHAT, WHEN, WHEN NOT
2. **Clear triggers**: Explicit scenarios for activation
3. **Imperative tone**: Direct instructions
4. **Progressive disclosure**: SKILL.md < 500 lines

## Anti-Patterns

### ❌ DON'T

**Overly Broad Plugin**
```
templates/plugins/everything/
├── commands/    (50 commands)
└── agents/      (30 agents)
```
Split into focused plugins instead.

**Missing Frontmatter**
```markdown
# My Command

Do the thing.
```
Always include YAML frontmatter.

**Vague Descriptions**
```yaml
description: Helps with code
```
Be specific about what it does.

**No Examples**
```markdown
## Usage
Run the command with arguments.
```
Show concrete examples.

### ✅ DO

**Focused Plugin**
```
templates/plugins/git/
└── commands/
    └── code-commit.md
```

**Complete Frontmatter**
```yaml
---
allowed-tools: Bash(git:*)
description: Auto-commit and push with minimal messages
---
```

**Specific Description**
```yaml
description: Create GitHub PR with auto-generated title and description from commits
```

**Clear Examples**
```markdown
## Examples

```bash
/git:code-commit
```

Result: Staged, committed, and pushed in one step.
```

## Summary

Good plugins are:

1. **Focused**: Single domain or purpose
2. **Complete**: All needed commands/agents/context/skills
3. **Documented**: README and clear descriptions
4. **Tested**: Works on fresh installation
5. **Consistent**: Follows naming and structure conventions

When in doubt, look at existing plugins (core, git, github, lang-node) as references!
