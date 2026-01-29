# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Spectre Agents** is a reactive multi-agent system for Claude Code, built on Software Craftsmanship principles.

> **Code is a craft. Agents perfect it together.**

## Core Philosophy

### 🛠️ CRAFT — Excellence Without Compromise

Every agent embodies:

| Principle | Meaning |
|-----------|---------|
| **Domain First** | Business logic at the center, frameworks at the periphery |
| **Type Safety** | The type system as safety net and living documentation |
| **Explicit > Implicit** | No silent exceptions, no magic, no guessing |
| **Test-Driven** | Tests are executable specifications |
| **Pedagogy** | Explain the "why" before the "how" |

### 🔄 REACTIVE — Self-Correcting Agents

What makes Spectre different:

```
┌────────────────────────────────────────────────────────────┐
│                    REACTIVE LOOP                           │
│                                                            │
│   QA finds error ──▶ Dev fixes ──▶ QA verifies             │
│         ▲                              │                   │
│         └──────────── retry ◀──────────┘                   │
│                                                            │
│   Agents collaborate. Errors trigger fixes. Automatically. │
└────────────────────────────────────────────────────────────┘
```

- **Auto-correction**: QA error → Dev spawns automatically with context
- **Shared memory**: `.spectre/` stores state, errors, learnings
- **Learning**: Successful fixes become patterns for future errors
- **Retry logic**: Max 3 attempts before asking for help

## Structure

```
spectre-agents/
├── .claude/
│   ├── agents/           # Agent definitions
│   └── skills/           # Skill definitions
├── scripts/              # Reactive system hooks
├── templates/            # Project setup templates
└── docs/
    └── ARCHITECTURE.md   # Full technical documentation
```

## Agents — Specialized Experts

| Agent | Role | Expertise |
|-------|------|-----------|
| **software-craftsman** | Architect | Clean Architecture, DDD, SOLID, TDD/BDD |
| **product-owner** | Product | User stories, acceptance criteria, prioritization |
| **frontend-dev** | Implementation | React, accessibility, state management, testing |
| **qa-engineer** | Quality | Test strategy, TDD/BDD, test pyramid |
| **orchestrator** | Coordination | Reactive loop, routing, retry, learnings |

## Skills — Invocable Capabilities

### Craft Skills
| Skill | Description |
|-------|-------------|
| `/typescript-craft` | Strict typing, algebraic types, Result types, pure functions |
| `/react-craft` | Component design, hooks, accessibility, testing |
| `/test-craft` | TDD/BDD, test pyramid, proper test doubles |

### Workflow Skills
| Skill | Description |
|-------|-------------|
| `/guide` | **Interactive guided mode — start here if unsure** |
| `/init-frontend` | Bootstrap React + Vite + TypeScript + Vitest project |
| `/feature` | Complete workflow: PO → Architect → Dev → QA |
| `/reactive-loop` | **Start the self-correcting agent loop** |
| `/agent` | **Start any agent with optional reactive links** |
| `/setup-reactive` | Configure reactive system in your project |

## The `/guide` Flow

Interactive mode that translates your need into the right agent configuration:

```
/guide
   │
   ├─→ "What's your situation?"
   │      [ Build ] [ Fix ] [ Improve ] [ Think ]
   │
   ├─→ "Where are you starting from?" (if Build)
   │      [ User need ] [ Know what to build ] [ Just code it ]
   │
   ├─→ "What part of the app?"
   │      [ UI ] [ Backend ] [ Both ]
   │
   ├─→ "Should this be tested?"
   │      [ Yes ] [ No (prototype) ]
   │
   └─→ "Describe what you want to build"
          → Launches the right agent chain
```

**Mapping:**
| Starting Point | Result |
|----------------|--------|
| User need + UI + Tested | `PO → Architect → frontend-dev → QA` |
| Know what to build + UI + Tested | `Architect → frontend-dev → QA` |
| Just code it + UI + Tested | `frontend-dev ↔ QA` |

## Reactive System

### Setup
```bash
/setup-reactive    # In your project
```

### Usage
```bash
/reactive-loop     # Full workflow: PO → Arch → Dev → QA with auto-correction

# Or start specific agents with links
/agent frontend-dev --link qa-engineer           # Dev + QA reactive loop
/agent arch --link front,qa --task "Build login" # Architect + Dev + QA
```

### How It Works

1. **Define** — Product Owner creates user story
2. **Design** — Software Craftsman designs solution
3. **Implement** — Frontend Dev builds it
4. **Verify** — QA Engineer tests it
5. **Fix Loop** — If errors: Dev fixes → QA re-verifies (up to 3x)
6. **Learn** — Successful fixes become patterns

### Shared State (`.spectre/`)
```
.spectre/
├── state.json        # Current workflow phase
├── errors.jsonl      # Error history
├── learnings.jsonl   # Patterns from fixes
└── context.json      # Feature context
```

## Component Format

### Agents (`.claude/agents/*.md`)
```yaml
---
name: agent-name
description: "When to use this agent..."
model: opus | sonnet | haiku
color: purple | blue | green
---

# System Prompt
```

### Skills (`.claude/skills/<name>/SKILL.md`)
```yaml
---
name: skill-name
description: "What this skill does"
context: fork | conversation
agent: executing-agent
allowed-tools: Read, Write, Edit, Bash
---

# Skill Instructions
```

## Extending Spectre

When creating new components:

1. **Embody Craft** — No shortcuts, explicit over clever
2. **Enable Reactivity** — Can it participate in the feedback loop?
3. **Teach** — Explain decisions, guide toward excellence
4. **Learn** — Record patterns that work

---

**Full documentation**: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
