#!/bin/bash
# Migration for v1.2.0: Convert config.local.jsonc from array to nested object format
# This migration embeds MCP configurations directly into config.local.jsonc

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Running migration: v1.2.0${NC}"
echo "  Converting config.local.jsonc to nested format with embedded MCP configs"
echo ""

# Paths
AI_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/.ai"
PROJECT_ROOT="$(dirname "$AI_ROOT")"
CONFIG_LOCAL="$AI_ROOT/config.local.jsonc"

# Check if config.local.jsonc exists
if [ ! -f "$CONFIG_LOCAL" ]; then
    echo "  No config.local.jsonc found, skipping migration"
    exit 0
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}  ⚠️  jq not found, skipping migration${NC}"
    exit 0
fi

# Strip comments and parse
config_json=$(grep -v '^\s*//' "$CONFIG_LOCAL" | sed 's|//.*||g')

# Check if migration is needed (old format uses array)
is_array=$(echo "$config_json" | jq -e '.ides | type == "array"' 2>/dev/null || echo "false")

if [ "$is_array" != "true" ]; then
    echo "  Config already in new format, skipping migration"
    exit 0
fi

echo -e "  ${YELLOW}Old format detected, migrating...${NC}"

# Get list of IDEs from old format
old_ides=($(echo "$config_json" | jq -r '.ides[]' 2>/dev/null))

if [ ${#old_ides[@]} -eq 0 ]; then
    echo "  No IDEs configured, skipping migration"
    exit 0
fi

# Determine templates directory
TEMPLATES_DIR=""
if [ -d "$PROJECT_ROOT/templates/ides" ]; then
    # Development mode or templates in project
    TEMPLATES_DIR="$PROJECT_ROOT/templates/ides"
else
    # Try to download templates
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT

    if git clone --depth 1 --quiet https://github.com/betagouv/agnostic-ai "$TEMP_DIR" 2>/dev/null; then
        TEMPLATES_DIR="$TEMP_DIR/templates/ides"
    else
        echo -e "${YELLOW}  ⚠️  Could not download templates, skipping migration${NC}"
        exit 0
    fi
fi

# Build new config object
new_config='{"ides":{}}'

for ide in "${old_ides[@]}"; do
    mcp_template="$TEMPLATES_DIR/$ide/mcp-config.jsonc"

    if [ -f "$mcp_template" ]; then
        # Read mcp-config template and embed it
        mcp_json=$(grep -v '^\s*//' "$mcp_template" | sed 's|//.*||g' | jq -c '.')
        new_config=$(echo "$new_config" | jq --arg ide "$ide" --argjson mcp "$mcp_json" '.ides[$ide] = {"mcp-config": $mcp}')
        echo -e "  ${GREEN}✓${NC} Loaded MCP config for $ide"
    else
        # No mcp-config template, just add IDE name
        new_config=$(echo "$new_config" | jq --arg ide "$ide" '.ides[$ide] = {}')
        echo -e "  ${YELLOW}⚠${NC} No MCP config found for $ide"
    fi
done

# Backup old config
cp "$CONFIG_LOCAL" "${CONFIG_LOCAL}.backup.$(date +%Y%m%d_%H%M%S)"

# Write new format with comments
cat > "$CONFIG_LOCAL" <<EOF
{
  // Local IDE configuration (gitignored)
  // Defines which IDEs are installed and configured with their MCP settings
EOF
echo "  \"ides\": $(echo "$new_config" | jq '.ides')" >> "$CONFIG_LOCAL"
echo "}" >> "$CONFIG_LOCAL"

echo -e "  ${GREEN}✅ Migration complete!${NC}"
echo "  Old config backed up to ${CONFIG_LOCAL}.backup.*"
echo ""
