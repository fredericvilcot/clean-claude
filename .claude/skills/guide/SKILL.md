---
name: guide
description: "Interactive guided mode to help you build the right thing. Express your need, Spectre configures the agents."
context: conversation
allowed-tools: Read, Bash, Task, AskUserQuestion, Skill
---

# Spectre Guide — Express Your Need

Guide users through an intuitive flow to understand WHAT they want to build, then configure the right agent chain automatically.

## Philosophy

**Don't ask technical questions. Ask about the USER'S need.**

Bad: "Which agent do you want to use?"
Good: "What are you trying to build?"

Bad: "Do you want QA verification?"
Good: "How critical is this feature?"

## The Flow

### Step 1: What's the Situation?

Start with a high-level question about context:

```
Question: "What's your situation right now?"
Header: "Context"
Options:
  1. "I have an idea to build"
     Description: "New feature, new component, new functionality"
  2. "Something is broken"
     Description: "Bug, failing tests, error to fix"
  3. "I want to improve existing code"
     Description: "Refactor, optimize, clean up, add tests"
  4. "I need to think before coding"
     Description: "Design, architecture, technical decision"
```

---

### Step 2: Branch by Situation

#### If "I have an idea to build"

Ask about scope:

```
Question: "How big is what you want to build?"
Header: "Scope"
Options:
  1. "A complete feature"
     Description: "User-facing functionality with multiple components"
  2. "A specific component or function"
     Description: "One piece of the puzzle, focused scope"
  3. "A quick addition"
     Description: "Small change, minor enhancement"
```

Then ask about domain:

```
Question: "What part of the app does it touch?"
Header: "Domain"
Options:
  1. "User interface"
     Description: "Components, pages, forms, interactions"
  2. "Backend / API"
     Description: "Services, endpoints, data processing"
  3. "Both frontend and backend"
     Description: "Full-stack feature"
  4. "Core logic / Architecture"
     Description: "Business rules, domain model, structure"
```

Then ask about quality needs:

```
Question: "How critical is quality for this?"
Header: "Quality"
Options:
  1. "Very important — needs thorough testing"
     Description: "User-facing, payment, auth, core business"
  2. "Normal — standard quality"
     Description: "Regular feature, should work correctly"
  3. "Exploratory — just trying something"
     Description: "Prototype, spike, proof of concept"
```

**Mapping:**

| Scope | Domain | Quality | Result |
|-------|--------|---------|--------|
| Complete feature | Any | Very important | `/reactive-loop` (full PO→Arch→Dev→QA) |
| Complete feature | Any | Normal | `/agent software-craftsman --link <dev>,qa-engineer` |
| Specific component | UI | Very/Normal | `/agent frontend-dev --link qa-engineer` |
| Specific component | Backend | Very/Normal | `/agent backend-dev --link qa-engineer` |
| Specific component | Both | Any | `/agent software-craftsman --link frontend-dev,backend-dev,qa-engineer` |
| Specific component | Core | Any | `/agent software-craftsman --link qa-engineer` |
| Quick addition | UI | Any | `/agent frontend-dev` (no loop, quick) |
| Quick addition | Backend | Any | `/agent backend-dev` |
| Any | Any | Exploratory | Agent alone, no QA link |

---

#### If "Something is broken"

Ask what kind of problem:

```
Question: "What's happening?"
Header: "Problem"
Options:
  1. "Tests are failing"
     Description: "Red tests, need to make them green"
  2. "There's an error in the app"
     Description: "Runtime error, crash, unexpected behavior"
  3. "Build is broken"
     Description: "Compilation errors, type errors, can't start"
  4. "Something doesn't look/work right"
     Description: "UI issue, UX problem, visual bug"
```

Then ask about confidence:

```
Question: "Do you know what's causing it?"
Header: "Diagnosis"
Options:
  1. "Yes, I know what to fix"
     Description: "Just need help implementing the fix"
  2. "I have a guess"
     Description: "Need to verify and then fix"
  3. "No idea"
     Description: "Need investigation first"
```

**Mapping:**

| Problem | Diagnosis | Result |
|---------|-----------|--------|
| Tests failing | Know/Guess | `/agent frontend-dev --link qa-engineer` (fix + verify) |
| Tests failing | No idea | `/agent qa-engineer --link frontend-dev` (QA investigates first) |
| Error in app | Any | `/agent frontend-dev --link qa-engineer` with error context |
| Build broken | Any | `/agent software-craftsman` (type/architecture issues) |
| UI issue | Any | `/agent frontend-dev --link qa-engineer` |

---

#### If "I want to improve existing code"

Ask what kind of improvement:

```
Question: "What kind of improvement?"
Header: "Improvement"
Options:
  1. "Add tests to existing code"
     Description: "Improve coverage, add missing tests"
  2. "Refactor for clarity"
     Description: "Clean up, rename, restructure"
  3. "Improve types and safety"
     Description: "Better TypeScript, stricter types"
  4. "Performance optimization"
     Description: "Make it faster, more efficient"
```

**Mapping:**

| Improvement | Result |
|-------------|--------|
| Add tests | `/agent qa-engineer` with target files |
| Refactor | `/agent software-craftsman --link qa-engineer` |
| Types/safety | Use `/typescript-craft` skill directly |
| Performance | `/agent software-craftsman --link qa-engineer` |

---

#### If "I need to think before coding"

Ask what needs thinking:

```
Question: "What do you need to figure out?"
Header: "Decision"
Options:
  1. "How to structure this feature"
     Description: "Architecture, components, data flow"
  2. "Which approach to take"
     Description: "Multiple options, need to choose"
  3. "How to break down a big task"
     Description: "Need a plan, steps, priorities"
  4. "Best practices for this case"
     Description: "Patterns, conventions, standards"
```

**Mapping:**

| Decision | Result |
|----------|--------|
| Structure | `/agent software-craftsman` (design mode) |
| Approach | `/agent software-craftsman` (analysis mode) |
| Break down | `/reactive-loop` starting with product-owner |
| Best practices | Use craft skills: `/typescript-craft`, `/react-craft`, `/test-craft` |

---

### Step 3: Get the Details

After determining the right configuration, ask for specifics:

```
Question: "Describe what you want to do in a few words:"
Header: "Task"
Options:
  1. (Let user type via "Other")
```

Or if context is clear, ask a more specific question:

- For features: "What should this feature do?"
- For bugs: "What's the error message or behavior?"
- For refactoring: "Which files or components?"
- For architecture: "What's the technical challenge?"

---

### Step 4: Confirm and Launch

Show the user what will happen:

```markdown
## Here's what I understood:

**Your need:** Build a login form with email/password validation
**Approach:** Frontend implementation with QA verification

## The agents that will work on this:

1. **frontend-dev** — Implements the UI
   - React components
   - Form handling
   - Validation logic

2. **qa-engineer** — Verifies the work
   - Tests the implementation
   - If errors → sends back to frontend-dev
   - Loops until all tests pass

## Starting the workflow...

`/agent frontend-dev --link qa-engineer --task "Build login form with email/password validation"`
```

Then actually execute the skill/command.

---

## Smart Shortcuts

If the user provides context upfront, skip questions:

| Input | Detected | Action |
|-------|----------|--------|
| `/guide login form` | Feature + UI | Ask only about quality, then launch |
| `/guide fix tests` | Broken + Tests | Ask about diagnosis, then launch |
| `/guide refactor auth` | Improve + Refactor | Confirm scope, then launch |
| `/guide how to structure` | Think + Architecture | Launch architect directly |

---

## Configuration Translation Table

### For Features

| Quality | Stack | Chain |
|---------|-------|-------|
| Critical | frontend | `product-owner → software-craftsman → frontend-dev → qa-engineer` |
| Critical | backend | `product-owner → software-craftsman → backend-dev → qa-engineer` |
| Critical | fullstack | `product-owner → software-craftsman → backend-dev → frontend-dev → qa-engineer` |
| Normal | frontend | `software-craftsman → frontend-dev → qa-engineer` |
| Normal | backend | `software-craftsman → backend-dev → qa-engineer` |
| Exploratory | any | `<dev-agent>` alone |

### For Fixes

| Problem | Chain |
|---------|-------|
| Tests failing | `frontend-dev ↔ qa-engineer` (loop) |
| Runtime error | `frontend-dev ↔ qa-engineer` (loop) |
| Build/Type error | `software-craftsman → qa-engineer` |
| Investigation needed | `qa-engineer → frontend-dev → qa-engineer` |

### For Improvements

| Type | Chain |
|------|-------|
| Add tests | `qa-engineer` |
| Refactor | `software-craftsman ↔ qa-engineer` |
| Types | `/typescript-craft` |
| Performance | `software-craftsman → qa-engineer` |

---

## Example Flows

### Example 1: "I want to add a dark mode toggle"

```
Step 1: "I have an idea to build"
Step 2: Scope → "A specific component"
        Domain → "User interface"
        Quality → "Normal"
Step 3: Task → "Dark mode toggle in the header"

Result: /agent frontend-dev --link qa-engineer --task "Dark mode toggle in the header"
```

### Example 2: "The checkout is broken"

```
Step 1: "Something is broken"
Step 2: Problem → "There's an error in the app"
        Diagnosis → "I have a guess"
Step 3: Details → "Payment fails on submit, console shows network error"

Result: /agent frontend-dev --link qa-engineer --task "Fix payment submit - network error on checkout"
```

### Example 3: "I need to plan the authentication system"

```
Step 1: "I need to think before coding"
Step 2: Decision → "How to structure this feature"
Step 3: Details → "Full auth system with OAuth, email, session management"

Result: /agent software-craftsman --task "Design authentication system architecture"
        (Then suggest /reactive-loop for implementation)
```

---

## Tone Guidelines

- **Conversational**: "What are you trying to build?" not "Select input type"
- **Supportive**: "Got it! Here's the plan..." not "Executing command..."
- **Clear**: Always show what will happen before doing it
- **Helpful**: If unsure, err on the side of more quality (add QA link)

---

## After Launch

Once the agents start working, remind the user:

```markdown
The agents are now working. Here's what to expect:

- **frontend-dev** is implementing your feature
- When done, **qa-engineer** will automatically verify
- If there are errors, they'll be fixed automatically (up to 3 attempts)
- You'll see the final result when everything passes

You can check progress anytime with:
`cat .spectre/state.json | jq .`
```
