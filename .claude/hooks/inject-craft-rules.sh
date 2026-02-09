#!/usr/bin/env bash
# Hook: SubagentStart on CRAFT agents
# Injects frontend CRAFT rules into every agent's context.
# Stack: TypeScript + React + TanStack Query

set -euo pipefail

# Base CRAFT principles for the frontend stack
RULES="CRAFT RULES (enforced by hooks — violations are caught automatically):
- Bash(find/ls/grep/cat/tree) is BLOCKED by PreToolUse hook — use Read/Glob/Grep
- TypeScript: NO \`any\`, NO \`throw\`, NO \`@ts-ignore\`, NO \`as unknown as\` — flagged on every Write/Edit
- React: components are PURE presenters — business logic belongs in custom hooks, not in components
- React: NO useEffect+fetch — ALL server state via useQuery/useMutation (TanStack Query)
- React: NO direct DOM (document.querySelector) — use useRef
- Domain layer: PURE — zero framework imports (no React, no TanStack, no axios in domain/)
- Every implementation file needs a colocated test (*.test.ts / *.test.tsx)
- Errors are values: Result<T,E> everywhere — never throw for expected cases"

# Merge custom principles from project config if available
CUSTOM_RULES="${CLAUDE_PROJECT_DIR:-.}/.clean-claude/craft-rules.json"
if [ -f "$CUSTOM_RULES" ]; then
  EXTRA=$(jq -r '.principles // [] | .[]' "$CUSTOM_RULES" 2>/dev/null || true)
  if [ -n "$EXTRA" ]; then
    RULES="${RULES}
${EXTRA}"
  fi
fi

ESCAPED=$(echo "$RULES" | jq -Rs .)
echo "{\"additionalContext\":$ESCAPED}"
