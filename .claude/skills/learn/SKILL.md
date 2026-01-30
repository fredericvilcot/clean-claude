---
name: learn
description: "Re-run stack detection and skill generation. Use when stack evolved or on first run."
context: conversation
allowed-tools: Read, Bash, Glob, Grep, Write, Task
---

# Spectre Learn — Stack Detection & Skill Generation

**Detect stack. Architect generates library skills. Skills used for design or audit.**

---

## When to Use

```
/learn    # Re-detect stack and regenerate skills
```

Use when:
- Stack changed (added new library)
- First time on existing project
- Skills seem outdated

---

## The Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   /learn (or auto at /craft start)                              │
│        │                                                         │
│        ▼                                                         │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  1. LEARNING AGENT: Detect Stack                         │   │
│   │     → Read package.json, tsconfig.json, go.mod...       │   │
│   │     → Write .spectre/context.json                        │   │
│   └─────────────────────────────────┬───────────────────────┘   │
│                                     │                            │
│                                     ▼                            │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  2. SPAWN ARCHITECT: Generate Library Skills             │   │
│   │     → For each detected library                         │   │
│   │     → Write API, patterns, examples                     │   │
│   │     → Output: .spectre/stack-skills.md                  │   │
│   └─────────────────────────────────┬───────────────────────┘   │
│                                     │                            │
│                                     ▼                            │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  3. SKILLS INJECTED                                      │   │
│   │     → Architect uses for design (new feature)           │   │
│   │     → Or for audit (refactoring proposal)               │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## What Gets Generated

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   ✅ LIBRARY KNOWLEDGE               ❌ NOT THIS                │
│   ────────────────────               ──────────                 │
│                                                                  │
│   • TypeScript utility types         • CRAFT patterns           │
│   • fp-ts (Option, Either, pipe)       (Architect knows them)   │
│   • React hooks API                                              │
│   • Zustand store patterns           • Existing code patterns   │
│   • Zod schemas                        (might be garbage)       │
│   • Tailwind utilities                                          │
│   • Vitest matchers                                             │
│   • etc.                                                        │
│                                                                  │
│   Written BY Architect,                                         │
│   FOR Architect and Dev.                                        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Execution

```
Task(
  subagent_type: "learning-agent",
  prompt: """
    DETECT STACK AND GENERATE SKILLS

    1. Detect libraries from package.json
    2. Write .spectre/context.json
    3. Spawn Architect to generate library skills
    4. Skills written to .spectre/stack-skills.md

    OUTPUT progress to user:
    - "📦 Detecting stack..."
    - "🏛️ Architect generating library skills..."
    - "✅ Stack skills ready"
  """
)
```

---

## Output Files

```
.spectre/
├── context.json        # Detected libraries (gitignored)
└── stack-skills.md     # Library documentation (gitignored)
```

---

## Automatic in /craft

Learning runs automatically at `/craft` start:

```
/craft
   │
   ├─ ══════════════════════════════════
   │   LEARNING (auto)
   │   → Detect stack
   │   → Architect generates skills
   │  ══════════════════════════════════
   │
   ├─ PO → spec
   ├─ Architect → design (uses skills)
   └─ Dev → implements
```

**Use `/learn` only to re-run manually.**

---

## Summary

| Step | Who | What |
|------|-----|------|
| Detect | Learning Agent | Read package.json → context.json |
| Generate | Architect | Library documentation → stack-skills.md |
| Use | Architect | Design with library knowledge |
| Use | Dev | Implement with library knowledge |
