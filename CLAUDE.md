# CLAUDE.md

> **Stop prompting. Start crafting.**

Spectre transforms Claude Code into a team of Software Craft experts. Clean architecture, Result types, TDD, domain-driven. All agents collaborate reactively.

---

## Three Commands

```bash
/craft    # Build with the full agent team
/heal     # Re-launch agent loop to fix issues
/learn    # Adapt to YOUR codebase patterns
```

---

## `/craft` — Smart Professional Flow

**Spec first. Always ask. All agents run.**

```
/craft
  │
  ├─ "Do you have a spec?"
  │     ├─ YES → "Where?" (file/URL/paste)
  │     └─ NO  → "What do you want?" → PO creates spec
  │
  ├─ Stack auto-detected (or asked if no project)
  │
  └─ MANDATORY CHAIN (ALL agents, NO shortcuts):
       │
       ├─ PO → .spectre/specs/spec-latest.md (user validates)
       ├─ Architect → .spectre/design.md (implementation LAW)
       └─ Dev ⇄ QA (parallel + autonomous fixing loop)
```

### Key Rules

- **ALL agents ALWAYS run** — No shortcuts, no skipping
- **PO is 100% FUNCTIONAL** — No tech details, that's Architect's job
- **Specs are VERSIONED** — spec-v1.md, spec-v2.md, spec-latest.md
- **User validates spec** before Architect starts
- **Architect's design.md is the LAW** — Dev implements EXACTLY that

### Test Responsibilities

| Who | What | Where |
|-----|------|-------|
| **Dev** | Unit tests (BDD) | Colocated `*.test.ts` |
| **QA** | E2E (Playwright) or Integration | `e2e/` or `tests/integration/` |

QA asks: "E2E or Integration?" — then writes tests covering 100% of spec.

---

## `/heal` — Re-launch the Agent Loop

**`/heal` is NOT `npm test`.** It relaunches the full agent loop.

```
/heal
  │
  ├─ Diagnose (tests, types, build, lint)
  ├─ Route to right agent (Dev, Architect, PO)
  ├─ Agent fixes AUTONOMOUSLY
  ├─ QA verifies
  └─ Loop until ALL GREEN
```

```bash
/heal           # Full diagnostic + fix loop
/heal tests     # Focus on test failures
/heal types     # Focus on TypeScript errors
/heal spec      # Sync spec ↔ implementation
```

| Problem | Agent |
|---------|-------|
| Test failing | Dev fixes |
| Type error | Architect fixes |
| Design flaw | Architect redesigns |
| Spec gap | PO completes |

---

## `/learn` — Adapts to YOUR Codebase

```bash
/learn              # Full scan: stack + patterns + violations
/learn <file>       # Learn from specific file
```

Detects your stack, patterns, conventions. On violations → triggers Architect reactively for refacto plan.

---

## Autonomous Fixing Loop

**THE LOOP NEVER STOPS UNTIL EVERYTHING IS GREEN.**

```
Dev + QA run in parallel
        │
   FAILURES?
        │
   ┌────┴────┐
   │         │
  NON       OUI
   │         │
 DONE!   Dev/Architect fix (AUTO)
              │
         QA re-verify
              │
         Loop until ✅
              │
         (max 3 retries → /heal to continue)
```

**Key: NEVER ask user during fixing. Agents fix autonomously.**

---

## The Agents

| Agent | Role | Output |
|-------|------|--------|
| **product-owner** | 100% functional specs, user stories | `.spectre/specs/spec-latest.md` |
| **architect** | Technical design, CRAFT patterns | `.spectre/design.md` |
| **frontend-engineer** | UI implementation + unit tests | Code + `*.test.ts` |
| **backend-engineer** | API implementation + unit tests | Code + `*.test.ts` |
| **qa-engineer** | E2E (Playwright) or Integration tests | `e2e/` or `tests/integration/` |
| **learning-agent** | Stack detection, pattern learning | `.spectre/context.json` |
| **orchestrator** | Coordinates reactive loop | State management |

---

## Software Craft Principles

Every agent follows these non-negotiable rules:

| Principle | Implementation |
|-----------|----------------|
| **No `any`** | Strict TypeScript, types are documentation |
| **No `throw`** | `Result<T, E>` — errors are values |
| **Domain isolation** | Hexagonal architecture, no framework in domain |
| **Colocated tests** | `*.test.ts` next to source |
| **Spec before code** | PO spec → Architect design → Dev implements |

### The Masters

- **Kent Beck** — TDD, "Make it work, make it right, make it fast"
- **Robert C. Martin** — Clean Code, SOLID, Clean Architecture
- **Martin Fowler** — Refactoring, Enterprise Patterns
- **Eric Evans** — Domain-Driven Design
- **Alistair Cockburn** — Hexagonal Architecture

---

## .spectre/ Directory

```
.spectre/
├── specs/
│   ├── spec-v1.md          # Original spec
│   ├── spec-v2.md          # PO improvements
│   └── spec-latest.md      # Approved version
├── design.md               # Architect's technical design
├── context.json            # Stack, patterns detected
├── failures.md             # Test failures for fixing loop
├── test-coverage.md        # QA coverage report
└── state.json              # Workflow state
```

---

## Philosophy

- **Reactive** — Agents collaborate, errors route automatically
- **Autonomous** — Dev fixes without asking, loop until green
- **Craft-first** — Software Craft principles in every line
- **Spec-driven** — Nothing implemented without functional + technical spec
- **Self-correcting** — Failures trigger fixes, not stops
