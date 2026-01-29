# TypeScript + Node.js — Craft Defaults

Ces guidelines sont injectées automatiquement aux agents travaillant sur un projet TypeScript + Node.js backend.

---

## Type System

### Configuration stricte

```json
// tsconfig.json — non négociable
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "exactOptionalPropertyTypes": true
  }
}
```

### Types métier explicites

```typescript
// ✅ Branded types pour les IDs
type UserId = string & { readonly __brand: 'UserId' };
type OrderId = string & { readonly __brand: 'OrderId' };

function createUserId(id: string): UserId {
  return id as UserId;
}

// ✅ Impossible de confondre
function getUser(id: UserId): Promise<User> { }
function getOrder(id: OrderId): Promise<Order> { }

getUser(orderId); // ❌ Type error!
```

### Validation aux frontières

```typescript
// ✅ Zod pour validation + inférence de types
import { z } from 'zod';

const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2).max(100),
  age: z.number().int().positive().optional(),
});

type CreateUserInput = z.infer<typeof CreateUserSchema>;

// ✅ Validation à l'entrée du controller
function createUser(input: unknown): Result<User, ValidationError> {
  const parsed = CreateUserSchema.safeParse(input);
  if (!parsed.success) {
    return err(new ValidationError(parsed.error));
  }
  return userService.create(parsed.data);
}
```

---

## Error Handling — Result Types

### Définition

```typescript
// ✅ Result type central
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };

// Helpers
const ok = <T>(value: T): Result<T, never> => ({ ok: true, value });
const err = <E>(error: E): Result<never, E> => ({ ok: false, error });
```

### Erreurs métier typées

```typescript
// ✅ Erreurs explicites par domaine
class UserNotFoundError extends Error {
  readonly _tag = 'UserNotFoundError';
  constructor(public readonly userId: string) {
    super(`User ${userId} not found`);
  }
}

class EmailAlreadyExistsError extends Error {
  readonly _tag = 'EmailAlreadyExistsError';
  constructor(public readonly email: string) {
    super(`Email ${email} already registered`);
  }
}

type CreateUserError = ValidationError | EmailAlreadyExistsError;

// ✅ Service avec erreurs typées
async function createUser(
  input: CreateUserInput
): Promise<Result<User, CreateUserError>> {
  const existing = await userRepo.findByEmail(input.email);
  if (existing) {
    return err(new EmailAlreadyExistsError(input.email));
  }
  const user = await userRepo.create(input);
  return ok(user);
}
```

### Propagation dans les controllers

```typescript
// ✅ Controller mappe Result → HTTP Response
async function handleCreateUser(req: Request, res: Response) {
  const result = await createUser(req.body);

  if (!result.ok) {
    switch (result.error._tag) {
      case 'ValidationError':
        return res.status(400).json({ error: result.error.message });
      case 'EmailAlreadyExistsError':
        return res.status(409).json({ error: 'Email already exists' });
      default:
        return res.status(500).json({ error: 'Internal error' });
    }
  }

  return res.status(201).json(result.value);
}
```

### Anti-patterns

```typescript
// ❌ JAMAIS
throw new Error('User not found'); // Exception non typée
try { } catch (e) { } // Catch silencieux
if (error) throw error; // Re-throw aveugle

// ✅ TOUJOURS
return err(new UserNotFoundError(id)); // Explicite, typé, retourné
```

---

## Architecture — Hexagonal / Ports & Adapters

### Structure

```
src/
├── domain/                 # Coeur métier — ZERO dépendances
│   ├── entities/
│   │   └── User.ts
│   ├── value-objects/
│   │   └── Email.ts
│   ├── errors/
│   │   └── UserErrors.ts
│   └── services/
│       └── UserService.ts
│
├── application/            # Use cases — orchestre le domaine
│   ├── use-cases/
│   │   ├── CreateUser.ts
│   │   └── GetUser.ts
│   └── ports/              # Interfaces (contrats)
│       ├── UserRepository.ts
│       └── EmailService.ts
│
├── infrastructure/         # Implémentations concrètes
│   ├── repositories/
│   │   └── PrismaUserRepository.ts
│   ├── services/
│   │   └── SendGridEmailService.ts
│   └── http/
│       ├── controllers/
│       ├── middleware/
│       └── routes.ts
│
└── main.ts                 # Composition root — DI wiring
```

### Dependency Inversion

```typescript
// ✅ Port (interface) dans application/
interface UserRepository {
  findById(id: UserId): Promise<User | null>;
  findByEmail(email: Email): Promise<User | null>;
  save(user: User): Promise<User>;
}

// ✅ Use case dépend de l'interface, pas de l'implémentation
class CreateUserUseCase {
  constructor(
    private readonly userRepo: UserRepository,
    private readonly emailService: EmailService,
  ) {}

  async execute(input: CreateUserInput): Promise<Result<User, CreateUserError>> {
    // ...
  }
}

// ✅ Adapter implémente l'interface
class PrismaUserRepository implements UserRepository {
  constructor(private readonly prisma: PrismaClient) {}

  async findById(id: UserId): Promise<User | null> {
    const data = await this.prisma.user.findUnique({ where: { id } });
    return data ? toUser(data) : null;
  }
}
```

### Composition Root

```typescript
// ✅ main.ts — seul endroit avec des imports concrets
import { PrismaClient } from '@prisma/client';
import { PrismaUserRepository } from './infrastructure/repositories';
import { CreateUserUseCase } from './application/use-cases';
import { createApp } from './infrastructure/http';

const prisma = new PrismaClient();
const userRepo = new PrismaUserRepository(prisma);
const createUser = new CreateUserUseCase(userRepo, emailService);

const app = createApp({ createUser, /* ... */ });
app.listen(3000);
```

---

## API Design — REST

### Conventions

| Action | Méthode | Route | Status Success | Status Error |
|--------|---------|-------|----------------|--------------|
| List | GET | /users | 200 | 500 |
| Get | GET | /users/:id | 200 | 404, 500 |
| Create | POST | /users | 201 | 400, 409, 500 |
| Update | PUT | /users/:id | 200 | 400, 404, 500 |
| Partial | PATCH | /users/:id | 200 | 400, 404, 500 |
| Delete | DELETE | /users/:id | 204 | 404, 500 |

### Response Format

```typescript
// ✅ Format uniforme
interface ApiResponse<T> {
  data: T;
  meta?: {
    page?: number;
    pageSize?: number;
    total?: number;
  };
}

interface ApiError {
  error: {
    code: string;
    message: string;
    details?: unknown;
  };
}

// ✅ Exemples
// Success: { "data": { "id": "123", "name": "John" } }
// Error: { "error": { "code": "USER_NOT_FOUND", "message": "..." } }
```

### Validation Middleware

```typescript
// ✅ Middleware générique avec Zod
function validate<T>(schema: z.ZodSchema<T>) {
  return (req: Request, res: Response, next: NextFunction) => {
    const result = schema.safeParse(req.body);
    if (!result.success) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Invalid input',
          details: result.error.flatten(),
        },
      });
    }
    req.body = result.data;
    next();
  };
}

// Usage
router.post('/users', validate(CreateUserSchema), createUserController);
```

---

## Testing

### Stratégie

| Type | Cible | Outils | Couverture |
|------|-------|--------|------------|
| Unit | Domain, Use cases | Vitest | 80%+ |
| Integration | Repositories, API | Vitest + Supertest | Routes critiques |
| E2E | Flows complets | Playwright | Happy paths |

### Unit Tests — Domain

```typescript
// ✅ Test du domaine — pur, rapide
describe('CreateUserUseCase', () => {
  it('returns error when email already exists', async () => {
    const userRepo = createMockUserRepo({
      findByEmail: async () => existingUser,
    });
    const useCase = new CreateUserUseCase(userRepo, mockEmailService);

    const result = await useCase.execute(validInput);

    expect(result.ok).toBe(false);
    expect(result.error).toBeInstanceOf(EmailAlreadyExistsError);
  });
});
```

### Integration Tests — API

```typescript
// ✅ Test d'intégration avec vraie DB (test container)
describe('POST /users', () => {
  it('creates user and returns 201', async () => {
    const response = await request(app)
      .post('/users')
      .send({ email: 'test@example.com', name: 'Test' })
      .expect(201);

    expect(response.body.data).toMatchObject({
      email: 'test@example.com',
      name: 'Test',
    });
  });

  it('returns 409 when email exists', async () => {
    await createUser({ email: 'existing@example.com' });

    await request(app)
      .post('/users')
      .send({ email: 'existing@example.com', name: 'Test' })
      .expect(409);
  });
});
```

### Mocking Strategy

```typescript
// ✅ Factory pour les mocks
function createMockUserRepo(
  overrides: Partial<UserRepository> = {}
): UserRepository {
  return {
    findById: async () => null,
    findByEmail: async () => null,
    save: async (user) => user,
    ...overrides,
  };
}

// ❌ JAMAIS de jest.mock() global
// ✅ Injection de dépendances = testabilité native
```

---

## Security

### Input Validation

```typescript
// ✅ Valider TOUT input externe
const schema = z.object({
  email: z.string().email().max(255),
  name: z.string().min(1).max(100).regex(/^[\w\s-]+$/),
});

// ✅ Sanitization si nécessaire
import { escape } from 'lodash';
const safeName = escape(input.name);
```

### Authentication

```typescript
// ✅ JWT avec refresh token
interface TokenPayload {
  sub: UserId;
  exp: number;
  iat: number;
}

// ✅ Middleware auth
async function authenticate(req: Request, res: Response, next: NextFunction) {
  const token = extractBearerToken(req.headers.authorization);
  if (!token) {
    return res.status(401).json({ error: { code: 'UNAUTHORIZED' } });
  }

  const result = verifyToken(token);
  if (!result.ok) {
    return res.status(401).json({ error: { code: 'INVALID_TOKEN' } });
  }

  req.user = result.value;
  next();
}
```

### Headers & CORS

```typescript
// ✅ Security headers avec Helmet
app.use(helmet());

// ✅ CORS restrictif
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(','),
  credentials: true,
}));

// ✅ Rate limiting
app.use(rateLimit({
  windowMs: 15 * 60 * 1000, // 15 min
  max: 100,
}));
```

---

## Logging & Observability

```typescript
// ✅ Structured logging
import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
});

// ✅ Correlation ID middleware
app.use((req, res, next) => {
  req.correlationId = req.headers['x-correlation-id'] || uuid();
  req.log = logger.child({ correlationId: req.correlationId });
  next();
});

// ✅ Log avec contexte
req.log.info({ userId, action: 'user.created' }, 'User created successfully');

// ❌ JAMAIS
console.log('User created'); // Pas de contexte
logger.info({ password }); // Données sensibles !
```

---

## Anti-patterns globaux

| Anti-pattern | Problème | Solution |
|--------------|----------|----------|
| `any` | Perte de types | `unknown` + validation |
| `throw Error` | Non typé | `Result<T, E>` |
| Catch silencieux | Erreurs cachées | Log + handle explicite |
| Import concret dans domain | Couplage | Dependency Inversion |
| `console.log` | Pas structuré | Logger (pino) |
| SQL brut | Injection | ORM ou query builder |
| Secrets en dur | Fuite | Variables d'env |
| God services | 1000+ lignes | Split par use case |

---

## Checklist avant PR

- [ ] Pas de `any` ni assertions de type hasardeuses
- [ ] Toutes les erreurs sont des Result, pas des throws
- [ ] Validation Zod sur tous les inputs externes
- [ ] Domain libre de dépendances infrastructure
- [ ] Tests unitaires pour les use cases
- [ ] Tests d'intégration pour les routes
- [ ] Pas de données sensibles dans les logs
- [ ] Headers de sécurité en place
