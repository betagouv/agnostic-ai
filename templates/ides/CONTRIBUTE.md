# Contributing IDE Support

> Guide to add support for a new AI-assisted IDE

## 🎯 Overview

This guide explains how to add support for a new IDE to the agnostic-ai system. Each IDE needs:
1. An `init.sh` script to set up configuration
2. A `.gitignore` file to ignore generated files
3. Documentation of the IDE's configuration format

## 📁 Structure

```
templates/ides/
├── CONTRIBUTE.md        # This file
├── your-ide/
│   ├── init.sh          # Setup script
│   └── .gitignore       # Files to ignore
└── claude/              # Example implementation
    ├── init.sh
    ├── .gitignore
    └── settings.json
```

## 🔧 Step 1: Create IDE Folder

```bash
mkdir -p templates/ides/your-ide
```

## 📝 Step 2: Create init.sh

Your `init.sh` must follow this pattern:

### Template Structure

```bash
#!/bin/bash
set -e

# ==============================================================================
# Your IDE Configuration Setup
# ==============================================================================
#
# Your IDE uses:
#   - .your-ide/config.ext           Main configuration file
#   - .your-ide/rules/               Optional rules directory
#
# Explain how your IDE reads configuration files
#
# ==============================================================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Global variables
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=".tmp/your-ide.backup_${TIMESTAMP}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==============================================================================
# Functions
# ==============================================================================

check_prerequisites() {
    if [ ! -d ".ai" ]; then
        echo -e "${YELLOW}⚠️  .ai folder not found. Run this from project root.${NC}"
        exit 1
    fi
}

backup_existing_config() {
    if [ ! -d ".your-ide" ]; then
        return 0
    fi

    echo -e "${YELLOW}⚠️  Existing .your-ide folder found. Backing up...${NC}"
    mkdir -p .tmp
    cp -r .your-ide "$BACKUP_DIR"
    echo -e "${GREEN}✓${NC} Backup created at $BACKUP_DIR"
}

preserve_user_customizations() {
    if [ ! -d ".your-ide" ]; then
        return 0
    fi

    echo "📦 Preserving your custom files..."

    # IMPORTANT: Ensure .ai directories exist before copying
    mkdir -p .ai/context .ai/commands .ai/agents .ai/avatars

    # Copy custom files (non-symlinks) to .ai/
    # Adapt this to your IDE's structure
    if [ -d ".your-ide/custom-files" ] && [ ! -L ".your-ide/custom-files" ]; then
        find .your-ide/custom-files -type f -name "*.ext" 2>/dev/null | while read file; do
            # Determine target directory based on file purpose:
            # - Configuration files → .ai/context/
            # - Commands → .ai/commands/
            # - Agents → .ai/agents/
            # - UI/behavior profiles → .ai/avatars/

            filename=$(basename "$file")
            cp "$file" ".ai/context/$filename"
            echo -e "${GREEN}✓${NC} Copied custom file: $filename"
        done
    fi
}

cleanup_old_config() {
    if [ ! -d ".your-ide" ]; then
        return 0
    fi

    rm -rf .your-ide
    echo -e "${GREEN}✓${NC} Old .your-ide folder removed"
}

create_directory_structure() {
    mkdir -p .your-ide
}

create_symlinks() {
    echo "📋 Setting up Your IDE configuration..."

    # Example 1: Symlink main config file
    if [ -f ".ai/AGENTS.md" ]; then
        ln -sf ../.ai/AGENTS.md .your-ide/config.ext
        echo -e "${GREEN}✓${NC} Linked .your-ide/config.ext → .ai/AGENTS.md"
    fi

    # Example 2: Symlink entire folders (recommended for dynamic updates)
    if [ -d ".ai/context" ]; then
        ln -sf ../.ai/context .your-ide/rules
        echo -e "${GREEN}✓${NC} Linked .your-ide/rules/ → .ai/context/"
    fi
}

copy_static_files() {
    # Example 3: Copy static files (if IDE doesn't support symlinks)
    if [ -f "$SCRIPT_DIR/settings.json" ]; then
        cp "$SCRIPT_DIR/settings.json" .your-ide/settings.json
        echo -e "${GREEN}✓${NC} Copied settings.json"
    fi
}

print_summary() {
    echo ""
    echo -e "${BLUE}✅ Your IDE setup complete!${NC}"
    echo ""
    echo "Structure created:"
    echo "  .your-ide/config.ext             → .ai/AGENTS.md"
    echo "  .your-ide/rules/                 → .ai/context/"
    echo ""
    echo "✨ Dynamic updates: Changes to .ai/ are immediately available!"
    echo ""
    if [ -d ".tmp" ]; then
        echo -e "${BLUE}📦 Backup files are stored in .tmp/${NC}"
    fi
}

# ==============================================================================
# Main execution
# ==============================================================================

main() {
    echo "🔧 Setting up Your IDE configuration..."

    check_prerequisites
    backup_existing_config
    preserve_user_customizations
    cleanup_old_config
    create_directory_structure
    create_symlinks
    copy_static_files
    print_summary
}

main
```

### Key Requirements

**✅ Must Have:**
1. Shebang: `#!/bin/bash`
2. `set -e` to exit on errors
3. Color variables for output
4. Check for `.ai/` folder existence
5. Backup existing configuration
6. **Preserve user customizations** by copying to `.ai/`
7. Create necessary directories
8. Symlink or copy files from `.ai/` to IDE location
9. Clear success message

**❌ Must Not:**
- Overwrite user files without backup
- Hard-code paths (use relative paths)
- Fail silently
- Delete `.ai/` folder or its contents

## 🚫 Step 3: Create .gitignore

Create `.gitignore` to exclude generated IDE files:

```gitignore
# Your IDE - Ignore entire folder (dynamically generated symlinks)
.your-ide/
```

If your IDE creates specific files:

```gitignore
# Your IDE - Ignore generated files
.your-ide/config.ext
.your-ide/rules/
.your-ide/cache/
```

## 📚 Step 4: Document IDE-Specific Details

### Create README.md (optional)

If your IDE has special requirements, create `templates/ides/your-ide/README.md`:

```markdown
# Your IDE Configuration

## Requirements

- Your IDE version X.Y.Z or higher
- [Special dependencies if any]

## File Format

Your IDE reads configuration in [format description].

### Example Config

\`\`\`ext
# Example of your IDE's config format
key: value
\`\`\`

## Symlink Support

- ✅ Supports symlinks: Yes/No
- ✅ Supports nested directories: Yes/No
- ⚠️  Character limits: [if any]

## Testing

To test the configuration:

1. Run `bash templates/ides/your-ide/init.sh`
2. Open Your IDE
3. Verify configuration is loaded
```

## 🧪 Step 5: Test Your Implementation

### Test Checklist

- [ ] Script runs without errors
- [ ] Backup is created when config exists
- [ ] User files are copied to `.ai/`
- [ ] Symlinks/copies are created correctly
- [ ] IDE loads configuration successfully
- [ ] Changes to `.ai/` files reflect in IDE
- [ ] Script is idempotent (can run multiple times)

### Test Scenarios

```bash
# Scenario 1: Fresh installation
rm -rf .your-ide .ai
bash templates/ides/your-ide/init.sh
# Should create .your-ide with symlinks

# Scenario 2: Existing configuration
# Add some files to .your-ide/
bash templates/ides/your-ide/init.sh
# Should backup and preserve user files in .ai/

# Scenario 3: Re-run after changes
bash templates/ides/your-ide/init.sh
# Should work without errors
```

## 📋 Step 6: Integration

### Update install.sh

The `install.sh` script automatically discovers IDEs in `templates/ides/`. No changes needed!

It will:
1. Find your IDE folder
2. Display it as an option during installation
3. Run your `init.sh` if selected
4. Append your `.gitignore` to the project

### Update Documentation

Add your IDE to the main README.md:

```markdown
| Your IDE | ✅ Full | `.your-ide/config.ext` |
```

## 🎯 Real Examples

### Example 1: Claude Code (Symlinks)

```bash
# Symlinks entire folders for dynamic updates
ln -sf ../.ai/commands .claude/commands
ln -sf ../.ai/agents .claude/agents
ln -sf ../.ai/avatars .claude/output-styles

# Main config file
ln -sf ../.ai/AGENTS.md .claude/CLAUDE.md
```

**Why:** Claude supports symlinks and nested folders, perfect for dynamic updates.

### Example 2: Cursor (Symlinks)

```bash
# Main config
ln -sf ../../.ai/AGENTS.md .cursor/rules/main.mdc

# Context folder
ln -sf ../../.ai/context .cursor/rules/context
```

**Why:** Cursor uses `.mdc` format and reads all files in `rules/` folder.

### Example 3: IDE Without Symlink Support

```bash
# Copy files instead of symlinks
cp .ai/AGENTS.md .your-ide/config.ext

# Note: Users must re-run init.sh after changes
echo "⚠️  Note: Re-run this script after modifying .ai/ files"
```

**Why:** Some IDEs or systems don't support symlinks.

## 🔍 Mapping Table

| IDE Feature | Maps to .ai/ |
|-------------|--------------|
| Main config file | `.ai/AGENTS.md` |
| Rules/directives | `.ai/context/*.md` |
| Custom commands | `.ai/commands/*.md` |
| Specialized agents | `.ai/agents/*.md` |
| Behavior profiles | `.ai/avatars/*.md` |

## 💡 Tips

### Symlinks vs Copies

**Use Symlinks** when:
- ✅ IDE supports symlinks
- ✅ You want automatic updates when `.ai/` changes
- ✅ IDE can follow symlinked directories

**Use Copies** when:
- ❌ IDE doesn't support symlinks
- ❌ Windows compatibility required
- ❌ IDE reads config once at startup

### File Format Conversion

If your IDE uses a different format:

```bash
# Convert .md to .your-format
if [ -f ".ai/AGENTS.md" ]; then
    # Simple rename
    cp .ai/AGENTS.md .your-ide/config.your-format

    # Or transform content
    cat .ai/AGENTS.md | your-transformer > .your-ide/config.your-format
fi
```

### Handling Multiple Config Files

```bash
# If IDE requires multiple files
for file in .ai/context/*.md; do
    filename=$(basename "$file")
    ln -sf "../../.ai/context/$filename" ".your-ide/rules/$filename"
done
```

## 📞 Questions?

1. Check existing implementations: `claude/init.sh`, `cursor/init.sh`
2. Open an issue: [GitHub Issues](https://github.com/betagouv/agnostic-ai/issues)
3. Test with `bash -x init.sh` for debug output

## 🔌 MCP Configuration

To support MCP (Model Context Protocol) for your IDE, create an `mcp-config.jsonc` template file:

### Location

`templates/ides/<your-ide>/mcp-config.jsonc`

**Important:**
- Template files are stored in `templates/ides/*/mcp-config.jsonc` (committed as templates)
- The CLI copies this content into `.ai/config.local.jsonc` under `ides.<ide-name>.mcp-config` (gitignored)
- Do NOT store MCP configs in `.ai/ides/` - they should not be committed

### Template Format

Create `templates/ides/<your-ide>/mcp-config.jsonc`:

```jsonc
{
  // Location where your IDE stores MCP server configurations
  "location": "~/path/to/ide/config.json",

  // Merge strategy: overwrite or merge-key
  "strategy": "overwrite" | "merge-key",

  // The key in the target file (only for merge-key strategy)
  "key": "mcpServers"
}
```

### User Configuration

When a user runs `.ai/cli configure` and selects your IDE, the CLI will copy this template into `.ai/config.local.jsonc`:

```jsonc
{
  "ides": {
    "your-ide": {
      "mcp-config": {
        "location": "~/path/to/ide/config.json",
        "strategy": "overwrite"
      }
    }
  }
}
```

### Strategies

**1. overwrite** - Replace entire file with MCP config

Example (Cursor):
```jsonc
{
  // Location where Cursor stores MCP server configurations
  "location": "~/.cursor/mcp.json",

  // Merge strategy: overwrite will replace the entire file
  "strategy": "overwrite"
}
```

The CLI will write `{"mcpServers": {...}}` directly to the file.

**2. merge-key** - Merge into existing config under a specific key

Example (Claude):
```jsonc
{
  // Location where Claude stores MCP server configurations
  "location": "~/.claude.json",

  // Merge strategy: merge-key will merge new servers with existing ones
  "strategy": "merge-key",

  // The key in the target file where MCP servers are stored
  "key": "mcpServers"
}
```

The CLI will read the existing `~/.claude.json`, update the `mcpServers` key, and write it back.

### How It Works

1. User runs `.ai/cli configure` and selects your IDE
2. Your `init.sh` runs to set up symlinks
3. The CLI reads `templates/ides/<your-ide>/mcp-config.jsonc`
4. The CLI copies the mcp-config content into `.ai/config.local.jsonc` under `ides.<your-ide>.mcp-config`
5. User runs `.ai/cli mcp use <server>`
6. The CLI reads `.ai/config.local.jsonc` to get the mcp-config for the IDE
7. The strategy is applied to write MCP servers to the IDE's config file

**No code changes needed** - just add the JSONC template!

### Testing MCP Support

```bash
# Configure your IDE
.ai/cli configure

# Install MCP templates
.ai/cli mcp install

# Test MCP
.ai/cli mcp use filesystem

# Verify config was written
cat ~/path/to/your/ide/config.json
```

## ✅ Checklist

Before submitting your IDE support:

- [ ] `init.sh` follows the template structure
- [ ] Backup is created for existing configs
- [ ] User customizations are preserved in `.ai/`
- [ ] `.gitignore` file created
- [ ] Script is executable: `chmod +x init.sh`
- [ ] `mcp-config.json` created with correct location and strategy
- [ ] Tested in fresh installation
- [ ] Tested with existing configuration
- [ ] Tested MCP support (install, use, unuse)
- [ ] Documentation added (README.md if needed)
- [ ] Works on macOS and Linux

---

**Need help?** Open an issue or check existing IDE implementations for reference.
