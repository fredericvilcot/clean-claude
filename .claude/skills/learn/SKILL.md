---
name: learn
description: "Auto-learn project patterns. Use /learn for full project, /learn <file> for exemplary file, /learn --example <file> for gold standard."
context: conversation
allowed-tools: Read, Bash, Glob, Grep, Write, Task
---

# Spectre Learn — Adaptive Intelligence

Analyze the project to learn its patterns. Agents then adapt their output to match YOUR conventions.

## Usage

```bash
/learn                        # Full project analysis
/learn code                   # Learn architecture & code patterns
/learn tests                  # Learn testing conventions
/learn specs                  # Learn spec/PRD format
/learn style                  # Learn naming & formatting conventions
/learn --reset                # Reset all learnings
/learn --show                 # Show current learnings
```

### Fine-Tuning — Learn from Specific Sources

```bash
/learn <file>                 # Learn from a specific exemplary file
/learn <folder>               # Learn from a specific folder only
/learn --from <file>          # Use this file as the reference standard
/learn --example <file>       # "This is how I want it done"
```

### Examples

```bash
# Learn from the whole project
/learn

# Learn code patterns from a specific well-written file
/learn src/features/auth/AuthService.ts

# Learn test patterns from your best test file
/learn src/components/Button/Button.test.tsx

# Learn spec format from your reference spec
/learn docs/specs/user-login.spec.md

# Learn only from the components folder
/learn src/components/

# Mark a file as THE reference (highest confidence)
/learn --example src/features/auth/AuthService.ts
```

### Scope Options

| Command | Scope | Use Case |
|---------|-------|----------|
| `/learn` | Full project | Initial setup, comprehensive |
| `/learn <file>` | Single file | "Learn from this exemplary file" |
| `/learn <folder>` | Folder only | "Focus on this area" |
| `/learn --example <file>` | Reference file | "THIS is the gold standard" |
| `/learn code src/features/` | Category + scope | "Learn code patterns from features/" |

## What Gets Learned

### 1. Code Patterns (`code`)

| Pattern | Detection | Example Learning |
|---------|-----------|------------------|
| **Architecture** | Folder structure, layers | "Uses hexagonal architecture with ports/adapters" |
| **File organization** | How files are grouped | "Components in `src/components/`, one per file" |
| **Import style** | Absolute vs relative, barrel files | "Uses barrel exports, absolute imports from `@/`" |
| **Error handling** | Try/catch, Result types, Either | "Uses Result<T, E> pattern, no thrown exceptions" |
| **State management** | Redux, Zustand, Context, signals | "Uses Zustand for global, React Query for server" |
| **API layer** | REST, GraphQL, tRPC | "tRPC with Zod validation" |

### 2. Test Patterns (`tests`)

| Pattern | Detection | Example Learning |
|---------|-----------|------------------|
| **Framework** | Jest, Vitest, Playwright | "Vitest for unit, Playwright for E2E" |
| **Structure** | Describe/it, test(), BDD style | "Uses describe blocks with BDD naming" |
| **Mocking** | vi.mock, jest.mock, MSW | "MSW for API mocking, vi.fn() for functions" |
| **Fixtures** | Factories, builders, raw objects | "Uses factory functions in `tests/factories/`" |
| **Coverage** | Thresholds, ignored patterns | "80% coverage required, ignores `*.dto.ts`" |
| **Naming** | `*.test.ts`, `*.spec.ts`, location | "Co-located `Component.test.tsx` files" |

### 3. Spec Patterns (`specs`)

| Pattern | Detection | Example Learning |
|---------|-----------|------------------|
| **Format** | Markdown, Notion, Jira style | "Markdown specs in `docs/specs/`" |
| **Structure** | Sections, headings, order | "Overview → Requirements → Acceptance Criteria → Edge Cases" |
| **User stories** | As a/I want/So that, jobs-to-be-done | "Uses JTBD format with outcome focus" |
| **Acceptance criteria** | Given/When/Then, checklist | "Gherkin syntax for AC" |
| **Examples** | Included, format | "Always includes examples with expected values" |

### 4. Style Patterns (`style`)

| Pattern | Detection | Example Learning |
|---------|-----------|------------------|
| **Naming** | camelCase, PascalCase, kebab | "Files: kebab-case, Components: PascalCase" |
| **TypeScript** | Strict mode, any usage, enums | "Strict mode, no `any`, uses const enums" |
| **Comments** | JSDoc, inline, none | "JSDoc for public APIs, minimal inline" |
| **Formatting** | Prettier config, line length | "Prettier with 100 char lines, single quotes" |
| **Linting** | ESLint rules, custom rules | "Strict ESLint, no-unused-vars error" |

---

---

## Fine-Tuning Behavior

### Full Project (`/learn`)

Scans the entire codebase:
- Samples multiple files per category
- Detects dominant patterns (majority wins)
- Confidence based on consistency

```
🔍 Analyzing full project...

Scanned: 47 files
  → 38 use absolute imports (81%)
  → 9 use relative imports (19%)

Learning: "Use absolute imports with @/"
Confidence: 0.81
```

### Specific File (`/learn <file>`)

Learns patterns from ONE exemplary file:
- Extracts ALL patterns from that file
- Higher confidence (0.85) than project scan
- Marks source file for reference

```
🔍 Learning from src/features/auth/AuthService.ts

Patterns detected:
  → Result<T, E> error handling
  → Dependency injection via constructor
  → JSDoc on public methods
  → Zod validation at boundaries

Confidence: 0.85 (single-file reference)
```

### Example File (`/learn --example <file>`)

Marks a file as THE gold standard:
- Highest confidence (0.95)
- Overrides conflicting patterns
- Used as reference in agent prompts

```
🌟 Marking as reference: src/features/auth/AuthService.ts

This file will be used as THE standard for:
  → Error handling patterns
  → Service structure
  → Documentation style

Confidence: 0.95 (explicit example)

Agents will reference this file when writing similar code.
```

### Folder Scope (`/learn <folder>`)

Learns only from files in that folder:
- Useful for domain-specific patterns
- Ignores patterns from other areas
- Good for monorepos with different styles

```
🔍 Learning from src/features/ only

Scanned: 12 files in src/features/

Patterns (features layer):
  → Feature-folder structure
  → Index barrel exports
  → Co-located tests
```

### Combined (`/learn code src/features/`)

Category + scope:
- Only learns code patterns
- Only from specified folder

```
🔍 Learning code patterns from src/features/

Focus: Architecture & code style only
Scope: src/features/**/*.ts

Patterns detected:
  → Hexagonal architecture
  → Ports/adapters pattern
  → Domain types in /types
```

---

## Confidence Levels

| Source | Confidence | Override Priority |
|--------|------------|-------------------|
| Full project scan | 0.6 - 0.8 | Low (default) |
| Specific file | 0.85 | Medium |
| `--example` flag | 0.95 | High |
| User correction | 0.99 | Highest |

When patterns conflict:
```
Project scan says: "Use try/catch" (0.7)
Example file says: "Use Result<T,E>" (0.95)

→ Winner: Result<T,E> (higher confidence)
```

---

## How It Works

### Step 1: Analyze Codebase

```bash
# Detect tech stack
cat package.json | jq '.dependencies, .devDependencies'

# Analyze folder structure
find src -type d | head -20

# Sample code files
find src -name "*.ts" -o -name "*.tsx" | head -10 | xargs head -50

# Sample test files
find . -name "*.test.*" -o -name "*.spec.*" | head -5 | xargs head -50

# Find spec/PRD files
find . -name "*.spec.md" -o -name "*.story.md" -o -name "PRD*" -o -path "*/specs/*"
```

### Step 2: Extract Patterns

For each category, identify:

1. **Conventions used** (what patterns appear most)
2. **Consistency level** (how uniform is the codebase)
3. **Deviations** (exceptions to note)

### Step 3: Store Learnings

```bash
mkdir -p .spectre/learnings

# Write pattern files
cat > .spectre/learnings/code-patterns.json << EOF
{
  "architecture": {
    "pattern": "hexagonal",
    "layers": ["domain", "application", "infrastructure"],
    "confidence": 0.9
  },
  "imports": {
    "style": "absolute",
    "alias": "@/",
    "barrels": true
  },
  "errorHandling": {
    "pattern": "result-type",
    "throwsExceptions": false
  }
}
EOF
```

### Step 4: Inject into Agent Context

When an agent starts, learnings are automatically loaded:

```
## Project Patterns (from /learn)

**Architecture:** Hexagonal with ports/adapters
**Imports:** Absolute from `@/`, barrel exports
**Error handling:** Result<T, E> pattern, no exceptions
**Tests:** Vitest, co-located, describe/it with BDD naming
**Specs:** Markdown with Gherkin acceptance criteria
```

---

## Implementation

### Full Learn (`/learn`)

```
🔍 Analyzing project...

📦 Tech Stack:
  → React 18 + TypeScript 5
  → Vite + Vitest
  → TailwindCSS
  → Zustand + React Query

🏗️ Architecture:
  → Feature-based structure (src/features/)
  → Shared components in src/components/
  → API layer with React Query hooks

🧪 Testing:
  → Vitest for unit tests
  → Co-located test files (*.test.tsx)
  → Testing Library for components
  → MSW for API mocking

📝 Specs:
  → Markdown in docs/specs/
  → Gherkin acceptance criteria
  → Examples section required

✨ Style:
  → Strict TypeScript (no any)
  → Prettier: single quotes, 100 chars
  → ESLint: strict ruleset

💾 Saved to .spectre/learnings/

Agents will now follow your project's conventions.
```

### Code Learn (`/learn code`)

Focus on:
1. Read `src/` structure
2. Sample 5-10 representative files
3. Detect patterns in:
   - Imports (style, aliases)
   - Exports (default vs named)
   - Error handling
   - Async patterns
   - State management
   - Component structure

### Test Learn (`/learn tests`)

Focus on:
1. Find test files
2. Detect framework (Vitest/Jest/Mocha)
3. Analyze structure (describe/it vs flat)
4. Identify mocking patterns
5. Check for fixtures/factories
6. Note naming conventions

### Spec Learn (`/learn specs`)

Focus on:
1. Find spec files (*.spec.md, PRD*, docs/specs/)
2. Analyze structure and sections
3. Detect user story format
4. Identify acceptance criteria style
5. Note examples format

### Style Learn (`/learn style`)

Focus on:
1. Read tsconfig.json (strict mode?)
2. Read .prettierrc / prettier config
3. Read .eslintrc / eslint config
4. Sample files for naming conventions
5. Check for JSDoc usage

---

## Storage Structure

```
.spectre/
└── learnings/
    ├── tech-stack.json       # Detected technologies
    ├── code-patterns.json    # Architecture & code style
    ├── test-patterns.json    # Testing conventions
    ├── spec-patterns.json    # Spec format
    ├── style-patterns.json   # Naming & formatting
    └── summary.md            # Human-readable summary
```

### tech-stack.json

```json
{
  "language": "typescript",
  "framework": "react",
  "buildTool": "vite",
  "testFramework": "vitest",
  "stateManagement": ["zustand", "react-query"],
  "styling": "tailwindcss",
  "linting": ["eslint", "prettier"],
  "detectedAt": "2024-01-15T10:30:00Z"
}
```

### code-patterns.json

```json
{
  "architecture": {
    "pattern": "feature-based",
    "rootDir": "src",
    "layers": {
      "features": "src/features/",
      "shared": "src/components/",
      "hooks": "src/hooks/",
      "utils": "src/utils/",
      "types": "src/types/"
    },
    "confidence": 0.85,
    "source": "project-scan"
  },
  "imports": {
    "style": "absolute",
    "alias": "@/",
    "barrels": true,
    "exampleImport": "import { Button } from '@/components'",
    "confidence": 0.9,
    "source": "project-scan"
  },
  "exports": {
    "preferDefault": false,
    "namedExports": true,
    "confidence": 0.8,
    "source": "project-scan"
  },
  "errorHandling": {
    "pattern": "result-type",
    "customTypes": true,
    "example": "return Result.err(new ValidationError(...))",
    "confidence": 0.95,
    "source": "example-file",
    "referenceFile": "src/features/auth/AuthService.ts"
  },
  "async": {
    "pattern": "async-await",
    "errorHandling": "result-type",
    "confidence": 0.95,
    "source": "example-file",
    "referenceFile": "src/features/auth/AuthService.ts"
  }
}
```

### examples.json (Reference Files)

```json
{
  "code": {
    "service": "src/features/auth/AuthService.ts",
    "component": "src/components/Button/Button.tsx",
    "hook": "src/hooks/useAuth.ts"
  },
  "tests": {
    "unit": "src/components/Button/Button.test.tsx",
    "integration": "src/features/auth/AuthService.test.ts"
  },
  "specs": {
    "feature": "docs/specs/user-login.spec.md"
  },
  "markedAt": "2024-01-15T10:30:00Z"
}
```

When agents need to write similar code, they can reference these example files:

```
## Reference Files (from /learn --example)

When writing a service, follow the patterns in:
→ src/features/auth/AuthService.ts

When writing a component, follow:
→ src/components/Button/Button.tsx

When writing tests, follow:
→ src/components/Button/Button.test.tsx
```

### test-patterns.json

```json
{
  "framework": "vitest",
  "structure": {
    "style": "describe-it",
    "naming": "BDD",
    "example": "describe('UserService', () => { it('should create user', ...) })"
  },
  "location": {
    "pattern": "co-located",
    "suffix": ".test.tsx"
  },
  "mocking": {
    "functions": "vi.fn()",
    "modules": "vi.mock()",
    "api": "msw"
  },
  "fixtures": {
    "pattern": "factories",
    "location": "tests/factories/"
  },
  "assertions": {
    "library": "vitest",
    "style": "expect().toBe()"
  },
  "confidence": 0.9
}
```

### spec-patterns.json

```json
{
  "location": "docs/specs/",
  "format": "markdown",
  "structure": {
    "sections": [
      "Overview",
      "Problem Statement",
      "Requirements",
      "User Stories",
      "Acceptance Criteria",
      "Edge Cases",
      "Out of Scope"
    ]
  },
  "userStories": {
    "format": "as-a-i-want-so-that",
    "example": "As a user, I want to reset my password, so that I can regain access"
  },
  "acceptanceCriteria": {
    "format": "gherkin",
    "example": "Given I am on login page\nWhen I click 'Forgot password'\nThen I see the reset form"
  },
  "examples": {
    "required": true,
    "format": "table"
  },
  "confidence": 0.8
}
```

### style-patterns.json

```json
{
  "typescript": {
    "strict": true,
    "noAny": true,
    "enums": "const-enum",
    "nullHandling": "strict-null-checks"
  },
  "naming": {
    "files": "kebab-case",
    "components": "PascalCase",
    "functions": "camelCase",
    "constants": "UPPER_SNAKE_CASE",
    "types": "PascalCase",
    "interfaces": "PascalCase (no I prefix)"
  },
  "formatting": {
    "tool": "prettier",
    "lineLength": 100,
    "quotes": "single",
    "semicolons": true,
    "trailingComma": "es5"
  },
  "comments": {
    "jsdoc": "public-apis-only",
    "inline": "minimal"
  },
  "confidence": 0.95
}
```

### summary.md

Human-readable summary generated after learning:

```markdown
# Project Patterns Summary

> Generated by `/learn` on 2024-01-15

## Tech Stack
- **Language:** TypeScript 5 (strict mode)
- **Framework:** React 18
- **Build:** Vite
- **Tests:** Vitest + Testing Library
- **State:** Zustand (client) + React Query (server)
- **Styling:** TailwindCSS

## Architecture
Feature-based organization:
- `src/features/` - Domain features
- `src/components/` - Shared UI components
- `src/hooks/` - Custom React hooks
- `src/utils/` - Utility functions

## Code Conventions
- **Imports:** Absolute with `@/` alias
- **Exports:** Named exports, barrel files
- **Error handling:** Try/catch with custom error types
- **Components:** Functional with hooks

## Testing Conventions
- **Location:** Co-located (`Component.test.tsx`)
- **Structure:** `describe` blocks with BDD naming
- **Mocking:** MSW for APIs, vi.fn() for functions
- **Fixtures:** Factory functions in `tests/factories/`

## Spec Format
- **Location:** `docs/specs/`
- **User stories:** As a / I want / So that
- **Acceptance criteria:** Gherkin (Given/When/Then)
- **Required sections:** Overview, Requirements, AC, Edge Cases

## Style Guide
- **Files:** kebab-case
- **Components:** PascalCase
- **No `any`:** Enforced by ESLint
- **Line length:** 100 characters
- **Quotes:** Single
```

---

## Agent Integration

When agents start, they receive the learnings context:

```
## Your Project's Conventions

The following patterns were learned from this codebase.
**Follow these conventions** when writing code, tests, or specs.

### Code Style
- Use absolute imports with `@/` alias
- Named exports only, no default exports
- Error handling: try/catch with custom error types
- Components: functional with hooks, no classes

### Test Style
- Co-locate tests: `Component.test.tsx` next to `Component.tsx`
- Use describe/it with BDD naming: "should do X when Y"
- Mock APIs with MSW, functions with vi.fn()
- Use factories from `tests/factories/`

### Spec Style
- Sections: Overview → Requirements → AC → Edge Cases
- User stories: As a [role], I want [goal], so that [benefit]
- Acceptance criteria: Gherkin format (Given/When/Then)
- Always include examples

### Naming
- Files: kebab-case (`user-service.ts`)
- Components: PascalCase (`UserProfile.tsx`)
- Functions: camelCase (`getUserById`)
- Types: PascalCase (`UserResponse`)
```

---

## Incremental Learning

Learnings can be updated incrementally:

### After a Fix
When an agent fixes something, record what worked:

```jsonl
// .spectre/learnings/fixes.jsonl
{"timestamp":"...","pattern":"import-alias","before":"../../../components","after":"@/components","agent":"frontend-dev"}
{"timestamp":"...","pattern":"test-mock","technique":"vi.mock with factory","file":"UserService.test.ts","agent":"qa-engineer"}
```

### After Code Review
Architect feedback becomes learning:

```jsonl
// .spectre/learnings/reviews.jsonl
{"timestamp":"...","feedback":"Use Result type instead of throwing","file":"api/auth.ts","appliedBy":"frontend-dev"}
{"timestamp":"...","feedback":"Extract to custom hook","file":"components/UserList.tsx","appliedBy":"frontend-dev"}
```

### Confidence Adjustment

Patterns that work consistently increase in confidence:
- Initial detection: 0.7
- Confirmed by usage: +0.1
- Contradicted: -0.2
- Explicitly corrected by user: set to 0.95

---

## Commands

### `/learn --show`

Display current learnings:

```
📚 Current Project Learnings

Tech Stack: React + TypeScript + Vite (confidence: 95%)
Architecture: Feature-based (confidence: 85%)
Testing: Vitest + co-located (confidence: 90%)
Specs: Markdown + Gherkin (confidence: 80%)
Style: Strict TS, Prettier (confidence: 95%)

Last updated: 2024-01-15
Files analyzed: 47

Run `/learn` to refresh.
```

### `/learn --reset`

Clear all learnings:

```
🗑️ Learnings reset.

Run `/learn` to re-analyze the project.
```

---

## Tone

- **Observational:** "I noticed your project uses..."
- **Adaptive:** "I'll follow your conventions for..."
- **Transparent:** Show what was learned and confidence level
- **Non-judgmental:** Learn patterns, don't critique them
