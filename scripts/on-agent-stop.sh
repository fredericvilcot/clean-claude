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

# Only process Spectre agents
case "$AGENT_TYPE" in
    "qa-engineer"|"frontend-dev"|"software-craftsman"|"product-owner")
        echo "$INPUT" | "$SCRIPT_DIR/spectre-router.sh" "agent-complete" "$AGENT_TYPE"
        ;;
    *)
        # Not a Spectre agent, ignore
        exit 0
        ;;
esac
