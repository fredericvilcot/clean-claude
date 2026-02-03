---
name: heal
description: "Auto-repair with smart routing: test failures → Dev, type errors → Architect, spec gaps → PO. Routes each problem to the right expert."
context: conversation
allowed-tools: Read, Bash, Task, AskUserQuestion, Skill
---

# Clean Claude Heal — Re-enter the Reactive Loop

> **CLEAN CLAUDE CODE OF CONDUCT APPLIES** — See CLAUDE.md
> - No non-CRAFT code, no anti-CRAFT requests, no inappropriate behavior
> - All fixes MUST follow Software Craft principles
> - Vulgar/insulting requests are REFUSED

**The fixing continues until everything is CRAFTED.**

Use `/heal` to:
- **Continue fixing** after `/craft` hit max retries
- **Re-run agents** when something breaks later
- **Fix specific issues** (tests, types, build, spec)

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   /craft                                                         │
│       │                                                          │
│       ▼                                                          │
│   PO → Architect → Dev ⇄ QA                                     │
│                     │                                            │
│              ┌──────┴──────┐                                    │
│              │             │                                    │
│           ALL GREEN    FAILURES                                  │
│              │             │                                    │
│              ▼             ▼                                    │
│            DONE!     Auto-fix loop                              │
│                           │                                      │
│                    ┌──────┴──────┐                              │
│                    │             │                              │
│                 FIXED      MAX RETRIES                          │
│                    │             │                              │
│                    ▼             ▼                              │
│                  DONE!     ⚠️ User notified                     │
│                                  │                              │
│                                  ▼                              │
│                            /heal  ← RE-ENTER HERE               │
│                                  │                              │
│                                  ▼                              │
│                         Continue fixing                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Pre-flight: Auto-Detect Stack

Before diagnosing, ensure stack context exists:

```bash
# If .clean-claude/context.json doesn't exist, detect stack first
if [ ! -f ".clean-claude/context.json" ]; then
  # Same detection logic as /craft
  # Detect language, runtime, framework
  # Store in .clean-claude/context.json
fi
```

This ensures agents know the stack when fixing issues.

---

## Usage

```bash
/heal           # Detect and fix whatever is broken
/heal tests     # Fix failing tests
/heal build     # Fix build errors
/heal types     # Fix TypeScript errors
/heal lint      # Fix lint errors
/heal spec      # Fix spec/implementation mismatch
```

> **`/heal` ≠ `npm test`**
>
> `/heal` relaunches the **agent loop**. It diagnoses, routes to the right agent (Dev, Architect, PO), the agent fixes automatically, QA verifies, and loops until all green.

### Mode Awareness

`/heal` adapts to the current mode:

| Mode | PO Involved | Routing |
|------|-------------|---------|
| **Full flow** (new feature) | ✅ Yes | test_failure → Dev, type_error → Architect, spec_gap → PO |
| **Craft the existing** (refacto) | ❌ No | test_failure → Dev, type_error → Architect, NO PO routing |

```bash
# Check current mode in .clean-claude/state.json
if mode == "craft-the-existing":
    # Never route to PO — this is pure technical refactoring
    # Regressions go to Dev, design issues to Architect
else:
    # Full routing including PO for spec issues
```

## What Can Be Healed

### 🔧 Code Issues
- Test failures
- Build errors
- TypeScript errors
- Lint errors

### 📋 Spec Issues
- Spec doesn't match implementation
- Missing acceptance criteria
- Incomplete user stories
- Contradictions in requirements

## How It Works

### Step 1: Diagnose

**For Code:**
```bash
# Check tests, build, types, lint
npm test && npm run build && npx tsc --noEmit && npm run lint
```

**For Specs:**
```bash
# Find spec files
find . -name "*.spec.md" -o -name "*.story.md" -o -name "PRD*.md"

# Check .clean-claude/ for context
cat .clean-claude/context.json
```

### Step 2: Identify Problem Type & Route

| Detection | Problem Type | Primary Agent | Fallback |
|-----------|--------------|---------------|----------|
| `FAIL`, `expect`, `assertion` | Test failure | Dev (owner) | stack dev |
| `error TS`, `not assignable` | Type error | `architect` | — |
| `Build failed`, `Module not found` | Build error | `architect` | dev |
| `eslint`, `prettier` | Lint error | Last active dev | — |
| Spec vs code mismatch | Spec drift | `product-owner` | — |
| Missing acceptance criteria | Incomplete spec | `product-owner` | — |
| Implementation gaps | Missing features | `architect` → dev | — |
| `circular`, `race condition` | Design flaw | `architect` | — |
| `ambiguous`, `not specified` | Unclear criteria | `product-owner` | — |
| `contradiction`, `impossible` | Spec contradiction | `product-owner` | — |
| `cannot implement`, `blocked` | Design block | `architect` | — |
| `edge case`, `not covered` | Spec gap | `product-owner` | — |

### Smart Routing Logic

```
┌─────────────────────────────────────────────────────────────────────┐
│                         HEAL ROUTING                                 │
│                                                                      │
│  Error detected                                                      │
│       │                                                              │
│       ▼                                                              │
│  ┌─────────────┐                                                     │
│  │ Parse error │                                                     │
│  │   message   │                                                     │
│  └──────┬──────┘                                                     │
│         │                                                            │
│         ▼                                                            │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                    ROUTE BY TYPE                              │   │
│  │                                                               │   │
│  │  test_failure ────────────────────────────────▶ Dev (owner)   │   │
│  │  type_error ──────────────────────────────────▶ Architect     │   │
│  │  design_flaw ─────────────────────────────────▶ Architect     │   │
│  │  build_error ─────────────────────────────────▶ Architect/Dev │   │
│  │  lint_error ──────────────────────────────────▶ Dev           │   │
│  │  spec_drift ──────────────────────────────────▶ PO            │   │
│  │  unclear_criteria ────────────────────────────▶ PO            │   │
│  │  contradiction ───────────────────────────────▶ PO            │   │
│  │  design_block ────────────────────────────────▶ Architect     │   │
│  │  spec_gap ────────────────────────────────────▶ PO            │   │
│  │                                                               │   │
│  └──────────────────────────────────────────────────────────────┘   │
│         │                                                            │
│         ▼                                                            │
│  Agent fixes → QA verifies → Loop if needed                          │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

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
**Related learnings:** (from .clean-claude/learnings.jsonl)
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

### Step 6: Loop Until Healed (AUTONOMOUS)

**SAME AS /craft: FIX AUTOMATICALLY, DO NOT ASK USER.**

```
┌─────────────┐         ┌─────────────┐
│   Diagnose  │         │     Dev     │
│   Problem   │ ──────▶ │    Fixes    │ ← AUTOMATIC
└─────────────┘         └──────┬──────┘
                               │
                               ▼
                        ┌─────────────┐
                        │     QA      │
                        │   Verifies  │ ← AUTOMATIC
                        └──────┬──────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
                   PASS                  FAIL
                    │                     │
                    ▼                     ▼
              ┌──────────┐         ┌──────────┐
              │  Done!   │         │  Retry   │
              │  Healed  │         │ (max 3)  │ ← AUTOMATIC
              └──────────┘         └──────────┘
```

### Key Behavior: Continue Where /craft Left Off

1. **READ EXISTING CONTEXT**: Check `.clean-claude/failures.md` from previous `/craft` run
2. **CONTINUE WHERE LEFT OFF**: Don't restart from scratch, use existing spec and design
3. **AUTONOMOUS FIXING**: Dev/Architect fix without asking user
4. **QA VERIFIES**: Re-run tests after each fix
5. **LOOP UNTIL GREEN**: Keep fixing until all tests pass

```
# When /heal is invoked, it reads existing .clean-claude/ state:

if exists(".clean-claude/failures.md"):
    # Continue fixing from where /craft stopped
    failures = read(".clean-claude/failures.md")
    for failure in failures:
        route_to_agent(failure)  # Dev or Architect
    qa_verify()
else:
    # Fresh diagnosis
    run_full_diagnostic()
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
// .clean-claude/state.json
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

### `/heal spec`

Fix specification issues:

```bash
/heal spec                    # Analyze spec vs implementation
/heal spec user-login.md      # Fix specific spec file
/heal spec --sync             # Sync spec to match implementation
/heal spec --impl             # Update implementation to match spec
```

#### What It Detects

| Issue | Description | Agent |
|-------|-------------|-------|
| **Spec drift** | Implementation doesn't match spec | `product-owner` analyzes |
| **Missing criteria** | Acceptance criteria incomplete | `product-owner` completes |
| **Untested criteria** | Criteria without tests | `qa-engineer` adds tests |
| **Orphan code** | Code not in any spec | `product-owner` documents |
| **Contradictions** | Conflicting requirements | `product-owner` resolves |

#### Heal Flow for Specs

```
┌─────────────────┐         ┌─────────────────┐
│  Read Spec      │         │  Read Code      │
│  (*.spec.md)    │         │  (src/)         │
└────────┬────────┘         └────────┬────────┘
         │                           │
         └─────────┬─────────────────┘
                   │
                   ▼
         ┌─────────────────┐
         │  Compare &      │
         │  Find Gaps      │
         └────────┬────────┘
                   │
         ┌─────────┴─────────┐
         │                   │
         ▼                   ▼
┌─────────────────┐  ┌─────────────────┐
│  Update Spec    │  │  Update Code    │
│  (--sync)       │  │  (--impl)       │
└─────────────────┘  └─────────────────┘
```

#### Example: Spec Drift

```
🔍 Analyzing spec vs implementation...

📋 Spec: docs/specs/user-login.spec.md
📁 Code: src/features/auth/

Found 3 issues:

1. ❌ Missing in code: "Remember me" checkbox (spec line 24)
2. ❌ Missing in spec: Password strength indicator (src/Login.tsx:45)
3. ⚠️ Mismatch: Spec says "5 attempts", code has "3 attempts"

How to heal?
  [Update spec to match code]
  [Update code to match spec]
  [Review each issue]
```

#### Example: Missing Acceptance Criteria

```
🔍 Analyzing spec completeness...

📋 Spec: docs/specs/checkout.spec.md

Found incomplete criteria:

1. ⚠️ "User can apply discount code" — no success/error states defined
2. ⚠️ "Order confirmation" — no email specification
3. ❌ Missing: Edge case for empty cart

🔧 Healing with product-owner...

product-owner is completing the spec:
  → Added success/error states for discount code
  → Specified confirmation email content
  → Added empty cart edge case

✅ Spec healed! 3 criteria completed.
```

---

## Smart Detection

If the user provides context, use it:

| Input | Action |
|-------|--------|
| `/heal` | Full diagnostic (code + specs), fix all |
| `/heal tests` | Fix tests only |
| `/heal spec` | Fix spec issues only |
| `/heal Login.test.tsx` | Fix specific test file |
| `/heal user-login.spec.md` | Fix specific spec file |
| `/heal "Cannot find module"` | Fix that specific error |
| `/heal "spec drift"` | Sync spec and implementation |

---

## Output Examples

### Successful Heal

```
🔍 Diagnosing...

Found 2 issues:
  ❌ Tests: 3 failing
  ❌ Types: 1 error

🔧 Healing types first...

architect is analyzing...
  → Fixed: Added missing type for UserResponse

🔧 Healing tests...

frontend-engineer is fixing...
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

Attempt 1/3: frontend-engineer fixing...
  → Applied fix

🧪 Verifying... ❌ Still failing

Attempt 2/3: frontend-engineer fixing...
  → Applied different approach

🧪 Verifying... ❌ Still failing

Attempt 3/3: frontend-engineer fixing...
  → Tried alternative solution

🧪 Verifying... ❌ Still failing

⚠️ Could not auto-heal after 3 attempts.

Remaining issue:
  - Login.test.tsx: "should handle network error"

Suggestions:
  1. Check the test expectations
  2. Review the error handling logic
  3. Run `/craft` and choose "Fix something" for guided debugging
```

---

## Integration with .clean-claude/

### Read Learnings

Before fixing, check if we've seen this error before:

```bash
# Search learnings for similar errors
grep -i "login" .clean-claude/learnings.jsonl
```

If found, apply the known solution first.

### Write Learnings

After successful fix, record the pattern:

```jsonl
{"timestamp":"...","error_type":"test_failure","pattern":"selector not found","file":"*.test.tsx","solution":"Use data-testid instead of class selector","agent":"frontend-engineer"}
```

---

## Tone

- **Confident:** "Found 2 issues. Fixing..."
- **Clear:** Show what's happening at each step
- **Helpful:** If can't fix, suggest next steps
- **Fast:** Minimize chatter, maximize action

---

## Agent Invocation

### How to Spawn Agents

Use the **Task tool** with the appropriate `subagent_type`:

```
Task tool:
  subagent_type: "frontend-engineer"
  prompt: "Fix this error:\n<error details>\n\nFile: <file path>"
```

### Routing Table

| Error Type | subagent_type | Prompt Template |
|------------|---------------|-----------------|
| Test failure | `frontend-engineer` or `backend-engineer` | "Fix failing test:\n<test output>" |
| Type error | `architect` | "Fix TypeScript error:\n<tsc output>" |
| Build error | `architect` | "Fix build error:\n<build output>" |
| Design flaw | `architect` | "Redesign to fix:\n<issue description>" |
| Spec gap | `product-owner` | "Complete spec for:\n<missing requirement>" |
| Unclear criteria | `product-owner` | "Clarify:\n<ambiguous criterion>" |

### Verification Flow

After each fix attempt:

```
# 1. Agent fixes the issue
Task(
  subagent_type: "<appropriate-agent>",
  prompt: "Fix: <error details>"
)

# 2. Verify with QA
Task(
  subagent_type: "qa-engineer",
  prompt: "Verify fix for:\n<what was fixed>\n\nRun: <test command>"
)

# 3. If still failing, loop (max 3 times)
```

### Stack Detection

Determine which dev agent to use:

| File Pattern | Agent |
|--------------|-------|
| `*.tsx`, `*.jsx`, `components/*` | `frontend-engineer` |
| `*.ts` in `api/`, `services/`, `server/` | `backend-engineer` |
| Mixed or unclear | Check `.clean-claude/context.json` for stack |
