---
name: learn
description: "Auto-learns project patterns by default. Adapts agents to YOUR conventions. Craft guard stops on violations. Can be scoped or disabled."
context: conversation
allowed-tools: Read, Bash, Glob, Grep, Write, Task, AskUserQuestion
---

# Spectre Learn — Adaptive Intelligence

**Active by default.** Two distinct phases that work independently.

## The Two Phases

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│  PHASE 1: STACK DETECTION          PHASE 2: PATTERN LEARNING    │
│  ─────────────────────────         ─────────────────────────    │
│                                                                  │
│  ✅ ALWAYS runs                    ⚠️  MAY BE BLOCKED            │
│  ✅ Independent of violations      ❌ STOPS on violations        │
│  ✅ Result: stack context          ✅ Result: learned patterns   │
│                                    ❌ On block: craft defaults   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Why Two Phases?

**Stack detection** tells agents WHAT language/framework you're using.
**Pattern learning** tells agents HOW you use it in this project.

Even if your code has violations, agents still need to know it's TypeScript vs Go.
They just won't copy your bad patterns — they'll use craft defaults instead.

## Default Behavior

When you run `/craft` or `/heal`, Spectre automatically:

1. **Detects your stack** → ALWAYS (stored in context.json)
2. **Learns your patterns** → IF no violations (stored in learnings/)
3. **Applies craft guard** → STOPS on violations, generates report
4. **Adapts agents** → Stack + patterns OR Stack + craft defaults

You don't need to run `/learn` manually — it happens automatically.

---

## Stack Auto-Detection

On first invocation, Spectre detects your stack:

```
┌─────────────────────────────────────────────────────────────┐
│  FILE DETECTED          →  STACK                            │
├─────────────────────────────────────────────────────────────┤
│  package.json           →  Node.js / TypeScript / React     │
│  go.mod                 →  Go                               │
│  Cargo.toml             →  Rust                             │
│  pyproject.toml         →  Python                           │
│  pom.xml                →  Java / Maven                     │
│  build.gradle           →  Java / Kotlin / Gradle           │
│  mix.exs                →  Elixir                           │
│  Gemfile                →  Ruby                             │
│  composer.json          →  PHP                              │
│  *.csproj               →  C# / .NET                        │
└─────────────────────────────────────────────────────────────┘
```

Stored in `.spectre/context.json`:

```json
{
  "stack": {
    "language": "typescript",
    "runtime": "node",
    "framework": "react",
    "testing": "vitest",
    "styling": "tailwind"
  },
  "detectedAt": "2024-01-15T10:30:00Z"
}
```

---

## On Violation: What Happens

When craft guard detects violations during pattern learning:

```
🔍 Phase 1: Detecting stack...
   ✅ TypeScript + React detected

🔍 Phase 2: Learning patterns...

🛑 CRAFT VIOLATIONS DETECTED

   src/services/UserService.ts:45
   → throw new Error('User not found')
   → Violates: Explicit Error Handling
   → Fix: Return Result<User, NotFoundError>

📋 Report: .spectre/violations-report.md

┌─────────────────────────────────────────────────────────────────┐
│  RESULT                                                          │
│                                                                  │
│  ✅ Stack: TypeScript + React (DETECTED)                         │
│  ❌ Patterns: NOT LEARNED (violations blocked)                   │
│  ✅ Agents will use: Craft defaults for TypeScript + React       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

   [ 🔧 Fix violations ]  [ ⏭️ Continue anyway ]  [ 🛑 Stop ]
```

### Context After Violation

```json
{
  "stack": {
    "language": "typescript",
    "runtime": "node",
    "framework": "react"
  },
  "learning": {
    "enabled": true,
    "status": "blocked",
    "reason": "violations",
    "violationCount": 2,
    "reportPath": ".spectre/violations-report.md"
  }
}
```

### What Agents Get

| Situation | Stack Known | Patterns Learned | Agents Use |
|-----------|-------------|------------------|------------|
| ✅ Clean code | Yes | Yes | Project patterns |
| ❌ Violations | Yes | **No** | Craft defaults |
| 🆕 From scratch | Yes (selected) | — | Craft defaults |
| 🚫 Learning off | Yes | — | Craft defaults |

**Key insight:** Violations block pattern learning, NOT stack detection.
Agents always know your stack. They just won't copy bad patterns.

---

## Manual Commands

### Configure Learning Scope

```bash
/learn                    # Re-learn entire project (refresh)
/learn --only <path>      # Learn ONLY from this file/folder
/learn --off              # Disable auto-learning completely
/learn --on               # Re-enable auto-learning (default)
```

### View & Reset

```bash
/learn --show             # Show current learnings
/learn --reset            # Reset all learnings
/learn --violations       # Show detected violations
```

---

## Scope Control

### Default: Entire Project

```bash
# Auto-learning is ON for the whole project
# Nothing to do, it just works
```

### Scoped: Specific Path Only

```bash
/learn --only src/features/auth/

# Now Spectre ONLY learns from src/features/auth/
# Ignores patterns from other parts of the codebase
# Useful for: monorepos, legacy code you don't want to learn from
```

### Disabled: No Learning

```bash
/learn --off

# Auto-learning is completely disabled
# Agents use default craft principles only
# Useful for: new projects, when you want pure craft defaults
```

### Re-enable

```bash
/learn --on

# Back to default: learn from entire project
```

---

## Craft Guard — Always Active

**Spectre will NEVER learn anti-patterns.**

Whether auto or manual, scoped or full — the craft guard is always on.

```
> /craft "Add user service"

🔍 Auto-learning project patterns...

🛑 CRAFT VIOLATIONS DETECTED

   src/services/UserService.ts:45
   → throw new Error('User not found')
   → Violates: Explicit Error Handling

📋 Report: .spectre/violations-report.md

❌ Pattern NOT learned. Fix violation first.

   [ 🔧 Fix it ]  [ ⏭️ Skip file ]  [ 🛑 Stop ]
```

### What Gets Checked

| Principle | Compliant ✅ | Violation ❌ |
|-----------|-------------|-------------|
| **Type Safety** | Strict types, generics | `any`, type assertions |
| **Error Handling** | Result types, explicit | Thrown exceptions |
| **Architecture** | Layers, DI, ports/adapters | God classes, tight coupling |
| **SOLID** | Single responsibility, DIP | God objects, concrete deps |
| **Immutability** | Const, readonly, pure | Mutations everywhere |

### Violation Report

Generated at `.spectre/violations-report.md`:

```markdown
## Action Plan

| Priority | File | Issue | Fix |
|----------|------|-------|-----|
| 🔴 P0 | PaymentService.ts | God class | Split into focused services |
| 🟠 P1 | UserService.ts:45 | throw Error | Use Result<T, E> |
```

---

## What Gets Learned

### Patterns Detected

| Category | Examples |
|----------|----------|
| **Architecture** | Hexagonal, feature-folders, layers |
| **Error Handling** | Result types, error classes, Go-style |
| **Naming** | Files: kebab-case, Functions: camelCase |
| **Imports** | Absolute paths, barrel exports |
| **Testing** | Co-located, factories, mocking style |
| **API Style** | REST conventions, response format |

### Language-Specific Adaptations

Craft principles are universal. Implementation adapts to your stack:

| Principle | TypeScript | Go | Rust |
|-----------|------------|-----|------|
| Explicit Errors | `Result<T, E>` | `error` return | `Result<T, E>` |
| Type Safety | Strict mode | Strong types | Ownership |
| Immutability | `readonly`, `const` | Value semantics | By default |
| DI | Constructor injection | Interface params | Traits |

---

## Storage

```
.spectre/
├── context.json          # Stack + settings
├── learnings/
│   ├── patterns.json     # Learned patterns → INJECTED into agents
│   └── examples.json     # Reference files → INJECTED into agents
├── violations-report.md  # Current violations
└── state.json            # Workflow state
```

### patterns.json — What Agents Receive

```json
{
  "architecture": {
    "style": "feature-folders",
    "layers": ["domain", "application", "infrastructure"]
  },
  "naming": {
    "files": "kebab-case",
    "components": "PascalCase",
    "functions": "camelCase",
    "constants": "SCREAMING_SNAKE"
  },
  "imports": {
    "style": "absolute",
    "aliases": ["@/", "~/"],
    "barrelExports": true
  },
  "testing": {
    "location": "colocated",
    "framework": "vitest",
    "pattern": "*.test.ts"
  },
  "errorHandling": {
    "style": "result-type",
    "customErrors": true
  }
}
```

### examples.json — Reference Files

```json
{
  "bestFiles": [
    {
      "path": "src/features/auth/AuthService.ts",
      "reason": "Clean Result types, proper DI",
      "patterns": ["result-type", "dependency-injection"]
    },
    {
      "path": "src/components/Button/Button.tsx",
      "reason": "Well-typed props, accessible",
      "patterns": ["typed-props", "a11y"]
    }
  ]
}
```

### Continuous Injection

Every time an agent is spawned via `/craft` or `/heal`:
1. Read `.spectre/learnings/patterns.json`
2. Read `.spectre/learnings/examples.json`
3. Inject into agent prompt alongside stack craft defaults
4. Agent applies YOUR conventions, not generic ones

---

## Integration with /craft and /heal

Auto-learning runs transparently:

```
/craft "Build login form"
    │
    ├─→ Check .spectre/context.json
    │       │
    │       └─→ Missing? → Auto-detect stack
    │
    ├─→ Check learning scope (--only, --off)
    │       │
    │       └─→ Active? → Scan for patterns + guard
    │
    ├─→ Violations found?
    │       │
    │       ├─→ YES → Stop, report, ask user
    │       │
    │       └─→ NO → Continue with learned context
    │
    └─→ Agents work with adapted conventions
```

---

## Summary

| Setting | Command | Behavior |
|---------|---------|----------|
| **Default** | (nothing) | Learn entire project, guard on |
| **Scoped** | `/learn --only <path>` | Learn only from path |
| **Disabled** | `/learn --off` | No learning, pure craft defaults |
| **Re-enabled** | `/learn --on` | Back to full project |
| **Refresh** | `/learn` | Re-scan and update learnings |
| **View** | `/learn --show` | Display current learnings |
| **Reset** | `/learn --reset` | Clear all learnings |
