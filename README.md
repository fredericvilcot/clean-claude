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
# Don't know where to start? Use the guided mode
/guide

# Start a feature with the reactive loop
/reactive-loop

# Or start any agent with optional reactive links
/agent frontend-dev --link qa-engineer
/agent arch --link front,qa --task "Build login"

# Or use individual skills
/typescript-craft
/react-craft
/test-craft
```

---

## The Reactive Loop

This is what sets Spectre apart: **agents that fix their own mistakes**.

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
│    ┌────────────────────────────────────────────────────────────────┐  │
│    │  .spectre/                                                     │  │
│    │  ├── errors.jsonl    ← QA writes errors                        │  │
│    │  ├── learnings.jsonl ← Successful fixes become patterns        │  │
│    │  └── state.json      ← Workflow coordination                   │  │
│    └────────────────────────────────────────────────────────────────┘  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### How It Works

1. **QA runs tests** → finds error
2. **Hook captures** error context automatically
3. **Dev agent spawns** with full error details + past learnings
4. **Dev fixes** the issue
5. **QA re-verifies** automatically
6. **Loop until success** (max 3 retries)
7. **Learning recorded** for future reference

### Setup in Your Project

```bash
/setup-reactive    # Configure hooks and shared state
/reactive-loop     # Start building a feature
```

---

## Agents

Specialized experts, each with deep domain knowledge.

| Agent | Role | Expertise |
|-------|------|-----------|
| **software-craftsman** | 🏗️ Architect | Clean Architecture, DDD, Hexagonal, SOLID, TDD/BDD |
| **product-owner** | 📋 Product | User stories, acceptance criteria, prioritization, MVP |
| **frontend-dev** | ⚛️ Frontend | React, accessibility, state management, component testing |
| **qa-engineer** | 🧪 Quality | Test strategy, TDD/BDD, test pyramid, coverage |
| **orchestrator** | 🎯 Conductor | Reactive loop coordination, routing, retry logic |

---

## Skills

Invoke with `/skill-name` in Claude Code.

### Craft Skills — Apply Excellence

| Skill | What It Does |
|-------|--------------|
| `/typescript-craft` | Strict typing, algebraic types, Result types, pure functions, immutability |
| `/react-craft` | Component design, hooks patterns, accessibility, state management, testing |
| `/test-craft` | TDD/BDD workflow, test pyramid, proper mocks, behavior-driven tests |

### Workflow Skills — Build Features

| Skill | What It Does |
|-------|--------------|
| `/guide` | **Interactive guided mode — start here if unsure** |
| `/init-frontend` | Bootstrap React + Vite + TypeScript + Vitest with craft structure |
| `/feature` | Linear workflow: PO → Architect → Dev → QA (manual progression) |
| `/reactive-loop` | **Full reactive loop with auto-correction** |
| `/agent` | **Start any agent with optional reactive links** |
| `/setup-reactive` | Configure your project for the reactive system |

---

## The `/guide` Skill — Interactive Guided Mode

**Don't know where to start?** Just run `/guide` and answer a few questions. Spectre figures out the right agents for you.

### The Flow

```
/guide
   │
   ▼
┌─────────────────────────────────────────────────────────────────┐
│  "What's your situation?"                                       │
│                                                                 │
│  [ I want to build something ]    [ Something isn't working ]   │
│  [ I want to improve code ]       [ I need to think first ]     │
└─────────────────────────────────────────────────────────────────┘
                    │
                    ▼ (if "build")
┌─────────────────────────────────────────────────────────────────┐
│  "Where are you starting from?"                                 │
│                                                                 │
│  [ A user need or idea ]     → Full workflow with PO            │
│  [ I know what to build ]    → Architect designs first          │
│  [ Just need to code it ]    → Dev implements directly          │
└─────────────────────────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────────┐
│  "What part of the app?"                                        │
│                                                                 │
│  [ User interface ]    [ Backend / API ]    [ Both ]            │
└─────────────────────────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────────┐
│  "Should this be tested before shipping?"                       │
│                                                                 │
│  [ Yes, with automated tests ]    [ No, just a prototype ]      │
└─────────────────────────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────────┐
│  "Describe what you want to build:"                             │
│                                                                 │
│  > "Password reset via email"                                   │
└─────────────────────────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────────┐
│  ## Got it! Here's the plan:                                    │
│                                                                 │
│  product-owner → software-craftsman → frontend-dev → qa         │
│                                             ↑            │      │
│                                             └── error ───┘      │
│                                                                 │
│  Launching: /reactive-loop                                      │
└─────────────────────────────────────────────────────────────────┘
```

### How Your Answers Map to Agents

| Starting Point | Domain | Testing | Agents Chain |
|----------------|--------|---------|--------------|
| User need/idea | UI | Yes | `PO → Architect → frontend-dev → QA` |
| User need/idea | Backend | Yes | `PO → Architect → backend-dev → QA` |
| Know what to build | UI | Yes | `Architect → frontend-dev → QA` |
| Know what to build | Backend | Yes | `Architect → backend-dev → QA` |
| Just code it | UI | Yes | `frontend-dev ↔ QA` (loop) |
| Just code it | Backend | Yes | `backend-dev ↔ QA` (loop) |
| Any | Any | No | Single agent, no QA |

### Smart Shortcuts

Skip questions by providing context upfront:

```bash
/guide add login form       # Detected: build + UI
/guide fix failing tests    # Detected: broken + tests
/guide refactor auth        # Detected: improve + refactor
/guide how to design auth   # Detected: think + architecture
```

---

### The `/agent` Skill — Flexible Agent Linking

Start any agent and optionally connect it to others for reactive collaboration.

```bash
# Start frontend-dev alone (no reactive loop)
/agent frontend-dev

# Start frontend-dev linked to QA (reactive loop)
/agent frontend-dev --link qa-engineer

# Start architect linked to dev and QA with a task
/agent software-craftsman --link frontend-dev,qa-engineer --task "Build authentication"

# Shorthand names: front, back, arch, qa, po
/agent arch --link front,qa
```

**Link Behaviors:**
```
frontend-dev → qa-engineer:
  Dev works → QA verifies → error → Dev fixes → loop

software-craftsman → frontend-dev → qa-engineer:
  Architect designs → Dev implements → QA verifies → errors route back
```

---

## Philosophy

### 🛠️ Craft Principles

| Principle | What It Means |
|-----------|---------------|
| **Domain First** | Business logic at the center, frameworks at the periphery |
| **Type Safety** | Types are documentation and safety net |
| **Explicit > Implicit** | No magic, no silent failures, no guessing |
| **Test-Driven** | Tests are specifications, not afterthoughts |
| **Pedagogy** | Explain the "why" before the "how" |

### 🔄 Reactive Principles

| Principle | What It Means |
|-----------|---------------|
| **Auto-Correction** | Errors trigger fixes without human intervention |
| **Shared Memory** | Agents communicate through `.spectre/` state |
| **Learning** | Every successful fix becomes a pattern |
| **Bounded Retry** | Max 3 attempts, then ask for help |
| **Full Context** | Each agent receives relevant history |

---

## Documentation

- **[Architecture Guide](docs/ARCHITECTURE.md)** — Full technical documentation
- **[CLAUDE.md](CLAUDE.md)** — Instructions for Claude Code

---

## Installation Details

### From Source

```bash
git clone https://github.com/fvilcot/spectre-agents.git
cd spectre-agents
./install.sh  # or .\install.ps1 on Windows
```

### What Gets Installed

```
~/.claude/
├── agents/
│   ├── software-craftsman.md
│   ├── product-owner.md
│   ├── frontend-dev.md
│   ├── qa-engineer.md
│   └── orchestrator.md
└── skills/
    ├── typescript-craft/
    ├── react-craft/
    ├── test-craft/
    ├── init-frontend/
    ├── feature/
    ├── reactive-loop/
    ├── agent/
    ├── guide/
    └── setup-reactive/
```

### Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/uninstall.sh | bash
```

---

## License

BSD 3-Clause

---

<p align="center">
  <strong>Code is a craft. Agents perfect it together.</strong>
</p>
