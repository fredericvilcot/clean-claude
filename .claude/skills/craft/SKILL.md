---
name: craft
description: "Craft something new. Adapts to your work context (Product Team, Startup, Freelance). Express your need, Spectre configures the agents."
context: conversation
allowed-tools: Read, Bash, Task, AskUserQuestion, Skill
---

# Spectre Craft — Adapted to Your Context

Craft features based on HOW you work, not just WHAT you want to build.

## Philosophy

Different contexts need different workflows:
- **Product Team** → Full process, specs, reviews, compliance
- **Startup** → Fast iterations, ship & learn
- **Freelance** → Efficient, focused, no overhead

---

## Step 0: Stack Detection + Pattern Learning (2 phases distinctes)

**Before asking any questions**, two separate phases:

### Phase 1: STACK DETECTION (toujours exécuté)

Détecte le stack technique. **Indépendant des violations.**
Même si le code est pourri, on sait quand même que c'est du TypeScript/Go/Rust.

### Phase 2: PATTERN LEARNING (peut être bloqué)

Apprend les patterns du projet. **STOP sur violations.**
Si bloqué → agents utilisent les craft defaults pour le stack détecté.

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLOW DÉTAILLÉ                                 │
│                                                                  │
│  1. STACK DETECTION ─────────────────────────────────────────   │
│     │                                                            │
│     └─→ Toujours OK → Stocké dans .spectre/context.json         │
│                                                                  │
│  2. PATTERN LEARNING ────────────────────────────────────────   │
│     │                                                            │
│     ├─→ Violation? ─── OUI ─→ STOP                              │
│     │                         Rapport généré                     │
│     │                         User décide (fix/skip/stop)        │
│     │                         Patterns NON appris                │
│     │                                                            │
│     └─→ Violation? ─── NON ─→ Patterns appris                   │
│                               Stockés dans .spectre/learnings/   │
│                                                                  │
│  3. AGENTS TRAVAILLENT AVEC: ────────────────────────────────   │
│     │                                                            │
│     ├─→ Stack détecté (TOUJOURS)                                │
│     ├─→ Patterns appris (SI pas de violations)                  │
│     └─→ Craft defaults pour le stack (SI violations)            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

### Phase 1: Stack Detection (ALWAYS)

#### Case A: Existing Project → Auto-Detect

```bash
# Check for stack indicators
if [ -f "package.json" ]; then
  STACK="node"
  grep -q "react" package.json && FRAMEWORK="react"
  grep -q "vue" package.json && FRAMEWORK="vue"
  [ -f "tsconfig.json" ] && LANGUAGE="typescript" || LANGUAGE="javascript"
elif [ -f "go.mod" ]; then
  STACK="go" && LANGUAGE="go"
elif [ -f "Cargo.toml" ]; then
  STACK="rust" && LANGUAGE="rust"
elif [ -f "pyproject.toml" ]; then
  STACK="python" && LANGUAGE="python"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
  STACK="jvm" && LANGUAGE="java"
fi
```

#### Case B: Empty/New Project → Guide Stack Selection

If no stack detected, **ask the user**:

```
Question: "What stack are you building with?"
Header: "Stack"
Options:
  1. "TypeScript + React"
     Description: "Frontend with React, Vite, Vitest"
  2. "TypeScript + Node"
     Description: "Backend with Node.js, Express/Fastify"
  3. "Go"
     Description: "Backend with Go, standard library or Gin/Echo"
  4. "Rust"
     Description: "Systems or backend with Rust"
  5. "Python"
     Description: "Backend with FastAPI/Django/Flask"
  6. "Other"
     Description: "Specify your stack"
```

Then ask for more specifics:

```
# If TypeScript + React:
Question: "Any preferences?"
Header: "Setup"
Options:
  1. "Full setup (Recommended)"
     Description: "Vite + Vitest + TailwindCSS + strict TS"
  2. "Minimal"
     Description: "Just React + TypeScript"
  3. "With state management"
     Description: "Add Zustand + React Query"
```

#### Store Stack Context (Phase 1 Result)

```bash
mkdir -p .spectre

cat > .spectre/context.json << EOF
{
  "stack": {
    "language": "$LANGUAGE",
    "runtime": "$STACK",
    "framework": "$FRAMEWORK",
    "setup": "$SETUP"
  },
  "learning": {
    "enabled": true,
    "scope": "project",
    "status": "pending"
  },
  "fromScratch": $FROM_SCRATCH,
  "detectedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
```

---

### Phase 2: Pattern Learning (MAY BE BLOCKED)

**Only runs if project has existing code.**

```bash
if [ "$FROM_SCRATCH" = "false" ] && [ "$LEARNING_ENABLED" = "true" ]; then
  # Scan for patterns
  # Apply craft guard
  # If violations → STOP, report, ask user
  # If clean → store patterns
fi
```

#### On Violation: What Happens

```
🔍 Learning patterns...

🛑 CRAFT VIOLATIONS DETECTED

   src/services/UserService.ts:45
   → throw new Error('User not found')
   → Violates: Explicit Error Handling

📋 Report: .spectre/violations-report.md

⚠️  Stack detected: TypeScript + React
✅  Agents will use CRAFT DEFAULTS for TypeScript + React
❌  Project patterns NOT learned (violations blocked)

   [ 🔧 Fix violations ]  [ ⏭️ Continue anyway ]  [ 🛑 Stop ]
```

#### Context After Violation

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
    "violationCount": 2
  }
}
```

**Agents still know the stack.** They use craft defaults instead of project patterns.

---

### Agent Knowledge by Stack — Dynamic Generation

**Pas de fichiers statiques.** Les craft defaults sont générés à la volée pour VOTRE stack exact.

#### Flow de génération dynamique

```
┌─────────────────────────────────────────────────────────────────┐
│                     GÉNÉRATION DYNAMIQUE                         │
│                                                                  │
│  1. DÉTECTION FINE DE LA STACK                                  │
│     ──────────────────────────                                   │
│     package.json → React 18.2 + React Query v5 + Zustand + Zod  │
│     go.mod → Go 1.21 + Gin + GORM + Zap                         │
│     Cargo.toml → Rust + Axum + SQLx + Tokio                     │
│                                                                  │
│  2. CHECK CACHE                                                  │
│     ─────────────                                                │
│     .spectre/stack-defaults.md existe et à jour ?               │
│       │                                                          │
│       ├─→ OUI → Utilise le cache                                │
│       │                                                          │
│       └─→ NON → Génère (étape 3)                                │
│                                                                  │
│  3. GÉNÉRATION VIA ARCHITECT (CRAFT-ALIGNED)                    │
│     ─────────────────────────────────────────                    │
│     Task(                                                        │
│       subagent_type: "architect",                               │
│       prompt: """                                                │
│         Génère les craft defaults pour cette stack exacte:       │
│         - TypeScript 5.3 (strict mode)                          │
│         - React 18.2                                             │
│         - React Query v5                                         │
│         - Zustand                                                │
│         - Zod                                                    │
│         - Vitest + Testing Library                               │
│                                                                  │
│         CONTRAINTES CRAFT OBLIGATOIRES:                          │
│         ─────────────────────────────────                        │
│         1. ARCHITECTURE HEXAGONALE                               │
│            - Domain au centre (pure, pas de deps)                │
│            - Ports = interfaces (ce dont le domain a besoin)     │
│            - Adapters = implémentations (React Query, etc.)      │
│            - Où placer chaque lib dans l'architecture?           │
│                                                                  │
│         2. SÉPARATION DES RESPONSABILITÉS                        │
│            - React Query = adapter pour server state             │
│            - Zustand = UI state seulement (pas business logic)   │
│            - Zod = validation aux boundaries (pas dans domain)   │
│            - Components = présentation pure                      │
│                                                                  │
│         3. ERROR HANDLING EXPLICITE                              │
│            - Result<T, E> pour le domain                         │
│            - Comment mapper avec React Query errors?             │
│            - Error boundaries React pour l'UI                    │
│                                                                  │
│         4. TESTABILITÉ                                           │
│            - Domain testable sans React                          │
│            - MSW pour les adapters (pas mock des hooks)          │
│            - Testing Library pour comportement UI                │
│                                                                  │
│         FORMAT ATTENDU:                                          │
│         ## Architecture (où chaque lib se place)                 │
│         ## Type System (strict, Result types)                    │
│         ## State Management (server vs client vs domain)         │
│         ## Error Handling (explicit, typed)                      │
│         ## Testing Strategy                                      │
│         ## Anti-patterns à éviter                                │
│       """                                                        │
│     )                                                            │
│                                                                  │
│  4. CACHE LE RÉSULTAT                                           │
│     ─────────────────                                            │
│     → Stocke dans .spectre/stack-defaults.md                    │
│     → Hash du package.json/go.mod pour invalidation             │
│                                                                  │
│  5. INJECTION DANS LES AGENTS                                   │
│     ─────────────────────────                                    │
│     Chaque agent reçoit:                                        │
│     - Stack defaults générés                                     │
│     - Project learnings (si clean)                               │
│     - La tâche demandée                                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

#### Détection fine de la stack

```bash
# Pour Node.js — parse package.json
DEPS=$(jq -r '.dependencies + .devDependencies | keys[]' package.json)

# Détecte chaque lib
echo "$DEPS" | grep -q "react" && LIBS+=("React")
echo "$DEPS" | grep -q "@tanstack/react-query" && LIBS+=("React Query v5")
echo "$DEPS" | grep -q "zustand" && LIBS+=("Zustand")
echo "$DEPS" | grep -q "zod" && LIBS+=("Zod")
echo "$DEPS" | grep -q "vitest" && LIBS+=("Vitest")
echo "$DEPS" | grep -q "@testing-library" && LIBS+=("Testing Library")
echo "$DEPS" | grep -q "tailwindcss" && LIBS+=("TailwindCSS")
echo "$DEPS" | grep -q "prisma" && LIBS+=("Prisma")

# Pour Go — parse go.mod
grep -q "gin-gonic/gin" go.mod && LIBS+=("Gin")
grep -q "gorm.io/gorm" go.mod && LIBS+=("GORM")
grep -q "go.uber.org/zap" go.mod && LIBS+=("Zap")

# Stack complète
FULL_STACK="${LANGUAGE} + ${LIBS[*]}"
# → "TypeScript + React + React Query v5 + Zustand + Zod + Vitest"
```

#### Cache et invalidation

```json
// .spectre/context.json
{
  "stack": {
    "language": "typescript",
    "runtime": "node",
    "framework": "react",
    "libs": ["react-query", "zustand", "zod", "vitest", "testing-library"],
    "versions": {
      "typescript": "5.3",
      "react": "18.2",
      "@tanstack/react-query": "5.0"
    }
  },
  "stackDefaultsHash": "a1b2c3d4",  // Hash de package.json
  "stackDefaultsGeneratedAt": "2024-01-15T10:30:00Z"
}
```

**Invalidation automatique** : si le hash de package.json/go.mod change → régénère.

#### Exemple de stack-defaults.md généré (CRAFT-ALIGNED)

```markdown
# Craft Defaults — TypeScript + React + React Query + Zustand

Généré pour: TypeScript 5.3, React 18.2, React Query v5, Zustand, Zod, Vitest

## Architecture — Où chaque lib se place

```
┌─────────────────────────────────────────────────────────────────┐
│                        INFRASTRUCTURE                            │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  UI (React Components)                                    │   │
│  │  - Présentation pure, pas de logique métier              │   │
│  │  - Zustand pour UI state (modals, sidebar, theme)        │   │
│  └──────────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Adapters                                                 │   │
│  │  - React Query = adapter pour server state               │   │
│  │  - Zod = validation aux boundaries (API responses)       │   │
│  │  - fetch/axios = HTTP adapter                            │   │
│  └──────────────────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────────────────┤
│                        APPLICATION                               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Use Cases (hooks métier)                                 │   │
│  │  - useCreateOrder() orchestre domain + adapters          │   │
│  │  - Retourne Result<T, E>, pas de throw                   │   │
│  └──────────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Ports (interfaces)                                       │   │
│  │  - OrderRepository, PaymentGateway                       │   │
│  │  - Définies dans application, implémentées en infra      │   │
│  └──────────────────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────────────────┤
│                          DOMAIN                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Entities, Value Objects, Domain Services                 │   │
│  │  - AUCUNE dépendance externe (pas de React, pas de Zod)  │   │
│  │  - Pure TypeScript, testable en isolation                │   │
│  │  - Result<T, E> pour les erreurs                         │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## Type System
- strict: true obligatoire
- Pas de `any` — utiliser `unknown` + type guards
- Props typées explicitement
- Domain types séparés des DTO/API types
- Zod pour validation + inférence (aux boundaries seulement)

## State Management — Séparation stricte

### Domain State
- Vit dans les entités du domain
- Calculé, pas stocké (derived state)
- Pas de React ici

### Server State (React Query = ADAPTER)
```typescript
// ✅ React Query est un adapter, pas le domain
// Le hook appelle un use case, pas directement l'API
function useOrders() {
  return useQuery({
    queryKey: ['orders'],
    queryFn: () => orderRepository.findAll(), // Via port/adapter
  });
}
```

### UI State (Zustand = UI seulement)
```typescript
// ✅ Zustand pour UI state uniquement
const useUIStore = create<UIState>((set) => ({
  sidebarOpen: false,
  theme: 'light',
  // ❌ PAS de business logic ici
}));
```

## Error Handling — Explicit & Typed

### Domain → Result<T, E>
```typescript
// Domain retourne des Result, jamais de throw
function createOrder(items: OrderItem[]): Result<Order, OrderError> {
  if (items.length === 0) {
    return err(new EmptyOrderError());
  }
  return ok(Order.create(items));
}
```

### React Query → Error Boundaries
```typescript
// Adapter mappe Result vers React Query
const mutation = useMutation({
  mutationFn: async (items) => {
    const result = await createOrderUseCase.execute(items);
    if (!result.ok) throw result.error; // React Query gère
    return result.value;
  },
});
```

### UI → Error Boundaries React
```tsx
<ErrorBoundary fallback={<ErrorFallback />}>
  <OrderForm />
</ErrorBoundary>
```

## Testing Strategy

### Domain (Vitest, pas de React)
```typescript
// ✅ Domain testable sans React
describe('Order', () => {
  it('should not allow empty order', () => {
    const result = createOrder([]);
    expect(result.ok).toBe(false);
  });
});
```

### Adapters (MSW pour API)
```typescript
// ✅ MSW pour mocker l'API, pas les hooks
server.use(
  http.get('/api/orders', () => HttpResponse.json(mockOrders))
);
```

### UI (Testing Library pour comportement)
```typescript
// ✅ Test le comportement utilisateur
test('user can submit order', async () => {
  render(<OrderForm />);
  await user.click(screen.getByRole('button', { name: /submit/i }));
  expect(await screen.findByText(/order confirmed/i)).toBeVisible();
});
```

## Anti-patterns à éviter

| Anti-pattern | Problème | Solution craft |
|--------------|----------|----------------|
| Business logic dans Zustand | Mélange UI/domain | Domain séparé, Zustand = UI only |
| `useEffect` pour fetch | Race conditions | React Query |
| Zod dans le domain | Domain dépend d'infra | Zod aux boundaries seulement |
| Mock des hooks React Query | Teste l'implémentation | MSW pour mock l'API |
| `throw` dans le domain | Erreurs non typées | Result<T, E> |
| Store global pour tout | Couplage fort | Server state vs UI state |
```
- Query client wrapper pour les tests

## Anti-patterns
- ❌ useEffect pour fetch (utiliser useQuery)
- ❌ useState pour server state (utiliser React Query)
- ❌ Store Zustand pour tout (séparer server/client state)
- ❌ any dans les schémas Zod
```

#### Injection complète

```
Task(
  subagent_type: "frontend-engineer",
  prompt: """
    ## Stack Context
    TypeScript + React + React Query v5 + Zustand + Zod + Vitest

    ## Craft Defaults (Généré)
    <contenu de .spectre/stack-defaults.md>

    ## Project Patterns (Appris)
    <contenu de .spectre/learnings/patterns.json>

    ## Reference Examples
    <contenu de .spectre/learnings/examples.json>

    ## Task
    <la tâche demandée>
  """
)
```

#### Avantages du dynamique

| Statique | Dynamique |
|----------|-----------|
| 5 fichiers fixes | Infini — ANY stack |
| "React" générique | "React 18.2 + React Query v5" spécifique |
| Maintenance manuelle | Auto-génération |
| Patterns génériques | Patterns pour VOS libs exactes |
| Mises à jour manuelles | Régénération si deps changent |

---

### Summary: What Agents Get

| Situation | Stack | Patterns | Source |
|-----------|-------|----------|--------|
| Clean project | ✅ Detected | ✅ Learned | Project |
| Violations found | ✅ Detected | ❌ Blocked | Craft defaults |
| From scratch | ✅ Selected | — | Craft defaults |
| Learning disabled | ✅ Detected | — | Craft defaults |

---

## The Flow

### SMART ROUTING: From Scratch vs Existing Project

**CRITICAL:** Adapt the flow based on project state.

```
┌─────────────────────────────────────────────────────────────────┐
│                     FLOW ROUTING                                 │
│                                                                  │
│  FROM SCRATCH (no code detected):                               │
│  ─────────────────────────────────                               │
│  1. Stack selection ✓ (already done in Phase 1)                 │
│  2. Work context (Product Team/Startup/etc.)                    │
│  3. SKIP "What do you want to do?" → assume BUILD               │
│  4. Go directly to domain questions                              │
│  5. Ask what to build → GO                                       │
│                                                                  │
│  EXISTING PROJECT (code detected):                               │
│  ─────────────────────────────────                               │
│  1. Auto-detect stack ✓ (already done in Phase 1)               │
│  2. Work context (Product Team/Startup/etc.)                    │
│  3. "What do you want to do?" → Build/Fix/Improve/Think         │
│  4. Continue based on choice                                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

### Step 1: What's Your Work Context?

**First time only** (remember for the session):

```
Question: "What's your work context?"
Header: "Context"
Options:
  1. "Product Team / Enterprise"
     Description: "Specs, process, reviews, multiple stakeholders"
  2. "Startup / Small Team"
     Description: "Fast iterations, agile, ship & learn"
  3. "Freelance / Solo"
     Description: "Efficient, focused, minimal overhead"
  4. "Learning / Exploring"
     Description: "Trying things out, no pressure"
```

---

### Step 2: What Do You Want to Do? (EXISTING PROJECTS ONLY)

**⚠️ SKIP THIS STEP IF `fromScratch === true`**

From scratch = nothing to fix, nothing to improve. Go directly to building.

```
# ONLY for existing projects:
if (fromScratch === false) {
  Question: "What do you want to do?"
  Header: "Goal"
  Options:
    1. "Build something new"
       Description: "New feature, component, or functionality"
    2. "Fix something"
       Description: "Bug, error, failing tests"
    3. "Improve existing code"
       Description: "Refactor, add tests, clean up"
    4. "Think / Design"
       Description: "Architecture, planning, decisions"
}

# For from-scratch projects:
if (fromScratch === true) {
  # SKIP this question
  # Assume goal = "Build something new"
  # Go directly to Step 3
}
```

---

### Step 3: Context-Specific Questions

#### If "Build something new"

**For Product Team / Enterprise:**

```
Question: "What do you have to start with?"
Header: "Input"
Options:
  1. "A PRD or feature spec"
     Description: "Product requirements document, Jira ticket, detailed spec"
  2. "A user story or brief"
     Description: "High-level requirement, needs refinement"
  3. "Just a concept"
     Description: "Idea that needs to be specced out"
```

Then:
```
Question: "What part of the system?"
Header: "Domain"
Options:
  1. "Frontend / UI"
  2. "Backend / API"
  3. "Full-stack"
```

**For Startup / Small Team:**

```
Question: "How clear are the requirements?"
Header: "Clarity"
Options:
  1. "Crystal clear — let's build"
     Description: "I know exactly what to do"
  2. "Mostly clear — might need quick design"
     Description: "90% there, need to figure out some details"
  3. "Rough idea — need to shape it"
     Description: "Know the goal, need to define the how"
```

Then:
```
Question: "Frontend, backend, or both?"
Header: "Stack"
Options:
  1. "Frontend"
  2. "Backend"
  3. "Both"
```

**For Freelance / Solo:**

```
Question: "What are you building?"
Header: "Stack"
Options:
  1. "UI / Frontend"
  2. "API / Backend"
  3. "Full-stack"
```

Then:
```
Question: "Testing?"
Header: "Quality"
Options:
  1. "Yes, with tests (Recommended)"
     Description: "QA agent verifies your work"
  2. "No, ship it"
     Description: "Just the implementation"
```

**For Learning / Exploring:**

```
Question: "What are you exploring?"
Header: "Area"
Options:
  1. "Frontend / React"
  2. "Backend / API"
  3. "Architecture patterns"
  4. "Testing practices"
```

→ Suggest appropriate craft skill directly

---

## Mapping Tables

### Product Team / Enterprise

| Input | Domain | Agents Chain |
|-------|--------|--------------|
| PRD/Spec | Frontend | `Architect → frontend-engineer → QA` |
| PRD/Spec | Backend | `Architect → backend-engineer → QA` |
| PRD/Spec | Full-stack | `Architect → backend-engineer → frontend-engineer → QA` |
| User story/Brief | Any | `PO (refine) → Architect → Dev → QA` |
| Just a concept | Any | `PO (full spec) → Architect → Dev → QA` |

**Characteristics:**
- Always includes architect for design review
- Always includes QA for testing
- PO refines unclear requirements
- Full documentation trail

### Startup / Small Team

| Clarity | Stack | Agents Chain |
|---------|-------|--------------|
| Crystal clear | Frontend | `frontend-engineer → QA` |
| Crystal clear | Backend | `backend-engineer → QA` |
| Crystal clear | Full-stack | `backend-engineer → frontend-engineer → QA` |
| Mostly clear | Any | `Architect (quick) → Dev → QA` |
| Rough idea | Any | `Architect → Dev → QA` |

**Characteristics:**
- Skip PO — you ARE the PO
- Architect only when needed
- Always QA for quality
- Fast feedback loop

### Freelance / Solo

| Stack | Testing | Agents Chain |
|-------|---------|--------------|
| Frontend | Yes | `frontend-engineer → QA` |
| Frontend | No | `frontend-engineer` |
| Backend | Yes | `backend-engineer → QA` |
| Backend | No | `backend-engineer` |
| Full-stack | Yes | `backend-engineer → frontend-engineer → QA` |
| Full-stack | No | `backend-engineer → frontend-engineer` |

**Characteristics:**
- Direct to implementation
- Testing is optional (but recommended)
- Minimal overhead
- Maximum efficiency

### Learning / Exploring

| Area | Agent |
|------|-------|
| Frontend/React | `frontend-engineer` (educational mode) |
| Backend/API | `backend-engineer` (educational mode) |
| Architecture | `architect` (design mode) |
| Testing | `qa-engineer` (educational mode) |

**Characteristics:**
- Educational mode
- Single agent explains concepts
- No pressure
- Pedagogical approach prioritized

---

## Step 4: Get Task Description

Context-appropriate prompt:

**Product Team:**
```
"Paste the PRD/spec or describe the feature:"
```

**Startup:**
```
"What are you building? (Keep it brief)"
```

**Freelance:**
```
"What do you need?"
```

**Learning:**
```
"What do you want to learn about?"
```

---

## Step 5: Confirm and Launch

Show context-appropriate summary:

### Product Team Example

```markdown
## Workflow for: User Authentication Feature

**Context:** Product Team / Enterprise
**Input:** PRD provided
**Domain:** Full-stack

### Agents Pipeline:

┌────────────────┐     ┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│   Architect    │ ──▶ │  backend-engineer   │ ──▶ │  frontend-engineer  │ ──▶ │  qa-engineer   │
│                │     │                │     │                │     │                │
│ • Tech design  │     │ • API          │     │ • UI           │     │ • Tests        │
│ • Data model   │     │ • Auth logic   │     │ • Forms        │     │ • Verification │
│ • Security     │     │ • Validation   │     │ • State        │     │ • Compliance   │
└────────────────┘     └────────────────┘     └────────────────┘     └───────┬────────┘
                                                      ▲                      │
                                                      └──── fix & retry ─────┘

**Output:** Tech spec → Implementation → Tested code
```

### Startup Example

```markdown
## Quick Build: Login Form

**Context:** Startup / Fast iteration
**Clarity:** Crystal clear
**Stack:** Frontend

### Agents:

┌────────────────┐     ┌────────────────┐
│  frontend-engineer  │ ──▶ │  qa-engineer   │
│                │     │                │
│ Build it       │     │ Test it        │
└────────────────┘     └───────┬────────┘
        ▲                      │
        └──── loop if needed ──┘

**Time to first feedback:** Fast ⚡
```

### Freelance Example

```markdown
## Task: Add Payment Form

**Context:** Freelance / Efficient
**Stack:** Frontend
**Testing:** Yes

### Agent:

frontend-engineer → qa-engineer (verify)

**Approach:** Direct implementation with quality check.
```

---

## Smart Context Detection

If user provides hints, detect context:

| Signal | Detected Context |
|--------|------------------|
| "PRD", "Jira", "spec", "requirements doc" | Product Team |
| "quick", "MVP", "ship it", "iterate" | Startup |
| "client", "project", "deadline" | Freelance |
| "learn", "try", "explore", "understand" | Learning |

---

## Remember Context

Store context for the session:

```json
// .spectre/context.json
{
  "workContext": "startup",
  "defaultStack": "frontend",
  "preferTesting": true
}
```

On subsequent `/craft` calls, skip Step 1 and use stored context.

To change: `/craft --reset` or answer "Other" to change context.

---

## Example Conversations

### FROM SCRATCH: New Project (Smart Flow)

```
User: /craft

Bot: 🔍 No project detected.
     "What stack are you building with?"
     [TypeScript + React] [TypeScript + Node] [Go] [Rust] [Python]

User: [TypeScript + React]

Bot: "Any preferences?"
     [Full setup] [Minimal] [With state management]

User: [Full setup]

Bot: ✅ Stack configured: TypeScript + React + Vite + Vitest + TailwindCSS

     "What's your work context?"
     [Product Team] [Startup] [Freelance] [Learning]

User: [Startup / Small Team]

Bot: "What part of the system?"                    ← SKIPPED "What do you want to do?"
     [Frontend] [Backend] [Full-stack]               (from scratch = obviously BUILD)

User: [Frontend]

Bot: "What are you building?"

User: "User authentication with social login"

Bot:
## New Project: User Authentication

**Stack:** TypeScript + React (Vite, Vitest, TailwindCSS)
**Context:** Startup / Fast iteration

### Agents:

architect → frontend-engineer → qa-engineer

Setting up project structure and starting architect...
```

**Key insight:** From scratch, we SKIP "Build/Fix/Improve?" — there's nothing to fix or improve yet.

---

### EXISTING PROJECT: Product Team Building from PRD

```
User: /craft

Bot: 🔍 Detected: TypeScript + React + Vite
     🔍 Learning patterns...
     ✅ Patterns learned (no violations)

     "What's your work context?"
     [Product Team] [Startup] [Freelance] [Learning]

User: [Product Team / Enterprise]

Bot: "What do you want to do?"                     ← SHOWN because existing project
     [Build something new] [Fix] [Improve] [Think]

User: [Build something new]

Bot: "What do you have to start with?"
     [A PRD or feature spec] [A user story] [Just a concept]

User: [A PRD or feature spec]

Bot: "What part of the system?"
     [Frontend] [Backend] [Full-stack]

User: [Full-stack]

Bot: "Paste the PRD or describe the feature:"

User: "User authentication with OAuth2, email/password, and 2FA support.
       See PRD-2024-AUTH in Confluence."

Bot:
## Enterprise Workflow: Authentication System

**Context:** Product Team
**Input:** PRD-2024-AUTH
**Scope:** Full-stack

### Pipeline:

1. **architect** — Technical design & security review
2. **backend-engineer** — API, auth logic, OAuth integration
3. **frontend-engineer** — Login UI, forms, state management
4. **qa-engineer** — Security tests, E2E, compliance

Starting architect...
```

---

### EXISTING PROJECT: Startup Quick Feature

```
User: /craft

Bot: 🔍 Detected: TypeScript + React
     ✅ Stack + patterns loaded

     "What's your work context?"

User: [Startup / Small Team]

Bot: "What do you want to do?"

User: [Build something new]

Bot: "How clear are the requirements?"
     [Crystal clear] [Mostly clear] [Rough idea]

User: [Crystal clear — let's build]

Bot: "Frontend, backend, or both?"

User: [Frontend]

Bot: "What are you building?"

User: "Dark mode toggle"

Bot:
## Quick Build: Dark Mode Toggle

frontend-engineer → qa-engineer

Starting frontend-engineer...
```

### EXISTING PROJECT: Freelance Fix & Ship

```
User: /craft

Bot: 🔍 Detected: TypeScript + Node
     ✅ Stack loaded

     "What's your work context?"

User: [Freelance / Solo]

Bot: "What do you want to do?"                     ← SHOWN because existing project
     [Build something new] [Fix] [Improve] [Think]

User: [Fix something]

Bot: "Describe the problem:"

User: "API returns 500 on invalid email format"

Bot:
## Fix: API 500 Error

backend-engineer → qa-engineer (verify)

Starting backend-engineer...
```

---

### EXISTING PROJECT: Freelance Build with Tests

```
User: /craft

Bot: 🔍 Detected: TypeScript + React
     ✅ Stack loaded

     "What's your work context?"

User: [Freelance / Solo]

Bot: "What do you want to do?"

User: [Build something new]

Bot: "What are you building?"
     [UI / Frontend] [API / Backend] [Full-stack]

User: [UI / Frontend]

Bot: "Testing?"
     [Yes, with tests] [No, ship it]

User: [Yes, with tests]

Bot: "What do you need?"

User: "Contact form with validation"

Bot:
## Task: Contact Form

frontend-engineer → qa-engineer

Starting...
```

---

## Tone by Context

| Context | Tone |
|---------|------|
| Product Team | Professional, thorough, documentation-focused |
| Startup | Energetic, fast, pragmatic |
| Freelance | Efficient, direct, no fluff |
| Learning | Patient, educational, encouraging |

---

## Agent Invocation

### How to Spawn Agents

Use the **Task tool** with the appropriate `subagent_type`:

```
Task tool:
  subagent_type: "architect"
  prompt: "Design the technical architecture for: <task>"
```

### Available Agent Types

| Agent | subagent_type | Use For |
|-------|---------------|---------|
| Product Owner | `product-owner` | User stories, specs, acceptance criteria |
| Architect | `architect` | Architecture, design, code review |
| Frontend Engineer | `frontend-engineer` | UI implementation, React, components |
| Backend Engineer | `backend-engineer` | API implementation, services, data |
| QA Engineer | `qa-engineer` | Tests, verification, quality |

### Chaining Agents

For pipelines like `Architect → Dev → QA`:

1. Spawn first agent, wait for completion
2. Pass output as context to next agent
3. Continue chain until QA passes or max retries

### Reactive Loop

When QA finds errors:
1. Parse error type (test failure, design flaw, spec gap)
2. Route to appropriate agent based on error
3. Re-run QA after fix
4. Loop until success (max 3 retries)

### Example: Startup Frontend Flow

```
# Step 1: Spawn frontend-engineer
Task(
  subagent_type: "frontend-engineer",
  prompt: "Implement: <task>\n\nContext: Startup mode, fast iteration."
)

# Step 2: On completion, spawn qa-engineer
Task(
  subagent_type: "qa-engineer",
  prompt: "Verify implementation:\n<what was built>\n\nAcceptance criteria:\n<criteria>"
)

# Step 3: If QA fails, loop back to frontend-engineer with error context
Task(
  subagent_type: "frontend-engineer",
  prompt: "Fix this error:\n<error details>\n\nOriginal task: <task>"
)
```
