---
name: craft
description: "Craft something new. Adapts to your work context (Product Team, Startup, Freelance). Express your need, Spectre configures the agents."
context: conversation
allowed-tools: Read, Bash, Task, AskUserQuestion, Skill
---

# Spectre Craft — Adapted to Your Context

Craft features based on HOW you work, not just WHAT you want to build.

## Philosophy

Different contexts need different workflows:
- **Product Team** → Full process, specs, reviews, compliance
- **Startup** → Fast iterations, ship & learn
- **Freelance** → Efficient, focused, no overhead

---

## Step 0: Stack Detection + Pattern Learning (2 phases distinctes)

**Before asking any questions**, two separate phases:

### Phase 1: STACK DETECTION (toujours exécuté)

Détecte le stack technique. **Indépendant des violations.**
Même si le code est pourri, on sait quand même que c'est du TypeScript/Go/Rust.

### Phase 2: PATTERN LEARNING (peut être bloqué)

Apprend les patterns du projet. **STOP sur violations.**
Si bloqué → agents utilisent les craft defaults pour le stack détecté.

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLOW DÉTAILLÉ                                 │
│                                                                  │
│  1. STACK DETECTION ─────────────────────────────────────────   │
│     │                                                            │
│     └─→ Toujours OK → Stocké dans .spectre/context.json         │
│                                                                  │
│  2. PATTERN LEARNING ────────────────────────────────────────   │
│     │                                                            │
│     ├─→ Violation? ─── OUI ─→ STOP                              │
│     │                         Rapport généré                     │
│     │                         User décide (fix/skip/stop)        │
│     │                         Patterns NON appris                │
│     │                                                            │
│     └─→ Violation? ─── NON ─→ Patterns appris                   │
│                               Stockés dans .spectre/learnings/   │
│                                                                  │
│  3. AGENTS TRAVAILLENT AVEC: ────────────────────────────────   │
│     │                                                            │
│     ├─→ Stack détecté (TOUJOURS)                                │
│     ├─→ Patterns appris (SI pas de violations)                  │
│     └─→ Craft defaults pour le stack (SI violations)            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

### Phase 1: Stack Detection (ALWAYS)

#### Case A: Existing Project → Auto-Detect

```bash
# Check for stack indicators
if [ -f "package.json" ]; then
  STACK="node"
  grep -q "react" package.json && FRAMEWORK="react"
  grep -q "vue" package.json && FRAMEWORK="vue"
  [ -f "tsconfig.json" ] && LANGUAGE="typescript" || LANGUAGE="javascript"
elif [ -f "go.mod" ]; then
  STACK="go" && LANGUAGE="go"
elif [ -f "Cargo.toml" ]; then
  STACK="rust" && LANGUAGE="rust"
elif [ -f "pyproject.toml" ]; then
  STACK="python" && LANGUAGE="python"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
  STACK="jvm" && LANGUAGE="java"
fi
```

#### Case B: Empty/New Project → Guide Stack Selection

If no stack detected, **ask the user**:

```
Question: "What stack are you building with?"
Header: "Stack"
Options:
  1. "TypeScript + React"
     Description: "Frontend with React, Vite, Vitest"
  2. "TypeScript + Node"
     Description: "Backend with Node.js, Express/Fastify"
  3. "Go"
     Description: "Backend with Go, standard library or Gin/Echo"
  4. "Rust"
     Description: "Systems or backend with Rust"
  5. "Python"
     Description: "Backend with FastAPI/Django/Flask"
  6. "Other"
     Description: "Specify your stack"
```

Then ask for more specifics:

```
# If TypeScript + React:
Question: "Any preferences?"
Header: "Setup"
Options:
  1. "Full setup (Recommended)"
     Description: "Vite + Vitest + TailwindCSS + strict TS"
  2. "Minimal"
     Description: "Just React + TypeScript"
  3. "With state management"
     Description: "Add Zustand + React Query"
```

#### Store Stack Context (Phase 1 Result)

```bash
mkdir -p .spectre

cat > .spectre/context.json << EOF
{
  "stack": {
    "language": "$LANGUAGE",
    "runtime": "$STACK",
    "framework": "$FRAMEWORK",
    "setup": "$SETUP"
  },
  "learning": {
    "enabled": true,
    "scope": "project",
    "status": "pending"
  },
  "fromScratch": $FROM_SCRATCH,
  "detectedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
```

---

### Phase 2: Pattern Learning (MAY BE BLOCKED)

**Only runs if project has existing code.**

```bash
if [ "$FROM_SCRATCH" = "false" ] && [ "$LEARNING_ENABLED" = "true" ]; then
  # Scan for patterns
  # Apply craft guard
  # If violations → STOP, report, ask user
  # If clean → store patterns
fi
```

#### On Violation: What Happens

```
🔍 Learning patterns...

🛑 CRAFT VIOLATIONS DETECTED

   src/services/UserService.ts:45
   → throw new Error('User not found')
   → Violates: Explicit Error Handling

📋 Report: .spectre/violations-report.md

⚠️  Stack detected: TypeScript + React
✅  Agents will use CRAFT DEFAULTS for TypeScript + React
❌  Project patterns NOT learned (violations blocked)

   [ 🔧 Fix violations ]  [ ⏭️ Continue anyway ]  [ 🛑 Stop ]
```

#### Context After Violation

```json
{
  "stack": {
    "language": "typescript",
    "runtime": "node",
    "framework": "react"
  },
  "learning": {
    "enabled": true,
    "status": "blocked",
    "reason": "violations",
    "violationCount": 2
  }
}
```

**Agents still know the stack.** They use craft defaults instead of project patterns.

---

### Agent Knowledge by Stack — Dynamic Injection

Agents receive stack-specific craft guidelines **dynamically injected** at spawn time.

#### Supported Stacks (Native)

| Stack | File | Key Patterns |
|-------|------|--------------|
| **TypeScript + React** | `stacks/typescript-react.md` | Strict types, hooks, Testing Library, a11y |
| **TypeScript + Node** | `stacks/typescript-node.md` | Result types, Zod, hexagonal, Pino |
| **Go** | `stacks/go.md` | Error returns, small interfaces, table tests |
| **Rust** | `stacks/rust.md` | Result/Option, thiserror, traits, no unwrap |
| **Python** | `stacks/python.md` | Type hints, dataclasses, protocols, pytest |

#### Injection Flow — Stack Defaults + Project Learnings

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│  1. Stack detected → "typescript-react"                         │
│                                                                  │
│  2. Load CRAFT DEFAULTS (always):                               │
│     → Read .claude/skills/craft/stacks/typescript-react.md      │
│                                                                  │
│  3. Load PROJECT LEARNINGS (if clean, auto-learning on):        │
│     → Read .spectre/learnings/patterns.json                     │
│     → Read .spectre/learnings/examples.json                     │
│                                                                  │
│  4. Spawn agent with FULL context:                              │
│                                                                  │
│     Task(                                                        │
│       subagent_type: "frontend-engineer",                       │
│       prompt: """                                                │
│         ## Stack Context                                         │
│         Tu travailles sur un projet TypeScript + React.          │
│                                                                  │
│         ## Craft Defaults (Stack)                                │
│         <contenu de typescript-react.md>                        │
│                                                                  │
│         ## Project Patterns (Learned)                            │
│         <contenu de .spectre/learnings/patterns.json>           │
│                                                                  │
│         ## Reference Examples                                    │
│         <contenu de .spectre/learnings/examples.json>           │
│                                                                  │
│         ## Task                                                  │
│         <la tâche demandée>                                     │
│       """                                                        │
│     )                                                            │
│                                                                  │
│  5. Agent = Universal + Stack defaults + Project patterns       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

#### What Gets Injected

| Source | Condition | Content |
|--------|-----------|---------|
| **Stack defaults** | Always | Craft principles for the detected stack |
| **Project patterns** | Learning ON + No violations | Naming, imports, architecture conventions |
| **Reference examples** | Learning ON + No violations | Best files as templates |

#### Continuous Learning

Each time `/craft` or `/heal` runs:
1. Check if `.spectre/learnings/` exists and is up-to-date
2. If new patterns detected → update learnings
3. Inject fresh learnings into next agent spawn

Agents stay in sync with your evolving codebase.

#### Why This Matters

| Sans injection | Avec injection |
|----------------|----------------|
| Agent devine les conventions | Agent suit des guidelines précises |
| Patterns incohérents | Patterns uniformes |
| Code "générique" | Code idiomatique au stack |
| Risque d'anti-patterns | Anti-patterns documentés et évités |

#### Adding New Stacks

Pour supporter un nouveau stack :
1. Créer `.claude/skills/craft/stacks/<stack-name>.md`
2. Suivre le format des fichiers existants
3. Documenter : type system, error handling, architecture, testing, anti-patterns

---

### Summary: What Agents Get

| Situation | Stack | Patterns | Source |
|-----------|-------|----------|--------|
| Clean project | ✅ Detected | ✅ Learned | Project |
| Violations found | ✅ Detected | ❌ Blocked | Craft defaults |
| From scratch | ✅ Selected | — | Craft defaults |
| Learning disabled | ✅ Detected | — | Craft defaults |

---

## The Flow

### SMART ROUTING: From Scratch vs Existing Project

**CRITICAL:** Adapt the flow based on project state.

```
┌─────────────────────────────────────────────────────────────────┐
│                     FLOW ROUTING                                 │
│                                                                  │
│  FROM SCRATCH (no code detected):                               │
│  ─────────────────────────────────                               │
│  1. Stack selection ✓ (already done in Phase 1)                 │
│  2. Work context (Product Team/Startup/etc.)                    │
│  3. SKIP "What do you want to do?" → assume BUILD               │
│  4. Go directly to domain questions                              │
│  5. Ask what to build → GO                                       │
│                                                                  │
│  EXISTING PROJECT (code detected):                               │
│  ─────────────────────────────────                               │
│  1. Auto-detect stack ✓ (already done in Phase 1)               │
│  2. Work context (Product Team/Startup/etc.)                    │
│  3. "What do you want to do?" → Build/Fix/Improve/Think         │
│  4. Continue based on choice                                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

### Step 1: What's Your Work Context?

**First time only** (remember for the session):

```
Question: "What's your work context?"
Header: "Context"
Options:
  1. "Product Team / Enterprise"
     Description: "Specs, process, reviews, multiple stakeholders"
  2. "Startup / Small Team"
     Description: "Fast iterations, agile, ship & learn"
  3. "Freelance / Solo"
     Description: "Efficient, focused, minimal overhead"
  4. "Learning / Exploring"
     Description: "Trying things out, no pressure"
```

---

### Step 2: What Do You Want to Do? (EXISTING PROJECTS ONLY)

**⚠️ SKIP THIS STEP IF `fromScratch === true`**

From scratch = nothing to fix, nothing to improve. Go directly to building.

```
# ONLY for existing projects:
if (fromScratch === false) {
  Question: "What do you want to do?"
  Header: "Goal"
  Options:
    1. "Build something new"
       Description: "New feature, component, or functionality"
    2. "Fix something"
       Description: "Bug, error, failing tests"
    3. "Improve existing code"
       Description: "Refactor, add tests, clean up"
    4. "Think / Design"
       Description: "Architecture, planning, decisions"
}

# For from-scratch projects:
if (fromScratch === true) {
  # SKIP this question
  # Assume goal = "Build something new"
  # Go directly to Step 3
}
```

---

### Step 3: Context-Specific Questions

#### If "Build something new"

**For Product Team / Enterprise:**

```
Question: "What do you have to start with?"
Header: "Input"
Options:
  1. "A PRD or feature spec"
     Description: "Product requirements document, Jira ticket, detailed spec"
  2. "A user story or brief"
     Description: "High-level requirement, needs refinement"
  3. "Just a concept"
     Description: "Idea that needs to be specced out"
```

Then:
```
Question: "What part of the system?"
Header: "Domain"
Options:
  1. "Frontend / UI"
  2. "Backend / API"
  3. "Full-stack"
```

**For Startup / Small Team:**

```
Question: "How clear are the requirements?"
Header: "Clarity"
Options:
  1. "Crystal clear — let's build"
     Description: "I know exactly what to do"
  2. "Mostly clear — might need quick design"
     Description: "90% there, need to figure out some details"
  3. "Rough idea — need to shape it"
     Description: "Know the goal, need to define the how"
```

Then:
```
Question: "Frontend, backend, or both?"
Header: "Stack"
Options:
  1. "Frontend"
  2. "Backend"
  3. "Both"
```

**For Freelance / Solo:**

```
Question: "What are you building?"
Header: "Stack"
Options:
  1. "UI / Frontend"
  2. "API / Backend"
  3. "Full-stack"
```

Then:
```
Question: "Testing?"
Header: "Quality"
Options:
  1. "Yes, with tests (Recommended)"
     Description: "QA agent verifies your work"
  2. "No, ship it"
     Description: "Just the implementation"
```

**For Learning / Exploring:**

```
Question: "What are you exploring?"
Header: "Area"
Options:
  1. "Frontend / React"
  2. "Backend / API"
  3. "Architecture patterns"
  4. "Testing practices"
```

→ Suggest appropriate craft skill directly

---

## Mapping Tables

### Product Team / Enterprise

| Input | Domain | Agents Chain |
|-------|--------|--------------|
| PRD/Spec | Frontend | `Architect → frontend-engineer → QA` |
| PRD/Spec | Backend | `Architect → backend-engineer → QA` |
| PRD/Spec | Full-stack | `Architect → backend-engineer → frontend-engineer → QA` |
| User story/Brief | Any | `PO (refine) → Architect → Dev → QA` |
| Just a concept | Any | `PO (full spec) → Architect → Dev → QA` |

**Characteristics:**
- Always includes architect for design review
- Always includes QA for testing
- PO refines unclear requirements
- Full documentation trail

### Startup / Small Team

| Clarity | Stack | Agents Chain |
|---------|-------|--------------|
| Crystal clear | Frontend | `frontend-engineer → QA` |
| Crystal clear | Backend | `backend-engineer → QA` |
| Crystal clear | Full-stack | `backend-engineer → frontend-engineer → QA` |
| Mostly clear | Any | `Architect (quick) → Dev → QA` |
| Rough idea | Any | `Architect → Dev → QA` |

**Characteristics:**
- Skip PO — you ARE the PO
- Architect only when needed
- Always QA for quality
- Fast feedback loop

### Freelance / Solo

| Stack | Testing | Agents Chain |
|-------|---------|--------------|
| Frontend | Yes | `frontend-engineer → QA` |
| Frontend | No | `frontend-engineer` |
| Backend | Yes | `backend-engineer → QA` |
| Backend | No | `backend-engineer` |
| Full-stack | Yes | `backend-engineer → frontend-engineer → QA` |
| Full-stack | No | `backend-engineer → frontend-engineer` |

**Characteristics:**
- Direct to implementation
- Testing is optional (but recommended)
- Minimal overhead
- Maximum efficiency

### Learning / Exploring

| Area | Agent |
|------|-------|
| Frontend/React | `frontend-engineer` (educational mode) |
| Backend/API | `backend-engineer` (educational mode) |
| Architecture | `architect` (design mode) |
| Testing | `qa-engineer` (educational mode) |

**Characteristics:**
- Educational mode
- Single agent explains concepts
- No pressure
- Pedagogical approach prioritized

---

## Step 4: Get Task Description

Context-appropriate prompt:

**Product Team:**
```
"Paste the PRD/spec or describe the feature:"
```

**Startup:**
```
"What are you building? (Keep it brief)"
```

**Freelance:**
```
"What do you need?"
```

**Learning:**
```
"What do you want to learn about?"
```

---

## Step 5: Confirm and Launch

Show context-appropriate summary:

### Product Team Example

```markdown
## Workflow for: User Authentication Feature

**Context:** Product Team / Enterprise
**Input:** PRD provided
**Domain:** Full-stack

### Agents Pipeline:

┌────────────────┐     ┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│   Architect    │ ──▶ │  backend-engineer   │ ──▶ │  frontend-engineer  │ ──▶ │  qa-engineer   │
│                │     │                │     │                │     │                │
│ • Tech design  │     │ • API          │     │ • UI           │     │ • Tests        │
│ • Data model   │     │ • Auth logic   │     │ • Forms        │     │ • Verification │
│ • Security     │     │ • Validation   │     │ • State        │     │ • Compliance   │
└────────────────┘     └────────────────┘     └────────────────┘     └───────┬────────┘
                                                      ▲                      │
                                                      └──── fix & retry ─────┘

**Output:** Tech spec → Implementation → Tested code
```

### Startup Example

```markdown
## Quick Build: Login Form

**Context:** Startup / Fast iteration
**Clarity:** Crystal clear
**Stack:** Frontend

### Agents:

┌────────────────┐     ┌────────────────┐
│  frontend-engineer  │ ──▶ │  qa-engineer   │
│                │     │                │
│ Build it       │     │ Test it        │
└────────────────┘     └───────┬────────┘
        ▲                      │
        └──── loop if needed ──┘

**Time to first feedback:** Fast ⚡
```

### Freelance Example

```markdown
## Task: Add Payment Form

**Context:** Freelance / Efficient
**Stack:** Frontend
**Testing:** Yes

### Agent:

frontend-engineer → qa-engineer (verify)

**Approach:** Direct implementation with quality check.
```

---

## Smart Context Detection

If user provides hints, detect context:

| Signal | Detected Context |
|--------|------------------|
| "PRD", "Jira", "spec", "requirements doc" | Product Team |
| "quick", "MVP", "ship it", "iterate" | Startup |
| "client", "project", "deadline" | Freelance |
| "learn", "try", "explore", "understand" | Learning |

---

## Remember Context

Store context for the session:

```json
// .spectre/context.json
{
  "workContext": "startup",
  "defaultStack": "frontend",
  "preferTesting": true
}
```

On subsequent `/craft` calls, skip Step 1 and use stored context.

To change: `/craft --reset` or answer "Other" to change context.

---

## Example Conversations

### FROM SCRATCH: New Project (Smart Flow)

```
User: /craft

Bot: 🔍 No project detected.
     "What stack are you building with?"
     [TypeScript + React] [TypeScript + Node] [Go] [Rust] [Python]

User: [TypeScript + React]

Bot: "Any preferences?"
     [Full setup] [Minimal] [With state management]

User: [Full setup]

Bot: ✅ Stack configured: TypeScript + React + Vite + Vitest + TailwindCSS

     "What's your work context?"
     [Product Team] [Startup] [Freelance] [Learning]

User: [Startup / Small Team]

Bot: "What part of the system?"                    ← SKIPPED "What do you want to do?"
     [Frontend] [Backend] [Full-stack]               (from scratch = obviously BUILD)

User: [Frontend]

Bot: "What are you building?"

User: "User authentication with social login"

Bot:
## New Project: User Authentication

**Stack:** TypeScript + React (Vite, Vitest, TailwindCSS)
**Context:** Startup / Fast iteration

### Agents:

architect → frontend-engineer → qa-engineer

Setting up project structure and starting architect...
```

**Key insight:** From scratch, we SKIP "Build/Fix/Improve?" — there's nothing to fix or improve yet.

---

### EXISTING PROJECT: Product Team Building from PRD

```
User: /craft

Bot: 🔍 Detected: TypeScript + React + Vite
     🔍 Learning patterns...
     ✅ Patterns learned (no violations)

     "What's your work context?"
     [Product Team] [Startup] [Freelance] [Learning]

User: [Product Team / Enterprise]

Bot: "What do you want to do?"                     ← SHOWN because existing project
     [Build something new] [Fix] [Improve] [Think]

User: [Build something new]

Bot: "What do you have to start with?"
     [A PRD or feature spec] [A user story] [Just a concept]

User: [A PRD or feature spec]

Bot: "What part of the system?"
     [Frontend] [Backend] [Full-stack]

User: [Full-stack]

Bot: "Paste the PRD or describe the feature:"

User: "User authentication with OAuth2, email/password, and 2FA support.
       See PRD-2024-AUTH in Confluence."

Bot:
## Enterprise Workflow: Authentication System

**Context:** Product Team
**Input:** PRD-2024-AUTH
**Scope:** Full-stack

### Pipeline:

1. **architect** — Technical design & security review
2. **backend-engineer** — API, auth logic, OAuth integration
3. **frontend-engineer** — Login UI, forms, state management
4. **qa-engineer** — Security tests, E2E, compliance

Starting architect...
```

---

### EXISTING PROJECT: Startup Quick Feature

```
User: /craft

Bot: 🔍 Detected: TypeScript + React
     ✅ Stack + patterns loaded

     "What's your work context?"

User: [Startup / Small Team]

Bot: "What do you want to do?"

User: [Build something new]

Bot: "How clear are the requirements?"
     [Crystal clear] [Mostly clear] [Rough idea]

User: [Crystal clear — let's build]

Bot: "Frontend, backend, or both?"

User: [Frontend]

Bot: "What are you building?"

User: "Dark mode toggle"

Bot:
## Quick Build: Dark Mode Toggle

frontend-engineer → qa-engineer

Starting frontend-engineer...
```

### EXISTING PROJECT: Freelance Fix & Ship

```
User: /craft

Bot: 🔍 Detected: TypeScript + Node
     ✅ Stack loaded

     "What's your work context?"

User: [Freelance / Solo]

Bot: "What do you want to do?"                     ← SHOWN because existing project
     [Build something new] [Fix] [Improve] [Think]

User: [Fix something]

Bot: "Describe the problem:"

User: "API returns 500 on invalid email format"

Bot:
## Fix: API 500 Error

backend-engineer → qa-engineer (verify)

Starting backend-engineer...
```

---

### EXISTING PROJECT: Freelance Build with Tests

```
User: /craft

Bot: 🔍 Detected: TypeScript + React
     ✅ Stack loaded

     "What's your work context?"

User: [Freelance / Solo]

Bot: "What do you want to do?"

User: [Build something new]

Bot: "What are you building?"
     [UI / Frontend] [API / Backend] [Full-stack]

User: [UI / Frontend]

Bot: "Testing?"
     [Yes, with tests] [No, ship it]

User: [Yes, with tests]

Bot: "What do you need?"

User: "Contact form with validation"

Bot:
## Task: Contact Form

frontend-engineer → qa-engineer

Starting...
```

---

## Tone by Context

| Context | Tone |
|---------|------|
| Product Team | Professional, thorough, documentation-focused |
| Startup | Energetic, fast, pragmatic |
| Freelance | Efficient, direct, no fluff |
| Learning | Patient, educational, encouraging |

---

## Agent Invocation

### How to Spawn Agents

Use the **Task tool** with the appropriate `subagent_type`:

```
Task tool:
  subagent_type: "architect"
  prompt: "Design the technical architecture for: <task>"
```

### Available Agent Types

| Agent | subagent_type | Use For |
|-------|---------------|---------|
| Product Owner | `product-owner` | User stories, specs, acceptance criteria |
| Architect | `architect` | Architecture, design, code review |
| Frontend Engineer | `frontend-engineer` | UI implementation, React, components |
| Backend Engineer | `backend-engineer` | API implementation, services, data |
| QA Engineer | `qa-engineer` | Tests, verification, quality |

### Chaining Agents

For pipelines like `Architect → Dev → QA`:

1. Spawn first agent, wait for completion
2. Pass output as context to next agent
3. Continue chain until QA passes or max retries

### Reactive Loop

When QA finds errors:
1. Parse error type (test failure, design flaw, spec gap)
2. Route to appropriate agent based on error
3. Re-run QA after fix
4. Loop until success (max 3 retries)

### Example: Startup Frontend Flow

```
# Step 1: Spawn frontend-engineer
Task(
  subagent_type: "frontend-engineer",
  prompt: "Implement: <task>\n\nContext: Startup mode, fast iteration."
)

# Step 2: On completion, spawn qa-engineer
Task(
  subagent_type: "qa-engineer",
  prompt: "Verify implementation:\n<what was built>\n\nAcceptance criteria:\n<criteria>"
)

# Step 3: If QA fails, loop back to frontend-engineer with error context
Task(
  subagent_type: "frontend-engineer",
  prompt: "Fix this error:\n<error details>\n\nOriginal task: <task>"
)
```
