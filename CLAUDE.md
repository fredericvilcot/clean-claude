# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Spectre Agents** is a reactive multi-agent system for Claude Code, built on Software Craftsmanship principles.

> **Code is a craft. Agents perfect it together.**

## Usage

### Two Commands

```bash
/guide    # Build something — adapts to your context
/heal     # Fix something — auto-repair
```

### `/heal` — Auto-Repair

```bash
/heal           # Detect and fix everything broken
/heal tests     # Fix failing tests
/heal build     # Fix build errors
/heal types     # Fix TypeScript errors
```

Diagnoses → Fixes → Verifies → Loops until healed.

### `/guide` — Guided Build

Spectre adapts to your work context and configures the right agents.

### The Flow

```
/guide
   │
   ├─→ "What's your work context?"
   │      [ Product Team ]  → Full process, specs, compliance
   │      [ Startup ]       → Fast iterations, ship & learn
   │      [ Freelance ]     → Efficient, minimal overhead
   │      [ Learning ]      → Educational, no pressure
   │
   ├─→ "What do you want to do?"
   │      [ Build ] [ Fix ] [ Improve ] [ Think ]
   │
   ├─→ Context-specific questions...
   │
   └─→ Agents start working
```

### Workflows by Context

| Context | Build Workflow |
|---------|----------------|
| **Product Team** | `PO → Architect → Dev → QA` (full spec, reviews) |
| **Startup** | `Dev → QA` or `Architect → Dev → QA` (fast, quality) |
| **Freelance** | `Dev` or `Dev → QA` (efficient) |
| **Learning** | Single agent or craft skill (educational) |

## Core Philosophy

### 🛠️ CRAFT

| Principle | Meaning |
|-----------|---------|
| **Domain First** | Business logic at the center |
| **Type Safety** | Types as safety net and documentation |
| **Explicit > Implicit** | No silent exceptions, no magic |
| **Test-Driven** | Tests are executable specifications |
| **Pedagogy** | Explain the "why" before the "how" |

### 🔄 REACTIVE

```
QA finds error ──▶ Dev fixes ──▶ QA verifies
      ▲                              │
      └──────────── retry ◀──────────┘

Agents collaborate. Errors trigger fixes. Automatically.
```

## Agents

| Agent | Role | Expertise |
|-------|------|-----------|
| **software-craftsman** | Architect | Clean Architecture, DDD, SOLID, TDD/BDD |
| **product-owner** | Product | User stories, acceptance criteria |
| **frontend-dev** | Frontend | React, accessibility, testing |
| **backend-dev** | Backend | APIs, services, data layer |
| **qa-engineer** | Quality | Test strategy, TDD/BDD |

## Craft Skills

| Skill | Description |
|-------|-------------|
| `/typescript-craft` | Strict typing, algebraic types, pure functions |
| `/react-craft` | Component design, hooks, accessibility |
| `/test-craft` | TDD/BDD, test pyramid |
| `/init-frontend` | Bootstrap React + Vite + TypeScript project |

## Structure

```
spectre-agents/
├── .claude/
│   ├── agents/           # Agent definitions
│   └── skills/           # Skill definitions
├── scripts/              # Reactive system hooks
└── docs/
    └── ARCHITECTURE.md   # Full technical documentation
```

---

**Full documentation**: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
