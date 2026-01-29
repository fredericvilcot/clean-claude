---
name: reactive-loop
description: "Start the Spectre reactive multi-agent loop. Agents collaborate automatically: QA finds errors → Dev fixes → QA verifies → repeat until success"
context: fork
agent: orchestrator
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task
---

# Reactive Loop Skill

You are initiating the Spectre Reactive Loop — a self-correcting multi-agent system where agents collaborate automatically to deliver features.

## What Happens

When you invoke `/reactive-loop`:

1. **Initialize** — Set up `.spectre/` shared state
2. **Define** — Product Owner creates user story
3. **Design** — Software Craftsman designs the solution
4. **Implement** — Frontend Dev builds the feature
5. **Verify** — QA Engineer runs tests
6. **Fix Loop** — If tests fail, Dev fixes and QA re-verifies (up to 3 retries)
7. **Complete** — Feature delivered with all tests passing

## Setup

First, ensure the project has the Spectre hooks configured:

```bash
# Check if .spectre exists
if [ ! -d ".spectre" ]; then
    mkdir -p .spectre
    echo '{"workflow":null,"feature":null,"phase":"idle","retryCount":0,"maxRetries":3,"agents":{"lastActive":null,"history":[]},"status":"ready"}' > .spectre/state.json
    touch .spectre/errors.jsonl
    touch .spectre/events.jsonl
    touch .spectre/learnings.jsonl
    echo '{}' > .spectre/context.json
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
cat > .spectre/state.json << EOF
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

cat > .spectre/context.json << EOF
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

1. **Read state**: `cat .spectre/state.json`
2. **Check for trigger**: `cat .spectre/trigger 2>/dev/null`
3. **Spawn next agent** based on phase

### Phase Transitions

| Current Phase | On Success | On Error |
|--------------|------------|----------|
| define | → design | — |
| design | → implement | — |
| implement | → verify | — |
| verify | → complete | → fix |
| fix | → verify | → fix (retry) |

### Step 5: Monitor Progress

Keep the user informed:

```
[SPECTRE] Phase: implement (2/5)
[SPECTRE] Agent: frontend-dev
[SPECTRE] Status: Implementing feature...
```

### Step 6: Handle Errors

When QA reports test failures:

1. Read error from `.spectre/errors.jsonl`
2. Check retry count (max 3)
3. Spawn frontend-dev with error context:

```
Use the frontend-dev agent to fix the following test failure:

Error: <ERROR_MESSAGE>
File: <FILE_PATH>
Line: <LINE_NUMBER>

Stack trace:
<STACK_TRACE>

Previous learnings that might help:
<RELEVANT_LEARNINGS>

Fix the error and ensure tests pass.
```

### Step 7: Complete

When all tests pass:

1. Update state to `complete`
2. Record any new learnings
3. Report success to user

```
[SPECTRE] ✓ Feature complete!
[SPECTRE]
[SPECTRE] Summary:
[SPECTRE] - User story: docs/features/<feature>/user-story.md
[SPECTRE] - Design: docs/features/<feature>/technical-design.md
[SPECTRE] - Tests: All passing
[SPECTRE] - Retries: <N>
[SPECTRE] - Learnings: <N> new patterns recorded
```

## Error Recovery

If max retries exceeded:

```
[SPECTRE] ✗ Max retries (3) exceeded
[SPECTRE]
[SPECTRE] Last error:
[SPECTRE] <ERROR_DETAILS>
[SPECTRE]
[SPECTRE] Options:
[SPECTRE] 1. Manually fix and run: /reactive-loop continue
[SPECTRE] 2. Reset and start over: /reactive-loop reset
[SPECTRE] 3. Ask for help with the specific error
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
├── technical-design.md  # From software-craftsman
└── qa-report.md         # From qa-engineer

.spectre/
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
