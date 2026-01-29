# Spectre Agents — Architecture & Documentation

> Document de synthèse technique du système multi-agents réactif Spectre.

## Table des matières

1. [Vue d'ensemble](#vue-densemble)
2. [Philosophie](#philosophie)
3. [Composants](#composants)
   - [Agents](#agents)
   - [Skills](#skills)
   - [Scripts & Hooks](#scripts--hooks)
4. [Architecture Réactive](#architecture-réactive)
5. [Flux de données](#flux-de-données)
6. [Installation & Configuration](#installation--configuration)
7. [Utilisation](#utilisation)
8. [Extension du système](#extension-du-système)

---

## Vue d'ensemble

Spectre Agents est une bibliothèque d'agents et skills pour Claude Code, orientée **Software Craftsmanship**. Sa particularité : un **système réactif** où les agents collaborent automatiquement et s'auto-corrigent.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         SPECTRE AGENTS                                  │
│                                                                         │
│            ┌─────────────┐ ┌─────────────┐ ┌─────────────┐              │
│            │   /learn    │ │   /craft    │ │   /heal     │              │
│            │   adapt     │ │   create    │ │   repair    │              │
│            └──────┬──────┘ └──────┬──────┘ └──────┬──────┘              │
│                   │               │               │                     │
│                   ▼               └───────┬───────┘                     │
│            ┌─────────────┐                ▼                             │
│            │  LEARNINGS  │◀────── injects into ────────┐                │
│            │             │                             │                │
│            │ • code      │     ┌─────────────────┐     │                │
│            │ • tests     │     │     AGENTS      │     │                │
│            │ • specs     │────▶│                 │◀────┘                │
│            │ • style     │     │ • software-     │                      │
│            └─────────────┘     │   craftsman     │                      │
│                                │ • product-owner │                      │
│  ┌─────────────────┐           │ • frontend-dev  │                      │
│  │  CRAFT SKILLS   │           │ • qa-engineer   │                      │
│  │                 │           │                 │                      │
│  │ • typescript-   │           └────────┬────────┘                      │
│  │   craft         │                    │                               │
│  │ • react-craft   │           ┌────────▼────────┐                      │
│  │ • test-craft    │           │ REACTIVE SYSTEM │                      │
│  │ • init-frontend │           │                 │                      │
│  │                 │           │ • 8 agent links │                      │
│  └─────────────────┘           │ • smart routing │                      │
│                                │ • auto-correct  │                      │
│                                └─────────────────┘                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Philosophie

### Principes Craft

Chaque composant incarne :

| Principe | Description |
|----------|-------------|
| **Domain First** | Le métier au centre, les frameworks en périphérie |
| **Type Safety** | Le système de types comme filet de sécurité |
| **Explicit over Implicit** | Gestion explicite des erreurs, pas d'exceptions silencieuses |
| **Test-Driven** | Les tests comme spécifications exécutables |
| **Pedagogy** | Expliquer le "pourquoi" avant le "comment" |

### Ce qui différencie Spectre

| Aspect | Autres libs (BMAD) | Spectre |
|--------|-------------------|---------|
| Workflow | Linéaire, séquentiel | **Réactif, boucle de feedback** |
| Erreurs | Humain intervient | **Auto-correction par agents** |
| Mémoire | Aucune persistence | **Learnings accumulés** |
| Communication | Documents statiques | **État partagé + hooks** |

---

## Composants

### Agents

Les agents sont des personnalités spécialisées avec leur propre expertise.

#### Localisation
```
~/.claude/agents/           # Installés par install.sh
.claude/agents/             # Projet-specific (si besoin)
```

#### Format (YAML frontmatter + Markdown)
```yaml
---
name: agent-name
description: "Quand utiliser cet agent..."
model: opus | sonnet | haiku
color: purple | blue | green | yellow | cyan
tools: Read, Write, Edit, Bash, ...
---

# System Prompt

Instructions détaillées pour l'agent...
```

#### Liste des agents

| Agent | Modèle | Rôle | Expertise |
|-------|--------|------|-----------|
| **software-craftsman** | opus | Architecte | Clean Architecture, DDD, SOLID, TDD/BDD |
| **product-owner** | sonnet | Produit | User stories, acceptance criteria, priorisation |
| **frontend-dev** | sonnet | Implémentation UI | React, accessibility, state, testing |
| **qa-engineer** | sonnet | Qualité | Test strategy, TDD/BDD, test pyramid |
| **orchestrator** | sonnet | Coordination | Boucle réactive, routing, retry |

#### Quand sont-ils invoqués ?

1. **Automatiquement** : Claude Code lit la `description` et délègue quand pertinent
2. **Explicitement** : "Use the qa-engineer agent to..."
3. **Par skill** : Le skill spécifie son agent via `agent: frontend-dev`
4. **Par hooks** : SubagentStop déclenche le routing

---

### Skills

Les skills sont des capacités invocables via `/nom-du-skill`.

#### Localisation
```
~/.claude/skills/           # Installés par install.sh
.claude/skills/             # Projet-specific
```

#### Format
```yaml
---
name: skill-name
description: "Ce que fait le skill"
context: fork | conversation
agent: agent-qui-execute
allowed-tools: Read, Write, Edit, Bash, ...
---

# Instructions du skill

Détails d'exécution...
```

#### Liste des skills

| Skill | Description |
|-------|-------------|
| **/craft** | **Build** — mode guidé adapté au contexte |
| **/heal** | **Fix** — auto-réparation (tests, build, types) |
| **/learn** | **Adapt** — apprend les conventions du projet |
| **/typescript-craft** | Principes craft TypeScript |
| **/react-craft** | Principes craft React |
| **/test-craft** | TDD/BDD, test pyramid |
| **/init-frontend** | Bootstrap projet React |

#### Context: fork vs conversation

- **fork** : S'exécute dans un sous-agent isolé (nouveau contexte)
- **conversation** : S'exécute dans la conversation principale

#### Le skill `/craft` en détail

Mode interactif adapté au **contexte de travail** de l'utilisateur.

**Philosophie** : Différents contextes = différents workflows.

##### Étape 1: Contexte de travail

```
┌─────────────────────────────────────────────────────────────────┐
│  "What's your work context?"                                    │
│                                                                 │
│  [ Product Team / Enterprise ]  → Specs, process, compliance    │
│  [ Startup / Small Team ]       → Fast iterations, ship & learn │
│  [ Freelance / Solo ]           → Efficient, minimal overhead   │
│  [ Learning / Exploring ]       → Educational, no pressure      │
└─────────────────────────────────────────────────────────────────┘
```

##### Étape 2: Objectif

```
┌─────────────────────────────────────────────────────────────────┐
│  "What do you want to do?"                                      │
│                                                                 │
│  [ Build something new ]    [ Fix something ]                   │
│  [ Improve existing code ]  [ Think / Design ]                  │
└─────────────────────────────────────────────────────────────────┘
```

##### Étape 3: Questions contextuelles

Les questions s'adaptent au contexte :

| Contexte | Questions pour "Build" |
|----------|------------------------|
| **Product Team** | "PRD ou spec?" "Quel système?" |
| **Startup** | "Requirements clairs?" "Frontend/Backend?" |
| **Freelance** | "Stack?" "Testing?" |
| **Learning** | "Quel domaine?" → Craft skill direct |

##### Workflows par contexte

**🏢 Product Team / Enterprise**

| Input | Workflow |
|-------|----------|
| PRD / Feature Spec | `Architect → Dev → QA` |
| User Story (à raffiner) | `PO → Architect → Dev → QA` |
| Concept seul | `PO (spec complète) → Architect → Dev → QA` |

Caractéristiques : Reviews obligatoires, documentation, compliance.

**🚀 Startup / Small Team**

| Clarté | Workflow |
|--------|----------|
| Crystal clear | `Dev → QA` |
| Mostly clear | `Architect (quick) → Dev → QA` |
| Rough idea | `Architect → Dev → QA` |

Caractéristiques : Pas de PO (vous êtes le PO), QA inclus, itérations rapides.

**💼 Freelance / Solo**

| Testing | Workflow |
|---------|----------|
| Oui | `Dev → QA` |
| Non | `Dev` seul |

Caractéristiques : Implémentation directe, overhead minimal.

**📚 Learning / Exploring**

| Domaine | Action |
|---------|--------|
| Frontend/React | `/react-craft` |
| Backend/API | `software-craftsman` guidance |
| Architecture | `software-craftsman` |
| Testing | `/test-craft` |

Caractéristiques : Mode éducatif, explications prioritaires.

#### Le skill `/heal` en détail

Auto-réparation : détecte ce qui est cassé (code OU specs) et répare automatiquement.

##### Usage

```bash
/heal           # Diagnostique et répare tout (code + specs)
/heal tests     # Répare les tests qui échouent
/heal build     # Répare les erreurs de build
/heal types     # Répare les erreurs TypeScript
/heal lint      # Répare les erreurs de lint
/heal spec      # Répare les écarts spec/implémentation
```

##### Ce qui peut être réparé

**🔧 Code**
- Tests qui échouent
- Erreurs de build
- Erreurs TypeScript
- Erreurs de lint

**📋 Specs**
- Spec qui ne correspond pas à l'implémentation
- Critères d'acceptation manquants
- User stories incomplètes
- Contradictions dans les requirements

##### Flow Code

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│  Diagnose   │ ──────▶ │    Fix      │ ──────▶ │   Verify    │
└─────────────┘         └─────────────┘         └──────┬──────┘
                                                       │
                                            ┌──────────┴──────────┐
                                          PASS                  FAIL
                                            │                     │
                                      ✅ Healed!            🔄 Retry (max 3)
```

##### Flow Spec

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│  Read Spec  │         │  Read Code  │         │   Compare   │
└──────┬──────┘         └──────┬──────┘         └──────┬──────┘
       └───────────────────────┴───────────────────────┘
                               │
                    ┌──────────┴──────────┐
                    ▼                     ▼
             Update Spec           Update Code
             (--sync)              (--impl)
```

##### Détection automatique

| Pattern détecté | Type | Agent |
|-----------------|------|-------|
| `FAIL`, `expect`, `assertion` | Test failure | `frontend-dev` / `backend-dev` |
| `error TS`, `not assignable` | Type error | `software-craftsman` |
| `Build failed`, `Module not found` | Build error | `software-craftsman` |
| `eslint`, `prettier` | Lint error | Dernier dev actif |
| Spec vs code mismatch | Spec drift | `product-owner` |
| Missing acceptance criteria | Incomplete spec | `product-owner` |

##### Ordre de réparation

1. **Types** (causent souvent d'autres erreurs)
2. **Build** (on ne peut pas tester sans build)
3. **Tests** (fonctionnalité core)
4. **Lint** (qualité de code)
5. **Specs** (documentation et alignment)

##### Learnings

Après une réparation réussie, le pattern est enregistré dans `.spectre/learnings.jsonl` pour accélérer les futures réparations similaires.

#### Le skill `/learn` en détail

Auto-apprentissage des conventions du projet. Les agents s'adaptent à VOS pratiques.

##### Usage

```bash
/learn                       # Analyse complète du projet
/learn code                  # Architecture & patterns de code
/learn tests                 # Conventions de test
/learn specs                 # Format des specs
/learn style                 # Naming & formatting
/learn <file>                # Apprendre d'un fichier exemplaire
/learn <folder>              # Apprendre d'un dossier spécifique
/learn --example <file>      # Marquer comme gold standard
/learn --show                # Afficher les apprentissages
/learn --reset               # Reset
```

##### Fine-Tuning

| Scope | Confiance | Usage |
|-------|-----------|-------|
| Projet complet | 0.6-0.8 | Vue d'ensemble |
| Fichier spécifique | 0.85 | "Apprends de ce fichier" |
| `--example` | 0.95 | "C'est LE standard" |
| Correction user | 0.99 | Override explicite |

```bash
# Marquer un fichier comme référence
/learn --example src/features/auth/AuthService.ts

# Les agents référenceront ce fichier pour écrire des services similaires
```

##### Ce qui est appris

| Catégorie | Patterns Détectés |
|-----------|-------------------|
| **Tech Stack** | Framework, build tool, test framework |
| **Architecture** | Structure folders, layers, imports |
| **Code Style** | Error handling, async patterns, exports |
| **Test Style** | Framework, structure, mocking, fixtures |
| **Spec Format** | Sections, user stories, acceptance criteria |
| **Naming** | Files, components, functions, types |
| **Formatting** | Prettier config, line length, quotes |

##### Storage

```
.spectre/learnings/
├── tech-stack.json       # Technologies détectées
├── code-patterns.json    # Architecture & code
├── test-patterns.json    # Testing
├── spec-patterns.json    # Specs/PRD
├── style-patterns.json   # Naming & formatting
└── summary.md            # Résumé lisible
```

##### Exemple de code-patterns.json

```json
{
  "architecture": {
    "pattern": "feature-based",
    "layers": {
      "features": "src/features/",
      "shared": "src/components/"
    }
  },
  "imports": {
    "style": "absolute",
    "alias": "@/",
    "barrels": true
  },
  "errorHandling": {
    "pattern": "result-type",
    "throwsExceptions": false
  },
  "confidence": 0.85
}
```

##### Injection dans le Contexte Agent

Quand un agent démarre, il reçoit les learnings :

```
## Conventions du Projet (via /learn)

**Architecture:** Feature-based (src/features/)
**Imports:** Absolus avec @/, barrel exports
**Error handling:** Result<T, E>, pas d'exceptions
**Tests:** Vitest, co-localisés, BDD naming
**Specs:** Markdown avec Gherkin AC
```

##### Apprentissage Incrémental

Les learnings s'améliorent avec le temps :

| Source | Ce qui est appris |
|--------|-------------------|
| **Fixes** | Patterns qui marchent |
| **Code reviews** | Feedback de l'architecte |
| **User corrections** | Corrections explicites |

Confiance ajustée :
- Détection initiale : 0.7
- Confirmé par usage : +0.1
- Contredit : -0.2
- Corrigé par user : → 0.95

---

### Scripts & Hooks

#### Scripts

```
scripts/
├── spectre-router.sh       # Logique de routage principal
├── on-agent-stop.sh        # Handler pour SubagentStop
├── check-test-results.sh   # Parser les résultats de tests
└── setup-reactive.sh       # Configure un projet
```

##### spectre-router.sh

Le cerveau du système réactif — **routage intelligent** basé sur le type d'erreur :

```bash
./scripts/spectre-router.sh <action> [args]

Actions:
  agent <name> [options]     # Démarre un agent avec liens réactifs
  agent-complete <agent>     # Appelé quand un agent termine
  test-result                # Analyse les résultats de tests (stdin)
  error <agent> [message]    # Enregistre une erreur
  ownership <agent> <files>  # Track qui a modifié quels fichiers
  status                     # Affiche l'état actuel
  links                      # Affiche la configuration des liens
  init <feature> [stack]     # Initialise un workflow (frontend|backend|fullstack)

Options pour 'agent':
  --link, -l <agents>        # Agents à lier (séparés par virgule)
  --stack, -s <stack>        # Contexte stack (frontend|backend|fullstack)
  --task, -t <description>   # Description de la tâche

Raccourcis agents: front, back, arch, qa, po
```

**Détection des types d'erreur** :

| Type | Pattern détecté | Agent routé |
|------|-----------------|-------------|
| `type_error` | TS errors, type mismatch | software-craftsman |
| `test_failure` | FAIL, expect, assertion | frontend-dev / backend-dev |
| `build_error` | compilation, module not found | dev du stack |
| `runtime_error` | TypeError, undefined | dev du stack |
| `lint_error` | eslint, prettier | dernier dev actif |
| `accessibility_error` | a11y, aria, axe | frontend-dev |
| `design_issue` | circular dependency | software-craftsman |

**Logique de routage intelligente** :

```
1. Détection du type d'erreur
         ↓
2. Check ownership du fichier (.spectre/ownership.json)
         ↓
3. Si owner connu → route vers owner
         ↓
4. Sinon → route selon type d'erreur + stack
```

**Support multi-stack** :

| Stack | Workflow |
|-------|----------|
| `frontend` | PO → Architect → frontend-dev → QA |
| `backend` | PO → Architect → backend-dev → QA |
| `fullstack` | PO → Architect → backend-dev → frontend-dev → QA |

##### on-agent-stop.sh

Hook SubagentStop — déclenché quand un agent termine :

```bash
# Agents Spectre écoutés :
# qa-engineer | frontend-dev | backend-dev | software-craftsman | product-owner

# Reçoit JSON avec agent_type
# Route vers spectre-router.sh agent-complete
```

##### check-test-results.sh

Hook PostToolUse (Bash) — analyse les commandes :

```bash
# Commandes analysées :
# - Tests: vitest, jest, playwright, cypress, mocha
# - Build: npm run build, tsc, vite build
# - Lint: eslint, prettier

# Actions :
# - Parse output pour détecter erreurs
# - Track ownership sur git commit
# - Route erreurs vers spectre-router.sh
```

#### Configuration des Hooks

Dans `.claude/settings.json` du projet :

```json
{
  "hooks": {
    "SubagentStop": [
      {
        "matcher": "qa-engineer|frontend-dev|backend-dev|software-craftsman|product-owner",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/spectre/on-agent-stop.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/spectre/check-test-results.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Architecture Réactive

### Vue d'ensemble — Tous les liens

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    COMPLETE REACTIVE SYSTEM                              │
│                                                                          │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                        AGENT NETWORK                               │  │
│  │                                                                    │  │
│  │                    ┌─────────────────┐                             │  │
│  │        ┌──────────▶│  product-owner  │◀──────────────┐             │  │
│  │        │           └────────┬────────┘               │             │  │
│  │        │                    │                        │             │  │
│  │   contradiction        spec │                   spec_gap           │  │
│  │   feasibility               │                   unclear            │  │
│  │        │                    ▼                        │             │  │
│  │        │           ┌─────────────────┐               │             │  │
│  │        └───────────│    software-    │◀──────────────│─────┐       │  │
│  │                    │    craftsman    │               │     │       │  │
│  │        ┌──────────▶└────────┬────────┘               │     │       │  │
│  │        │                    │                        │     │       │  │
│  │   design_block         design│review            design_flaw│       │  │
│  │        │                    │                              │       │  │
│  │        │                    ▼                              │       │  │
│  │        │           ┌─────────────────┐                     │       │  │
│  │        └───────────│   frontend-dev  │─────────────────────│───┐   │  │
│  │                    │   backend-dev   │                     │   │   │  │
│  │                    └────────┬────────┘                     │   │   │  │
│  │                             │                              │   │   │  │
│  │                        code │                              │   │   │  │
│  │                             ▼                              │   │   │  │
│  │                    ┌─────────────────┐                     │   │   │  │
│  │                    │   qa-engineer   │─────────────────────┘   │   │  │
│  │                    └────────┬────────┘                         │   │  │
│  │                             │                                  │   │  │
│  │                       test_failure ────────────────────────────┘   │  │
│  │                                                                    │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Matrice des Liens Réactifs

| Source | Cible | Trigger | Description |
|--------|-------|---------|-------------|
| **QA → Dev** | frontend-dev / backend-dev | Test failure | Dev fixes failing tests |
| **QA → Architect** | software-craftsman | Design flaw | Architect redesigns |
| **QA → PO** | product-owner | Unclear criteria | PO clarifies spec |
| **Dev → Architect** | software-craftsman | Design block | Architect adjusts design |
| **Dev → PO** | product-owner | Spec gap | PO completes requirements |
| **Architect → PO** | product-owner | Contradiction | PO arbitrates tradeoff |
| **Architect → Dev** | frontend-dev / backend-dev | Code review | Dev improves code |

### Détection des Types d'Erreur

| Type | Patterns Détectés | Agent Cible |
|------|-------------------|-------------|
| `test_failure` | FAIL, expect, assertion, ✕ | Dev (owner) |
| `type_error` | error TS, not assignable, Type | software-craftsman |
| `design_flaw` | circular, race condition, deadlock, coupling | software-craftsman |
| `build_error` | Build failed, Module not found, compilation | software-craftsman |
| `lint_error` | eslint, prettier, warning | Dev (last active) |
| `spec_gap` | edge case, not covered, what if, missing | product-owner |
| `unclear_criteria` | ambiguous, not specified, undefined | product-owner |
| `contradiction` | impossible, mutually exclusive, conflict | product-owner |
| `design_block` | cannot implement, blocked, need decision | software-craftsman |
| `spec_drift` | mismatch between spec and code | product-owner |

### Workflow Visuel (Ancien vs Nouveau)

**Avant (linéaire) :**
```
PO → Architect → Dev → QA → (fail?) → Dev → QA
```

**Maintenant (mesh réactif) :**
```
PO ◀──────────────────────────────────────────────┐
 │                                                │
 ├── contradiction ◀─────── Architect             │
 ├── spec_gap ◀──────────── Dev                   │
 └── unclear ◀───────────── QA                    │
                                                  │
Architect ◀───────────────────────────────────────│──┐
 │                                                │  │
 ├── design_block ◀────────── Dev                 │  │
 └── design_flaw ◀─────────── QA                  │  │
                                                  │  │
Dev ◀─────────────────────────────────────────────│──│──┐
 │                                                │  │  │
 ├── test_failure ◀────────── QA ─────────────────┘  │  │
 └── review_feedback ◀─────── Architect ─────────────┘  │
                                                        │
QA ◀────────────────────────────────────────────────────┘
 │
 └── (verifies everything, routes errors to right agent)
```

### Shared State (.spectre/)

```
.spectre/
├── state.json        # État du workflow
├── errors.jsonl      # Log des erreurs (append-only)
├── events.jsonl      # Log des événements
├── learnings.jsonl   # Patterns appris (fixes)
├── ownership.json    # Qui a modifié quels fichiers
├── links.json        # Configuration des liens réactifs (/agent)
├── context.json      # Contexte de la feature courante
├── trigger           # Fichier de déclenchement (transitoire)
└── learnings/        # Conventions du projet (/learn)
    ├── tech-stack.json
    ├── code-patterns.json
    ├── test-patterns.json
    ├── spec-patterns.json
    ├── style-patterns.json
    └── summary.md
```

#### state.json

```json
{
  "workflow": "feature",
  "feature": "user-login",
  "stack": "frontend",
  "phase": "verify",
  "retryCount": 1,
  "maxRetries": 3,
  "agents": {
    "lastActive": "qa-engineer",
    "lastDev": "frontend-dev",
    "history": ["product-owner", "software-craftsman", "frontend-dev", "qa-engineer"]
  },
  "status": "in_progress"
}
```

#### errors.jsonl

```jsonl
{"timestamp":"...","type":"test_failure","message":"Button not found","file":"src/Login.tsx","resolved":false,"routedTo":"frontend-dev"}
{"timestamp":"...","type":"type_error","message":"Property 'name' does not exist","file":"src/User.ts","resolved":true,"routedTo":"software-craftsman"}
{"timestamp":"...","type":"design_flaw","message":"Circular dependency detected","file":"src/services/","resolved":false,"routedTo":"software-craftsman"}
{"timestamp":"...","type":"spec_gap","message":"Edge case: empty cart not specified","file":"checkout.spec.md","resolved":true,"routedTo":"product-owner"}
{"timestamp":"...","type":"unclear_criteria","message":"What does 'fast' mean?","file":"performance.spec.md","resolved":false,"routedTo":"product-owner"}
{"timestamp":"...","type":"contradiction","message":"Offline + real-time sync conflict","file":"sync.spec.md","resolved":true,"routedTo":"product-owner"}
{"timestamp":"...","type":"design_block","message":"Cannot implement without API change","file":"src/api/","resolved":false,"routedTo":"software-craftsman"}
```

#### Error Types Reference

| Type | Description | Routed To |
|------|-------------|-----------|
| `test_failure` | Test assertion failed | Dev (owner) |
| `type_error` | TypeScript compilation error | software-craftsman |
| `design_flaw` | Architectural issue (circular dep, race condition) | software-craftsman |
| `build_error` | Build/compilation failure | software-craftsman |
| `lint_error` | ESLint/Prettier violation | Dev (last active) |
| `spec_gap` | Missing requirement or edge case | product-owner |
| `unclear_criteria` | Ambiguous acceptance criteria | product-owner |
| `contradiction` | Conflicting requirements | product-owner |
| `design_block` | Implementation blocked by design | software-craftsman |
| `spec_drift` | Code doesn't match specification | product-owner |

#### learnings.jsonl

```jsonl
{"timestamp":"...","error_type":"test_failure","file_pattern":"*.tsx","fixed_by":"frontend-dev","solution":"Added data-testid","confidence":0.7}
{"timestamp":"...","error_type":"type_error","file_pattern":"*.ts","fixed_by":"software-craftsman","solution":"Added type guard","confidence":0.85}
```

#### ownership.json

```json
{
  "src/components/Login.tsx": "frontend-dev",
  "src/api/auth.ts": "backend-dev",
  "src/types/user.ts": "software-craftsman"
}
```

Le routeur utilise ownership pour router les erreurs vers l'agent qui a écrit le code.

#### links.json

Créé par `/agent` pour configurer les liens réactifs :

```json
{
  "primary": "frontend-dev",
  "links": ["qa-engineer"],
  "stack": "frontend",
  "task": "Build login form"
}
```

| Champ | Description |
|-------|-------------|
| `primary` | Agent principal qui travaille |
| `links` | Agents à déclencher après (chaîne réactive) |
| `stack` | Contexte stack (frontend, backend, fullstack) |
| `task` | Description de la tâche |

**Exemple de chaîne réactive** :
```
primary: frontend-dev, links: [qa-engineer]

frontend-dev → qa-engineer → (error?) → frontend-dev → qa-engineer → ...
```

### Mode Agent vs Mode Workflow

| Aspect | `/reactive-loop` | `/agent` |
|--------|------------------|----------|
| Workflow | PO → Arch → Dev → QA | Agent choisi + liens |
| Flexibilité | Fixe | Configurable |
| Usage | Feature complète | Tâche spécifique |
| Liens | Implicites | Explicites (--link) |

### Phases du Workflow

| Phase | Agent | Entrée | Sortie | Reactive Routes |
|-------|-------|--------|--------|-----------------|
| `define` | product-owner | Feature description | user-story.md | — |
| `design` | software-craftsman | User story | technical-design.md | → PO (contradiction) |
| `implement` | frontend-dev | Tech spec | Code + tests | → Architect (blocked), → PO (spec gap) |
| `verify` | qa-engineer | Implementation | Test results | → Dev (test fail), → Architect (design flaw), → PO (unclear) |
| `fix` | varies | Error details | Fixed code | Based on error type |
| `review` | software-craftsman | Code | Review feedback | → Dev (improve) |
| `complete` | — | All tests pass | Feature done | — |

### Mécanisme de Retry

```
retryCount < maxRetries (3)?
    │
    ├── OUI → Spawn frontend-dev avec contexte d'erreur
    │         └── Après fix → Spawn qa-engineer pour re-verify
    │
    └── NON → Arrêt avec message d'erreur
              └── Demande intervention humaine
```

---

## Flux de données

### 1. Démarrage d'une feature

```
User: /reactive-loop
         │
         ▼
┌─────────────────────┐
│  Initialize State   │
│  .spectre/state.json│
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Spawn product-owner│
│  "Define user story"│
└──────────┬──────────┘
           │
           ▼
     [Agent works]
           │
           ▼
┌─────────────────────┐
│  SubagentStop hook  │
│  on-agent-stop.sh   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  spectre-router.sh  │
│  "agent-complete"   │
│  "product-owner"    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Update state       │
│  phase: "design"    │
│  Write trigger file │
└──────────┬──────────┘
           │
           ▼
     [Next agent...]
```

### 2. Détection d'erreur

```
QA Agent runs: npm test
         │
         ▼
┌─────────────────────┐
│  PostToolUse hook   │
│  check-test-results │
└──────────┬──────────┘
           │
    Tests failed?
    ┌─────┴─────┐
    │           │
   YES          NO
    │           │
    ▼           ▼
┌─────────┐  ┌─────────┐
│ Write   │  │ Mark    │
│ error   │  │ resolved│
│ .jsonl  │  │         │
└────┬────┘  └────┬────┘
     │            │
     ▼            ▼
  [Continue with SubagentStop]
```

### 3. Boucle de correction (Smart Routing)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         SMART ERROR ROUTING                              │
│                                                                          │
│  ┌─────────────┐                                                         │
│  │  QA finds   │                                                         │
│  │   error     │                                                         │
│  └──────┬──────┘                                                         │
│         │                                                                │
│         ▼                                                                │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                      ERROR TYPE DETECTION                         │   │
│  │                                                                   │   │
│  │  test_failure? ─────────────────────────────────▶ Dev (owner)    │   │
│  │  type_error? ───────────────────────────────────▶ Architect      │   │
│  │  design_flaw? ──────────────────────────────────▶ Architect      │   │
│  │  spec_gap? ─────────────────────────────────────▶ PO             │   │
│  │  unclear_criteria? ─────────────────────────────▶ PO             │   │
│  │  contradiction? ────────────────────────────────▶ PO             │   │
│  │  design_block? ─────────────────────────────────▶ Architect      │   │
│  │                                                                   │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│         │                                                                │
│         ▼                                                                │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                │
│  │   Agent     │────▶│   Agent     │────▶│     QA      │                │
│  │   fixes     │     │  completes  │     │  re-verify  │                │
│  └─────────────┘     └─────────────┘     └──────┬──────┘                │
│                                                  │                       │
│                                     ┌────────────┴────────────┐          │
│                                     │                         │          │
│                                   ERROR                      OK          │
│                                     │                         │          │
│                                     ▼                         ▼          │
│                              [Route again]              [Complete]       │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3b. Exemples de Routing

**Test Failure → Dev**
```
QA: "Login button test fails"
  → Check ownership: Login.tsx owned by frontend-dev
  → Route to: frontend-dev
  → Dev fixes → QA re-verifies
```

**Design Flaw → Architect**
```
QA: "Circular dependency between UserService and AuthService"
  → Error type: design_flaw
  → Route to: software-craftsman
  → Architect redesigns → Dev updates → QA re-verifies
```

**Spec Gap → PO**
```
Dev: "What happens if user has 0 items in cart?"
  → Error type: spec_gap
  → Route to: product-owner
  → PO completes spec → Dev implements → QA verifies
```

**Contradiction → PO**
```
Architect: "Spec requires offline AND real-time sync - these conflict"
  → Error type: contradiction
  → Route to: product-owner
  → PO decides tradeoff → Architect adjusts → Dev implements
```

---

## Installation & Configuration

### Installation globale (agents & skills)

```bash
# One-liner
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/install.sh | bash

# Ou depuis le repo
git clone https://github.com/fvilcot/spectre-agents.git
cd spectre-agents && ./install.sh
```

Installe dans :
- `~/.claude/agents/` — Tous les agents
- `~/.claude/skills/` — Tous les skills

### Configuration projet (système réactif)

Dans chaque projet où tu veux utiliser le système réactif :

```bash
/setup-reactive
```

Ou manuellement :

```bash
./scripts/setup-reactive.sh /path/to/project
```

Crée :
- `.spectre/` — État partagé
- `scripts/spectre/` — Scripts de hooks
- `.claude/settings.json` — Configuration des hooks
- `docs/features/` — Output des features

### Fichiers installés

```
~/.claude/
├── agents/
│   ├── software-craftsman.md
│   ├── product-owner.md
│   ├── frontend-dev.md
│   ├── qa-engineer.md
│   └── orchestrator.md
└── skills/
    ├── craft/SKILL.md
    ├── heal/SKILL.md
    ├── learn/SKILL.md
    ├── typescript-craft/SKILL.md
    ├── react-craft/SKILL.md
    ├── test-craft/SKILL.md
    ├── init-frontend/SKILL.md
    ├── feature/SKILL.md
    ├── reactive-loop/SKILL.md
    ├── agent/SKILL.md
    └── setup-reactive/SKILL.md

project/
├── .spectre/
│   ├── state.json
│   ├── errors.jsonl
│   ├── events.jsonl
│   ├── learnings.jsonl
│   ├── links.json
│   ├── context.json
│   └── learnings/         # From /learn
│       ├── tech-stack.json
│       ├── code-patterns.json
│       ├── test-patterns.json
│       ├── spec-patterns.json
│       ├── style-patterns.json
│       └── summary.md
├── .claude/
│   └── settings.json    # Hooks config
├── scripts/
│   └── spectre/
│       ├── spectre-router.sh
│       ├── on-agent-stop.sh
│       └── check-test-results.sh
└── docs/
    └── features/
```

---

## Utilisation

### Trois commandes

```bash
/learn    # S'adapter au projet
/craft    # Construire quelque chose de nouveau
/heal     # Réparer ce qui est cassé
```

### `/learn` — S'adapter

```bash
/learn
# → Analyse tech stack, architecture, tests, specs, style
# → Sauvegarde dans .spectre/learnings/
# → Les agents suivent VOS conventions
```

### `/craft` — Construire

```bash
/craft
# → Contexte ? [ Product Team | Startup | Freelance | Learning ]
# → Objectif ? [ Build | Fix | Improve | Think ]
# → Questions contextuelles...
# → Décrivez votre besoin
# → Les agents travaillent (avec vos conventions)
```

### `/heal` — Réparer

```bash
/heal           # Diagnostique et répare tout (code + specs)
/heal tests     # Répare les tests
/heal build     # Répare le build
/heal types     # Répare les types
/heal spec      # Répare les écarts spec/code
```

### Workflow typique

```bash
# 0. Premier usage sur un projet existant
/learn

# 1. Nouveau projet ou feature
/craft

# 2. Si quelque chose casse
/heal

# 3. Les agents travaillent automatiquement
#    Diagnose → Fix → Verify → Loop until healed
#    (en suivant VOS conventions)
```

### Raccourcis

```bash
/craft add login form       # → flow build + UI
/craft fix failing tests    # → flow fix + tests
/craft refactor auth        # → flow improve
/craft how to design auth   # → flow think
```

### Monitoring

```bash
# Voir l'état actuel
cat .spectre/state.json | jq '.'

# Voir les erreurs récentes
tail -5 .spectre/errors.jsonl | jq '.'

# Voir les learnings
cat .spectre/learnings.jsonl | jq '.'

# Commande router
./scripts/spectre/spectre-router.sh status
```

### Intervention manuelle

Si la boucle échoue après 3 retries :

```bash
# 1. Fixer manuellement
# 2. Relancer la vérification
/reactive-loop continue

# Ou reset complet
/reactive-loop reset
```

---

## Extension du système

### Ajouter un nouvel agent

1. Créer le fichier :
```bash
# Global
~/.claude/agents/mon-agent.md

# Ou projet
.claude/agents/mon-agent.md
```

2. Structure :
```yaml
---
name: mon-agent
description: "Quand utiliser cet agent avec exemples..."
model: sonnet
color: magenta
tools: Read, Write, Edit, Bash
---

# System Prompt

## Expertise
...

## Méthodologie
...

## Règles absolues
1. ...
2. ...
```

3. Pour l'intégrer au système réactif, modifier `spectre-router.sh` :
```bash
case "$agent" in
    ...
    "mon-agent")
        # Logique de routage
        ;;
esac
```

### Ajouter un nouveau skill

1. Créer le dossier :
```bash
mkdir -p ~/.claude/skills/mon-skill
```

2. Créer `SKILL.md` :
```yaml
---
name: mon-skill
description: "Ce que fait le skill"
context: fork
agent: agent-executant
allowed-tools: Read, Write, Edit
---

# Instructions

...
```

### Ajouter un nouveau hook

Dans `.claude/settings.json` :

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/mon-hook.sh"
          }
        ]
      }
    ]
  }
}
```

### Types de hooks disponibles

| Hook | Déclencheur | Usage |
|------|-------------|-------|
| `PreToolUse` | Avant un outil | Validation, blocage |
| `PostToolUse` | Après un outil | Logging, réaction |
| `SubagentStop` | Fin de subagent | Routing, chaînage |
| `SessionStart` | Début de session | Initialisation |
| `Stop` | Fin de conversation | Cleanup |
| `Notification` | Notification Claude | Alertes |

---

## Résumé

Spectre Agents = **Craft** + **Réactivité Complète** + **Auto-apprentissage**

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   CRAFT              REACTIVE MESH              ADAPTIVE LEARNING       │
│                                                                         │
│   • Clean Arch       • 8 reactive links         • /learn your patterns │
│   • DDD              • Smart error routing      • Code style detection │
│   • SOLID            • Agent escalation         • Test conventions     │
│   • TDD/BDD          • Bidirectional flow       • Spec format learning │
│                                                                         │
│   COMMANDS:                                                             │
│                                                                         │
│   /learn ───▶ Analyze project → Store patterns → Inject in agents      │
│   /craft ───▶ Guided flow → Agent chain → Build with YOUR conventions  │
│   /heal  ───▶ Diagnose → Route to expert → Fix → Verify → Loop         │
│                                                                         │
│   REACTIVE LINKS:                                                       │
│                                                                         │
│   QA ──────▶ Dev (test failure)                                        │
│   QA ──────▶ Architect (design flaw)                                   │
│   QA ──────▶ PO (unclear criteria)                                     │
│   Dev ─────▶ Architect (design block)                                  │
│   Dev ─────▶ PO (spec gap)                                             │
│   Architect ▶ PO (contradiction)                                       │
│   Architect ▶ Dev (code review)                                        │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

**Le code est un artisanat. Les agents s'adaptent à VOTRE artisanat.**
