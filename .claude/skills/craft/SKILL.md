---
name: craft
description: "Craft something. Smart professional flow: spec first, then adapt. QA optional."
context: conversation
allowed-tools: Task
---

# /craft — Launch CRAFT Master

> **SPECTRE CODE OF CONDUCT APPLIES** — See CLAUDE.md
> - No non-CRAFT code, no anti-CRAFT requests, no inappropriate behavior
> - CRAFT Master REFUSES all violations and offers alternatives
> - Vulgar/insulting requests are DECLINED

**Claude does ONE thing: spawn the CRAFT Master. Nothing else.**

---

## ABSOLUTE RULE

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║   🚫  CLAUDE MUST NOT INTERACT DURING /craft  🚫                 ║
║                                                                   ║
║   Claude's ONLY job:                                              ║
║   1. Spawn craft-master agent                                     ║
║   2. Relay final results                                          ║
║                                                                   ║
║   Claude MUST NOT:                                                ║
║   ❌ Ask questions                                                ║
║   ❌ Write code                                                   ║
║   ❌ Make decisions                                               ║
║   ❌ Interpret user requests                                      ║
║                                                                   ║
║   CRAFT Master handles EVERYTHING.                                ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

## Execution

**IMMEDIATELY spawn the CRAFT Master:**

```
Task(
  subagent_type: "craft-master",
  prompt: """
    EXECUTE NOW. DO NOT READ FURTHER DOCUMENTATION FIRST.

    STEP 1: Output this banner IMMEDIATELY:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   ███████╗██████╗ ███████╗ ██████╗████████╗██████╗ ███████╗
   ██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔════╝
   ███████╗██████╔╝█████╗  ██║        ██║   ██████╔╝█████╗
   ╚════██║██╔═══╝ ██╔══╝  ██║        ██║   ██╔══██╗██╔══╝
   ███████║██║     ███████╗╚██████╗   ██║   ██║  ██║███████╗
   ╚══════╝╚═╝     ╚══════╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝

                    C R A F T   M A S T E R

          Stop prompting. Start crafting.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    STEP 2: Call the AskUserQuestion tool with this EXACT JSON:

    {
      "questions": [{
        "question": "What do you want to craft today?",
        "header": "Goal",
        "multiSelect": false,
        "options": [
          { "label": "✨ New feature", "description": "Build something new" },
          { "label": "🔄 Improve existing", "description": "Refactor with CRAFT principles" },
          { "label": "🐛 Fix a bug", "description": "Fix with proper tests" },
          { "label": "🧪 Add tests", "description": "E2E or unit test coverage" }
        ]
      }]
    }

    FAILURE CONDITIONS (you FAIL if any of these happen):
    ❌ Returning plain text options instead of using AskUserQuestion tool
    ❌ Scanning files before asking
    ❌ Running Bash commands before asking
    ❌ Spawning other agents before asking
    ❌ Reading package.json before asking
    ❌ NOT using the AskUserQuestion tool

    SUCCESS = Banner displayed + AskUserQuestion tool called. Nothing else.
  """
)
```

---

## Why CRAFT Master?

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   BEFORE: Claude orchestrates                                    │
│   ─────────────────────────────                                  │
│   → Claude asks questions (may miss CRAFT)                      │
│   → Claude interprets requests (may accept anti-patterns)       │
│   → Claude routes to agents (may skip steps)                    │
│                                                                  │
│   AFTER: CRAFT Master orchestrates                               │
│   ────────────────────────────────                               │
│   → CRAFT Master is a SUPERSET of all agents                    │
│   → Embodies Kent Beck, Uncle Bob, Fowler, Evans, Cockburn      │
│   → CANNOT produce anti-CRAFT code                              │
│   → Every question, every decision = CRAFT-aligned              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## That's It

The entire /craft skill is now:

1. Claude receives `/craft`
2. Claude spawns `craft-master`
3. CRAFT Master takes over completely
4. Claude relays final result

**No more Claude in the middle. Pure CRAFT.**
