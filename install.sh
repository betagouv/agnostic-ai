#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Repository information
REPO_URL="https://github.com/betagouv/agnostic-ai"

echo -e "${BLUE}"
echo "🤖 AI CLI - Unified Configuration for AI Tools"
echo "===============================================${NC}"
echo ""

# Check dependencies
check_dependency() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}❌ Error: $1 is not installed${NC}"
        echo "Please install $1 and try again"
        exit 1
    fi
}

echo "Checking dependencies..."
check_dependency "curl"
check_dependency "git"
echo -e "${GREEN}✓ All dependencies found${NC}"
echo ""

# Check if git working directory is clean
if [ -d ".git" ]; then
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        echo -e "${RED}❌ Git working directory is not clean${NC}"
        echo -e "${YELLOW}   Please commit or stash your changes before running install${NC}"
        echo ""
        echo "Uncommitted changes:"
        git status --short
        exit 1
    fi
    echo -e "${GREEN}✓ Git working directory is clean${NC}"
    echo ""
fi

# Check if .ai directory already exists
if [ -d ".ai" ]; then
    echo -e "${YELLOW}⚠️  .ai folder already exists${NC}"
    echo ""
    echo -e "${BLUE}AI CLI (unified AI configuration) is already installed in this project.${NC}"
    echo ""
    echo "To manage your installation, use:"
    echo -e "  ${GREEN}.ai/cli plugins list${NC}       - List available plugins"
    echo -e "  ${GREEN}.ai/cli plugins add <name>${NC} - Install a plugin"
    echo -e "  ${GREEN}.ai/cli update${NC}             - Update agnostic-ai and plugins"
    echo ""
    echo -e "${YELLOW}⚠️  Re-installing will overwrite your configuration!${NC}"
    echo ""
    read -p "Do you still want to reinstall? (y/N): " -n 1 -r </dev/tty
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Installation cancelled${NC}"
        exit 0
    fi
fi

# Check if we're running from within the repository (for local development/testing)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLEANUP_TEMP=false

if [ -d "$SCRIPT_DIR/templates/ides" ]; then
    echo "Using local templates (development mode)..."
    TEMP_DIR="$SCRIPT_DIR"
else
    # Create temporary directory and clone repository
    TEMP_DIR=$(mktemp -d)
    CLEANUP_TEMP=true

    # Clone repository to temp directory
    echo "Fetching templates..."
    git clone --depth 1 --quiet "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
        echo -e "${RED}❌ Failed to download templates${NC}"
        exit 1
    }
fi

# Cleanup temp directory only if we created it
if [ "$CLEANUP_TEMP" = true ]; then
    trap "rm -rf $TEMP_DIR" EXIT
fi

# Project information
echo -e "${BLUE}Project Information${NC}"
read -p "Project name [$(basename "$PWD")]: " PROJECT_NAME </dev/tty
PROJECT_NAME=${PROJECT_NAME:-$(basename "$PWD")}

echo ""
echo -e "${BLUE}📝 Creating AI configuration structure...${NC}"
echo ""

# Copy .ai folder structure
echo "Creating .ai structure..."
cp -r "$TEMP_DIR/templates/.ai" .

# Copy .gitignore template if it exists
if [ -f "$TEMP_DIR/templates/.gitignore" ]; then
    if [ ! -f .gitignore ]; then
        cp "$TEMP_DIR/templates/.gitignore" .gitignore
    else
        # Append template to existing .gitignore
        cat "$TEMP_DIR/templates/.gitignore" >> .gitignore
    fi
    echo -e "${GREEN}✓${NC} Updated .gitignore"
fi

# Replace placeholders in all .ai files
echo "Customizing templates with your project info..."

# Function to replace placeholders
replace_placeholders() {
    local file="$1"
    if [ -f "$file" ]; then
        sed -i.bak \
            -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
            -e "s/{{FRAMEWORK}}/Core/g" \
            "$file"
        rm -f "${file}.bak"
    fi
}

# Replace in all markdown files in .ai/
find .ai -name "*.md" -type f | while read file; do
    replace_placeholders "$file"
done

echo -e "${GREEN}✓ Created .ai structure${NC}"

# Install core plugin (always installed)
echo ""
echo -e "${BLUE}📦 Installing core plugin...${NC}"

if [ -d "$TEMP_DIR/templates/plugins/core/commands" ]; then
    mkdir -p .ai/commands
    cp -r "$TEMP_DIR/templates/plugins/core/commands" .ai/commands/core
    echo -e "${GREEN}✓${NC} Commands → .ai/commands/core/"
fi

if [ -d "$TEMP_DIR/templates/plugins/core/agents" ]; then
    mkdir -p .ai/agents
    cp -r "$TEMP_DIR/templates/plugins/core/agents" .ai/agents/core
    echo -e "${GREEN}✓${NC} Agents → .ai/agents/core/"
fi

if [ -d "$TEMP_DIR/templates/plugins/core/context" ]; then
    mkdir -p .ai/context
    cp -r "$TEMP_DIR/templates/plugins/core/context" .ai/context/core
    echo -e "${GREEN}✓${NC} Context → .ai/context/core/"
fi

echo -e "${GREEN}✓ Core plugin installed${NC}"

# Create .ai/config.jsonc
echo ""
echo -e "${BLUE}📝 Creating .ai/config.jsonc...${NC}"

cat > .ai/config.jsonc << 'EOF'
{
  // Unified AI Configuration
  // This file is committed to git and shared across the team and all AI tools

  "version": "1.0.0",

  // Installed plugins
  "plugins": ["core"]
}
EOF

echo -e "${GREEN}✓ Created .ai/config.jsonc${NC}"

# Configure IDE symlinks
echo ""
.ai/cli configure

echo ""
echo -e "${GREEN}✅ AI configuration initialized successfully!${NC}"
echo ""
echo -e "${BLUE}Plugins installed:${NC} core"
echo ""

# Show next steps
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Review files in .ai/ folder"
echo "  2. Commit .ai/ to git (including config.jsonc)"
echo ""
echo -e "${BLUE}Migrate existing documentation to .ai folder:${NC}"
echo "  .ai/cli migrate                - Migrate existing documentation to .ai folder"
echo ""
echo -e "${BLUE}Manage plugins:${NC}"
echo "  .ai/cli plugins list             - List available plugins"
echo "  .ai/cli plugins add <name>       - Install a plugin"
echo ""
echo -e "${BLUE}Update:${NC}"
echo "  .ai/cli update                   - Update agnostic-ai and plugins"
echo ""
echo -e "${BLUE}Configure IDEs:${NC}"
echo "  .ai/cli configure                - Set up IDE symlinks (run again to add more IDEs)"
echo ""
