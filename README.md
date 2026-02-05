<p align="center">
  <img src="https://img.shields.io/badge/CLEAN-CLAUDE-blueviolet?style=for-the-badge&logo=ghost&logoColor=white" alt="Clean Claude"/>
</p>

<h1 align="center">Stop prompting. Start crafting.</h1>

<p align="center">
  <em>Clean Claude transforms Claude Code into a team of Software Craft experts.<br/>
  Clean architecture. Result types. TDD. Domain-driven.<br/>
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
| **Kent Beck** | TDD — *"Make it work, make it right, make it fast"* |
| **Uncle Bob** | Clean Code, SOLID, Clean Architecture |
| **Martin Fowler** | Refactoring — *"Good programmers write code humans understand"* |
| **Eric Evans** | Domain-Driven Design |
| **Alistair Cockburn** | Hexagonal Architecture (Ports & Adapters) |

### The Non-Negotiables

```
No any          → Types are documentation
No throw        → Result<T, E> — errors are values
No god classes  → Single responsibility
No untested     → Tests are specs that run
No cowboy code  → Spec → Design → Implement
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

Your AI dev team activates:

```
You: "Build user authentication"

    Product Owner  →  Writes the spec
    Architect      →  Designs the solution
    Developer      →  Implements it
    QA Engineer    →  Tests it

    Bug found? → Dev fixes → QA re-tests → Loop until green.
```

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

```typescript
// ❌ BAD — Caller doesn't know this can fail
function getUser(id: string): User {
  throw new Error('Not found');
}

// ✅ GOOD — Error is explicit in the type
function getUser(id: string): Result<User, NotFoundError> {
  return err(new NotFoundError(id));
}
```

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
