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
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────┐ │
│  │     AGENTS      │  │     SKILLS      │  │    REACTIVE SYSTEM      │ │
│  │                 │  │                 │  │                         │ │
│  │ • software-     │  │ • typescript-   │  │ • orchestrator agent    │ │
│  │   craftsman     │  │   craft         │  │ • hooks (SubagentStop)  │ │
│  │ • product-owner │  │ • react-craft   │  │ • shared state          │ │
│  │ • frontend-dev  │  │ • test-craft    │  │ • auto-correction loop  │ │
│  │ • qa-engineer   │  │ • init-frontend │  │ • learnings             │ │
│  │ • orchestrator  │  │ • feature       │  │                         │ │
│  │                 │  │ • reactive-loop │  │                         │ │
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

| Skill | Agent | Context | Description |
|-------|-------|---------|-------------|
| **/typescript-craft** | software-craftsman | fork | Principes craft TypeScript |
| **/react-craft** | frontend-dev | fork | Principes craft React |
| **/test-craft** | qa-engineer | fork | TDD/BDD, test pyramid |
| **/init-frontend** | software-craftsman | fork | Bootstrap projet React |
| **/feature** | software-craftsman | fork | Workflow complet PO→Arch→Dev→QA |
| **/reactive-loop** | orchestrator | fork | Boucle réactive auto-corrective |
| **/setup-reactive** | — | conversation | Configure le système réactif |

#### Context: fork vs conversation

- **fork** : S'exécute dans un sous-agent isolé (nouveau contexte)
- **conversation** : S'exécute dans la conversation principale

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

Le cerveau du système réactif :

```bash
./scripts/spectre-router.sh <action> [agent]

Actions:
  agent-complete <agent>  # Appelé quand un agent termine
  test-result            # Analyse les résultats de tests
  error <agent>          # Enregistre une erreur
  status                 # Affiche l'état actuel
```

**Logique de routage** :
```
qa-engineer complete + error    → spawn frontend-dev
qa-engineer complete + success  → workflow complete
frontend-dev complete           → spawn qa-engineer (verify)
software-craftsman complete     → spawn frontend-dev
product-owner complete          → spawn software-craftsman
```

##### on-agent-stop.sh

Hook déclenché par Claude Code quand un subagent termine :

```bash
# Reçoit JSON sur stdin avec info de l'agent
# Extrait le type d'agent
# Appelle spectre-router.sh si c'est un agent Spectre
```

##### check-test-results.sh

Hook déclenché après chaque commande Bash :

```bash
# Vérifie si c'était une commande de test (vitest, jest, etc.)
# Parse la sortie pour détecter FAIL/ERROR
# Enregistre dans .spectre/errors.jsonl si erreur
```

#### Configuration des Hooks

Dans `.claude/settings.json` du projet :

```json
{
  "hooks": {
    "SubagentStop": [
      {
        "matcher": "qa-engineer|frontend-dev|software-craftsman|product-owner",
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
├── context.json      # Contexte de la feature courante
└── trigger           # Fichier de déclenchement (transitoire)
```

#### state.json

```json
{
  "workflow": "feature",
  "feature": "user-login",
  "phase": "verify",
  "retryCount": 1,
  "maxRetries": 3,
  "agents": {
    "lastActive": "frontend-dev",
    "history": ["product-owner", "software-craftsman", "frontend-dev", "qa-engineer", "frontend-dev"]
  },
  "status": "in_progress"
}
```

#### errors.jsonl

```jsonl
{"timestamp":"2024-01-15T10:30:00Z","type":"test_failure","message":"Button not found","resolved":false}
{"timestamp":"2024-01-15T10:35:00Z","agent":"frontend-dev","fix":"Added data-testid","resolved":true}
```

#### learnings.jsonl

```jsonl
{"pattern":"missing-testid","solution":"Add data-testid to interactive elements","confidence":0.9}
{"pattern":"async-timing","solution":"Use waitFor instead of sleep","confidence":0.85}
```

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
    ├── typescript-craft/SKILL.md
    ├── react-craft/SKILL.md
    ├── test-craft/SKILL.md
    ├── init-frontend/SKILL.md
    ├── feature/SKILL.md
    ├── reactive-loop/SKILL.md
    └── setup-reactive/SKILL.md

project/
├── .spectre/
│   ├── state.json
│   ├── errors.jsonl
│   ├── events.jsonl
│   ├── learnings.jsonl
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

### Commandes principales

| Commande | Description |
|----------|-------------|
| `/reactive-loop` | Démarre la boucle réactive pour une feature |
| `/setup-reactive` | Configure le projet pour le système réactif |
| `/feature` | Workflow linéaire (sans auto-correction) |
| `/init-frontend` | Bootstrap un projet React craft |
| `/typescript-craft` | Applique les principes craft au code TS |
| `/react-craft` | Applique les principes craft au code React |
| `/test-craft` | Applique les principes TDD/BDD |

### Workflow typique

```bash
# 1. Nouveau projet
/init-frontend

# 2. Configurer le système réactif
/setup-reactive

# 3. Développer une feature avec auto-correction
/reactive-loop
> "I want to build a user login form with email and password"

# 4. Les agents collaborent automatiquement
#    PO → Architect → Dev → QA → [fix loop] → Complete
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
