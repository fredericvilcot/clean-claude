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

# CRAFT GUARDIAN — FILTERS EVERY USER MESSAGE

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🛡️ CRAFT GUARDIAN — RUNS ON EVERY USER INPUT, EVERY TIME              ║
║                                                                           ║
║   WHEN: Before processing ANY user message — at ANY step, at ANY        ║
║   moment, including Step 8 iteration mode.                               ║
║                                                                           ║
║   HOW: Claude reads user input → checks against CRAFT rules → ONLY     ║
║   proceeds if compliant. This is NOT a one-time check. It is a          ║
║   PERMANENT FILTER on every single user interaction.                     ║
║                                                                           ║
║   ═══════════════════════════════════════════════════════════════════    ║
║                                                                           ║
║   ❌ BLOCK IMMEDIATELY if user asks to:                                  ║
║                                                                           ║
║   STACK VIOLATIONS (mandatory: TypeScript + React + TanStack Query):     ║
║      - Start a project with Go, Rust, Vue, Angular, Svelte, plain JS    ║
║      - Migrate/refactor away from React + TS + TanStack Query            ║
║      - "Rewrite in Go/Rust/Python/Vue/Angular/Svelte..."                ║
║      - "Remove React Query" / "Use SWR instead" / "Use axios"           ║
║      - "Convert to JavaScript" / "Remove TypeScript"                     ║
║      → guard-stack.sh hook blocks agents. Claude blocks at prompt level. ║
║                                                                           ║
║   CODE QUALITY VIOLATIONS:                                               ║
║      - Migrate TypeScript → JavaScript                                   ║
║      - Remove types / use `any` / use `unknown` casts                   ║
║      - Use `throw` instead of Result<T,E>                                ║
║      - Add `// @ts-ignore` or `// @ts-expect-error`                     ║
║      - Remove error handling                                             ║
║      - "Quick and dirty" / "just make it work"                           ║
║                                                                           ║
║   PROCESS VIOLATIONS:                                                    ║
║      - Skip tests ("no tests needed", "tests later")                    ║
║      - Skip architecture ("no need for design", "just code it")         ║
║      - Skip specs ("don't need a spec", "just implement")               ║
║      - Skip QA ("waste of time")                                         ║
║      - "I'll refactor later"                                             ║
║                                                                           ║
║   ARCHITECTURE VIOLATIONS:                                               ║
║      - Flatten hexagonal → spaghetti                                     ║
║      - Put domain logic in infrastructure layer                          ║
║      - Import framework in domain layer                                  ║
║      - Remove test coverage                                              ║
║      - Copy-paste without understanding                                  ║
║                                                                           ║
║   ═══════════════════════════════════════════════════════════════════    ║
║                                                                           ║
║   RESPONSE TO VIOLATION (show to user):                                  ║
║                                                                           ║
║   🔴 CRAFT VIOLATION — [rule broken]                                     ║
║   [Why this violates CRAFT — 1-2 sentences]                              ║
║   ✅ CRAFT alternative: [what to do instead]                             ║
║   → Reformulate your request, or type "exit craft" to leave CRAFT mode. ║
║                                                                           ║
║   ═══════════════════════════════════════════════════════════════════    ║
║                                                                           ║
║   ALSO VALIDATES AGENT OUTPUTS:                                          ║
║      - PO: spec in English? No tech details?                             ║
║      - Architect: hexagonal? Result<T,E>? No any?                       ║
║      - Dev: every file has test? No any? No throw? Follows design?      ║
║      - QA: covers spec items? Tests pass?                                ║
║                                                                           ║
║   🛡️ CRAFT GUARDIAN IS ALWAYS ON. NO OFF SWITCH. NO EXCEPTIONS.         ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

# RULES — READ BEFORE ANYTHING

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚫 FORBIDDEN IN /craft — AT ALL TIMES, ALL STEPS:                     ║
║                                                                           ║
║   ❌ Claude writing implementation code (src/, components, hooks...)     ║
║      → ALL code is written by Dev agents via Task()                      ║
║      → Claude ORCHESTRATES. Agents EXECUTE. No exceptions.              ║
║                                                                           ║
║   ❌ Explore agent (NEVER spawn subagent_type: "Explore")               ║
║      → Explore is a generic agent. Craft uses SPECIALIZED agents.       ║
║      → Need to understand code? The DEV AGENT reads code, not Claude.   ║
║                                                                           ║
║   ❌ Claude investigating / diagnosing bugs                              ║
║      → Claude does NOT read 10+ files to "understand" a bug             ║
║      → Claude routes the user's words to the owning agent               ║
║      → The AGENT investigates, diagnoses, and fixes                     ║
║                                                                           ║
║   ❌ Bash for file exploration (use Read, Glob, Grep ONLY)              ║
║   ❌ Skipping steps or reordering the flow                              ║
║   ❌ Analyzing code before asking the user what they want               ║
║   ❌ Making assumptions about the feature without asking                ║
║                                                                           ║
║   ✅ Claude ONLY does: Read, Glob, Grep, Write (state/context.json),    ║
║      Task (spawn agents), AskUserQuestion, Bash (npm test/build only)   ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

# PATH RESOLUTION

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚨 TWO DIRECTORIES — DIFFERENT RULES                                  ║
║                                                                           ║
║   {SCOPE} = project.scope from context.json                              ║
║                                                                           ║
║   specs/ → COMMITTED (all documentation the team shares)                 ║
║   ├── functional/   PO specs (spec-v1.md, spec-v2.md...)                ║
║   ├── design/       Architect designs (design-v1.md, design-v2.md...)   ║
║   └── stack/        Stack skills (stack-skills.md)                       ║
║                                                                           ║
║      IF monorepo: {SCOPE}/specs/                                         ║
║      IF standalone: specs/ (root)                                        ║
║                                                                           ║
║   .clean-claude/ → GITIGNORED (operational files only)                   ║
║   ├── context.json  Project detection cache                              ║
║   └── state.json    Session state (resume)                               ║
║                                                                           ║
║      ALWAYS at root: .clean-claude/ (never inside scope)                 ║
║                                                                           ║
║   EVERY prompt to an agent MUST use RESOLVED PATHS.                      ║
║                                                                           ║
║   ❌ Hardcoded "specs/design/design-v1.md"                               ║
║   ✅ Resolved "{SCOPE}/specs/design/design-v1.md"                        ║
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
║   CLAUDE MUST SHOW DETAILED PROGRESS — NOT JUST AGENT TYPES             ║
║                                                                           ║
║   ❌ BAD (too generic):                                                  ║
║   ⏳ Launching frontend-engineer...                                      ║
║   🟢 Dev complete.                                                       ║
║                                                                           ║
║   ✅ GOOD (describes WHAT the agent does):                               ║
║   ⏳ frontend-engineer → Dashboard card component + state badge          ║
║   ⏳ backend-engineer  → VPS API service + domain types                  ║
║   ⏳ qa-engineer       → E2E: listing page + error scenarios             ║
║   🟢 frontend-engineer ✓ 6 files: DashboardCard, StateBadge, hooks      ║
║                                                                           ║
║   RULE: Every progress line MUST include the WHAT, not just WHO.         ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

## Progress Formats

**Before launching an agent — describe the task:**
```
⏳ [agent-type] → [short description of what files/features they handle]
```

**After agent completes — summarize the work:**
```
🟢 [agent-type] ✓ [count] files: [key file/component names]
```

**During fix loop — describe what's being fixed:**
```
🔴 [agent-type] → fixing: [error summary in human terms]
🟢 [agent-type] ✓ fixed: [what was wrong + what changed]
```

**During iteration mode — describe the change:**
```
⏳ [agent-type] → [user's request in short form]
🟢 [agent-type] ✓ [what was done]
```

## Live Progress — Background Agents + Polling

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🔄 REAL-TIME PROGRESS WITH BACKGROUND AGENTS                          ║
║                                                                           ║
║   When launching multiple agents in parallel (Step 5c waves):            ║
║                                                                           ║
║   1. Launch ALL agents with run_in_background: true                      ║
║   2. Each returns an output_file path immediately                        ║
║   3. Poll output files with TaskOutput(task_id, block=false)             ║
║   4. Show live progress as each agent works                              ║
║   5. Wait for all to complete with TaskOutput(task_id, block=true)       ║
║                                                                           ║
║   This lets Claude show progress WHILE agents work.                      ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**How to launch + poll:**
```
// 1. Launch in background (all in SAME message)
Task(frontend-engineer, "Wave 1: ...", run_in_background: true)  → task_id_1
Task(backend-engineer,  "Wave 1: ...", run_in_background: true)  → task_id_2
Task(qa-engineer,       "E2E tests",  run_in_background: true)  → task_id_3

// 2. Show initial state
⏳ Wave 1
   ├── frontend-engineer ⟳ Layout component + routing
   ├── backend-engineer  ⟳ Domain types + API service
   └── qa-engineer       ⟳ E2E: navigation + errors

// 3. Poll with TaskOutput(task_id, block=false) to check progress
//    Update display as agents complete:
⏳ Wave 1
   ├── frontend-engineer ⟳ Layout component + routing
   ├── backend-engineer  ✓ 4 files: VpsType, ApiPort, VpsService
   └── qa-engineer       ⟳ E2E: navigation + errors

// 4. All done:
🟢 Wave 1                                        ✓ Complete
   ├── frontend-engineer ✓ 5 files: Layout, Sidebar, AppRouter
   ├── backend-engineer  ✓ 4 files: VpsType, ApiPort, VpsService
   └── qa-engineer       ✓ 2 files: navigation.e2e, errors.e2e
```

## Wave Progress (Step 5c)

**Between waves — show cumulative progress:**
```
🟢 Wave 1  ✓  Layout + Domain types (9 files)
🟢 Wave 2  ✓  List page + API adapters (12 files)
⏳ Wave 3  ⟳  Dashboard cards + state badges
   ├── frontend-engineer ✓ DashboardCard, StateBadge
   └── backend-engineer  ⟳ VPS state mapping service
⬜ Wave 4     Detail page + actions
```

## Step Completion

**After each step:**
```
🟢 Step N ─ Name                              ✓ Complete
   Key info · Key info · Key info
```

## Full Recap (after Steps 4 and 7)

```
┌──────────────────────────────────────────────────────────────┐
│ 🟢 Step 1 ─ Detect          ✓  monorepo · TypeScript        │
│ 🟢 Step 2 ─ Scope           ✓  apps/my-app                  │
│ 🟢 Step 3 ─ Choose          ✓  New feature: VPS dashboard   │
│ 🟢 Step 4 ─ QA Config       ✓  Unit + E2E (Playwright)      │
│ ⬜ Step 5a ─ PO                 Pending                      │
│ ⬜ Step 5b ─ Architect          Pending                      │
│ ⬜ Step 5c ─ Dev + QA           Pending                      │
│ ⬜ Step 6 ─ Verify              Pending                      │
│ ⬜ Step 7 ─ Capture             Pending                      │
│ ⬜ Step 8 ─ Iterate             Pending                      │
└──────────────────────────────────────────────────────────────┘
```

---

# FLOW OVERVIEW

```
Step 1: DETECT       Claude: Read + Glob → context.json (or RESUME)
Step 2: SCOPE        If monorepo → ask user
Step 3: CHOOSE       "What do you want to craft?" + describe it
Step 4: QA CONFIG    "E2E tests?" → yes/no
Step 5: ROUTE        PO → Architect → Dev + QA
Step 6: VERIFY       Tests → fix loop → green
Step 7: CAPTURE      Architecture reference (if none existed)
Step 8: ITERATE      CRAFT session stays active — bugs/changes routed to agents
```

---

# STEP 1: DETECT or RESUME

**DO NOT spawn any agent. DO NOT use Bash. Claude does this with Read/Glob/Grep only.**

## 1a. CHECK FOR EXISTING SESSION

```
Read(".clean-claude/state.json")
```

**state.json is ALWAYS at root** (`.clean-claude/state.json`).
The scope is stored INSIDE state.json, not in the path.

**IF state.json EXISTS and has `status: "iteration"` or `status: "in_progress"`:**

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   BRANCH CHECK — Compare current git branch with saved session branch    ║
║                                                                           ║
║   Bash: git branch --show-current → CURRENT_BRANCH                      ║
║   Read state.json → state.branch                                        ║
║                                                                           ║
║   IF CURRENT_BRANCH == state.branch → Same context, show resume         ║
║   IF CURRENT_BRANCH != state.branch → Different context, warn user      ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**Show session banner (includes branch info):**
```
╭──────────────────────────────────────────────────────────────╮
│                                                              │
│   🟣 CRAFT SESSION FOUND                                     │
│                                                              │
│   Branch: [branch from state.json]                           │
│   Scope: [scope from state.json, or "root"]                  │
│   Last step: [STEP]                                          │
│   Task: [description from state]                             │
│   Status: [iteration / in_progress at step X]                │
│   Author: [author from state.json, or "unknown"]             │
│                                                              │
│   ⚠️ Current branch: [CURRENT_BRANCH]                        │
│   [if different: "Session was on a different branch!"]       │
│                                                              │
╰──────────────────────────────────────────────────────────────╯

AskUserQuestion:
  "Found an existing CRAFT session. What do you want?"
  Options:
  - Resume this session (continue where I left off)
  - Start fresh (new task, same scope)
  - Start fresh (different scope / project)
```

**IF "Resume":**
- Read context.json, design, spec from {SCOPE} stored in state
- IF `status: "iteration"` → GO DIRECTLY TO STEP 8 (iteration mode)
- IF `status: "in_progress"` → GO TO the step saved in state.json

**IF "Start fresh (same scope)":**
- Keep scope, reset state → GO TO STEP 3

**IF "Start fresh (different scope / project)":**
- Reset everything → Continue to Step 1b below

## 1b. FRESH DETECTION (no session or user chose fresh)

```
1. Read("package.json")
2. Glob("{lerna,nx,turbo}.json,pnpm-workspace.yaml")
3. IF monorepo: Glob("apps/*,packages/*,modules/*")
4. Grep("clean-claude: architecture-reference", "**/*.md")
5. STACK VALIDATION (see 1c below)
6. Write(".clean-claude/context.json") — include stackGuard: "pass" or "fail"
```

**context.json:**
```json
{
  "project": {
    "type": "monorepo | frontend | backend | fullstack",
    "monorepo": { "detected": true, "workspaces": [...] },
    "scope": null,
    "language": "typescript",
    "stackGuard": "pass"
  },
  "architectureRef": null
}
```

**state.json — ALWAYS AT ROOT: `.clean-claude/state.json`**
```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚨 WRITE state.json AT EVERY STEP COMPLETION                          ║
║                                                                           ║
║   Path: .clean-claude/state.json (ALWAYS root, never inside scope)       ║
║   This enables /craft resume across sessions.                            ║
║                                                                           ║
║   Update "currentStep" after each step.                                  ║
║   Update fields as they become available.                                ║
║   Set "status": "iteration" after Step 7.                                ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```
```json
{
  "status": "in_progress | iteration | completed",
  "currentStep": 1,
  "scope": null,
  "branch": null,
  "author": null,
  "description": null,
  "qaConfig": null,
  "specPath": null,
  "designPath": null,
  "stackSkillsPath": null
}
```

**Capturing branch and author:**
```
branch: Bash("git branch --show-current") → store in state.json
author: Bash("git config user.name") → store in state.json
```
These fields enable team collaboration — when another dev runs `/craft`,
they see WHO was working on WHICH branch and can resume or start fresh.

## 1c. STACK VALIDATION (MANDATORY — BLOCKING)

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚨 MANDATORY STACK: TypeScript + React + TanStack Query               ║
║                                                                           ║
║   Clean Claude is built EXCLUSIVELY for this frontend stack.             ║
║   This is NOT configurable. This is NOT negotiable.                      ║
║                                                                           ║
║   CHECK (from package.json + tsconfig.json):                             ║
║   ✅ TypeScript (tsconfig.json OR typescript in dependencies)            ║
║   ✅ React (react in dependencies)                                      ║
║   ✅ @tanstack/react-query in dependencies                               ║
║                                                                           ║
║   IF ALL PRESENT:                                                         ║
║      → Set stackGuard: "pass" in context.json                           ║
║      → Continue to Step 2                                                ║
║                                                                           ║
║   IF ANY MISSING (package.json exists but wrong stack):                   ║
║      → Set stackGuard: "fail" in context.json                           ║
║      → Show 🔴 STACK VIOLATION (see below)                              ║
║      → STOP. DO NOT proceed.                                             ║
║      → guard-stack.sh hook will also block all Task() calls as safety   ║
║                                                                           ║
║   IF NO package.json AT ALL:                                              ║
║      → Propose to BOOTSTRAP a new project (see below)                   ║
║      → If user accepts → scaffold → re-detect → continue flow           ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**No project detected → Smart onboarding:**

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   NO BOILERPLATE. ASK THE USER ABOUT THEIR PROJECT.                      ║
║                                                                           ║
║   1. Ask project name + description                                      ║
║   2. Ask additional libraries (beyond mandatory stack)                    ║
║   3. Bootstrap: package.json + deps + minimal config                     ║
║   4. Save inputs in context.json → flow continues to Step 3              ║
║                                                                           ║
║   ❌ DO NOT create src/ structure (that's the Architect's job)           ║
║   ❌ DO NOT use npm create vite (creates useless boilerplate)            ║
║   ✅ Create package.json, tsconfig.json, vite.config.ts ONLY            ║
║   ✅ Install deps and let the CRAFT flow design the rest                 ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

```
AskUserQuestion:
  "No project detected. Tell me about what you want to build."
  Questions:
  1. "Project name?" → (user types name)
  2. "Additional libraries? (React + TS + TanStack Query are mandatory)"
     Options (multiSelect):
     - React Router
     - Zustand (client state)
     - Tailwind CSS
     - Zod (validation)
     - None, just the mandatory stack
```

**IF user answers → Bootstrap:**
```
1. Write package.json with:
   - name: [PROJECT_NAME]
   - Mandatory deps: react, react-dom, @tanstack/react-query
   - Mandatory devDeps: typescript, vite, @vitejs/plugin-react,
     vitest, @testing-library/react, @testing-library/jest-dom,
     @testing-library/user-event, jsdom, @vitest/coverage-v8, @types/node
   - Additional deps: [user's choices from question 2]

2. Write tsconfig.json (strict mode)
3. Write vite.config.ts (with vitest config)
4. Write src/main.tsx (minimal entry point)
5. Bash: npm install

6. Save in context.json:
   {
     "project": {
       "type": "frontend",
       "language": "typescript",
       "stackGuard": "pass",
       "additionalLibs": ["react-router-dom", "zustand", ...]
     }
   }

7. CONTINUE to Step 3 (skip Step 2 — not a monorepo)
   → The user's project description feeds directly into Step 3.
```

**IF user declines:**
```
→ STOP. "Set up your project with React + TypeScript + TanStack Query, then retry /craft."
```

**Existing project with wrong/incomplete stack → Smart migration:**

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   DON'T JUST BLOCK — PROPOSE A PATH FORWARD                             ║
║                                                                           ║
║   Analyze what's there → propose the right migration:                    ║
║                                                                           ║
║   CASE 1: React + TS, missing TanStack Query only                        ║
║      → "Install @tanstack/react-query? I'll add it and continue."       ║
║      → Bash: npm install @tanstack/react-query                           ║
║      → Re-detect → continue flow normally                                ║
║                                                                           ║
║   CASE 2: React + JS (no TypeScript)                                     ║
║      → "Migrate to TypeScript? I'll install TS and design the migration"║
║      → Bash: npm install -D typescript @types/react @types/react-dom    ║
║      → Flow becomes type: "Refactor" → Architect designs TS migration   ║
║                                                                           ║
║   CASE 3: Vue / Angular / Svelte / other framework                       ║
║      → "This is a [Vue] project. Migration to React is a major effort." ║
║      → AskUserQuestion: Migrate to React? or Start fresh alongside?     ║
║      → IF migrate → type: "Refactor" → full migration flow              ║
║      → IF fresh → bootstrap new project in a subfolder                   ║
║                                                                           ║
║   CASE 4: Plain JS (no framework)                                        ║
║      → "No framework detected. Install React + TS + TanStack Query?"    ║
║      → Bash: install all mandatory deps                                  ║
║      → Re-detect → continue flow normally                                ║
║                                                                           ║
║   CASE 5: Non-JS project (Go, Rust, Python...)                           ║
║      → "This is a [Go] project. Clean Claude is for React frontends."   ║
║      → AskUserQuestion: Bootstrap a React frontend alongside?            ║
║      → IF yes → bootstrap in a subfolder (e.g. frontend/)               ║
║                                                                           ║
║   KEY RULE: Always install missing deps via Bash BEFORE spawning agents  ║
║   → guard-stack.sh checks package.json → deps present → agents pass     ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**Show:**
```
🟢 Step 1 ─ Detect                              ✓ Complete
   Project: [TYPE] · Language: [LANG] · Monorepo: [yes/no]
   Stack: TypeScript + React + TanStack Query ✅
```

---

# STEP 2: SCOPE (if monorepo)

**Only if `project.monorepo.detected == true`**

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🏢 ENTERPRISE MONOLITH MANAGEMENT                                     ║
║                                                                           ║
║   Clean Claude manages modular monoliths at scale (40+ devs).           ║
║   Step 2 is the entry point for ALL monorepo operations:                ║
║                                                                           ║
║   • Work on an EXISTING app or package                                  ║
║   • CREATE a new app (micro-frontend in apps/)                          ║
║   • CREATE a shared package (packages/)                                 ║
║                                                                           ║
║   Architecture reference applies to ALL workspaces.                     ║
║   Same patterns, same conventions, same quality — at scale.             ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

## 2a. Ask workspace operation

```
AskUserQuestion:
  "Monorepo detected. What do you want to do?"
  Options:
  - Work on existing workspace (select from list)
  - Create a new app (in apps/)
  - Create a shared package (in packages/)
```

## 2b. EXISTING workspace → select and continue

```
AskUserQuestion: "Which workspace?"
  Options: [list from context.json monorepo.workspaces]

→ User selects
→ Update context.json with scope
→ GO TO STEP 3 IMMEDIATELY
```

**DO NOT re-analyze. DO NOT read scope's package.json. Just save scope and continue.**

## 2c. CREATE NEW APP → scaffold + continue

```
AskUserQuestion:
  "Name for the new app? It will be created in apps/[name]."
  + "Additional libraries? (React + TS + TanStack Query are mandatory)"
    Options (multiSelect):
    - React Router
    - Zustand (client state)
    - Tailwind CSS
    - Zod (validation)
    - None, just the mandatory stack

→ User provides name + libs
```

**Scaffold the new app:**
```
1. Create apps/[name]/ directory
2. Write apps/[name]/package.json with:
   - name: "@[monorepo-name]/[app-name]"
   - Mandatory deps: react, react-dom, @tanstack/react-query
   - Mandatory devDeps: typescript, vite, @vitejs/plugin-react,
     vitest, @testing-library/react, @testing-library/jest-dom,
     @testing-library/user-event, jsdom, @vitest/coverage-v8
   - Additional deps from user's choices
   - Shared packages from monorepo (if any packages/* exist)

3. Write apps/[name]/tsconfig.json (strict mode, extends root if exists)
4. Write apps/[name]/vite.config.ts (with vitest config)
5. Write apps/[name]/src/main.tsx (minimal entry point)

6. Bash: npm install (or pnpm install, based on lockfile detected)

7. Update context.json:
   {
     "project": {
       "scope": "apps/[name]",
       "monorepo": { "workspaces": [..., "apps/[name]"] },
       "stackGuard": "pass"
     }
   }

8. CONTINUE to Step 3
   → The user's app description feeds directly into Step 3.
```

## 2d. CREATE SHARED PACKAGE → scaffold + continue

```
AskUserQuestion:
  "What kind of shared package?"
  Options:
  - UI library (shared components: buttons, modals, forms)
  - Domain library (shared types, business rules, Result<T,E>)
  - Config library (shared tsconfig, eslint, tailwind presets)
  - Utils library (shared helpers, formatters, validators)

+ "Name for the package? It will be created in packages/[name]."
```

**Scaffold the shared package:**
```
1. Create packages/[name]/ directory
2. Write packages/[name]/package.json with:
   - name: "@[monorepo-name]/[name]"
   - main: "src/index.ts"
   - types: "src/index.ts"
   - devDeps: typescript, vitest
   - Additional deps based on type:
     → UI: react, react-dom (peerDeps)
     → Domain: (no extra deps — pure)
     → Config: relevant config packages
     → Utils: (no extra deps — pure)

3. Write packages/[name]/tsconfig.json (strict, extends root)
4. Write packages/[name]/src/index.ts (empty barrel export)
5. Write packages/[name]/src/index.test.ts (smoke test)

6. Bash: npm install

7. Update context.json with scope: "packages/[name]"

8. CONTINUE to Step 3
   → The user describes what the package should contain.
```

**Show:**
```
🟢 Step 2 ─ Scope                               ✓ Complete
   Workspace: [SELECTED or CREATED]
   Operation: [existing / new app / new package]
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
  - I have a reference URL (app/site to analyze)
  - I have a Figma design
  - I'll describe it now
  - Let the PO write the spec from scratch
```

**IF "reference URL" chosen:**
```
AskUserQuestion:
  "What URL should the PO analyze?"
  [free text — user types URL]

AskUserQuestion:
  "What aspect should the PO focus on?"
  Options:
  - Reproduce this page/feature
  - Improve on this (note what to change)
  - Use as inspiration (different design, same concept)
```

**IF "Figma design" chosen:**
```
AskUserQuestion:
  "Paste the Figma file URL or frame link:"
  [free text — user types Figma URL]
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
    "description": "[user description if typed]",
    "referenceUrl": "[URL if provided via 'reference URL' option]",
    "referenceIntent": "[reproduce | improve | inspiration]",
    "figmaUrl": "[Figma URL if provided via 'Figma design' option]"
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

# STEP 3b: CRAFT GATE

**The CRAFT GUARDIAN (top of this file) applies here explicitly.**
The user just described their task — this is the most critical checkpoint.

```
IF user's description violates CRAFT:
   → Show 🔴 CRAFT VIOLATION (see CRAFT GUARDIAN format)
   → DO NOT proceed to Step 4. BLOCK HERE.
   → Wait for user to reformulate or exit.
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
    - Output: specs/functional/spec-v[N].md
    - Ask user approval before finalizing
  """
)
```

**IF no existing spec (text description only — no reference URL/Figma):**
```
Task(
  subagent_type: "product-owner",
  prompt: """
    Write functional spec for: [USER_DESCRIPTION]

    RULES:
    - Write in ENGLISH
    - PURELY FUNCTIONAL — no API endpoints, no code, no tech details
    - User stories with Given/When/Then acceptance criteria
    - Output: specs/functional/spec-v1.md
    - Ask user approval before finalizing
  """
)
```

**IF referenceUrl provided in context.json inputs:**
```
Task(
  subagent_type: "product-owner",
  prompt: """
    Write functional spec for: [USER_DESCRIPTION]

    ## Visual Reference
    Reference URL: [REFERENCE_URL]
    Intent: [reproduce | improve | inspiration]

    IMPORTANT: Browse this URL first using Playwright tools.
    Capture an accessibility snapshot to understand the page structure.
    Use what you see to write a precise, detailed spec.

    If the page requires authentication:
    → Report "🔒 AUTH NEEDED: [URL]" and STOP
    → Wait for further instructions.

    RULES:
    - Write in ENGLISH
    - PURELY FUNCTIONAL — translate what you SEE into user stories
    - DO NOT mention technical details from page analysis (DOM, CSS, etc.)
    - User stories with Given/When/Then acceptance criteria
    - Output: specs/functional/spec-v1.md
    - Ask user approval before finalizing
  """
)
```

**IF figmaUrl provided in context.json inputs:**
```
Task(
  subagent_type: "product-owner",
  prompt: """
    Write functional spec for: [USER_DESCRIPTION]

    ## Design Reference
    Figma URL: [FIGMA_URL]

    IMPORTANT: Read this Figma design using Figma MCP tools.
    Extract: components, layout hierarchy, user flows, interactions.
    Use the design intent to write a precise, detailed spec.

    RULES:
    - Write in ENGLISH
    - PURELY FUNCTIONAL — translate DESIGN into user stories
    - DO NOT mention Figma-specific details (layers, frames, etc.)
    - User stories with Given/When/Then acceptance criteria
    - Output: specs/functional/spec-v1.md
    - Ask user approval before finalizing
  """
)
```

**IF both referenceUrl AND figmaUrl provided:** combine both Visual Reference and Design Reference sections into a single PO prompt.

### Auth Interruption Flow

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🔒 IF PO OUTPUT CONTAINS "AUTH NEEDED":                                ║
║                                                                           ║
║   1. Claude shows: "The PO needs to access [URL] but it requires login." ║
║   2. AskUserQuestion:                                                     ║
║      "Please log in to the browser window that opened, then confirm."    ║
║      Options: "I'm logged in" / "Skip this URL"                         ║
║   3. IF "I'm logged in" → re-launch PO with same prompt                 ║
║   4. IF "Skip this URL" → re-launch PO WITHOUT referenceUrl             ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**PO asks user approval. Wait for approval.**

**Show AFTER PO completes + approval:**
```
🟢 Step 5a ─ PO                                  ✓ Complete
   Spec: specs/functional/spec-v[N].md
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
║   4. Mandatory stack skills are HARDCODED (see .claude/templates/)       ║
║      → Architect generates skills for ADDITIONAL libs only               ║
║      → Final stack-skills.md = mandatory + project-specific              ║
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
   ├── Functional spec: specs/functional/spec-v[N].md
   ├── API endpoints: specs/functional/api-endpoints.md [if exists]
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
    - Functional spec: specs/functional/spec-v[N].md
    - API endpoints spec: specs/functional/api-endpoints.md (if exists)
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

    (CRAFT rules and tool restrictions are enforced by hooks — see .claude/settings.json)

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

    4. Write specs/stack/stack-skills.md:
       → Read .claude/templates/mandatory-stack-skills.md (HARDCODED — React + TS + TanStack)
       → COPY its content as the FIRST section of stack-skills.md
       → THEN generate CRAFT skills for ADDITIONAL project libraries only
       → Concatenate: mandatory skills + project-specific skills = final file
       → DO NOT regenerate React/TS/TanStack skills — they are already perfect

    5. CHOOSE hexagonal structure adapted to the STACK:
       → Analyze the stack (state management, data fetching, backend vs frontend)
       → Decide WHERE application logic lives naturally in this stack
       → Apply the NO-DEAD-CODE rule: every layer MUST be used
       → See "HEXAGONAL VARIANT — ARCHITECT DECIDES" in your agent file
       → Justify your choice in the ADR section of design.md

    6. Write specs/design/design-v1.md with FULL design:
       → Architecture Decision (ADR style — why this structure, how it adapts hexagonal)
       → CRAFT Principles Applied (checklist: no any, Result<T,E>, etc.)
       → File Structure (hexagonal adapted to the stack — justify every layer)
       → Domain Types (entities, value objects, error types with Result<T,E>)
       → API Endpoints / routes (extracted from inputs, not invented)
       → Application layer (use cases, hooks, stores — whatever fits the stack)
       → Infrastructure (adapters — level of abstraction adapted to context)
       → Code examples for key patterns (Result handling, layer usage)
       → Implementation Checklist (MANDATORY — EVERY file with Wave number)
       → Execution Plan (waves for parallelization)

    7. Ask user approval BEFORE finalizing

    ## QUALITY BAR
    "If this design is complete, Dev can implement WITHOUT asking questions."
    Every file, every type, every interface must be specified.
    NO dead code layers — every file in the design MUST be imported/used by another.
  """
)
```

**Architect asks user approval. Wait for approval.**

> Endpoints come from INPUTS (legacy code, spec, API docs) — Architect extracts and documents them.

**Show AFTER Architect completes + approval:**
```
🟢 Step 5b ─ Architect                            ✓ Complete
   Skills: specs/stack/stack-skills.md
   Design: specs/design/design-v1.md
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
║   1. Re-read the design ({SCOPE}/specs/design/design-v1.md)║
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
║   devops-engineer:                                                       ║
║      → CI/CD pipelines (.github/workflows/*)                             ║
║      → Docker configs (Dockerfile, docker-compose.*)                     ║
║      → Publish configs (.npmrc, .changeset/*)                            ║
║      → Infrastructure-as-code, pipeline monitoring                       ║
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

**Launch agents in BACKGROUND for live progress:**

**Show BEFORE launching — describe WHAT each agent will do:**
```
⏳ Step 5c ─ Wave [N]                             ⟳ In Progress
   ├── [agent-type] ⟳ [short description of files/features]
   ├── [agent-type] ⟳ [short description of files/features]
   └── qa-engineer  ⟳ [test type]: [what's being tested]    ← ONLY if Step 4 = Yes
```

```
// Launch ALL agents in SAME message with run_in_background: true
Task(
  subagent_type: "frontend-engineer",  // or backend-engineer based on code responsibility
  run_in_background: true,
  prompt: """
    Implement Wave [N] from design: specs/design/design-v1.md

    ## BEFORE YOU START
    1. Read specs/design/design-v1.md
    2. Read specs/stack/stack-skills.md — USE these patterns
    3. Find the Implementation Checklist section
    4. Identify ALL files in Wave [N]

    ## CRAFT RULES — MANDATORY
    - Follow the design EXACTLY — don't invent structure
    - Every file gets a colocated *.test.ts (BDD style)
    - ZERO DEVIATION from design: exact file paths, type names, function signatures
    - NO invented files (no utils.ts, helpers.ts, constants.ts unless in checklist)
    - NO dead code (no unused functions, no unused exports, no commented code)
    - NO extra abstractions (no wrapper, factory, or pattern the design didn't ask)
    - IF something is missing from the design → notify Architect, don't invent

    (CRAFT rules and tool restrictions are enforced by hooks — see .claude/settings.json)

    ## OUTPUT
    - ALL files in Wave [N] implemented + tested
    - FILES CREATED table (file path | status | test status)
    - DESIGN CONFORMITY report (extra files: 0, names match: yes/no, dead code: none)
    - Run tests to verify they pass
  """
)

Task(
  subagent_type: "qa-engineer",  // only if QA enabled
  run_in_background: true,
  prompt: """
    Write tests from spec: specs/functional/spec-v[N].md

    ## BEFORE YOU START
    1. Read specs/stack/stack-skills.md — know the testing stack
    2. Read specs/functional/spec-v[N].md — ALL acceptance criteria
    3. Read specs/design/design-v1.md — understand the architecture

    ## YOUR JOB
    - Cover 100% of acceptance criteria (Given/When/Then)
    - E2E or Integration tests (NOT unit tests — that's Dev's job)
    - Test from user's perspective, not implementation details

    (CRAFT rules and tool restrictions are enforced by hooks — see .claude/settings.json)

    ## OUTPUT
    - Test files created
    - All tests passing
    - Coverage report: which spec items are covered
  """
)

// THEN poll for live progress:
TaskOutput(task_id_1, block=false)  → check frontend-engineer
TaskOutput(task_id_2, block=false)  → check qa-engineer
// Update display after each poll:
⏳ Wave [N]
   ├── frontend-engineer ✓ 3/5 files done: Layout, Sidebar, ...
   └── qa-engineer       ⟳ writing E2E for listing page

// Wait for all to finish:
TaskOutput(task_id_1, block=true)
TaskOutput(task_id_2, block=true)
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
║   - Dev: see DESIGN CONFORMITY checks below                              ║
║   - QA: covers all spec items? Tests pass?                               ║
║                                                                           ║
║   DEV-SPECIFIC CONFORMITY (checked on EVERY dev agent output):           ║
║   1. Every file has a test? (*.test.ts colocated)                        ║
║   2. No `any`? No `throw`?                                               ║
║   3. FILES CREATED matches the design checklist EXACTLY?                 ║
║   4. Extra files: 0? (no invented utils.ts, helpers.ts, constants.ts)   ║
║   5. Type names match design? Function signatures match design?          ║
║   6. No dead code? (no unused exports, no commented-out code)            ║
║                                                                           ║
║   IF violation detected → Route back to agent with 🔔 NOTIFICATION      ║
║   "🔴 CRAFT violation: [what's wrong]. Fix before proceeding."           ║
║                                                                           ║
║   IF extra files detected → Route back with:                             ║
║   "🔴 DESIGN DEVIATION: [file] not in checklist. Delete or notify Arch."║
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

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚫 CLAUDE DOES NOT FIX — CLAUDE ROUTES                                ║
║                                                                           ║
║   Claude's ONLY job in Step 6:                                           ║
║   1. Run tests (Bash: npm test)                                          ║
║   2. Run build (Bash: npm run build)                                     ║
║   3. Read the output ONCE                                                ║
║   4. IMMEDIATELY route failures to the owning agent                      ║
║                                                                           ║
║   ❌ DO NOT run tests multiple times to "understand" failures            ║
║   ❌ DO NOT grep/analyze test output to "diagnose"                       ║
║   ❌ DO NOT read source files to "understand the bug"                    ║
║   ❌ DO NOT attempt to fix anything yourself                             ║
║   ❌ DO NOT "wander" trying different commands                           ║
║                                                                           ║
║   Test output shows failures? → Copy the FULL output → Task(agent)      ║
║   Build fails? → Copy the FULL output → Task(agent)                     ║
║                                                                           ║
║   The AGENT reads the error, diagnoses, and fixes. NOT Claude.           ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**Show BEFORE starting:**
```
⏳ Step 6 ─ Verify                                ⟳ In Progress
   Running tests...
```

**Claude's verify procedure (fast — no analysis):**
```
1. Check DESIGN COVERAGE (100% of Implementation Checklist)
2. Run: npm test (or project's test command) — ONE TIME
3. Run: npm run build (or project's build command) — ONE TIME
4. Read output → count pass/fail

IF all green → GO TO STEP 7
IF failures → IMMEDIATELY route full output to owning agent
```

## Design Coverage Check

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚨 BEFORE DECLARING "COMPLETE" — VERIFY 100% COVERAGE + 0 EXTRAS      ║
║                                                                           ║
║   STEP A — COMPLETENESS (all design files exist):                        ║
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
║   STEP B — CONFORMITY (no extra files, no dead code):                    ║
║   4. Glob src/ → list ALL created files                                  ║
║   5. Compare with Implementation Checklist                               ║
║   6. EXTRA files (not in checklist) = DEVIATION                          ║
║                                                                           ║
║   IF extras found:                                                        ║
║      → Show: "🔴 DEVIATION: [files] not in design checklist"            ║
║      → Route to Dev: "Delete [file] or notify Architect if needed"       ║
║      → Loop until extra = 0                                              ║
║                                                                           ║
║   ONLY AT 100% coverage + 0 extras → Proceed to test verification       ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**Show coverage result:**
```
   Coverage: [X]/[Y] files ([Z]%)
   Tests: [PASS/FAIL] · Build: [PASS/FAIL]
```

## Fix Loop Routing

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   ROUTING TABLE — EVERY ERROR TYPE HAS AN OWNER                          ║
║                                                                           ║
║   Error Type                   │ Route To                                ║
║   ─────────────────────────────┼──────────────────────────────           ║
║   Test failure in src/         │ Dev (frontend or backend)               ║
║   Test failure in e2e/         │ QA                                      ║
║   Test failure in tests/       │ QA                                      ║
║   Runtime error (undefined,    │ Dev who owns the file                   ║
║     null ref, React warnings)  │ (UI → frontend, logic → backend)       ║
║   TypeScript type error        │ Architect (design issue)                ║
║   Build error (not types)      │ Dev who owns the failing file           ║
║   Lint error                   │ Dev who owns the file                   ║
║   Spec unclear / ambiguous     │ PO                                      ║
║   Design conflict              │ Architect                               ║
║   CI/CD failure                │ DevOps                                  ║
║   Pipeline config issue        │ DevOps                                  ║
║   Publish error                │ DevOps                                  ║
║   Docker build error           │ DevOps                                  ║
║                                                                           ║
║   🧠 HOW TO DECIDE Dev TYPE:                                             ║
║      → UI component, hook, page, i18n? → frontend-engineer              ║
║      → Domain, service, API, repository? → backend-engineer              ║
║      → Look at the FILE PATH, not the error message                      ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**Show during fix loop:**
```
   🔴 [X] failures detected → routing to [AGENT]...
   ⟳ Fix attempt [N]...
```

### HOW to route — Notification prompts

**Claude MUST use the 🔔 NOTIFICATION format when routing errors:**

```
// Test failure in src/ → Dev fixes (frontend-engineer or backend-engineer)
Task(
  subagent_type: "frontend-engineer",  // or backend-engineer — based on file ownership
  prompt: """
    🔔 NOTIFICATION FROM VERIFY STEP

    ## Test Failed
    File: [test-file:line]
    Test: "[test name]"

    ## Error
    [error message / expected vs received]

    ## Likely Source
    File: [src-file suspected]

    ## Action Required
    Fix the bug. Run tests to confirm. Report what you changed.

    (CRAFT rules enforced by hooks — see .claude/settings.json)
  """
)
```

```
// Test failure in e2e/ or tests/ → QA fixes
Task(
  subagent_type: "qa-engineer",
  prompt: """
    🔔 NOTIFICATION FROM VERIFY STEP

    ## Test Failed
    File: [test-file:line]
    Test: "[test name]"

    ## Error
    [error message / expected vs received]

    ## Context
    - Design: {SCOPE}/specs/design/design-v1.md
    - Stack skills: {SCOPE}/specs/stack/stack-skills.md

    ## Action Required
    Fix YOUR test code. The implementation is correct (tests in src/ pass).
    Run tests to confirm. Report what you changed.
  """
)
```

```
// Runtime error (undefined, null, React warning) → Dev fixes
Task(
  subagent_type: "frontend-engineer",  // or backend-engineer — based on file path
  prompt: """
    🔔 NOTIFICATION FROM VERIFY STEP

    ## Runtime Error
    Component/File: [file:line]
    Error: [error message — e.g. "can't access property X, state is undefined"]

    ## Context
    [React warning, console error, or browser error — paste full message]

    ## Action Required
    Fix the runtime bug. Likely causes: missing null check, incorrect state init,
    missing key prop, undefined data. Fix and add a test covering this case.

    (CRAFT rules enforced by hooks — see .claude/settings.json)
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
// Build error (not type) → Dev fixes
Task(
  subagent_type: "frontend-engineer",  // or backend-engineer — based on file path
  prompt: """
    🔔 NOTIFICATION FROM VERIFY STEP

    ## Build Error
    File: [file:line]
    Error: [build error message]

    ## Context
    Build command: [npm run build / vite build / etc.]
    This is NOT a type error — it's a bundler/build configuration issue.

    ## Action Required
    Fix the build error. Run build to confirm. Report what you changed.

    (CRAFT rules enforced by hooks — see .claude/settings.json)
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

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚨 STEP 7 IS MANDATORY — DO NOT SKIP                                  ║
║                                                                           ║
║   Claude MUST go through Step 7 before declaring complete.               ║
║                                                                           ║
║   ❌ DO NOT write to memory or notes                                     ║
║   ❌ DO NOT declare "Migration Complete" or "Done" yourself              ║
║   ❌ DO NOT skip the architecture capture question                       ║
║                                                                           ║
║   ONLY the CRAFT COMPLETE banner (below) marks the end of /craft.       ║
║   Everything else = the flow is NOT finished.                            ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**Only if `architectureRef` was null at start:**

```
AskUserQuestion:
  "Implementation complete. Capture as architecture reference?"
  Options:
  - Yes, capture patterns
  - No, skip
```

**If YES → spawn Architect to capture patterns:**
```
Task(
  subagent_type: "architect",
  prompt: """
    🔔 ARCHITECTURE CAPTURE

    Implementation is complete. Capture the patterns used into
    an architecture reference document.

    (CRAFT rules and tool restrictions are enforced by hooks — see .claude/settings.json)

    ## YOUR TASK
    1. Read the design: {SCOPE}/specs/design/design-v1.md
    2. Read key implemented files to confirm patterns (use Read/Glob, NEVER Bash)
    3. Write {SCOPE}/ARCHITECTURE.md with:
       - Architecture pattern (hexagonal, layers)
       - Folder structure convention
       - Naming conventions
       - Error handling patterns (Result<T,E>)
       - Testing patterns
       - Key decisions (ADR style)
    4. Add frontmatter: `clean-claude: architecture-reference`

    This becomes the reference for ALL future features in this project.
  """
)
```

**Show RECAP then transition to ITERATION MODE:**
```
╭──────────────────────────────────────────────────────────────╮
│                                                              │
│   🟣 CRAFT COMPLETE — Entering iteration mode                │
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
│   ├── specs/functional/spec-v[N].md           │
│   ├── specs/design/design-v1.md               │
│   ├── specs/stack/stack-skills.md                          │
│   ├── src/ ([X] files + [Y] tests)                          │
│   └── [e2e/ or tests/] ([Z] test files)                     │
│                                                              │
│   🔄 CRAFT session active. Tell me what's next.             │
│                                                              │
╰──────────────────────────────────────────────────────────────╯
```

**Update state.json → status: "iteration"**

**→ GO TO STEP 8**

---

# STEP 8: ITERATION MODE (CRAFT session stays active)

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🔄 CRAFT ITERATION MODE                                               ║
║                                                                           ║
║   The session does NOT end after Step 7.                                 ║
║   Claude stays in FULL CRAFT mode:                                       ║
║                                                                           ║
║   🛡️ CRAFT GUARDIAN is ACTIVE on every user message                      ║
║   - Anti-CRAFT requests → BLOCKED (same rules as always)                ║
║   - ALL routing rules still apply (Dev, QA, Architect, PO)              ║
║   - ALL notification templates still apply                               ║
║   - Claude still delegates to agents via Task() — NEVER implements      ║
║                                                                           ║
║   THIS IS NOT "CLASSIC CLAUDE". THIS IS CRAFT.                          ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

## What the user says → What Claude does

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   USER INPUT                    │ CLAUDE ACTION                          ║
║   ──────────────────────────────┼──────────────────────────────          ║
║                                 │                                        ║
║   Bug report / error message    │ Route to owning agent (Step 6 rules)  ║
║   "Fix this: [error]"          │ → Identify file owner → Task(agent)    ║
║   "This crashes: [stacktrace]" │ → Use Fix Loop Routing table           ║
║                                 │                                        ║
║   Small change / tweak          │ Route to Dev agent directly            ║
║   "Change X to Y"              │ → frontend or backend based on file    ║
║   "Add a tooltip here"         │ → Task(dev) with CRAFT rules           ║
║                                 │                                        ║
║   New feature / big change      │ Back to Step 3 (skip detect/scope)    ║
║   "Add dark mode"              │ → Choose + QA config + full flow       ║
║   "Create a new page"          │ → PO → Architect → Dev → Verify       ║
║                                 │                                        ║
║   "Run tests"                   │ Step 6 Verify (test + build)          ║
║   "Check everything works"     │ → Fix loop if failures                 ║
║                                 │                                        ║
║   "Update the design"          │ Route to Architect                     ║
║   "Refactor this module"       │ → Architect redesigns → Dev implements ║
║                                 │                                        ║
║   ═══════════════════════════════════════════════════════════════════    ║
║                                 │                                        ║
║   🚨 GIT / SHIP = DEVOPS (OBLIGATOIRE — NEVER CLAUDE DIRECTLY)        ║
║                                 │                                        ║
║   "Commit" / "commit this"     │ Task(devops-engineer) IMMEDIATELY      ║
║   "Push" / "push to remote"    │ → DevOps: conventional commit + push   ║
║   "Create a PR"                │ → DevOps: branch + PR via gh           ║
║   "Merge" / "ship it"          │ → DevOps: CI check + merge             ║
║   "Tag" / "release" / "publish"│ → DevOps: version + changelog + publish║
║   "Set up CI" / "add pipeline" │ → DevOps: GitHub Actions / CDS         ║
║   "Deploy" / "deploy to prod"  │ → DevOps: CI green check + deploy     ║
║   "Check CI" / "check pipeline"│ → DevOps: monitor + notify agents     ║
║   "Watch the CI on this branch"│ → DevOps: subscribe + failure routing  ║
║   "Deploy once CI is green"    │ → DevOps: monitor → wait green → ship ║
║                                 │                                        ║
║   ❌ Claude NEVER runs git/gh commands directly                        ║
║   ❌ Claude NEVER commits, pushes, or creates PRs                      ║
║   ❌ Claude NEVER checks CI status or pipeline logs                    ║
║   ✅ ALL git/CI/CD/deploy operations go through DevOps agent           ║
║   ✅ DevOps enforces conventional commits (feat:, fix:, etc.)          ║
║   ✅ DevOps monitors pipelines and notifies the right agent on failure ║
║                                 │                                        ║
║   ═══════════════════════════════════════════════════════════════════    ║
║                                 │                                        ║
║   "Exit craft" / "Done"        │ End session (show final banner)        ║
║                                 │                                        ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

## Bug Fix / Change in Iteration Mode

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚫 CLAUDE DOES NOT INVESTIGATE BUGS — AGENTS DO                       ║
║                                                                           ║
║   User says "modals are blank" or "tabs are missing":                    ║
║                                                                           ║
║   ❌ Claude reads 20 files to understand the architecture                ║
║   ❌ Claude spawns Explore agent to analyze patterns                     ║
║   ❌ Claude diagnoses "the modal replaces the outlet content"            ║
║   ❌ Claude reads the code and THEN spawns agents                        ║
║                                                                           ║
║   ✅ Claude asks: "What does this code do? UI → frontend-engineer"       ║
║   ✅ Claude spawns Task(frontend-engineer) with the bug description      ║
║   ✅ The AGENT reads files, diagnoses, and fixes                         ║
║                                                                           ║
║   TIME FROM USER MESSAGE TO Task() = SECONDS, NOT MINUTES               ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**User reports a bug or asks for a change → Claude routes IMMEDIATELY:**

```
1. Read user's message
2. Determine agent type from the SUBJECT (not by reading code):
   → Modal, tab, route, page, component, UI → frontend-engineer
   → API, service, domain, data mapping     → backend-engineer
   → Test infra, E2E, fixtures              → qa-engineer
3. Spawn agent — IMMEDIATELY (no file reading, no exploration)

Task(
  subagent_type: "[owner-agent]",
  prompt: """
    🔔 NOTIFICATION FROM USER (Iteration Mode)

    ## Bug Report / Change Request
    [PASTE user's EXACT words — do not rephrase or analyze]

    ## Context
    - Design: {SCOPE}/specs/design/design-v1.md
    - Stack skills: {SCOPE}/specs/stack/stack-skills.md

    ## Action Required
    YOU investigate, diagnose, and fix. Read the relevant files.
    Write/update tests. Run tests to confirm green.
    Every fix MUST have a test covering the bug.

    (CRAFT rules enforced by hooks — see .claude/settings.json)
  """
)
```

4. After agent returns → Claude runs tests ONCE (Step 6 verify)
5. If failures → route full output to owning agent (fix loop)
6. If green → report to user → THEN ask doc sync (MANDATORY, see below)

**Git request? → DevOps agent IMMEDIATELY (MANDATORY):**

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚨 GIT = DEVOPS — OBLIGATOIRE, SANS EXCEPTION                         ║
║                                                                           ║
║   User mentions: commit, push, PR, merge, tag, release, publish, deploy  ║
║   → Task(devops-engineer) IMMEDIATELY                                    ║
║   → Claude NEVER runs git/gh commands directly                           ║
║   → DevOps enforces conventional commits                                 ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🔒 DOUBLE APPROVAL — DANGEROUS OPERATIONS                             ║
║                                                                           ║
║   BEFORE spawning DevOps for these, Claude MUST ask user confirmation:   ║
║                                                                           ║
║   🔴 DESTRUCTIVE (irreversible or high blast radius):                    ║
║      - Delete a branch (git branch -D, git push origin --delete)         ║
║      - Force push (git push --force, --force-with-lease)                 ║
║      - Rollback / revert in production                                   ║
║      - npm unpublish / deprecate                                         ║
║      - Drop / destroy pipeline, workflow, or environment                 ║
║      - Reset (git reset --hard)                                          ║
║                                                                           ║
║   🟠 HIGH-IMPACT (affects shared state or external systems):             ║
║      - Deploy to production                                              ║
║      - Merge to main / release branch                                    ║
║      - npm publish (new version to registry)                             ║
║      - Tag a release (version becomes permanent)                         ║
║      - Modify production environment variables                           ║
║                                                                           ║
║   ═══════════════════════════════════════════════════════════════════    ║
║                                                                           ║
║   🟢 NO CONFIRMATION NEEDED (safe, reversible, local):                   ║
║      - Commit, push to feature branch, create PR                         ║
║      - Check CI status, watch pipeline                                   ║
║      - Deploy to staging / dev                                           ║
║      - Create branch, run lint, run tests                                ║
║      - Set up CI pipeline, Docker config                                 ║
║                                                                           ║
║   ═══════════════════════════════════════════════════════════════════    ║
║                                                                           ║
║   HOW: Claude uses AskUserQuestion BEFORE spawning DevOps:              ║
║                                                                           ║
║   AskUserQuestion:                                                       ║
║     "⚠️ This is a [destructive/high-impact] operation:                   ║
║      [describe what will happen]                                         ║
║      Are you sure?"                                                      ║
║     Options: "Yes, proceed" / "No, cancel"                              ║
║                                                                           ║
║   ONLY if user confirms → spawn Task(devops-engineer)                   ║
║   If user cancels → acknowledge and continue session                    ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**Safe operations → DevOps directly:**

```
// User: "commit this" / "push" / "create a PR"
Task(
  subagent_type: "devops-engineer",
  prompt: """
    🔔 GIT REQUEST FROM USER (Iteration Mode)

    ## User Request
    [PASTE user's EXACT words]

    ## Context
    - Scope: {SCOPE}
    - Design: {SCOPE}/specs/design/design-v1.md
    - State: .clean-claude/state.json

    ## RULES — MANDATORY
    - Conventional Commits: type(scope): description
      Types: feat, fix, refactor, test, docs, chore, ci, style, perf, build
    - BEFORE committing: verify tests pass (npm test) and build passes (npm run build)
    - NEVER commit if tests are red
    - NEVER force-push to main
    - NEVER skip hooks (--no-verify)
    - PR body must include: Summary + Test plan
    - Commit message must be concise (< 72 chars first line)

    ## Action Required
    Execute the git operation following CRAFT rules.
    Report what you did (branch, commit hash, PR URL if applicable).
  """
)
```

**Dangerous operation? → Confirm FIRST, then DevOps with USER CONFIRMED flag:**

```
// User: "deploy to prod" / "delete this branch" / "npm publish" / "merge to main" / "rollback"
//
// Step 1: Claude asks confirmation BEFORE spawning DevOps
AskUserQuestion:
  question: "⚠️ This is a [destructive/high-impact] operation: [describe what will happen]. Are you sure?"
  options:
    - "Yes, proceed"
    - "No, cancel"

// Step 2: ONLY if user confirms → spawn DevOps with USER CONFIRMED flag
Task(
  subagent_type: "devops-engineer",
  prompt: """
    🔔 DANGEROUS OPERATION REQUEST — USER CONFIRMED (Iteration Mode)

    ## User Request
    [PASTE user's EXACT words]

    ## Risk Level
    [🔴 DESTRUCTIVE or 🟠 HIGH-IMPACT]: [what will happen]

    ## User Confirmation
    ✅ USER CONFIRMED — proceed with the operation.

    ## Context
    - Scope: {SCOPE}
    - Branch: [current branch]
    - Design: {SCOPE}/specs/design/design-v1.md
    - State: .clean-claude/state.json

    ## RULES — MANDATORY
    - Conventional Commits: type(scope): description
    - BEFORE any destructive action: verify what will be affected
    - Log everything in output (branch deleted, version published, etc.)
    - For production deploys: verify CI is green FIRST

    ## Action Required
    Execute the operation. Report exactly what was done.
  """
)
```

**CI/Pipeline request? → DevOps agent (MONITORING):**

```
// User: "check the CI on this branch" / "check pipeline" / "watch CI"
Task(
  subagent_type: "devops-engineer",
  prompt: """
    🔔 CI MONITORING REQUEST (Iteration Mode)

    ## User Request
    [PASTE user's EXACT words]

    ## Context
    - Scope: {SCOPE}
    - Branch: [current branch]
    - State: .clean-claude/state.json

    ## Action Required
    1. Check current CI status on this branch (gh run list, gh run view)
    2. If a run is in progress → monitor until completion
    3. If failed → parse logs, identify failure type, report with NOTIFICATION format:
       - Test failure → "🔴 ROUTE TO: frontend-engineer (or backend-engineer)"
       - Type error → "🔴 ROUTE TO: architect"
       - E2E failure → "🔴 ROUTE TO: qa-engineer"
       - Build/Docker/Pipeline error → fix directly
    4. If green → report ✅

    Output with standard PIPELINE STATUS + NOTIFICATIONS SENT format.
  """
)
```

```
// User: "deploy once CI is green" / "deploy to staging when pipeline passes"
Task(
  subagent_type: "devops-engineer",
  prompt: """
    🔔 CONDITIONAL DEPLOY REQUEST (Iteration Mode)

    ## User Request
    [PASTE user's EXACT words]

    ## Context
    - Scope: {SCOPE}
    - Branch: [current branch]
    - Design: {SCOPE}/specs/design/design-v1.md
    - State: .clean-claude/state.json

    ## Action Required
    1. Monitor current CI run on this branch (gh run view, poll status)
    2. Wait for completion
    3. If ALL green → proceed with deploy:
       - Verify target environment (staging / production)
       - Execute deploy pipeline or deploy command
       - Report result
    4. If ANY red → DO NOT deploy. Report failures with NOTIFICATION format
       so the right agent can fix.

    ⚠️ IMPORTANT: If deploying to PRODUCTION → report "🔒 PRODUCTION DEPLOY"
    in your output so Claude can confirm with user before proceeding.

    Output with standard PIPELINE STATUS + ACTIONS TAKEN format.
  """
)
```

**Multiple bugs? → Multiple agents in PARALLEL (same message):**
```
// User: "modals are blank, NaN in data, no tabs"
Task(frontend-engineer, "Fix blank modals + missing tabs")
Task(backend-engineer,  "Fix NaN data mapping")
// Both in parallel — SAME message
```

## Post-Fix: Sync Spec + Architecture (NON-BLOCKING)

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚨 MANDATORY — AFTER EVERY GREEN ITERATION, ASK DOC SYNC             ║
║                                                                           ║
║   This is NOT optional. Claude MUST ask every time tests pass.           ║
║   DO NOT skip this. DO NOT just say "What's next?".                      ║
║                                                                           ║
║   Flow: Agent fixes → tests green → ASK doc sync → THEN "What's next?" ║
║                                                                           ║
║   IF user says yes → spawn in BACKGROUND (run_in_background: true)      ║
║   User can immediately start next request.                               ║
║   Doc agents work in parallel without blocking.                          ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

**After each iteration (tests green), ask:**

```
AskUserQuestion:
  "Changes applied and tests green. Update documentation?"
  Options:
  - Update spec + architecture reference
  - Update spec only
  - Update architecture only
  - No, skip
```

**IF user says yes → spawn in BACKGROUND, then immediately ready for next input:**

```
// Spawn doc sync agents in background — don't wait
Task(
  subagent_type: "product-owner",
  run_in_background: true,
  prompt: """
    🔔 SPEC SYNC (Iteration Mode)

    ## What changed
    [summary of what was fixed/changed in this iteration]

    ## Current spec
    {SCOPE}/specs/functional/spec-v[N].md

    ## Action Required
    Read the current spec. Update it to reflect the changes:
    - New behaviors discovered during bug fix
    - Updated acceptance criteria
    - New edge cases identified
    Write spec-v[N+1].md (increment version, don't overwrite).
  """
)

Task(
  subagent_type: "architect",
  run_in_background: true,
  prompt: """
    🔔 ARCHITECTURE SYNC (Iteration Mode)

    (CRAFT rules and tool restrictions are enforced by hooks — see .claude/settings.json)

    ## What changed
    [summary of what was fixed/changed in this iteration]

    ## Current design
    {SCOPE}/specs/design/design-v[N].md

    ## Action Required
    Read the current design. Update to reflect the changes:
    - New patterns introduced
    - Routing/structure changes
    - Updated file list in Implementation Checklist
    Increment version (design-v[N+1].md).
  """
)

// Show to user:
⏳ Doc sync in background:
   ├── product-owner  ⟳ Updating spec-v[N+1].md
   └── architect      ⟳ Updating design-v[N+1].md

🔄 CRAFT session active. What's next? (doc sync continues in background)
```

## New Feature in Iteration Mode

**User asks for something big → back to Step 3:**

```
"This sounds like a new feature. Let me route through the full CRAFT flow."
→ GO TO STEP 3 (skip Step 1-2, keep same scope)
```

## End Session

**User says "exit craft" or "done" → show final banner and update state:**

```
Update state.json → status: "completed"

╭──────────────────────────────────────────────────────────────╮
│                                                              │
│   🟣 CRAFT SESSION ENDED                                     │
│                                                              │
│   Run /craft anytime to start a new session                  │
│   or resume from where you left off.                         │
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
| Verify | Dev | Test failure in src/, runtime error, build error | Spawn Dev with `🔔 NOTIFICATION FROM VERIFY` |
| Verify | QA | Test failure in e2e/ or tests/ | Spawn QA with `🔔 NOTIFICATION FROM VERIFY` |
| Verify | Architect | TypeScript type error, design conflict | Spawn Architect with `🔔 NOTIFICATION FROM VERIFY` |
| QA | Dev | "🔴 Test failed: [file:line]" | Spawn Dev with `🔔 NOTIFICATION FROM QA` |
| Dev | QA | "✅ Fixed [file]" | Spawn QA with `🔔 NOTIFICATION FROM DEV` |
| Dev | Architect | "❓ Design unclear: [question]" | Spawn Architect with `🔔 NOTIFICATION FROM DEV` |
| Architect | Dev | "📐 Design updated: [change]" | Spawn Dev with `🔔 NOTIFICATION FROM ARCHITECT` |
| Any | PO | "❓ Spec unclear: [question]" | Spawn PO with `🔔 NOTIFICATION FROM [AGENT]` |
| DevOps | Dev | "🔴 CI failed: test [X] in pipeline [Y]" | Spawn Dev with `🔔 NOTIFICATION FROM DEVOPS` |
| DevOps | Architect | "🔴 CI failed: type error in pipeline [Y]" | Spawn Architect with `🔔 NOTIFICATION FROM DEVOPS` |
| DevOps | QA | "🔴 CI failed: E2E test [X] in pipeline [Y]" | Spawn QA with `🔔 NOTIFICATION FROM DEVOPS` |
| Dev | DevOps | "✅ Fixed, re-run pipeline" | Spawn DevOps with `🔔 NOTIFICATION FROM DEV` |

**You wrote it? You fix it. Claude routes. EVERY error type has an owner.**

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
| {SCOPE}/specs/functional/ | PO |
| {SCOPE}/specs/design/ | Architect |
| {SCOPE}/specs/stack/stack-skills.md | Architect |
| .github/workflows/** | DevOps |
| Dockerfile, docker-compose.* | DevOps |
| .npmrc, .changeset/** | DevOps |
| CI/CD configs (*.yml pipelines, CDS workflows) | DevOps |

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
  ├─ Step 1: Detect OR Resume (check state.json first)
  │          → Resume: jump to saved step or iteration mode
  │          → Fresh: Read/Glob → context.json + state.json
  │
  ├─ Step 2: Scope (if monorepo) → save and continue
  │
  ├─ Step 3: Choose + Describe (spec? legacy? from scratch?)
  │
  ├─ Step 4: QA Config
  │          Show: FULL RECAP
  │
  ├─ Step 5a: PO enriches/writes spec → User approves
  │
  ├─ Step 5b: Architect: skills + design → User approves
  │
  ├─ Step 5c: Dev + QA implement (parallel)
  │
  ├─ Step 6: Coverage 100% + Tests green + Build OK → Fix loop
  │
  ├─ Step 7: Capture as arch ref (if none existed)
  │
  └─ Step 8: ITERATION MODE (session stays active)
             → Bug → route to agent → fix loop → green
             → Tweak → route to Dev → verify
             → New feature → back to Step 3
             → "Exit craft" → end session
```

**No learning-agent. No Explore agent. Claude orchestrates. Agents execute.**
**Session persists. Resume works across conversations.**
