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

<p align="center">
  <img src="https://img.shields.io/badge/craft-first-8A2BE2?style=flat-square" alt="Craft First"/>
  <img src="https://img.shields.io/badge/reactive-agents-9400D3?style=flat-square" alt="Reactive"/>
  <img src="https://img.shields.io/badge/auto-learning-8B008B?style=flat-square" alt="Auto-learning"/>
</p>

---

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/fredericvilcot/spectre-agents/main/install.sh | bash
```

Restart Claude Code. Done.

---

## Three Commands

```bash
/craft    # Build with the right agent team
/heal     # Auto-fix everything
/learn    # Adapt to YOUR patterns
```

---

## What is Spectre?

Spectre is built on **three pillars**:

### 1. Craft First

No code without craft. Every agent enforces:
- **Strict TypeScript** — No `any`, types are documentation
- **Result Types** — `Result<T, E>` not `throw`, explicit errors
- **Clean Architecture** — Domain at center, hexagonal structure
- **Test-Driven** — Tests are executable specifications

### 2. Reactive Collaboration

Agents don't just execute — they **react** to each other:
- QA finds bug → routes to Dev → Dev fixes → QA re-verifies
- Violation detected → triggers Architect → proposes refactoring
- Spec unclear → escalates to PO → PO clarifies

No blocking. No waiting. Continuous feedback loop.

### 3. Auto-Learning

Spectre learns YOUR codebase:
- Detects your stack, patterns, conventions
- Adapts all agents to follow YOUR style
- Guards against violations of YOUR standards

---

## `/craft` — Build Features

Smart workflow that adapts to your input.

### Rule: No Spec = No Code

Nothing gets implemented without contracts:

| Contract | Owner | Purpose |
|----------|-------|---------|
| `.spectre/spec.md` | PO | Functional spec (user story, criteria, edge cases) |
| `.spectre/design.md` | Architect | Technical spec (files, patterns, tests) |

Dev and QA implement `design.md` **exactly**. No improvisation.

### Smart Routing

| Your Input | What Happens |
|------------|--------------|
| "a sexy counter" | PO creates spec → Architect designs → Dev ⇄ QA |
| Jira ticket | PO fetches + creates spec → Architect → Dev ⇄ QA |
| `spec.md` file | Architect designs → Dev ⇄ QA |
| "Fix the bug" | Dev → QA |

### Parallel Execution

Dev and QA work **together**:
- Dev implements while QA writes tests
- QA runs tests as Dev completes files
- Failures route back instantly

---

## `/heal` — Auto-Repair

Routes problems to the right expert:

```bash
/heal           # Fix all
/heal tests     # Fix failing tests
/heal types     # Fix TypeScript errors
```

| Problem | Expert |
|---------|--------|
| Test failure | Dev |
| Type error | Architect |
| Design flaw | Architect |
| Spec gap | PO |

---

## `/learn` — Adapt

Learns your codebase, detects violations:

```bash
/learn              # Full scan
/learn --only src/  # Specific path
```

On violations → triggers Architect with refactoring plan.
Reactive, not punitive.

---

## The Agents

| Agent | Role |
|-------|------|
| **learning-agent** | Pattern detection, violations |
| **product-owner** | Specs, acceptance criteria |
| **architect** | Design, code review |
| **frontend-engineer** | React, UI, accessibility |
| **backend-engineer** | APIs, services |
| **qa-engineer** | Tests, verification |

---

## Reactive Mesh

```
Learning Agent ─── violation ───▶ Architect
                                      │
Product Owner ◀─── contradiction ─────┤
     │                                │
spec_gap ◀─── Dev              design ┘
unclear  ◀─── QA               review ───▶ Dev
     │                                    │
     ▼                                    ▼
┌─────────┐                        ┌───────────┐
│   Dev   │◀─── test_failure ──────│    QA     │
└─────────┘                        └───────────┘
```

---

<p align="center">
  <img src="https://img.shields.io/badge//%20craft-8A2BE2?style=for-the-badge" alt="/craft"/>
  <img src="https://img.shields.io/badge//%20heal-9400D3?style=for-the-badge" alt="/heal"/>
  <img src="https://img.shields.io/badge//%20learn-9932CC?style=for-the-badge" alt="/learn"/>
</p>

<p align="center">
  <strong>Spectre learns. Spectre adapts. Spectre crafts.</strong>
</p>

---

<p align="center">
  <sub>BSD 3-Clause License</sub>
</p>
