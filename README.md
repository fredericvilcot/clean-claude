<p align="center">
  <img src="https://img.shields.io/badge/CLEAN-CLAUDE-blueviolet?style=for-the-badge&logo=ghost&logoColor=white" alt="Clean Claude"/>
</p>

<h1 align="center">Stop prompting. Start crafting.</h1>

<p align="center">
  <em>Other agent libs give you tools. Clean Claude gives you <strong>standards</strong>.<br/>
  Clean architecture. Result types. TDD. Domain-driven.<br/>
  Code that fixes itself. Code that learns YOUR patterns.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/🛠️_CRAFT-Clean_Code_&_DDD-8A2BE2?style=for-the-badge" alt="Craft"/>
  <img src="https://img.shields.io/badge/⚡_REACTIVE-Agents_route_errors-9400D3?style=for-the-badge" alt="Reactive"/>
</p>
<p align="center">
  <img src="https://img.shields.io/badge/🔄_SELF--HEALING-Auto--fix_loop-9932CC?style=for-the-badge" alt="Self-healing"/>
  <img src="https://img.shields.io/badge/🧠_ADAPTIVE-Learns_YOUR_code-8A2BE2?style=for-the-badge" alt="Adaptive"/>
</p>

---

## Why Clean Claude is Different

| Other Agent Libs | Clean Claude |
|------------------|---------|
| Agents do tasks | Agents **enforce standards** |
| You fix the bugs | Agents **fix their own bugs** |
| Generic output | **Learns YOUR patterns** |
| No architecture | **Clean Architecture, DDD, Hexagonal** |
| `any`, `throw`, chaos | **Strict types, Result<T,E>, order** |

**Clean Claude isn't a tool. It's a philosophy.**

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

That's Clean Claude.

---

## Prerequisites

**Claude Code CLI** must be installed first:

```bash
# macOS / Linux
npm install -g @anthropic-ai/claude-code

# Or via Homebrew
brew install claude-code
```

> 📖 [Claude Code Documentation](https://docs.anthropic.com/claude-code)

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/fredericvilcot/clean-claude/main/install.sh | bash
```

---

## <img src="https://img.shields.io/badge/Software%20Craft-The%20Foundation-8A2BE2?style=flat-square" alt="Software Craft"/>

Clean Claude is built on **Software Craft** principles — the philosophy that code is a craft, not just a task.

> *"Any fool can write code that a computer can understand. Good programmers write code that humans can understand."* — Martin Fowler

> *"The only way to go fast is to go well."* — Robert C. Martin

### The Masters Behind the Craft

Every Clean Claude agent embodies the teachings of:

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

**Clean Claude agents write code where errors are values, not surprises.**

---

## ⚡ Reactive — Agents Talk to Each Other

<table>
<tr>
<td width="120" align="center">

```
   🔴
  ERROR
   │
   ▼
```

</td>
<td>

**Errors don't stop the flow. They route it.**

```
Test fails     → Dev fixes automatically
Type error     → Architect redesigns
Spec unclear   → PO clarifies
```

No manual intervention. The right agent handles it.

</td>
</tr>
</table>

---

## 🔄 Self-Healing — Bugs Fix Themselves

<table>
<tr>
<td>

```
  ┌─────────────────────────────────────┐
  │                                     │
  │   QA finds bug                      │
  │        │                            │
  │        ▼                            │
  │   Dev fixes (auto)                  │
  │        │                            │
  │        ▼                            │
  │   QA re-tests                       │
  │        │                            │
  │   ┌────┴────┐                       │
  │   │         │                       │
  │  ✅ Pass   🔄 Loop (max 3x)         │
  │                                     │
  └─────────────────────────────────────┘
```

</td>
<td width="300">

**You don't debug AI code.**

The agents debug themselves.

- QA catches the bug
- Dev fixes without asking
- QA verifies the fix
- Loop until green

**Zero human intervention.**

</td>
</tr>
</table>

---

## 🧠 Adaptive — Real-Time CRAFT Guardian

<table>
<tr>
<td width="300">

**Always watching. Always learning.**

The Learning Agent monitors your code **in real-time**:

- 👁️ Watches every code change
- 🔴 Detects CRAFT violations instantly
- 🏗️ Triggers Architect immediately
- 💬 Prompts you for approval

**Auto-learning is ON by default.**

</td>
<td>

```
Code saved...

⚠️ CRAFT VIOLATION DETECTED

File: src/api/client.ts:45
Issue: `any` type found

🏗️ Architect suggests:
Replace `data: any` with `ApiResponse<T>`

[ 💜 Fix now ]  [ ⏭️ Later ]
```

</td>
</tr>
</table>

### What Gets Watched

| 🔴 Critical | 🟠 Warning | 🟡 Smells |
|-------------|------------|-----------|
| `any` types | God class (>300 lines) | Feature Envy |
| `throw` in domain | Long methods (>20 lines) | Data Clumps |
| Framework in domain | Long params (>4) | Primitive Obsession |
| No tests for business | Poor naming | Shotgun Surgery |
| Dependency Rule violation | Missing strict mode | |
| Hidden coupling | | |

**+ All SOLID principles monitored.**

---

## Three Commands. That's It.

```bash
/craft    # Build something
/heal     # Fix something
/learn    # Adapt to your codebase
```

---

## `/craft` — Your AI Dev Team

Say what you want. Clean Claude does the rest.

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

Something broken? Clean Claude relaunches agents to fix it.

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

## `/learn` — Real-Time Guardian

**Auto-learning is ON by default.** The Learning Agent watches your code continuously.

```bash
/learn              # Force re-scan now
/learn --off        # Disable auto-learning (not recommended)
/learn --from <x>   # Learn from external source (repo, folder, URL)
```

When violations are detected:

```
⚠️ CRAFT violation in src/services/auth.ts

🏗️ Architect proposes fix:
   Replace `throw new Error` with `Result<User, AuthError>`

[ 💜 Approve & Fix ]  [ ⏭️ Later ]
```

**Violation → Architect → User approval → Dev fixes → QA verifies**

---

## Why Clean Claude?

| Without Clean Claude | With Clean Claude |
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
  <strong>Clean Claude learns. Clean Claude adapts. Clean Claude crafts.</strong>
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
