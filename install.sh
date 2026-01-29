#!/usr/bin/env bash
set -euo pipefail

# Spectre Agents Installer
# Installs craft-oriented agents and skills for Claude Code

REPO_URL="https://github.com/fredericvilcot/spectre-agents"
CLAUDE_DIR="$HOME/.claude"
# Handle curl|bash case where BASH_SOURCE is empty
SCRIPT_DIR="${BASH_SOURCE[0]:-}"
if [[ -n "$SCRIPT_DIR" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_DIR")" && pwd)"
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${BLUE}→${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1" >&2; exit 1; }

# Check if running from cloned repo or via curl
is_local_install() {
    [[ -n "$SCRIPT_DIR" ]] && [[ -d "$SCRIPT_DIR/.claude/agents" ]] && [[ -d "$SCRIPT_DIR/.claude/skills" ]]
}

# Create directories
setup_directories() {
    info "Creating Claude Code directories..."
    mkdir -p "$CLAUDE_DIR/agents"
    mkdir -p "$CLAUDE_DIR/skills"
}

# Install from local clone
install_local() {
    info "Installing from local repository..."

    # Copy agents
    for agent in "$SCRIPT_DIR/.claude/agents"/*.md; do
        [[ -f "$agent" ]] || continue
        cp "$agent" "$CLAUDE_DIR/agents/"
        success "Installed agent: $(basename "$agent" .md)"
    done

    # Copy skills (entire directories)
    for skill_dir in "$SCRIPT_DIR/.claude/skills"/*; do
        [[ -d "$skill_dir" ]] || continue
        skill_name=$(basename "$skill_dir")
        rm -rf "$CLAUDE_DIR/skills/$skill_name"
        cp -r "$skill_dir" "$CLAUDE_DIR/skills/$skill_name"
        success "Installed skill: $skill_name"
    done
}

# Install from remote (curl install)
install_remote() {
    info "Cloning Spectre Agents..."

    tmp_dir=$(mktemp -d)
    trap "rm -rf $tmp_dir" EXIT

    git clone --depth 1 --quiet "$REPO_URL" "$tmp_dir" || error "Failed to clone repository"

    # Copy agents
    for agent in "$tmp_dir/.claude/agents"/*.md; do
        [[ -f "$agent" ]] || continue
        cp "$agent" "$CLAUDE_DIR/agents/"
        success "Installed agent: $(basename "$agent" .md)"
    done

    # Copy skills
    for skill_dir in "$tmp_dir/.claude/skills"/*; do
        [[ -d "$skill_dir" ]] || continue
        skill_name=$(basename "$skill_dir")
        rm -rf "$CLAUDE_DIR/skills/$skill_name"
        cp -r "$skill_dir" "$CLAUDE_DIR/skills/$skill_name"
        success "Installed skill: $skill_name"
    done
}

main() {
    echo -e "${BOLD}Spectre Agents Installer${NC}"
    echo "Craft-oriented agents and skills for Claude Code"
    echo ""

    setup_directories

    if is_local_install; then
        install_local
    else
        install_remote
    fi

    echo ""
    success "Installation complete!"
    echo ""
    echo "Restart Claude Code to load the new components."
    echo "See https://github.com/fredericvilcot/spectre-agents for documentation."
}

main "$@"
