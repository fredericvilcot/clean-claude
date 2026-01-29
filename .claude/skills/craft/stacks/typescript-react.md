# TypeScript + React — Craft Defaults

Ces guidelines sont injectées automatiquement aux agents travaillant sur un projet TypeScript + React.

---

## Type System

### Règles strictes
- `strict: true` dans tsconfig.json — non négociable
- **Jamais `any`** — utiliser `unknown` puis narrowing
- Props typées explicitement, pas d'inférence implicite
- Generics pour composants et hooks réutilisables

### Patterns recommandés

```typescript
// ✅ Props explicites avec children typés
interface ButtonProps {
  variant: 'primary' | 'secondary';
  disabled?: boolean;
  onClick: () => void;
  children: React.ReactNode;
}

// ✅ Generic pour composant réutilisable
interface ListProps<T> {
  items: T[];
  renderItem: (item: T) => React.ReactNode;
  keyExtractor: (item: T) => string;
}

// ✅ Discriminated unions pour états
type AsyncState<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: Error };
```

### Anti-patterns

```typescript
// ❌ JAMAIS
const data: any = fetchData();
props.onClick && props.onClick(); // undefined check implicite

// ✅ TOUJOURS
const data: unknown = fetchData();
if (isUserData(data)) { /* narrowed */ }
props.onClick?.(); // optional chaining explicite
```

---

## Error Handling

### Result Type obligatoire

```typescript
// ✅ Définir un Result type
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };

// ✅ Utilisation
async function fetchUser(id: string): Promise<Result<User, ApiError>> {
  try {
    const response = await api.get(`/users/${id}`);
    return { ok: true, value: response.data };
  } catch (e) {
    return { ok: false, error: toApiError(e) };
  }
}

// ✅ Consommation
const result = await fetchUser(id);
if (!result.ok) {
  showError(result.error.message);
  return;
}
const user = result.value; // Type narrowed to User
```

### Error Boundaries

```typescript
// ✅ Error boundary pour chaque feature
<ErrorBoundary fallback={<FeatureError />}>
  <UserProfile userId={id} />
</ErrorBoundary>
```

### Anti-patterns

```typescript
// ❌ JAMAIS
try {
  doSomething();
} catch (e) {
  // Silencieux ou juste console.log
}

throw new Error('Something went wrong'); // Exceptions non typées

// ✅ TOUJOURS
// Erreurs explicites, typées, retournées
```

---

## Architecture des Composants

### Structure recommandée

```
src/
├── features/              # Feature folders
│   └── auth/
│       ├── components/
│       │   ├── LoginForm.tsx
│       │   └── LoginForm.test.tsx   # Colocalisé
│       ├── hooks/
│       │   └── useAuth.ts
│       ├── types.ts
│       └── index.ts       # Barrel export
├── shared/
│   ├── components/        # Composants réutilisables
│   ├── hooks/
│   └── utils/
└── app/                   # Setup, routing, providers
```

### Composants purs

```typescript
// ✅ Composant pur — logique dans les hooks
function UserCard({ user, onEdit }: UserCardProps) {
  return (
    <Card>
      <Avatar src={user.avatar} alt={user.name} />
      <Text>{user.name}</Text>
      <Button onClick={onEdit}>Edit</Button>
    </Card>
  );
}

// ✅ Logique extraite dans un hook
function useUserCard(userId: string) {
  const { data: user, isLoading } = useUser(userId);
  const { mutate: updateUser } = useUpdateUser();

  const handleEdit = useCallback(() => {
    // logic
  }, []);

  return { user, isLoading, handleEdit };
}
```

### Composition over Props Drilling

```typescript
// ❌ Props drilling
<App user={user}>
  <Layout user={user}>
    <Sidebar user={user}>
      <UserMenu user={user} />

// ✅ Composition avec Context ou children
<UserProvider user={user}>
  <App>
    <Layout>
      <Sidebar>
        <UserMenu /> {/* useUser() inside */}
```

---

## Hooks — Règles strictes

### Custom Hooks

```typescript
// ✅ Hook avec return explicite
function useToggle(initial = false) {
  const [value, setValue] = useState(initial);

  const toggle = useCallback(() => setValue(v => !v), []);
  const setTrue = useCallback(() => setValue(true), []);
  const setFalse = useCallback(() => setValue(false), []);

  return { value, toggle, setTrue, setFalse } as const;
}
```

### useEffect — Règles

```typescript
// ✅ Cleanup obligatoire pour subscriptions
useEffect(() => {
  const subscription = observable.subscribe(handler);
  return () => subscription.unsubscribe();
}, [observable]);

// ✅ AbortController pour fetch
useEffect(() => {
  const controller = new AbortController();

  fetchData({ signal: controller.signal })
    .then(setData)
    .catch(e => {
      if (e.name !== 'AbortError') setError(e);
    });

  return () => controller.abort();
}, []);
```

### Anti-patterns useEffect

```typescript
// ❌ JAMAIS — logique métier dans useEffect
useEffect(() => {
  if (user && user.age > 18) {
    setIsAdult(true);
  }
}, [user]);

// ✅ Dérivation directe
const isAdult = user && user.age > 18;

// ✅ Ou useMemo si calcul coûteux
const expensiveValue = useMemo(() => compute(data), [data]);
```

---

## State Management

### Hiérarchie de choix

1. **Local state** — `useState` pour UI locale
2. **Derived state** — Calcul direct ou `useMemo`
3. **Server state** — React Query / TanStack Query
4. **Global UI state** — Zustand ou Context (simple)
5. **Complex state** — Zustand avec slices

### React Query Pattern

```typescript
// ✅ Query avec types
const { data, isLoading, error } = useQuery({
  queryKey: ['user', userId],
  queryFn: () => fetchUser(userId),
});

// ✅ Mutation avec optimistic update
const mutation = useMutation({
  mutationFn: updateUser,
  onMutate: async (newUser) => {
    await queryClient.cancelQueries(['user', newUser.id]);
    const previous = queryClient.getQueryData(['user', newUser.id]);
    queryClient.setQueryData(['user', newUser.id], newUser);
    return { previous };
  },
  onError: (err, newUser, context) => {
    queryClient.setQueryData(['user', newUser.id], context?.previous);
  },
});
```

---

## Testing

### Stack obligatoire
- **Vitest** — Test runner
- **Testing Library** — Rendu et interactions
- **MSW** — Mock des API (pas de mock manuel)

### Patterns

```typescript
// ✅ Test du comportement, pas de l'implémentation
test('user can submit login form', async () => {
  const user = userEvent.setup();
  render(<LoginForm onSubmit={mockSubmit} />);

  await user.type(screen.getByLabelText(/email/i), 'test@example.com');
  await user.type(screen.getByLabelText(/password/i), 'password123');
  await user.click(screen.getByRole('button', { name: /sign in/i }));

  expect(mockSubmit).toHaveBeenCalledWith({
    email: 'test@example.com',
    password: 'password123',
  });
});

// ✅ data-testid uniquement si pas d'alternative accessible
<div data-testid="user-avatar" /> // OK si pas de rôle ARIA approprié
```

### Anti-patterns test

```typescript
// ❌ JAMAIS
expect(component.state.isLoading).toBe(true);  // Test d'implémentation
wrapper.find('.btn-primary').simulate('click'); // Sélecteur CSS fragile

// ✅ TOUJOURS
expect(screen.getByRole('button')).toBeDisabled(); // Comportement visible
await user.click(screen.getByRole('button', { name: /submit/i })); // Accessible
```

---

## Accessibilité (a11y)

### Règles non négociables

```typescript
// ✅ Labels explicites
<label htmlFor="email">Email</label>
<input id="email" type="email" aria-describedby="email-hint" />
<span id="email-hint">We'll never share your email</span>

// ✅ Boutons avec texte accessible
<button aria-label="Close dialog">
  <CloseIcon aria-hidden="true" />
</button>

// ✅ Focus management
const dialogRef = useRef<HTMLDivElement>(null);
useEffect(() => {
  dialogRef.current?.focus();
}, [isOpen]);
```

### Checklist automatique
- `eslint-plugin-jsx-a11y` activé
- Tests avec `@testing-library/jest-dom` matchers a11y
- Audit avec axe-core en CI

---

## Anti-patterns globaux à éviter

| Anti-pattern | Problème | Solution |
|--------------|----------|----------|
| `any` | Perte de type safety | `unknown` + narrowing |
| Index as key | Re-renders incorrects | ID stable |
| useEffect pour dérivation | Complexité inutile | Calcul direct |
| Props drilling > 2 | Couplage fort | Context ou composition |
| Mutations directes | Bugs subtils | Immutabilité (spread, map) |
| `// @ts-ignore` | Cache les erreurs | Fixer le type |
| console.log en prod | Fuite d'info | Logger conditionnel |
| Fetch dans useEffect sans cleanup | Memory leaks | AbortController |

---

## Checklist avant PR

- [ ] Pas de `any` ni `@ts-ignore`
- [ ] Tous les composants ont des props typées
- [ ] Error boundaries en place
- [ ] Tests couvrent les user journeys
- [ ] Labels et ARIA attributes corrects
- [ ] Pas de useEffect pour état dérivé
- [ ] Keys stables (pas d'index)
- [ ] Cleanup dans tous les useEffect avec subscriptions
