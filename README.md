<p align="center">
  <img src="https://img.shields.io/badge/CLEAN-CLAUDE-blueviolet?style=for-the-badge&logo=ghost&logoColor=white" alt="Clean Claude"/>
</p>

<h1 align="center">Stop prompting. Start crafting.</h1>

<p align="center">
  <em>Clean Claude transforms Claude Code into a team of Software Craft experts<br/>
  for modern React frontends.<br/>
  TypeScript + React + TanStack Query. Hexagonal. Result types. Tested.<br/>
  All agents collaborate reactively.</em>
</p>

<p align="center">
  <a href="#philosophy">Philosophy</a> •
  <a href="#agents">Agents</a> •
  <a href="#visual-context-optional">Visual Context</a> •
  <a href="#mandatory-stack">Mandatory Stack</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#commands">Commands</a> •
  <a href="#hooks">Hooks</a> •
  <a href="#documentation">Documentation</a>
</p>

---

## Philosophy

**Clean Claude isn't a tool. It's a philosophy — applied to modern React frontends.**

We believe frontend code is a **craft**, not just UI. Every agent embodies the teachings of the masters:

| Master | Teaching |
|--------|----------|
| **Dan Abramov** | Thinking in React, composition over configuration |
| **Kent C. Dodds** | Testing Library — *"Test like a user, not like a developer"* |
| **Kent Beck** | *"Make it work, make it right, make it fast"* |
| **Uncle Bob** | Clean Code, SOLID, Clean Architecture |
| **Martin Fowler** | Refactoring — *"Good programmers write code humans understand"* |
| **Eric Evans** | Domain-Driven Design |
| **Alistair Cockburn** | Hexagonal Architecture (Ports & Adapters) |

### The Non-Negotiables

```
Explicit types     → Types document intent (strict TypeScript, no `any`)
Explicit errors    → Errors are values, not surprises (Result<T,E>, no `throw`)
Single purpose     → Small, focused units
Always tested      → Tests are specs that run (BDD, colocated)
Spec first         → Think before you code
Domain isolation   → Business logic stays pure (no framework imports)
```

---

## Agents

Six specialized agents. Claude orchestrates them directly via `Task()`.

| Agent | Role | Output |
|-------|------|--------|
| **Product Owner** | Turns ideas into specs | `specs/functional/` |
| **Architect** | Stack skills + technical design | `specs/design/`, `specs/stack/` |
| **Frontend Engineer** | UI + unit tests (BDD) | Code + `*.test.tsx` |
| **Backend Engineer** | API + unit tests (BDD) | Code + `*.test.ts` |
| **QA Engineer** | E2E / Integration tests | `e2e/` |
| **DevOps Engineer** | Ship, CI/CD, deploy, publish, monitor | Pipelines, Docker, npm |

### Reactive Loop

Agents don't work in isolation. They **notify each other**:

```
QA finds bug       →  Dev fixes automatically
Dev needs clarity  →  Architect explains
Design flaw        →  Architect updates
Spec unclear       →  PO clarifies
CI/CD fails        →  DevOps routes to owning agent
Dev fixes code     →  DevOps re-runs pipeline
```

**Zero manual intervention. The right agent handles it.**

### Design Conformity

Dev agents implement the Architect's design with **zero deviation**:

- File paths, type names, function signatures = **exactly** as designed
- No invented files, no dead code, no extra abstractions
- 100% of the Implementation Checklist, no more, no less
- Something missing? Notify Architect — never invent

### How It Works

```
/craft "add dark mode"
     │
     ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│     PO      │────▶│  ARCHITECT  │────▶│  DEV + QA   │
│   (spec)    │     │  (design)   │     │ (parallel)  │
└─────────────┘     └─────────────┘     └─────────────┘
                                               │
                                               ▼
                                     ┌─────────────────┐
                                     │     VERIFY      │
                                     │  test + build   │
                                     │   → fix loop    │
                                     └─────────────────┘
                                               │
                                               ▼
                                     ┌─────────────────┐
                                     │     DEVOPS      │
                                     │  CI/CD + ship   │
                                     │  deploy + publish│
                                     └─────────────────┘
                                               │
                                               ▼
                                        ✅ All green
```

**DevOps in the loop:** During verify, CI/CD failures route to DevOps who parses logs and dispatches — test failures back to Dev, type errors to Architect, E2E failures to QA. Shipping is **on-demand** — you can iterate without shipping. When you're ready, say "commit", "push", or "create a PR" and DevOps handles it with conventional commits.

### Git = DevOps (Mandatory)

Any git operation goes through the DevOps agent. No exceptions.

```
"commit this"        →  DevOps: conventional commit + pre-commit checks
"push"               →  DevOps: push with safety checks
"create a PR"        →  DevOps: branch + PR via gh
"tag" / "release"    →  DevOps: version + changelog + publish
```

DevOps enforces **conventional commits** (`feat:`, `fix:`, `refactor:`, etc.) and verifies tests are green before every commit. Claude never runs git commands directly.

---

## Mandatory Stack

Clean Claude is built **exclusively** for modern frontend crafting:

```
TypeScript + React + TanStack Query
```

This is the only supported stack. No exceptions, no configuration.

| Required | Why |
|----------|-----|
| **TypeScript** | Types are documentation. No `any`, no escape hatches. |
| **React** | Component architecture, composition, hooks. |
| **TanStack Query** | Server state done right. No `useEffect` + `fetch`. |

**Enforced at 3 levels:**
1. `guard-stack.sh` hook blocks all agents if dependencies are missing
2. CRAFT Guardian blocks stack-change requests at prompt level
3. `craft-lint.sh` hook catches anti-patterns on every file write

> Don't have a project yet? `/craft` will propose to bootstrap one for you.

---

## Quick Start

### Prerequisites

[Claude Code CLI](https://docs.anthropic.com/claude-code) must be installed:

```bash
npm install -g @anthropic-ai/claude-code
```

### Installation

```bash
curl -fsSL https://raw.githubusercontent.com/fredericvilcot/clean-claude/main/install.sh | bash
```

That's it. Start with `/craft`.

---

## Commands

Three commands. That's all you need.

### `/craft` — Build something

```bash
/craft
```

**The Flow:**

```
Step 1  DETECT         Scan project, validate stack (TS + React + TanStack)
Step 2  SCOPE          If monorepo → which workspace?
Step 3  CHOOSE         What do you want? + describe it
Step 4  QA CONFIG      E2E tests in addition to unit tests?
Step 5a PRODUCT OWNER  Functional spec (if new feature / user-facing bug)
Step 5b ARCHITECT      Stack skills + technical design (hexagonal)
Step 5c DEV + QA       Implementation in parallel waves
Step 6  VERIFY         Tests + build → fix loop until green (CI failures → DevOps)
Step 7  CAPTURE        Save as architecture reference (if first feature)
Step 8  ITERATE        Session stays active — bugs/changes routed to agents
                       Git operations (commit/push/PR) → DevOps on demand
```

**Smart routing — free text works:**

| You say | Route | Why |
|---------|-------|-----|
| "Add dark mode" | PO → Arch → Dev | New feature needs spec |
| "Login doesn't work" | PO → Arch → Dev | User-facing bug needs spec |
| "Memory leak in cart" | Arch → Dev | Technical bug, no spec needed |
| "Migrate to Result types" | Arch → Dev | Refactor, no spec needed |
| "Add E2E tests" | QA directly | Tests only |
| "Set up CI pipeline" | DevOps directly | Infrastructure only |
| "Publish to npm" | DevOps directly | Ship only |

### `/heal` — Fix something

```bash
/heal           # Full diagnostic
/heal tests     # Focus on test failures
/heal types     # Focus on TypeScript errors
```

Routes each problem to the right expert:
- Test failing → Developer
- Type error → Architect
- Spec unclear → Product Owner
- CI/CD failure → DevOps Engineer
- Docker/publish error → DevOps Engineer

### `/learn` — Adapt to your codebase

```bash
/learn                    # Detect stack + validate CRAFT
/learn stack              # Stack detection only
/learn architecture       # Extract patterns from code
/learn <url|path>         # Analyze external source
```

---

## Hooks

Clean Claude enforces CRAFT principles through **4 hooks** that run automatically:

| Hook | Trigger | What it does |
|------|---------|--------------|
| `guard-stack.sh` | `PreToolUse` on `Task` | Blocks all agents if project isn't React + TS + TanStack Query |
| `craft-lint.sh` | `PostToolUse` on `Write\|Edit` | Catches anti-patterns on every file write (~15 rules) |
| `inject-craft-rules.sh` | `SubagentStart` on all agents | Injects CRAFT rules into every agent's context |
| `block-file-exploration.sh` | `PreToolUse` on `Bash` | Blocks `find`, `grep`, `cat`, etc. — forces `Read`/`Glob`/`Grep` |

### craft-lint.sh rules

**TypeScript:** no `any`, no `throw`, no `@ts-ignore`, no `as unknown as`

**React:** no `dangerouslySetInnerHTML`, no direct DOM, no `console.log` in production

**TanStack Query:** no `useEffect` + `fetch`, no `useState` + `useEffect` + `fetch`

**Architecture:** no framework imports in `domain/`

**Custom rules:** optional overlay via `.clean-claude/craft-rules.json`

> Test files (`*.test.ts`, `*.spec.ts`) are excluded from production-only rules.

---

## Architecture

Clean Claude enforces **Hexagonal Architecture** adapted to the frontend stack:

```
┌─────────────────────────────────────────────┐
│              INFRASTRUCTURE                  │
│   (HTTP, APIs, storage — replaceable)       │
│  ┌───────────────────────────────────────┐  │
│  │            APPLICATION                 │  │
│  │    (TanStack hooks = use cases)       │  │
│  │  ┌─────────────────────────────────┐  │  │
│  │  │            DOMAIN               │  │  │
│  │  │   (Entities, Value Objects)     │  │  │
│  │  │        Pure. No deps.           │  │  │
│  │  └─────────────────────────────────┘  │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
         Dependencies point INWARD →
```

> For frontend with TanStack Query: hooks **are** the application layer. No dead `use-cases/` folder.

### Error Handling

Errors are **values**, not exceptions:

```
❌ BAD  — Caller doesn't know this can fail
   getUser(id) → User | throws

✅ GOOD — Error is explicit in the return type
   getUser(id) → Result<User, NotFoundError>
```

### Architecture Reference — Team Consistency

**First feature = reference for all future features.**

After implementing your first feature, Clean Claude asks:

```
"Implementation complete. Capture as architecture reference?"
```

If you accept, it creates an **architecture-reference** file that:
- Documents your folder structure, naming conventions, patterns
- Becomes **mandatory** for all future features
- Keeps your team (humans or AI) consistent

---

## Visual Context (Optional)

> **Your PO can now see.** Point it at a live app or a Figma design — it writes the spec from what it *sees*, not just what you describe.

```
Without Visual Context              With Visual Context
─────────────────────               ─────────────────────
You describe in words    →          You paste a URL
PO imagines what you mean           PO browses the actual page
Spec misses half the UI             Spec covers every button, form, flow
3 rounds of "that's not what I      First spec nails it
meant"
```

### Two MCP Servers, One Superpower

| MCP | What it does | Example |
|-----|-------------|---------|
| **Playwright** | Browse live apps, capture structure, handle auth | *"Analyze https://app.example.com/dashboard"* |
| **Figma** | Read designs, extract components, understand layout | *"Read the Figma for the new checkout flow"* |

### Setup (2 commands)

```bash
claude mcp add playwright -- npx @playwright/mcp@latest
claude mcp add --transport http figma https://mcp.figma.com/mcp
```

Or let the installer handle it — `install.sh` offers this as an optional step.

### How It Looks in /craft

```
/craft "Add dark mode"
  → "Do you have a reference?"
  → "I have a reference URL: https://example.com/settings"
  → PO browses the page, captures accessibility snapshot
  → Extracts: toggle, color scheme, user preferences
  → Writes spec based on what it SEES + what you DESCRIBE
  → Result: precise spec, first try
```

```
/craft "Redesign the checkout"
  → "I have a Figma design"
  → Paste Figma URL
  → PO reads components, layout hierarchy, user flows
  → Translates design intent into Given/When/Then criteria
  → No Figma details leak into the spec — purely functional
```

### Authentication

Playwright uses a **persistent browser profile** — log in once, stay logged in:

```
First visit:   Browser opens → you log in → cookies saved
Next visits:   Already authenticated → PO browses freely
Enterprise:    --extension mode → connects to your existing browser (SSO, VPN)
```

### Without MCP? No Problem

Visual Context is **optional**. Without Playwright/Figma, the PO works exactly as before — from your text description. No regression, no dependency.

---

## Monorepo Support

Clean Claude detects your project structure and adapts:

```
Single app?  → Direct stack detection, no extra questions
Monorepo?    → Ask which workspace to work on first
```

**Smart detection:**
- `package.json` workspaces
- `pnpm-workspace.yaml`
- `lerna.json`, `nx.json`, `turbo.json`

> Each workspace must have React + TypeScript + TanStack Query in its dependencies.

---

## Documentation

| Document | Description |
|----------|-------------|
| [CLAUDE.md](./CLAUDE.md) | Full operational rules and workflow |
| [Agents](./.claude/agents/) | Individual agent definitions |
| [Skills](./.claude/skills/) | Command implementations |
| [Hooks](./.claude/hooks/) | CRAFT enforcement hooks |

### Project Structure

```
specs/                          # COMMITTED — shared with team
├── functional/                 # PO specs (spec-v1.md, spec-v2.md...)
├── design/                     # Architect designs (design-v1.md...)
└── stack/                      # Stack skills (stack-skills.md)

.clean-claude/                  # GITIGNORED — operational only
├── context.json                # Detected stack + stackGuard cache
├── state.json                  # Session state (resume)
└── architecture-guide.md       # Project patterns (if captured)
```

---

## Why Clean Claude?

| Without | With Clean Claude |
|---------|-------------------|
| You prompt, you debug | Agents collaborate, QA verifies |
| Generic code | Follows YOUR architecture reference |
| `any` everywhere | Strict TypeScript, enforced by hooks |
| `throw new Error` | `Result<T, E>` everywhere |
| `useEffect` + `fetch` | TanStack Query, enforced by hooks |
| No architecture | Hexagonal, DDD, Clean |
| You are the QA | QA agent catches bugs in parallel |

---

<p align="center">
  <img src="https://img.shields.io/badge//%20craft-8A2BE2?style=for-the-badge" alt="/craft"/>
  <img src="https://img.shields.io/badge//%20heal-9400D3?style=for-the-badge" alt="/heal"/>
  <img src="https://img.shields.io/badge//%20learn-9932CC?style=for-the-badge" alt="/learn"/>
</p>

<p align="center">
  <strong>Modern React frontends, crafted right.</strong>
</p>

<p align="center">
  <sub>BSD 3-Clause License</sub>
</p>
