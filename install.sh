#!/usr/bin/env bash
set -euo pipefail

# Clean Claude Installer
# Installs craft-oriented agents and skills for Claude Code

REPO_URL="https://github.com/fredericvilcot/clean-claude"
CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="${BASH_SOURCE[0]:-}"
if [[ -n "$SCRIPT_DIR" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_DIR")" && pwd)"
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

# Counters
AGENTS_COUNT=0
SKILLS_COUNT=0

# ─────────────────────────────────────────────────────────────
# Display functions
# ─────────────────────────────────────────────────────────────

banner() {
    echo ""
    echo -e "${PURPLE}"
    echo '    ██████╗██╗     ███████╗ █████╗ ███╗   ██╗'
    echo '   ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║'
    echo '   ██║     ██║     █████╗  ███████║██╔██╗ ██║'
    echo '   ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║'
    echo '   ╚██████╗███████╗███████╗██║  ██║██║ ╚████║'
    echo '    ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝'
    echo ''
    echo '    ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗'
    echo '   ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝'
    echo '   ██║     ██║     ███████║██║   ██║██║  ██║█████╗  '
    echo '   ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝  '
    echo '   ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗'
    echo '    ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝'
    echo -e "${NC}"
    echo -e "${DIM}   Stop prompting. Start crafting.${NC}"
    echo ""
}

step() {
    echo -e "${PURPLE}▸${NC} $1"
}

done_step() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1" >&2
    exit 1
}

spinner() {
    local pid=$1
    local msg=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${CYAN}%s${NC} %s" "${spin:i++%10:1}" "$msg"
        sleep 0.1
    done
    printf "\r"
}

# ─────────────────────────────────────────────────────────────
# Install logic (unchanged)
# ─────────────────────────────────────────────────────────────

is_local_install() {
    [[ -n "$SCRIPT_DIR" ]] && [[ -d "$SCRIPT_DIR/.claude/agents" ]] && [[ -d "$SCRIPT_DIR/.claude/skills" ]]
}

setup_directories() {
    mkdir -p "$CLAUDE_DIR/agents"
    mkdir -p "$CLAUDE_DIR/skills"
}

install_local() {
    for agent in "$SCRIPT_DIR/.claude/agents"/*.md; do
        [[ -f "$agent" ]] || continue
        cp "$agent" "$CLAUDE_DIR/agents/"
        ((AGENTS_COUNT++))
    done

    for skill_dir in "$SCRIPT_DIR/.claude/skills"/*; do
        [[ -d "$skill_dir" ]] || continue
        skill_name=$(basename "$skill_dir")
        rm -rf "$CLAUDE_DIR/skills/$skill_name"
        cp -r "$skill_dir" "$CLAUDE_DIR/skills/$skill_name"
        ((SKILLS_COUNT++))
    done
}

install_remote() {
    tmp_dir=$(mktemp -d)
    trap "rm -rf $tmp_dir" EXIT

    git clone --depth 1 --quiet "$REPO_URL" "$tmp_dir" || error "Failed to clone repository"

    for agent in "$tmp_dir/.claude/agents"/*.md; do
        [[ -f "$agent" ]] || continue
        cp "$agent" "$CLAUDE_DIR/agents/"
        ((AGENTS_COUNT++))
    done

    for skill_dir in "$tmp_dir/.claude/skills"/*; do
        [[ -d "$skill_dir" ]] || continue
        skill_name=$(basename "$skill_dir")
        rm -rf "$CLAUDE_DIR/skills/$skill_name"
        cp -r "$skill_dir" "$CLAUDE_DIR/skills/$skill_name"
        ((SKILLS_COUNT++))
    done
}

# ─────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────

main() {
    clear 2>/dev/null || true
    banner

    # Setup
    step "Preparing installation..."
    setup_directories
    done_step "Directories ready"

    # Install
    step "Downloading Software Craft agents..."
    if is_local_install; then
        install_local
    else
        install_remote
    fi
    done_step "Installed ${BOLD}${AGENTS_COUNT}${NC} agents + ${BOLD}${SKILLS_COUNT}${NC} skills"

    # Optional: MCP setup for visual context
    echo ""
    echo -e "${PURPLE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│${NC}                                                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}   ${WHITE}Optional: Visual Context${NC}                              ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}   ${DIM}Enable Browser + Figma for smarter specs${NC}               ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}                                                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}   ${DIM}Playwright MCP: browse live apps, handle auth${NC}          ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}   ${DIM}Figma MCP: read designs, extract components${NC}            ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}                                                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    read -p "  Enable visual context? (Playwright + Figma MCP) [y/N] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "  Which browser for Playwright?"
        echo "  1) Chrome (default)"
        echo "  2) Firefox"
        echo "  3) Edge"
        read -p "  Choice [1]: " browser_choice
        case "${browser_choice:-1}" in
            2) BROWSER="firefox" ;;
            3) BROWSER="msedge" ;;
            *) BROWSER="chrome" ;;
        esac
        echo ""
        claude mcp add playwright -- npx @playwright/mcp@latest --browser "$BROWSER" 2>/dev/null && done_step "Playwright MCP added ($BROWSER)"
        claude mcp add --transport http figma https://mcp.figma.com/mcp 2>/dev/null && done_step "Figma MCP added"
        echo ""
    fi

    # Success
    echo ""
    echo -e "${PURPLE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│${NC}                                                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}   ${WHITE}${BOLD}Installation complete!${NC}                              ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}                                                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}   ${DIM}Restart Claude Code, then type:${NC}                    ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}                                                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}   ${WHITE}/craft${NC}  ${DIM}→${NC} Build with your AI dev team              ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}   ${WHITE}/heal${NC}   ${DIM}→${NC} Auto-fix issues with smart routing       ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}   ${WHITE}/learn${NC}  ${DIM}→${NC} Adapt to your codebase patterns          ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}                                                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "   ${DIM}▪${NC} ${WHITE}Auto-healing${NC}${DIM} — Agents fix bugs autonomously${NC}"
    echo -e "   ${DIM}▪${NC} ${WHITE}Auto-learning${NC}${DIM} — Adapts to YOUR codebase patterns${NC}"
    echo -e "   ${DIM}▪${NC} ${WHITE}Fully reactive${NC}${DIM} — Errors route to the right expert${NC}"
    echo ""
    echo -e "${PURPLE}   Kent Beck • Uncle Bob • Martin Fowler • Eric Evans${NC}"
    echo -e "${DIM}   The craft masters are now in your terminal.${NC}"
    echo ""
}

main "$@"
