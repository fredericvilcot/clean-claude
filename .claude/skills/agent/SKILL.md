---
name: agent
description: "Start a Spectre agent with optional reactive links. Examples: /agent frontend-dev, /agent frontend-dev --link qa-engineer, /agent software-craftsman --link frontend-dev,qa-engineer"
context: conversation
allowed-tools: Read, Write, Bash, Task
---

# Agent Skill — Start with Reactive Links

Start any Spectre agent with optional reactive connections to other agents.

## Syntax

```
/agent <agent-name> [--link <agents>] [--stack <stack>] [--task <description>] [--review]
```

### Arguments

| Argument | Description | Example |
|----------|-------------|---------|
| `<agent-name>` | Agent to start | `frontend-dev`, `qa-engineer` |
| `--link <agents>` | Agents to link reactively (comma-separated) | `--link qa-engineer` |
| `--stack <stack>` | Stack context | `--stack frontend` |
| `--task <desc>` | Task description | `--task "Build login form"` |
| `--review` | Enable code review loop (Architect → Dev) | `--review` |

### Escalation Keywords

Agents can escalate issues by using these keywords in their output:

| Keyword | Escalates To | Description |
|---------|--------------|-------------|
| `BLOCKED:` | Architect | Design block, need decision |
| `SPEC_GAP:` | PO | Missing requirement |
| `UNCLEAR:` | PO | Ambiguous criteria |
| `DESIGN_FLAW:` | Architect | Architectural issue found |
| `CONTRADICTION:` | PO | Conflicting requirements |

Example agent output:
```
BLOCKED: Cannot implement real-time sync without WebSocket infrastructure.
Need architectural decision on connection strategy.
```
→ Automatically routes to software-craftsman

## Examples

### Start frontend-dev alone
```
/agent frontend-dev
```
Agent works, no reactive loop.

### Start frontend-dev linked to QA
```
/agent frontend-dev --link qa-engineer
```
Frontend works → QA verifies → error → Frontend fixes → loop

### Start architect linked to dev and QA
```
/agent software-craftsman --link frontend-dev,qa-engineer
```
Architect designs → Frontend implements → QA verifies → errors route back

### Start with task description
```
/agent frontend-dev --link qa-engineer --task "Build user authentication form"
```

## Available Agents

| Agent | Role | Common Links |
|-------|------|--------------|
| `software-craftsman` | Architecture, design | `frontend-dev`, `backend-dev` |
| `product-owner` | User stories | `software-craftsman` |
| `frontend-dev` | UI implementation | `qa-engineer`, `software-craftsman` |
| `backend-dev` | API implementation | `qa-engineer`, `software-craftsman` |
| `qa-engineer` | Testing, verification | `frontend-dev`, `backend-dev` |

## Reactive Links — Full Matrix

### Link Types

| Link | Trigger | Action |
|------|---------|--------|
| **QA → Dev** | Test failure | Dev fixes code |
| **QA → Architect** | Design flaw detected | Architect redesigns |
| **QA → PO** | Unclear acceptance criteria | PO clarifies spec |
| **Dev → Architect** | Blocked by design | Architect adjusts |
| **Dev → PO** | Edge case not covered | PO completes spec |
| **Architect → PO** | Contradiction/impossibility | PO arbitrates |
| **Architect → Dev** | Code review feedback | Dev improves |
| **Spec Drift** | Code ≠ Spec | PO or Dev aligns |

---

### 1. QA → Dev (Test Failures)
```
┌──────────────┐         ┌──────────────┐
│     qa-      │  test   │  frontend-   │
│   engineer   │  fail   │     dev      │
└──────────────┘ ──────▶ └──────────────┘
       ▲                        │
       │         fixed          │
       └────────────────────────┘
```
**Trigger:** `FAIL`, `expect`, `assertion error`
**Route to:** Last dev who touched the file (ownership) or stack dev

---

### 2. QA → Architect (Design Flaws)
```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│     qa-      │ design  │   software-  │  new    │     dev      │
│   engineer   │  flaw   │   craftsman  │ design  │              │
└──────────────┘ ──────▶ └──────────────┘ ──────▶ └──────────────┘
       ▲                                                 │
       │                    re-verify                    │
       └─────────────────────────────────────────────────┘
```
**Trigger:** Race condition, circular dependency, architectural issue
**Detection:** `circular`, `deadlock`, `race condition`, `coupling`

---

### 3. QA → PO (Unclear Criteria)
```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│     qa-      │ unclear │   product-   │ clarify │     qa-      │
│   engineer   │ criteria│    owner     │   spec  │   engineer   │
└──────────────┘ ──────▶ └──────────────┘ ──────▶ └──────────────┘
```
**Trigger:** `ambiguous`, `not specified`, `undefined behavior`
**Detection:** QA reports unclear acceptance criteria

---

### 4. Dev → Architect (Design Block)
```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│  frontend-   │ blocked │   software-  │ adjust  │  frontend-   │
│     dev      │   by    │   craftsman  │ design  │     dev      │
└──────────────┘ design  └──────────────┘ ──────▶ └──────────────┘
                 ──────▶
```
**Trigger:** `cannot implement`, `design issue`, `need architectural decision`
**Detection:** Dev explicitly flags design problem

---

### 5. Dev → PO (Spec Gap)
```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│  frontend-   │  edge   │   product-   │ update  │  frontend-   │
│     dev      │  case   │    owner     │   spec  │     dev      │
└──────────────┘ ──────▶ └──────────────┘ ──────▶ └──────────────┘
```
**Trigger:** `edge case`, `not covered in spec`, `what if`, `missing requirement`
**Detection:** Dev finds gap in specification

---

### 6. Architect → PO (Feasibility)
```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   software-  │ contra- │   product-   │ decide  │   software-  │
│   craftsman  │ diction │    owner     │ tradeoff│   craftsman  │
└──────────────┘ ──────▶ └──────────────┘ ──────▶ └──────────────┘
```
**Trigger:** `contradiction`, `impossible`, `tradeoff needed`, `mutually exclusive`
**Detection:** Architect identifies spec issues

---

### 7. Architect → Dev (Code Review)
```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   software-  │ review  │  frontend-   │ improve │   software-  │
│   craftsman  │ feedback│     dev      │   code  │   craftsman  │
└──────────────┘ ──────▶ └──────────────┘ ──────▶ └──────────────┘
       │                                                 │
       └──────────────── approved ◀──────────────────────┘
```
**Trigger:** Post-implementation review
**Mode:** Enable with `--review` flag

---

### 8. Spec Drift Detection (Bidirectional)
```
┌─────────────┐                           ┌─────────────┐
│    Spec     │◀── drift detected ──────▶│    Code     │
└──────┬──────┘                           └──────┬──────┘
       │                                         │
       ▼                                         ▼
┌─────────────┐                           ┌─────────────┐
│  Update     │    OR                     │  Update     │
│  Spec       │                           │  Code       │
│  (--sync)   │                           │  (--impl)   │
└─────────────┘                           └─────────────┘
```
**Trigger:** `/heal spec` or automatic drift detection
**Route:** PO updates spec OR Dev updates code

---

## Full Workflow with All Links

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        COMPLETE REACTIVE SYSTEM                          │
│                                                                          │
│  ┌───────────────┐                                                       │
│  │ product-owner │◀──────────────────────────────────────────┐           │
│  └───────┬───────┘                                           │           │
│          │ spec                                              │           │
│          ▼                                    contradiction  │           │
│  ┌───────────────┐◀────────────────────────────────────┐     │           │
│  │   software-   │                                     │     │           │
│  │   craftsman   │─────── design flaw ─────────────────│─────│───┐       │
│  └───────┬───────┘                                     │     │   │       │
│          │ design                                      │     │   │       │
│          ▼                              blocked by     │     │   │       │
│  ┌───────────────┐                         design ─────┘     │   │       │
│  │   frontend-   │                                           │   │       │
│  │      dev      │────── spec gap ───────────────────────────┘   │       │
│  └───────┬───────┘                                               │       │
│          │ code                                                  │       │
│          ▼                                                       │       │
│  ┌───────────────┐                                               │       │
│  │  qa-engineer  │───── test failure ──▶ Dev ◀───────────────────┘       │
│  │               │───── design flaw ───▶ Architect                       │
│  │               │───── unclear spec ──▶ PO                              │
│  └───────────────┘                                                       │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

## How It Works

1. **Parse arguments** from the skill invocation
2. **Initialize .spectre/** if not exists
3. **Configure links** in `.spectre/links.json`
4. **Start the agent** with context
5. **Hooks route** based on configured links

## Implementation

When you invoke `/agent`, parse the arguments and:

### Step 1: Parse Arguments

Extract from the user's command:
- `agent_name`: The agent to start
- `links`: Array of linked agents (from --link)
- `stack`: Stack context (from --stack, default: "frontend")
- `task`: Task description (from --task)

### Step 2: Initialize Spectre State

```bash
mkdir -p .spectre

# Create links configuration
cat > .spectre/links.json << EOF
{
  "primary": "<agent_name>",
  "links": [<links_array>],
  "stack": "<stack>",
  "task": "<task>"
}
EOF

# Initialize state
cat > .spectre/state.json << EOF
{
  "workflow": "agent",
  "feature": "<task or 'ad-hoc'>",
  "stack": "<stack>",
  "phase": "active",
  "retryCount": 0,
  "maxRetries": 3,
  "agents": {
    "primary": "<agent_name>",
    "links": [<links_array>],
    "lastActive": null,
    "lastDev": null,
    "history": []
  },
  "status": "in_progress"
}
EOF
```

### Step 3: Start the Agent

Use the Task tool to spawn the agent:

```
Use the <agent_name> agent to work on: <task>

Context:
- Stack: <stack>
- Linked agents: <links>
- When complete, linked agents will be triggered automatically

<Additional context from .spectre/context.json if exists>
```

### Step 4: Reactive Routing

The hooks will handle routing based on `.spectre/links.json`:

When the primary agent completes:
1. Check if there are linked agents
2. Trigger the first link (e.g., qa-engineer)
3. If error in verification → route back to primary
4. Loop until success

## Examples of Parsed Commands

### `/agent frontend-dev`
```json
{
  "primary": "frontend-dev",
  "links": [],
  "stack": "frontend",
  "task": null
}
```
→ Starts frontend-dev alone, no reactive loop

### `/agent frontend-dev --link qa-engineer`
```json
{
  "primary": "frontend-dev",
  "links": ["qa-engineer"],
  "stack": "frontend",
  "task": null
}
```
→ Starts frontend-dev, QA verifies after, errors loop back

### `/agent frontend-dev --link qa-engineer,software-craftsman --task "Build login"`
```json
{
  "primary": "frontend-dev",
  "links": ["qa-engineer", "software-craftsman"],
  "stack": "frontend",
  "task": "Build login"
}
```
→ Starts frontend-dev with full context, linked to both QA and architect

## Shorthand Commands

For convenience, also support:

| Shorthand | Equivalent |
|-----------|------------|
| `/agent front` | `/agent frontend-dev` |
| `/agent back` | `/agent backend-dev` |
| `/agent arch` | `/agent software-craftsman` |
| `/agent qa` | `/agent qa-engineer` |
| `/agent po` | `/agent product-owner` |

## Integration with Existing Workflow

This skill complements `/reactive-loop`:
- `/reactive-loop` — Full workflow (PO → Arch → Dev → QA)
- `/agent` — Flexible, start any agent with chosen links

Both use the same `.spectre/` state and routing infrastructure.
