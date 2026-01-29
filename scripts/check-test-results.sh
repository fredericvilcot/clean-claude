#!/usr/bin/env bash
set -euo pipefail

# Hook: PostToolUse (Bash)
# Checks if a test command was run and captures results

SPECTRE_DIR=".spectre"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read hook input from stdin
INPUT=$(cat)

# Extract the command that was run
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
OUTPUT=$(echo "$INPUT" | jq -r '.tool_output.stdout // empty')
EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_output.exit_code // 0')

# Check if this was a test command
if echo "$COMMAND" | grep -qiE "(vitest|jest|npm test|npm run test|pnpm test|yarn test|playwright|cypress)"; then
    # This was a test command, analyze results
    echo "$OUTPUT" | "$SCRIPT_DIR/spectre-router.sh" "test-result"

    # Log the test run
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "{\"timestamp\":\"$TIMESTAMP\",\"command\":\"$COMMAND\",\"exitCode\":$EXIT_CODE}" >> "$SPECTRE_DIR/test-runs.jsonl"
fi

exit 0
