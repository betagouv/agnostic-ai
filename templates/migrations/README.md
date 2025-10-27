# Migrations

This folder contains migration scripts that run when users update their agnostic-ai installation.

## How It Works

When a user runs `.ai/cli update`, the CLI will:

1. Check the current installed version
2. Download the latest version
3. Run migration scripts for versions between the old and new version
4. Update the installation

## Migration Script Naming

Migration scripts should be named `<version>.sh`, where `<version>` matches the version number in `.ai/cli`.

Examples:
- `1.1.0.sh` - Runs when upgrading to v1.1.0
- `1.2.0.sh` - Runs when upgrading to v1.2.0
- `2.0.0.sh` - Runs when upgrading to v2.0.0

## Writing Migration Scripts

Each migration script should:

1. **Be idempotent** - Can be run multiple times safely
2. **Check prerequisites** - Verify required tools (jq, etc.) are available
3. **Backup data** - Create backups before making changes
4. **Handle errors gracefully** - Don't break if migration can't complete
5. **Provide clear output** - Show what's being migrated
6. **Exit 0** - Always exit successfully (even if skipped)

### Template

```bash
#!/bin/bash
# Migration for vX.Y.Z: Description of what this migration does

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Running migration: vX.Y.Z${NC}"
echo "  Description of changes"
echo ""

# Paths
AI_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/.ai"
PROJECT_ROOT="$(dirname "$AI_ROOT")"

# Check if migration is needed
if [ ! -f "$AI_ROOT/some-file" ]; then
    echo "  Nothing to migrate, skipping"
    exit 0
fi

# Perform migration
echo "  Migrating..."

# Backup if needed
cp "$AI_ROOT/some-file" "$AI_ROOT/some-file.backup.$(date +%Y%m%d_%H%M%S)"

# Make changes
# ...

echo -e "  ${GREEN}✅ Migration complete!${NC}"
echo ""
```

## Migration Order

Migrations are run in version order using `sort -V`:

```bash
1.0.0.sh
1.1.0.sh
1.2.0.sh
2.0.0.sh
```

## Testing Migrations

Before committing a migration:

1. Test on a fresh installation
2. Test on an existing installation with old format
3. Test running migration twice (idempotency)
4. Test when prerequisites are missing

## Example: v1.1.0 Migration

The `1.1.0.sh` migration converts `config.local.jsonc` from array format to nested object format:

**Before:**
```jsonc
{
  "ides": ["claude", "cursor"]
}
```

**After:**
```jsonc
{
  "ides": {
    "claude": {
      "mcp-config": { "location": "~/.claude.json", ... }
    },
    "cursor": {
      "mcp-config": { "location": "~/.cursor/mcp.json", ... }
    }
  }
}
```

This migration:
- Checks if config is in old format
- Downloads templates if needed
- Reads MCP config templates for each IDE
- Embeds MCP config into config.local.jsonc
- Creates a backup before modifying
