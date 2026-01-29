---
name: heal
description: "Auto-repair: detects what's broken and fixes it automatically. Just run /heal and let the agents work."
context: conversation
allowed-tools: Read, Bash, Task, AskUserQuestion, Skill
---

# Spectre Heal — Auto-Repair Mode

Detects what's broken and fixes it automatically. No questions, just healing.

## Usage

```bash
/heal           # Detect and fix whatever is broken
/heal tests     # Fix failing tests specifically
/heal build     # Fix build errors specifically
/heal lint      # Fix lint errors specifically
```

## How It Works

### Step 1: Diagnose

Run diagnostics to detect what's broken:

```bash
# Check for test failures
npm test 2>&1 || pnpm test 2>&1 || yarn test 2>&1

# Check for build errors
npm run build 2>&1 || pnpm build 2>&1

# Check for lint errors
npm run lint 2>&1 || pnpm lint 2>&1

# Check for TypeScript errors
npx tsc --noEmit 2>&1
```

### Step 2: Identify Problem Type

| Detection | Problem Type | Agent |
|-----------|--------------|-------|
| `FAIL`, `expect`, `assertion` | Test failure | `frontend-dev` or `backend-dev` |
| `error TS`, `Cannot find`, `not assignable` | Type error | `software-craftsman` |
| `Build failed`, `Module not found` | Build error | `software-craftsman` |
| `eslint`, `prettier`, `Parsing error` | Lint error | Last active dev |
| `ENOENT`, `Cannot resolve` | Missing dependency | `software-craftsman` |

### Step 3: Gather Context

Collect information for the fixing agent:

```markdown
## Error Context

**Type:** Test failure
**Files involved:** src/components/Login.test.tsx
**Error message:**
```
FAIL src/components/Login.test.tsx
  ✕ should submit form with valid credentials (15 ms)
    Expected: "Welcome"
    Received: undefined
```

**Recent changes:** (from git diff)
**Related learnings:** (from .spectre/learnings.jsonl)
```

### Step 4: Launch Repair Agent

Spawn the appropriate agent with full context:

```
Use the <agent> agent to fix this error:

<error context>

Instructions:
1. Analyze the error
2. Identify the root cause
3. Implement the fix
4. The QA agent will verify automatically
```

### Step 5: Verify Fix

After the dev agent completes, spawn QA to verify:

```
Use the qa-engineer agent to verify the fix:

1. Run the failing test(s) again
2. If still failing → report back for another fix attempt
3. If passing → confirm the fix is complete
```

### Step 6: Loop Until Healed

```
┌─────────────┐         ┌─────────────┐
│   Diagnose  │         │     Dev     │
│   Problem   │ ──────▶ │    Fixes    │
└─────────────┘         └──────┬──────┘
                               │
                               ▼
                        ┌─────────────┐
                        │     QA      │
                        │   Verifies  │
                        └──────┬──────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
                   PASS                  FAIL
                    │                     │
                    ▼                     ▼
              ┌──────────┐         ┌──────────┐
              │  Done!   │         │  Retry   │
              │  Healed  │         │ (max 3)  │
              └──────────┘         └──────────┘
```

---

## Implementation

When `/heal` is invoked:

### 1. Run Diagnostics

```bash
# Initialize results
PROBLEMS=()

# Check tests
if ! npm test --passWithNoTests 2>/dev/null; then
  PROBLEMS+=("tests")
fi

# Check build
if ! npm run build 2>/dev/null; then
  PROBLEMS+=("build")
fi

# Check TypeScript
if ! npx tsc --noEmit 2>/dev/null; then
  PROBLEMS+=("types")
fi

# Check lint
if ! npm run lint 2>/dev/null; then
  PROBLEMS+=("lint")
fi
```

### 2. Report Findings

If no problems found:
```
✓ All systems healthy!

- Tests: passing
- Build: successful
- Types: no errors
- Lint: clean

Nothing to heal.
```

If problems found:
```
Found issues to heal:

1. ❌ Tests failing (3 failures)
2. ❌ TypeScript errors (2 errors)

Starting auto-repair...
```

### 3. Fix in Priority Order

1. **Type errors first** (they often cause other failures)
2. **Build errors** (can't test if can't build)
3. **Test failures** (core functionality)
4. **Lint errors** (code quality)

### 4. Update State

```json
// .spectre/state.json
{
  "workflow": "heal",
  "phase": "fixing",
  "problems": ["tests", "types"],
  "currentProblem": "types",
  "retryCount": 0,
  "maxRetries": 3
}
```

---

## Specific Heal Commands

### `/heal tests`

Focus only on test failures:

```bash
/heal tests
```

1. Run tests and capture output
2. Parse failing test names and files
3. Spawn dev agent with test context
4. Re-run tests to verify

### `/heal build`

Focus only on build errors:

```bash
/heal build
```

1. Run build and capture errors
2. Identify missing modules, syntax errors
3. Spawn architect for structural issues or dev for code issues
4. Re-run build to verify

### `/heal lint`

Focus only on lint errors:

```bash
/heal lint
```

1. Run linter and capture issues
2. For auto-fixable: run `npm run lint -- --fix`
3. For manual fixes: spawn dev agent
4. Re-run lint to verify

### `/heal types`

Focus only on TypeScript errors:

```bash
/heal types
```

1. Run `tsc --noEmit` and capture errors
2. Spawn architect for complex type issues
3. Spawn dev for simple fixes
4. Re-run type check to verify

---

## Smart Detection

If the user provides context, use it:

| Input | Action |
|-------|--------|
| `/heal` | Full diagnostic, fix all |
| `/heal tests` | Fix tests only |
| `/heal Login.test.tsx` | Fix specific test file |
| `/heal "Cannot find module"` | Fix that specific error |

---

## Output Examples

### Successful Heal

```
🔍 Diagnosing...

Found 2 issues:
  ❌ Tests: 3 failing
  ❌ Types: 1 error

🔧 Healing types first...

software-craftsman is analyzing...
  → Fixed: Added missing type for UserResponse

🔧 Healing tests...

frontend-dev is fixing...
  → Fixed: Updated selector in Login.test.tsx

🧪 Verifying...

qa-engineer is checking...
  ✓ All tests passing
  ✓ Types clean
  ✓ Build successful

✅ Healed! All systems healthy.
```

### Partial Heal (Max Retries)

```
🔍 Diagnosing...

Found 1 issue:
  ❌ Tests: 1 failing

🔧 Healing tests...

Attempt 1/3: frontend-dev fixing...
  → Applied fix

🧪 Verifying... ❌ Still failing

Attempt 2/3: frontend-dev fixing...
  → Applied different approach

🧪 Verifying... ❌ Still failing

Attempt 3/3: frontend-dev fixing...
  → Tried alternative solution

🧪 Verifying... ❌ Still failing

⚠️ Could not auto-heal after 3 attempts.

Remaining issue:
  - Login.test.tsx: "should handle network error"

Suggestions:
  1. Check the test expectations
  2. Review the error handling logic
  3. Run `/guide fix tests` for guided debugging
```

---

## Integration with .spectre/

### Read Learnings

Before fixing, check if we've seen this error before:

```bash
# Search learnings for similar errors
grep -i "login" .spectre/learnings.jsonl
```

If found, apply the known solution first.

### Write Learnings

After successful fix, record the pattern:

```jsonl
{"timestamp":"...","error_type":"test_failure","pattern":"selector not found","file":"*.test.tsx","solution":"Use data-testid instead of class selector","agent":"frontend-dev"}
```

---

## Tone

- **Confident:** "Found 2 issues. Fixing..."
- **Clear:** Show what's happening at each step
- **Helpful:** If can't fix, suggest next steps
- **Fast:** Minimize chatter, maximize action
