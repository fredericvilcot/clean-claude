# Spectre Agents

Craft-oriented agents and skills for [Claude Code](https://claude.ai/code).

Every component embodies Software Craftsmanship principles: Clean Architecture, DDD, SOLID, TDD/BDD, and uncompromising technical excellence.

## Installation

### Quick Install (Linux/macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/install.sh | bash
```

### Quick Install (Windows PowerShell)

```powershell
irm https://raw.githubusercontent.com/fvilcot/spectre-agents/main/install.ps1 | iex
```

### From Source

```bash
git clone https://github.com/fvilcot/spectre-agents.git
cd spectre-agents
./install.sh  # or .\install.ps1 on Windows
```

After installation, **restart Claude Code** to load the new components.

## Components

### Agents

| Agent | Description |
|-------|-------------|
| **software-craftsman** | Software architect expert in Clean Architecture, DDD, Hexagonal, SOLID, TDD/BDD. Analyzes, designs, and reviews code with a pedagogical approach. |
| **product-owner** | Product expert who transforms vague ideas into clear user stories with acceptance criteria. Prioritizes by value, defines MVP scope. |
| **frontend-dev** | Frontend specialist building accessible, performant, maintainable UIs. Expert in React, state management, component testing. |
| **qa-engineer** | Quality expert designing test strategies, writing tests at all levels (unit, integration, e2e), ensuring confidence in the codebase. |
| **orchestrator** | Conductor of the reactive multi-agent system. Coordinates agents, manages feedback loops, handles errors and retries automatically. |

### Skills

| Skill | Description |
|-------|-------------|
| **/typescript-craft** | Applies craft principles to TypeScript: strict typing, algebraic types, immutability, pure functions, Result types, layer separation. |
| **/react-craft** | Applies craft principles to React: component design, hooks, state management, accessibility, and testing. |
| **/test-craft** | TDD/BDD testing principles: test pyramid, behavior-driven tests, proper test doubles, maintainable test suites. |
| **/init-frontend** | Bootstraps a new frontend project with craft setup: React + Vite + TypeScript + Vitest + clean architecture. |
| **/feature** | Complete feature workflow: PO → Architect → Dev → QA. Creates user story, technical design, implementation, and QA verification. |
| **/reactive-loop** | Start the reactive multi-agent loop. Agents auto-collaborate: QA finds errors → Dev fixes → QA verifies → repeat until success. |
| **/setup-reactive** | Set up the Spectre Reactive System in your project (hooks, shared state, scripts). |

## Usage

### Using the software-craftsman agent

The agent is automatically available when Claude Code detects tasks matching its expertise:
- Designing new features with proper architecture
- Reviewing code for quality and maintainability
- Implementing design patterns
- Writing or improving tests (TDD/BDD)
- Refactoring legacy code

### Using skills

Invoke skills directly in Claude Code:

```
/typescript-craft
```

## Uninstallation

```bash
# Linux/macOS
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/uninstall.sh | bash

# Or from cloned repo
./uninstall.sh
```

## Reactive Multi-Agent System

**What makes Spectre Agents different**: a self-correcting feedback loop where agents collaborate automatically.

```
┌─────────────────────────────────────────────────────────────┐
│                    SPECTRE REACTIVE LOOP                    │
│                                                             │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌───────┐ │
│  │ Product  │ ─▶ │ Software │ ─▶ │ Frontend │ ─▶ │  QA   │ │
│  │  Owner   │    │ Craftsman│    │   Dev    │    │Engineer│ │
│  └──────────┘    └──────────┘    └──────────┘    └───┬───┘ │
│                                        ▲              │     │
│                                        │    error     │     │
│                                        └──────────────┘     │
│                                           fix & retry       │
└─────────────────────────────────────────────────────────────┘
```

### How It Works

1. **QA runs tests** and finds an error
2. **Hook triggers** and captures the error context
3. **Dev agent spawns** automatically with error details
4. **Dev fixes** the issue
5. **QA re-verifies** automatically
6. **Loop continues** until all tests pass (or max retries)

### Shared Memory

Agents communicate through `.spectre/`:
- `state.json` — Current workflow state
- `errors.jsonl` — Error history with resolutions
- `learnings.jsonl` — Patterns learned from fixes

### Setup in Your Project

```bash
/setup-reactive
```

Then start the loop:

```bash
/reactive-loop
```

### Key Features

- **Auto-correction**: Errors trigger fixes without human intervention
- **Learning**: Successful fixes become patterns for future errors
- **Retry limits**: Maximum 3 retries before asking for help
- **Full context**: Each agent receives relevant history and learnings

## Philosophy

> Code is a craft. We favor quality, readability, and maintainability over speed.

Every component is built on these principles:

1. **Domain First** — Business logic at the center, frameworks at the periphery
2. **Type Safety** — The type system as safety net and living documentation
3. **Explicit over Implicit** — Explicit error handling, no silent exceptions
4. **Test-Driven** — Tests as executable specifications
5. **Pedagogy** — Explain the "why" before the "how"

## License

BSD 3-Clause
