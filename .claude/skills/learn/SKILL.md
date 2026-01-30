---
name: learn
description: "Auto-learns project patterns by default. Adapts agents to YOUR conventions. On violations, triggers architect reactively to propose refactoring. Fully integrated in reactive loop."
context: conversation
allowed-tools: Read, Bash, Glob, Grep, Write, Task, AskUserQuestion
---

# Spectre Learn — Reactive Learning

**Learn your patterns. Fix violations collaboratively.**

## Philosophy

Learning isn't about blocking. It's about **understanding** your codebase and **improving** it reactively.

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   OLD WAY (Punitive)              NEW WAY (Reactive)            │
│   ──────────────────              ──────────────────            │
│                                                                  │
│   Violation found                 Violation found               │
│        │                               │                        │
│        ▼                               ▼                        │
│   ❌ BLOCKED                      🔔 Trigger Architect          │
│   "Fix your code"                      │                        │
│                                        ▼                        │
│                                   📋 Refacto Plan               │
│                                        │                        │
│                                        ▼                        │
│                                   ✅ User Decides               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Usage

```bash
/learn                    # Full scan: stack + patterns + violations check
/learn --only <path>      # Scan only specific path
/learn --show             # Show current learnings
/learn --reset            # Clear all learnings
```

---

## How It Works

When you run `/learn`, the **Learning Agent** is spawned:

```
/learn
   │
   ▼
┌─────────────────┐
│  Learning Agent │
└────────┬────────┘
         │
         ├── 1. Detect Stack (always)
         │      → package.json, tsconfig, etc.
         │      → Write .spectre/context.json
         │
         ├── 2. Scan Patterns
         │      → Architecture, naming, imports
         │      → Error handling, testing
         │
         └── 3. Violations?
                │
         ┌──────┴──────┐
         │             │
        YES           NO
         │             │
         ▼             ▼
   ┌───────────┐  ┌───────────┐
   │  Trigger  │  │   Store   │
   │ Architect │  │ Patterns  │
   └─────┬─────┘  └───────────┘
         │
         ▼
   ┌───────────┐
   │  Propose  │
   │  Refacto  │
   │   Plan    │
   └─────┬─────┘
         │
         ▼
   ┌───────────┐
   │   User    │
   │  Decides  │
   └───────────┘
```

---

## Execution

When `/learn` is invoked:

### Step 1: Spawn Learning Agent

```
Task(
  subagent_type: "learning-agent",
  prompt: """
    Analyze this codebase:

    ## Instructions

    1. DETECT the technical stack
       - Check package.json, tsconfig.json, go.mod, etc.
       - Identify framework, testing, styling, state management
       - Write to .spectre/context.json

    2. SCAN for patterns
       - Folder structure (feature-folders? layers?)
       - Naming conventions (files, components, functions)
       - Import style (relative? absolute? aliases?)
       - Error handling (Result types? throw?)
       - Testing (colocated? separate? framework?)

    3. CHECK for violations
       - any abuse (>3 occurrences)
       - throw in business logic
       - god classes (>500 lines, >15 methods)
       - missing strict mode

    4. IF violations found:
       - Write .spectre/violations.json
       - TRIGGER architect agent with violation context
       - DO NOT BLOCK

    5. IF clean:
       - Write .spectre/learnings/patterns.json
       - Write .spectre/learnings/examples.json
       - Report success

    ## Scope

    Path to scan: <project root or --only path>
  """
)
```

### Step 2: Learning Agent Detects Stack

Always succeeds. Writes `.spectre/context.json`:

```json
{
  "stack": {
    "language": "typescript",
    "runtime": "node",
    "framework": "react",
    "testing": "vitest",
    "styling": "tailwind"
  },
  "detectedAt": "2024-01-15T10:30:00Z"
}
```

### Step 3: Learning Agent Scans Patterns

Analyzes codebase conventions.

### Step 4a: Violations Found → Offer "Craft the Existing"

Learning Agent writes `.spectre/violations.json` and asks user:

```
AskUserQuestion(
  questions: [{
    question: "💜 CRAFT violations detected. What do you want to do?",
    header: "Action",
    options: [
      { label: "💜 Craft the existing", description: "Launch CRAFT refactoring (Architect → Dev → QA)" },
      { label: "📋 See violations", description: "Show me what's wrong first" },
      { label: "⏭️ Ignore for now", description: "I'll fix this later" }
    ]
  }]
)
```

### If "Craft the existing" → Launch Refactoring Flow

```
# Set mode to craft-the-existing (NO PO)
write(".spectre/state.json", { mode: "craft-the-existing" })

# Trigger Architect directly
Task(
  subagent_type: "architect",
  prompt: """
    MODE: CRAFT THE EXISTING (pure technical refactoring)

    ## Violations Detected

    <violations from .spectre/violations.json>

    ## Your Mission

    1. Analyze each violation by severity
    2. Create refactoring plan in .spectre/specs/design/refacto-v1.md
    3. Prioritize: P1 quick wins, P2 core fixes, P3 polish

    ## Output

    Refactoring plan with:
    - What to change
    - Order of operations
    - Regression risk assessment

    Then Dev implements, QA runs regression tests.

    ## IMPORTANT
    - NO PO involved — this is pure technical refactoring
    - Functionality stays the same
    - Only code quality improves
  """
)
```

### If "See violations" → Show Details Then Ask Again

```
# Display violations summary
echo "Found violations:"
for v in violations:
    echo "  - $v.type: $v.count occurrences"

# Then ask again
AskUserQuestion(...)  # Same options
```

### Step 4b: Clean → Store Patterns

Learning Agent writes:

**`.spectre/learnings/patterns.json`**
```json
{
  "architecture": { "style": "feature-folders" },
  "naming": { "files": "kebab-case", "components": "PascalCase" },
  "imports": { "style": "absolute", "alias": "@/" },
  "errorHandling": { "style": "result-type" },
  "testing": { "location": "colocated", "framework": "vitest" }
}
```

**`.spectre/learnings/examples.json`**
```json
{
  "exemplary": [
    { "path": "src/features/auth/AuthService.ts", "reason": "Clean Result types" }
  ]
}
```

---

## Reactive Integration

Learning is part of the reactive mesh:

```
┌─────────────────────────────────────────────────────────────────┐
│                    LEARNING REACTIVE LINKS                       │
│                                                                  │
│   Learning Agent                                                 │
│        │                                                         │
│        ├── violation ────────▶ Architect ────▶ User Decision     │
│        │                                           │             │
│        │                                    ┌──────┴──────┐      │
│        │                                    ▼             ▼      │
│        │                              [ Fix Now ]   [ Later ]    │
│        │                                    │                    │
│        │                                    ▼                    │
│        │                               /heal (auto)              │
│        │                                                         │
│        └── clean ────────────▶ Store Patterns                    │
│                                     │                            │
│                                     ▼                            │
│                              Inject into Agents                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

If user chooses "Fix Now", the architect's plan triggers `/heal` automatically.

---

## Auto-Learning

Learning runs automatically on first `/craft` or `/heal`:

```
/craft "Add login form"
   │
   ├── Check: .spectre/context.json exists?
   │      │
   │      └── NO → Trigger /learn automatically
   │               │
   │               └── Learning Agent runs
   │                    │
   │                    └── Then continue with /craft
   │
   └── YES → Use existing learnings
```

---

## Storage

```
.spectre/
├── context.json              # Stack detection (always present)
├── violations.json           # Current violations (if any)
├── learnings/
│   ├── patterns.json         # Learned conventions
│   └── examples.json         # Exemplary files
└── state.json                # Workflow state
```

---

## Commands

| Command | Action |
|---------|--------|
| `/learn` | Full scan (stack + patterns + violations) |
| `/learn --only src/features/` | Scan only specific path |
| `/learn --show` | Display current learnings |
| `/learn --reset` | Clear all learnings |

---

## What Gets Learned

| Category | Examples |
|----------|----------|
| **Stack** | TypeScript, React, Vitest, Tailwind |
| **Architecture** | Feature-folders, hexagonal, layers |
| **Naming** | kebab-case files, PascalCase components |
| **Imports** | Absolute paths, @/ alias, barrel exports |
| **Error Handling** | Result types, error classes |
| **Testing** | Colocated, vitest, testing-library |

---

## Craft Violations Detected

| Violation | Severity | Detection |
|-----------|----------|-----------|
| `any` abuse | 🔴 Critical | >3 occurrences of `: any` |
| `throw` for expected | 🔴 Critical | `throw new Error` in services |
| God class | 🔴 Critical | >500 lines, >15 methods |
| Missing strict | 🟠 Warning | `"strict": false` |
| Type assertions | 🟠 Warning | `as unknown as` patterns |
| No tests | 🟠 Warning | No test files found |

---

## Example Session

```
> /learn

🔍 Spawning Learning Agent...

📦 Stack Detection
   ✅ TypeScript 5.3
   ✅ React 18.2
   ✅ Vite 5.0
   ✅ Vitest
   ✅ Tailwind CSS

🔍 Pattern Scan
   ├── Architecture: feature-folders ✅
   ├── Naming: kebab-case ✅
   ├── Imports: @/ alias ✅
   │
   └── ⚠️ Violations detected:
       • 8x 'any' in src/api/
       • 3x 'throw' in src/services/

🔔 Triggering Architect for review...

─────────────────────────────────────────

🏗️ Architect Analysis

## Quick Assessment
Main issue: API layer lacks type safety. Services throw instead of returning Results.

## Refactoring Plan

**Phase 1: Quick Wins** (low risk)
- Add strict mode to tsconfig
- Replace 'any' with 'unknown' in API responses

**Phase 2: Core Fixes** (medium risk)
- Introduce Result<T, E> type
- Refactor UserService.ts to use Results
- Refactor AuthService.ts to use Results

**Phase 3: Polish**
- Add Zod schemas for API validation
- Complete type coverage

[ 🚀 Start Phase 1 ]  [ 📋 See Details ]  [ ⏭️ Later ]
```

---

## Summary

| Aspect | Behavior |
|--------|----------|
| **Blocking** | Never — always proposes solutions |
| **Reactive** | Triggers architect on violations |
| **Automatic** | Runs on first /craft or /heal |
| **Collaborative** | User decides what to fix |
| **Persistent** | Learnings stored in .spectre/ |
