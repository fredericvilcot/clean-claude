# Python — Craft Defaults

Ces guidelines sont injectées automatiquement aux agents travaillant sur un projet Python.

---

## Philosophy

Python moderne = type hints + explicitness + clean architecture.

- **Type hints everywhere** — mypy strict
- **Explicit returns** — Pas de `None` implicites
- **Dataclasses** — Immutables par défaut
- **Result pattern** — Pas d'exceptions pour la logique métier

---

## Type System

### Configuration mypy stricte

```toml
# pyproject.toml
[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_ignores = true
disallow_untyped_defs = true
disallow_any_generics = true
```

### Type hints obligatoires

```python
# ✅ Fonctions typées
def get_user(user_id: str) -> User | None:
    ...

def create_user(email: str, name: str) -> Result[User, CreateUserError]:
    ...

# ✅ Variables annotées quand pas évident
users: list[User] = []
cache: dict[str, User] = {}

# ✅ Generics
T = TypeVar("T")
E = TypeVar("E", bound=Exception)

def first(items: Sequence[T]) -> T | None:
    return items[0] if items else None
```

### Anti-patterns

```python
# ❌ JAMAIS
def process(data):  # Pas de types
    return data["value"]  # Any implicite

# ✅ TOUJOURS
def process(data: UserData) -> str:
    return data.value
```

---

## Error Handling — Result Pattern

### Définition

```python
from dataclasses import dataclass
from typing import Generic, TypeVar

T = TypeVar("T")
E = TypeVar("E", bound=Exception)

@dataclass(frozen=True)
class Ok(Generic[T]):
    value: T

@dataclass(frozen=True)
class Err(Generic[E]):
    error: E

Result = Ok[T] | Err[E]

# Helpers
def ok(value: T) -> Ok[T]:
    return Ok(value)

def err(error: E) -> Err[E]:
    return Err(error)
```

### Erreurs métier typées

```python
# ✅ Erreurs explicites
@dataclass(frozen=True)
class UserNotFoundError(Exception):
    user_id: str

    def __str__(self) -> str:
        return f"User {self.user_id} not found"

@dataclass(frozen=True)
class EmailExistsError(Exception):
    email: str

    def __str__(self) -> str:
        return f"Email {self.email} already exists"

CreateUserError = EmailExistsError | ValidationError
```

### Usage

```python
# ✅ Service avec Result
async def create_user(
    repo: UserRepository,
    email: str,
    name: str,
) -> Result[User, CreateUserError]:
    # Validation
    if not is_valid_email(email):
        return err(ValidationError("Invalid email format"))

    # Check existence
    existing = await repo.find_by_email(email)
    if existing is not None:
        return err(EmailExistsError(email))

    # Create
    user = User(id=generate_id(), email=email, name=name)
    await repo.save(user)

    return ok(user)

# ✅ Consommation
result = await create_user(repo, email, name)
match result:
    case Ok(user):
        return UserResponse.from_user(user)
    case Err(EmailExistsError()):
        raise HTTPException(409, "Email already exists")
    case Err(ValidationError() as e):
        raise HTTPException(400, str(e))
```

### Anti-patterns

```python
# ❌ JAMAIS
def get_user(user_id: str) -> User:
    user = repo.find_by_id(user_id)
    if user is None:
        raise ValueError("User not found")  # Exception non typée
    return user

# ✅ TOUJOURS
def get_user(user_id: str) -> Result[User, UserNotFoundError]:
    user = repo.find_by_id(user_id)
    if user is None:
        return err(UserNotFoundError(user_id))
    return ok(user)
```

---

## Data Classes — Immutables

### Entities

```python
from dataclasses import dataclass, field
from datetime import datetime

# ✅ Immutable par défaut
@dataclass(frozen=True)
class User:
    id: str
    email: str
    name: str
    created_at: datetime = field(default_factory=datetime.utcnow)

    def with_name(self, name: str) -> "User":
        """Retourne une nouvelle instance avec le nom modifié."""
        return User(
            id=self.id,
            email=self.email,
            name=name,
            created_at=self.created_at,
        )
```

### Value Objects

```python
# ✅ Value object validé
@dataclass(frozen=True)
class Email:
    value: str

    def __post_init__(self) -> None:
        if "@" not in self.value or len(self.value) > 255:
            raise ValueError(f"Invalid email: {self.value}")

# ✅ Usage — toujours valide après construction
user = User(id="123", email=Email("test@example.com"), name="Test")
```

### DTOs avec Pydantic

```python
from pydantic import BaseModel, EmailStr, Field

# ✅ Input validation
class CreateUserRequest(BaseModel):
    email: EmailStr
    name: str = Field(min_length=1, max_length=100)

# ✅ Output serialization
class UserResponse(BaseModel):
    id: str
    email: str
    name: str

    @classmethod
    def from_user(cls, user: User) -> "UserResponse":
        return cls(id=user.id, email=user.email, name=user.name)
```

---

## Architecture

### Structure projet

```
myservice/
├── src/
│   └── myservice/
│       ├── __init__.py
│       ├── domain/
│       │   ├── __init__.py
│       │   ├── user.py          # Entity
│       │   ├── email.py         # Value object
│       │   └── errors.py        # Domain errors
│       ├── application/
│       │   ├── __init__.py
│       │   ├── ports.py         # Protocols (interfaces)
│       │   └── create_user.py   # Use case
│       ├── infrastructure/
│       │   ├── __init__.py
│       │   ├── repositories/
│       │   │   └── postgres_user_repo.py
│       │   └── http/
│       │       ├── app.py
│       │       └── handlers.py
│       └── config.py
├── tests/
│   ├── unit/
│   └── integration/
├── pyproject.toml
└── README.md
```

### Protocols pour abstraction

```python
from typing import Protocol

# ✅ Protocol défini dans application/
class UserRepository(Protocol):
    async def find_by_id(self, user_id: str) -> User | None: ...
    async def find_by_email(self, email: str) -> User | None: ...
    async def save(self, user: User) -> None: ...

# ✅ Use case dépend du Protocol
class CreateUserUseCase:
    def __init__(self, repo: UserRepository) -> None:
        self._repo = repo

    async def execute(
        self, email: str, name: str
    ) -> Result[User, CreateUserError]:
        ...
```

### Dependency Injection

```python
# ✅ Composition dans main / factory
from functools import lru_cache

@lru_cache
def get_settings() -> Settings:
    return Settings()

async def get_db_pool() -> AsyncIterator[asyncpg.Pool]:
    settings = get_settings()
    pool = await asyncpg.create_pool(settings.database_url)
    try:
        yield pool
    finally:
        await pool.close()

def create_user_repository(pool: asyncpg.Pool) -> UserRepository:
    return PostgresUserRepository(pool)

def create_user_use_case(repo: UserRepository) -> CreateUserUseCase:
    return CreateUserUseCase(repo)

# ✅ FastAPI dependency injection
@app.post("/users")
async def create_user(
    request: CreateUserRequest,
    repo: UserRepository = Depends(get_user_repository),
) -> UserResponse:
    use_case = create_user_use_case(repo)
    result = await use_case.execute(request.email, request.name)
    ...
```

---

## HTTP avec FastAPI

### Handler pattern

```python
from fastapi import FastAPI, HTTPException, Depends

app = FastAPI()

@app.post("/users", status_code=201)
async def create_user(
    request: CreateUserRequest,
    use_case: CreateUserUseCase = Depends(get_create_user_use_case),
) -> UserResponse:
    result = await use_case.execute(request.email, request.name)

    match result:
        case Ok(user):
            return UserResponse.from_user(user)
        case Err(EmailExistsError()):
            raise HTTPException(409, "Email already exists")
        case Err(ValidationError() as e):
            raise HTTPException(400, str(e))

@app.get("/users/{user_id}")
async def get_user(
    user_id: str,
    repo: UserRepository = Depends(get_user_repository),
) -> UserResponse:
    user = await repo.find_by_id(user_id)
    if user is None:
        raise HTTPException(404, "User not found")
    return UserResponse.from_user(user)
```

### Error handling global

```python
from fastapi import Request
from fastapi.responses import JSONResponse

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    # Log l'erreur
    logger.exception("Unhandled exception", exc_info=exc)

    # Ne pas exposer les détails en prod
    return JSONResponse(
        status_code=500,
        content={"error": "Internal server error"},
    )
```

---

## Testing

### Stack

- **pytest** — Test runner
- **pytest-asyncio** — Async tests
- **pytest-cov** — Coverage
- **factory_boy** — Test data factories
- **httpx** — Client HTTP async pour tests

### Unit tests

```python
import pytest
from unittest.mock import AsyncMock

@pytest.fixture
def mock_user_repo() -> AsyncMock:
    return AsyncMock(spec=UserRepository)

@pytest.mark.asyncio
async def test_create_user_success(mock_user_repo: AsyncMock) -> None:
    # Arrange
    mock_user_repo.find_by_email.return_value = None
    mock_user_repo.save.return_value = None

    use_case = CreateUserUseCase(mock_user_repo)

    # Act
    result = await use_case.execute("test@example.com", "Test")

    # Assert
    assert isinstance(result, Ok)
    assert result.value.email == "test@example.com"
    mock_user_repo.save.assert_called_once()

@pytest.mark.asyncio
async def test_create_user_email_exists(mock_user_repo: AsyncMock) -> None:
    # Arrange
    mock_user_repo.find_by_email.return_value = User(...)

    use_case = CreateUserUseCase(mock_user_repo)

    # Act
    result = await use_case.execute("exists@example.com", "Test")

    # Assert
    assert isinstance(result, Err)
    assert isinstance(result.error, EmailExistsError)
```

### Integration tests

```python
import pytest
from httpx import AsyncClient

@pytest.mark.asyncio
async def test_create_user_api(client: AsyncClient) -> None:
    response = await client.post(
        "/users",
        json={"email": "test@example.com", "name": "Test"},
    )

    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "test@example.com"

@pytest.mark.asyncio
async def test_create_user_duplicate_email(client: AsyncClient) -> None:
    # Create first user
    await client.post("/users", json={"email": "dup@example.com", "name": "First"})

    # Try duplicate
    response = await client.post(
        "/users",
        json={"email": "dup@example.com", "name": "Second"},
    )

    assert response.status_code == 409
```

### Factories

```python
import factory

class UserFactory(factory.Factory):
    class Meta:
        model = User

    id = factory.LazyFunction(lambda: str(uuid.uuid4()))
    email = factory.Sequence(lambda n: f"user{n}@example.com")
    name = factory.Faker("name")
    created_at = factory.LazyFunction(datetime.utcnow)

# Usage
user = UserFactory()
user_with_email = UserFactory(email="specific@example.com")
```

---

## Async Best Practices

```python
import asyncio

# ✅ Concurrent execution
async def fetch_user_with_orders(user_id: str) -> tuple[User, list[Order]]:
    user, orders = await asyncio.gather(
        user_repo.find_by_id(user_id),
        order_repo.find_by_user(user_id),
    )
    if user is None:
        raise UserNotFoundError(user_id)
    return user, orders

# ✅ Context manager pour resources
async with asyncpg.create_pool(database_url) as pool:
    async with pool.acquire() as conn:
        result = await conn.fetch("SELECT * FROM users")

# ✅ Timeout
async with asyncio.timeout(5.0):
    result = await slow_operation()
```

---

## Logging

```python
import structlog

# ✅ Configuration structlog
structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.JSONRenderer(),
    ],
    wrapper_class=structlog.stdlib.BoundLogger,
    context_class=dict,
    logger_factory=structlog.stdlib.LoggerFactory(),
)

logger = structlog.get_logger()

# ✅ Usage
logger.info("user_created", user_id=user.id, email=user.email)
logger.error("database_error", error=str(e), query=query)

# ❌ JAMAIS
print("User created")  # Pas structuré
logger.info(f"User {user.email} created")  # Pas de champs séparés
```

---

## Tools & Linting

```toml
# pyproject.toml

[tool.ruff]
target-version = "py311"
line-length = 88
select = [
    "E",    # pycodestyle errors
    "W",    # pycodestyle warnings
    "F",    # Pyflakes
    "I",    # isort
    "B",    # flake8-bugbear
    "C4",   # flake8-comprehensions
    "UP",   # pyupgrade
]

[tool.black]
line-length = 88
target-version = ["py311"]

[tool.isort]
profile = "black"
```

```bash
# CI obligatoire
ruff check .
black --check .
mypy .
pytest --cov
```

---

## Anti-patterns globaux

| Anti-pattern | Problème | Solution |
|--------------|----------|----------|
| Pas de type hints | Bugs runtime | mypy strict |
| `raise Exception` | Non typé | Result pattern |
| `except Exception` | Avale tout | Except spécifique |
| Mutable defaults | Bugs subtils | `field(default_factory=)` |
| `print()` | Pas structuré | structlog |
| Global state | Tests impossibles | Injection |
| `Any` partout | Perte de types | Types concrets |
| `# type: ignore` | Cache problèmes | Fixer le type |

---

## Checklist avant PR

- [ ] Type hints sur toutes les fonctions et méthodes
- [ ] mypy strict passe sans erreurs
- [ ] Erreurs métier avec Result pattern, pas d'exceptions
- [ ] Dataclasses immutables (frozen=True)
- [ ] Protocols pour les abstractions
- [ ] Tests unitaires avec pytest
- [ ] Pas de `print()`, utiliser structlog
- [ ] ruff et black passent
