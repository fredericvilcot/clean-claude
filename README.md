<p align="center">
  <img src="https://img.shields.io/badge/SPECTRE-AGENTS-blueviolet?style=for-the-badge&logo=ghost&logoColor=white" alt="Spectre Agents"/>
</p>

<h1 align="center">SPECTRE AGENTS</h1>

<p align="center">
  <strong>Stop prompting. Start crafting.</strong>
</p>

<p align="center">
  <em>A reactive multi-agent system for <a href="https://claude.ai/code">Claude Code</a><br/>that engineers software, not just code.</em>
</p>

<p align="center">
  <a href="#why-spectre">Why</a> ·
  <a href="#install">Install</a> ·
  <a href="#craft">Craft</a> ·
  <a href="#heal">Heal</a> ·
  <a href="#learn">Learn</a> ·
  <a href="#the-team">Team</a>
</p>

---

## Why Spectre?

You've used AI coding tools. You know the pattern:

> *"Build me a login form"*
> → 200 lines of spaghetti
> → *"It doesn't work"*
> → 200 more lines
> → *"Now there are 2 bugs"*
> → You delete everything and write it yourself.

**What if AI worked like a real engineering team?**

With Spectre:
- The **Architect** designs the auth flow with proper security patterns
- The **Engineer** implements it with type-safe code and explicit error handling
- The **QA Engineer** tests it, finds edge cases, catches bugs
- When tests fail, the Engineer fixes them — automatically
- You get production-ready code. Tested. Architected. Clean.

That's the difference between *prompting* and *crafting*.

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/install.sh | bash
```

Restart Claude Code. Three commands. Infinite possibilities.

```
/craft    →  Build with the right team
/heal     →  Auto-fix everything
/learn    →  Adapt to your patterns
```

---

## Craft

> Build features with the right team for your context.

### Adapts to How You Work

```
> /craft

What's your work context?

  🏢 Product Team   →  Full workflow: specs, reviews, compliance
  🚀 Startup        →  Fast iterations, still architected
  💼 Freelance      →  Direct and efficient
  📚 Learning       →  Step-by-step explanations
```

Different contexts, different workflows. Product teams get specs and reviews. Startups get speed. Freelancers get efficiency. Learners get pedagogy.

### Any Stack. Full Precision.

**No static templates.** Spectre detects your *exact* stack and generates craft defaults on the fly.

```
> /craft

🔍 Detecting stack...

   package.json:
   → TypeScript 5.3 (strict)
   → React 18.2
   → React Query v5
   → Zustand
   → Zod
   → Vitest + Testing Library

🧠 Generating craft defaults...

   ✓ React Query patterns (query keys, mutations, optimistic updates)
   ✓ Zustand patterns (slices, selectors, domain separation)
   ✓ Zod validation at boundaries
   ✓ Testing Library + MSW patterns
   ✓ Anti-patterns to avoid

📦 Cached in .spectre/stack-defaults.md
```

Add a library? Change a version? Spectre regenerates. Your agents always have patterns specific to YOUR stack.

### From Scratch? Guided Setup.

```
> /craft

🆕 No project detected. What stack?

  ⚡ TypeScript + React
  🟢 TypeScript + Node
  🐹 Go
  🦀 Rust
  🐍 Python
  📝 Other (describe)

> TypeScript + React

Any preferences?

  [Full setup]           Vite + Vitest + TailwindCSS + strict TS
  [With state management] + Zustand + React Query
  [Minimal]              Just React + TypeScript

> Full setup

✅ Stack configured
🧠 Generating craft defaults...
📦 Ready to build

What do you want to create?
```

### Assembles the Right Team

```
> "User authentication with OAuth and magic links"

Assembling: Architect → Frontend Engineer → QA Engineer

🏗️ Architect designing...
   ✓ OAuth2 + PKCE flow
   ✓ Magic link with short-lived tokens
   ✓ Session management strategy

💻 Frontend Engineer implementing...
   ✓ Type-safe auth context
   ✓ Protected route wrapper
   ✓ Login/callback components

🧪 QA Engineer testing...
   ✓ 12 tests passing
   ✓ Edge cases covered
   ✓ Security scenarios verified

✅ Ready to ship.
```

---

## Heal

> Auto-fix everything. Tests, types, build, specs.

```bash
/heal           # Diagnose and fix whatever is broken
/heal tests     # Fix failing tests
/heal types     # Fix TypeScript errors
/heal build     # Fix build errors
/heal spec      # Sync spec with implementation
```

### Smart Routing

Spectre doesn't throw code at problems. It routes each issue to the right expert.

```
> /heal

🔍 Diagnosing...
   ❌ 3 tests failing
   ❌ 2 type errors

🏗️ Architect fixing type errors...
   → Missing branded type at API boundary
   ✓ Fixed

💻 Frontend Engineer fixing tests...
   → Error state not announced to screen readers
   ✓ Fixed

🧪 QA verifying...
   ✓ All tests pass
   ✓ Types clean
   ✓ Build successful

✅ Healed.
```

Test failures → Engineer who wrote the code
Type errors → Architect
Spec gaps → Product Owner
Design flaws → Architect

The right expert, every time.

---

## Learn

> Active by default. Adapts agents to YOUR conventions.

You don't need to run `/learn`. It happens automatically with `/craft` and `/heal`.

### Two-Phase Intelligence

**Phase 1: Stack Detection** — Always runs.
Even if your code needs work, Spectre knows your stack.

**Phase 2: Pattern Learning** — Learns your conventions.
But stops on violations. Bad patterns don't propagate.

```
🔍 Phase 1: Detecting stack...
   ✅ TypeScript + React + Vite

🔍 Phase 2: Learning patterns...
   ✅ Feature folders architecture
   ✅ Result types for errors
   ✅ Colocated tests
   ✅ Absolute imports with aliases

📦 Patterns cached for agents
```

### The Craft Guard

**Spectre never learns garbage.**

```
> /craft "Add user service"

🔍 Learning patterns...

🛑 CRAFT VIOLATIONS DETECTED

   src/services/UserService.ts:45
   → throw new Error('User not found')
   → Violates: Explicit Error Handling
   → Fix: Return Result<User, NotFoundError>

📋 Report: .spectre/violations-report.md

   Stack detected: ✅ TypeScript + React
   Patterns learned: ❌ Blocked (violations)
   Agents will use: Craft defaults

   [ 🔧 Fix violations ]  [ ⏭️ Continue anyway ]  [ 🛑 Stop ]
```

Your agents still know your stack. They just won't copy bad patterns — they'll use craft defaults instead.

### Manual Controls

```bash
/learn                  # Re-scan and refresh
/learn --only <path>    # Learn from specific folder only
/learn --off            # Disable auto-learning
/learn --on             # Re-enable (default)
/learn --show           # Show current learnings
/learn --reset          # Clear all learnings
```

---

## The Team

Six specialists. Deep expertise. Reactive collaboration.

**👤 Product Owner**
Transforms vague ideas into clear specs. User stories with acceptance criteria. Edge cases you forgot.

**🏗️ Architect**
Designs systems that scale. Clean Architecture. Domain-Driven Design. SOLID. Code review with teeth.

**💻 Frontend Engineer**
Builds interfaces users love. Accessible. Performant. Type-safe. Components that compose.

**⚙️ Backend Engineer**
APIs that are secure and fast. Explicit error handling. Proper validation. No `any`, no shortcuts.

**🧪 QA Engineer**
Tests that prove it works. TDD/BDD. Meaningful coverage. Catches bugs before users do.

**🎭 Orchestrator**
Coordinates the team. Routes problems to the right expert. Manages retries. Keeps the loop flowing.

---

## Reactive Links

Agents don't just work in sequence. They react to each other.

```
QA finds test failure    → Engineer fixes → QA re-verifies
QA finds design flaw     → Architect redesigns → Engineer updates → QA re-verifies
Engineer blocked         → Architect adjusts → Engineer continues
Architect finds spec gap → Product Owner clarifies
```

Every problem goes to the expert who can solve it. Automatically.

```
                    ┌─────────────┐
         clarify ───│   Product   │─── contradiction
         spec gap ──│    Owner    │◀── edge case
                    └──────┬──────┘
                           │
                           ▼
         blocked ──────┌─────────────┐────── design flaw
         by design ────│  Architect  │─────▶ code review
                       └──────┬──────┘
                              │
                    ┌─────────┴─────────┐
                    ▼                   ▼
             ┌───────────┐       ┌───────────┐
             │  Frontend │       │  Backend  │
             │  Engineer │       │  Engineer │
             └─────┬─────┘       └─────┬─────┘
                   └─────────┬─────────┘
                             ▼
                      ┌───────────┐
        test failure ◀│    QA     │
        re-verify ────│ Engineer  │
                      └───────────┘
```

---

## What Makes Spectre Different

| Traditional AI | Spectre |
|----------------|---------|
| One model, generic output | Specialized agents, expert output |
| Static prompts | Dynamic stack detection |
| Learns everything | Guards against anti-patterns |
| Fix it yourself | Self-correcting loops |
| Same for everyone | Adapts to your context |
| Generic patterns | YOUR stack, YOUR libs, YOUR conventions |

---

## Philosophy

**Domain First** — Business logic at the center. Frameworks at the edges. Your domain model is sacred.

**Type Safety** — Types are documentation that compiles. No `any`. No escape hatches. The compiler is your ally.

**Explicit Over Implicit** — No magic. No surprises. `Result<T, E>` over thrown exceptions. Code tells its story.

**Test-Driven** — Tests are specifications that run. Write the test first. Let it drive the design.

**Self-Correcting** — Agents catch their own mistakes. QA fails, Engineer fixes, QA verifies. Humans intervene only when needed.

**Adaptive** — Learns your patterns. Guards your standards. Evolves with your codebase.

---

## License

BSD 3-Clause

---

<p align="center">
  <code>/craft</code> · <code>/heal</code> · <code>/learn</code>
</p>

<p align="center">
  <strong>That's the Spectre way.</strong>
</p>
