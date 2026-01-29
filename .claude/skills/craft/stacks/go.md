# Go — Craft Defaults

Ces guidelines sont injectées automatiquement aux agents travaillant sur un projet Go.

---

## Philosophy

Go est simple par design. Respecter cette simplicité.

- **Explicit over implicit** — Pas de magie
- **Composition over inheritance** — Interfaces, embedding
- **Errors are values** — Traiter, pas ignorer
- **Small interfaces** — 1-2 méthodes max
- **Package by feature** — Pas par type technique

---

## Error Handling

### Pattern fondamental

```go
// ✅ Erreur retournée, jamais panic pour la logique métier
func GetUser(id string) (*User, error) {
    user, err := repo.FindByID(id)
    if err != nil {
        return nil, fmt.Errorf("get user %s: %w", id, err)
    }
    if user == nil {
        return nil, ErrUserNotFound
    }
    return user, nil
}
```

### Erreurs sentinelles

```go
// ✅ Erreurs prédéfinies pour le domaine
var (
    ErrUserNotFound     = errors.New("user not found")
    ErrEmailExists      = errors.New("email already exists")
    ErrInvalidInput     = errors.New("invalid input")
)

// ✅ Vérification
if errors.Is(err, ErrUserNotFound) {
    return http.StatusNotFound
}
```

### Erreurs avec contexte

```go
// ✅ Custom error type pour plus d'info
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation error on %s: %s", e.Field, e.Message)
}

// ✅ Wrapping avec contexte
if err != nil {
    return fmt.Errorf("create user in repository: %w", err)
}
```

### Anti-patterns

```go
// ❌ JAMAIS
user, _ := repo.FindByID(id)  // Erreur ignorée
panic("something went wrong")  // Panic pour erreur prévisible
if err != nil {
    log.Println(err)          // Log sans retour
}

// ✅ TOUJOURS
user, err := repo.FindByID(id)
if err != nil {
    return nil, fmt.Errorf("find user %s: %w", id, err)
}
```

---

## Interfaces

### Principe : Accept interfaces, return structs

```go
// ✅ Interface définie par le consommateur
type UserRepository interface {
    FindByID(ctx context.Context, id string) (*User, error)
    Save(ctx context.Context, user *User) error
}

// ✅ Service accepte l'interface
type UserService struct {
    repo UserRepository
}

func NewUserService(repo UserRepository) *UserService {
    return &UserService{repo: repo}
}

// ✅ Implémentation retourne struct concrète
type PostgresUserRepo struct {
    db *sql.DB
}
```

### Interfaces petites

```go
// ✅ Interface minimale
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// ✅ Composition si besoin
type ReadWriter interface {
    Reader
    Writer
}

// ❌ Interface trop large
type UserStore interface {
    FindByID(id string) (*User, error)
    FindByEmail(email string) (*User, error)
    FindAll() ([]*User, error)
    Create(user *User) error
    Update(user *User) error
    Delete(id string) error
    // ... 10 autres méthodes
}
```

---

## Architecture

### Structure projet

```
myservice/
├── cmd/
│   └── server/
│       └── main.go           # Point d'entrée
├── internal/                  # Code privé au module
│   ├── domain/
│   │   ├── user.go           # Entity + value objects
│   │   └── errors.go         # Domain errors
│   ├── usecase/
│   │   ├── create_user.go    # Use case
│   │   └── create_user_test.go
│   ├── repository/
│   │   ├── user.go           # Interface
│   │   └── postgres/
│   │       └── user.go       # Implémentation
│   └── handler/
│       └── user.go           # HTTP handlers
├── pkg/                       # Code réutilisable externe
│   └── validator/
├── go.mod
└── go.sum
```

### Dependency Injection

```go
// ✅ Wire les dépendances dans main
func main() {
    // Config
    cfg := config.Load()

    // Infrastructure
    db, err := sql.Open("postgres", cfg.DatabaseURL)
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    // Repositories
    userRepo := postgres.NewUserRepository(db)

    // Use cases
    createUser := usecase.NewCreateUser(userRepo)

    // Handlers
    userHandler := handler.NewUserHandler(createUser)

    // Router
    router := chi.NewRouter()
    router.Post("/users", userHandler.Create)

    // Server
    log.Fatal(http.ListenAndServe(":8080", router))
}
```

---

## HTTP Handlers

### Pattern standard

```go
// ✅ Handler clean
func (h *UserHandler) Create(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context()

    // Parse input
    var input CreateUserInput
    if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
        h.respondError(w, http.StatusBadRequest, "invalid json")
        return
    }

    // Validate
    if err := input.Validate(); err != nil {
        h.respondError(w, http.StatusBadRequest, err.Error())
        return
    }

    // Execute use case
    user, err := h.createUser.Execute(ctx, input)
    if err != nil {
        h.handleError(w, err)
        return
    }

    // Respond
    h.respondJSON(w, http.StatusCreated, user)
}

// ✅ Error mapping centralisé
func (h *UserHandler) handleError(w http.ResponseWriter, err error) {
    switch {
    case errors.Is(err, domain.ErrUserNotFound):
        h.respondError(w, http.StatusNotFound, "user not found")
    case errors.Is(err, domain.ErrEmailExists):
        h.respondError(w, http.StatusConflict, "email already exists")
    default:
        log.Printf("internal error: %v", err)
        h.respondError(w, http.StatusInternalServerError, "internal error")
    }
}
```

### Response helpers

```go
// ✅ Helpers réutilisables
func respondJSON(w http.ResponseWriter, status int, data interface{}) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(status)
    json.NewEncoder(w).Encode(data)
}

func respondError(w http.ResponseWriter, status int, message string) {
    respondJSON(w, status, map[string]string{"error": message})
}
```

---

## Context

### Propagation obligatoire

```go
// ✅ Context en premier paramètre, toujours
func (r *UserRepo) FindByID(ctx context.Context, id string) (*User, error) {
    row := r.db.QueryRowContext(ctx, "SELECT * FROM users WHERE id = $1", id)
    // ...
}

// ✅ Timeout dans les handlers
func (h *UserHandler) Get(w http.ResponseWriter, r *http.Request) {
    ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
    defer cancel()

    user, err := h.userRepo.FindByID(ctx, id)
    // ...
}
```

### Anti-patterns

```go
// ❌ JAMAIS
func GetUser(id string) (*User, error) // Pas de context
context.Background() // Dans du code applicatif

// ✅ TOUJOURS
func GetUser(ctx context.Context, id string) (*User, error)
```

---

## Testing

### Table-driven tests

```go
// ✅ Pattern standard Go
func TestCreateUser(t *testing.T) {
    tests := []struct {
        name    string
        input   CreateUserInput
        setup   func(*MockUserRepo)
        wantErr error
    }{
        {
            name:  "success",
            input: CreateUserInput{Email: "test@example.com", Name: "Test"},
            setup: func(m *MockUserRepo) {
                m.On("FindByEmail", mock.Anything, "test@example.com").Return(nil, nil)
                m.On("Save", mock.Anything, mock.Anything).Return(nil)
            },
            wantErr: nil,
        },
        {
            name:  "email exists",
            input: CreateUserInput{Email: "exists@example.com", Name: "Test"},
            setup: func(m *MockUserRepo) {
                m.On("FindByEmail", mock.Anything, "exists@example.com").Return(&User{}, nil)
            },
            wantErr: ErrEmailExists,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            repo := new(MockUserRepo)
            tt.setup(repo)

            uc := NewCreateUser(repo)
            _, err := uc.Execute(context.Background(), tt.input)

            if !errors.Is(err, tt.wantErr) {
                t.Errorf("got error %v, want %v", err, tt.wantErr)
            }
        })
    }
}
```

### Test avec DB réelle (integration)

```go
// ✅ Test containers pour intégration
func TestUserRepo_Integration(t *testing.T) {
    if testing.Short() {
        t.Skip("skipping integration test")
    }

    ctx := context.Background()
    container, err := postgres.RunContainer(ctx)
    if err != nil {
        t.Fatal(err)
    }
    defer container.Terminate(ctx)

    db, err := sql.Open("postgres", container.ConnectionString())
    if err != nil {
        t.Fatal(err)
    }

    repo := NewUserRepository(db)

    // ... tests
}
```

---

## Concurrency

### Goroutines safe

```go
// ✅ Errgroup pour goroutines multiples
func FetchAll(ctx context.Context, ids []string) ([]*User, error) {
    g, ctx := errgroup.WithContext(ctx)
    users := make([]*User, len(ids))

    for i, id := range ids {
        i, id := i, id // Capture loop variables
        g.Go(func() error {
            user, err := fetchUser(ctx, id)
            if err != nil {
                return err
            }
            users[i] = user
            return nil
        })
    }

    if err := g.Wait(); err != nil {
        return nil, err
    }
    return users, nil
}
```

### Mutex pour état partagé

```go
// ✅ Mutex pour protéger l'état
type Cache struct {
    mu    sync.RWMutex
    items map[string]*User
}

func (c *Cache) Get(key string) (*User, bool) {
    c.mu.RLock()
    defer c.mu.RUnlock()
    user, ok := c.items[key]
    return user, ok
}

func (c *Cache) Set(key string, user *User) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.items[key] = user
}
```

---

## Logging

```go
// ✅ Structured logging avec slog (Go 1.21+)
import "log/slog"

logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))

logger.Info("user created",
    slog.String("user_id", user.ID),
    slog.String("email", user.Email),
)

// ✅ Context avec logger
func WithLogger(ctx context.Context, logger *slog.Logger) context.Context {
    return context.WithValue(ctx, loggerKey, logger)
}

// ❌ JAMAIS
log.Println("User created") // Pas structuré
fmt.Printf("user: %+v\n", user) // Debug en prod
```

---

## Anti-patterns globaux

| Anti-pattern | Problème | Solution |
|--------------|----------|----------|
| `_` pour ignorer erreur | Bug caché | Toujours handle |
| `panic` pour erreurs | Crash en prod | Return error |
| Interface trop large | Couplage | 1-2 méthodes |
| Global state | Tests impossibles | Injection |
| `init()` complexe | Effets cachés | Init explicite dans main |
| Channels partout | Complexité | Mutex si simple |
| `context.Background()` | Pas de cancel | Propager le context |

---

## Checklist avant PR

- [ ] Toutes les erreurs sont gérées (pas de `_`)
- [ ] Errors wrappées avec contexte (`fmt.Errorf("...: %w", err)`)
- [ ] Context propagé partout
- [ ] Interfaces définies côté consommateur
- [ ] Table-driven tests
- [ ] Pas de global state
- [ ] Goroutines avec errgroup ou sync
- [ ] Structured logging
