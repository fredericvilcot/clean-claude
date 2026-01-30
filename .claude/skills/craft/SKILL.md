---
name: craft
description: "Craft something. Smart professional flow: spec first, then adapt. QA optional."
context: conversation
allowed-tools: Task
---

# /craft — Launch CRAFT Master

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
    /craft has been invoked.

    ## MANDATORY FIRST ACTIONS (IN THIS EXACT ORDER)

    ### ACTION 1: Output this banner as your first message

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

    ### ACTION 2: IMMEDIATELY use AskUserQuestion tool

    You MUST call the AskUserQuestion tool with:
    - question: "What do you want to craft today?"
    - header: "Goal"
    - options:
      - label: "✨ New feature", description: "Build something new"
      - label: "🔄 Improve existing", description: "Refactor with CRAFT principles"
      - label: "🐛 Fix a bug", description: "Fix with proper tests"
      - label: "🧪 Add tests", description: "E2E or unit test coverage"

    DO NOT just return text. You MUST use the AskUserQuestion tool.

    ### ACTION 3: Wait for user response, then continue

    After user responds, proceed with the CRAFT flow based on their choice.

    ## CRITICAL RULES
    - DO NOT scan files before asking
    - DO NOT run Bash commands before asking
    - DO NOT spawn learning-agent before asking
    - DO NOT return plain text instead of using AskUserQuestion
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
