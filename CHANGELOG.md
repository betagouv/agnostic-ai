# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2025-10-27

### Added

#### Migration System
- **Automatic Migrations**: New migration system for smooth version upgrades
  - Migration scripts in `templates/migrations/<version>.sh`
  - Runs automatically during `.ai/cli update`
  - Version-aware: only runs migrations newer than current version
  - Graceful error handling with warnings
- **v1.2.0 Migration**: Converts `config.local.jsonc` format
  - Migrates from array-based IDE list to nested object format
  - Embeds MCP configurations directly into `config.local.jsonc`
  - Creates backup of old config before migration
  - Automatically downloads templates if needed

### Changed

#### MCP Configuration Architecture
- **Unified Configuration**: MCP configs now embedded in `.ai/config.local.jsonc`
  - Old format: `{"ides": ["claude", "cursor"]}`
  - New format: `{"ides": {"claude": {"mcp-config": {...}}, "cursor": {...}}}`
  - Each IDE has its MCP config embedded directly
  - No more separate `ides/` folder for IDE-specific configs
- **Improved Maintainability**:
  - Single source of truth for IDE configuration
  - Easier to version control and share
  - Better IDE detection in CLI commands

### Fixed

- **Version Consistency**: Updated `templates/.ai/cli` to version 1.2.0
  - Previously showed 1.1.0 while migration was 1.2.0
  - Ensures version tracking is consistent across updates

## [1.1.0] - 2024-10-27

### Added

#### MCP (Model Context Protocol) Support
- **MCP Server Management**: New CLI commands to manage MCP servers
  - `.ai/cli mcp install` - Install MCP templates from repository
  - `.ai/cli mcp list` - List all available MCP servers with descriptions
  - `.ai/cli mcp use <server...>` - Enable one or multiple MCP servers
  - `.ai/cli mcp unuse <server...>` - Disable MCP servers
- **14 Pre-configured MCP Servers**: Ready-to-use servers including:
  - Airtable, Context7, Filesystem, GitHub, Gmail
  - Google Calendar, Google Drive, Make, Next.js DevTools
  - Notion, PostgreSQL, SQLite, Stripe, Trello
- **Environment Variable Management**:
  - `.env.local` file for storing API keys and credentials
  - `.env.example` template with all required variables
  - Automatic replacement of `.env.KEY` placeholders in configs
- **IDE-Specific Configuration**:
  - Per-IDE MCP config files in `templates/.ai/ides/<ide>/mcp-config.json`
  - Two strategies: `overwrite` (Cursor) and `merge-key` (Claude)
  - No code changes needed to add new IDE support
- **Local Configuration Tracking**:
  - `.ai/config.local.jsonc` (gitignored) tracks configured IDEs
  - Auto-created during `.ai/cli configure`
  - Used by MCP commands to write to correct IDE locations

#### Version Management
- **Version System**: Added version tracking to CLI
  - `VERSION="1.1.0"` constant in CLI script
  - `.ai/cli --version` command to display version info
  - Also works with `-v` and `version` commands
- **Automatic Update Checks**:
  - Checks GitHub once per day for new versions
  - Cached in `.ai/.version-check` (gitignored)
  - 2-second timeout, non-blocking
  - Only runs in production (skips in dev mode)
  - Shows notification when update available
- **CHANGELOG.md**: This file for tracking changes

#### Configuration & Infrastructure
- **Updated .gitignore**: Template now includes:
  - `.env.local` (environment variables)
  - `.tmp/` (temporary files)
  - `.ai/config.local.jsonc` (local IDE config)
  - `.ai/.version-check` (version check cache)
- **IDE Configuration Directory**: `templates/.ai/ides/<ide>/mcp-config.json`
  - Declarative MCP config per IDE
  - No hardcoded logic in CLI
  - Easy to extend for new IDEs

### Changed

- **IDE Configuration Flow**: Updated `.ai/cli configure` to:
  - Copy IDE-specific configs to `.ai/ides/`
  - Create `.ai/config.local.jsonc` with selected IDEs
  - Add config.local to .gitignore automatically
- **Help Text**: Updated to include MCP and version commands
- **Contribution Guide**: Enhanced `templates/ides/CONTRIBUTE.md` with:
  - Complete MCP configuration documentation
  - Strategy explanations (overwrite vs merge-key)
  - Step-by-step testing instructions
  - Updated checklist including MCP support

### Fixed

- **Init Scripts**: Cleaned up Cursor and Claude init.sh
  - Removed complex MCP sync logic
  - Simplified to focus on symlink setup only
  - MCP handling now in CLI, not init scripts

## [1.0.0] - 2024-10-22

### Added

- Initial release of agnostic-ai
- Unified `.ai/` configuration folder
- Plugin system for extensibility
- IDE support for Claude Code and Cursor
- Symlink-based dynamic configuration
- Documentation migration with `/core:migrate` command
- Context organization system
- Custom slash commands support
- Specialized agents support
- AI behavior profiles (avatars)

### Core Features

- **CLI Tool**: `.ai/cli` for managing configuration
  - `configure` - Set up IDE symlinks
  - `plugins list` - View available plugins
  - `plugins add` - Install plugins
  - `migrate` - Migrate documentation to .ai/context/
  - `update` - Update configuration and plugins
- **IDE Support**:
  - Claude Code with full configuration
  - Cursor with rules and commands
- **Plugin Architecture**:
  - Core plugin (always installed)
  - Modular plugin system
  - Easy to create custom plugins

[1.2.0]: https://github.com/betagouv/agnostic-ai/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/betagouv/agnostic-ai/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/betagouv/agnostic-ai/releases/tag/v1.0.0
