# Spectre Agents

Craft-oriented agents and skills for [Claude Code](https://claude.ai/code).

Every component embodies Software Craftsmanship principles: Clean Architecture, DDD, SOLID, TDD/BDD, and uncompromising technical excellence.

## Installation

### Quick Install (Linux/macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/install.sh | bash
```

### Quick Install (Windows PowerShell)

```powershell
irm https://raw.githubusercontent.com/fvilcot/spectre-agents/main/install.ps1 | iex
```

### From Source

```bash
git clone https://github.com/fvilcot/spectre-agents.git
cd spectre-agents
./install.sh  # or .\install.ps1 on Windows
```

After installation, **restart Claude Code** to load the new components.

## Components

### Agents

| Agent | Description |
|-------|-------------|
| **software-craftsman** | Software architect expert in Clean Architecture, DDD, Hexagonal, SOLID, TDD/BDD. Analyzes, designs, and reviews code with a pedagogical approach. |

### Skills

| Skill | Description |
|-------|-------------|
| **/typescript-craft** | Applies craft principles to TypeScript: strict typing, algebraic types, immutability, pure functions, Result types, layer separation. |

## Usage

### Using the software-craftsman agent

The agent is automatically available when Claude Code detects tasks matching its expertise:
- Designing new features with proper architecture
- Reviewing code for quality and maintainability
- Implementing design patterns
- Writing or improving tests (TDD/BDD)
- Refactoring legacy code

### Using skills

Invoke skills directly in Claude Code:

```
/typescript-craft
```

## Uninstallation

```bash
# Linux/macOS
curl -fsSL https://raw.githubusercontent.com/fvilcot/spectre-agents/main/uninstall.sh | bash

# Or from cloned repo
./uninstall.sh
```

## Philosophy

> Code is a craft. We favor quality, readability, and maintainability over speed.

Every component is built on these principles:

1. **Domain First** — Business logic at the center, frameworks at the periphery
2. **Type Safety** — The type system as safety net and living documentation
3. **Explicit over Implicit** — Explicit error handling, no silent exceptions
4. **Test-Driven** — Tests as executable specifications
5. **Pedagogy** — Explain the "why" before the "how"

## License

BSD 3-Clause
