---
name: craft
description: "Craft something. Claude orchestrates, agents execute."
context: conversation
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion
---

# /craft — CRAFT Mode

## IMMEDIATE: Show Banner

```
╭──────────────────────────────────────────────────────────────╮
│                                                              │
│   🟣 C L E A N   C L A U D E                                 │
│                                                              │
│   ══════════════════════════════════════════════════════     │
│   CRAFT MODE                                                 │
│   ══════════════════════════════════════════════════════     │
│                                                              │
╰──────────────────────────────────────────────────────────────╯
```

---

# RULES — READ BEFORE ANYTHING

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚫 FORBIDDEN IN /craft:                                                ║
║                                                                           ║
║   ❌ Bash for file exploration (use Read, Glob, Grep ONLY)              ║
║   ❌ Explore agent (NEVER spawn Explore — Claude explores directly)      ║
║   ❌ Skipping steps or reordering the flow                              ║
║   ❌ Analyzing code before asking the user what they want               ║
║   ❌ Making assumptions about the feature without asking                ║
║                                                                           ║
║   ✅ ONLY USE: Read, Glob, Grep, Write, Task, AskUserQuestion           ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

# FLOW OVERVIEW

```
Step 1: DETECT       Claude: Read + Glob → context.json
Step 2: SCOPE        If monorepo → ask user
Step 3: CHOOSE       "What do you want to craft?" + describe it
Step 4: QA CONFIG    "E2E tests?" → yes/no
Step 5: ROUTE        PO → Architect → Dev + QA
Step 6: VERIFY       Tests → fix loop → green
Step 7: CAPTURE      Architecture reference (if none existed)
```

---

# STEP 1: DETECT (Claude does this directly)

**DO NOT spawn any agent. DO NOT use Bash. Claude does this with Read/Glob/Grep only.**

```
1. Read("package.json")
2. Glob("{lerna,nx,turbo}.json,pnpm-workspace.yaml")
3. IF monorepo: Glob("apps/*,packages/*,modules/*")
4. Grep("clean-claude: architecture-reference", "**/*.md")
5. Write(".clean-claude/context.json")
```

**context.json:**
```json
{
  "project": {
    "type": "monorepo | frontend | backend | fullstack",
    "monorepo": { "detected": true, "workspaces": [...] },
    "scope": null,
    "language": "typescript"
  },
  "architectureRef": null
}
```

**Show:**
```
🟢 Step 1 ─ Detect                              ✓ Complete
   Project: [TYPE] · Language: [LANG] · Monorepo: [yes/no]
```

---

# STEP 2: SCOPE (if monorepo)

**Only if `project.monorepo.detected == true`**

```
AskUserQuestion: "Which workspace?"
→ User selects
→ Update context.json with scope
→ Show: "🟢 Scope: [SELECTED]"
→ GO TO STEP 3 IMMEDIATELY
```

**DO NOT re-analyze. DO NOT read scope's package.json. Just save scope and continue.**

---

# STEP 3: CHOOSE + DESCRIBE

**Two questions in this step:**

**Question 1: What type?**
```
AskUserQuestion:
  "What do you want to craft?"
  Options:
  - New feature
  - Refactor
  - Fix bug
  - Add tests
```

**Question 2: Describe it + spec?**
```
AskUserQuestion:
  "Describe what you want. Do you have an existing spec or reference?"
  Options:
  - I have a spec (give me the path)
  - I have a legacy app to migrate (give me the path)
  - I'll describe it now
  - Let the PO write the spec from scratch
```

**Save ALL inputs in context.json for the entire chain (PO + Architect):**

```
Update context.json:
{
  "project": { ... },
  "inputs": {
    "specPath": "[path if provided]",
    "legacyPath": "[path if provided]",
    "description": "[user description if typed]"
  }
}
```

**These inputs are passed to BOTH PO AND Architect:**
- PO uses them for functional spec (features, user stories)
- Architect uses them for technical design (endpoints, data models, API contracts)

**DO NOT start exploring code on your own. Ask the user first.**

---

# STEP 4: QA CONFIG

```
AskUserQuestion:
  "Do you want QA tests?"
  Options:
  - E2E tests (Playwright)
  - Integration tests
  - Unit + Integration (Dev writes them)
  - No QA (unit tests only)
```

---

# STEP 5: ROUTE TO AGENTS

## Routing Table

| Choice | Route |
|--------|-------|
| New feature | PO → Architect → Dev + QA |
| Refactor | Architect → Dev + QA |
| Fix bug (user-facing) | PO → Architect → Dev |
| Fix bug (technical) | Architect → Dev |
| Add tests | QA only |

---

## 5a. PO (if needed)

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   PO RULES — CRITICAL                                                    ║
║                                                                           ║
║   1. ENGLISH ONLY — All specs in English                                 ║
║   2. NO TECH — Zero technical details (no API endpoints, no code,        ║
║      no enums, no DB schemas, no framework names)                        ║
║   3. FUNCTIONAL ONLY — User stories, behaviors, business rules           ║
║   4. Endpoints/API = ARCHITECT'S JOB, never PO's                        ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**IF user provided an existing spec:**
```
Task(
  subagent_type: "product-owner",
  prompt: """
    ENRICH this existing spec: [SPEC_PATH]
    Read it, then ENRICH with missing functional requirements.

    IF there is legacy code at [LEGACY_PATH]:
      → Read it to find ALL features
      → Add EVERY missing feature to the spec

    RULES:
    - Write in ENGLISH
    - PURELY FUNCTIONAL — no API endpoints, no code, no tech details
    - User stories with Given/When/Then acceptance criteria
    - Output: .clean-claude/specs/functional/spec-v[N].md
    - Ask user approval before finalizing
  """
)
```

**IF no existing spec:**
```
Task(
  subagent_type: "product-owner",
  prompt: """
    Write functional spec for: [USER_DESCRIPTION]

    RULES:
    - Write in ENGLISH
    - PURELY FUNCTIONAL — no API endpoints, no code, no tech details
    - User stories with Given/When/Then acceptance criteria
    - Output: .clean-claude/specs/functional/spec-v1.md
    - Ask user approval before finalizing
  """
)
```

**PO asks user approval. Wait for approval.**

---

## 5b. ARCHITECT

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   ARCHITECT PROMPT MUST INCLUDE:                                         ║
║                                                                           ║
║   1. ALL inputs (spec, legacy, context.json)                             ║
║   2. CRAFT PRINCIPLES reminder (hexagonal, Result<T,E>, no any/throw)   ║
║   3. Request for FULL design (not just file list)                        ║
║   4. Explicit ask for stack-skills.md BEFORE design                     ║
║                                                                           ║
║   WITHOUT THIS → Architect produces generic "Claude classic" design      ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

```
Task(
  subagent_type: "architect",
  prompt: """
    Design CRAFT implementation for: [REQUEST]

    ## YOUR INPUTS
    - Functional spec: .clean-claude/specs/functional/spec-v[N].md
    - API endpoints spec: .clean-claude/specs/functional/api-endpoints.md (if exists)
    - Legacy code: [LEGACY_PATH from context.json inputs] (if exists)
    - context.json: .clean-claude/context.json

    ## CRAFT PRINCIPLES — MANDATORY
    - Architecture: HEXAGONAL (domain → application → infrastructure)
    - Error handling: Result<T, E> — NO throw, NO try/catch for business errors
    - Types: STRICT TypeScript — NO `any`, NO `unknown` casts
    - Domain: PURE — zero framework imports in domain layer
    - Tests: BDD style, colocated *.test.ts, test domain in isolation
    - Patterns: Use your FEATURE Design section (hexagonal), NOT bootstrap

    ## YOUR TASKS (IN ORDER)
    1. Check context.json for architectureRef
       → IF exists: Read it and FOLLOW its patterns exactly
       → Confirm: "Architecture Reference: [path] (v[N]) ✅"

    2. IF legacy code exists:
       → Read it to extract API endpoints, data models, routes
       → These become the technical contract for the new app

    3. Read [SCOPE]/package.json for stack detection

    4. Write .clean-claude/stack-skills.md
       → Follow your "MANDATORY: GENERATE STACK SKILLS" section
       → CRAFT patterns for EACH library (do's, don'ts, code examples)

    5. Write .clean-claude/specs/design/design-v1.md with FULL design:
       → Architecture Decision (ADR style — why hexagonal, why these patterns)
       → CRAFT Principles Applied (checklist: no any, Result<T,E>, etc.)
       → File Structure (hexagonal: domain/ → application/ → infrastructure/)
       → Domain Types (entities, value objects, error types with Result<T,E>)
       → API Endpoints / routes (extracted from inputs, not invented)
       → Port interfaces (driving + driven)
       → Use cases (application layer)
       → Code examples for key patterns (Result handling, port usage)
       → Implementation Checklist (MANDATORY — EVERY file with Wave number)
       → Execution Plan (waves for parallelization)

    6. Ask user approval BEFORE finalizing

    ## QUALITY BAR
    "If this design is complete, Dev can implement WITHOUT asking questions."
    Every file, every type, every interface must be specified.
  """
)
```

**Architect asks user approval. Wait for approval.**

> Endpoints come from INPUTS (legacy code, spec, API docs) — Architect extracts and documents them.

---

## 5c. DEV + QA (parallel)

**Spawn in SAME message for parallel execution:**

```
Task(
  subagent_type: "frontend-engineer",  // or backend-engineer based on code responsibility
  prompt: """
    Implement Wave [N] from design: .clean-claude/specs/design/design-v1.md

    ## BEFORE YOU START
    1. Read .clean-claude/specs/design/design-v1.md
    2. Read .clean-claude/stack-skills.md — USE these patterns
    3. Find the Implementation Checklist section
    4. Identify ALL files in Wave [N]

    ## CRAFT RULES — MANDATORY
    - NO `any` types — strict TypeScript everywhere
    - NO `throw` — use Result<T, E> for all error handling
    - Domain layer = PURE (zero framework imports)
    - Every file gets a colocated *.test.ts (BDD style)
    - Follow the design EXACTLY — don't invent structure

    ## OUTPUT
    - ALL files in Wave [N] implemented + tested
    - FILES CREATED table (file path | status | test status)
    - Run tests to verify they pass
  """
)

Task(
  subagent_type: "qa-engineer",  // only if QA enabled
  prompt: """
    Write tests from spec: .clean-claude/specs/functional/spec-v[N].md

    ## BEFORE YOU START
    1. Read .clean-claude/stack-skills.md — know the testing stack
    2. Read .clean-claude/specs/functional/spec-v[N].md — ALL acceptance criteria
    3. Read .clean-claude/specs/design/design-v1.md — understand the architecture

    ## YOUR JOB
    - Cover 100% of acceptance criteria (Given/When/Then)
    - E2E or Integration tests (NOT unit tests — that's Dev's job)
    - Test from user's perspective, not implementation details

    ## OUTPUT
    - Test files created
    - All tests passing
    - Coverage report: which spec items are covered
  """
)
```

---

# STEP 6: VERIFY

```
1. Check DESIGN COVERAGE (100% of Implementation Checklist)
2. Run: npm test (or project's test command)
3. Run: npm run build (or project's build command)

IF all green → GO TO STEP 7
IF failures → ROUTE to appropriate agent
```

## Design Coverage Check

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚨 BEFORE DECLARING "COMPLETE" — VERIFY 100% COVERAGE                  ║
║                                                                           ║
║   1. Read design.md → Implementation Checklist                           ║
║   2. For EACH file in checklist:                                         ║
║      → Check file EXISTS                                                 ║
║      → Check file has TEST (*.test.ts)                                   ║
║   3. Calculate: created / total = X%                                     ║
║                                                                           ║
║   IF < 100%:                                                              ║
║      → Show: "⚠️ Implementation Incomplete: X/Y files (Z%)"             ║
║      → Spawn dev agents for missing files                                ║
║      → Loop until 100%                                                   ║
║                                                                           ║
║   ONLY AT 100% → Proceed to test verification                            ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

## Fix Loop Routing

| Error Type | Route To |
|------------|----------|
| Test failure in src/ | Dev (frontend or backend) |
| Test failure in e2e/ | QA |
| Type error | Architect (design issue) |
| Spec unclear | PO |

**Loop until all green.**

---

# STEP 7: ARCHITECTURE CAPTURE (if no reference existed)

**Only if `architectureRef` was null at start:**

```
AskUserQuestion:
  "Implementation complete. Capture as architecture reference?"
  Options:
  - Yes, capture patterns
  - No, skip
```

**If YES → Architect captures patterns into ARCHITECTURE.md**

---

# REACTIVE NOTIFICATIONS

| From | To | When |
|------|-----|------|
| QA | Dev | "🔴 Test failed: [file:line]" |
| Dev | QA | "✅ Fixed, please re-test" |
| Dev | Architect | "❓ Design unclear: [question]" |
| Architect | Dev | "📐 Design updated: [change]" |
| Any | PO | "❓ Spec unclear: [question]" |

**You wrote it? You fix it.**

---

# OWNERSHIP

| Location | Owner |
|----------|-------|
| src/**/*.ts | Dev |
| src/**/*.test.ts | Dev |
| e2e/** | QA |
| .clean-claude/specs/functional/ | PO |
| .clean-claude/specs/design/ | Architect |
| .clean-claude/stack-skills.md | Architect |

---

# PARALLEL EXECUTION

**Independent tasks = spawn in SAME message**

```
// Good: parallel (independent files)
Task(frontend-engineer, "Wave 1: types/")
Task(frontend-engineer, "Wave 1: hooks/")
Task(qa-engineer, "E2E tests")

// Bad: sequential for independent work
Task(frontend-engineer, "Wave 1: types/")
// wait...
Task(frontend-engineer, "Wave 1: hooks/")
```

---

# SUMMARY

```
/craft
  │
  ├─ Step 1: Claude detects project (Read/Glob only) → context.json
  │
  ├─ Step 2: Scope (if monorepo) → save and continue
  │
  ├─ Step 3: Choose + Describe (spec? legacy? from scratch?)
  │
  ├─ Step 4: QA Config
  │
  ├─ Step 5a: PO enriches/writes spec (ENGLISH, no tech) → User approves
  │
  ├─ Step 5b: Architect: skills + design + endpoints → User approves
  │
  ├─ Step 5c: Dev + QA implement (parallel)
  │
  ├─ Step 6: Coverage 100% + Tests green + Build OK → Fix loop
  │
  └─ Step 7: Capture as arch ref (if none existed)
```

**No learning-agent. No Explore agent. Claude orchestrates. Agents execute.**
