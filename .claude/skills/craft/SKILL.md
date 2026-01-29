---
name: craft
description: "Craft something new. Smart adaptive flow. ALL agents ALWAYS intervene: PO → Architect → Dev+QA. No shortcuts, no unnecessary questions."
context: conversation
allowed-tools: Read, Bash, Task, AskUserQuestion, Glob, Grep, WebFetch, Write
---

# Spectre Craft — Smart Adaptive Flow

**Two rules:**
1. Ask only what's needed
2. ALL agents ALWAYS run

---

## The Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   /craft                                                         │
│       │                                                          │
│       ▼                                                          │
│   ┌─────────────────────────────────────┐                       │
│   │  AUTO-DETECT                        │                       │
│   │  - Project exists? Stack?           │                       │
│   │  - Patterns? (.spectre/learnings)   │                       │
│   └─────────────────┬───────────────────┘                       │
│                     │                                            │
│            ┌────────┴────────┐                                  │
│            │                 │                                  │
│         PROJECT           EMPTY                                  │
│            │                 │                                  │
│            │                 ▼                                  │
│            │        ┌───────────────┐                           │
│            │        │ "What stack?" │                           │
│            │        └───────┬───────┘                           │
│            │                │                                   │
│            └────────┬───────┘                                   │
│                     │                                            │
│                     ▼                                            │
│         ┌───────────────────────┐                               │
│         │ "What do you want?"   │                               │
│         └───────────┬───────────┘                               │
│                     │                                            │
│                     ▼                                            │
│   ══════════════════════════════════════════════════════════    │
│   │  MANDATORY CHAIN (NO EXCEPTIONS)                        │   │
│   ══════════════════════════════════════════════════════════    │
│                     │                                            │
│                     ▼                                            │
│              ┌──────────┐                                       │
│              │    PO    │ → .spectre/spec.md                    │
│              └────┬─────┘                                       │
│                   │                                              │
│                   ▼                                              │
│              ┌──────────┐                                       │
│              │ Architect│ → .spectre/design.md                  │
│              └────┬─────┘                                       │
│                   │                                              │
│                   ▼                                              │
│              ┌──────────────────┐                               │
│              │   Dev ⇄ QA       │                               │
│              │   (parallel)     │                               │
│              └──────────────────┘                               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Auto-Detect (No Questions)

Silently detect:

```bash
# Project exists?
if [ -f "package.json" ]; then
  STACK="typescript"
  # Read package.json for framework
fi

if [ -f "go.mod" ]; then
  STACK="go"
fi

# Patterns learned?
if [ -f ".spectre/learnings/patterns.json" ]; then
  PATTERNS=$(cat .spectre/learnings/patterns.json)
fi
```

**No question if detectable.**

---

## Step 2: Ask Stack (Only If Empty Project)

```
# ONLY if no project detected
Question: "What stack?"
Options:
  1. "TypeScript + React" - Frontend
  2. "TypeScript + Node" - Backend
  3. "Full-stack TypeScript" - Both
  4. "Go" - Backend
```

**Skip if project exists.**

---

## Step 3: Ask What to Build (Always)

```
Question: "What do you want to build?"
# Free text, examples:
# - "a pokemon list with search"
# - "user authentication"
# - "fix the login bug"
# - "refactor the auth module"
```

**This is the ONLY required question.**

---

## Step 4: PO — ALWAYS RUNS

Creates or validates `.spectre/spec.md`.

```
Task(
  subagent_type: "product-owner",
  prompt: """
    USER WANTS: <user input>
    STACK: <detected or chosen>
    EXISTING PATTERNS: <from .spectre/learnings if any>

    ## Your Job
    Create a clear, actionable spec.

    ## Output: .spectre/spec.md

    ```markdown
    # Spec: [Feature Name]

    ## User Story
    As a [user], I want [what]
    so that [why].

    ## Acceptance Criteria
    - [ ] [Criterion 1 - specific, testable]
    - [ ] [Criterion 2]
    - [ ] [Criterion 3]

    ## Edge Cases
    - [Edge case 1]
    - [Edge case 2]

    ## Out of Scope
    - [What we're NOT doing]
    ```

    Keep it concise. Focus on WHAT, not HOW.
    Write to .spectre/spec.md.
  """
)
```

---

## Step 5: Architect — ALWAYS RUNS

Creates `.spectre/design.md`.

```
Task(
  subagent_type: "architect",
  prompt: """
    SPEC: Read .spectre/spec.md
    STACK: <stack>
    PATTERNS: <from .spectre/learnings if any>

    ## Your Job
    Design the technical solution. CRAFT principles mandatory.

    ## CRAFT Rules
    - Strict TypeScript (no `any`)
    - Result<T, E> for errors (no throw)
    - Domain at center (hexagonal)
    - Tests colocated

    ## Output: .spectre/design.md

    ```markdown
    # Design: [Feature Name]

    ## Architecture
    [Brief approach]

    ## Files to Create

    ```
    src/features/<name>/
    ├── domain/
    │   └── [Entity].ts
    ├── application/
    │   └── use[UseCase].ts
    ├── infrastructure/
    │   └── [Adapter].ts
    └── ui/
        ├── [Component].tsx
        └── [Component].test.tsx
    ```

    ## Implementation Notes

    ### [File path]
    - Purpose: ...
    - Exports: ...
    - Pattern: Result<T, E>

    ## Tests (for QA)
    - [ ] "[test description]"
    - [ ] "[test description]"
    ```

    Write to .spectre/design.md.
    Dev and QA will implement this EXACTLY.
  """
)
```

---

## Step 6: Dev + QA — ALWAYS RUN IN PARALLEL

```
# Ensure .spectre exists
mkdir -p .spectre

# Launch both
Task(
  subagent_type: "frontend-engineer",  # or backend based on stack
  prompt: """
    SPEC: .spectre/spec.md
    DESIGN: .spectre/design.md

    Implement EXACTLY what design.md specifies.
    - Create the exact files listed
    - Use the exact patterns specified
    - No improvisation

    CRAFT: strict TS, Result<T,E>, domain isolated.
  """
)

Task(
  subagent_type: "qa-engineer",
  prompt: """
    SPEC: .spectre/spec.md
    DESIGN: .spectre/design.md

    Write the tests specified in design.md.
    Run them as Dev completes files.
    Report failures to .spectre/failures.md.
  """
)
```

---

## Reactive Loop

```
Dev completes file
       │
       ▼
QA runs tests
       │
   ┌───┴───┐
   │       │
  PASS    FAIL
   │       │
   ▼       ▼
 Done    Dev fixes → QA re-runs
```

Max 3 retries, then escalate.

---

## Summary

| Question | When Asked |
|----------|------------|
| "What stack?" | Only if empty project |
| "What do you want?" | Always |

| Agent | Runs | Output |
|-------|------|--------|
| PO | **ALWAYS** | `.spectre/spec.md` |
| Architect | **ALWAYS** | `.spectre/design.md` |
| Dev + QA | **ALWAYS** | Implementation + Tests |

**Smart. Minimal. Complete.**

---

## Example

```
> /craft

🔍 Detected: TypeScript + React (from package.json)
📐 Patterns: Feature folders, Result types (from .spectre/learnings)

"What do you want to build?"
> a pokemon list with search

═══════════════════════════════════════════════════════════════

👤 PO → .spectre/spec.md
   ✓ User story
   ✓ 4 acceptance criteria
   ✓ Edge cases defined

🏗️ Architect → .spectre/design.md
   ✓ 6 files planned
   ✓ 4 tests specified
   ✓ CRAFT patterns applied

💻 Dev + 🧪 QA (parallel)
   ✓ Pokemon.ts
   ✓ usePokemonList.ts
   ✓ PokemonList.tsx
   🧪 Running tests...
   ✓ 4/4 passing

═══════════════════════════════════════════════════════════════

✨ Done!
```

**One question. Full chain. Craft code.**
