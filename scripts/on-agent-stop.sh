#!/usr/bin/env bash
set -euo pipefail

# Hook: SubagentStop
# Called when any Spectre agent completes

SPECTRE_DIR=".spectre"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read hook input from stdin (JSON with agent info)
INPUT=$(cat)

# Extract agent type from hook input
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // .subagent_type // "unknown"')

# List of Spectre agents
SPECTRE_AGENTS="qa-engineer|frontend-dev|backend-dev|software-craftsman|product-owner|orchestrator"

# Only process Spectre agents
if echo "$AGENT_TYPE" | grep -qE "^($SPECTRE_AGENTS)$"; then
    echo "$INPUT" | "$SCRIPT_DIR/spectre-router.sh" "agent-complete" "$AGENT_TYPE"
fi

exit 0
