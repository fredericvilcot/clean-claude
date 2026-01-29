---
name: craft
description: "Craft something. Smart professional flow: spec first, then adapt. ALL agents ALWAYS run."
context: conversation
allowed-tools: Read, Bash, Task, AskUserQuestion, Glob, Grep, WebFetch, Write
---

# Spectre Craft — Professional Flow

**Spec first. Always ask. All agents run.**

---

## The Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   /craft                                                         │
│       │                                                          │
│       ▼                                                          │
│   ┌─────────────────────────────────────┐                       │
│   │  Q1: "Do you have a spec?"          │ ← FIRST QUESTION      │
│   └─────────────────┬───────────────────┘                       │
│                     │                                            │
│            ┌────────┴────────┐                                  │
│            │                 │                                  │
│           YES               NO                                   │
│            │                 │                                  │
│            ▼                 ▼                                  │
│   ┌────────────────┐  ┌────────────────┐                       │
│   │ Q2: "Where?"   │  │ Q2: "What do   │                       │
│   │ (file/Jira/URL)│  │ you want?"     │                       │
│   └───────┬────────┘  └───────┬────────┘                       │
│           │                   │                                  │
│           │                   ▼                                  │
│           │          ┌────────────────┐                         │
│           │          │ PROJECT EXISTS?│                         │
│           │          └───────┬────────┘                         │
│           │                  │                                   │
│           │         ┌────────┴────────┐                         │
│           │         │                 │                         │
│           │        YES               NO                          │
│           │         │                 │                         │
│           │         ▼                 ▼                         │
│           │   Auto-detect      ┌────────────┐                   │
│           │   stack            │ Q3: Stack? │                   │
│           │         │          └─────┬──────┘                   │
│           │         │                │                          │
│           └─────────┴────────────────┘                          │
│                          │                                       │
│                          ▼                                       │
│   ════════════════════════════════════════════════════════════  │
│   │           MANDATORY CHAIN (ALL AGENTS)                  │   │
│   ════════════════════════════════════════════════════════════  │
│                          │                                       │
│                          ▼                                       │
│                   ┌──────────┐                                  │
│                   │    PO    │ → .spectre/spec.md               │
│                   └────┬─────┘   (validates or creates)         │
│                        │                                         │
│                        ▼                                         │
│                   ┌──────────┐                                  │
│                   │ Architect│ → .spectre/design.md             │
│                   └────┬─────┘   (CRAFT tech spec)              │
│                        │                                         │
│                        ▼                                         │
│                   ┌──────────────────┐                          │
│                   │   Dev ⇄ QA       │                          │
│                   │   (parallel)     │                          │
│                   └──────────────────┘                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Do You Have a Spec?

**ALWAYS ask this first.**

```
AskUserQuestion(
  questions: [{
    question: "Do you have a spec or requirements document?",
    header: "Spec",
    options: [
      { label: "Yes, I have a spec", description: "File, Jira ticket, URL, or document" },
      { label: "No, just an idea", description: "I'll describe what I want" }
    ]
  }]
)
```

---

## Step 2a: If YES → Where Is the Spec?

```
AskUserQuestion(
  questions: [{
    question: "Where is your spec?",
    header: "Source",
    options: [
      { label: "Local file", description: "Path to .md, .yml, or .json file" },
      { label: "Jira / Linear / GitHub", description: "Ticket URL or ID" },
      { label: "Paste it", description: "I'll paste the content" }
    ]
  }]
)
```

Then:
- **Local file** → Ask for path, read file
- **Jira/Linear/GitHub** → Ask for URL/ID, fetch content
- **Paste** → Ask user to paste

---

## Step 2b: If NO → What Do You Want?

```
AskUserQuestion(
  questions: [{
    question: "What do you want to build?",
    header: "Goal",
    options: [
      { label: "New feature", description: "Build something new" },
      { label: "Fix a bug", description: "Something is broken" },
      { label: "Refactor", description: "Improve existing code" },
      { label: "Other", description: "Something else" }
    ]
  }]
)
```

Then ask for details (free text).

---

## Step 3: Stack (Only If No Project)

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
    question: "What stack are you using?",
    header: "Stack",
    options: [
      { label: "TypeScript + React", description: "Frontend application" },
      { label: "TypeScript + Node", description: "Backend API" },
      { label: "Full-stack TypeScript", description: "Frontend + Backend" },
      { label: "Go", description: "Backend service" }
    ]
  }]
)
```

---

## Step 4: PO — ALWAYS RUNS (with User Validation)

**Specs are VERSIONED. User MUST approve before Architect starts.**

```
.spectre/
└── specs/
    ├── spec-v1.md      # Original
    ├── spec-v2.md      # After PO improvements (if needed)
    └── spec-latest.md  # Approved version → goes to Architect
```

### If User Provided Spec

```
Task(
  subagent_type: "product-owner",
  prompt: """
    USER PROVIDED SPEC:
    <spec content>

    ## Your Job
    1. Create .spectre/specs/ folder
    2. Save user spec as spec-v1.md
    3. REVIEW against CRAFT checklist:
       - [ ] User story present? (As a... I want... So that...)
       - [ ] Acceptance criteria testable? (Given/When/Then)
       - [ ] Edge cases covered?
       - [ ] Error scenarios defined?
       - [ ] Business rules explicit?
       - [ ] Out of scope clear?
       - [ ] NO technical details? (that's Architect's job)

    4. If ALL checked → Approve v1, copy to spec-latest.md
    5. If ANY unchecked → Create spec-v2.md with improvements

    ## If Creating v2
    Show user what's missing and propose changes:
    - List what's missing
    - Show the improved version
    - ASK USER TO VALIDATE before proceeding

    ## Output
    - .spectre/specs/spec-v1.md (original)
    - .spectre/specs/spec-v2.md (if improvements needed)
    - .spectre/specs/spec-latest.md (approved version)

    IMPORTANT: Do NOT proceed to Architect until user approves spec-latest.md
  """
)
```

### After PO Review → User Validation

```
AskUserQuestion(
  questions: [{
    question: "PO reviewed your spec. Accept the changes?",
    header: "Spec",
    options: [
      { label: "Accept v2", description: "Use PO's improved version" },
      { label: "Keep v1", description: "Use my original spec as-is" },
      { label: "Discuss", description: "I have questions" }
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
    question: "Review the spec. Ready to proceed?",
    header: "Validate",
    options: [
      { label: "Approve", description: "Spec is good, proceed to Architect" },
      { label: "Changes needed", description: "I want to modify something" }
    ]
  }]
)

# If approved → copy to spec-latest.md → proceed to Architect
# If changes needed → iterate with user
```

---

## Step 5: Architect — ALWAYS RUNS

```
Task(
  subagent_type: "architect",
  prompt: """
    SPEC: Read .spectre/spec.md
    STACK: <stack>

    ## Your Job
    Design the CRAFT technical solution.

    ## CRAFT Rules (Mandatory)
    - Strict TypeScript (no any)
    - Result<T, E> for errors (no throw)
    - Domain at center (hexagonal)
    - Tests colocated

    ## Output: .spectre/design.md

    Format:
    ```markdown
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

## Step 6: Dev + QA — ALWAYS RUN IN PARALLEL

### Developer: Implementation + Unit Tests (BDD)

```
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
  """
)
```

### QA: E2E or Integration Tests

**QA asks user FIRST:**
```
AskUserQuestion(
  questions: [{
    question: "What type of tests should I write?",
    header: "Tests",
    options: [
      { label: "E2E (Playwright)", description: "Full browser tests covering all spec scenarios" },
      { label: "Integration", description: "API/service boundary tests" }
    ]
  }]
)
```

**Then:**
```
Task(
  subagent_type: "qa-engineer",
  prompt: """
    SPEC: .spectre/specs/spec-latest.md
    DESIGN: .spectre/design.md
    TEST TYPE: <E2E or Integration>

    ## Your Job
    - NEVER write unit tests (that's Dev's job)
    - Write <E2E/Integration> tests for ALL acceptance criteria

    ## IF E2E (Playwright)
    - Create e2e/ folder with Playwright config
    - Use Page Object Model pattern
    - Test ALL scenarios from spec:
      - happy-path.spec.ts
      - edge-cases.spec.ts
      - error-cases.spec.ts

    ## IF Integration
    - Create tests/integration/ folder
    - Test API endpoints and service boundaries

    ## Output
    - .spectre/test-coverage.md (100% spec coverage required)
    - .spectre/failures.md (if any test fails)
  """
)
```

---

## Example: With Spec

```
> /craft

"Do you have a spec?"
> Yes, I have a spec

"Where is your spec?"
> Local file

"File path?"
> docs/user-auth-spec.md

═══════════════════════════════════════════════════════════════

👤 PO: Validating spec...
   ✓ Objective clear
   ✓ 5 acceptance criteria
   ⚠️ Missing edge cases → adding
   📋 spec-v2.md created

"Accept PO's improvements?"
> Accept v2

   ✓ .spectre/specs/spec-latest.md ready

🏗️ Architect: Designing...
   ✓ Hexagonal architecture
   ✓ 8 files planned
   ✓ Result<T, E> patterns
   ✓ .spectre/design.md ready

"What type of tests?"
> E2E (Playwright)

💻 Dev: Implementing...
   ✓ Domain layer + unit tests (BDD)
   ✓ Application layer + unit tests
   ✓ UI components + unit tests

🧪 QA: E2E Tests (Playwright)...
   ✓ e2e/ folder created
   ✓ Page Objects ready
   ✓ happy-path.spec.ts (3 tests)
   ✓ edge-cases.spec.ts (2 tests)
   ✓ error-cases.spec.ts (2 tests)
   ✓ 7/7 E2E tests passing
   ✓ 100% spec coverage

✨ Done.
```

---

## Example: Without Spec

```
> /craft

"Do you have a spec?"
> No, just an idea

"What do you want to build?"
> New feature

"Describe it:"
> User authentication with email/password and OAuth

🔍 Detected: TypeScript + React + Node (monorepo)

═══════════════════════════════════════════════════════════════

👤 PO: Creating spec...
   ✓ Objective defined
   ✓ 7 acceptance criteria
   ✓ Edge cases covered
   📋 spec-v1.md created

"Review the spec. Ready to proceed?"
> Approve

   ✓ .spectre/specs/spec-latest.md ready

🏗️ Architect: Designing...
   ✓ Auth module structure
   ✓ 12 files planned
   ✓ Security patterns
   ✓ .spectre/design.md ready

"What type of tests?"
> E2E (Playwright)

💻 Dev: Implementing...
   ✓ Domain layer + unit tests
   ✓ Application layer + unit tests
   ✓ UI components + unit tests

🧪 QA: E2E Tests (Playwright)...
   ✓ e2e/ folder created
   ✗ Test failed: OAuth callback redirect

   → Routing to Dev...
   🔧 Dev: Fixing OAuth callback...

   → QA re-runs...
   ✓ 9/9 E2E tests passing
   ✓ 100% spec coverage

✨ Done.
```

---

## Summary

| Step | Question | When |
|------|----------|------|
| 1 | "Do you have a spec?" | **ALWAYS** |
| 2a | "Where is it?" | If has spec |
| 2b | "What do you want?" | If no spec |
| 3 | "What stack?" | Only if no project |
| 4 | "Accept spec changes?" | After PO review |
| 5 | "What type of tests?" | Before QA starts |

| Agent | Runs | Output |
|-------|------|--------|
| PO | **ALWAYS** | `.spectre/specs/spec-latest.md` |
| Architect | **ALWAYS** | `.spectre/design.md` |
| Dev | **ALWAYS** | Implementation + Unit tests (BDD) |
| QA | **ALWAYS** | E2E (Playwright) or Integration tests |

| Test Type | Responsibility | Location |
|-----------|----------------|----------|
| Unit (BDD) | **Developer** | Colocated `*.test.ts` |
| E2E | **QA** | `e2e/` (Playwright) |
| Integration | **QA** | `tests/integration/` |

**Professional. Smart. Complete.**
