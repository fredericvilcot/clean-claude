#!/usr/bin/env bash
set -euo pipefail

# Setup Spectre Reactive System in a project
# This script configures hooks and creates the .spectre directory

PROJECT_DIR="${1:-.}"
SPECTRE_AGENTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${BLUE}→${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1" >&2; exit 1; }

echo -e "${BOLD}Spectre Reactive System Setup${NC}"
echo "Setting up reactive multi-agent system in: $PROJECT_DIR"
echo ""

cd "$PROJECT_DIR"

# 1. Create .spectre directory
info "Creating .spectre directory..."
mkdir -p .spectre
cat > .spectre/state.json << 'EOF'
{
  "workflow": null,
  "feature": null,
  "phase": "idle",
  "retryCount": 0,
  "maxRetries": 3,
  "agents": {
    "lastActive": null,
    "history": []
  },
  "status": "ready"
}
EOF
touch .spectre/errors.jsonl
touch .spectre/events.jsonl
touch .spectre/learnings.jsonl
echo '{}' > .spectre/context.json
success "Created .spectre directory"

# 2. Create scripts directory
info "Setting up hook scripts..."
mkdir -p scripts/spectre
cp "$SPECTRE_AGENTS_DIR/scripts/spectre-router.sh" scripts/spectre/
cp "$SPECTRE_AGENTS_DIR/scripts/on-agent-stop.sh" scripts/spectre/
cp "$SPECTRE_AGENTS_DIR/scripts/check-test-results.sh" scripts/spectre/
chmod +x scripts/spectre/*.sh
success "Copied hook scripts to scripts/spectre/"

# 3. Configure hooks in settings
info "Configuring Claude Code hooks..."
mkdir -p .claude

if [[ -f .claude/settings.json ]]; then
    # Merge hooks into existing settings
    warn "Existing .claude/settings.json found, merging hooks..."

    # Check if jq is available
    if command -v jq &> /dev/null; then
        HOOKS_CONFIG=$(cat << 'EOF'
{
  "SubagentStop": [
    {
      "matcher": "qa-engineer|frontend-dev|software-craftsman|product-owner",
      "hooks": [
        {
          "type": "command",
          "command": "./scripts/spectre/on-agent-stop.sh"
        }
      ]
    }
  ],
  "PostToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "command",
          "command": "./scripts/spectre/check-test-results.sh"
        }
      ]
    }
  ]
}
EOF
)
        # Merge hooks
        jq --argjson hooks "$HOOKS_CONFIG" '.hooks = (.hooks // {}) + $hooks' .claude/settings.json > .claude/settings.json.tmp
        mv .claude/settings.json.tmp .claude/settings.json
        success "Merged hooks into existing settings"
    else
        warn "jq not found, please manually add hooks from templates/spectre/hooks.json"
    fi
else
    # Create new settings with hooks
    cat > .claude/settings.json << 'EOF'
{
  "hooks": {
    "SubagentStop": [
      {
        "matcher": "qa-engineer|frontend-dev|software-craftsman|product-owner",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/spectre/on-agent-stop.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/spectre/check-test-results.sh"
          }
        ]
      }
    ]
  }
}
EOF
    success "Created .claude/settings.json with hooks"
fi

# 4. Create docs directory for feature artifacts
info "Creating docs structure..."
mkdir -p docs/features
success "Created docs/features directory"

# 5. Add .spectre to .gitignore (optional files)
if [[ -f .gitignore ]]; then
    if ! grep -q ".spectre/state.json" .gitignore; then
        info "Adding .spectre runtime files to .gitignore..."
        cat >> .gitignore << 'EOF'

# Spectre Agents runtime state (can be regenerated)
.spectre/state.json
.spectre/events.jsonl
.spectre/context.json
.spectre/trigger
EOF
        success "Updated .gitignore"
    fi
fi

echo ""
echo -e "${GREEN}${BOLD}Setup complete!${NC}"
echo ""
echo "The Spectre Reactive System is now configured."
echo ""
echo "Directory structure:"
echo "  .spectre/           # Shared state between agents"
echo "  scripts/spectre/    # Hook scripts for reactive routing"
echo "  docs/features/      # Feature documentation output"
echo ""
echo "To start a reactive loop:"
echo "  /reactive-loop"
echo ""
echo "Or manually check status:"
echo "  ./scripts/spectre/spectre-router.sh status"
