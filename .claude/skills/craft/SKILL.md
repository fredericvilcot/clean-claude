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

## Step 2a: If YES → Where Is the Spec?

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

## Step 2b: If NO → What Do You Want?

```
AskUserQuestion(
  questions: [{
    question: "🎯 What are we building?",
    header: "Goal",
    options: [
      { label: "✨ New feature", description: "Let's create something awesome" },
      { label: "🐛 Bug fix", description: "Something needs fixing" },
      { label: "♻️ Refactor", description: "Make existing code better" }
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

# If approved → mark spec status: approved → proceed to Architect
# If changes needed → PO creates new version (NEVER modify original)
```

---

## Step 5: Architect — ALWAYS RUNS

**Architect creates versioned design in `.spectre/specs/design/`**

```
Task(
  subagent_type: "architect",
  prompt: """
    FUNCTIONAL SPEC: .spectre/specs/functional/spec-vN.md (latest approved)
    STACK: <stack>

    ## Your Job
    1. Find latest approved functional spec
    2. Check for existing designs in .spectre/specs/design/
    3. Create design-v(M+1).md with frontmatter:
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

## Step 6: Dev + QA — PARALLEL + AUTONOMOUS FIXING LOOP

**THE LOOP NEVER STOPS UNTIL EVERYTHING IS GREEN.**

### Ask Test Type First

```
AskUserQuestion(
  questions: [{
    question: "🧪 What tests should QA write?",
    header: "Tests",
    options: [
      { label: "🎭 E2E (Playwright)", description: "Full browser tests — sees what users see" },
      { label: "🔌 Integration", description: "API boundaries — fast & focused" }
    ]
  }]
)
```

### Launch Dev + QA in Parallel

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
| 1 | "Do you have a spec?" | **ALWAYS** |
| 2a | "Where is it?" | If has spec |
| 2b | "What do you want?" | If no spec |
| 3 | "What stack?" | Only if no project |
| 4 | "Accept spec changes?" | After PO review |
| 5 | "What type of tests?" | Before QA starts |

| Agent | Runs | Output |
|-------|------|--------|
| PO | **ALWAYS** | `.spectre/specs/functional/spec-vN.md` |
| Architect | **ALWAYS** | `.spectre/specs/design/design-vN.md` |
| Dev | **ALWAYS** | Implementation + Unit tests (BDD) |
| QA | **ALWAYS** | E2E (Playwright) or Integration tests |

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
```

### Golden Rules

1. **VERSION IS THE KEY** — Everything is versioned
2. **NEVER MODIFY ORIGINALS** — Always create new version
3. **HISTORY IS SACRED** — Every version preserved forever
4. **FRONTMATTER REQUIRED** — version, status, parent, based_on

| Test Type | Responsibility | Location |
|-----------|----------------|----------|
| Unit (BDD) | **Developer** | Colocated `*.test.ts` |
| E2E | **QA** | `e2e/` (Playwright) |
| Integration | **QA** | `tests/integration/` |

**Professional. Smart. Complete.**
