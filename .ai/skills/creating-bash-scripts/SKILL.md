---
name: "creating-bash-scripts"
description: "Bash scripting best practices for agnostic-ai project. Use when writing or reviewing bash scripts in .ai/cli, install.sh, update.sh, or IDE init scripts. Do not use for other languages."
version: 1.0.0
allowed-tools: Read, Grep, Glob
---

# Bash Scripting Standards for Agnostic AI

When writing bash scripts for agnostic-ai, follow these conventions:

## Script Header

Always start with:

```bash
#!/usr/bin/env bash
set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
```

## Error Handling

### Always Exit on Error

```bash
set -e  # At the top of every script
```

### Provide Clear Error Messages

```bash
if [ ! -f "package.json" ]; then
    echo -e "${RED}✗ Error: package.json not found${NC}"
    exit 1
fi
```

### Check Command Availability

```bash
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}⚠ Warning: jq not installed${NC}"
    # Provide fallback or skip
fi
```

## File Operations

### Check Before Operating

```bash
# Always verify directory exists before copying
if [ -d "$source_dir" ]; then
    mkdir -p "$dest_dir"
    cp -r "$source_dir" "$dest_dir"
fi
```

### Use Relative Symlinks

```bash
# ✅ Good - relative paths work across systems
ln -sf ../.ai/commands .claude/commands

# ❌ Bad - absolute paths break portability
ln -sf /absolute/path/.ai/commands .claude/commands
```

### Handle Spaces in Paths

```bash
# Always quote variables
if [ -f "$FILE_PATH" ]; then
    cat "$FILE_PATH"
fi
```

## Plugin Architecture Pattern

### Copying Plugin Files

Always check and copy in this order:

```bash
# Copy commands to .ai/commands/<plugin-name>/
if [ -d "$plugins_dir/$plugin_name/commands" ]; then
    mkdir -p .ai/commands
    cp -r "$plugins_dir/$plugin_name/commands" ".ai/commands/$plugin_name"
    echo -e "${GREEN}✓${NC} Commands → .ai/commands/$plugin_name/"
fi

# Copy agents to .ai/agents/<plugin-name>/
if [ -d "$plugins_dir/$plugin_name/agents" ]; then
    mkdir -p .ai/agents
    cp -r "$plugins_dir/$plugin_name/agents" ".ai/agents/$plugin_name"
    echo -e "${GREEN}✓${NC} Agents → .ai/agents/$plugin_name/"
fi

# Copy context to .ai/context/<plugin-name>/
if [ -d "$plugins_dir/$plugin_name/context" ]; then
    mkdir -p .ai/context
    cp -r "$plugins_dir/$plugin_name/context" ".ai/context/$plugin_name"
    echo -e "${GREEN}✓${NC} Context → .ai/context/$plugin_name/"
fi

# Copy skills to .ai/skills/<plugin-name>/
if [ -d "$plugins_dir/$plugin_name/skills" ]; then
    mkdir -p .ai/skills
    cp -r "$plugins_dir/$plugin_name/skills" ".ai/skills/$plugin_name"
    echo -e "${GREEN}✓${NC} Skills → .ai/skills/$plugin_name/"
fi
```

### Removing Old Plugin Files

```bash
# Remove old plugin files from .ai/<type>/<plugin>/
rm -rf ".ai/commands/$plugin" 2>/dev/null
rm -rf ".ai/agents/$plugin" 2>/dev/null
rm -rf ".ai/context/$plugin" 2>/dev/null
rm -rf ".ai/skills/$plugin" 2>/dev/null
```

## User Feedback

### Progress Messages

```bash
echo -e "${BLUE}📦 Installing plugin: $plugin_name${NC}"
echo -e "${GREEN}✓${NC} Commands → .ai/commands/$plugin_name/"
```

### Use Icons for Clarity

- ✓ (success) - `${GREEN}✓${NC}`
- ✗ (error) - `${RED}✗${NC}`
- ⚠ (warning) - `${YELLOW}⚠${NC}`
- 📦 (package/install) - `${BLUE}📦${NC}`
- 🔧 (configuration) - `${BLUE}🔧${NC}`
- 📋 (list/info) - `${BLUE}📋${NC}`

### Section Headers

```bash
echo ""
echo -e "${BLUE}🔧 Configuring IDE...${NC}"
```

## Variable Naming

```bash
# Use UPPER_CASE for constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE=".ai/config.jsonc"

# Use lower_case for local variables
plugin_name="core"
temp_dir=$(mktemp -d)
```

## Functions

### Define Functions Early

```bash
#!/usr/bin/env bash
set -e

# Function definitions
create_symlinks() {
    echo "Creating symlinks..."
    # Implementation
}

# Main script execution
create_symlinks
```

### Use Local Variables

```bash
function count_files() {
    local dir=$1
    local count=$(find "$dir" -name "*.md" | wc -l | tr -d ' ')
    echo "$count"
}
```

## Path Handling

### Get Script Directory

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

### Use Forward Slashes

```bash
# ✅ Good - works on all platforms
path="templates/plugins/core"

# ❌ Bad - Windows-specific
path="templates\plugins\core"
```

### Check Directory Existence

```bash
if [ -d ".ai" ]; then
    echo "Found .ai directory"
else
    echo "Creating .ai directory"
    mkdir -p .ai
fi
```

## Temporary Files

### Create and Clean Up

```bash
temp_file=$(mktemp)
trap "rm -f $temp_file" EXIT

# Use temp file
echo "data" > "$temp_file"
```

## JSON/JSONC Handling

### Using jq for JSON

```bash
if command -v jq &> /dev/null; then
    # Strip comments from JSONC
    config_json=$(grep -v '^\s*//' "$CONFIG_FILE" | sed 's|//.*||g')

    # Parse with jq
    echo "$config_json" | jq '.plugins'
else
    echo -e "${YELLOW}⚠ jq not installed, skipping JSON parsing${NC}"
fi
```

## IDE Configuration

### Symlink Creation Pattern

```bash
create_symlinks() {
    echo "📋 Setting up symlinks..."

    # Symlink main config
    if [ -f ".ai/AGENTS.md" ]; then
        ln -sf ../.ai/AGENTS.md .claude/CLAUDE.md
        echo -e "${GREEN}✓${NC} Linked .claude/CLAUDE.md → .ai/AGENTS.md"
    fi

    # Symlink directories
    if [ -d ".ai/commands" ]; then
        ln -sf ../.ai/commands .claude/commands
        echo -e "${GREEN}✓${NC} Linked .claude/commands/ → .ai/commands/"
    fi
}
```

## Common Patterns

### Loop Through Plugins

```bash
PLUGINS=($(echo "$config_json" | jq -r '.plugins[]' 2>/dev/null))

for plugin in "${PLUGINS[@]}"; do
    echo "Processing: $plugin"
    # Process plugin
done
```

### User Input

```bash
read -p "Which IDE? (1) Claude Code (2) Cursor: " choice

case $choice in
    1)
        echo "Setting up Claude Code..."
        ;;
    2)
        echo "Setting up Cursor..."
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac
```

### Multi-select Input

```bash
read -p "Select IDEs (space-separated, e.g., '1 2'): " choices

for choice in $choices; do
    case $choice in
        1) setup_claude ;;
        2) setup_cursor ;;
    esac
done
```

## Anti-Patterns

### ❌ DON'T

```bash
# Don't ignore errors
cp important_file.txt /dest  # No error checking

# Don't use absolute paths for symlinks
ln -sf /Users/martin/.ai/commands .claude/commands

# Don't forget to quote variables
if [ -f $FILE ]; then  # Breaks with spaces

# Don't use cat unnecessarily
cat file.txt | grep pattern  # Use grep directly

# Don't hardcode colors
echo "✓ Success"  # No color coding
```

### ✅ DO

```bash
# Check for errors
if ! cp important_file.txt /dest; then
    echo "Copy failed"
    exit 1
fi

# Use relative paths
ln -sf ../.ai/commands .claude/commands

# Quote variables
if [ -f "$FILE" ]; then

# Avoid useless cat
grep pattern file.txt

# Use color codes
echo -e "${GREEN}✓${NC} Success"
```

## Testing Scripts

### Dry Run Support

```bash
DRY_RUN=false

if [ "$1" = "--dry-run" ]; then
    DRY_RUN=true
fi

if [ "$DRY_RUN" = true ]; then
    echo "Would copy: $source → $dest"
else
    cp "$source" "$dest"
fi
```

### Verbose Mode

```bash
VERBOSE=false

if [ "$1" = "-v" ] || [ "$1" = "--verbose" ]; then
    VERBOSE=true
fi

log() {
    if [ "$VERBOSE" = true ]; then
        echo "$1"
    fi
}

log "Starting installation..."
```

## Summary

Key principles for bash scripts in agnostic-ai:

1. **Safety**: Use `set -e`, check before operations
2. **Portability**: Relative paths, forward slashes, quote variables
3. **User Experience**: Clear colors, progress feedback, helpful errors
4. **Consistency**: Follow plugin architecture patterns
5. **Maintainability**: Functions, clear variable names, comments for complex logic

Always test scripts on a fresh installation before committing!
