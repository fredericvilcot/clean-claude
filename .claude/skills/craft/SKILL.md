---
name: craft
description: "Craft something. Smart professional flow: spec first, then adapt. QA optional."
context: conversation
allowed-tools: Read, Bash, Task, AskUserQuestion, Glob, Grep, WebFetch, Write
---

# Spectre Craft — Professional Flow

**Spec first. Always ask. QA optional.**

---

## What The User Sees

**Show the magic. Be explicit at every step.**

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│  🚀 SPECTRE CRAFT                                               │
│                                                                  │
│  ─────────────────────────────────────────────────────────────  │
│                                                                  │
│  📦 Detecting project...                                        │
│     → Found: package.json, tsconfig.json                        │
│     → Stack: TypeScript + React + Vite                          │
│                                                                  │
│  ─────────────────────────────────────────────────────────────  │
│                                                                  │
│  ❓ QUESTIONS                                                    │
│     → What do you want to do?                                   │
│     → Do you have a spec?                                       │
│     → Want QA tests?                                            │
│                                                                  │
│  ─────────────────────────────────────────────────────────────  │
│                                                                  │
│  📚 LEARNING                                                    │
│     📦 Detecting stack...                                       │
│        → typescript, react, zustand, zod, fp-ts, vitest        │
│     🏛️ Architect generating library skills...                   │
│        → TypeScript: utility types, type guards                 │
│        → React: hooks, composition                              │
│        → fp-ts: Option, Either, pipe                            │
│        → Zustand: stores, selectors                             │
│        → Zod: schemas, parsing                                  │
│     ✅ Stack skills ready (.spectre/stack-skills.md)           │
│                                                                  │
│  ─────────────────────────────────────────────────────────────  │
│                                                                  │
│  📋 PO — Writing functional spec...                             │
│     → Analyzing requirements...                                  │
│     → User stories defined                                       │
│     → Acceptance criteria written                               │
│     → Writing .spectre/specs/functional/spec-v1.md              │
│     ✅ Spec ready for review                                    │
│                                                                  │
│  ─────────────────────────────────────────────────────────────  │
│                                                                  │
│  🏛️ ARCHITECT — Designing implementation...                     │
│     → Reading CRAFT skills from .spectre/stack-skills.md       │
│     → Applying hexagonal architecture                           │
│     → Defining domain boundaries                                │
│     → Writing .spectre/specs/design/design-v1.md               │
│     ✅ Technical design ready                                   │
│                                                                  │
│  ─────────────────────────────────────────────────────────────  │
│                                                                  │
│  ⚡ DEV + QA — Implementing in parallel...                      │
│                                                                  │
│     DEV:                                                         │
│     → Reading design from .spectre/specs/design/design-v1.md   │
│     → Implementing domain layer...                              │
│     → Implementing application layer...                         │
│     → Writing unit tests (BDD colocated)...                     │
│     ✅ Implementation complete                                  │
│                                                                  │
│     QA:                                                          │
│     → Reading spec from .spectre/specs/functional/spec-v1.md   │
│     → Writing E2E tests in e2e/...                              │
│     → Covering all acceptance criteria...                       │
│     ✅ E2E tests complete                                       │
│                                                                  │
│  ─────────────────────────────────────────────────────────────  │
│                                                                  │
│  🔄 FIXING LOOP                                                  │
│     → Running all tests...                                       │
│     → 2 failures detected                                        │
│     → Dev fixing cart.test.ts:45...                             │
│     → Re-running tests...                                        │
│     ✅ All tests pass                                           │
│                                                                  │
│  ─────────────────────────────────────────────────────────────  │
│                                                                  │
│  ✅ CRAFT COMPLETE                                              │
│                                                                  │
│     📁 Files created:                                           │
│        .spectre/specs/functional/spec-v1.md                     │
│        .spectre/specs/design/design-v1.md                       │
│        src/domain/cart/cart.ts                                  │
│        src/domain/cart/cart.test.ts                             │
│        src/application/useAddToCart.ts                          │
│        e2e/cart.spec.ts                                         │
│                                                                  │
│     🧪 Tests: 12 passed, 0 failed                               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Each step MUST output its progress explicitly.**

---

## The Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   /craft                                                         │
│       │                                                          │
│       ▼                                                          │
│   ┌─────────────────────────────────────┐                       │
│   │  PROJECT EXISTS? (auto-detect)      │                       │
│   └─────────────────┬───────────────────┘                       │
│                     │                                            │
│            ┌────────┴────────┐                                  │
│            │                 │                                  │
│           YES               NO                                   │
│            │                 │                                  │
│            ▼                 ▼                                  │
│   ┌────────────────────┐  ┌────────────────┐                   │
│   │ Q1: "What do you   │  │ Q1: Stack?     │                   │
│   │ want to do?"       │  └───────┬────────┘                   │
│   │                    │          │                             │
│   │ • 💜 Craft the     │          ▼                             │
│   │   existing         │  ┌────────────────┐                   │
│   │ • ✨ New feature   │  │ Q2: Spec?      │                   │
│   │ • 🐛 Bug fix       │  └───────┬────────┘                   │
│   └────────┬───────────┘          │                             │
│            │                      │                             │
│            └──────────────────────┘                             │
│                       │                                          │
│                       ▼                                          │
│   ╔═══════════════════════════════════════════════════════════╗ │
│   ║              Q: "Want QA tests?" (UPFRONT)                ║ │
│   ║                                                           ║ │
│   ║   • ✅ Yes, with QA (E2E or Integration)                 ║ │
│   ║   • ⏭️ No, Dev only (unit tests)                          ║ │
│   ║                                                           ║ │
│   ║   If YES → Q: "Same repo or different?"                   ║ │
│   ╚═══════════════════════════════════════════════════════════╝ │
│                       │                                          │
│            ┌──────────┴──────────┐                              │
│            │                     │                              │
│      CRAFT THE              FULL CHAIN                          │
│      EXISTING               (WITH PO)                           │
│            │                     │                              │
│            │                     ▼                              │
│            │              ┌──────────┐                          │
│            │              │    PO    │ → spec-vN.md             │
│            │              └────┬─────┘                          │
│            │                   │                                 │
│            └─────────┬─────────┘                                │
│                      │                                           │
│                      ▼                                           │
│               ┌──────────┐                                      │
│               │ Learning │ → Stack + skills                     │
│               └────┬─────┘                                      │
│                    │                                             │
│                    ▼                                             │
│               ┌──────────┐                                      │
│               │ Architect│ → design-vN.md                       │
│               └────┬─────┘                                      │
│                    │                                             │
│                    ▼                                             │
│          ┌─────────┴─────────┐                                  │
│          │                   │                                  │
│       QA_ENABLED         QA_DISABLED                            │
│          │                   │                                  │
│          ▼                   ▼                                  │
│   ┌──────────────────┐  ┌──────────┐                           │
│   │  Dev  ║    QA    │  │   Dev    │                           │
│   │       ║ (parallel)│  │  only    │                           │
│   └───────╨──────────┘  └────┬─────┘                           │
│          │                   │                                  │
│          └─────────┬─────────┘                                  │
│                    │                                             │
│                    ▼                                             │
│              FIXING LOOP                                         │
│                    │                                             │
│                    ▼                                             │
│                  DONE                                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### "Craft the existing" — CRAFT Refactoring (NO PO)

**When to use:**
- Migration to `Result<T, E>` (remove `throw`)
- Remove all `any` types
- Hexagonal restructure (domain/application/infrastructure)
- Colocate tests
- Clean code / SOLID
- Rename / reorganize

**What changes:**
- ❌ No PO (no functional change)
- ✅ Architect (CRAFT design)
- ✅ Dev (implementation)
- ✅ QA (regression tests — ensure nothing breaks)

**Functionality stays the same. Only code quality improves.**

---

## Step 0: Detect Project

**ALWAYS check this first.**

```bash
# Auto-detect stack
if [ -f "package.json" ] || [ -f "go.mod" ] || [ -f "Cargo.toml" ]; then
  PROJECT_EXISTS=true
  STACK=$(detect_stack)
else
  PROJECT_EXISTS=false
fi
```

---

## Step 1: What Do You Want? (If Project Exists)

**If project detected → Ask intent FIRST.**

```
AskUserQuestion(
  questions: [{
    question: "🔮 Project detected ($STACK). What do you want to do?",
    header: "Intent",
    options: [
      { label: "💜 Craft the existing", description: "CRAFT refactoring — no functional change" },
      { label: "✨ New feature", description: "Add new functionality" },
      { label: "🐛 Fix a bug", description: "Something's broken" },
      { label: "♻️ Other refactor", description: "Refactoring with functional changes" }
    ]
  }]
)
```

### If "💜 Craft the existing" → SKIP PO

```
# No spec needed — pure technical refactoring
# Go directly to Architect → Dev → QA (regression)
SKIP_PO=true
```

### Otherwise → Ask for Spec

```
# Need functional spec
SKIP_PO=false
# Continue to Step 2
```

---

## Step 1b: Stack? (If No Project)

**If no project → Ask stack, then spec.**

```
AskUserQuestion(
  questions: [{
    question: "🔮 What's your stack?",
    header: "Stack",
    options: [
      { label: "⚛️ React + TypeScript", description: "Frontend app" },
      { label: "🟢 Node + TypeScript", description: "Backend API" },
      { label: "🔥 Full-stack TS", description: "React + Node monorepo" },
      { label: "🐹 Go", description: "Backend service" }
    ]
  }]
)
```

Then continue to Step 2 (Spec).

---

## Step 2: Do You Have a Spec?

**Only ask if NOT "Crafter l'existant".**

```
AskUserQuestion(
  questions: [{
    question: "📋 Do you have a spec or requirements?",
    header: "Spec",
    options: [
      { label: "✅ Yes, I have one", description: "File, Jira, Notion, or I'll paste it" },
      { label: "💡 No, just an idea", description: "Let's build the spec together" }
    ]
  }]
)
```

---

## Step 3a: If Has Spec → Where Is It?

```
AskUserQuestion(
  questions: [{
    question: "📍 Where's the spec?",
    header: "Source",
    options: [
      { label: "📁 Local file", description: "I'll give you the path" },
      { label: "🔗 URL / Ticket", description: "Jira, Linear, GitHub, Notion..." },
      { label: "📝 Paste it", description: "I'll copy-paste it here" }
    ]
  }]
)
```

Then:
- **Local file** → Ask for path, read file
- **Jira/Linear/GitHub** → Ask for URL/ID, fetch content
- **Paste** → Ask user to paste

---

## Step 3b: If No Spec → Describe It

Ask for details (free text):

```
💬 Describe what you want to build:
> [user describes the feature/fix]
```

---

## Step 3c: QA Configuration (UPFRONT)

**Ask QA preferences BEFORE launching the chain. This enables Dev + QA in parallel.**

```
AskUserQuestion(
  questions: [{
    question: "🧪 Do you want QA tests (E2E/Integration)?",
    header: "QA",
    options: [
      { label: "✅ Yes, with QA", description: "E2E or Integration tests (Recommended)" },
      { label: "⏭️ No, Dev only", description: "Unit tests only (colocated)" }
    ]
  }]
)
```

### If "Yes, with QA" → Ask Test Type + Location

```
AskUserQuestion(
  questions: [
    {
      question: "🧪 What type of tests?",
      header: "Tests",
      options: [
        { label: "🎭 E2E (Playwright)", description: "Full browser tests" },
        { label: "🔌 Integration", description: "API boundary tests" }
      ]
    },
    {
      question: "📁 Where to store tests?",
      header: "Location",
      options: [
        { label: "📦 Same repo (default path)", description: "e2e/ or tests/integration/ at root" },
        { label: "📂 Same repo (custom path)", description: "I'll specify the folder" },
        { label: "🔗 Different repo", description: "Separate test repository" }
      ]
    }
  ]
)
```

### Test Location Options

```
┌─────────────────────────────────────────────────────────────────┐
│                 TEST LOCATION OPTIONS                            │
│                                                                  │
│   Option A: Same repo, default path                              │
│   ─────────────────────────────────                              │
│   project/                                                       │
│   ├── src/              ← App code (NO tests here)              │
│   ├── e2e/              ← E2E tests (default)                   │
│   └── tests/                                                     │
│       └── integration/  ← Integration tests (default)           │
│                                                                  │
│   Option B: Same repo, custom path                               │
│   ────────────────────────────────                               │
│   User specifies: "packages/tests/e2e"                          │
│   project/                                                       │
│   ├── src/                                                       │
│   └── packages/                                                  │
│       └── tests/                                                 │
│           └── e2e/      ← Custom location                       │
│                                                                  │
│   Option C: Different repo                                       │
│   ────────────────────────                                       │
│   project/              project-tests/ (separate repo)          │
│   └── src/              └── e2e/                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### If "Same repo (custom path)" → Ask Path

```
# User provides local path
# Example: "packages/e2e" or "test/e2e"
```

### If "Different repo" → Ask for Remote URL

```
# User provides git remote URL
# Example: git@github.com:org/project-tests.git
```

### Store QA Config

```
QA_CONFIG = {
  enabled: true | false,
  type: "e2e" | "integration",
  location: "same-default" | "same-custom" | "different",
  local_path: "e2e/" | "tests/integration/" | "<custom>",
  remote_url: "<url>" | null
}

# Default paths (at project ROOT, not in src/)
# E2E: e2e/
# Integration: tests/integration/
```

**This config is used in Step 6 to launch Dev + QA in parallel (if enabled).**

---

## BRANCH A: "Craft the existing" (NO PO)

**Pure technical refactoring — functional behavior unchanged.**

```
┌─────────────────────────────────────────────────────────────────┐
│                 💜 CRAFT THE EXISTING                            │
│                                                                  │
│   ❌ PO (skipped — no functional change)                        │
│                                                                  │
│   ┌──────────────────────────────────────────────────────────┐  │
│   │ Q: "What do you want to craft?"                          │  │
│   │                                                          │  │
│   │ • 🚫 Remove all `any` types                              │  │
│   │ • 🔄 Migrate to Result<T, E>                             │  │
│   │ • 🏛️ Restructure to hexagonal                            │  │
│   │ • 🧪 Add colocated tests                                 │  │
│   │ • ✨ Full CRAFT migration                                │  │
│   │ • 📝 Other (describe)                                    │  │
│   └──────────────────────────────────────────────────────────┘  │
│                          │                                       │
│                          ▼                                       │
│   ╔══════════════════════════════════════════════════════════╗  │
│   ║              LEARNING AGENT (MANDATORY)                   ║  │
│   ║   • Detect stack → context.json                          ║  │
│   ║   • Generate CRAFT skills → stack-skills.md              ║  │
│   ╚══════════════════════════════════════════════════════════╝  │
│                          │                                       │
│                          ▼                                       │
│                   ┌──────────┐                                  │
│                   │ Architect│ → Refactoring plan               │
│                   └────┬─────┘   (uses stack skills + patterns) │
│                        │                                         │
│                        ▼                                         │
│                   ┌──────────┐                                  │
│                   │   Dev    │ → Apply changes + Unit tests     │
│                   └────┬─────┘                                  │
│                        │                                         │
│                        ▼                                         │
│                   ┌──────────┐                                  │
│                   │    QA    │ → REGRESSION TESTS               │
│                   └──────────┘   (ensure nothing broke)         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Ask Craft Target

```
AskUserQuestion(
  questions: [{
    question: "💜 What do you want to craft?",
    header: "Craft",
    options: [
      { label: "🚫 Remove `any`", description: "Strict TypeScript everywhere" },
      { label: "🔄 Result<T, E>", description: "Replace throw with Result types" },
      { label: "🏛️ Hexagonal", description: "Restructure domain/application/infra" },
      { label: "✨ Full CRAFT", description: "Everything at once — the full monty" }
    ]
  }]
)
```

### Learning Agent (Before Architect)

```
Task(
  subagent_type: "learning-agent",
  prompt: """
    MODE: CRAFT THE EXISTING (pre-refactoring scan)

    ## Your Mission
    1. DETECT stack → .spectre/context.json
    2. PREPARE stack skills → .spectre/stack-skills.json
    3. LEARN project patterns → .spectre/learnings/patterns.json
    4. Violations will be fixed by refactoring (don't block)

    ## Output
    Context and skills ready for Architect.
  """
)
```

### Architect for Refactoring

```
Task(
  subagent_type: "architect",
  prompt: """
    MODE: CRAFT THE EXISTING (pure technical refactoring)

    CRAFT TARGET: <selected option>
    STACK CONTEXT: .spectre/context.json
    STACK SKILLS: .spectre/stack-skills.json
    PROJECT PATTERNS: .spectre/learnings/patterns.json

    ## Your Job
    1. READ injected context from Learning Agent
    2. Analyze current codebase
    3. Identify all violations of CRAFT target
    4. Create refactoring plan in .spectre/specs/design/refacto-v1.md

    ## Output Format
    ```markdown
    ---
    version: "1.0.0"
    type: refactoring
    target: <craft target>
    ---

    # Refactoring Plan: <target>

    ## Current State
    - X files with `any`
    - Y functions throwing exceptions
    - Z files outside hexagonal structure

    ## Changes

    ### File: src/path/to/file.ts
    - [ ] Change: <description>
    - [ ] Before: <code snippet>
    - [ ] After: <code snippet>

    (repeat for each file)

    ## Order of Operations
    1. First: ...
    2. Then: ...
    3. Finally: ...

    ## Regression Risk
    - Low/Medium/High
    - Areas to test: ...
    ```

    ## IMPORTANT
    - NO functional changes
    - Behavior must remain identical
    - Only structure/types/patterns change
  """
)
```

### QA for Regression

**QA in refactoring mode: ensure NOTHING BROKE.**

```
┌─────────────────────────────────────────────────────────────────┐
│                 QA REGRESSION FLOW                              │
│                                                                  │
│   1. CHECK: Existing tests?                                      │
│        │                                                         │
│   ┌────┴────┐                                                   │
│   │         │                                                   │
│  YES       NO                                                    │
│   │         │                                                   │
│   ▼         ▼                                                   │
│  RUN      WRITE                                                  │
│  existing "characterization tests"                               │
│  suite    (capture current behavior)                             │
│   │         │                                                   │
│   └────┬────┘                                                   │
│        │                                                         │
│   2. AFTER REFACTORING: Run all tests                           │
│        │                                                         │
│   ┌────┴────┐                                                   │
│   │         │                                                   │
│  PASS     FAIL = REGRESSION → Dev fixes                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

```
Task(
  subagent_type: "qa-engineer",
  prompt: """
    MODE: REGRESSION TESTING (Craft the existing)

    ## Step 1: Check Existing Tests

    Find existing test files:
    - *.test.ts, *.spec.ts
    - e2e/, tests/integration/

    ## Step 2a: If Tests Exist → Run as Baseline

    Run ALL existing tests BEFORE refactoring.
    Store results as baseline.
    After refactoring: run again, compare.

    ## Step 2b: If No Tests → Write Characterization Tests

    Characterization tests capture CURRENT behavior:
    - Snapshot API responses
    - Snapshot service outputs
    - Document error handling
    - Capture edge case behaviors

    Location: tests/characterization/

    Example:
    ```typescript
    describe('UserService (Characterization)', () => {
      it('getUser returns this structure', async () => {
        const user = await service.getUser('123');
        expect(user).toMatchSnapshot();
      });
    });
    ```

    ## Step 3: After Refactoring

    Run ALL tests (existing + characterization).
    ANY failure = REGRESSION = Dev must fix.

    ## Output
    - .spectre/regression-report.md
    - List regressions → triggers fixing loop

    ## Key Rule
    Behavior must NOT change. Same input = same output.
  """
)
```

---

## BRANCH B: Full Flow (WITH PO)

**Auto-detect first. Ask only if empty.**

```bash
# Check for project
if [ -f "package.json" ]; then
  # Read and detect: React? Node? Both?
  STACK=$(detect_from_package_json)
elif [ -f "go.mod" ]; then
  STACK="go"
elif [ -f "Cargo.toml" ]; then
  STACK="rust"
else
  # No project → must ask
  ASK_STACK=true
fi
```

If `ASK_STACK`:
```
AskUserQuestion(
  questions: [{
    question: "🔮 What's your stack?",
    header: "Stack",
    options: [
      { label: "⚛️ React + TypeScript", description: "Frontend app" },
      { label: "🟢 Node + TypeScript", description: "Backend API" },
      { label: "🔥 Full-stack TS", description: "React + Node monorepo" },
      { label: "🐹 Go", description: "Backend service" }
    ]
  }]
)
```

---

## Step 4: PO — ALWAYS RUNS (with User Validation)

**VERSION IS THE KEY. NEVER modify originals.**

```
.spectre/specs/
├── functional/           # PO's domain
│   ├── spec-v1.md        # version: 1.0.0 — IMMUTABLE
│   ├── spec-v2.md        # version: 2.0.0 — PO improvements
│   └── ...               # History preserved forever
└── design/               # Architect's domain (Step 5)
    └── ...
```

### First: Check for Existing Specs

```bash
# If project already has specs, find latest version
ls .spectre/specs/functional/spec-v*.md 2>/dev/null | sort -V | tail -1
```

### If User Provided Spec (or Existing Project)

```
Task(
  subagent_type: "product-owner",
  prompt: """
    USER PROVIDED SPEC (raw input):
    <spec content — ANY format: paste, file, Jira, vague idea...>

    EXISTING SPECS (if any):
    <list of spec-vN.md files>

    ## MANDATORY STEP 1: Transform to Standard Format

    BEFORE anything else, transform user input into standard format:

    1. Create .spectre/specs/functional/ folder
    2. Find latest version N (or 0 if none)
    3. TRANSFORM user input into spec-v(N+1).md:

       ---
       version: "(N+1).0.0"
       status: draft
       author: user
       created: <today>
       parent: "spec-vN.md" | null
       feature: <slug>
       ---

       # Spec: [Title]

       > One-line summary

       ## Problem
       [Extract from user input or ask]

       ## User Story
       As a [persona], I want [goal], So that [benefit].

       ## Acceptance Criteria
       ### Happy Path
       - [ ] Given... When... Then...
       ### Edge Cases
       - [ ] Given... When... Then...
       ### Error Cases
       - [ ] Given... When... Then...

       ## Business Rules
       ## Out of Scope
       ## Changelog

    ## MANDATORY STEP 2: Review for CRAFT Compliance

    Check the TRANSFORMED spec against CRAFT checklist.
    If NOT compliant → Create spec-v(N+2).md with improvements.

    ## IMMUTABILITY RULE
    - NEVER modify any existing spec-vN.md
    - Always create NEW version file

    ## Output
    - .spectre/specs/functional/spec-vN.md (STANDARDIZED, with frontmatter)
    - User validates before Architect starts

    NO RAW USER INPUT GOES TO ARCHITECT. EVER.
  """
)
```

### After PO Review → Diff Approval (if major changes)

**If major changes needed, PO generates a diff file first.**

```
# PO generates diff file
.spectre/specs/functional/spec-v1-to-v2.diff.md

# Contains:
# - Summary of changes
# - 🔴 MISSING (what must be added)
# - 🟢 ADDED (what PO added)
# - 🟡 MODIFIED (what changed)
# - WHY each change (CRAFT reason)
# - CRAFT compliance table (v1 vs v2)
```

**Then ask user to approve:**

```
AskUserQuestion(
  questions: [{
    question: "🔮 PO improved your spec. Accept changes?",
    header: "Review",
    options: [
      { label: "💜 Accept v2", description: "Looks good, let's roll" },
      { label: "🚫 Keep v1", description: "Use my original (may cause issues)" },
      { label: "💬 Discuss", description: "I have questions" }
    ]
  }]
)
```

### If User Gave Idea (No Spec)

```
Task(
  subagent_type: "product-owner",
  prompt: """
    USER WANTS: <user's description>
    TYPE: <feature/fix/refactor>

    ## Your Job
    Create a CRAFT-compliant functional spec.

    ## IMPORTANT
    - 100% FUNCTIONAL — no technical details
    - No stack, no architecture, no patterns
    - Focus on WHAT user wants, not HOW to build it

    ## Output: .spectre/specs/spec-v1.md

    Format:
    ```markdown
    # Spec: [Title]

    **Version:** v1
    **Status:** Draft
    **Author:** PO
    **Date:** <today>

    ---

    > [One-line user benefit]

    ## Problem
    [User problem we're solving]

    ## User Story
    As a [persona],
    I want [goal],
    So that [benefit].

    ## Acceptance Criteria

    ### Happy Path
    - [ ] Given [context], when [action], then [result]

    ### Edge Cases
    - [ ] Given [edge], when [action], then [behavior]

    ### Error Cases
    - [ ] Given [error], when [action], then [handling]

    ## Business Rules
    - [Rule 1]

    ## Out of Scope
    - [What we're NOT doing]

    ## Success Metrics
    - [How we measure success]
    ```

    Then ASK USER to validate before proceeding.
  """
)
```

### User Validates Spec

```
AskUserQuestion(
  questions: [{
    question: "🔮 Spec ready. Ship it?",
    header: "Validate",
    options: [
      { label: "💜 Let's go!", description: "Proceed to Architect" },
      { label: "✏️ Needs tweaks", description: "I want to adjust something" }
    ]
  }]
)

# If approved → mark spec status: approved → proceed to Learning Agent
# If changes needed → PO creates new version (NEVER modify original)
```

---

## Step 4.5: Learning Agent — ALWAYS RUNS (Before Architect)

**Learning Agent detects stack, injects skills to Architect, checks violations.**

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   PO approved spec (or "Craft the existing" mode)               │
│        │                                                         │
│        ▼                                                         │
│   ╔══════════════════════════════════════════════════════════╗  │
│   ║              LEARNING AGENT (MANDATORY)                   ║  │
│   ║                                                           ║  │
│   ║   1. Detect stack → .spectre/context.json                 ║  │
│   ║   2. Generate CRAFT skills → .spectre/stack-skills.md     ║  │
│   ║                                                           ║  │
│   ╚═══════════════════════════════════════════════════════════╝  │
│        │                                                         │
│        ▼                                                         │
│   ARCHITECT (reads stack-skills.md before designing)            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Learning Agent — Explicit Output

**The user MUST see this progress:**

```
📚 LEARNING

📦 Detecting stack...
   → Found: package.json, tsconfig.json
   → Libraries: typescript, react, zustand, zod, fp-ts, vitest

🏛️ Architect generating library skills...
   → TypeScript: utility types, type guards
   → React: hooks, composition
   → fp-ts: Option, Either, pipe, flow
   → Zustand: stores, selectors
   → Zod: schemas, parsing
   → Vitest: describe, expect, mocking

✅ Stack skills ready
   → .spectre/context.json
   → .spectre/stack-skills.md

Architect will use for design.
```

### Learning Agent Task

```
Task(
  subagent_type: "learning-agent",
  prompt: """
    DETECT STACK AND GENERATE LIBRARY SKILLS

    ## Step 1: Detect Stack

    Read package.json dependencies.
    Extract ALL libraries (not just frameworks).

    Write .spectre/context.json:
    {
      "stack": {
        "language": "typescript",
        "libraries": ["react", "zustand", "zod", "fp-ts", "vitest", ...]
      }
    }

    OUTPUT TO USER:
    "📦 Detecting stack...
       → Libraries: <list>"

    ## Step 2: Spawn Architect for Skills

    Task(
      subagent_type: "architect",
      prompt: "Generate library documentation for: <detected libs>.
               Write API, patterns, examples for EACH library.
               Output to .spectre/stack-skills.md.
               DON'T include CRAFT patterns (you already know them).
               DON'T analyze existing code (it might be garbage)."
    )

    OUTPUT TO USER:
    "🏛️ Architect generating library skills...
       → <lib1>: <what>
       → <lib2>: <what>"

    ## Step 3: Report Complete

    OUTPUT TO USER:
    "✅ Stack skills ready
       → .spectre/stack-skills.md

       Architect will use for design."
  """
)
```

---

## Step 5: Architect — ALWAYS RUNS

**Architect creates versioned design in `.spectre/specs/design/`**

```
Task(
  subagent_type: "architect",
  prompt: """
    FUNCTIONAL SPEC: .spectre/specs/functional/spec-vN.md (latest approved)
    STACK CONTEXT: .spectre/context.json (from Learning Agent)
    STACK SKILLS: .spectre/stack-skills.json (injected by Learning Agent)
    PROJECT PATTERNS: .spectre/learnings/patterns.json (from Learning Agent)

    ## IMPORTANT: Read Injected Context First
    1. READ .spectre/context.json for detected stack
    2. READ .spectre/stack-skills.json for stack-specific patterns
    3. READ .spectre/learnings/patterns.json for project conventions

    ## Your Job
    1. Find latest approved functional spec
    2. Check for existing designs in .spectre/specs/design/
    3. Apply BOTH built-in CRAFT AND stack-specific skills
    4. Follow project-specific conventions (naming, folders, imports)
    5. Create design-v(M+1).md with frontmatter:
       ---
       version: "(M+1).0.0"
       status: draft
       author: architect
       created: <today>
       parent: "design-vM.md" | null
       based_on: "spec-vN.md"
       feature: <slug>
       ---

    ## IMMUTABILITY RULE
    - NEVER modify existing design-vM.md
    - Design flaw found? Create design-v(M+1).md
    - Spec updated? Create design-v(M+1).md with new based_on

    ## CRAFT Rules (Mandatory)
    - Strict TypeScript (no any)
    - Result<T, E> for errors (no throw)
    - Domain at center (hexagonal)
    - Tests colocated

    ## Output: .spectre/specs/design/design-vN.md

    Format:
    ```markdown
    ---
    version: "1.0.0"
    based_on: "spec-v2.md"
    ...
    ---

    # Design: [Title]

    ## Approach
    [Brief technical approach]

    ## File Structure
    ```
    src/
    └── features/
        └── <feature>/
            ├── domain/
            │   └── [files]
            ├── application/
            │   └── [files]
            ├── infrastructure/
            │   └── [files]
            └── ui/
                └── [files]
    ```

    ## Implementation

    ### [File path]
    - Purpose: ...
    - Exports: ...
    - Pattern: Result<T, E>

    ## Tests
    - [ ] "[test 1]"
    - [ ] "[test 2]"

    ## CRAFT Checklist
    - [ ] No any
    - [ ] Result<T, E> for errors
    - [ ] Domain isolated
    - [ ] Tests colocated
    ```

    Dev and QA implement this EXACTLY.
  """
)
```

---

## Step 6: Dev + QA — PARALLEL EXECUTION + FIXING LOOP

**QA config was set in Step 3c. Now execute based on that config.**

```
┌─────────────────────────────────────────────────────────────────┐
│                    STEP 6: IMPLEMENTATION                        │
│                                                                  │
│   QA_CONFIG from Step 3c                                         │
│        │                                                         │
│   ┌────┴────┐                                                   │
│   │         │                                                   │
│  ENABLED   DISABLED                                              │
│   │         │                                                   │
│   ▼         ▼                                                   │
│  ┌─────────────────────────┐  ┌─────────────────────────┐      │
│  │   DEV    ║      QA      │  │        DEV ONLY         │      │
│  │          ║   (PARALLEL) │  │                         │      │
│  │  Code +  ║   E2E or     │  │  Code + Unit tests      │      │
│  │  Unit    ║   Integration│  │  (BDD colocated)        │      │
│  │  tests   ║              │  │                         │      │
│  └────┬─────╨──────┬───────┘  └───────────┬─────────────┘      │
│       │            │                      │                     │
│       └──────┬─────┘                      │                     │
│              │                            │                     │
│              ▼                            ▼                     │
│         FIXING LOOP                   FIXING LOOP               │
│         (Dev + QA)                    (Dev only)                │
│              │                            │                     │
│              ▼                            ▼                     │
│            DONE                         DONE                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Branch A: QA Disabled → Dev Only

```
Task(
  subagent_type: "frontend-engineer",  # or backend-engineer
  prompt: """
    SPEC: .spectre/specs/functional/spec-vN.md
    DESIGN: .spectre/specs/design/design-vN.md

    ## Your Job
    Implement EXACTLY what design specifies.
    CRAFT: strict TS, Result<T,E>, domain isolated.

    ## Unit Tests (BDD)
    - Colocated *.test.ts next to source
    - Test domain logic, pure functions
    - Given-When-Then format

    ## Output
    - Implementation files
    - Unit tests (colocated)
    - .spectre/dev-status.md
  """
)

# Run unit tests
# If failures → Dev fixes (loop)
# Until all green → DONE
```

### Branch B: QA Enabled → Dev + QA in Parallel

**PARALLEL EXECUTION: Both agents work simultaneously.**

```
# PARALLEL — Launch both at the same time
Task(
  subagent_type: "frontend-engineer",
  prompt: """
    SPEC: .spectre/specs/functional/spec-vN.md
    DESIGN: .spectre/specs/design/design-vN.md

    Implement + Unit tests (BDD colocated).
  """
)

Task(
  subagent_type: "qa-engineer",
  prompt: """
    MODE: <QA_CONFIG.type>  # e2e or integration
    SPEC: .spectre/specs/functional/spec-vN.md
    REPO: <QA_CONFIG.repo>  # same or different
    REMOTE: <QA_CONFIG.remote_url>  # if different repo

    ## If Same Repo
    Write tests in e2e/ or tests/integration/

    ## If Different Repo
    1. Clone: git clone <remote> .spectre/test-repo/
    2. Branch: git checkout -b feat/<feature>
    3. Write tests in .spectre/test-repo/
    4. Commit + push to remote

    ## Coverage
    100% of acceptance criteria from spec.
  """
)
```

### Test Repository Options

```
┌─────────────────────────────────────────────────────────────────┐
│                 TEST REPOSITORY OPTIONS                          │
│                                                                  │
│   Option A: Same Repo (default)                                  │
│   ─────────────────────────────                                  │
│   project/                                                       │
│   ├── src/                                                       │
│   ├── e2e/              ← E2E tests here                        │
│   └── tests/integration/ ← Integration tests here               │
│                                                                  │
│   Option B: Different Repo                                       │
│   ────────────────────────                                       │
│   project/              project-tests/ (cloned)                  │
│   ├── src/              ├── e2e/                                │
│   └── ...               ├── integration/                        │
│                         └── playwright.config.ts                │
│                                                                  │
│   QA workflow for different repo:                                │
│   1. Clone to .spectre/test-repo/                               │
│   2. Create feature branch                                       │
│   3. Write tests                                                 │
│   4. Commit + push to test remote                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### After Parallel Execution → Fixing Loop

```
# PARALLEL EXECUTION
Task(
  subagent_type: "frontend-engineer",  # or backend
  prompt: """
    SPEC: .spectre/specs/spec-latest.md
    DESIGN: .spectre/design.md

    Implement EXACTLY what design.md specifies.
    CRAFT: strict TS, Result<T,E>, domain isolated.

    UNIT TESTS (BDD):
    - Write colocated tests (*.test.ts next to source)
    - Test domain logic, pure functions
    - Given-When-Then format

    OUTPUT:
    - Implementation files
    - .spectre/dev-status.md with list of files created
  """
)

Task(
  subagent_type: "qa-engineer",
  prompt: """
    SPEC: .spectre/specs/spec-latest.md
    DESIGN: .spectre/design.md
    TEST TYPE: <E2E or Integration>

    ## Your Job
    - NEVER write unit tests (that's Dev's job)
    - Write <E2E/Integration> tests for ALL acceptance criteria
    - Run tests and report results

    ## Output
    - .spectre/test-coverage.md (100% spec coverage required)
    - .spectre/failures.md (if ANY test fails)
  """
)
```

---

## Step 7: AUTONOMOUS FIXING LOOP (CRITICAL)

**IF THERE ARE FAILURES, FIX THEM AUTOMATICALLY. DO NOT ASK THE USER.**

```
┌─────────────────────────────────────────────────────────────────┐
│                    AUTONOMOUS FIXING LOOP                        │
│                                                                  │
│  Tests run                                                       │
│       │                                                          │
│       ▼                                                          │
│  ┌─────────────────┐                                            │
│  │ Read failures   │ ← .spectre/failures.md                     │
│  │ from QA report  │                                            │
│  └────────┬────────┘                                            │
│           │                                                      │
│      ┌────┴────┐                                                │
│      │         │                                                │
│   NO FAILURES  FAILURES FOUND                                    │
│      │         │                                                │
│      ▼         ▼                                                │
│    DONE!    ┌─────────────────┐                                 │
│             │ Classify errors │                                 │
│             └────────┬────────┘                                 │
│                      │                                           │
│         ┌────────────┴────────────┐                             │
│         │            │            │                             │
│      test_fail    type_error   design_flaw                      │
│         │            │            │                             │
│         ▼            ▼            ▼                             │
│       Dev         Architect    Architect                         │
│       fixes       fixes        redesigns                         │
│         │            │            │                             │
│         └────────────┴────────────┘                             │
│                      │                                           │
│                      ▼                                           │
│               ┌─────────────┐                                   │
│               │  QA re-runs │ ← LOOP BACK                       │
│               │   tests     │                                   │
│               └──────┬──────┘                                   │
│                      │                                           │
│              ┌───────┴───────┐                                  │
│              │               │                                  │
│           PASS            FAIL                                   │
│              │               │                                  │
│              ▼               ▼                                   │
│            DONE!     retry++ < 3?                               │
│                              │                                   │
│                      ┌───────┴───────┐                          │
│                      │               │                          │
│                     YES             NO                           │
│                      │               │                          │
│                      ▼               ▼                           │
│                 LOOP BACK      Report to user                    │
│                              (needs manual fix)                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Implementation

```python
# PSEUDO-CODE - The orchestrator does this automatically

retry_count = 0
max_retries = 3

while retry_count < max_retries:
    # Read failures from QA
    failures = read(".spectre/failures.md")

    if not failures:
        print("✅ ALL TESTS PASSING - CRAFT COMPLETE")
        break

    # Classify and route each failure
    for failure in failures:
        if failure.type == "test_failure":
            # Dev fixes
            Task(subagent_type="frontend-engineer", prompt=f"""
                FIX THIS TEST FAILURE:
                {failure.details}

                File: {failure.file}
                Error: {failure.error}

                DO NOT ask the user. Just fix it.
            """)

        elif failure.type == "type_error":
            # Architect fixes
            Task(subagent_type="architect", prompt=f"""
                FIX THIS TYPE ERROR:
                {failure.details}

                This may require updating .spectre/design.md
            """)

        elif failure.type == "design_flaw":
            # Architect redesigns
            Task(subagent_type="architect", prompt=f"""
                DESIGN FLAW DETECTED:
                {failure.details}

                Update .spectre/design.md with corrected design.
                Dev will re-implement based on new design.
            """)

    # QA re-runs all tests
    Task(subagent_type="qa-engineer", prompt="""
        RE-RUN ALL TESTS.
        Update .spectre/failures.md with any remaining failures.
    """)

    retry_count += 1

if retry_count >= max_retries:
    print("⚠️ Max retries reached. Use /heal to continue fixing.")
```

### Key Rules

1. **NEVER ask the user** during the fixing loop
2. **Dev fixes test failures** automatically
3. **Architect fixes type errors** and design flaws
4. **QA re-runs tests** after each fix attempt
5. **Loop until ALL tests pass** or max retries reached
6. **If stuck**: User runs `/heal` to continue

---
```

---

## Example: With Spec

```
> /craft

🔮 SPECTRE CRAFT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Do you have a spec or requirements?
   ▸ ✅ Yes, I have one
   ▹ 💡 No, just an idea

> Yes

📍 Where's the spec?
   ▸ 📁 Local file
   ▹ 🔗 URL / Ticket
   ▹ 📝 Paste it

> Local file → docs/user-auth-spec.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    💜 PO PHASE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👤 Product Owner analyzing...
   ✓ Objective clear
   ✓ 5 acceptance criteria found
   ⚠️ Missing edge cases → adding
   📋 spec-v2.md drafted

🔮 PO improved your spec. Accept changes?
   ▸ 💜 Accept v2
   ▹ 🚫 Keep v1
   ▹ 💬 Discuss

> Accept v2

   ✓ .spectre/specs/functional/spec-v2.md approved

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                 💜 ARCHITECT PHASE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏗️ Architect designing...
   ✓ Hexagonal architecture
   ✓ 8 files planned
   ✓ Result<T, E> patterns
   ✓ design-v1.md ready (based_on: spec-v2)

🧪 What tests should QA write?
   ▸ 🎭 E2E (Playwright)
   ▹ 🔌 Integration

> E2E

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
               💜 IMPLEMENTATION PHASE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💻 Dev implementing...
   ✓ Domain layer + unit tests (BDD)
   ✓ Application layer + unit tests
   ✓ UI components + unit tests

🧪 QA writing E2E tests...
   ✓ e2e/ folder created
   ✓ Page Objects ready
   ✓ 7 tests written
   ✓ Running...
   ✓ 7/7 passing
   ✓ 100% spec coverage

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ CRAFT COMPLETE

💜 All agents passed. All tests green.
```

---

## Example: Without Spec (Autonomous Fixing Loop)

```
> /craft

🔮 SPECTRE CRAFT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Do you have a spec or requirements?
   ▹ ✅ Yes, I have one
   ▸ 💡 No, just an idea

> No

🎯 What are we building?
   ▸ ✨ New feature
   ▹ 🐛 Bug fix
   ▹ ♻️ Refactor

> New feature

💬 Describe what you want:
> User authentication with email/password and OAuth

🔍 Auto-detected: TypeScript + React + Node (monorepo)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    💜 PO PHASE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👤 Product Owner creating spec...
   ✓ Objective defined
   ✓ 7 acceptance criteria
   ✓ Edge cases covered
   📋 spec-v1.md drafted

🔮 Spec ready. Ship it?
   ▸ 💜 Let's go!
   ▹ ✏️ Needs tweaks

> Let's go!

   ✓ .spectre/specs/functional/spec-v1.md approved

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                 💜 ARCHITECT PHASE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏗️ Architect designing...
   ✓ Auth module structure
   ✓ 12 files planned
   ✓ Security patterns
   ✓ design-v1.md ready (based_on: spec-v1)

🧪 What tests should QA write?
   ▸ 🎭 E2E (Playwright)
   ▹ 🔌 Integration

> E2E

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
               💜 IMPLEMENTATION PHASE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💻 Dev implementing...
   ✓ Domain layer + unit tests
   ✓ Application layer + unit tests
   ✓ UI components + unit tests

🧪 QA writing E2E tests...
   ✓ e2e/ folder created
   ✗ 2 tests failed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            🔄 SELF-HEALING LOOP (1/3)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Failures:
   • oauth-callback.spec.ts → redirect URL mismatch
   • login-form.spec.ts → missing error message

🔧 Dev auto-fixing...
   ✓ Fixed redirect URL in AuthService
   ✓ Added error display in LoginForm

🧪 QA re-running...
   ✗ 1 test still failing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            🔄 SELF-HEALING LOOP (2/3)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Remaining:
   • oauth-callback.spec.ts → type error in response

🏗️ Architect auto-fixing type...
   ✓ Updated OAuthResponse type

🔧 Dev re-implementing...
   ✓ Applied type fix

🧪 QA re-running...
   ✓ 9/9 E2E tests passing
   ✓ 100% spec coverage

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ CRAFT COMPLETE

💜 All agents passed. All tests green.

📁 Output:
   spec-v1.md      functional spec
   design-v2.md    design (updated after type fix)
   src/auth/       implementation
   e2e/auth/       E2E tests
```

---

## Summary

| Step | Question | When |
|------|----------|------|
| Step | Question | When |
|------|----------|------|
| 1 | "What do you want to do?" | If project exists |
| 1b | "What's your stack?" | If no project |
| 2 | "Do you have a spec?" | If not "Craft the existing" |
| 3a | "Where is it?" | If has spec |
| 3b | "Describe what you want" | If no spec |
| **3c** | **"Want QA tests?"** | **UPFRONT — before chain starts** |
| 3c+ | "Test type? Same repo?" | If QA enabled |
| 4 | "Accept spec changes?" | After PO review |

| Agent | Runs | Output |
|-------|------|--------|
| PO | If not "Craft the existing" | `.spectre/specs/functional/spec-vN.md` |
| Learning | **ALWAYS** | `.spectre/context.json`, `stack-skills.json` |
| Architect | **ALWAYS** | `.spectre/specs/design/design-vN.md` |
| Dev | **ALWAYS** | Implementation + Unit tests (BDD) |
| QA | **OPTIONAL** | E2E or Integration tests |

### QA Options

| Option | Description |
|--------|-------------|
| Skip QA | Dev only with unit tests |
| QA in same repo | Tests in `e2e/` or `tests/integration/` |
| QA in different repo | Clone, write, push to separate repo |

### Folder Structure

```
.spectre/specs/
├── functional/           # PO's versioned specs
│   ├── spec-v1.md        # version: 1.0.0 — IMMUTABLE
│   ├── spec-v2.md        # version: 2.0.0
│   └── ...
└── design/               # Architect's versioned designs
    ├── design-v1.md      # version: 1.0.0, based_on: spec-v2.md
    └── ...

# If QA in different repo:
.spectre/test-repo/       # Cloned test repository
├── e2e/
└── integration/
```

### Golden Rules

1. **VERSION IS THE KEY** — Everything is versioned
2. **NEVER MODIFY ORIGINALS** — Always create new version
3. **HISTORY IS SACRED** — Every version preserved forever
4. **FRONTMATTER REQUIRED** — version, status, parent, based_on
5. **QA IS OPTIONAL** — User decides if E2E/Integration needed

| Test Type | Responsibility | Location |
|-----------|----------------|----------|
| Unit (BDD) | **Developer** | Colocated `*.test.ts` |
| E2E | **QA** (optional) | `e2e/` or separate repo |
| Integration | **QA** (optional) | `tests/integration/` or separate repo |

**Professional. Smart. Flexible.**
