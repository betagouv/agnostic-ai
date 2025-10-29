#!/bin/bash
set -e

# ==============================================================================
# Claude Code Configuration Setup
# ==============================================================================
#
# Claude Code uses:
#   - .claude/CLAUDE.md                Main configuration file
#   - .claude/commands/                Custom slash commands (supports nested folders)
#   - .claude/agents/                  Specialized agents
#   - .claude/output-styles/           AI behavior profiles (personas)
#
# All of these use SYMLINKS for dynamic updates - no manual sync needed!
#
# ==============================================================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Global variables
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=".tmp/claude.backup_${TIMESTAMP}"
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
    if [ ! -d ".claude" ]; then
        return 0
    fi

    echo -e "${YELLOW}⚠️  Existing .claude folder found. Backing up...${NC}"
    mkdir -p .tmp
    cp -r .claude "$BACKUP_DIR"
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
    if [ ! -d ".claude" ]; then
        return 0
    fi

    echo "📦 Preserving your custom files..."

    # Ensure .ai directories exist
    mkdir -p .ai/commands .ai/agents .ai/avatars

    # List known mapped folders
    known_folders=(commands agents output-styles)

    # Handle known folders and also copy any other custom folders
    for folder in .claude/*; do
        [ -d "$folder" ] || continue
        [ -L "$folder" ] && continue  # Skip if it's a symlink

        folder_name="$(basename "$folder")"

        # Determine .ai target dir
        if [[ "$folder_name" == "commands" ]]; then
            find "$folder" -type f ! -type l -name "*.md" 2>/dev/null | while read file; do
                relative_path="${file#$folder/}"
                dest_dir=".ai/commands/$(dirname "$relative_path")"
                mkdir -p "$dest_dir"
                cp "$file" "$dest_dir/"
                echo -e "${GREEN}✓${NC} Copied custom command: $relative_path → .ai/commands/"
            done
        elif [[ "$folder_name" == "agents" ]]; then
            find "$folder" -type f ! -type l -name "*.md" 2>/dev/null | while read file; do
                cp "$file" ".ai/agents/"
                echo -e "${GREEN}✓${NC} Copied custom agent: $(basename "$file") → .ai/agents/"
            done
        elif [[ "$folder_name" == "output-styles" ]]; then
            find "$folder" -type f ! -type l -name "*.md" 2>/dev/null | while read file; do
                cp "$file" ".ai/avatars/"
                echo -e "${GREEN}✓${NC} Copied custom avatar: $(basename "$file") → .ai/avatars/"
            done
        else
            # For any other folder, copy its full tree to .ai/<folder_name>/
            mkdir -p ".ai/${folder_name}"
            cp -R "$folder/." ".ai/${folder_name}/"
            echo -e "${GREEN}✓${NC} Copied custom folder: $folder_name → .ai/${folder_name}/"
        fi
    done
}

cleanup_old_config() {
    if [ ! -d ".claude" ]; then
        return 0
    fi

    rm -rf .claude
    echo -e "${GREEN}✓${NC} Old .claude folder removed"
}

create_directory_structure() {
    mkdir -p .claude
}

create_symlinks() {
    echo "📋 Setting up Claude Code symlinks..."

    # Symlink CLAUDE.md (main config)
    if [ -f ".ai/AGENTS.md" ]; then
        ln -sf ../.ai/AGENTS.md .claude/CLAUDE.md
        echo -e "${GREEN}✓${NC} Linked .claude/CLAUDE.md → .ai/AGENTS.md"
    fi

    # Symlink entire directories
    if [ -d ".ai/commands" ]; then
        ln -sf ../.ai/commands .claude/commands
        echo -e "${GREEN}✓${NC} Linked .claude/commands/ → .ai/commands/"
    fi

    if [ -d ".ai/agents" ]; then
        ln -sf ../.ai/agents .claude/agents
        echo -e "${GREEN}✓${NC} Linked .claude/agents/ → .ai/agents/"
    fi

    if [ -d ".ai/context" ]; then
        ln -sf ../.ai/context .claude/context
        echo -e "${GREEN}✓${NC} Linked .claude/context/ → .ai/context/"
    fi

    if [ -d ".ai/avatars" ]; then
        ln -sf ../.ai/avatars .claude/output-styles
        echo -e "${GREEN}✓${NC} Linked .claude/output-styles/ → .ai/avatars/"
    fi

    if [ -d ".ai/skills" ]; then
        ln -sf ../.ai/skills .claude/skills
        echo -e "${GREEN}✓${NC} Linked .claude/skills/ → .ai/skills/"
    fi
}

copy_static_files() {
    # Copy settings.json if it exists in templates
    if [ -f "$SCRIPT_DIR/settings.json" ]; then
        cp "$SCRIPT_DIR/settings.json" .claude/settings.json
        echo -e "${GREEN}✓${NC} Copied settings.json → .claude/settings.json"
    fi

    # Copy Claude-specific scripts
    if [ -d "$SCRIPT_DIR/scripts" ]; then
        mkdir -p .ai/scripts/claude
        cp -r "$SCRIPT_DIR/scripts"/* .ai/scripts/claude/
        echo -e "${GREEN}✓${NC} Copied Claude scripts → .ai/scripts/claude/"
    fi
}

print_summary() {
    echo ""
    echo -e "${BLUE}✅ Claude Code setup complete!${NC}"
    echo ""
    echo "Structure created:"
    echo "  .claude/CLAUDE.md                → .ai/AGENTS.md"
    echo "  .claude/commands/                → .ai/commands/"
    echo "  .claude/agents/                  → .ai/agents/"
    echo "  .claude/context/                 → .ai/context/"
    echo "  .claude/output-styles/           → .ai/avatars/"
    echo "  .claude/settings.json            (copied from templates)"
    echo "  .ai/scripts/claude/              (Claude-specific scripts)"
    echo ""
    if [ -d ".tmp" ]; then
        echo -e "${BLUE}📦 Backup files are stored in .tmp/${NC}"
    fi
    echo ""
    echo -e "${BLUE}💡 Recommended: Set up shell aliases for faster Claude CLI access${NC}"
    echo ""
    echo "Add these aliases to your ~/.zshrc or ~/.bashrc:"
    echo ""
    echo -e "${GREEN}  alias cc=\"claude --dangerously-skip-permissions\"${NC}"
    echo -e "${GREEN}  alias ccc=\"claude --dangerously-skip-permissions -c\"${NC}"
    echo ""
    echo "Why --dangerously-skip-permissions is safe:"
    echo "  • Claude settings.json includes PreToolsBash hook"
    echo "  • PreToolsBash safely intercepts potentially destructive commands"
    echo "  • You get faster workflow without compromising safety"
    echo ""
    echo "Usage after setting aliases:"
    echo "  cc               - Start Claude CLI without permission prompts"
    echo "  ccc              - Start Claude CLI and continue previous conversation"
    echo ""
}

# ==============================================================================
# Main execution
# ==============================================================================

main() {
    echo "🔧 Setting up Claude Code configuration..."

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
