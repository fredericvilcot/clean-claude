---
name: setup-reactive
description: "Set up the Spectre Reactive System in the current project. Configures hooks, shared state, and scripts for the multi-agent feedback loop"
context: conversation
allowed-tools: Read, Write, Bash, Glob
---

# Setup Reactive System

You are setting up the Spectre Reactive System in the current project.

## What This Does

1. Creates `.spectre/` directory for shared agent state
2. Copies hook scripts to `scripts/spectre/`
3. Configures Claude Code hooks in `.claude/settings.json`
4. Sets up `docs/features/` for output artifacts

## Setup Steps

### Step 1: Create .spectre Directory

```bash
mkdir -p .spectre

cat > .spectre/state.json << 'EOF'
{
  "workflow": null,
  "feature": null,
  "phase": "idle",
  "retryCount": 0,
  "maxRetries": 3,
  "agents": {
    "lastActive": null,
    "history": []
  },
  "status": "ready"
}
EOF

touch .spectre/errors.jsonl
touch .spectre/events.jsonl
touch .spectre/learnings.jsonl
echo '{}' > .spectre/context.json
```

### Step 2: Create Hook Scripts

Create `scripts/spectre/spectre-router.sh`:

```bash
mkdir -p scripts/spectre
```

Then create the router script that handles agent communication and routing.

### Step 3: Configure Hooks

Add to `.claude/settings.json`:

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

### Step 4: Create Output Directory

```bash
mkdir -p docs/features
```

### Step 5: Update .gitignore

Add runtime files that shouldn't be committed:

```
# Spectre runtime state
.spectre/state.json
.spectre/events.jsonl
.spectre/context.json
.spectre/trigger
```

Keep `errors.jsonl` and `learnings.jsonl` as they contain valuable history.

## After Setup

The reactive system is ready. Start with:

```
/reactive-loop
```

Or check system status:

```bash
./scripts/spectre/spectre-router.sh status
```

## Directory Structure Created

```
project/
├── .spectre/
│   ├── state.json        # Current workflow state
│   ├── errors.jsonl      # Error history (keep in git)
│   ├── events.jsonl      # Event log
│   ├── learnings.jsonl   # Patterns learned (keep in git)
│   └── context.json      # Current feature context
├── .claude/
│   └── settings.json     # Hooks configuration
├── scripts/
│   └── spectre/
│       ├── spectre-router.sh      # Main routing logic
│       ├── on-agent-stop.sh       # SubagentStop hook
│       └── check-test-results.sh  # PostToolUse hook
└── docs/
    └── features/         # Feature documentation output
```

## Verification

After setup, verify with:

```bash
# Check state file
cat .spectre/state.json | jq '.'

# Check hooks are configured
cat .claude/settings.json | jq '.hooks'

# Check scripts are executable
ls -la scripts/spectre/
```

Setup complete when all checks pass.
