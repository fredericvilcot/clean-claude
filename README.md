<p align="center">
  <img src="https://img.shields.io/badge/SPECTRE-AGENTS-blueviolet?style=for-the-badge&logo=ghost&logoColor=white" alt="Spectre Agents"/>
</p>

<h1 align="center">Stop prompting. Start crafting.</h1>

<p align="center">
  <em>Turn Claude Code into a team of Software Craft experts.<br/>Clean architecture. Result types. TDD. Domain-driven.<br/>Production-ready code, crafted together.</em>
</p>

---

## The Problem

You prompt. AI dumps code. You debug it.

No architecture. No tests. No standards. Just... code.

**You became the QA for an AI.**

---

## The Solution

What if Claude Code worked like a **real dev team**?

```
You: "Build user authentication"

    Product Owner    →  Writes the spec
    Architect        →  Designs the solution
    Developer        →  Implements it
    QA Engineer      →  Tests it

    Bug found? → Dev fixes → QA re-tests → Loop until green.
```

That's Spectre.

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/fredericvilcot/spectre-agents/main/install.sh | bash
```

---

## Software Craft — The Foundation

Spectre is built on **Software Craft** principles — the philosophy that code is a craft, not just a task.

> *"Any fool can write code that a computer can understand. Good programmers write code that humans can understand."* — Martin Fowler

> *"The only way to go fast is to go well."* — Robert C. Martin

### The Masters Behind the Craft

Every Spectre agent embodies the teachings of:

- **Kent Beck** — TDD, XP, "Make it work, make it right, make it fast"
- **Robert C. Martin (Uncle Bob)** — Clean Code, SOLID, Clean Architecture
- **Martin Fowler** — Refactoring, Enterprise Patterns
- **Eric Evans** — Domain-Driven Design
- **Alistair Cockburn** — Hexagonal Architecture (Ports & Adapters)

### Architecture: Domain at the Center

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

### Craft Principles — Non-Negotiable

| Principle | Why |
|-----------|-----|
| **No `any`** | Types are documentation. `any` is lying. |
| **No `throw`** | Use `Result<T, E>`. Errors are values, not surprises. |
| **No god classes** | Single responsibility. Small, focused units. |
| **No code without tests** | TDD mindset. Tests are specs that run. |
| **No implementation without spec** | Contracts first. PO spec → Architect design → Dev implements. |
| **Domain is sacred** | No framework contamination. Pure business logic. |

### Error Handling: Explicit, Not Exceptional

```typescript
// BAD — Caller doesn't know this can fail
function getUser(id: string): User {
  throw new Error('Not found');
}

// GOOD — Error is explicit in the type
function getUser(id: string): Result<User, NotFoundError> {
  return err(new NotFoundError(id));
}
```

**Spectre agents write code where errors are values, not surprises.**

---

## Three Commands. That's It.

```bash
/craft    # Build something
/heal     # Fix something
/learn    # Adapt to your codebase
```

---

## `/craft` — Your AI Dev Team

Say what you want. Spectre does the rest.

```
> /craft "user authentication with OAuth"

🔍 Detected: TypeScript + React + Node

👤 PO → spec.md
   ✓ User story
   ✓ 6 acceptance criteria

🏗️ Architect → design.md
   ✓ 8 files planned
   ✓ CRAFT patterns

💻 Dev + 🧪 QA (parallel)
   ✓ Implementing...
   ✗ Test failed: OAuth callback
   🔧 Dev fixing... (auto)
   ✓ 6/6 tests passing

✨ Done.
```

**All agents. Always. No shortcuts. Autonomous fixing.**

---

## `/heal` — Re-launch the Agent Loop

Something broken? Spectre relaunches agents to fix it.

```bash
/heal        # Diagnose → Route → Fix → Verify → Loop
/heal tests  # Focus on test failures
/heal types  # Focus on TypeScript errors
```

**`/heal` is NOT `npm test`.** It relaunches the full agent loop:

1. **Diagnose** — What's broken?
2. **Route** — Send to the right agent
3. **Fix** — Agent fixes autonomously
4. **Verify** — QA re-runs tests
5. **Loop** — Until all green

| Problem | Agent fixes it |
|---------|----------------|
| Test failing | Developer |
| Type error | Architect |
| Spec gap | Product Owner |

---

## `/learn` — Adapts to YOU

Spectre learns your codebase:

- Your folder structure
- Your naming conventions
- Your patterns

Then enforces them. Everywhere.

```
> /learn

📦 Detected: TypeScript + React + Vitest
📐 Patterns: Feature folders, Result types
⚠️ Found: 5x 'any' types

🏗️ Architect proposes refactoring plan...
```

---

## Why Spectre?

| Without Spectre | With Spectre |
|-----------------|--------------|
| You prompt, you debug | Agents collaborate, QA verifies |
| Generic code | Learns YOUR patterns |
| `any` everywhere | Strict TypeScript |
| `throw new Error` | `Result<T, E>` |
| No tests | Tests included |
| You are the QA | QA agent catches bugs |

---

## The Team

| Agent | Superpower |
|-------|------------|
| **Product Owner** | Turns vague ideas into clear specs |
| **Architect** | Designs clean, maintainable solutions |
| **Developer** | Implements with craft principles |
| **QA Engineer** | Catches bugs before you do |
| **Learning Agent** | Adapts everything to YOUR codebase |

---

<p align="center">
  <strong>Spectre learns. Spectre adapts. Spectre crafts.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge//%20craft-8A2BE2?style=for-the-badge" alt="/craft"/>
  <img src="https://img.shields.io/badge//%20heal-9400D3?style=for-the-badge" alt="/heal"/>
  <img src="https://img.shields.io/badge//%20learn-9932CC?style=for-the-badge" alt="/learn"/>
</p>

---

<p align="center">
  <sub>BSD 3-Clause License</sub>
</p>
