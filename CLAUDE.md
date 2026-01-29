# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Spectre Agents is a collection of craft-oriented agents and skills for Claude Code. Every component embodies Software Craftsmanship principles: Clean Architecture, DDD, SOLID, TDD/BDD, and uncompromising technical excellence.

**Philosophy**: Code is a craft. We favor quality, readability, and maintainability over speed. Each agent guides toward technical excellence with pedagogy and rigor.

## Structure

```
.claude/
├── agents/          # Agent definitions (YAML frontmatter + Markdown)
└── skills/          # Skill definitions (YAML frontmatter + Markdown)
```

## Component Format

### Agents (`.claude/agents/*.md`)

YAML frontmatter:
- `name`: Agent identifier
- `description`: When to use this agent (displayed in Claude Code)
- `model`: Claude model to use (`opus`, `sonnet`, `haiku`)
- `color`: Terminal color

The Markdown body contains the agent's system prompt.

### Skills (`.claude/skills/<name>/SKILL.md`)

YAML frontmatter:
- `name`: Skill identifier
- `description`: What the skill does
- `context`: Execution context (`fork`, etc.)
- `agent`: Agent that executes this skill
- `allowed-tools`: Available tools

The Markdown body contains the skill's specific instructions.

## Current Components

### Agents
- **software-craftsman**: Software architect expert in Clean Architecture, DDD, Hexagonal, SOLID, TDD/BDD. Analyzes, designs, and reviews code with a pedagogical approach.
- **product-owner**: Product expert who transforms vague ideas into clear user stories with acceptance criteria. Prioritizes by value, defines MVP scope.
- **frontend-dev**: Frontend specialist building accessible, performant, maintainable UIs. Expert in React, state management, testing.
- **qa-engineer**: Quality expert designing test strategies, writing tests at all levels, ensuring confidence in the codebase.

### Skills
- **typescript-craft**: Applies craft principles to TypeScript — strict typing, algebraic types, immutability, pure functions, Result types, layer separation.

## Guiding Principles

Every new component must embody:
1. **Domain First**: Business logic at the center, frameworks at the periphery
2. **Type Safety**: The type system as safety net and living documentation
3. **Explicit over Implicit**: Explicit error handling, no silent exceptions
4. **Test-Driven**: Tests as executable specifications
5. **Pedagogy**: Explain the "why" before the "how"
