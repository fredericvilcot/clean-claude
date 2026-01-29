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
│                           ┌─────────────┐                               │
│                           │   /guide    │  ← Point d'entrée             │
│                           └──────┬──────┘                               │
│                                  │                                      │
│                                  ▼                                      │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────┐ │
│  │     AGENTS      │  │  CRAFT SKILLS   │  │    REACTIVE SYSTEM      │ │
│  │                 │  │                 │  │                         │ │
│  │ • software-     │  │ • typescript-   │  │ • hooks (SubagentStop)  │ │
│  │   craftsman     │  │   craft         │  │ • shared state          │ │
│  │ • product-owner │  │ • react-craft   │  │ • auto-correction loop  │ │
│  │ • frontend-dev  │  │ • test-craft    │  │ • learnings             │ │
│  │ • qa-engineer   │  │ • init-frontend │  │                         │ │
│  │                 │  │                 │  │                         │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────────────┘ │
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
| **/guide** | **Build** — mode guidé adapté au contexte |
| **/heal** | **Fix** — auto-réparation (tests, build, types) |
| **/typescript-craft** | Principes craft TypeScript |
| **/react-craft** | Principes craft React |
| **/test-craft** | TDD/BDD, test pyramid |
| **/init-frontend** | Bootstrap projet React |

#### Context: fork vs conversation

- **fork** : S'exécute dans un sous-agent isolé (nouveau contexte)
- **conversation** : S'exécute dans la conversation principale

#### Le skill `/guide` en détail

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

### Vue d'ensemble

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         REACTIVE LOOP                                   │
│                                                                         │
│  User: "Build login feature"                                            │
│         │                                                               │
│         ▼                                                               │
│  ┌─────────────────┐                                                    │
│  │   Orchestrator  │◀──────────────────────────────────────┐            │
│  │   (coordinator) │                                       │            │
│  └────────┬────────┘                                       │            │
│           │ spawn                                          │            │
│           ▼                                                │            │
│  ┌──────────────┐     ┌──────────────┐     ┌────────────┐ │            │
│  │   Product    │────▶│   Software   │────▶│  Frontend  │ │            │
│  │    Owner     │     │   Craftsman  │     │    Dev     │ │            │
│  └──────────────┘     └──────────────┘     └─────┬──────┘ │            │
│         │                    │                   │        │            │
│         ▼                    ▼                   ▼        │            │
│  ┌──────────────┐     ┌──────────────┐     ┌────────────┐ │            │
│  │  user-story  │     │   tech-spec  │     │    code    │ │            │
│  │     .md      │     │     .md      │     │   + tests  │ │            │
│  └──────────────┘     └──────────────┘     └─────┬──────┘ │            │
│                                                  │        │            │
│                                                  ▼        │            │
│                                           ┌────────────┐  │            │
│                                           │     QA     │  │            │
│                                           │  Engineer  │  │            │
│                                           └─────┬──────┘  │            │
│                                                 │         │            │
│                              ┌──────────────────┼─────────┘            │
│                              │                  │                      │
│                              ▼                  ▼                      │
│                         [SUCCESS]          [ERROR]                     │
│                              │                  │                      │
│                              ▼                  ▼                      │
│                         Complete         Retry (max 3)                 │
│                                                 │                      │
│                                                 ▼                      │
│                                          Frontend Dev                  │
│                                          (with error                   │
│                                           context)                     │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### Shared State (.spectre/)

```
.spectre/
├── state.json        # État du workflow
├── errors.jsonl      # Log des erreurs (append-only)
├── events.jsonl      # Log des événements
├── learnings.jsonl   # Patterns appris
├── ownership.json    # Qui a modifié quels fichiers
├── links.json        # Configuration des liens réactifs (/agent)
├── context.json      # Contexte de la feature courante
└── trigger           # Fichier de déclenchement (transitoire)
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
{"timestamp":"...","type":"test_failure","message":"Button not found","file":"src/Login.tsx","resolved":false}
{"timestamp":"...","type":"type_error","message":"Property 'name' does not exist","file":"src/User.ts","resolved":true}
```

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

| Phase | Agent | Entrée | Sortie |
|-------|-------|--------|--------|
| `define` | product-owner | Feature description | user-story.md |
| `design` | software-craftsman | User story | technical-design.md |
| `implement` | frontend-dev | Tech spec | Code + tests |
| `verify` | qa-engineer | Implementation | Test results |
| `fix` | frontend-dev | Error details | Fixed code |
| `complete` | — | All tests pass | Feature done |

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

### 3. Boucle de correction

```
┌─────────────────────────────────────────┐
│                                         │
│  ┌─────────────┐    ┌─────────────┐    │
│  │  QA finds   │───▶│   Router    │    │
│  │   error     │    │  triggers   │    │
│  └─────────────┘    └──────┬──────┘    │
│                            │           │
│                            ▼           │
│                     ┌─────────────┐    │
│                     │  Dev agent  │    │
│                     │ with error  │    │
│                     │  context    │    │
│                     └──────┬──────┘    │
│                            │           │
│                            ▼           │
│                     ┌─────────────┐    │
│                     │  Dev fixes  │    │
│                     │    code     │    │
│                     └──────┬──────┘    │
│                            │           │
│         ┌──────────────────┘           │
│         │                              │
│         ▼                              │
│  ┌─────────────┐                       │
│  │   Router    │                       │
│  │  triggers   │                       │
│  └──────┬──────┘                       │
│         │                              │
│         ▼                              │
│  ┌─────────────┐     ┌─────────────┐  │
│  │  QA agent   │────▶│  Still has  │  │
│  │  re-verify  │     │   errors?   │  │
│  └─────────────┘     └──────┬──────┘  │
│                             │         │
│                    ┌────────┴────────┐│
│                    │                 ││
│                   YES               NO ││
│                    │                 ││
│                    ▼                 ▼ │
│              [Loop again]      [Complete]│
│                                         │
└─────────────────────────────────────────┘
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
    ├── guide/SKILL.md
    ├── heal/SKILL.md
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
│   └── context.json
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

### Deux commandes

```bash
/guide    # Construire quelque chose de nouveau
/heal     # Réparer ce qui est cassé
```

### `/guide` — Construire

```bash
/guide
# → Contexte ? [ Product Team | Startup | Freelance | Learning ]
# → Objectif ? [ Build | Fix | Improve | Think ]
# → Questions contextuelles...
# → Décrivez votre besoin
# → Les agents travaillent
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
# 1. Nouveau projet ou feature
/guide

# 2. Si quelque chose casse
/heal

# 3. Les agents travaillent automatiquement
#    Diagnose → Fix → Verify → Loop until healed
```

### Raccourcis

```bash
/guide add login form       # → flow build + UI
/guide fix failing tests    # → flow fix + tests
/guide refactor auth        # → flow improve
/guide how to design auth   # → flow think
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

Spectre Agents = **Craft** + **Réactivité** + **Auto-apprentissage**

```
┌────────────────────────────────────────────────────────────┐
│                                                            │
│   CRAFT           REACTIVE           LEARNING              │
│                                                            │
│   • Clean Arch    • Auto-correct     • Errors → Patterns   │
│   • DDD           • Hooks routing    • Fixes → Learnings   │
│   • SOLID         • Retry logic      • Confidence scores   │
│   • TDD/BDD       • Shared state     • Cross-agent memory  │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

**Le code est un artisanat. Les agents le perfectionnent ensemble.**
