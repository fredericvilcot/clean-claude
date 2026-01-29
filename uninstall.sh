#!/usr/bin/env bash
set -euo pipefail

# Spectre Agents Uninstaller

CLAUDE_DIR="$HOME/.claude"

GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

success() { echo -e "${GREEN}✓${NC} $1"; }

echo -e "${BOLD}Spectre Agents Uninstaller${NC}"
echo ""

# Spectre agents list
AGENTS=(
    "architect"
    "product-owner"
    "frontend-engineer"
    "qa-engineer"
    "orchestrator"
)

# Spectre skills list
SKILLS=(
    "typescript-craft"
    "react-craft"
    "test-craft"
    "init-frontend"
    "feature"
    "reactive-loop"
    "setup-reactive"
)

# Remove agents
for agent in "${AGENTS[@]}"; do
    if [[ -f "$CLAUDE_DIR/agents/$agent.md" ]]; then
        rm "$CLAUDE_DIR/agents/$agent.md"
        success "Removed agent: $agent"
    fi
done

# Remove skills
for skill in "${SKILLS[@]}"; do
    if [[ -d "$CLAUDE_DIR/skills/$skill" ]]; then
        rm -rf "$CLAUDE_DIR/skills/$skill"
        success "Removed skill: $skill"
    fi
done

echo ""
success "Uninstallation complete!"
echo "Restart Claude Code to apply changes."
