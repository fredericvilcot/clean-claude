# Rust — Craft Defaults

Ces guidelines sont injectées automatiquement aux agents travaillant sur un projet Rust.

---

## Philosophy

Rust enforce la qualité par design. Embrasser ses contraintes.

- **Ownership** — Clarté sur qui possède quoi
- **Explicit errors** — `Result<T, E>` partout
- **No runtime cost** — Zero-cost abstractions
- **Fearless concurrency** — Le compilateur vérifie

---

## Error Handling

### Pattern fondamental

```rust
// ✅ Custom error type avec thiserror
use thiserror::Error;

#[derive(Error, Debug)]
pub enum UserError {
    #[error("user {0} not found")]
    NotFound(UserId),

    #[error("email {0} already exists")]
    EmailExists(String),

    #[error("validation failed: {0}")]
    Validation(String),

    #[error("database error")]
    Database(#[from] sqlx::Error),
}

// ✅ Result type alias pour le module
pub type Result<T> = std::result::Result<T, UserError>;
```

### Propagation avec `?`

```rust
// ✅ Propagation élégante
pub async fn create_user(
    repo: &dyn UserRepository,
    input: CreateUserInput,
) -> Result<User> {
    // Validation
    input.validate()?;

    // Check existence
    if repo.find_by_email(&input.email).await?.is_some() {
        return Err(UserError::EmailExists(input.email));
    }

    // Create
    let user = User::new(input.email, input.name);
    repo.save(&user).await?;

    Ok(user)
}
```

### Anti-patterns

```rust
// ❌ JAMAIS
let user = repo.find_by_id(id).unwrap();  // Panic en prod
let _ = do_something();                    // Erreur ignorée
panic!("something went wrong");            // Crash explicite

// ✅ TOUJOURS
let user = repo.find_by_id(id)?;
let user = repo.find_by_id(id)
    .map_err(|e| UserError::Database(e))?;
```

### Option vs Result

```rust
// ✅ Option pour absence normale
fn find_by_id(&self, id: &UserId) -> Option<User>;

// ✅ Result pour opérations faillibles
async fn save(&self, user: &User) -> Result<(), DbError>;

// ✅ Combinaison
pub async fn get_user(repo: &dyn UserRepository, id: UserId) -> Result<User> {
    repo.find_by_id(&id)
        .await?
        .ok_or(UserError::NotFound(id))
}
```

---

## Types — Newtype Pattern

### IDs typés

```rust
// ✅ Newtype pour type safety
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct UserId(String);

impl UserId {
    pub fn new(id: impl Into<String>) -> Self {
        Self(id.into())
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}

// ✅ Impossible de confondre
fn get_user(id: UserId) -> Result<User>;
fn get_order(id: OrderId) -> Result<Order>;

get_user(order_id); // ❌ Compile error!
```

### Value Objects

```rust
// ✅ Email validé à la construction
#[derive(Debug, Clone)]
pub struct Email(String);

impl Email {
    pub fn new(value: impl Into<String>) -> Result<Self, ValidationError> {
        let value = value.into();
        if !value.contains('@') || value.len() > 255 {
            return Err(ValidationError::InvalidEmail);
        }
        Ok(Self(value))
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}

// ✅ Usage — l'Email est toujours valide
pub struct User {
    pub id: UserId,
    pub email: Email,  // Garanti valide
    pub name: String,
}
```

### Builder Pattern

```rust
// ✅ Builder pour construction complexe
#[derive(Default)]
pub struct UserBuilder {
    email: Option<Email>,
    name: Option<String>,
    role: Option<Role>,
}

impl UserBuilder {
    pub fn email(mut self, email: Email) -> Self {
        self.email = Some(email);
        self
    }

    pub fn name(mut self, name: impl Into<String>) -> Self {
        self.name = Some(name.into());
        self
    }

    pub fn build(self) -> Result<User, BuildError> {
        Ok(User {
            id: UserId::new(Uuid::new_v4().to_string()),
            email: self.email.ok_or(BuildError::MissingEmail)?,
            name: self.name.ok_or(BuildError::MissingName)?,
            role: self.role.unwrap_or(Role::User),
        })
    }
}
```

---

## Architecture

### Structure projet

```
myservice/
├── src/
│   ├── main.rs               # Entry point
│   ├── lib.rs                # Library root
│   ├── domain/
│   │   ├── mod.rs
│   │   ├── user.rs           # Entity
│   │   ├── email.rs          # Value object
│   │   └── error.rs          # Domain errors
│   ├── application/
│   │   ├── mod.rs
│   │   ├── ports.rs          # Traits (interfaces)
│   │   └── create_user.rs    # Use case
│   ├── infrastructure/
│   │   ├── mod.rs
│   │   ├── postgres/
│   │   │   └── user_repo.rs
│   │   └── http/
│   │       ├── mod.rs
│   │       └── handlers.rs
│   └── config.rs
├── tests/
│   └── integration/
├── Cargo.toml
└── Cargo.lock
```

### Traits pour abstraction

```rust
// ✅ Trait défini dans application/
#[async_trait]
pub trait UserRepository: Send + Sync {
    async fn find_by_id(&self, id: &UserId) -> Result<Option<User>>;
    async fn find_by_email(&self, email: &Email) -> Result<Option<User>>;
    async fn save(&self, user: &User) -> Result<()>;
}

// ✅ Use case dépend du trait
pub struct CreateUser<R: UserRepository> {
    repo: R,
}

impl<R: UserRepository> CreateUser<R> {
    pub fn new(repo: R) -> Self {
        Self { repo }
    }

    pub async fn execute(&self, input: CreateUserInput) -> Result<User> {
        // ...
    }
}
```

### Dependency Injection

```rust
// ✅ Composition dans main
#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let config = Config::from_env()?;

    // Infrastructure
    let pool = PgPool::connect(&config.database_url).await?;
    let user_repo = PostgresUserRepository::new(pool);

    // Use cases
    let create_user = CreateUser::new(user_repo.clone());

    // App state
    let state = AppState {
        create_user: Arc::new(create_user),
    };

    // Router
    let app = Router::new()
        .route("/users", post(handlers::create_user))
        .with_state(state);

    axum::Server::bind(&config.addr)
        .serve(app.into_make_service())
        .await?;

    Ok(())
}
```

---

## HTTP avec Axum

### Handler pattern

```rust
// ✅ Handler clean avec extractors
pub async fn create_user(
    State(state): State<AppState>,
    Json(input): Json<CreateUserRequest>,
) -> Result<Json<UserResponse>, AppError> {
    let user = state.create_user.execute(input.into()).await?;
    Ok(Json(user.into()))
}

// ✅ Error type pour HTTP
pub struct AppError(anyhow::Error);

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let (status, message) = match self.0.downcast_ref::<UserError>() {
            Some(UserError::NotFound(_)) => (StatusCode::NOT_FOUND, "User not found"),
            Some(UserError::EmailExists(_)) => (StatusCode::CONFLICT, "Email exists"),
            Some(UserError::Validation(msg)) => (StatusCode::BAD_REQUEST, msg.as_str()),
            _ => (StatusCode::INTERNAL_SERVER_ERROR, "Internal error"),
        };

        (status, Json(json!({ "error": message }))).into_response()
    }
}

impl<E: Into<anyhow::Error>> From<E> for AppError {
    fn from(err: E) -> Self {
        Self(err.into())
    }
}
```

### Validation avec serde

```rust
// ✅ Validation à la désérialisation
#[derive(Debug, Deserialize)]
pub struct CreateUserRequest {
    #[serde(deserialize_with = "deserialize_email")]
    pub email: Email,

    #[serde(deserialize_with = "deserialize_non_empty")]
    pub name: String,
}

fn deserialize_email<'de, D>(deserializer: D) -> Result<Email, D::Error>
where
    D: Deserializer<'de>,
{
    let s = String::deserialize(deserializer)?;
    Email::new(s).map_err(serde::de::Error::custom)
}
```

---

## Testing

### Unit tests

```rust
// ✅ Tests dans le même fichier
#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn create_user_success() {
        let repo = MockUserRepository::new();
        repo.expect_find_by_email()
            .returning(|_| Ok(None));
        repo.expect_save()
            .returning(|_| Ok(()));

        let use_case = CreateUser::new(repo);
        let input = CreateUserInput {
            email: Email::new("test@example.com").unwrap(),
            name: "Test".to_string(),
        };

        let result = use_case.execute(input).await;
        assert!(result.is_ok());
    }

    #[tokio::test]
    async fn create_user_email_exists() {
        let repo = MockUserRepository::new();
        repo.expect_find_by_email()
            .returning(|_| Ok(Some(User::default())));

        let use_case = CreateUser::new(repo);
        let result = use_case.execute(valid_input()).await;

        assert!(matches!(result, Err(UserError::EmailExists(_))));
    }
}
```

### Integration tests

```rust
// tests/integration/user_api.rs
use sqlx::PgPool;

#[sqlx::test]
async fn test_create_user_api(pool: PgPool) {
    let app = create_test_app(pool).await;

    let response = app
        .post("/users")
        .json(&json!({
            "email": "test@example.com",
            "name": "Test User"
        }))
        .await;

    assert_eq!(response.status(), StatusCode::CREATED);

    let body: UserResponse = response.json().await;
    assert_eq!(body.email, "test@example.com");
}
```

### Property-based testing

```rust
// ✅ Avec proptest pour edge cases
use proptest::prelude::*;

proptest! {
    #[test]
    fn email_validation_never_panics(s in "\\PC*") {
        let _ = Email::new(s); // Should never panic
    }

    #[test]
    fn valid_email_roundtrips(email in "[a-z]+@[a-z]+\\.[a-z]+") {
        let parsed = Email::new(&email).unwrap();
        assert_eq!(parsed.as_str(), email);
    }
}
```

---

## Async & Concurrency

### Tokio patterns

```rust
// ✅ Concurrent fetch avec join
async fn fetch_user_with_orders(
    user_repo: &dyn UserRepository,
    order_repo: &dyn OrderRepository,
    user_id: &UserId,
) -> Result<(User, Vec<Order>)> {
    let (user, orders) = tokio::try_join!(
        user_repo.find_by_id(user_id),
        order_repo.find_by_user(user_id),
    )?;

    let user = user.ok_or(UserError::NotFound(user_id.clone()))?;
    Ok((user, orders))
}

// ✅ Spawn pour background work
tokio::spawn(async move {
    if let Err(e) = send_welcome_email(&user.email).await {
        tracing::error!(?e, "Failed to send welcome email");
    }
});
```

### Shared state

```rust
// ✅ Arc pour partage read-only
let config = Arc::new(Config::from_env()?);

// ✅ Arc<RwLock> pour mutation
let cache: Arc<RwLock<HashMap<UserId, User>>> = Arc::new(RwLock::new(HashMap::new()));

// Read
let user = cache.read().await.get(&id).cloned();

// Write
cache.write().await.insert(id, user);
```

---

## Logging avec tracing

```rust
// ✅ Structured logging
use tracing::{info, error, instrument};

#[instrument(skip(repo))]
pub async fn create_user(
    repo: &dyn UserRepository,
    input: CreateUserInput,
) -> Result<User> {
    info!(email = %input.email, "Creating user");

    let user = User::new(input.email, input.name);
    repo.save(&user).await?;

    info!(user_id = %user.id, "User created");
    Ok(user)
}

// ✅ Setup dans main
tracing_subscriber::fmt()
    .with_env_filter(EnvFilter::from_default_env())
    .json()
    .init();
```

---

## Clippy & Formatting

```toml
# Cargo.toml
[lints.rust]
unsafe_code = "forbid"

[lints.clippy]
unwrap_used = "deny"
expect_used = "deny"
panic = "deny"
todo = "warn"
```

```bash
# CI obligatoire
cargo fmt --check
cargo clippy -- -D warnings
cargo test
```

---

## Anti-patterns globaux

| Anti-pattern | Problème | Solution |
|--------------|----------|----------|
| `.unwrap()` | Panic en prod | `?` ou `ok_or()` |
| `.expect()` | Panic explicite | Handle l'erreur |
| `panic!()` | Crash | Return `Result` |
| `clone()` partout | Performance | Références, `Arc` |
| `String` pour tout | Pas de validation | Newtypes |
| `pub` partout | Encapsulation cassée | Visibilité minimale |
| `unsafe` sans raison | Risques | Garder safe |

---

## Checklist avant PR

- [ ] Pas de `unwrap()`, `expect()`, `panic!()` en code applicatif
- [ ] Tous les types d'erreur sont définis et documentés
- [ ] Newtypes pour IDs et value objects validés
- [ ] Traits pour l'abstraction, pas de dépendances concrètes
- [ ] Tests unitaires pour la logique métier
- [ ] Tests d'intégration pour l'API
- [ ] `cargo fmt` et `cargo clippy` passent
- [ ] Documentation sur les types publics
