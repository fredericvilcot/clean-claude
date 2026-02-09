#!/usr/bin/env bash
# Hook: PreToolUse on Task
# STACK GUARD — Blocks ALL agent spawning if project is NOT React + TypeScript + TanStack Query.
# Clean Claude is built exclusively for this frontend stack.
# /craft handles bootstrapping if no project exists.

set -euo pipefail

PROJ_DIR="${CLAUDE_PROJECT_DIR:-.}"

# ═══════════════════════════════════════════════════════════
# Fast path: check context.json cache (written at /craft Step 1)
# ═══════════════════════════════════════════════════════════

CTX="$PROJ_DIR/.clean-claude/context.json"
if [ -f "$CTX" ]; then
  STACK_OK=$(jq -r '.project.stackGuard // "unchecked"' "$CTX" 2>/dev/null || echo "unchecked")
  if [ "$STACK_OK" = "pass" ]; then
    exit 0
  fi
  if [ "$STACK_OK" = "fail" ]; then
    echo '{"decision":"block","reason":"STACK GUARD: This project does NOT use React + TypeScript + TanStack Query. Clean Claude only supports this stack. Run /craft to bootstrap or fix your dependencies."}'
    exit 2
  fi
fi

# ═══════════════════════════════════════════════════════════
# No cache — scan package.json files
# ═══════════════════════════════════════════════════════════

HAS_REACT=false
HAS_TANSTACK=false
HAS_TS=false

check_pkg() {
  local pkg="$1"
  [ ! -f "$pkg" ] && return 0
  if jq -e '(.dependencies.react // .devDependencies.react // .peerDependencies.react) != null' "$pkg" >/dev/null 2>&1; then
    HAS_REACT=true
  fi
  if jq -e '(.dependencies["@tanstack/react-query"] // .devDependencies["@tanstack/react-query"] // .peerDependencies["@tanstack/react-query"]) != null' "$pkg" >/dev/null 2>&1; then
    HAS_TANSTACK=true
  fi
  if jq -e '(.dependencies.typescript // .devDependencies.typescript) != null' "$pkg" >/dev/null 2>&1; then
    HAS_TS=true
  fi
}

# Root package.json
check_pkg "$PROJ_DIR/package.json"

# Workspace package.json files (monorepo: apps/*, packages/*)
for dir in "$PROJ_DIR"/apps/*/package.json "$PROJ_DIR"/packages/*/package.json "$PROJ_DIR"/modules/*/package.json; do
  [ -f "$dir" ] && check_pkg "$dir"
done

# TypeScript also detected via tsconfig.json
if ! $HAS_TS; then
  for tsconfig in "$PROJ_DIR"/tsconfig*.json "$PROJ_DIR"/apps/*/tsconfig*.json "$PROJ_DIR"/packages/*/tsconfig*.json; do
    if [ -f "$tsconfig" ]; then
      HAS_TS=true
      break
    fi
  done
fi

# ═══════════════════════════════════════════════════════════
# Verdict
# ═══════════════════════════════════════════════════════════

if $HAS_REACT && $HAS_TANSTACK && $HAS_TS; then
  exit 0
fi

# Build missing list
MISSING=""
$HAS_TS || MISSING="${MISSING}TypeScript, "
$HAS_REACT || MISSING="${MISSING}React, "
$HAS_TANSTACK || MISSING="${MISSING}@tanstack/react-query, "
MISSING="${MISSING%, }"

echo "{\"decision\":\"block\",\"reason\":\"STACK GUARD: Missing ${MISSING}. Clean Claude only supports TypeScript + React + TanStack Query. Run /craft to bootstrap or fix your dependencies.\"}"
exit 2
