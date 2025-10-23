#!/bin/bash
set -e

# ==============================================================================
# Cursor IDE Configuration Setup
# ==============================================================================
#
# Cursor uses:
#   - .cursor/rules/*.mdc              Markdown files with AI rules
#   - .cursor/rules/main.mdc           Main configuration (required)
#
# Cursor reads ALL .mdc files in .cursor/rules/ and can reference them with @
#
# We use SYMLINKS so any changes to .ai/ are immediately available.
#
# ==============================================================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Global variables
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=".tmp/cursor.backup_${TIMESTAMP}"

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
    if [ ! -d ".cursor" ]; then
        return 0
    fi

    echo -e "${YELLOW}⚠️  Existing .cursor folder found. Backing up...${NC}"
    mkdir -p .tmp
    cp -r .cursor "$BACKUP_DIR"
    echo -e "${GREEN}✓${NC} Backup created at $BACKUP_DIR"
}

get_installed_plugins() {
    if [ ! -f ".ai/config.jsonc" ]; then
        echo ""
        return
    fi

    # Strip comments from JSONC
    local config_json=$(grep -v '^\s*//' ".ai/config.jsonc" | sed 's|//.*||g')

    # Check if jq is available
    if command -v jq &> /dev/null; then
        echo "$config_json" | jq -r '.plugins[]' 2>/dev/null || echo ""
    else
        # Fallback: simple grep/sed parsing
        echo "$config_json" | grep -o '"plugins":\s*\[.*\]' | sed 's/.*\[//' | sed 's/\].*//' | tr ',' '\n' | tr -d ' "' | grep -v '^$'
    fi
}

preserve_user_customizations() {
    if [ ! -d ".cursor" ]; then
        return 0
    fi

    echo "📦 Preserving custom files..."

    # Ensure .ai directories exist
    mkdir -p .ai/context .ai/commands .ai/agents

    # Copy custom rules (non-symlink .mdc and .md files)
    if [ -d ".cursor/rules" ]; then
        find .cursor/rules -type f ! -type l \( -name "*.mdc" -o -name "*.md" \) 2>/dev/null | while read file; do
            filename=$(basename "$file")
            if [ "$filename" != "main.mdc" ]; then
                # Skip symlinked directories content
                if [ ! -L "$file" ]; then
                    cp "$file" ".ai/context/${filename}"
                    echo -e "${GREEN}✓${NC} Copied custom rule: $filename → .ai/context/"
                fi
            fi
        done
    fi

    # Copy custom commands
    if [ -d ".cursor/commands" ]; then
        find .cursor/commands -type f ! -type l -name "*.md" 2>/dev/null | while read file; do
            relative_path="${file#.cursor/commands/}"
            # Skip symlinked directories
            if [ ! -L "$file" ]; then
                dest_dir=".ai/commands/$(dirname "$relative_path")"
                mkdir -p "$dest_dir"
                cp "$file" "$dest_dir/"
                echo -e "${GREEN}✓${NC} Copied custom command: $relative_path → .ai/commands/"
            fi
        done
    fi

    # Copy custom agents
    if [ -d ".cursor/agents" ]; then
        find .cursor/agents -type f ! -type l -name "*.md" 2>/dev/null | while read file; do
            if [ ! -L "$file" ]; then
                cp "$file" ".ai/agents/"
                echo -e "${GREEN}✓${NC} Copied custom agent: $(basename "$file") → .ai/agents/"
            fi
        done
    fi

    # Copy any non-standard directories/files from .cursor/ to .ai/<item_name>/
    echo "📦 Preserving non-standard directories..."
    for item in .cursor/*; do
        if [ ! -e "$item" ]; then
            continue
        fi

        item_name=$(basename "$item")

        # Skip the known directories (already handled above)
        if [ "$item_name" = "rules" ] || [ "$item_name" = "commands" ] || [ "$item_name" = "agents" ]; then
            continue
        fi

        # Copy unknown items to .ai/<item_name>/
        if [ -d "$item" ] && [ ! -L "$item" ]; then
            mkdir -p ".ai/${item_name}"
            cp -r "$item/." ".ai/${item_name}/"
            echo -e "${GREEN}✓${NC} Copied custom directory: $item_name/ → .ai/${item_name}/"
        elif [ -f "$item" ]; then
            mkdir -p ".ai"
            cp "$item" ".ai/$item_name"
            echo -e "${GREEN}✓${NC} Copied custom file: $item_name → .ai/"
        fi
    done
}

cleanup_old_config() {
    if [ ! -d ".cursor" ]; then
        return 0
    fi

    rm -rf .cursor
    echo -e "${GREEN}✓${NC} Old .cursor folder removed"
}

create_directory_structure() {
    mkdir -p .cursor/rules
}

create_symlinks() {
    echo "📋 Creating Cursor configuration..."

    # Symlink main.mdc (main config)
    if [ -f ".ai/AGENTS.md" ]; then
        ln -sf ../../.ai/AGENTS.md .cursor/rules/main.mdc
        echo -e "${GREEN}✓${NC} Linked .cursor/rules/main.mdc → .ai/AGENTS.md"
    fi

    # Get installed plugins
    local plugins=($(get_installed_plugins))

    # Symlink each plugin's context into .cursor/rules/
    for plugin in "${plugins[@]}"; do
        if [ -d ".ai/context/$plugin" ]; then
            ln -sf "../../../.ai/context/$plugin" ".cursor/rules/$plugin"
            echo -e "${GREEN}✓${NC} Linked .cursor/rules/$plugin/ → .ai/context/$plugin/"
        fi
    done

    # Create base directories for commands and agents
    mkdir -p .cursor/commands .cursor/agents

    # Symlink each plugin's commands and agents
    for plugin in "${plugins[@]}"; do
        if [ -d ".ai/commands/$plugin" ]; then
            ln -sf "../../.ai/commands/$plugin" ".cursor/commands/$plugin"
            echo -e "${GREEN}✓${NC} Linked .cursor/commands/$plugin/ → .ai/commands/$plugin/"
        fi

        if [ -d ".ai/agents/$plugin" ]; then
            ln -sf "../../.ai/agents/$plugin" ".cursor/agents/$plugin"
            echo -e "${GREEN}✓${NC} Linked .cursor/agents/$plugin/ → .ai/agents/$plugin/"
        fi
    done
}

print_summary() {
    echo ""
    echo -e "${BLUE}✅ Cursor setup complete!${NC}"
    echo ""
    echo "Structure created:"
    echo "  .cursor/rules/main.mdc           → .ai/AGENTS.md"
    echo "  .cursor/rules/<plugin>/          → .ai/context/<plugin>/"
    echo "  .cursor/commands/<plugin>/       → .ai/commands/<plugin>/"
    echo "  .cursor/agents/<plugin>/         → .ai/agents/<plugin>/"
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
    echo "🔧 Setting up Cursor configuration..."

    check_prerequisites
    backup_existing_config
    preserve_user_customizations
    cleanup_old_config
    create_directory_structure
    create_symlinks
    print_summary
}

main
