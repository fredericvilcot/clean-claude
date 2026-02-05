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

**The Flow:**

```
┌──────────────────────────────────────────────────────────────────┐
│  1. LEARN                                                        │
│     Detect your stack → Generate library skills                  │
│     "TypeScript + React + fp-ts detected"                        │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│  2. CHOOSE                                                       │
│     • New feature                                                │
│     • Fix a bug                                                  │
│     • Improve existing (refactor, add tests, migrate patterns)   │
│     • Or describe what you need...                               │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│  3. QA CONFIG                                                    │
│     "Do you want QA tests?"                                      │
│     • Yes → E2E (Playwright) or Integration?                     │
│     • No  → Dev handles unit tests only                          │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│  4. PRODUCT OWNER                                                │
│     Writes functional spec with acceptance criteria              │
│     → .clean-claude/specs/functional/spec-v1.md                  │
│     ⏸️  USER APPROVAL REQUIRED                                    │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│  5. ARCHITECTURE REFERENCE (explicit prompt)                     │
│     "📐 Which architecture reference?"                           │
│                                                                  │
│     • Use detected reference (path, version, UUID shown)         │
│     • Local file (.md)                                           │
│     • Remote repo (GitHub URL) → CRAFT validation                │
│     • Code folder (extract patterns) → CRAFT validation          │
│     • Design freely (no reference)                               │
│                                                                  │
│     User ALWAYS knows what reference is used                     │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│  6. ARCHITECT                                                    │
│     Reads spec + reference → Designs technical solution          │
│     → .clean-claude/specs/design/design-v1.md                    │
│     MUST confirm: "Architecture Reference: [path] (vN) ✅"       │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│  7. IMPLEMENTATION (parallel)                                    │
│                                                                  │
│     ┌─────────────┐              ┌─────────────┐                 │
│     │     DEV     │    notify    │     QA      │                 │
│     │  code +     │◄────────────►│  E2E tests  │                 │
│     │  unit tests │              │             │                 │
│     └─────────────┘              └─────────────┘                 │
│                                                                  │
│     Bug found? → Dev fixes → QA re-tests → Loop until green      │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│  8. VERIFICATION                                                 │
│     Claude runs build + tests                                    │
│     ✅ All green → Continue                                      │
│     ❌ Failure → Route to right agent → Loop                     │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│  9. CAPTURE (if no reference existed)                            │
│     "Capture as architecture reference?"                         │
│     • Yes → Generate file with UUID + frontmatter flag           │
│     • No  → Skip (can capture later)                             │
│     Future devs (human or AI) will follow these patterns         │
└──────────────────────────────────────────────────────────────────┘
```

**Free text works too:**

| You say | Clean Claude does |
|---------|-------------------|
| "Add dark mode" | Full flow: PO → Arch → Dev → QA |
| "Fix the login bug" | Skip PO, route to Dev |
| "Migrate to Result types" | Architect refactoring plan |
| "Add E2E tests" | QA only |

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
