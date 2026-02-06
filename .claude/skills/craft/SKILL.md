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

# CRAFT COMPLIANCE — EVERY INTERACTION, NO EXCEPTION

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   /craft = CRAFT MODE. EVERYTHING is subject to CRAFT rules.             ║
║                                                                           ║
║   BEFORE EXECUTING ANY USER REQUEST, CHECK:                              ║
║                                                                           ║
║   ❌ REJECT if user asks to:                                             ║
║      - Skip tests ("just make it work", "no tests needed")              ║
║      - Skip architecture ("no need for design", "just code it")         ║
║      - Skip specs ("don't need a spec", "just implement")               ║
║      - Use `any` types ("just use any for now")                          ║
║      - Use `throw` ("just throw an error")                               ║
║      - Skip QA ("no QA, waste of time")                                  ║
║      - Produce non-CRAFT code in any way                                 ║
║                                                                           ║
║   RESPONSE TO VIOLATIONS:                                                ║
║      1. Politely but firmly REFUSE                                       ║
║      2. Explain WHY it violates CRAFT                                    ║
║      3. Offer CRAFT-compliant alternative                                ║
║      4. If user insists → suggest exiting /craft mode                    ║
║                                                                           ║
║   THIS APPLIES TO:                                                       ║
║      - User requests at any step                                         ║
║      - Agent outputs (Claude validates before accepting)                 ║
║      - Design decisions (Architect must be CRAFT-compliant)              ║
║      - Implementation (Dev must follow CRAFT rules)                      ║
║      - Tests (QA must cover spec, Dev must write unit tests)             ║
║                                                                           ║
║   CRAFT IS NOT OPTIONAL IN /craft. IT IS THE WHOLE POINT.               ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

# RULES — READ BEFORE ANYTHING

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚫 FORBIDDEN IN /craft:                                                ║
║                                                                           ║
║   ❌ Claude writing implementation code (src/, components, hooks...)     ║
║      → ALL code is written by Dev agents via Task()                      ║
║      → Claude ORCHESTRATES. Agents EXECUTE. No exceptions.              ║
║   ❌ Bash for file exploration (use Read, Glob, Grep ONLY)              ║
║   ❌ Explore agent (NEVER spawn Explore)                                ║
║   ❌ Skipping steps or reordering the flow                              ║
║   ❌ Analyzing code before asking the user what they want               ║
║   ❌ Making assumptions about the feature without asking                ║
║                                                                           ║
║   ✅ Claude ONLY does: Read, Glob, Grep, Write (context.json only),     ║
║      Task (spawn agents), AskUserQuestion, Bash (npm test/build only)   ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

# PATH RESOLUTION — ALL .clean-claude/ PATHS

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚨 ALL .clean-claude/ PATHS ARE RELATIVE TO {SCOPE}                   ║
║                                                                           ║
║   {SCOPE} = project.scope from context.json                              ║
║                                                                           ║
║   IF monorepo with scope set:                                            ║
║      .clean-claude/ → {SCOPE}/.clean-claude/                             ║
║                                                                           ║
║   IF standalone app (no scope):                                          ║
║      .clean-claude/ → .clean-claude/ (root)                              ║
║                                                                           ║
║   EVERY prompt to an agent MUST use RESOLVED PATHS.                      ║
║   Replace ".clean-claude/" with "{SCOPE}/.clean-claude/" everywhere.     ║
║                                                                           ║
║   ❌ Hardcoded ".clean-claude/specs/design/design-v1.md"                ║
║   ✅ Resolved "{SCOPE}/.clean-claude/specs/design/design-v1.md"         ║
║                                                                           ║
║   WRONG PATH = AGENT LOSES THE DESIGN = DISASTER                        ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

# PROGRESS DISPLAY — MANDATORY AT EVERY STEP

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   CLAUDE MUST SHOW PROGRESS AFTER EVERY STEP COMPLETION                  ║
║                                                                           ║
║   Format:                                                                ║
║   🟢 Step N ─ Name                              ✓ Complete               ║
║      Key info · Key info · Key info                                      ║
║                                                                           ║
║   Before launching an agent:                                             ║
║   ⏳ Step N ─ Name                              ⟳ In Progress            ║
║      Launching [agent-type]...                                           ║
║                                                                           ║
║   After agent completes:                                                 ║
║   🟢 Step N ─ Name                              ✓ Complete               ║
║      Deliverable: [file path]                                            ║
║      Summary: [1-2 lines from agent output]                              ║
║                                                                           ║
║   SHOW FULL PROGRESS RECAP after Steps 4 and 7:                         ║
║   ┌──────────────────────────────────────────────────────────────┐       ║
║   │ 🟢 Step 1 ─ Detect          ✓  Project: monorepo · TS      │       ║
║   │ 🟢 Step 2 ─ Scope           ✓  Scope: [SCOPE]              │       ║
║   │ 🟢 Step 3 ─ Choose          ✓  New feature                  │       ║
║   │ 🟢 Step 4 ─ QA Config       ✓  Unit + Integration           │       ║
║   │ ⬜ Step 5a ─ PO                 Pending                      │       ║
║   │ ⬜ Step 5b ─ Architect          Pending                      │       ║
║   │ ⬜ Step 5c ─ Dev + QA           Pending                      │       ║
║   │ ⬜ Step 6 ─ Verify              Pending                      │       ║
║   │ ⬜ Step 7 ─ Capture             Pending                      │       ║
║   └──────────────────────────────────────────────────────────────┘       ║
║                                                                           ║
║   WITHOUT THIS → User has no idea what's happening                       ║
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
→ GO TO STEP 3 IMMEDIATELY
```

**DO NOT re-analyze. DO NOT read scope's package.json. Just save scope and continue.**

**Show:**
```
🟢 Step 2 ─ Scope                               ✓ Complete
   Workspace: [SELECTED]
```

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
    "type": "[new feature | refactor | fix bug | add tests]",
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

**Show:**
```
🟢 Step 3 ─ Choose                              ✓ Complete
   Type: [TYPE] · Input: [spec/legacy/description/from scratch]
```

---

# STEP 4: QA CONFIG

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   Unit tests (*.test.ts colocated) = ALWAYS written by Dev.              ║
║   This is NOT a choice — it's mandatory CRAFT.                           ║
║                                                                           ║
║   QA question = "IN ADDITION to Dev's unit tests, do you want            ║
║   a QA agent to write E2E or Integration tests in parallel?"             ║
║                                                                           ║
║   IF user says Yes → QA agent runs IN PARALLEL with Dev                  ║
║   IF user says No  → Dev only (unit tests colocated)                     ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

```
AskUserQuestion:
  "Dev will write unit tests (BDD, colocated). Want QA tests on top?"
  Options:
  - Yes, E2E tests (Playwright) → QA agent in parallel
  - Yes, Integration tests → QA agent in parallel
  - No, unit tests are enough → Dev only
```

**Show after answer + FULL RECAP:**
```
🟢 Step 4 ─ QA Config                           ✓ Complete
   Testing: [SELECTED]

┌──────────────────────────────────────────────────────────────┐
│ 🟢 Step 1 ─ Detect          ✓  [TYPE] · [LANG] · [MONO]    │
│ 🟢 Step 2 ─ Scope           ✓  [SCOPE or "N/A"]            │
│ 🟢 Step 3 ─ Choose          ✓  [TYPE] · [INPUT]            │
│ 🟢 Step 4 ─ QA Config       ✓  [TESTING]                   │
│ ⬜ Step 5a ─ PO                 Pending                      │
│ ⬜ Step 5b ─ Architect          Pending                      │
│ ⬜ Step 5c ─ Dev + QA           Pending                      │
│ ⬜ Step 6 ─ Verify              Pending                      │
│ ⬜ Step 7 ─ Capture             Pending                      │
└──────────────────────────────────────────────────────────────┘

Launching Step 5...
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

**Show BEFORE launching:**
```
⏳ Step 5a ─ PO                                  ⟳ In Progress
   Launching product-owner...
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

**Show AFTER PO completes + approval:**
```
🟢 Step 5a ─ PO                                  ✓ Complete
   Spec: .clean-claude/specs/functional/spec-v[N].md
   Stories: [X] user stories · [Y] acceptance criteria
```

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

### 5b-1. BEFORE ARCHITECT: Show context + Ask design approach

**Show the user what the Architect will receive:**
```
⏳ Step 5b ─ Architect                            ⟳ Preparing...

   Inputs for Architect:
   ├── Functional spec: .clean-claude/specs/functional/spec-v[N].md
   ├── API endpoints: .clean-claude/specs/functional/api-endpoints.md [if exists]
   ├── Legacy code: [LEGACY_PATH] [if exists]
   └── Architecture ref: [PATH if found in Step 1] or "None detected"
```

**Then ask design approach:**
```
AskUserQuestion:
  "How should the Architect design this?"
  Options:
  - Follow architecture reference (only if architectureRef found in context.json)
  - Follow an existing app as reference (give me the path)
  - Design from scratch (CRAFT principles: hexagonal, Result<T,E>)
```

**IF user provides a reference app path → save it in context.json inputs:**
```
Update context.json:
{
  "inputs": {
    ...,
    "architectureRefApp": "[path to reference app]"
  }
}
```

**Add to Architect prompt if reference app provided:**
```
- Reference app to follow: [ARCHITECTURE_REF_APP_PATH]
  → Read its structure, patterns, conventions
  → Replicate the same architecture for the new feature
```

### 5b-2. Launch Architect

**Show BEFORE launching:**
```
⏳ Step 5b ─ Architect                            ⟳ In Progress
   Mode: [Follow reference / Follow app / Design from scratch]
   Launching architect...
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
    - Reference app: [ARCHITECTURE_REF_APP_PATH from context.json inputs] (if exists)
    - context.json: .clean-claude/context.json

    ## DESIGN MODE (from user choice in Step 5b-1)
    - IF "Follow architecture reference": Read architectureRef from context.json, FOLLOW exactly
    - IF "Follow an existing app": Read [ARCHITECTURE_REF_APP_PATH], replicate its patterns
    - IF "Design from scratch": Apply CRAFT principles below freely

    ## CRAFT PRINCIPLES — MANDATORY (all modes)
    - Architecture: HEXAGONAL (domain → application → infrastructure)
    - Error handling: Result<T, E> — NO throw, NO try/catch for business errors
    - Types: STRICT TypeScript — NO `any`, NO `unknown` casts
    - Domain: PURE — zero framework imports in domain layer
    - Tests: BDD style, colocated *.test.ts, test domain in isolation
    - Patterns: Use your FEATURE Design section (hexagonal), NOT bootstrap

    ## YOUR TASKS (IN ORDER)
    1. Check DESIGN MODE:
       → IF "Follow reference": Read architectureRef, FOLLOW its patterns
       → IF "Follow app": Read reference app structure, replicate patterns
       → IF "Design from scratch": Skip to step 2
       → Confirm: "Design mode: [MODE] ✅" (+ path if following reference)

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

**Show AFTER Architect completes + approval:**
```
🟢 Step 5b ─ Architect                            ✓ Complete
   Skills: .clean-claude/stack-skills.md
   Design: .clean-claude/specs/design/design-v1.md
   Architecture: Hexagonal · Result<T,E> · [X] files · [Y] waves
```

---

## 5c. DEV + QA (parallel)

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚫 BETWEEN WAVES — CLAUDE DOES NOT EXPLORE                            ║
║                                                                           ║
║   After a wave completes:                                                ║
║   1. Re-read the design ({SCOPE}/.clean-claude/specs/design/design-v1.md)║
║   2. Identify next wave's files from Implementation Checklist            ║
║   3. Spawn dev agents via Task() for next wave                           ║
║                                                                           ║
║   ❌ DO NOT implement files yourself — spawn Task() agents              ║
║   ❌ DO NOT use Bash(find ...) to explore src/                          ║
║   ❌ DO NOT use Explore agent                                           ║
║   ❌ DO NOT "reconstruct the wave plan from the codebase"               ║
║   ❌ DO NOT read existing files to "understand context"                  ║
║   The design IS the context. Trust the design. Delegate to agents.       ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   AGENT ROUTING PER FILE TYPE:                                           ║
║                                                                           ║
║   frontend-engineer:                                                     ║
║      → UI code (components, hooks, pages, styles)                        ║
║      → i18n / locale / translation files (JSON, TS)                      ║
║      → Colocated unit tests for UI code                                  ║
║                                                                           ║
║   backend-engineer:                                                      ║
║      → Domain logic, services, repositories, use cases                   ║
║      → API endpoints, data models, DTOs, mappers                         ║
║      → Colocated unit tests for backend code                             ║
║                                                                           ║
║   qa-engineer:                                                            ║
║      → Test infrastructure (MSW handlers, test fixtures, test utils)     ║
║      → E2E tests (e2e/**)                                                ║
║      → Integration tests (tests/integration/**)                          ║
║      → Test configuration (playwright.config, vitest.setup, etc.)        ║
║                                                                           ║
║   ASK: "Is this file IMPLEMENTATION or TEST INFRASTRUCTURE?"             ║
║      → Implementation / i18n → Dev                                       ║
║      → Test infra / test config / E2E / integration → QA                 ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   QA AGENT LAUNCH RULE:                                                  ║
║                                                                           ║
║   Step 4 answer = "Yes, E2E" or "Yes, Integration"                      ║
║      → QA agent IN PARALLEL with Dev (same Task() message)              ║
║                                                                           ║
║   Step 4 answer = "No, unit tests are enough"                            ║
║      → Dev only (writes unit tests colocated *.test.ts)                  ║
║      → NO QA agent                                                       ║
║                                                                           ║
║   Dev ALWAYS writes unit tests. QA is ADDITIONAL.                        ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**Spawn in SAME message for parallel execution:**

**Show BEFORE launching:**
```
⏳ Step 5c ─ Dev + QA                             ⟳ In Progress
   Launching [frontend|backend]-engineer (Wave [N])...
   Launching qa-engineer ([E2E|Integration])...    ← ONLY if Step 4 = Yes
```

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
    - Use Read/Glob/Grep for file exploration — NEVER Bash(find/ls)
    - Bash ONLY for: running tests (npm test) and build (npm run build)

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
    - Use Read/Glob/Grep for file exploration — NEVER Bash(find/ls)
    - Bash ONLY for: running tests

    ## OUTPUT
    - Test files created
    - All tests passing
    - Coverage report: which spec items are covered
  """
)
```

**AFTER each agent completes — Claude VALIDATES CRAFT compliance:**
```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   CRAFT VALIDATION ON AGENT OUTPUT:                                      ║
║                                                                           ║
║   Claude reads agent output and checks:                                  ║
║   - PO: spec in English? No tech details?                                ║
║   - Architect: hexagonal? Result<T,E>? No any? Implementation Checklist? ║
║   - Dev: every file has a test? No any? No throw? Follows design?        ║
║   - QA: covers all spec items? Tests pass?                               ║
║                                                                           ║
║   IF violation detected → Route back to agent with 🔔 NOTIFICATION      ║
║   "🔴 CRAFT violation: [what's wrong]. Fix before proceeding."           ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**Show AFTER Dev + QA complete:**
```
🟢 Step 5c ─ Dev + QA                             ✓ Complete
   Dev: [X] files created · [Y] tests passing
   QA: [Z] test files · [W] spec items covered
```

---

# STEP 6: VERIFY

**Show BEFORE starting:**
```
⏳ Step 6 ─ Verify                                ⟳ In Progress
   Checking design coverage...
```

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
║      → Show: "⚠️ Coverage: X/Y files (Z%) — INCOMPLETE"                 ║
║      → Spawn dev agents for missing files                                ║
║      → Loop until 100%                                                   ║
║                                                                           ║
║   ONLY AT 100% → Proceed to test verification                            ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**Show coverage result:**
```
   Coverage: [X]/[Y] files ([Z]%)
   Tests: [PASS/FAIL] · Build: [PASS/FAIL]
```

## Fix Loop Routing

| Error Type | Route To |
|------------|----------|
| Test failure in src/ | Dev (frontend or backend) |
| Test failure in e2e/ | QA |
| Type error | Architect (design issue) |
| Spec unclear | PO |

**Show during fix loop:**
```
   🔴 [X] failures detected → routing to [AGENT]...
   ⟳ Fix attempt [N]...
```

### HOW to route — Notification prompts

**Claude MUST use the 🔔 NOTIFICATION format when routing errors:**

```
// Test failure in src/ → Dev fixes
Task(
  subagent_type: "frontend-engineer",  // or backend-engineer
  prompt: """
    🔔 NOTIFICATION FROM QA / VERIFY STEP

    ## Test Failed
    File: [test-file:line]
    Test: "[test name]"

    ## Error
    [error message / expected vs received]

    ## Likely Source
    File: [src-file suspected]

    ## Action Required
    Fix the bug. Run tests to confirm. Report what you changed.

    ## CRAFT RULES STILL APPLY
    - NO `any`, NO `throw`, Result<T,E> only
    - Read .clean-claude/stack-skills.md for patterns
  """
)
```

```
// Type error → Architect fixes design
Task(
  subagent_type: "architect",
  prompt: """
    🔔 NOTIFICATION FROM VERIFY STEP

    ## Type Error in Implementation
    File: [file:line]
    Error: [TypeScript error message]

    ## Action Required
    Review your design. Update type definitions in design-v[N+1].md.
    Notify Dev when design is updated.
  """
)
```

```
// Spec unclear → PO clarifies
Task(
  subagent_type: "product-owner",
  prompt: """
    🔔 NOTIFICATION FROM VERIFY STEP

    ## Spec Unclear
    Context: [what's ambiguous]
    Found during: [test/implementation of what feature]

    ## Action Required
    Clarify in spec-v[N+1].md. Ask user if needed.
  """
)
```

**After agent fixes → Claude re-runs tests → Loop until all green.**

**Show AFTER all green:**
```
🟢 Step 6 ─ Verify                                ✓ Complete
   Coverage: [X]/[X] files (100%)
   Tests: ✓ All passing · Build: ✓ OK
```

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

**Show FINAL RECAP:**
```
╭──────────────────────────────────────────────────────────────╮
│                                                              │
│   🟣 CRAFT COMPLETE                                          │
│                                                              │
│   🟢 Step 1 ─ Detect          ✓  [TYPE] · [LANG]           │
│   🟢 Step 2 ─ Scope           ✓  [SCOPE]                   │
│   🟢 Step 3 ─ Choose          ✓  [TYPE]                     │
│   🟢 Step 4 ─ QA Config       ✓  [TESTING]                  │
│   🟢 Step 5a ─ PO             ✓  spec-v[N].md              │
│   🟢 Step 5b ─ Architect      ✓  design-v1.md              │
│   🟢 Step 5c ─ Dev + QA       ✓  [X] files · [Y] tests    │
│   🟢 Step 6 ─ Verify          ✓  100% · Tests ✓ · Build ✓ │
│   🟢 Step 7 ─ Capture         ✓  [captured/skipped]        │
│                                                              │
│   Deliverables:                                              │
│   ├── .clean-claude/specs/functional/spec-v[N].md           │
│   ├── .clean-claude/specs/design/design-v1.md               │
│   ├── .clean-claude/stack-skills.md                          │
│   ├── src/ ([X] files + [Y] tests)                          │
│   └── [e2e/ or tests/] ([Z] test files)                     │
│                                                              │
╰──────────────────────────────────────────────────────────────╯
```

---

# REACTIVE NOTIFICATIONS

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   CLAUDE = THE NOTIFICATION BUS                                          ║
║                                                                           ║
║   Agents can't talk to each other directly.                              ║
║   Claude reads agent output → detects issues → spawns next agent         ║
║   with 🔔 NOTIFICATION format.                                           ║
║                                                                           ║
║   Agent returns "❓ Design unclear" in output                            ║
║      → Claude spawns Architect with notification prompt                  ║
║      → Architect fixes → Claude spawns Dev with update                   ║
║                                                                           ║
║   This is NOT automatic. Claude MUST read agent output carefully         ║
║   and route notifications manually.                                      ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

| From | To | Trigger in output | Claude's action |
|------|-----|-------------------|-----------------|
| QA | Dev | "🔴 Test failed: [file:line]" | Spawn Dev with `🔔 NOTIFICATION FROM QA` |
| Dev | QA | "✅ Fixed [file]" | Spawn QA with `🔔 NOTIFICATION FROM DEV` |
| Dev | Architect | "❓ Design unclear: [question]" | Spawn Architect with `🔔 NOTIFICATION FROM DEV` |
| Architect | Dev | "📐 Design updated: [change]" | Spawn Dev with `🔔 NOTIFICATION FROM ARCHITECT` |
| Any | PO | "❓ Spec unclear: [question]" | Spawn PO with `🔔 NOTIFICATION FROM [AGENT]` |

**You wrote it? You fix it. Claude routes.**

---

# OWNERSHIP

| Location | Owner |
|----------|-------|
| src/**/*.ts | Dev |
| src/**/*.test.ts (colocated unit tests) | Dev |
| src/**/translations/ (i18n, locales) | frontend-engineer |
| e2e/** | QA |
| tests/integration/** | QA |
| test infrastructure (MSW, fixtures, utils) | QA |
| test config (playwright.config, vitest.setup) | QA |
| {SCOPE}/.clean-claude/specs/functional/ | PO |
| {SCOPE}/.clean-claude/specs/design/ | Architect |
| {SCOPE}/.clean-claude/stack-skills.md | Architect |

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

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   WAVE SIZING — MAX ~15 FILES PER AGENT                                 ║
║                                                                           ║
║   Agents have limited turns. If a wave has too many files,               ║
║   the agent runs out of turns mid-implementation.                        ║
║                                                                           ║
║   RULE: Split large waves into sub-waves of ~15 files max.              ║
║                                                                           ║
║   Wave 10 has 30 files?                                                  ║
║      → Task(frontend-engineer, "Wave 10A: files 1-15")                  ║
║      → Task(frontend-engineer, "Wave 10B: files 16-30")                 ║
║      → Both in parallel (same message)                                   ║
║                                                                           ║
║   IF an agent runs out of turns with remaining files:                    ║
║      → Spawn SAME agent type for remaining files                        ║
║      → List exactly which files are missing                              ║
║      → DO NOT switch to a different agent type                           ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

# SUMMARY

```
/craft
  │
  ├─ Step 1: Claude detects project (Read/Glob only) → context.json
  │          Show: 🟢 Detect ✓
  │
  ├─ Step 2: Scope (if monorepo) → save and continue
  │          Show: 🟢 Scope ✓
  │
  ├─ Step 3: Choose + Describe (spec? legacy? from scratch?)
  │          Show: 🟢 Choose ✓
  │
  ├─ Step 4: QA Config
  │          Show: 🟢 QA Config ✓ + FULL RECAP
  │
  ├─ Step 5a: PO enriches/writes spec → User approves
  │           Show: ⏳ before → 🟢 after with deliverables
  │
  ├─ Step 5b: Architect: skills + design → User approves
  │           Show: ⏳ before → 🟢 after with deliverables
  │
  ├─ Step 5c: Dev + QA implement (parallel)
  │           Show: ⏳ before → 🟢 after with file counts
  │
  ├─ Step 6: Coverage 100% + Tests green + Build OK → Fix loop
  │          Show: coverage %, test/build status, fix loop progress
  │
  └─ Step 7: Capture as arch ref (if none existed)
             Show: 🟢 FINAL RECAP with all deliverables
```

**No learning-agent. No Explore agent. Claude orchestrates. Agents execute.**
