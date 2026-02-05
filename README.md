<p align="center">
  <img src="https://img.shields.io/badge/CLEAN-CLAUDE-blueviolet?style=for-the-badge&logo=ghost&logoColor=white" alt="Clean Claude"/>
</p>

<h1 align="center">Stop prompting. Start crafting.</h1>

<p align="center">
  <em>Clean Claude transforms Claude Code into a team of Software Craft experts.<br/>
  Clean architecture. Result types. Tested. Domain-driven.<br/>
  All agents collaborate reactively.</em>
</p>

<p align="center">
  <a href="#philosophy">Philosophy</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#commands">Commands</a> •
  <a href="#agents">Agents</a> •
  <a href="#documentation">Documentation</a>
</p>

---

## Philosophy

**Clean Claude isn't a tool. It's a philosophy.**

We believe code is a **craft**, not just a task. Every agent embodies the teachings of the masters:

| Master | Teaching |
|--------|----------|
| **Kent Beck** | *"Make it work, make it right, make it fast"* |
| **Uncle Bob** | Clean Code, SOLID, Clean Architecture |
| **Martin Fowler** | Refactoring — *"Good programmers write code humans understand"* |
| **Eric Evans** | Domain-Driven Design |
| **Alistair Cockburn** | Hexagonal Architecture (Ports & Adapters) |

### The Non-Negotiables

```
Explicit types     → Types document intent
Explicit errors    → Errors are values, not surprises
Single purpose     → Small, focused units
Always tested      → Tests are specs that run
Spec first         → Think before you code
Domain isolation   → Business logic stays pure
```

---

## Quick Start

### Prerequisites

[Claude Code CLI](https://docs.anthropic.com/claude-code) must be installed:

```bash
npm install -g @anthropic-ai/claude-code
```

### Installation

```bash
curl -fsSL https://raw.githubusercontent.com/fredericvilcot/clean-claude/main/install.sh | bash
```

That's it. Start with `/craft`.

---

## Commands

Three commands. That's all you need.

### `/craft` — Build something

```bash
/craft
```

**The Flow (with live feedback):**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 1. LEARN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 📦 Stack: typescript, react, zustand, fp-ts, vitest
 📐 Architecture: docs/arch.md (v2, id: f8a3...b2c1)
 ✅ CRAFT: compliant (no any, Result pattern, 65% coverage)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 2. CHOOSE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 What do you want to craft?
 • New feature
 • Fix a bug
 • Improve existing
 • Or describe...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 3. QA CONFIG
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Do you want QA tests?
 • Yes → E2E (Playwright) or Integration?
 • No  → Unit tests only (colocated)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 4. PRODUCT OWNER (smart routing)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 IF new feature / user-facing bug:
   📋 Writing spec...
   → .clean-claude/specs/functional/spec-v1.md
   ⏸️  APPROVAL REQUIRED

 IF refactor / migration / technical:
   ⏭️  SKIPPED — no functional spec needed
   → Proceeding directly to Architect

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 5. ARCHITECTURE REFERENCE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 📐 Reference detected: docs/arch.md
    Version: 2 | UUID: f8a3b2c1-4d5e-6789-abcd-ef0123456789

 Which reference to use?
 • Use docs/arch.md (recommended)
 • Choose another (local file, remote repo, code folder)
 • Design freely (no reference)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 6. ARCHITECT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 🏛️ Designing...
    Reference: docs/arch.md (v2) ✅
    Spec: spec-v1.md

 → .clean-claude/specs/design/design-v1.md
 → 8 implementation tasks identified

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 7. IMPLEMENTATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 🚀 Parallel execution:

 ┌─────────────────────────────────────────────────────────────┐
 │  DEV 1: src/domain/        ████████░░ 80%                   │
 │  DEV 2: src/application/   ██████████ done                  │
 │  DEV 3: src/ui/            ███████░░░ 70%                   │
 │  QA:    e2e/               ██████░░░░ 60%                   │
 └─────────────────────────────────────────────────────────────┘

 📁 Files: 12 created, 3 modified
 🧪 Tests: 8 written (6 passing, 2 pending)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 8. VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Running: npm run build && npm test

 ❌ 2 failures detected:
    • Type error: src/domain/User.ts:45
    • Test fail: e2e/login.spec.ts:23

 🔄 Routing to agents...
    → DEV 1: fixing type error
    → QA: fixing e2e test

 ✅ Retry 1: All green

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 9. CAPTURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 ✅ Implementation complete

 Capture as architecture reference?
 • Yes → Save patterns (UUID generated, committed)
 • No  → Skip for now

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 DONE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 📊 Summary:
    Feature: User Authentication
    Files: 15 created, 3 modified
    Tests: 12 unit + 4 e2e (all passing)
    Time: 4 agent cycles
    Reference: docs/arch.md (v2) followed ✅

```

**Smart routing — free text works:**

| You say | Route | Why |
|---------|-------|-----|
| "Add dark mode" | PO → Arch → Dev | New feature needs spec |
| "Login doesn't work" | PO → Arch → Dev | User-facing bug needs spec |
| "Memory leak in cart" | Arch → Dev | Technical bug, no spec needed |
| "Migrate to monorepo" | Arch → Dev | Transformation, no spec needed |
| "Migrate to Result types" | Arch → Dev | Refactor, no spec needed |
| "Add E2E tests" | QA directly | Tests only |

### `/heal` — Fix something

```bash
/heal           # Full diagnostic
/heal tests     # Focus on test failures
/heal types     # Focus on TypeScript errors
```

Routes each problem to the right expert:
- Test failing → Developer
- Type error → Architect
- Spec unclear → Product Owner

### `/learn` — Adapt to your codebase

```bash
/learn                    # Detect stack + validate CRAFT
/learn stack              # Stack detection only
/learn architecture       # Extract patterns from code
/learn <url|path>         # Analyze external source
```

---

## Agents

| Agent | Role | Output |
|-------|------|--------|
| **Learning Agent** | Detects stack, validates CRAFT compliance | `.clean-claude/context.json` |
| **Product Owner** | Turns ideas into specs | `.clean-claude/specs/functional/` |
| **Architect** | Designs clean solutions | `.clean-claude/specs/design/` |
| **Frontend Engineer** | UI + unit tests (BDD) | Code + `*.test.ts` |
| **Backend Engineer** | API + unit tests (BDD) | Code + `*.test.ts` |
| **QA Engineer** | E2E / Integration tests | `e2e/` |

### Reactive Loop

Agents don't work in isolation. They **notify each other**:

```
QA finds bug       →  Dev fixes automatically
Dev needs clarity  →  Architect explains
Design flaw        →  Architect updates
Spec unclear       →  PO clarifies
```

**Zero manual intervention. The right agent handles it.**

---

## How It Works

```
/craft "add dark mode"
     │
     ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   LEARNING  │────▶│     PO      │────▶│  ARCHITECT  │
│   (stack)   │     │   (spec)    │     │  (design)   │
└─────────────┘     └─────────────┘     └─────────────┘
                                               │
                    ┌──────────────────────────┤
                    │                          │
                    ▼                          ▼
             ┌─────────────┐           ┌─────────────┐
             │     DEV     │           │     QA      │
             │   (code)    │◀─────────▶│  (tests)    │
             └─────────────┘  notify   └─────────────┘
                    │                          │
                    └──────────────────────────┘
                                │
                                ▼
                         ✅ All green
```

---

## Architecture

Clean Claude enforces **Hexagonal Architecture**:

```
┌─────────────────────────────────────────────┐
│              INFRASTRUCTURE                  │
│   (HTTP, DB, External APIs — replaceable)   │
│  ┌───────────────────────────────────────┐  │
│  │            APPLICATION                 │  │
│  │         (Use Cases, Ports)            │  │
│  │  ┌─────────────────────────────────┐  │  │
│  │  │            DOMAIN               │  │  │
│  │  │   (Entities, Value Objects)     │  │  │
│  │  │        Pure. No deps.           │  │  │
│  │  └─────────────────────────────────┘  │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
         Dependencies point INWARD →
```

### Error Handling

Errors are **values**, not exceptions:

```
❌ BAD  — Caller doesn't know this can fail
   getUser(id) → User | throws

✅ GOOD — Error is explicit in the return type
   getUser(id) → Result<User, NotFoundError>
```

Works with any language: `Result<T,E>`, `Either`, `Option`, `Maybe`, `error` return values...

### Architecture Reference — Team Consistency

**First feature = reference for all future features.**

After implementing your first feature, Clean Claude asks:

```
"Implementation complete. Capture as architecture reference?"
```

If you accept, it creates an **architecture-reference** file that:
- Documents your folder structure, naming conventions, patterns
- Becomes **mandatory** for all future features
- Keeps your team (humans or AI) consistent

```
┌─────────────────────────────────────────────────────────────────┐
│  Feature 1: Authentication                                      │
│  → Implements patterns freely                                   │
│  → Captured as architecture-reference                           │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Feature 2, 3, 4...                                             │
│  → Architect READS architecture-reference first                 │
│  → Architect FOLLOWS established patterns                       │
│  → Deviations require explicit approval + version bump          │
└─────────────────────────────────────────────────────────────────┘
```

**Use case:** You define the architecture once. Every developer (human or AI) follows it.

---

## Monorepo & Full-Stack Support

Clean Claude detects your project structure and adapts:

```
Single app?  → Direct stack detection, no extra questions
Monorepo?    → Ask which workspace to work on first
Full-stack?  → Routes to the right engineer (frontend or backend)
```

**Stack-agnostic routing:**

| Code responsibility | Routed to |
|---------------------|-----------|
| UI, components, user interaction | Frontend Engineer |
| API, business logic, data persistence | Backend Engineer |
| Shared types, utilities | Either (based on usage) |

Works with **any stack**: React, Vue, Svelte, Node, Go, Rust, Python...

**Smart detection:**
- `package.json` workspaces
- `pnpm-workspace.yaml`
- `lerna.json`, `nx.json`, `turbo.json`

**Example flow (monorepo with 50 micro-frontends):**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 STEP 1/9 — LEARN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 🔍 Monorepo detected (50 workspaces)

 ┌─ Workspaces ──────────────────────────────────────────────────────┐
 │  apps/     auth, dashboard, billing, settings, admin...          │
 │  packages/ shared, ui-kit, utils                                  │
 └───────────────────────────────────────────────────────────────────┘

 Which workspace do you want to work on?
 • apps/auth
 • apps/dashboard
 • packages/shared
 • Root level
```

**Architecture hierarchy:**

```
monorepo/
├── docs/
│   └── architecture.md          ← ROOT (shared patterns)
│
└── apps/
    └── auth/
        └── ARCHITECTURE.md      ← LOCAL (inherits root, can override)
```

- **Root architecture**: Patterns shared across ALL workspaces
- **Local architecture**: Workspace-specific patterns (inherits from root)
- Architect reads BOTH when designing

---

## Documentation

| Document | Description |
|----------|-------------|
| [CLAUDE.md](./CLAUDE.md) | Full operational rules and workflow |
| [Agents](./.claude/agents/) | Individual agent definitions |
| [Skills](./.claude/skills/) | Command implementations |

### Project Structure

```
.clean-claude/                  # Clean Claude working directory
├── context.json                # Detected stack + CRAFT validation
├── stack-skills.md             # Library documentation
├── architecture-guide.md       # Project patterns (if captured)
└── specs/
    ├── functional/             # PO specs
    └── design/                 # Architect designs
```

---

## Why Clean Claude?

| Without | With Clean Claude |
|---------|-------------------|
| You prompt, you debug | Agents collaborate, QA verifies |
| Generic code | Learns YOUR patterns |
| `any` everywhere | Strict TypeScript |
| `throw new Error` | `Result<T, E>` |
| No architecture | Hexagonal, DDD, Clean |
| You are the QA | QA agent catches bugs |

---

<p align="center">
  <img src="https://img.shields.io/badge//%20craft-8A2BE2?style=for-the-badge" alt="/craft"/>
  <img src="https://img.shields.io/badge//%20heal-9400D3?style=for-the-badge" alt="/heal"/>
  <img src="https://img.shields.io/badge//%20learn-9932CC?style=for-the-badge" alt="/learn"/>
</p>

<p align="center">
  <strong>Clean Claude learns. Clean Claude adapts. Clean Claude crafts.</strong>
</p>

<p align="center">
  <sub>BSD 3-Clause License</sub>
</p>
