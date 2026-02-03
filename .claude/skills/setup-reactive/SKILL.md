---
name: setup-reactive
description: "Set up the Clean Claude Reactive System in the current project. Configures hooks, shared state, and scripts for the multi-agent feedback loop"
user-invocable: false
context: conversation
allowed-tools: Read, Write, Bash, Glob
---

# Setup Reactive System

You are setting up the Clean Claude Reactive System in the current project.

## What This Does

1. Creates `.clean-claude/` directory for shared agent state
2. Copies hook scripts to `scripts/clean-claude/`
3. Configures Claude Code hooks in `.claude/settings.json`
4. Sets up `docs/features/` for output artifacts

## Setup Steps

### Step 1: Create .clean-claude Directory

```bash
mkdir -p .clean-claude

cat > .clean-claude/state.json << 'EOF'
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

touch .clean-claude/errors.jsonl
touch .clean-claude/events.jsonl
touch .clean-claude/learnings.jsonl
echo '{}' > .clean-claude/context.json
```

### Step 2: Create Hook Scripts

Create `scripts/clean-claude/clean-claude-router.sh`:

```bash
mkdir -p scripts/clean-claude
```

Then create the router script that handles agent communication and routing.

### Step 3: Configure Hooks

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "SubagentStop": [
      {
        "matcher": "qa-engineer|frontend-engineer|architect|product-owner",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/clean-claude/on-agent-stop.sh"
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
            "command": "./scripts/clean-claude/check-test-results.sh"
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
# Clean Claude runtime state
.clean-claude/state.json
.clean-claude/events.jsonl
.clean-claude/context.json
.clean-claude/trigger
```

Keep `errors.jsonl` and `learnings.jsonl` as they contain valuable history.

## After Setup

The reactive system is ready. Start with:

```
/reactive-loop
```

Or check system status:

```bash
./scripts/clean-claude/clean-claude-router.sh status
```

## Directory Structure Created

```
project/
├── .clean-claude/
│   ├── state.json        # Current workflow state
│   ├── errors.jsonl      # Error history (keep in git)
│   ├── events.jsonl      # Event log
│   ├── learnings.jsonl   # Patterns learned (keep in git)
│   └── context.json      # Current feature context
├── .claude/
│   └── settings.json     # Hooks configuration
├── scripts/
│   └── clean-claude/
│       ├── clean-claude-router.sh      # Main routing logic
│       ├── on-agent-stop.sh       # SubagentStop hook
│       └── check-test-results.sh  # PostToolUse hook
└── docs/
    └── features/         # Feature documentation output
```

## Verification

After setup, verify with:

```bash
# Check state file
cat .clean-claude/state.json | jq '.'

# Check hooks are configured
cat .claude/settings.json | jq '.hooks'

# Check scripts are executable
ls -la scripts/clean-claude/
```

Setup complete when all checks pass.
