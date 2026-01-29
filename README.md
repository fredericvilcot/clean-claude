# Spectre Agents

**Reactive multi-agent system for [Claude Code](https://claude.ai/code), built on Software Craftsmanship.**

> **Code is a craft. Agents perfect it together.**

---

## What Makes Spectre Different

```
┌──────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│   🛠️  CRAFT                              🔄  REACTIVE                    │
│                                                                          │
│   Clean Architecture                     Self-correcting agents          │
│   DDD, SOLID, TDD/BDD                    Automatic error → fix loop      │
│   Type safety, no shortcuts              Shared memory & learnings       │
│   Pedagogy over speed                    Agents collaborate, not just    │
│                                          execute                         │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

**Other agent libraries** give you workflows. **Spectre** gives you a **team that learns**.

---

## Quick Start

### Install

```bash
# Linux/macOS
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/install.sh | bash

# Windows PowerShell
irm https://raw.githubusercontent.com/fvilcot/spectre-agents/main/install.ps1 | iex
```

Restart Claude Code after installation.

### Use

```bash
/build    # Build something new — adapts to your context
/heal     # Something's broken — auto-repair
```

That's it. Two commands for everything.

---

## The Two Commands

### `/build` — Build with Guidance

For building new features, the guide adapts to your work context.

### `/heal` — Auto-Repair

Something's broken? Just run `/heal`. Spectre detects the problem and fixes it.

```bash
/heal           # Detect and fix everything (code + specs)
/heal tests     # Fix failing tests
/heal build     # Fix build errors
/heal types     # Fix TypeScript errors
/heal spec      # Fix spec/implementation mismatch
```

**Code healing:**
```
🔍 Diagnosing...

Found 2 issues:
  ❌ Tests: 3 failing
  ❌ Types: 1 error

🔧 Healing...
  → software-craftsman fixed type error
  → frontend-dev fixed test

✅ Healed!
```

**Spec healing:**
```
🔍 Analyzing spec vs implementation...

Found 2 issues:
  ❌ Missing in code: "Remember me" checkbox
  ⚠️ Mismatch: Spec says "5 attempts", code has "3"

🔧 Healing...
  → product-owner updated spec
  → frontend-dev added missing feature

✅ Spec synced!
```

---

## How `/build` Works

### Step 1: Your Work Context

```
┌─────────────────────────────────────────────────────────────────┐
│  "What's your work context?"                                    │
│                                                                 │
│  [ Product Team / Enterprise ]                                  │
│    → Specs, process, reviews, compliance                        │
│                                                                 │
│  [ Startup / Small Team ]                                       │
│    → Fast iterations, ship & learn                              │
│                                                                 │
│  [ Freelance / Solo ]                                           │
│    → Efficient, minimal overhead                                │
│                                                                 │
│  [ Learning / Exploring ]                                       │
│    → No pressure, educational                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Step 2: What You Want to Do

```
┌─────────────────────────────────────────────────────────────────┐
│  "What do you want to do?"                                      │
│                                                                 │
│  [ Build something new ]    [ Fix something ]                   │
│  [ Improve existing code ]  [ Think / Design ]                  │
└─────────────────────────────────────────────────────────────────┘
```

### Step 3: Context-Specific Questions

The questions adapt to your context:

| Context | Questions |
|---------|-----------|
| **Product Team** | "Do you have a PRD?" "What part of the system?" |
| **Startup** | "How clear are the requirements?" "Frontend/Backend?" |
| **Freelance** | "What stack?" "Testing?" |
| **Learning** | "What area?" → Suggests craft skill |

### Step 4: Agents Start Working

Spectre shows the plan and launches the right agents:

```
## Workflow for: User Authentication

Context: Product Team / Enterprise
Input: PRD provided

Pipeline:
┌────────────┐    ┌────────────┐    ┌────────────┐    ┌────────────┐
│ Architect  │ ─▶ │ backend-   │ ─▶ │ frontend-  │ ─▶ │    QA      │
│            │    │    dev     │    │    dev     │    │            │
└────────────┘    └────────────┘    └────────────┘    └─────┬──────┘
                                          ▲                  │
                                          └── fix & retry ───┘

Starting...
```

---

## Workflows by Context

### 🏢 Product Team / Enterprise

Full process with specs, design reviews, and compliance.

| Input | Workflow |
|-------|----------|
| PRD / Feature Spec | `Architect → Dev → QA` |
| User Story (needs refinement) | `PO → Architect → Dev → QA` |
| Just a Concept | `PO (full spec) → Architect → Dev → QA` |

**Always includes:** Architecture review, comprehensive testing, documentation.

### 🚀 Startup / Small Team

Fast iterations, ship and learn.

| Clarity | Workflow |
|---------|----------|
| Crystal Clear | `Dev → QA` |
| Mostly Clear | `Architect (quick) → Dev → QA` |
| Rough Idea | `Architect → Dev → QA` |

**Skips:** PO (you are the PO), heavy process.
**Keeps:** Quality (QA always included).

### 💼 Freelance / Solo

Maximum efficiency, minimal overhead.

| Testing | Workflow |
|---------|----------|
| Yes | `Dev → QA` |
| No | `Dev` alone |

**Focus:** Get it done right, fast.

### 📚 Learning / Exploring

Educational mode, no pressure.

| Area | Suggestion |
|------|------------|
| Frontend/React | `/react-craft` |
| Backend/API | Architect guidance |
| Architecture | `software-craftsman` |
| Testing | `/test-craft` |

---

## The Reactive Loop

What makes Spectre unique: **agents that fix their own mistakes**.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         SPECTRE REACTIVE LOOP                           │
│                                                                         │
│    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐        │
│    │ Product  │ ─▶ │ Software │ ─▶ │ Frontend │ ─▶ │    QA    │        │
│    │  Owner   │    │ Craftsman│    │   Dev    │    │ Engineer │        │
│    └──────────┘    └──────────┘    └──────────┘    └────┬─────┘        │
│                                          ▲               │              │
│                                          │    error      │              │
│                                          └───────────────┘              │
│                                             fix & retry                 │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

1. **QA runs tests** → finds error
2. **Dev agent spawns** automatically with error context
3. **Dev fixes** the issue
4. **QA re-verifies** automatically
5. **Loop until success** (max 3 retries)

---

## Agents

Specialized experts that `/build` orchestrates for you.

| Agent | Role | Expertise |
|-------|------|-----------|
| **software-craftsman** | 🏗️ Architect | Clean Architecture, DDD, SOLID, TDD/BDD |
| **product-owner** | 📋 Product | User stories, acceptance criteria, PRD refinement |
| **frontend-dev** | ⚛️ Frontend | React, accessibility, state management, testing |
| **backend-dev** | 🔧 Backend | APIs, services, data layer, integration |
| **qa-engineer** | 🧪 Quality | Test strategy, TDD/BDD, test pyramid, coverage |

---

## Craft Skills

Apply excellence to specific areas:

| Skill | What It Does |
|-------|--------------|
| `/typescript-craft` | Strict typing, algebraic types, Result types, pure functions |
| `/react-craft` | Component design, hooks patterns, accessibility, testing |
| `/test-craft` | TDD/BDD workflow, test pyramid, proper mocks |
| `/init-frontend` | Bootstrap React + Vite + TypeScript + Vitest project |

---

## Philosophy

### 🛠️ Craft Principles

| Principle | What It Means |
|-----------|---------------|
| **Domain First** | Business logic at the center, frameworks at the periphery |
| **Type Safety** | Types are documentation and safety net |
| **Explicit > Implicit** | No magic, no silent failures |
| **Test-Driven** | Tests are specifications |
| **Pedagogy** | Explain the "why" before the "how" |

### 🔄 Reactive Principles

| Principle | What It Means |
|-----------|---------------|
| **Auto-Correction** | Errors trigger fixes automatically |
| **Shared Memory** | Agents communicate through shared state |
| **Learning** | Successful fixes become patterns |
| **Bounded Retry** | Max 3 attempts, then ask for help |

---

## Installation

### From Source

```bash
git clone https://github.com/fvilcot/spectre-agents.git
cd spectre-agents
./install.sh  # or .\install.ps1 on Windows
```

### Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/uninstall.sh | bash
```

---

## Documentation

- **[Architecture Guide](docs/ARCHITECTURE.md)** — Full technical documentation
- **[CLAUDE.md](CLAUDE.md)** — Instructions for Claude Code

---

## License

BSD 3-Clause

---

<p align="center">
  <strong>Code is a craft. Agents perfect it together.</strong>
</p>
