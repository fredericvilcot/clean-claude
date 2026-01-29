---
name: test-craft
description: "Apply TDD/BDD testing principles: test pyramid, behavior-driven tests, proper test doubles, and maintainable test suites"
context: fork
agent: qa-engineer
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
---

# Test Craft Skill

You are applying software craftsmanship principles to testing. Follow these guidelines rigorously.

## TDD Workflow

### Red-Green-Refactor
```
1. RED    → Write a failing test that describes expected behavior
2. GREEN  → Write the minimum code to make the test pass
3. REFACTOR → Improve the code while keeping tests green
```

### Start from the Outside
```typescript
// 1. Start with an acceptance test (what the user wants)
describe('User Registration', () => {
  it('should send welcome email after successful registration', async () => {
    const result = await registerUser({
      email: 'new@example.com',
      password: 'SecurePass123!',
    })

    expect(result.ok).toBe(true)
    expect(emailService.sentEmails).toContainEqual(
      expect.objectContaining({
        to: 'new@example.com',
        subject: 'Welcome!',
      })
    )
  })
})

// 2. Then write unit tests for the details
describe('validatePassword', () => {
  it('should reject passwords shorter than 8 characters', () => {
    const result = validatePassword('short')
    expect(result.ok).toBe(false)
    expect(result.error.code).toBe('PASSWORD_TOO_SHORT')
  })
})
```

## Test Structure

### Arrange-Act-Assert (AAA)
```typescript
describe('ShoppingCart', () => {
  describe('when adding an item', () => {
    it('should increase total by item price', () => {
      // Arrange - Set up the test scenario
      const cart = new ShoppingCart()
      const item = createTestItem({ price: 29.99 })

      // Act - Execute the behavior under test
      cart.add(item)

      // Assert - Verify the expected outcome
      expect(cart.total).toBe(29.99)
    })
  })
})
```

### Given-When-Then (BDD)
```typescript
describe('User Authentication', () => {
  describe('given a registered user', () => {
    const user = createTestUser({ email: 'user@test.com' })

    describe('when logging in with correct credentials', () => {
      it('then should return an access token', async () => {
        const result = await login({
          email: user.email,
          password: 'correctPassword',
        })

        expect(result.ok).toBe(true)
        expect(result.value.accessToken).toBeDefined()
      })
    })

    describe('when logging in with wrong password', () => {
      it('then should return invalid credentials error', async () => {
        const result = await login({
          email: user.email,
          password: 'wrongPassword',
        })

        expect(result.ok).toBe(false)
        expect(result.error.code).toBe('INVALID_CREDENTIALS')
      })
    })
  })
})
```

### Descriptive Test Names
```typescript
// Bad: vague test names
it('should work', () => {})
it('test add', () => {})
it('handles error', () => {})

// Good: behavior specifications
it('should calculate discount when cart total exceeds $100', () => {})
it('should reject expired credit cards with clear error message', () => {})
it('should retry failed API calls up to 3 times', () => {})
```

## Test Pyramid

### Unit Tests (Base - Many)
Fast, isolated, test single units:
```typescript
// Test pure business logic
describe('calculateDiscount', () => {
  it('should apply 10% discount for orders over $100', () => {
    const discount = calculateDiscount(150)
    expect(discount).toBe(15)
  })

  it('should not apply discount for orders under $100', () => {
    const discount = calculateDiscount(50)
    expect(discount).toBe(0)
  })

  it('should handle edge case of exactly $100', () => {
    const discount = calculateDiscount(100)
    expect(discount).toBe(0) // Not "over" $100
  })
})
```

### Integration Tests (Middle - Some)
Test component interactions:
```typescript
// Test with real dependencies (or realistic fakes)
describe('UserService', () => {
  let userService: UserService
  let userRepository: InMemoryUserRepository

  beforeEach(() => {
    userRepository = new InMemoryUserRepository()
    userService = new UserService(userRepository)
  })

  it('should persist user and return with generated id', async () => {
    const result = await userService.createUser({
      email: 'test@example.com',
      name: 'Test User',
    })

    expect(result.ok).toBe(true)
    expect(result.value.id).toBeDefined()

    // Verify persistence
    const found = await userRepository.findById(result.value.id)
    expect(found).toEqual(result.value)
  })
})
```

### E2E Tests (Top - Few)
Test critical user journeys:
```typescript
// Test full user flows (sparingly)
describe('Checkout Flow', () => {
  it('should complete purchase with valid payment', async () => {
    // Setup
    await page.goto('/products')

    // Add to cart
    await page.click('[data-testid="add-to-cart-1"]')
    await page.click('[data-testid="go-to-checkout"]')

    // Fill payment
    await page.fill('[name="cardNumber"]', '4242424242424242')
    await page.fill('[name="expiry"]', '12/25')
    await page.fill('[name="cvc"]', '123')

    // Complete purchase
    await page.click('[data-testid="pay-now"]')

    // Verify success
    await expect(page.locator('.order-confirmation')).toBeVisible()
  })
})
```

## Test Doubles

### When to Use Each

| Double | Purpose | Example |
|--------|---------|---------|
| **Stub** | Provide canned answers | `stub.returns({ id: '123' })` |
| **Mock** | Verify interactions | `expect(mock).toHaveBeenCalledWith(...)` |
| **Spy** | Record calls, keep behavior | `vi.spyOn(service, 'method')` |
| **Fake** | Working implementation | `InMemoryUserRepository` |

### Prefer Fakes Over Mocks
```typescript
// Bad: over-mocking loses confidence
const mockRepo = {
  findById: vi.fn().mockResolvedValue(user),
  save: vi.fn().mockResolvedValue(undefined),
  delete: vi.fn().mockResolvedValue(undefined),
}

// Good: fake with real behavior
class InMemoryUserRepository implements UserRepository {
  private users = new Map<string, User>()

  async findById(id: string): Promise<User | null> {
    return this.users.get(id) ?? null
  }

  async save(user: User): Promise<void> {
    this.users.set(user.id, user)
  }

  async delete(id: string): Promise<void> {
    this.users.delete(id)
  }
}
```

### Mock External Services
```typescript
// Use MSW for HTTP mocking
import { setupServer } from 'msw/node'
import { http, HttpResponse } from 'msw'

const server = setupServer(
  http.get('/api/users/:id', ({ params }) => {
    return HttpResponse.json({
      id: params.id,
      name: 'Test User',
    })
  }),

  http.post('/api/users', async ({ request }) => {
    const body = await request.json()
    return HttpResponse.json({ id: 'new-id', ...body }, { status: 201 })
  })
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())
```

## Test Factories

### Build Test Data Consistently
```typescript
// test/factories/user.factory.ts
import { faker } from '@faker-js/faker'

type UserOverrides = Partial<User>

export function createTestUser(overrides: UserOverrides = {}): User {
  return {
    id: faker.string.uuid(),
    email: faker.internet.email(),
    name: faker.person.fullName(),
    createdAt: new Date(),
    ...overrides,
  }
}

// Usage
const user = createTestUser({ email: 'specific@test.com' })
const admin = createTestUser({ role: 'admin' })
```

### Builder Pattern for Complex Objects
```typescript
class OrderBuilder {
  private order: Partial<Order> = {}

  withCustomer(customer: Customer): this {
    this.order.customer = customer
    return this
  }

  withItems(items: OrderItem[]): this {
    this.order.items = items
    return this
  }

  withDiscount(discount: number): this {
    this.order.discount = discount
    return this
  }

  build(): Order {
    return {
      id: faker.string.uuid(),
      customer: this.order.customer ?? createTestCustomer(),
      items: this.order.items ?? [createTestOrderItem()],
      discount: this.order.discount ?? 0,
      createdAt: new Date(),
    }
  }
}

// Usage
const order = new OrderBuilder()
  .withCustomer(vipCustomer)
  .withDiscount(20)
  .build()
```

## Edge Cases & Error Paths

### Always Test Error Scenarios
```typescript
describe('UserService.createUser', () => {
  it('should return error when email already exists', async () => {
    // Arrange
    const existingUser = createTestUser({ email: 'taken@test.com' })
    await userRepository.save(existingUser)

    // Act
    const result = await userService.createUser({
      email: 'taken@test.com',
      name: 'New User',
    })

    // Assert
    expect(result.ok).toBe(false)
    expect(result.error.code).toBe('EMAIL_ALREADY_EXISTS')
  })

  it('should return error when email format is invalid', async () => {
    const result = await userService.createUser({
      email: 'not-an-email',
      name: 'Test',
    })

    expect(result.ok).toBe(false)
    expect(result.error.code).toBe('INVALID_EMAIL_FORMAT')
  })
})
```

### Boundary Testing
```typescript
describe('Pagination', () => {
  it('should handle empty results', async () => {
    const result = await getUsers({ page: 1, limit: 10 })
    expect(result.items).toEqual([])
    expect(result.totalPages).toBe(0)
  })

  it('should handle last page with fewer items', async () => {
    // Setup: 25 users, requesting page 3 with limit 10
    await seedUsers(25)

    const result = await getUsers({ page: 3, limit: 10 })

    expect(result.items).toHaveLength(5) // Only 5 remaining
    expect(result.hasNextPage).toBe(false)
  })

  it('should handle page beyond total pages', async () => {
    await seedUsers(10)

    const result = await getUsers({ page: 100, limit: 10 })

    expect(result.items).toEqual([])
  })
})
```

## Test Organization

### File Structure
```
src/
├── domain/
│   └── user/
│       ├── user.ts
│       └── user.test.ts          # Unit tests next to source
├── application/
│   └── user/
│       ├── create-user.ts
│       └── create-user.test.ts
└── infrastructure/
    └── persistence/
        ├── postgres-user-repo.ts
        └── postgres-user-repo.integration.test.ts

test/
├── e2e/
│   └── checkout.e2e.test.ts      # E2E tests separate
├── factories/
│   └── user.factory.ts            # Shared test factories
├── fixtures/
│   └── users.json                 # Test data fixtures
└── setup.ts                       # Test configuration
```

### Test Configuration
```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['src/**/*.test.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html'],
      exclude: ['**/*.test.ts', 'test/**'],
    },
    setupFiles: ['./test/setup.ts'],
  },
})
```

## Anti-Patterns to Avoid

### Don't Test Implementation Details
```typescript
// Bad: testing internal state
it('should set isLoading to true', () => {
  const { result } = renderHook(() => useUsers())
  expect(result.current.isLoading).toBe(true) // Implementation detail
})

// Good: testing observable behavior
it('should show loading indicator while fetching', () => {
  render(<UserList />)
  expect(screen.getByRole('progressbar')).toBeInTheDocument()
})
```

### Don't Use Arbitrary Waits
```typescript
// Bad: arbitrary timeout
await new Promise((r) => setTimeout(r, 1000))
expect(element).toBeVisible()

// Good: wait for condition
await waitFor(() => {
  expect(element).toBeVisible()
})
```

### Don't Share Mutable State
```typescript
// Bad: shared state between tests
let user: User

beforeAll(() => {
  user = createTestUser()
})

it('test 1', () => {
  user.name = 'Modified' // Affects other tests!
})

// Good: fresh state per test
let user: User

beforeEach(() => {
  user = createTestUser()
})
```

## When Reviewing Test Code

Check for:
1. Test names describe behavior clearly
2. AAA/GWT structure is followed
3. No implementation details tested
4. Error scenarios covered
5. Edge cases handled
6. No flaky tests (arbitrary waits, shared state)
7. Appropriate test level (unit vs integration vs e2e)
8. Test doubles used appropriately
