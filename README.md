<p align="center">
  <img src="https://img.shields.io/badge/SPECTRE-AGENTS-blueviolet?style=for-the-badge&logo=ghost&logoColor=white" alt="Spectre Agents"/>
</p>

<h1 align="center">👻 SPECTRE AGENTS</h1>

<p align="center">
  <strong>Stop prompting. Start crafting.</strong>
</p>

<p align="center">
  <em>A reactive multi-agent system for <a href="https://claude.ai/code">Claude Code</a><br/>that learns, adapts, and delivers craft-ready code.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/auto--learning-enabled-8A2BE2?style=flat-square" alt="Auto-learning"/>
  <img src="https://img.shields.io/badge/reactive-loop-9400D3?style=flat-square" alt="Reactive"/>
  <img src="https://img.shields.io/badge/dynamic-injection-9932CC?style=flat-square" alt="Dynamic"/>
  <img src="https://img.shields.io/badge/craft-guard-8B008B?style=flat-square" alt="Craft Guard"/>
</p>

---

## 🎯 Craft First

Spectre isn't a code assistant. It's a **craft system**.

<table>
<tr>
<td width="50%">

### 😫 Prompting
```
"Build me a login"
      ↓
200 lines of code
Works... maybe
No tests
any everywhere
throw Error
      ↓
"Now debug this"
```

</td>
<td width="50%">

### 💎 Crafting
```
"Build me a login"
      ↓
Architect designs the flow
Engineer implements SOLID
QA verifies, loops on failure
Strict types, Result<T,E>
Explicit error handling
      ↓
Production-ready
```

</td>
</tr>
</table>

### ✨ Craft Principles

Every Spectre agent embodies these:

| | Principle | Application |
|-|-----------|-------------|
| 🏛️ | **Domain First** | Business logic at the center, frameworks at the edges |
| 🔒 | **Type Safety** | Strict mode, no `any`, the compiler is your ally |
| 📖 | **Explicit Errors** | `Result<T, E>` not `throw Error`, code tells its story |
| 🧪 | **Test-Driven** | Tests are executable specs, not an afterthought |
| 🏗️ | **Clean Architecture** | SOLID, DDD, Hexagonal — context-appropriate |

> **Spectre doesn't generate code. It crafts software.**

---

## 🔮 How It Works

Three mechanisms working together:

### 1️⃣ Auto-Learning

**Active by default.** Zero configuration.

```
🔍 Detects your exact stack
   → TypeScript 5.3 + React 18.2 + React Query v5 + Zustand + Zod

🧠 Learns your conventions (if code is clean)
   → Feature folders, Result types, absolute imports, colocated tests

🛡️ Craft Guard — rejects anti-patterns
   → throw Error? Blocked.
   → any everywhere? Blocked.
   → Report generated, you decide.
```

---

### 2️⃣ Dynamic Injection

**No static templates.** Skills generated for YOUR stack.

```
📦 Stack: React + React Query + Zustand + Zod

⚡ Generating craft skills...
   ✓ React Query: query keys, mutations, optimistic updates
   ✓ Zustand: slices, selectors, domain separation
   ✓ Zod: validation boundaries, type inference

💉 Injecting into agents...
   → Architect receives skills
   → Engineer receives skills
   → QA receives skills
```

**Each agent works with:**
- 🎯 Skills generated for your stack
- 📚 Patterns learned from your project
- 💎 Universal craft principles

---

### 3️⃣ Reactive Loop

**Agents self-correct.**

```
   🏗️              💻              🧪
Architect ───▶ Engineer ───▶ QA
                   ▲           │
                   │   fail    │
                   └─── 🔄 ────┘
```

| QA detects | Routed to | Action |
|------------|-----------|--------|
| 🔴 Test failure | Engineer | Fix → QA re-verifies |
| 🟠 Design flaw | Architect | Redesign → Engineer → QA |
| 🟡 Spec gap | Product Owner | Clarify → Architect → ... |

**Max 3 retries.** Then you take over.

---

## 🚀 Commands

### `/craft` — Build with craft

```bash
/craft                    # Guided flow
/craft "Add login form"   # Direct
```

**Assembles the team based on your context:**

| Context | Pipeline |
|---------|----------|
| 🏢 Product Team | PO → Architect → Engineer → QA |
| 🚀 Startup | Architect → Engineer → QA |
| 💼 Freelance | Engineer → QA |

---

### `/heal` — Smart repair

```bash
/heal           # Diagnose and fix everything
/heal tests     # Fix failing tests
/heal types     # Fix TypeScript errors
```

**Routes to the right expert:**
- Type error → 🏗️ Architect
- Test failure → 💻 Engineer
- Spec gap → 👤 Product Owner

---

### `/learn` — Configure learning

```bash
/learn                  # Re-scan project
/learn --only src/auth  # Limited scope
/learn --off            # Disable auto-learning
/learn --show           # View current learnings
```

---

### `/add-skill` — Skill Management

**Craft foundation is ALWAYS active.** Add specialized expertise on top.

```
🏛️ CRAFT FOUNDATION (Always Active — Cannot be removed)
   • SOLID • Clean Architecture • Hexagonal
   • Explicit Errors • Type Safety • Immutability • TDD
```

Add, remove, or list skills:

```bash
/add-skill architect DDD                  # Add DDD expertise
/add-skill architect CQRS --scope src/orders
/add-skill --remove architect CQRS        # Remove a skill
/add-skill --list                         # Show all active skills
/add-skill --reset                        # Remove all added (keep foundation)
```

**Craft Guard validates every skill:**

```
> /add-skill architect DDD

✅ Validating against craft principles...
   ✓ Aligns with SOLID (aggregates = single responsibility)
   ✓ Aligns with Clean Architecture (domain at center)
   ✓ Aligns with Hexagonal (bounded contexts as ports)

✅ APPROVED — DDD is craft-aligned
```

**Available skills:**

| Category | Skills |
|----------|--------|
| Architecture | `DDD`, `CQRS`, `Event-Sourcing`, `Hexagonal-Advanced`, `Modular-Monolith` |
| Frontend | `React-Patterns`, `State-Machines`, `A11y-Expert`, `Performance` |
| Backend | `API-Design`, `GraphQL`, `Message-Queues`, `Caching` |
| Testing | `TDD-Advanced`, `BDD`, `Contract-Testing`, `Property-Testing` |

---

## 👥 The Team

| Agent | Focus | Expertise |
|-------|-------|-----------|
| 👤 **Product Owner** | Specs | Stories, acceptance criteria, edge cases |
| 🏗️ **Architect** | Design | Clean Architecture, DDD, SOLID, code review |
| 💻 **Frontend Engineer** | UI | React, accessibility, components, hooks |
| ⚙️ **Backend Engineer** | API | Services, validation, Result types, security |
| 🧪 **QA Engineer** | Tests | TDD/BDD, Testing Library, coverage |

---

## 💫 Example

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
   ✓ 8 tests written
   ✗ 2 failures detected

🔄 Reactive loop triggered...

💻 Engineer fixing...
   ✓ Fixed error handling
   ✓ Fixed token refresh

🧪 QA re-verifying...
   ✓ 8/8 passing

✨ Craft complete.
```

---

## 📦 Install

```bash
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/install.sh | bash
```

Restart Claude Code. You're ready.

---

<p align="center">
  <img src="https://img.shields.io/badge//%20craft-8A2BE2?style=for-the-badge" alt="/craft"/>
  <img src="https://img.shields.io/badge//%20heal-9400D3?style=for-the-badge" alt="/heal"/>
  <img src="https://img.shields.io/badge//%20learn-9932CC?style=for-the-badge" alt="/learn"/>
</p>

<p align="center">
  <strong>Spectre learns. Spectre adapts. Spectre crafts.</strong> 👻
</p>

---

<p align="center">
  <sub>BSD 3-Clause License</sub>
</p>
