# CLAUDE.md
## Universal Development Standards for Flutter + FastAPI + PostgreSQL
## Version: 1.0 | Stack: Flutter + FastAPI + PostgreSQL
## Reusable across ALL projects

---

# SECTION 1: MANDATORY PRE-GENERATION PROTOCOL

## Before Writing ANY Code, Claude MUST:

### Step 1: Read Project Context
```bash
# Read what to build
view WBS.md

# Read what already exists
view CODE_REGISTRY.md
```

### Step 2: Identify Integration Points

Before generating, answer these questions:
1. What existing files does this new code depend on?
2. What existing files will use this new code?
3. What shared utilities should I use (not recreate)?
4. What interface/contract must this implement?

### Step 3: Read Relevant Existing Files
```bash
# Read files this code depends on
view [dependency_path]

# Read similar existing implementation for patterns
view [similar_file_path]
```

### Step 4: State Your Plan

Before writing code, output:
```
GENERATING: [file_name]
LOCATION: [exact_path]
IMPLEMENTS: [interface if any]
DEPENDS ON: [list of dependencies]
PATTERN SOURCE: [file I'm copying pattern from]
```

---

# SECTION 2: PROJECT STRUCTURE

## 2.1 Monorepo Structure

```
project_name/
├── .github/
│   └── workflows/
│       ├── flutter_build.yml      # Mobile CI/CD
│       └── backend_deploy.yml     # Backend CI/CD
├── mobile/                        # Flutter app
│   ├── android/
│   ├── ios/
│   ├── lib/
│   ├── test/
│   ├── pubspec.yaml
│   └── analysis_options.yaml
├── backend/                       # FastAPI backend
│   ├── app/
│   ├── tests/
│   ├── alembic/
│   ├── requirements.txt
│   ├── .env.example
│   └── main.py
├── scripts/                       # Deployment & utility scripts
│   ├── deploy_backend.sh
│   ├── setup_vps.sh
│   └── backup_db.sh
├── docs/                          # Documentation
├── CLAUDE.md                      # THIS FILE
├── CODE_REGISTRY.md               # Claude maintains
├── DEPLOYMENT.md                  # Deployment guide
└── WBS.md                         # Project requirements
```

## 2.2 Flutter App Structure (mobile/lib/)

```
lib/
├── main.dart                      # App entry point
├── app.dart                       # MaterialApp configuration
├── core/                          # Shared core utilities
│   ├── config/
│   │   ├── env_config.dart        # Environment configuration
│   │   └── app_config.dart        # App constants
│   ├── constants/
│   │   ├── api_constants.dart     # API endpoints
│   │   ├── app_constants.dart     # App-wide constants
│   │   └── storage_keys.dart      # Storage key constants
│   ├── errors/
│   │   ├── exceptions.dart        # Custom exceptions
│   │   └── failures.dart          # Failure classes
│   ├── network/
│   │   ├── api_client.dart        # Dio HTTP client
│   │   ├── api_client.g.dart      # Generated
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       └── error_interceptor.dart
│   ├── router/
│   │   ├── app_router.dart        # GoRouter configuration
│   │   └── routes.dart            # Route definitions
│   ├── storage/
│   │   ├── secure_storage.dart    # Token storage
│   │   └── local_storage.dart     # Preferences
│   ├── theme/
│   │   ├── app_theme.dart         # Theme data
│   │   ├── app_colors.dart        # Color definitions
│   │   └── app_typography.dart    # Text styles
│   ├── types/
│   │   ├── result.dart            # Result<T> type
│   │   └── result.freezed.dart    # Generated
│   ├── utils/
│   │   ├── validators.dart        # Input validation
│   │   ├── formatters.dart        # Data formatting
│   │   └── extensions.dart        # Dart extensions
│   └── widgets/                   # Core reusable widgets
│       ├── buttons/
│       ├── inputs/
│       ├── dialogs/
│       └── loading/
├── shared/                        # Shared across features
│   ├── providers/
│   │   ├── shared_providers.dart  # App-wide providers
│   │   └── connectivity_provider.dart
│   ├── widgets/
│   │   └── [shared widgets]
│   └── services/
│       └── [shared services]
├── features/                      # Feature modules
│   └── [feature_name]/
│       ├── data/
│       │   ├── models/
│       │   │   ├── [name]_model.dart
│       │   │   └── [name]_model.g.dart
│       │   ├── datasources/
│       │   │   ├── [name]_remote_datasource.dart
│       │   │   └── [name]_local_datasource.dart
│       │   └── repositories/
│       │       └── [name]_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── [name].dart
│       │   │   └── [name].freezed.dart
│       │   └── repositories/
│       │       └── [name]_repository.dart
│       └── presentation/
│           ├── providers/
│           │   ├── [name]_provider.dart
│           │   └── [name]_provider.g.dart
│           ├── screens/
│           │   └── [name]_screen.dart
│           └── widgets/
│               └── [name]_widget.dart
└── l10n/                          # Localization
    ├── app_en.arb
    └── app_hi.arb
```

## 2.3 FastAPI Backend Structure (backend/app/)

```
app/
├── __init__.py
├── main.py                        # FastAPI app entry
├── core/
│   ├── __init__.py
│   ├── config.py                  # Settings from env
│   ├── security.py                # JWT, password hashing
│   ├── database.py                # SQLAlchemy setup
│   └── dependencies.py            # FastAPI dependencies
├── api/
│   ├── __init__.py
│   └── v1/
│       ├── __init__.py
│       ├── router.py              # Main API router
│       └── endpoints/
│           ├── __init__.py
│           ├── auth.py
│           ├── users.py
│           └── [feature].py
├── models/                        # SQLAlchemy models
│   ├── __init__.py
│   ├── base.py                    # Base model class
│   ├── user.py
│   └── [feature].py
├── schemas/                       # Pydantic schemas
│   ├── __init__.py
│   ├── base.py                    # Base schemas
│   ├── auth.py
│   ├── user.py
│   └── [feature].py
├── repositories/                  # Data access layer
│   ├── __init__.py
│   ├── base.py                    # Base repository
│   ├── user.py
│   └── [feature].py
├── services/                      # Business logic
│   ├── __init__.py
│   ├── auth.py
│   ├── user.py
│   └── [feature].py
├── utils/
│   ├── __init__.py
│   └── helpers.py
└── middleware/
    ├── __init__.py
    └── logging.py
```

---

# SECTION 3: NAMING CONVENTIONS

## 3.1 File Naming

| Type | Convention | Example |
|------|------------|---------|
| Dart files | snake_case | `user_repository.dart` |
| Python files | snake_case | `user_repository.py` |
| Test files | `*_test.dart` / `test_*.py` | `user_repository_test.dart` |
| Generated files | `*.g.dart` / `*.freezed.dart` | `user.g.dart` |

## 3.2 Class/Function Naming

| Language | Element | Convention | Example |
|----------|---------|------------|---------|
| Dart | Classes | PascalCase | `UserRepository` |
| Dart | Functions | camelCase | `getUserById` |
| Dart | Variables | camelCase | `userId` |
| Dart | Constants | camelCase | `defaultTimeout` |
| Dart | Providers | camelCase + Provider | `userProvider` |
| Python | Classes | PascalCase | `UserRepository` |
| Python | Functions | snake_case | `get_user_by_id` |
| Python | Variables | snake_case | `user_id` |
| Python | Constants | SCREAMING_SNAKE | `DEFAULT_TIMEOUT` |

## 3.3 Database Naming

| Element | Convention | Example |
|---------|------------|---------|
| Tables | snake_case, plural | `users`, `user_profiles` |
| Columns | snake_case | `created_at`, `user_id` |
| Primary keys | `id` | `id` |
| Foreign keys | `[table]_id` | `user_id` |
| Indexes | `ix_[table]_[column]` | `ix_users_email` |
| Constraints | `[type]_[table]_[column]` | `uq_users_email` |

---

# SECTION 4: FLUTTER PATTERNS

## 4.1 Core Types (ALWAYS USE - NEVER RECREATE)

### Result Type (lib/core/types/result.dart)
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = Failure_<T>;
}

@freezed
class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;
  
  const factory Failure.network({
    String? message,
  }) = NetworkFailure;
  
  const factory Failure.cache({
    required String message,
  }) = CacheFailure;
  
  const factory Failure.validation({
    required String message,
    Map<String, String>? errors,
  }) = ValidationFailure;
  
  const factory Failure.unauthorized({
    String? message,
  }) = UnauthorizedFailure;
  
  const factory Failure.notFound({
    required String message,
  }) = NotFoundFailure;
}
```

## 4.2 Entity Pattern (Freezed)

```dart
// lib/features/user/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String fullName,
    String? avatarUrl,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

## 4.3 Repository Interface Pattern

```dart
// lib/features/user/domain/repositories/user_repository.dart
import '../entities/user.dart';
import '../../../../core/types/result.dart';

abstract class UserRepository {
  Future<Result<User>> getUserById(String id);
  Future<Result<User>> getCurrentUser();
  Future<Result<User>> updateUser({
    required String id,
    String? fullName,
    String? avatarUrl,
  });
  Future<Result<void>> deleteUser(String id);
}
```

## 4.4 Repository Implementation Pattern

```dart
// lib/features/user/data/repositories/user_repository_impl.dart
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../../../core/types/result.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<User>> getUserById(String id) async {
    try {
      final user = await _remoteDataSource.getUserById(id);
      return Result.success(user);
    } on ServerException catch (e) {
      return Result.failure(Failure.server(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Result.failure(Failure.network(message: e.message));
    } on UnauthorizedException {
      return Result.failure(const Failure.unauthorized());
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  // ... other methods follow same pattern
}
```

## 4.5 Remote DataSource Pattern

```dart
// lib/features/user/data/datasources/user_remote_datasource.dart
import '../models/user_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<UserModel> getUserById(String id) async {
    final response = await _apiClient.get('${ApiConstants.users}/$id');
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiConstants.currentUser);
    return UserModel.fromJson(response.data);
  }

  // ... other methods
}
```

## 4.6 Provider Pattern (Riverpod)

```dart
// lib/features/user/presentation/providers/user_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/providers/shared_providers.dart';

part 'user_provider.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepositoryImpl(
    remoteDataSource: UserRemoteDataSource(apiClient: apiClient),
  );
}

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<User?> build() async {
    return _fetchCurrentUser();
  }

  Future<User?> _fetchCurrentUser() async {
    final repository = ref.read(userRepositoryProvider);
    final result = await repository.getCurrentUser();
    
    return result.when(
      success: (user) => user,
      failure: (failure) => null,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchCurrentUser());
  }
}
```

## 4.7 Screen Pattern

```dart
// lib/features/user/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../widgets/profile_header.dart';
import '../../../../core/widgets/loading/loading_indicator.dart';
import '../../../../core/widgets/errors/error_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userAsync.when(
        data: (user) => user != null
            ? ProfileContent(user: user)
            : const ErrorView(message: 'User not found'),
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorView(message: error.toString()),
      ),
    );
  }
}
```

---

# SECTION 5: FASTAPI PATTERNS

## 5.1 Database Configuration

```python
# app/core/database.py
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase
from app.core.config import settings

engine = create_async_engine(
    settings.DATABASE_URL,
    echo=settings.DEBUG,
    pool_pre_ping=True,
    pool_size=10,
    max_overflow=20,
)

AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
)

class Base(DeclarativeBase):
    pass

async def get_db() -> AsyncSession:
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()
```

## 5.2 Model Pattern

```python
# app/models/user.py
from datetime import datetime
from sqlalchemy import String, DateTime, Boolean
from sqlalchemy.orm import Mapped, mapped_column
from app.models.base import Base, TimestampMixin

class User(Base, TimestampMixin):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    hashed_password: Mapped[str] = mapped_column(String(255))
    full_name: Mapped[str] = mapped_column(String(255))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    is_superuser: Mapped[bool] = mapped_column(Boolean, default=False)
```

## 5.3 Schema Pattern

```python
# app/schemas/user.py
from datetime import datetime
from pydantic import BaseModel, EmailStr, ConfigDict

class UserBase(BaseModel):
    email: EmailStr
    full_name: str

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    full_name: str | None = None
    password: str | None = None

class UserResponse(UserBase):
    id: int
    is_active: bool
    created_at: datetime
    updated_at: datetime | None

    model_config = ConfigDict(from_attributes=True)
```

## 5.4 Repository Pattern

```python
# app/repositories/user.py
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.user import User
from app.repositories.base import BaseRepository

class UserRepository(BaseRepository[User]):
    def __init__(self, session: AsyncSession):
        super().__init__(User, session)

    async def get_by_email(self, email: str) -> User | None:
        stmt = select(User).where(User.email == email)
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def get_active_users(self, skip: int = 0, limit: int = 100) -> list[User]:
        stmt = select(User).where(User.is_active == True).offset(skip).limit(limit)
        result = await self.session.execute(stmt)
        return list(result.scalars().all())
```

## 5.5 Service Pattern

```python
# app/services/user.py
from sqlalchemy.ext.asyncio import AsyncSession
from app.repositories.user import UserRepository
from app.schemas.user import UserCreate, UserUpdate
from app.models.user import User
from app.core.security import get_password_hash, verify_password
from app.core.exceptions import NotFoundError, ConflictError

class UserService:
    def __init__(self, session: AsyncSession):
        self.repository = UserRepository(session)

    async def get_user(self, user_id: int) -> User:
        user = await self.repository.get(user_id)
        if not user:
            raise NotFoundError(f"User {user_id} not found")
        return user

    async def get_user_by_email(self, email: str) -> User | None:
        return await self.repository.get_by_email(email)

    async def create_user(self, data: UserCreate) -> User:
        existing = await self.repository.get_by_email(data.email)
        if existing:
            raise ConflictError(f"Email {data.email} already registered")
        
        user = User(
            email=data.email,
            full_name=data.full_name,
            hashed_password=get_password_hash(data.password),
        )
        return await self.repository.create(user)

    async def update_user(self, user_id: int, data: UserUpdate) -> User:
        user = await self.get_user(user_id)
        
        if data.full_name is not None:
            user.full_name = data.full_name
        if data.password is not None:
            user.hashed_password = get_password_hash(data.password)
        
        return await self.repository.update(user)

    async def authenticate(self, email: str, password: str) -> User | None:
        user = await self.repository.get_by_email(email)
        if not user or not verify_password(password, user.hashed_password):
            return None
        return user
```

## 5.6 Endpoint Pattern

```python
# app/api/v1/endpoints/users.py
from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.database import get_db
from app.core.dependencies import get_current_user, get_current_superuser
from app.services.user import UserService
from app.schemas.user import UserCreate, UserUpdate, UserResponse
from app.models.user import User
from app.core.exceptions import NotFoundError, ConflictError

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/me", response_model=UserResponse)
async def get_current_user_info(
    current_user: Annotated[User, Depends(get_current_user)],
):
    return current_user

@router.get("/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: int,
    db: Annotated[AsyncSession, Depends(get_db)],
    _: Annotated[User, Depends(get_current_user)],
):
    service = UserService(db)
    try:
        return await service.get_user(user_id)
    except NotFoundError as e:
        raise HTTPException(status_code=404, detail=str(e))

@router.put("/me", response_model=UserResponse)
async def update_current_user(
    data: UserUpdate,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    service = UserService(db)
    return await service.update_user(current_user.id, data)
```

---

# SECTION 6: API RESPONSE FORMAT

## 6.1 Standard Response

All API responses follow this structure:

**Success Response:**
```json
{
  "success": true,
  "data": { ... },
  "message": null
}
```

**Error Response:**
```json
{
  "success": false,
  "data": null,
  "message": "Error description",
  "errors": { "field": "error message" }
}
```

**Paginated Response:**
```json
{
  "success": true,
  "data": {
    "items": [ ... ],
    "total": 100,
    "page": 1,
    "size": 20,
    "pages": 5
  }
}
```

---

# SECTION 7: SHARED UTILITIES REGISTRY

## 7.1 Flutter Utilities (NEVER RECREATE)

| Utility | Path | Purpose |
|---------|------|---------|
| Result<T> | `core/types/result.dart` | Async operation results |
| Failure | `core/types/result.dart` | Error types |
| ApiClient | `core/network/api_client.dart` | HTTP requests |
| SecureStorage | `core/storage/secure_storage.dart` | Token storage |
| LocalStorage | `core/storage/local_storage.dart` | Preferences |
| Validators | `core/utils/validators.dart` | Input validation |
| AppRouter | `core/router/app_router.dart` | Navigation |

## 7.2 Python Utilities (NEVER RECREATE)

| Utility | Path | Purpose |
|---------|------|---------|
| Base model | `models/base.py` | SQLAlchemy base |
| BaseRepository | `repositories/base.py` | Generic CRUD |
| Security | `core/security.py` | JWT, hashing |
| Dependencies | `core/dependencies.py` | FastAPI deps |
| Exceptions | `core/exceptions.py` | Custom errors |

---

# SECTION 8: DEPENDENCIES

## 8.1 Flutter Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  
  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  # Networking
  dio: ^5.4.3+1
  retrofit: ^4.1.0
  
  # Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.3
  
  # Navigation
  go_router: ^14.2.0
  
  # UI
  flutter_screenutil: ^5.9.0
  cached_network_image: ^3.3.1
  
  # Utils
  intl: ^0.19.0
  logger: ^2.2.0
  connectivity_plus: ^6.0.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  
  # Code Generation
  build_runner: ^2.4.9
  freezed: ^2.5.2
  json_serializable: ^6.7.1
  riverpod_generator: ^2.4.0
  retrofit_generator: ^8.1.0
  
  # Testing
  mockito: ^5.4.4
  build_resolving: ^2.4.2
```

## 8.2 Python Dependencies (requirements.txt)

```
# Core
fastapi==0.111.0
uvicorn[standard]==0.30.1
pydantic==2.7.4
pydantic-settings==2.3.3

# Database
sqlalchemy[asyncio]==2.0.30
asyncpg==0.29.0
alembic==1.13.1

# Security
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.9

# Utils
python-dotenv==1.0.1
httpx==0.27.0
email-validator==2.1.1

# Logging
structlog==24.2.0

# Testing
pytest==8.2.2
pytest-asyncio==0.23.7
pytest-cov==5.0.0
```

---

# SECTION 9: ENVIRONMENT CONFIGURATION

## 9.1 Backend Environment (.env)

```bash
# App
APP_NAME=ProjectName
DEBUG=false
ENVIRONMENT=production

# Database
DATABASE_URL=postgresql+asyncpg://user:password@localhost:5432/dbname

# Security
SECRET_KEY=your-secret-key-min-32-chars-long
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# CORS
CORS_ORIGINS=["https://yourdomain.com"]

# Email (optional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email
SMTP_PASSWORD=your-app-password
```

## 9.2 Flutter Environment

Create `lib/core/config/env_config.dart`:
```dart
class EnvConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.yourdomain.com',
  );
  
  static const bool isProduction = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'production',
  ) == 'production';
}
```

Build with environment:
```bash
flutter build apk --dart-define=API_BASE_URL=https://api.yourdomain.com
```

---

# SECTION 10: POST-GENERATION PROTOCOL

## After Creating ANY File, Claude MUST:

### Step 1: Update CODE_REGISTRY.md

```bash
# Read current registry
view CODE_REGISTRY.md

# Add new entry using str_replace
```

Add entry format:
```markdown
### [path/to/file.dart]
- **Status:** ✅ Implemented
- **Exports:** `ClassName`, `methodName()`
- **Implements:** `InterfaceName` (if applicable)
- **Depends On:** `File1`, `File2`
```

### Step 2: Run Code Generation (if Freezed/Riverpod)

```bash
cd mobile && dart run build_runner build --delete-conflicting-outputs
```

### Step 3: Verify

```bash
# Flutter
cd mobile && flutter analyze

# Python
cd backend && python -m py_compile app/path/to/file.py
```

### Step 4: Report

```
✅ Generated: [file_path]
✅ Registry updated
✅ Build passed
```

---

# SECTION 11: FORBIDDEN ACTIONS

## NEVER DO:

1. ❌ Generate without reading CODE_REGISTRY.md first
2. ❌ Create duplicate utilities (check registry)
3. ❌ Use different error handling patterns
4. ❌ Hardcode API URLs, secrets, credentials
5. ❌ Skip registry update after generation
6. ❌ Use different naming conventions
7. ❌ Create files outside defined structure
8. ❌ Use print() for logging (use logger)
9. ❌ Store tokens in plain SharedPreferences
10. ❌ Skip input validation

## ALWAYS DO:

1. ✅ Read CODE_REGISTRY.md first
2. ✅ Read relevant existing files before generating
3. ✅ Follow established patterns exactly
4. ✅ Update registry after generation
5. ✅ Use existing shared utilities
6. ✅ Use environment variables for config
7. ✅ Add proper error handling
8. ✅ Follow naming conventions
9. ✅ Run code generation when needed
10. ✅ Verify code compiles/analyzes

---

# SECTION 12: QUICK COMMANDS

## Flutter

```bash
# Create new project
flutter create --org com.yourcompany project_name

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs

# Analyze
flutter analyze

# Test
flutter test

# Build Android
flutter build apk --release

# Build iOS
flutter build ios --release
```

## Python/FastAPI

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
.\venv\Scripts\activate   # Windows

# Install dependencies
pip install -r requirements.txt

# Run dev server
uvicorn app.main:app --reload

# Run migrations
alembic upgrade head

# Create migration
alembic revision --autogenerate -m "description"

# Run tests
pytest
```

---

# SECTION 13: PROMPT-BASED DEVELOPMENT WORKFLOW

## Overview

This project uses a **task-driven development approach** where tasks are defined in `scripts/tasks.json` and prompts are generated using `generate_prompt.py`. This ensures consistent, dependency-aware code generation.

## Key Files

| File | Purpose |
|------|---------|
| `scripts/tasks.json` | Task definitions with dependencies, exports, status |
| `generate_prompt.py` | Generates prompts for Claude from task definitions |
| `CODE_REGISTRY.md` | Tracks all generated files and their status |
| `CLAUDE.md` | Development standards (this file) |

## Task Structure (tasks.json)

Each task contains:

```json
{
  "FE-016": {
    "name": "App Card",
    "description": "Card container widget",
    "output_path": "web/lib/core/widgets/app_card.dart",
    "status": "pending",
    "platform": "web",
    "layer": "widget",
    "phase": "1",
    "depends_on": ["FE-001", "FE-004", "FE-005"],
    "exports": ["AppCard"],
    "estimated_hours": 2,
    "detailed_requirements": "Create card widget with shadow, border radius"
  }
}
```

## Prompt Generator Commands

```bash
# Get next pending task (respects dependency order)
python generate_prompt.py --next

# Generate prompt for specific task
python generate_prompt.py FE-036

# Print prompt to stdout (instead of file)
python generate_prompt.py FE-036 --print

# Save prompt to file
python generate_prompt.py FE-036 --output prompts/

# List all tasks
python generate_prompt.py --list

# List tasks by phase
python generate_prompt.py --list --phase 2

# Mark task as complete
python generate_prompt.py --complete FE-036
```

## Development Workflow

### Step 1: Get Next Task

```bash
python generate_prompt.py --next
```

Output:
```
📋 Next Task: FE-036 - Dashboard Screen
   File: web/lib/features/projects/presentation/screens/dashboard_screen.dart
   Depends on: FE-031, FE-033, FE-018

Run: python generate_prompt.py FE-036
```

### Step 2: Generate Prompt

```bash
python generate_prompt.py FE-036 --print
```

This generates a complete prompt including:
- Task details and requirements
- Tech stack and code style guidelines
- Dependency code (actual content of dependent files)
- Completion requirements
- Verification checklist

### Step 3: Execute Task

Provide the generated prompt to Claude, which will:
1. Read CODE_REGISTRY.md
2. Read dependency files
3. Generate the code following patterns
4. Update CODE_REGISTRY.md
5. Output completion report

### Step 4: Mark Complete

```bash
python generate_prompt.py --complete FE-036
```

### Step 5: Commit

```bash
git add .
git commit -m "FE-036: Dashboard Screen"
```

## Task Naming Convention

| Prefix | Platform | Example |
|--------|----------|---------|
| `BE-` | Backend (FastAPI) | `BE-001`, `BE-015` |
| `FE-` | Frontend (Flutter) | `FE-001`, `FE-043` |

## Task Status Values

| Status | Meaning |
|--------|---------|
| `pending` | Not started |
| `completed` | Done and verified |

## Dependency Resolution

The `--next` command automatically:
1. Finds all pending tasks
2. Checks if dependencies are completed
3. Returns the first task with all dependencies met

This ensures tasks are executed in the correct order.

## Generated Prompt Contents

When you run `generate_prompt.py <TASK_ID>`, the prompt includes:

1. **Task Header** - ID, name, file path, dependencies
2. **Tech Stack** - Platform-specific technologies
3. **Code Style** - Naming conventions, patterns
4. **Detailed Requirements** - What to implement
5. **Dependency Code** - Actual source code of dependencies
6. **Completion Requirements** - Registry update, commit message
7. **Verification Checklist** - What to check after generation

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    DEVELOPMENT WORKFLOW                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │ tasks.json   │───►│ generate_    │───►│   Prompt     │  │
│  │ (definitions)│    │ prompt.py    │    │   (markdown) │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│                                                 │           │
│                                                 ▼           │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │ CODE_        │◄───│   Claude     │◄───│   Human      │  │
│  │ REGISTRY.md  │    │   (generate) │    │   (review)   │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│         │                   │                              │
│         ▼                   ▼                              │
│  ┌──────────────┐    ┌──────────────┐                     │
│  │ --complete   │    │   Git        │                     │
│  │ (mark done)  │    │   Commit     │                     │
│  └──────────────┘    └──────────────┘                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Best Practices

1. **Always use `--next`** to get the correct task order
2. **Don't skip dependencies** - tasks depend on each other
3. **Mark complete immediately** after successful generation
4. **One task per commit** with format: `<TASK_ID>: <Task Name>`
5. **Review generated code** before committing
6. **Keep CODE_REGISTRY.md in sync** - Claude updates it automatically

## Adding New Tasks

To add a new task, edit `scripts/tasks.json`:

```json
{
  "FE-044": {
    "name": "New Feature Widget",
    "description": "Description of the widget",
    "output_path": "web/lib/features/xxx/presentation/widgets/new_widget.dart",
    "status": "pending",
    "platform": "web",
    "layer": "widget",
    "phase": "3",
    "depends_on": ["FE-001", "FE-016"],
    "exports": ["NewWidget"],
    "estimated_hours": 3,
    "detailed_requirements": "Detailed implementation requirements..."
  }
}
```

---

# REMEMBER

> "Read before write. Always."

> "The registry is the source of truth."

> "Consistency beats creativity."

> "If it's not in the registry, Claude doesn't know it exists."

---

# ⚠️ CRITICAL: MANDATORY COMPLETION PROTOCOL

## THIS SECTION HAS HIGHEST PRIORITY. DO NOT SKIP.

### After EVERY File Generation, Output This EXACT Format:

```
═══════════════════════════════════════════════════════════════
📁 FILE GENERATED
═══════════════════════════════════════════════════════════════
Path: [exact/file/path.dart or .py]
Status: ✅ Created
Exports: [ClassName, methodName, etc.]
Depends On: [list of imports/dependencies]
═══════════════════════════════════════════════════════════════
📝 REGISTRY UPDATE
═══════════════════════════════════════════════════════════════
Action: Added new entry to CODE_REGISTRY.md
Section: [Feature: X / Core Layer / etc.]
Entry Added: ✅
═══════════════════════════════════════════════════════════════
```

### At END of Session, Output This EXACT Format:

```
═══════════════════════════════════════════════════════════════
🏁 SESSION COMPLETION REPORT
═══════════════════════════════════════════════════════════════
Session: [Session Name/Description]
Files Generated: [count]

| # | File | Status | Registry |
|---|------|--------|----------|
| 1 | path/to/file1.dart | ✅ | ✅ |
| 2 | path/to/file2.dart | ✅ | ✅ |
| 3 | path/to/file3.py | ✅ | ✅ |

Summary:
- Total files created: [X]
- Registry entries added: [X]
- All files in registry: ✅
- Ready for git commit: ✅
═══════════════════════════════════════════════════════════════
```

### Why This Is Mandatory

1. **Git pre-commit hook will BLOCK commits if registry is out of sync**
2. **Human verifies this output before committing**
3. **Missing format = Human will ask you to provide it**
4. **This is the ONLY way to ensure 99%+ consistency**

### Session Limits

- **MAXIMUM 5-7 files per session**
- If asked to generate more, suggest breaking into multiple sessions
- Context window overflow degrades quality after 7+ files

### If You Skip This Format

The human will say: "Output the completion report"
You MUST then provide the format above.
