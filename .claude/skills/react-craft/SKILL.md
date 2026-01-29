---
name: react-craft
description: "Apply software craftsmanship principles to React code: component design, hooks, state management, accessibility, and testing"
context: fork
agent: frontend-dev
allowed-tools: Read, Grep, Glob, Edit, Write
---

# React Craft Skill

You are applying software craftsmanship principles to React code. Follow these guidelines rigorously.

## Component Design

### Single Responsibility
Each component should do one thing well:
```tsx
// Bad: component doing too much
function UserDashboard({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null)
  const [posts, setPosts] = useState<Post[]>([])
  const [isEditing, setIsEditing] = useState(false)
  // ... 200 lines of mixed concerns
}

// Good: composed from focused components
function UserDashboard({ userId }: { userId: string }) {
  return (
    <div className="dashboard">
      <UserProfile userId={userId} />
      <UserPosts userId={userId} />
      <UserSettings userId={userId} />
    </div>
  )
}
```

### Props API Design
```tsx
// Bad: too many props, unclear API
interface ButtonProps {
  text: string
  onClick: () => void
  isLoading: boolean
  isDisabled: boolean
  isPrimary: boolean
  isSecondary: boolean
  isSmall: boolean
  isLarge: boolean
}

// Good: minimal, composable API
interface ButtonProps {
  children: React.ReactNode
  onClick?: () => void
  variant?: 'primary' | 'secondary' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  isLoading?: boolean
  disabled?: boolean
}
```

### Composition Over Configuration
```tsx
// Bad: configuration prop explosion
<Card
  hasHeader
  headerTitle="Users"
  headerAction={<Button>Add</Button>}
  hasFooter
  footerContent={<Pagination />}
>
  {content}
</Card>

// Good: composable compound components
<Card>
  <Card.Header>
    <Card.Title>Users</Card.Title>
    <Button>Add</Button>
  </Card.Header>
  <Card.Body>{content}</Card.Body>
  <Card.Footer>
    <Pagination />
  </Card.Footer>
</Card>
```

## Hooks Patterns

### Custom Hooks for Logic Extraction
```tsx
// Extract reusable logic into custom hooks
function useAsync<T>(asyncFn: () => Promise<T>, deps: unknown[] = []) {
  const [state, setState] = useState<AsyncData<T>>({ status: 'idle' })

  useEffect(() => {
    setState({ status: 'loading' })
    asyncFn()
      .then((data) => setState({ status: 'success', data }))
      .catch((error) => setState({ status: 'error', error }))
  }, deps)

  return state
}

// Usage
function UserProfile({ userId }: { userId: string }) {
  const userState = useAsync(() => fetchUser(userId), [userId])

  if (userState.status === 'loading') return <Spinner />
  if (userState.status === 'error') return <Error error={userState.error} />
  if (userState.status === 'success') return <Profile user={userState.data} />
  return null
}
```

### Hook Rules
- Always call hooks at the top level
- Only call hooks from React functions
- Name custom hooks with `use` prefix
- Keep hooks focused on single concern

### Avoid Prop Drilling
```tsx
// Bad: drilling props through many levels
<App user={user}>
  <Layout user={user}>
    <Sidebar user={user}>
      <UserMenu user={user} />
    </Sidebar>
  </Layout>
</App>

// Good: context for shared state
const UserContext = createContext<User | null>(null)

function useUser() {
  const user = useContext(UserContext)
  if (!user) throw new Error('useUser must be within UserProvider')
  return user
}

// Usage anywhere in tree
function UserMenu() {
  const user = useUser()
  return <span>{user.name}</span>
}
```

## State Management

### Local State First
```tsx
// Start with local state, lift only when needed
function SearchInput({ onSearch }: { onSearch: (query: string) => void }) {
  const [query, setQuery] = useState('')

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    onSearch(query)
  }

  return (
    <form onSubmit={handleSubmit}>
      <input value={query} onChange={(e) => setQuery(e.target.value)} />
      <button type="submit">Search</button>
    </form>
  )
}
```

### State Colocation
Keep state as close as possible to where it's used:
```tsx
// Bad: global state for local concern
const globalStore = create(() => ({
  isModalOpen: false,
  setModalOpen: (open: boolean) => set({ isModalOpen: open }),
}))

// Good: local state for local concern
function FeatureSection() {
  const [isModalOpen, setModalOpen] = useState(false)
  return (
    <>
      <Button onClick={() => setModalOpen(true)}>Open</Button>
      <Modal isOpen={isModalOpen} onClose={() => setModalOpen(false)} />
    </>
  )
}
```

### Server State with React Query
```tsx
// Separate server state from client state
function UserList() {
  const { data: users, isLoading, error } = useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers,
  })

  if (isLoading) return <Spinner />
  if (error) return <Error error={error} />

  return (
    <ul>
      {users.map((user) => (
        <UserItem key={user.id} user={user} />
      ))}
    </ul>
  )
}
```

## Accessibility (a11y)

### Semantic HTML First
```tsx
// Bad: div soup
<div className="button" onClick={handleClick}>
  Click me
</div>

// Good: semantic elements
<button type="button" onClick={handleClick}>
  Click me
</button>
```

### Interactive Elements
```tsx
// Every interactive element must be keyboard accessible
function ClickableCard({ onClick, children }: ClickableCardProps) {
  return (
    <article
      role="button"
      tabIndex={0}
      onClick={onClick}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault()
          onClick()
        }
      }}
    >
      {children}
    </article>
  )
}
```

### ARIA When Needed
```tsx
// Use ARIA only when HTML semantics aren't sufficient
function LoadingButton({ isLoading, children, ...props }: LoadingButtonProps) {
  return (
    <button
      {...props}
      disabled={isLoading}
      aria-busy={isLoading}
      aria-describedby={isLoading ? 'loading-status' : undefined}
    >
      {isLoading ? (
        <>
          <Spinner aria-hidden="true" />
          <span id="loading-status" className="sr-only">
            Loading, please wait...
          </span>
        </>
      ) : (
        children
      )}
    </button>
  )
}
```

### Focus Management
```tsx
// Manage focus for modal dialogs
function Modal({ isOpen, onClose, children }: ModalProps) {
  const closeButtonRef = useRef<HTMLButtonElement>(null)

  useEffect(() => {
    if (isOpen) {
      closeButtonRef.current?.focus()
    }
  }, [isOpen])

  if (!isOpen) return null

  return (
    <dialog open aria-modal="true" role="dialog">
      <button ref={closeButtonRef} onClick={onClose} aria-label="Close">
        ×
      </button>
      {children}
    </dialog>
  )
}
```

## Performance

### Avoid Unnecessary Re-renders
```tsx
// Memoize expensive computations
const sortedItems = useMemo(
  () => items.sort((a, b) => a.name.localeCompare(b.name)),
  [items]
)

// Memoize callbacks passed to children
const handleClick = useCallback(() => {
  doSomething(id)
}, [id])

// Memoize components that receive objects/arrays
const MemoizedChild = memo(ExpensiveChild)
```

### Code Splitting
```tsx
// Lazy load routes and heavy components
const AdminDashboard = lazy(() => import('./AdminDashboard'))

function App() {
  return (
    <Suspense fallback={<PageSkeleton />}>
      <Routes>
        <Route path="/admin" element={<AdminDashboard />} />
      </Routes>
    </Suspense>
  )
}
```

### List Rendering
```tsx
// Always use stable, unique keys
function UserList({ users }: { users: User[] }) {
  return (
    <ul>
      {users.map((user) => (
        // Good: stable unique id
        <UserItem key={user.id} user={user} />
        // Bad: index as key (causes issues with reordering)
        // <UserItem key={index} user={user} />
      ))}
    </ul>
  )
}
```

## Testing

### Test User Behavior, Not Implementation
```tsx
// Bad: testing implementation details
it('should call setIsOpen when button is clicked', () => {
  const setIsOpen = vi.fn()
  render(<Modal setIsOpen={setIsOpen} />)
  fireEvent.click(screen.getByRole('button'))
  expect(setIsOpen).toHaveBeenCalledWith(true)
})

// Good: testing user behavior
it('should open modal when trigger button is clicked', async () => {
  render(<ModalWithTrigger />)

  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()

  await userEvent.click(screen.getByRole('button', { name: /open/i }))

  expect(screen.getByRole('dialog')).toBeInTheDocument()
})
```

### Accessibility Queries
```tsx
// Prefer accessibility queries
screen.getByRole('button', { name: /submit/i })
screen.getByLabelText(/email/i)
screen.getByRole('heading', { level: 1 })
screen.getByRole('link', { name: /learn more/i })

// Avoid test IDs unless necessary
screen.getByTestId('submit-button') // Last resort
```

### Component Testing Structure
```tsx
describe('LoginForm', () => {
  it('should submit credentials when form is valid', async () => {
    const onSubmit = vi.fn()
    render(<LoginForm onSubmit={onSubmit} />)

    await userEvent.type(screen.getByLabelText(/email/i), 'user@example.com')
    await userEvent.type(screen.getByLabelText(/password/i), 'password123')
    await userEvent.click(screen.getByRole('button', { name: /sign in/i }))

    expect(onSubmit).toHaveBeenCalledWith({
      email: 'user@example.com',
      password: 'password123',
    })
  })

  it('should display error when email is invalid', async () => {
    render(<LoginForm onSubmit={vi.fn()} />)

    await userEvent.type(screen.getByLabelText(/email/i), 'invalid-email')
    await userEvent.click(screen.getByRole('button', { name: /sign in/i }))

    expect(screen.getByRole('alert')).toHaveTextContent(/valid email/i)
  })
})
```

## File Structure

```
src/
├── components/
│   ├── ui/                    # Generic UI components
│   │   ├── Button/
│   │   │   ├── Button.tsx
│   │   │   ├── Button.test.tsx
│   │   │   └── index.ts
│   │   └── Modal/
│   └── features/              # Feature-specific components
│       └── auth/
│           ├── LoginForm.tsx
│           └── LoginForm.test.tsx
├── hooks/                     # Shared custom hooks
│   ├── useAsync.ts
│   └── useLocalStorage.ts
├── lib/                       # Utilities and helpers
│   ├── api.ts
│   └── validation.ts
└── types/                     # Shared TypeScript types
    └── index.ts
```

## When Reviewing React Code

Check for:
1. Component single responsibility
2. Props API clarity and minimalism
3. Proper hook usage (rules, dependencies)
4. Accessibility (keyboard, screen reader)
5. Performance (memoization when needed)
6. Testing (behavior, not implementation)
7. State colocation (local before global)
