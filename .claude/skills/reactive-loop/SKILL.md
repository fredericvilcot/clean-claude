---
name: reactive-loop
description: "Start the Clean Claude reactive multi-agent loop. Agents collaborate with smart routing: test failures → Dev, design flaws → Architect, spec gaps → PO. Full mesh of reactive links."
user-invocable: false
context: fork
agent: orchestrator
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task
---

# Reactive Loop Skill

You are initiating the Clean Claude Reactive Loop — a self-correcting multi-agent system where agents collaborate automatically to deliver features.

## What Happens

When you invoke `/reactive-loop`:

1. **Initialize** — Set up `.clean-claude/` shared state
2. **Define** — Product Owner creates user story
3. **Design** — Architect designs the solution
4. **Implement** — Frontend Engineer builds the feature
5. **Verify** — QA Engineer runs tests
6. **Fix Loop** — If tests fail, Dev fixes and QA re-verifies (up to 3 retries)
7. **Complete** — Feature delivered with all tests passing

## Setup

First, ensure the project has the Clean Claude hooks configured:

```bash
# Check if .clean-claude exists
if [ ! -d .clean-claude ]; then
    mkdir -p .clean-claude
    echo '{"workflow":null,"feature":null,"phase":"idle","retryCount":0,"maxRetries":3,"agents":{"lastActive":null,"history":[]},"status":"ready"}' > .clean-claude/state.json
    touch .clean-claude/errors.jsonl
    touch .clean-claude/events.jsonl
    touch .clean-claude/learnings.jsonl
    echo '{}' > .clean-claude/context.json
fi
```

## Starting the Loop

### Step 1: Get Feature Description

Ask the user what feature they want to build:
- What is the feature?
- Who is it for?
- What problem does it solve?

### Step 2: Initialize State

```bash
cat > .clean-claude/state.json << EOF
{
  "workflow": "feature",
  "feature": "<FEATURE_NAME>",
  "phase": "define",
  "retryCount": 0,
  "maxRetries": 3,
  "agents": {"lastActive": "orchestrator", "history": ["orchestrator"]},
  "status": "in_progress"
}
EOF

cat > .clean-claude/context.json << EOF
{
  "feature": "<FEATURE_NAME>",
  "description": "<FEATURE_DESCRIPTION>",
  "startedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "requestedBy": "user"
}
EOF
```

### Step 3: Start Phase 1 — Define

Spawn the product-owner agent to create the user story:

```
Use the product-owner agent to define user stories for this feature:

Feature: <FEATURE_NAME>
Description: <FEATURE_DESCRIPTION>

Create a complete user story with:
1. As a / I want / So that
2. Acceptance criteria (Given/When/Then)
3. Examples
4. Out of scope
5. Success metrics

Save the user story to: docs/features/<feature-name>/user-story.md
```

### Step 4: Continue the Loop

After each agent completes:

1. **Read state**: `cat .clean-claude/state.json`
2. **Check for trigger**: `cat .clean-claude/trigger 2>/dev/null`
3. **Spawn next agent** based on phase

### Phase Transitions

| Current Phase | On Success | On Error Type | Route To |
|--------------|------------|---------------|----------|
| define | → design | — | — |
| design | → implement | contradiction | → PO (arbitrate) |
| design | → implement | spec_gap | → PO (complete) |
| implement | → verify | blocked_by_design | → Architect |
| implement | → verify | spec_gap | → PO |
| verify | → complete | test_failure | → Dev (fix) |
| verify | → complete | design_flaw | → Architect |
| verify | → complete | unclear_criteria | → PO |
| fix | → verify | — | → fix (retry) |

### Error Type Detection

| Error Type | Detection Pattern | Routed To |
|------------|-------------------|-----------|
| `test_failure` | FAIL, expect, assertion | Dev (owner) |
| `type_error` | TS error, not assignable | Architect |
| `design_flaw` | circular, race condition, coupling | Architect |
| `spec_gap` | edge case, not covered, what if | PO |
| `unclear_criteria` | ambiguous, not specified | PO |
| `contradiction` | impossible, mutually exclusive | PO |
| `blocked_by_design` | cannot implement, need decision | Architect |
| `build_error` | compilation, module not found | Dev |
| `lint_error` | eslint, prettier | Dev |

### Step 5: Monitor Progress

Keep the user informed:

```
[CLEAN CLAUDE] Phase: implement (2/5)
[CLEAN CLAUDE] Agent: frontend-engineer
[CLEAN CLAUDE] Status: Implementing feature...
```

### Step 6: Handle Errors (Smart Routing)

When any agent reports an issue, route based on error type:

#### 6a. Test Failures → Dev
```
Use the <dev-agent> agent to fix the following test failure:

Error: <ERROR_MESSAGE>
File: <FILE_PATH>
Ownership: <AGENT_WHO_WROTE_IT>

Fix the error and ensure tests pass.
```

#### 6b. Design Flaws → Architect
```
Use the architect agent to fix this design issue:

Problem: <DESIGN_ISSUE>
Detection: <HOW_IT_WAS_FOUND>
Files: <AFFECTED_FILES>

Redesign and update technical spec.
```

#### 6c. Spec Gaps → Product Owner
```
Use the product-owner agent to complete the specification:

Missing: <EDGE_CASE_OR_REQUIREMENT>
Context: <WHERE_FOUND>
Reported by: <AGENT>

Update the spec with the missing criteria.
```

#### 6d. Unclear Criteria → Product Owner
```
Use the product-owner agent to clarify this acceptance criterion:

Criterion: <AMBIGUOUS_CRITERION>
Question: <WHAT_NEEDS_CLARIFICATION>
Impact: <WHAT_CANT_BE_TESTED>

Clarify and update the user story.
```

#### 6e. Contradictions → Product Owner
```
Use the product-owner agent to resolve this contradiction:

Requirement A: <FIRST_REQUIREMENT>
Requirement B: <CONFLICTING_REQUIREMENT>
Analysis: <WHY_THEY_CONFLICT>

Decide on the tradeoff and update the spec.
```

#### 6f. Design Blocks → Architect
```
Use the architect agent to adjust the design:

Blocker: <WHAT_CANT_BE_IMPLEMENTED>
Current Design: <DESIGN_DECISION>
Suggested: <DEV_SUGGESTION>

Adjust the design to unblock implementation.
```

#### Routing Logic

```
┌─────────────────────────────────────────────────────────────────┐
│                    ERROR ROUTING LOGIC                          │
│                                                                 │
│  1. Parse error message                                         │
│  2. Detect error type:                                          │
│     - test_failure    → Check ownership → Route to owner dev    │
│     - type_error      → Route to architect             │
│     - design_flaw     → Route to architect             │
│     - spec_gap        → Route to product-owner                  │
│     - unclear_criteria→ Route to product-owner                  │
│     - contradiction   → Route to product-owner                  │
│     - blocked_by_design → Route to architect           │
│  3. Spawn agent with error context                              │
│  4. After fix, re-verify with qa-engineer                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Step 7: Complete

When all tests pass:

1. Update state to `complete`
2. Record any new learnings
3. Report success to user

```
[CLEAN CLAUDE] ✓ Feature complete!
[CLEAN CLAUDE]
[CLEAN CLAUDE] Summary:
[CLEAN CLAUDE] - User story: docs/features/<feature>/user-story.md
[CLEAN CLAUDE] - Design: docs/features/<feature>/technical-design.md
[CLEAN CLAUDE] - Tests: All passing
[CLEAN CLAUDE] - Retries: <N>
[CLEAN CLAUDE] - Learnings: <N> new patterns recorded
```

## Error Recovery

If max retries exceeded:

```
[CLEAN CLAUDE] ✗ Max retries (3) exceeded
[CLEAN CLAUDE]
[CLEAN CLAUDE] Last error:
[CLEAN CLAUDE] <ERROR_DETAILS>
[CLEAN CLAUDE]
[CLEAN CLAUDE] Options:
[CLEAN CLAUDE] 1. Manually fix and run: /reactive-loop continue
[CLEAN CLAUDE] 2. Reset and start over: /reactive-loop reset
[CLEAN CLAUDE] 3. Ask for help with the specific error
```

## Commands

### Start new feature
```
/reactive-loop
> What feature do you want to build?
```

### Continue after manual fix
```
/reactive-loop continue
```

### Check status
```
/reactive-loop status
```

### Reset
```
/reactive-loop reset
```

## File Outputs

The loop creates:

```
docs/features/<feature-name>/
├── user-story.md        # From product-owner
├── technical-design.md  # From architect
└── qa-report.md         # From qa-engineer

.clean-claude/
├── state.json           # Current state
├── errors.jsonl         # Error history
├── events.jsonl         # Event log
├── learnings.jsonl      # Patterns learned
└── context.json         # Feature context
```

## The Magic

The reactive loop is self-correcting:

1. **QA finds bug** → Automatically spawns Dev
2. **Dev fixes** → Automatically spawns QA
3. **QA verifies** → Loop until success or max retries
4. **Learnings accumulate** → Future fixes are faster

Each iteration makes the system smarter. Patterns that work get recorded. Errors that repeat get recognized. The agents learn from each other.

**Start the loop and watch the agents collaborate.**
