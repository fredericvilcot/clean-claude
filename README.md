# Spectre Agents

> **Stop prompting. Start crafting.**

A reactive multi-agent system for [Claude Code](https://claude.ai/code) that adapts to how you work.

---

## Three Commands. That's It.

```bash
/craft    # Create something new
/heal     # Fix what's broken
/learn    # Adapt to YOUR project
```

No configuration. No learning curve. Just results.

---

## `/craft` — Tell Us What You Need

```
> /craft

What's your work context?

  [ Product Team ]  → Full specs, reviews, compliance
  [ Startup ]       → Ship fast, iterate faster
  [ Freelance ]     → Get it done, no overhead
  [ Learning ]      → Explore, no pressure
```

Then describe what you want. Spectre assembles the right team:

```
> "User authentication with OAuth and magic links"

Got it! Here's the plan:

  product-owner → software-craftsman → frontend-dev → qa-engineer
                                             ↑              │
                                             └── fix loop ──┘

Starting...
```

**Your context changes everything:**

| You | What Happens |
|-----|--------------|
| **Product Team** | Full workflow: PO writes spec → Architect designs → Dev builds → QA tests |
| **Startup** | Fast track: Architect → Dev → QA (you're the PO) |
| **Freelance** | Direct: Dev → QA (or just Dev if prototyping) |
| **Learning** | Educational: Single agent explains as it goes |

---

## `/heal` — Fix Everything Automatically

Something broke? Don't debug. Just heal.

```bash
/heal           # Fix everything (tests, build, types, specs)
/heal tests     # Fix failing tests
/heal types     # Fix TypeScript errors
/heal spec      # Sync spec with implementation
```

```
> /heal

🔍 Diagnosing...

  ❌ 3 tests failing
  ❌ 2 type errors

🔧 Healing...

  → software-craftsman fixed type errors
  → frontend-dev fixed tests
  → qa-engineer verified

✅ All systems healthy.
```

**Even specs get healed:**

```
> /heal spec

🔍 Comparing spec vs code...

  ❌ Missing in code: "Remember me" checkbox
  ⚠️ Mismatch: spec says 5 retries, code has 3

🔧 Healing...

  → product-owner updated spec
  → frontend-dev added feature

✅ Spec and code in sync.
```

---

## Why Spectre?

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│   Other tools:        You prompt → Agent works → You check     │
│                                                                │
│   Spectre:            You describe → Agents collaborate →      │
│                       Agents verify → Agents fix → Done        │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

**Agents that talk to each other:**

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   QA finds test failure ────────────▶ Dev fixes            │
│   QA finds design flaw ─────────────▶ Architect redesigns  │
│   QA finds unclear spec ────────────▶ PO clarifies         │
│                                                             │
│   Dev blocked by design ────────────▶ Architect adjusts    │
│   Dev finds spec gap ───────────────▶ PO completes         │
│                                                             │
│   Architect finds contradiction ────▶ PO arbitrates        │
│   Architect reviews code ───────────▶ Dev improves         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Not just "Dev fixes tests". **Every agent can escalate to the right expert.**

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/install.sh | bash
```

Restart Claude Code. Done.

---

## The Team

Specialized agents that know their craft:

| Agent | Expertise |
|-------|-----------|
| **product-owner** | Specs, user stories, acceptance criteria |
| **software-craftsman** | Architecture, DDD, SOLID, clean code |
| **frontend-dev** | React, accessibility, state, components |
| **backend-dev** | APIs, services, data, integrations |
| **qa-engineer** | Tests, TDD/BDD, coverage, verification |

You don't manage them. `/craft` and `/heal` do.

---

## Reactive Links

Agents don't just work in sequence. They **react** to each other:

| When... | Then... |
|---------|---------|
| QA finds **test failure** | Dev (who wrote the code) fixes it |
| QA finds **design flaw** | Architect redesigns, Dev re-implements |
| QA finds **unclear spec** | PO clarifies, QA re-tests |
| Dev is **blocked by design** | Architect adjusts, Dev continues |
| Dev finds **spec gap** | PO completes, Dev implements |
| Architect finds **contradiction** | PO decides, Architect adjusts |

```
         ┌──── contradiction ────▶ PO
         │
Architect├──── design flaw ◀───── QA
         │
         └──── review ───────────▶ Dev
                                    │
                   ┌────────────────┤
                   │                │
              spec gap          blocked
                   │                │
                   ▼                ▼
                  PO            Architect
```

**The right expert handles each problem. Automatically.**

---

## `/learn` — Adapt to Your Project

Agents learn YOUR conventions. Not generic best practices — YOUR patterns.

```bash
/learn                       # Full project analysis
/learn code                  # Learn architecture & imports
/learn tests                 # Learn testing style
/learn <file>                # Learn from exemplary file
/learn --example <file>      # Mark as gold standard
```

```
> /learn

🔍 Analyzing project...

📦 Tech Stack: React 18 + TypeScript + Vite
🏗️ Architecture: Feature-based (src/features/)
🧪 Testing: Vitest, co-located, BDD naming
📝 Specs: Markdown with Gherkin AC
✨ Style: Strict TS, single quotes, @/ imports

💾 Saved. Agents will now follow your conventions.
```

**Fine-tune with exemplary files:**

```bash
# "This service is exactly how I want services written"
/learn --example src/features/auth/AuthService.ts

# "This is my reference test file"
/learn --example src/components/Button/Button.test.tsx
```

Agents will now reference YOUR gold standard files when writing similar code.

**Before `/learn`:**
```typescript
// Generic patterns
import Button from '../../../components/Button'
throw new Error('Failed')
```

**After `/learn`:**
```typescript
// YOUR patterns
import { Button } from '@/components'
return Result.err(new AuthError('Failed'))
```

---

## Craft Skills

Apply craft principles to specific areas:

```bash
/typescript-craft    # Strict types, Result patterns, pure functions
/react-craft         # Component design, hooks, accessibility
/test-craft          # TDD/BDD, test pyramid, proper mocks
/init-frontend       # Bootstrap React + Vite + TypeScript + Vitest
```

---

## Philosophy

**Code is a craft.** Not a race.

| Principle | Meaning |
|-----------|---------|
| **Domain First** | Business logic at center, frameworks at edges |
| **Type Safety** | Types are documentation that compiles |
| **Explicit > Implicit** | No magic, no surprises |
| **Test-Driven** | Tests are specs that run |

---

## Documentation

- [Architecture Guide](docs/ARCHITECTURE.md) — How it works under the hood
- [CLAUDE.md](CLAUDE.md) — Instructions for Claude Code

---

## License

BSD 3-Clause

---

<p align="center">
  <strong>/learn</strong> to adapt. <strong>/craft</strong> to create. <strong>/heal</strong> to fix.<br/>
  That's the Spectre way.
</p>
