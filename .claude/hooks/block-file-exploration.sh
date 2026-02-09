#!/usr/bin/env bash
# Hook: PreToolUse on Bash
# Blocks file exploration commands — forces agents to use Read/Glob/Grep instead.
# Exit 0 = allow, Exit 2 = block (with reason on stdout as JSON)

set -euo pipefail

# Read tool input from stdin
INPUT=$(cat)

# Extract the command from tool_input.command
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Get the first word of the command (strip leading whitespace)
FIRST_WORD=$(echo "$COMMAND" | sed 's/^[[:space:]]*//' | awk '{print $1}')

# Strip any path prefix to get the base command name
BASE_CMD=$(basename "$FIRST_WORD")

# Blocked commands: file exploration tools that agents should not use
case "$BASE_CMD" in
  find|grep|rg|cat|head|tail|tree|wc|awk|sed)
    echo '{"decision":"block","reason":"CRAFT RULE: Use Read/Glob/Grep tools for file exploration — Bash('"$BASE_CMD"') is blocked by hook."}'
    exit 2
    ;;
  ls)
    # Allow bare "ls" (no arguments) but block "ls <path>" exploration
    # Strip the command name and check for remaining args
    ARGS=$(echo "$COMMAND" | sed 's/^[[:space:]]*[^ ]*//' | sed 's/^[[:space:]]*//')
    if [ -n "$ARGS" ]; then
      echo '{"decision":"block","reason":"CRAFT RULE: Use Glob tool for directory listing — Bash(ls <path>) is blocked by hook."}'
      exit 2
    fi
    # Bare "ls" is OK
    exit 0
    ;;
esac

# Allowed commands pass through (npm, npx, node, pnpm, yarn, git, docker, chmod, mkdir, cp, mv, etc.)
exit 0
