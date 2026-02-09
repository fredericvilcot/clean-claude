#!/usr/bin/env bash
# Hook: PostToolUse on Write|Edit
# CRAFT lint for frontend stack: TypeScript + React + TanStack Query
# Detects anti-patterns on every write. Non-blocking — agents self-correct.
#
# Built-in rules for the mandatory stack (TS + React + TanStack Query).
# Optional: .clean-claude/craft-rules.json for project-specific custom rules.

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

[ -z "$FILE_PATH" ] && exit 0
[ ! -f "$FILE_PATH" ] && exit 0

# Only lint TypeScript/TSX
case "$FILE_PATH" in
  *.ts|*.tsx) ;;
  *) exit 0 ;;
esac

VIOLATIONS=""
BASENAME=$(basename "$FILE_PATH")
IS_TEST=false

case "$BASENAME" in
  *.test.ts|*.test.tsx|*.spec.ts|*.spec.tsx) IS_TEST=true ;;
esac

check() {
  local pattern="$1"
  local message="$2"
  local matches
  matches=$(grep -nE "$pattern" "$FILE_PATH" 2>/dev/null || true)
  [ -n "$matches" ] && VIOLATIONS="${VIOLATIONS}CRAFT: ${message}\n${matches}\n\n"
}

check_prod() {
  # Skip in test files
  $IS_TEST && return 0
  check "$@"
}

# ═══════════════════════════════════════════════════════════
# TYPESCRIPT — Strict typing, explicit errors, no escape hatches
# ═══════════════════════════════════════════════════════════

check '\b(: any\b|as any\b|<any>)' \
  'NO \`any\` — use strict types, generics, or \`unknown\` with type guards'

check '\bthrow[\s(]|\bthrow new\b' \
  'NO \`throw\` — use Result<T,E>. Errors are values, not exceptions'

check '@ts-ignore|@ts-expect-error' \
  'NO @ts-ignore / @ts-expect-error — fix the type error properly'

check '\bas unknown as\b' \
  'NO \`as unknown as\` — double cast is a type smell. Fix the types upstream'

check_prod 'eslint-disable' \
  'NO eslint-disable — fix the lint issue, do not suppress it'

# ═══════════════════════════════════════════════════════════
# REACT — Components are pure presenters, logic lives in hooks
# ═══════════════════════════════════════════════════════════

check 'dangerouslySetInnerHTML' \
  'NO dangerouslySetInnerHTML — XSS risk. Use safe rendering or a sanitizer'

check_prod 'document\.(getElementById|querySelector|getElementsBy)' \
  'NO direct DOM access — use useRef. React owns the DOM'

check_prod '\bconsole\.(log|warn|error)\(' \
  'NO console.log in production — remove debug traces or use structured logging'

# useEffect + fetch/axios = should be TanStack Query
if ! $IS_TEST && grep -qE '\buseEffect\b' "$FILE_PATH" 2>/dev/null; then
  FETCH_MATCHES=$(grep -nE '\bfetch\(|\baxios[\.(]' "$FILE_PATH" 2>/dev/null || true)
  [ -n "$FETCH_MATCHES" ] && \
    VIOLATIONS="${VIOLATIONS}CRAFT: NO fetch/axios inside useEffect — use useQuery/useMutation (TanStack Query)\n${FETCH_MATCHES}\n\n"
fi

# useEffect + setState from fetch = manual server state (TanStack Query does this)
if ! $IS_TEST && grep -qE '\buseEffect\b' "$FILE_PATH" 2>/dev/null; then
  SET_STATE_FETCH=$(grep -nE 'set[A-Z]\w*\(' "$FILE_PATH" 2>/dev/null || true)
  if [ -n "$SET_STATE_FETCH" ] && grep -qE '\bfetch\(|\baxios[\.(]' "$FILE_PATH" 2>/dev/null; then
    VIOLATIONS="${VIOLATIONS}CRAFT: useState+useEffect+fetch = manual server state. Use useQuery instead (caching, revalidation, error handling for free)\n\n"
  fi
fi

# ═══════════════════════════════════════════════════════════
# TANSTACK QUERY — Server state belongs here, not in useState
# ═══════════════════════════════════════════════════════════

# Detect useState for data that should be server state
# Pattern: useState<SomeType[]>([]) followed by useEffect with fetch
# (Simplified: useState with empty array init + useEffect in same file)
if ! $IS_TEST && grep -qE 'useState(<[^>]+>\()?\[\]' "$FILE_PATH" 2>/dev/null; then
  if grep -qE '\buseEffect\b' "$FILE_PATH" 2>/dev/null; then
    if grep -qE '\bfetch\(|\baxios[\.(]|\.get\(|\.post\(' "$FILE_PATH" 2>/dev/null; then
      VIOLATIONS="${VIOLATIONS}CRAFT: useState([]) + useEffect + fetch = anti-pattern. Replace with useQuery({ queryKey, queryFn })\n\n"
    fi
  fi
fi

# ═══════════════════════════════════════════════════════════
# ARCHITECTURE — Domain purity, no framework leaks
# ═══════════════════════════════════════════════════════════

# Domain files should not import React or framework code
case "$FILE_PATH" in
  */domain/*)
    check "from ['\"]react['\"]|from ['\"]@tanstack|from ['\"]axios|from ['\"]@reduxjs" \
      'DOMAIN VIOLATION — domain/ must be PURE. No React, TanStack, axios, or framework imports'
    ;;
esac

# ═══════════════════════════════════════════════════════════
# CUSTOM RULES — Optional project overlay (.clean-claude/craft-rules.json)
# ═══════════════════════════════════════════════════════════

CUSTOM_RULES="${CLAUDE_PROJECT_DIR:-.}/.clean-claude/craft-rules.json"
if [ -f "$CUSTOM_RULES" ]; then
  COUNT=$(jq -r '.custom // [] | length' "$CUSTOM_RULES" 2>/dev/null || echo "0")
  for i in $(seq 0 $((COUNT - 1))); do
    PATTERN=$(jq -r ".custom[$i].pattern // empty" "$CUSTOM_RULES" 2>/dev/null)
    MESSAGE=$(jq -r ".custom[$i].message // empty" "$CUSTOM_RULES" 2>/dev/null)
    [ -n "$PATTERN" ] && [ -n "$MESSAGE" ] && check "$PATTERN" "$MESSAGE"
  done
fi

# ═══════════════════════════════════════════════════════════
# OUTPUT
# ═══════════════════════════════════════════════════════════

if [ -n "$VIOLATIONS" ]; then
  ESCAPED=$(echo -e "$VIOLATIONS" | jq -Rs .)
  echo "{\"additionalContext\":$ESCAPED}"
fi

exit 0
