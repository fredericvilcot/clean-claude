---
name: add-skill
description: "Manage craft skills for agents. Default craft principles always active. Add specialized expertise, remove skills. Everything MUST respect the craft philosophy."
context: conversation
allowed-tools: Read, Write, Bash, Task, AskUserQuestion
---

# Spectre Skills — Craft-First Skill Management

**Craft principles are ALWAYS active.** You can add specialized expertise or remove skills, but the craft philosophy is non-negotiable.

## The Craft Foundation

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│  🏛️  DEFAULT CRAFT PRINCIPLES (Always Active)                   │
│  ──────────────────────────────────────────                     │
│                                                                  │
│  These are the FOUNDATION. Cannot be removed.                   │
│                                                                  │
│  • SOLID Principles — Single responsibility, Open/closed, etc.  │
│  • Clean Architecture — Dependencies point inward               │
│  • Hexagonal (Ports & Adapters) — Domain at center              │
│  • Explicit Error Handling — Result<T, E>, no throw             │
│  • Type Safety — Strict mode, no any                            │
│  • Immutability — Const by default                              │
│  • TDD — Tests first, design emerges                            │
│                                                                  │
│  ⚠️  These are NON-NEGOTIABLE. Spectre won't work without them.  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Adding Specialized Skills

You can ADD specialized expertise on top of the craft foundation.

### Syntax

```bash
/add-skill <agent> <skill> [--scope <path>]
```

### Examples

```bash
/add-skill architect DDD              # Add DDD expertise to architect
/add-skill architect CQRS             # Add CQRS patterns
/add-skill backend-engineer Event-Sourcing
/add-skill frontend-engineer React-Patterns
/add-skill qa-engineer Property-Testing
```

---

## Removing Skills

You can ONLY remove skills that were added with `/add-skill`.

**Built-in craft principles are PROTECTED and cannot be removed.**

### Syntax

```bash
/add-skill --remove <agent> <skill>
/add-skill --list                     # Show all active skills
/add-skill --reset                    # Remove all added skills (keep craft)
```

### Examples

```bash
/add-skill --remove architect CQRS    # ✅ Remove CQRS (was added)
/add-skill --remove architect SOLID   # ❌ REJECTED: Built-in, cannot remove
/add-skill --remove architect TDD     # ❌ REJECTED: Built-in, cannot remove
/add-skill --list                     # See what's active
/add-skill --reset                    # Back to craft defaults only
```

### Protected Skills (Built-in)

These skills are ALWAYS active and CANNOT be removed:

| Skill | Why Protected |
|-------|---------------|
| `SOLID` | Foundation of OOP design |
| `Clean-Architecture` | Core structural principle |
| `Hexagonal` | Domain isolation principle |
| `Explicit-Errors` | Craft error handling |
| `Type-Safety` | Compiler as safety net |
| `Immutability` | Predictable state |
| `TDD` | Design through tests |

```
> /add-skill --remove architect SOLID

❌ REJECTED

SOLID is a BUILT-IN craft principle.
Built-in skills are protected and cannot be removed.

Only skills added with /add-skill can be removed.
```

---

## Skill Validation — Craft Guard

**Every skill MUST respect the craft philosophy.**

When you add a skill, Spectre validates it:

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│  /add-skill architect DDD                                        │
│                                                                  │
│  ✅ VALIDATION                                                   │
│                                                                  │
│  1. Is DDD craft-aligned?                                        │
│     ✓ Domain at center — aligns with Hexagonal                  │
│     ✓ Bounded contexts — aligns with Clean Architecture          │
│     ✓ Aggregates — aligns with Single Responsibility             │
│     ✓ Value Objects — aligns with Immutability                   │
│                                                                  │
│  2. Does it conflict with existing skills?                       │
│     ✓ No conflicts                                               │
│                                                                  │
│  ✅ APPROVED: DDD is craft-aligned                               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### What Gets Rejected

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│  /add-skill architect "Throw exceptions everywhere"              │
│                                                                  │
│  ❌ REJECTED                                                      │
│                                                                  │
│  This skill violates craft principles:                           │
│  ✗ Conflicts with: Explicit Error Handling                       │
│  ✗ Reason: throw is implicit, Result<T, E> is explicit           │
│                                                                  │
│  Suggestion: Use "Explicit-Errors" skill instead                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Available Skills (Craft-Aligned)

All these skills have been validated against the craft philosophy:

### Architecture Skills

| Skill | Description | Craft Alignment |
|-------|-------------|-----------------|
| `DDD` | Domain-Driven Design | ✅ Domain-first, bounded contexts |
| `CQRS` | Command Query Responsibility Segregation | ✅ Single responsibility, explicit |
| `Event-Sourcing` | Event store, projections, replay | ✅ Immutability, explicit state |
| `Hexagonal-Advanced` | Deep ports & adapters patterns | ✅ Extension of core Hexagonal |
| `Modular-Monolith` | Module boundaries, internal APIs | ✅ Bounded contexts, clean deps |

### Frontend Skills

| Skill | Description | Craft Alignment |
|-------|-------------|-----------------|
| `React-Patterns` | Compound components, custom hooks | ✅ Composition, single responsibility |
| `State-Machines` | XState, statecharts | ✅ Explicit state, predictable |
| `A11y-Expert` | Accessibility deep-dive | ✅ Domain (user needs) first |
| `Performance` | Core Web Vitals optimization | ✅ Measurable, testable |

### Backend Skills

| Skill | Description | Craft Alignment |
|-------|-------------|-----------------|
| `API-Design` | REST best practices, HATEOAS | ✅ Explicit contracts, testable |
| `GraphQL` | Schema design, resolvers | ✅ Type-safe, explicit |
| `Message-Queues` | Event-driven patterns | ✅ Decoupling, explicit |
| `Caching` | Cache strategies, invalidation | ✅ Explicit, predictable |

### Testing Skills

| Skill | Description | Craft Alignment |
|-------|-------------|-----------------|
| `TDD-Advanced` | Outside-in, mocking strategies | ✅ Extension of core TDD |
| `BDD` | Gherkin, behavior specs | ✅ Domain language, explicit |
| `Contract-Testing` | Pact, consumer-driven | ✅ Explicit contracts |
| `Property-Testing` | QuickCheck-style, fuzzing | ✅ Exhaustive, type-driven |

---

## How It Works

### Adding a Skill

```
┌─────────────────────────────────────────────────────────────────┐
│                    /add-skill architect DDD                      │
│                                                                  │
│  1. CRAFT VALIDATION                                             │
│     ─────────────────                                            │
│     → Is DDD craft-aligned? ✅                                   │
│     → Any conflicts? None ✅                                     │
│                                                                  │
│  2. SKILL GENERATION                                             │
│     ─────────────────────                                        │
│     → Use architect agent to generate DDD skill document         │
│     → Include: principles, patterns, examples, checklist         │
│     → Store in .spectre/skills/ddd.md                           │
│                                                                  │
│  3. CODEBASE ANALYSIS                                            │
│     ────────────────────                                         │
│     → Architect analyzes code through DDD lens                   │
│     → Identifies: bounded contexts, aggregates, violations       │
│     → Generates refactoring plan                                 │
│                                                                  │
│  4. USER APPROVAL                                                │
│     ─────────────────                                            │
│     → Show analysis and plan                                     │
│     → User approves/modifies/rejects                             │
│                                                                  │
│  5. REACTIVE LOOP (if approved)                                  │
│     ──────────────────────────                                   │
│     → Architect designs changes                                  │
│     → Engineers implement                                        │
│     → QA verifies                                                │
│     → Loop until green                                           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Listing Skills

```
> /add-skill --list

┌─────────────────────────────────────────────────────────────────┐
│  ACTIVE SKILLS                                                   │
│                                                                  │
│  🏛️  CRAFT FOUNDATION (Always Active)                           │
│      • SOLID                                                     │
│      • Clean Architecture                                        │
│      • Hexagonal                                                 │
│      • Explicit Errors                                           │
│      • Type Safety                                               │
│      • Immutability                                              │
│      • TDD                                                       │
│                                                                  │
│  ➕  ADDED SKILLS                                                 │
│      • architect: DDD (added 2024-01-15)                         │
│      • architect: CQRS (added 2024-01-16)                        │
│      • qa-engineer: Property-Testing (added 2024-01-16)         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Removing Skills

```
> /add-skill --remove architect CQRS

✅ Removed CQRS from architect

Note: Craft foundation skills cannot be removed.
```

### Resetting

```
> /add-skill --reset

✅ All added skills removed
🏛️ Craft foundation remains active
```

---

## Storage

```
.spectre/
├── context.json          # Includes active skills
├── skills/
│   ├── ddd.md            # Generated skill document
│   ├── cqrs.md           # Generated skill document
│   └── ...
└── refactoring-plans/
    └── ddd-2024-01-15.md # Refactoring plan if applied
```

### context.json with Skills

```json
{
  "stack": { ... },
  "craftFoundation": [
    "SOLID",
    "Clean-Architecture",
    "Hexagonal",
    "Explicit-Errors",
    "Type-Safety",
    "Immutability",
    "TDD"
  ],
  "addedSkills": [
    {
      "name": "DDD",
      "agent": "architect",
      "addedAt": "2024-01-15T10:30:00Z",
      "scope": null
    },
    {
      "name": "CQRS",
      "agent": "architect",
      "addedAt": "2024-01-16T09:00:00Z",
      "scope": "src/features/orders"
    }
  ]
}
```

---

## Skill Injection into Agents

When agents are spawned, they receive:

1. **Craft Foundation** — Always (non-negotiable)
2. **Stack Defaults** — Generated for your exact stack
3. **Project Patterns** — Learned from your clean code
4. **Added Skills** — Custom skills you've added

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│  AGENT CONTEXT = Foundation + Stack + Patterns + Skills         │
│                                                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   SOLID     │  │  React      │  │  Your       │  │  DDD    │ │
│  │   Clean     │  │  Query      │  │  naming     │  │  CQRS   │ │
│  │   Hexa      │  │  patterns   │  │  patterns   │  │  etc.   │ │
│  │   TDD       │  │             │  │             │  │         │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
│   Foundation       Stack Defaults   Learned         Added       │
│   (Always)         (Generated)      (If clean)      (Manual)    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Implementation

### Step 1: Parse Arguments

```typescript
type Command =
  | { type: 'add'; agent: string; skill: string; scope?: string }
  | { type: 'remove'; agent: string; skill: string }
  | { type: 'list' }
  | { type: 'reset' };

// /add-skill architect DDD → { type: 'add', agent: 'architect', skill: 'DDD' }
// /add-skill --remove architect DDD → { type: 'remove', ... }
// /add-skill --list → { type: 'list' }
// /add-skill --reset → { type: 'reset' }
```

### Step 2: Check Built-in Protection (for remove)

```typescript
const BUILT_IN_SKILLS = [
  'SOLID',
  'Clean-Architecture',
  'Hexagonal',
  'Explicit-Errors',
  'Type-Safety',
  'Immutability',
  'TDD'
];

function handleRemove(agent: string, skill: string): Result<void, ProtectedSkillError> {
  // HARD BLOCK: Built-in skills cannot be removed
  if (BUILT_IN_SKILLS.includes(skill)) {
    return err(new ProtectedSkillError(
      `${skill} is a BUILT-IN craft principle and cannot be removed.`
    ));
  }

  // Check if skill was actually added
  const addedSkills = readContext().addedSkills;
  const found = addedSkills.find(s => s.name === skill && s.agent === agent);

  if (!found) {
    return err(new SkillNotFoundError(
      `${skill} was not added to ${agent}. Nothing to remove.`
    ));
  }

  // Safe to remove
  return ok(removeSkill(agent, skill));
}
```

### Step 3: Validate Against Craft (for add)

```
Task(
  subagent_type: "software-craftsman",
  prompt: """
    Validate if this skill is CRAFT-ALIGNED:

    Skill: DDD (Domain-Driven Design)
    Target Agent: architect

    Check against craft foundation:
    1. Does it align with SOLID?
    2. Does it align with Clean Architecture?
    3. Does it align with Hexagonal?
    4. Does it align with Explicit Errors?
    5. Does it align with Type Safety?
    6. Does it align with Immutability?
    7. Does it align with TDD?

    If ANY conflict → REJECT with explanation
    If aligned → APPROVE with alignment notes
  """
)
```

### Step 3: Generate Skill Document (if approved)

```
Task(
  subagent_type: "software-craftsman",
  prompt: """
    Generate an expert-level skill document for: DDD

    Structure:
    ## Core Principles
    ## Tactical Patterns (with TypeScript examples)
    ## Strategic Patterns
    ## Integration with Craft Foundation
    ## Checklist for Code Review
    ## Anti-patterns to Avoid

    IMPORTANT: All examples must use Result<T, E>, strict types, etc.
  """
)
```

### Step 4: Analyze and Propose (if requested)

Same reactive flow as before — analyze codebase, propose plan, loop.

---

## Example Session

```
> /add-skill --list

🏛️ CRAFT FOUNDATION (Always Active)
   • SOLID • Clean Architecture • Hexagonal
   • Explicit Errors • Type Safety • Immutability • TDD

➕ ADDED SKILLS
   (none)

> /add-skill architect DDD

✅ Validating DDD against craft principles...
   ✓ Aligns with SOLID (aggregates = single responsibility)
   ✓ Aligns with Clean Architecture (domain at center)
   ✓ Aligns with Hexagonal (bounded contexts as ports)

📝 Generating DDD skill document...
   ✓ Stored in .spectre/skills/ddd.md

🔍 Analyzing codebase with DDD lens...

📋 Analysis Complete

## Bounded Contexts Identified
- Users (current)
- Orders (current)
- Payments (referenced)

## Violations Found
| File | Issue | Priority |
|------|-------|----------|
| UserService.ts | Anemic domain model | 🔴 High |
| Order.ts | No aggregate boundaries | 🔴 High |

## Refactoring Plan
1. **Phase 1**: Create User aggregate
2. **Phase 2**: Create Order aggregate with items

─────────────────────────────

[Approve & Implement] [Modify Scope] [Just add skill, don't refactor] [Cancel]

> Just add skill, don't refactor

✅ DDD added to architect

> /add-skill --list

🏛️ CRAFT FOUNDATION (Always Active)
   • SOLID • Clean Architecture • Hexagonal
   • Explicit Errors • Type Safety • Immutability • TDD

➕ ADDED SKILLS
   • architect: DDD

> /add-skill --remove architect DDD

✅ Removed DDD from architect

> /add-skill --reset

✅ All added skills removed
🏛️ Craft foundation remains active
```

---

## Tone

- **Craft-first**: Everything validates against craft principles
- **Educational**: Explain WHY a skill aligns (or doesn't)
- **Non-dogmatic**: Added skills are optional enhancements
- **Protective**: Foundation cannot be compromised
