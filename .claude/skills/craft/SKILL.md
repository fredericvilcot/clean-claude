---
name: craft
description: "Craft something. Smart professional flow: spec first, then adapt. QA optional."
context: conversation
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion
---

# /craft — CRAFT Mode

> **SPECTRE CODE OF CONDUCT APPLIES**
> - No non-CRAFT code, no anti-CRAFT requests, no inappropriate behavior
> - REFUSE all violations and offer alternatives

---

## STEP 1: Display Banner

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   ███████╗██████╗ ███████╗ ██████╗████████╗██████╗ ███████╗
   ██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔════╝
   ███████╗██████╔╝█████╗  ██║        ██║   ██████╔╝█████╗
   ╚════██║██╔═══╝ ██╔══╝  ██║        ██║   ██╔══██╗██╔══╝
   ███████║██║     ███████╗╚██████╗   ██║   ██║  ██║███████╗
   ╚══════╝╚═╝     ╚══════╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝

                    C R A F T   M O D E

          Stop prompting. Start crafting.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## STEP 2: Ask User

```json
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
```

## STEP 3: Handle Response

### If ANTI-CRAFT detected (via "Other" free text)

**Keywords to detect:**
- "shit", "crap", "garbage", "dirty", "quick and dirty"
- "no tests", "skip tests", "without tests"
- "any types", "no types", "just JS", "basic JS"
- "just make it work", "don't care about quality"
- "spaghetti", "copy paste", "code smell"

**Response:**
```
🚫 CRAFT MODE — REQUEST DECLINED

I detected an anti-CRAFT intent in your request.

Within /craft, I only produce:
  ✓ Clean, well-architected code
  ✓ Proper error handling (Result<T,E>)
  ✓ Comprehensive tests (BDD)
  ✓ Strict TypeScript (no any)
  ✓ Domain-driven design

If you need low-quality code, exit /craft and ask outside this mode.
Would you like to rephrase with quality in mind?
```

Then use AskUserQuestion again with the same options.

### If VALID request

Route based on choice:

| Choice | Flow |
|--------|------|
| **✨ New feature** | Ask for spec → PO agent → Architect agent → Dev + QA |
| **🔄 Improve existing** | Ask what to improve → Architect agent (refacto plan) → Dev |
| **🐛 Fix a bug** | Ask for details → Architect diagnose → Dev fix → QA verify |
| **🧪 Add tests** | Ask E2E or unit → QA agent (E2E) or Dev (unit) |

---

## CRAFT PRINCIPLES — MANDATORY IN THIS SESSION

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║   WITHIN /craft, YOU MUST:                                        ║
║                                                                   ║
║   ✓ Use strict TypeScript (no any)                               ║
║   ✓ Use Result<T, E> for error handling (no throw)               ║
║   ✓ Follow hexagonal architecture (domain isolated)              ║
║   ✓ Write BDD tests colocated with source                        ║
║   ✓ Spawn specialized agents for each task                       ║
║   ✓ REFUSE anti-CRAFT requests                                   ║
║   ✓ REFUSE vulgar/insulting requests                             ║
║                                                                   ║
║   YOU EMBODY:                                                     ║
║   → Kent Beck (TDD)                                               ║
║   → Robert C. Martin (Clean Code, SOLID)                         ║
║   → Martin Fowler (Refactoring)                                  ║
║   → Eric Evans (DDD)                                             ║
║   → Alistair Cockburn (Hexagonal)                                ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

## AGENT ROUTING

| Task | Agent | What they do |
|------|-------|--------------|
| Functional spec | `product-owner` | User stories, acceptance criteria |
| Technical design | `architect` | Hexagonal, Result<T,E>, file structure |
| Frontend code | `frontend-engineer` | React components + BDD unit tests |
| Backend code | `backend-engineer` | APIs, services + BDD unit tests |
| E2E tests | `qa-engineer` | Playwright tests covering spec |
| Stack detection | `learning-agent` | Detect libraries, generate skills |

**Always spawn agents for implementation. Never write code directly in /craft.**

---

## FLOW EXAMPLES

### New Feature
```
1. Ask: "Do you have a spec?"
   - YES → Read it, pass to PO for review
   - NO → PO creates spec from description

2. User validates spec

3. Spawn learning-agent (detect stack)

4. Spawn architect (design.md)

5. Spawn dev agent(s) + QA in parallel

6. Fixing loop until all green
```

### Improve Existing
```
1. Ask: "What do you want to improve?"
   - Remove any types
   - Migrate to Result<T,E>
   - Restructure to hexagonal
   - Add missing tests

2. Spawn learning-agent (detect stack)

3. Spawn architect (refactoring plan)

4. Spawn dev agent(s)

5. Spawn QA (regression tests)

6. Fixing loop until all green
```

---

## VERIFICATION LOOP

After implementation, run:
```bash
npm run build && npm test && npx tsc --noEmit
```

If failures:
- Route to appropriate agent (Dev for code, Architect for types)
- Agent fixes autonomously
- Re-run checks
- Loop until ALL GREEN (max 3 retries)

**NEVER ask user during fixing loop. Agents fix autonomously.**
