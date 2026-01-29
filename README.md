<p align="center">
  <img src="https://img.shields.io/badge/SPECTRE-AGENTS-blueviolet?style=for-the-badge&logo=ghost&logoColor=white" alt="Spectre Agents"/>
</p>

<h1 align="center">SPECTRE AGENTS</h1>

<p align="center">
  <strong>Stop prompting. Start crafting.</strong>
</p>

<p align="center">
  <em>A reactive multi-agent system for <a href="https://claude.ai/code">Claude Code</a><br/>that learns, adapts, and delivers craft-ready code.</em>
</p>

---

## Craft First

Spectre isn't a code assistant. It's a **craft system**.

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   PROMPTING                        CRAFTING                      │
│   ─────────                        ────────                      │
│                                                                  │
│   "Build me a login"               "Build me a login"            │
│         ↓                                ↓                       │
│   200 lines of code                Architect designs the flow    │
│   Works... maybe                   Engineer implements SOLID     │
│   No tests                         QA verifies, loops on failure │
│   any everywhere                   Strict types, Result<T,E>     │
│   throw Error                      Explicit error handling       │
│         ↓                                ↓                       │
│   "Now debug this"                 Production-ready              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Craft Principles

Every Spectre agent embodies these principles:

| Principle | Application |
|-----------|-------------|
| **Domain First** | Business logic at the center, frameworks at the edges |
| **Type Safety** | Strict mode, no `any`, the compiler is your ally |
| **Explicit Errors** | `Result<T, E>` not `throw Error`, code tells its story |
| **Test-Driven** | Tests are executable specs, not an afterthought |
| **Clean Architecture** | SOLID, DDD, Hexagonal — context-appropriate |

**Spectre doesn't generate code. It crafts software.**

---

## How It Works

Three mechanisms working together:

### 1. Auto-Learning

**Active by default.** Zero configuration.

```
🔍 Detects your exact stack
   TypeScript 5.3 + React 18.2 + React Query v5 + Zustand + Zod

🧠 Learns your conventions (if code is clean)
   Feature folders, Result types, absolute imports, colocated tests

🛡️ Craft Guard — rejects anti-patterns
   throw Error? → Blocked
   any everywhere? → Blocked
   → Report generated, you decide
```

### 2. Dynamic Injection

**No static templates.** Skills generated for YOUR stack.

```
Stack: React + React Query + Zustand + Zod

Generating craft skills...
  ✓ React Query: query keys, mutations, optimistic updates
  ✓ Zustand: slices, selectors, domain separation
  ✓ Zod: validation boundaries, type inference

Injecting into each agent...
  → Architect receives skills
  → Engineer receives skills
  → QA receives skills
```

Each agent works with:
- Skills generated for your stack
- Patterns learned from your project
- Universal craft principles

### 3. Reactive Loop

**Agents self-correct.**

```
Architect ───▶ Engineer ───▶ QA
                   ▲          │
                   └── fix ◀──┘  (test fail → loop)
```

| QA detects | Routed to | Action |
|------------|-----------|--------|
| Test failure | Engineer | Fix → QA re-verifies |
| Design flaw | Architect | Redesign → Engineer → QA |
| Spec gap | Product Owner | Clarify → Architect → ... |

Max 3 retries. Then you take over.

---

## Commands

### `/craft` — Build with craft

```bash
/craft                    # Guided flow
/craft "Add login form"   # Direct
```

Assembles the team based on your context:
- **Product Team** → PO → Architect → Engineer → QA
- **Startup** → Architect → Engineer → QA
- **Freelance** → Engineer → QA

### `/heal` — Smart repair

```bash
/heal           # Diagnose and fix everything
/heal tests     # Fix tests
/heal types     # Fix TypeScript
```

Routes to the right expert. Type error → Architect. Test failure → Engineer.

### `/learn` — Configure learning

```bash
/learn                  # Re-scan
/learn --only src/auth  # Limited scope
/learn --off            # Disable
/learn --show           # View learnings
```

---

## The Team

| Agent | Focus | Craft Skills |
|-------|-------|--------------|
| **Product Owner** | Specs | Stories, criteria, edge cases |
| **Architect** | Design | Clean Archi, DDD, SOLID, review |
| **Frontend Engineer** | UI | React, a11y, components, hooks |
| **Backend Engineer** | API | Services, validation, Result types |
| **QA Engineer** | Tests | TDD/BDD, coverage, verification |

---

## Example

```
> /craft "Auth with OAuth and magic links"

🔍 Stack: TypeScript + React + React Query
🧠 Patterns: feature folders, Result types
✅ Craft skills injected

🏗️ Architect designing...
   ✓ OAuth2 + PKCE
   ✓ Magic link strategy
   ✓ Session management

💻 Engineer implementing...
   ✓ AuthContext (typed)
   ✓ useAuth hook
   ✓ LoginForm component

🧪 QA testing...
   ✓ 8 tests, 2 failures

🔄 Engineer fixing...
💻 → Fixed error handling
💻 → Fixed token refresh

🧪 QA re-verifying...
   ✓ 8/8 passing

✅ Craft complete.
```

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/install.sh | bash
```

---

<p align="center">
  <code>/craft</code> · <code>/heal</code> · <code>/learn</code>
</p>

<p align="center">
  <strong>Spectre learns. Spectre adapts. Spectre crafts.</strong>
</p>
