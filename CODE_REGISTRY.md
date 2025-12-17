# CODE REGISTRY
## Project: [PROJECT_NAME]
## Stack: Flutter + FastAPI + PostgreSQL
## Last Updated: [DATE] by Claude

---

# INSTRUCTIONS FOR CLAUDE

1. **READ this file BEFORE generating ANY code**
2. **UPDATE this file AFTER generating ANY code**
3. **NEVER recreate utilities listed in Quick Reference**
4. **FOLLOW patterns from existing implementations**

---

# QUICK REFERENCE

## Import Patterns (Flutter)

| When you need... | Import this |
|------------------|-------------|
| Result/Failure types | `package:[app]/core/types/result.dart` |
| API Client | `package:[app]/core/network/api_client.dart` |
| Secure Storage | `package:[app]/core/storage/secure_storage.dart` |
| Local Storage | `package:[app]/core/storage/local_storage.dart` |
| Validators | `package:[app]/core/utils/validators.dart` |
| App Router | `package:[app]/core/router/app_router.dart` |
| Theme | `package:[app]/core/theme/app_theme.dart` |
| Constants | `package:[app]/core/constants/app_constants.dart` |

## Import Patterns (Python)

| When you need... | Import this |
|------------------|-------------|
| Database session | `from app.core.database import get_db` |
| Current user | `from app.core.dependencies import get_current_user` |
| Password hashing | `from app.core.security import get_password_hash, verify_password` |
| JWT | `from app.core.security import create_access_token` |
| Base model | `from app.models.base import Base, TimestampMixin` |
| Base repository | `from app.repositories.base import BaseRepository` |
| Exceptions | `from app.core.exceptions import NotFoundError, ConflictError` |

## Shared Utilities (NEVER RECREATE)

| Utility | Flutter Path | Python Path |
|---------|--------------|-------------|
| Result type | `core/types/result.dart` | N/A |
| HTTP client | `core/network/api_client.dart` | `httpx` |
| Auth storage | `core/storage/secure_storage.dart` | N/A |
| Password hash | N/A | `core/security.py` |
| JWT handling | N/A | `core/security.py` |
| Base CRUD | N/A | `repositories/base.py` |

---

# FILE REGISTRY

## Core Layer (Flutter)

### mobile/lib/core/types/result.dart
- **Status:** 📋 To Create First
- **Exports:** `Result<T>`, `Failure`, `ServerFailure`, `NetworkFailure`, `CacheFailure`, `ValidationFailure`, `UnauthorizedFailure`, `NotFoundFailure`
- **Depends On:** freezed
- **Used By:** All repositories

### mobile/lib/core/network/api_client.dart
- **Status:** 📋 To Create First
- **Exports:** `ApiClient`
- **Methods:** `get()`, `post()`, `put()`, `delete()`, `upload()`
- **Depends On:** dio
- **Used By:** All remote data sources

### mobile/lib/core/network/interceptors/auth_interceptor.dart
- **Status:** 📋 To Create First
- **Exports:** `AuthInterceptor`
- **Depends On:** dio, SecureStorage
- **Used By:** ApiClient

### mobile/lib/core/network/interceptors/error_interceptor.dart
- **Status:** 📋 To Create First
- **Exports:** `ErrorInterceptor`
- **Depends On:** dio
- **Used By:** ApiClient

### mobile/lib/core/storage/secure_storage.dart
- **Status:** 📋 To Create First
- **Exports:** `SecureStorage`
- **Methods:** `getAccessToken()`, `setAccessToken()`, `getRefreshToken()`, `setRefreshToken()`, `clearTokens()`
- **Depends On:** flutter_secure_storage
- **Used By:** AuthInterceptor, AuthService

### mobile/lib/core/storage/local_storage.dart
- **Status:** 📋 To Create First
- **Exports:** `LocalStorage`
- **Methods:** `getString()`, `setString()`, `getBool()`, `setBool()`, `remove()`, `clear()`
- **Depends On:** shared_preferences
- **Used By:** Settings, Cache

### mobile/lib/core/router/app_router.dart
- **Status:** 📋 To Create First
- **Exports:** `appRouter`, `AppRoutes`
- **Depends On:** go_router
- **Used By:** App entry point

### mobile/lib/core/theme/app_theme.dart
- **Status:** 📋 To Create First
- **Exports:** `AppTheme`, `lightTheme`, `darkTheme`
- **Depends On:** flutter
- **Used By:** MaterialApp

### mobile/lib/core/constants/api_constants.dart
- **Status:** 📋 To Create First
- **Exports:** `ApiConstants`
- **Contains:** All API endpoint paths
- **Used By:** All data sources

### mobile/lib/core/utils/validators.dart
- **Status:** 📋 To Create First
- **Exports:** `Validators`
- **Methods:** `email()`, `password()`, `phone()`, `required()`, `minLength()`, `maxLength()`
- **Used By:** All forms

---

## Core Layer (Backend)

### backend/app/core/config.py
- **Status:** ✅ Implemented
- **Exports:** `Settings`, `settings`
- **Contains:** All environment configuration (DATABASE_URL, SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES, REFRESH_TOKEN_EXPIRE_DAYS, CORS_ORIGINS, DEBUG, ENVIRONMENT, APP_NAME)
- **Depends On:** pydantic, pydantic-settings
- **Used By:** Entire backend

### backend/app/core/database.py
- **Status:** ✅ Implemented
- **Exports:** `engine`, `async_session`, `Base`, `get_db`
- **Depends On:** sqlalchemy, asyncpg
- **Used By:** All repositories
- **Methods:** `get_db()` - FastAPI dependency for database sessions

### backend/app/core/security.py
- **Status:** ✅ Implemented
- **Task:** BE-003
- **Exports:** `hash_password`, `verify_password`, `create_access_token`, `verify_token`
- **Depends On:** BE-002, passlib, python-jose
- **Used By:** AuthService, Dependencies
- **Methods:** Password hashing with bcrypt, JWT token creation and verification

### backend/app/core/dependencies.py
- **Status:** 📋 To Create First
- **Exports:** `get_current_user`, `get_current_active_user`, `get_current_superuser`
- **Depends On:** security, database
- **Used By:** All protected endpoints

### backend/app/core/exceptions.py
- **Status:** ✅ Implemented
- **Task:** BE-005
- **Exports:** `AppException`, `NotFoundException`, `UnauthorizedException`, `ValidationException`, `handlers`
- **Used By:** All services, FastAPI app
- **Description:** Custom exception classes with FastAPI handlers for consistent error responses

### backend/app/models/base.py
- **Status:** 📋 To Create First
- **Exports:** `Base`, `TimestampMixin`
- **Depends On:** sqlalchemy
- **Used By:** All models

### backend/app/repositories/base.py
- **Status:** ✅ Implemented
- **Task:** BE-004
- **Exports:** `BaseRepository[T]`
- **Methods:** `get(id)`, `get_all(skip, limit)`, `create(obj)`, `update(obj)`, `delete(id)`
- **Depends On:** BE-001, sqlalchemy
- **Used By:** All repositories
- **Description:** Generic async CRUD repository with TypeVar for model type safety

### backend/app/schemas/base.py
- **Status:** 📋 To Create First
- **Exports:** `ResponseBase`, `PaginatedResponse`
- **Used By:** All endpoint responses

---

## Feature: Auth

### Flutter Files

#### mobile/lib/features/auth/domain/entities/auth_tokens.dart
- **Status:** 📋 Pending
- **Exports:** `AuthTokens`
- **Fields:** `accessToken`, `refreshToken`, `expiresAt`

#### mobile/lib/features/auth/domain/repositories/auth_repository.dart
- **Status:** 📋 Pending
- **Exports:** `AuthRepository` (abstract)
- **Methods:** `login()`, `register()`, `logout()`, `refreshToken()`, `isAuthenticated()`

#### mobile/lib/features/auth/data/repositories/auth_repository_impl.dart
- **Status:** 📋 Pending
- **Implements:** `AuthRepository`
- **Depends On:** AuthRemoteDataSource, SecureStorage, Result

#### mobile/lib/features/auth/data/datasources/auth_remote_datasource.dart
- **Status:** 📋 Pending
- **Exports:** `AuthRemoteDataSource`
- **Depends On:** ApiClient

#### mobile/lib/features/auth/presentation/providers/auth_provider.dart
- **Status:** 📋 Pending
- **Exports:** `authProvider`, `authStateProvider`, `isAuthenticatedProvider`

#### mobile/lib/features/auth/presentation/screens/login_screen.dart
- **Status:** 📋 Pending
- **Depends On:** AuthProvider, Validators

#### mobile/lib/features/auth/presentation/screens/register_screen.dart
- **Status:** 📋 Pending
- **Depends On:** AuthProvider, Validators

### Backend Files

#### backend/app/models/user.py
- **Status:** ✅ Implemented
- **Task:** BE-006
- **Exports:** `User`
- **Fields:** `id` (UUID), `email` (String, unique, indexed), `hashed_password` (String), `full_name` (String), `is_active` (Boolean), `created_at` (DateTime), `updated_at` (DateTime)
- **Depends On:** BE-001
- **Description:** SQLAlchemy User model with UUID primary key and timestamps

#### backend/app/schemas/auth.py
- **Status:** ✅ Implemented
- **Task:** BE-007
- **Exports:** `RegisterRequest`, `LoginRequest`, `TokenResponse`, `UserResponse`
- **Description:** Pydantic schemas for authentication with validation and serialization

#### backend/app/schemas/user.py
- **Status:** 📋 Pending
- **Exports:** `UserCreate`, `UserUpdate`, `UserResponse`

#### backend/app/repositories/user.py
- **Status:** ✅ Implemented
- **Task:** BE-008
- **Exports:** `UserRepository`
- **Methods:** `get_by_email(email: str) -> Optional[User]`
- **Depends On:** BE-004, BE-006
- **Description:** User repository extending BaseRepository with email lookup

#### backend/app/services/auth.py
- **Status:** 📋 Pending
- **Exports:** `AuthService`
- **Methods:** `login()`, `register()`, `refresh_token()`

#### backend/app/api/v1/endpoints/auth.py
- **Status:** 📋 Pending
- **Endpoints:** `POST /login`, `POST /register`, `POST /refresh`, `POST /logout`

---

## Feature: User

### Flutter Files

#### mobile/lib/features/user/domain/entities/user.dart
- **Status:** 📋 Pending
- **Exports:** `User`
- **Fields:** `id`, `email`, `fullName`, `avatarUrl`, `createdAt`, `updatedAt`

#### mobile/lib/features/user/domain/repositories/user_repository.dart
- **Status:** 📋 Pending
- **Exports:** `UserRepository` (abstract)
- **Methods:** `getCurrentUser()`, `updateUser()`, `deleteAccount()`

### Backend Files

#### backend/app/services/user.py
- **Status:** 📋 Pending
- **Exports:** `UserService`

#### backend/app/api/v1/endpoints/users.py
- **Status:** 📋 Pending
- **Endpoints:** `GET /me`, `PUT /me`, `DELETE /me`

---

# DEPENDENCY GRAPH

```
┌─────────────────────────────────────────────────────────────────┐
│                      FLUTTER ARCHITECTURE                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    PRESENTATION                          │   │
│  │   Screens ──► Widgets ──► Providers                     │   │
│  └─────────────────────────────────────────────────────────┘   │
│                            │                                    │
│                            ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                      DOMAIN                              │   │
│  │   Entities ◄── Repositories (abstract)                  │   │
│  └─────────────────────────────────────────────────────────┘   │
│                            │                                    │
│                            ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                       DATA                               │   │
│  │   Models ──► DataSources ──► Repository Impl            │   │
│  └─────────────────────────────────────────────────────────┘   │
│                            │                                    │
│                            ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                       CORE                               │   │
│  │   ApiClient, Storage, Router, Theme, Utils              │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      BACKEND ARCHITECTURE                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    API LAYER                             │   │
│  │   Endpoints (routes) ──► Request/Response Schemas       │   │
│  └─────────────────────────────────────────────────────────┘   │
│                            │                                    │
│                            ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                   SERVICE LAYER                          │   │
│  │   Business Logic, Validation, Orchestration             │   │
│  └─────────────────────────────────────────────────────────┘   │
│                            │                                    │
│                            ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                 REPOSITORY LAYER                         │   │
│  │   Data Access, Queries, CRUD Operations                 │   │
│  └─────────────────────────────────────────────────────────┘   │
│                            │                                    │
│                            ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                   MODEL LAYER                            │   │
│  │   SQLAlchemy Models, Database Tables                    │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# PATTERNS REFERENCE

## Flutter Error Handling (COPY THIS)

```dart
Future<Result<T>> repositoryMethod() async {
  try {
    final data = await _remoteDataSource.fetchData();
    return Result.success(data);
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
```

## Flutter Provider (COPY THIS)

```dart
@riverpod
class FeatureNotifier extends _$FeatureNotifier {
  @override
  Future<FeatureState> build() async {
    return _loadInitialState();
  }

  Future<void> performAction() async {
    state = const AsyncLoading();
    final repository = ref.read(featureRepositoryProvider);
    final result = await repository.doSomething();
    
    state = result.when(
      success: (data) => AsyncData(data),
      failure: (failure) => AsyncError(failure, StackTrace.current),
    );
  }
}
```

## Python Service (COPY THIS)

```python
class FeatureService:
    def __init__(self, session: AsyncSession):
        self.repository = FeatureRepository(session)

    async def get_item(self, item_id: int) -> Feature:
        item = await self.repository.get(item_id)
        if not item:
            raise NotFoundError(f"Item {item_id} not found")
        return item

    async def create_item(self, data: FeatureCreate) -> Feature:
        item = Feature(**data.model_dump())
        return await self.repository.create(item)
```

## Python Endpoint (COPY THIS)

```python
@router.get("/{item_id}", response_model=FeatureResponse)
async def get_item(
    item_id: int,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    service = FeatureService(db)
    try:
        return await service.get_item(item_id)
    except NotFoundError as e:
        raise HTTPException(status_code=404, detail=str(e))
```

---

# GENERATION LOG

| Date | File | Action | Verified |
|------|------|--------|----------|
| 2025-12-17 | CODE_REGISTRY.md | Created | ✅ |
| 2025-12-17 | backend/app/core/database.py | Created | ✅ |
| 2025-12-17 | backend/app/core/config.py | Created | ✅ |
| 2025-12-17 | backend/app/core/security.py | Created | ✅ |
| 2025-12-17 | backend/app/repositories/base.py | Created | ✅ |
| 2025-12-17 | backend/app/core/exceptions.py | Created | ✅ |
| 2025-12-17 | backend/app/models/user.py | Created | ✅ |
| 2025-12-17 | backend/app/schemas/auth.py | Created | ✅ |
| 2025-12-17 | backend/app/repositories/user.py | Created | ✅ |
| 2025-12-17 | backend/app/services/auth.py | Created | ✅ |
| 2025-12-17 | backend/app/api/dependencies.py | Created | ✅ |
| 2025-12-17 | backend/app/api/v1/endpoints/auth.py | Created | ✅ |
| 2025-12-17 | backend/app/api/v1/router.py | Created | ✅ |
| 2025-12-17 | backend/app/main.py | Created | ✅ |
| 2025-12-17 | backend/alembic/env.py | Created | ✅ |
| 2025-12-17 | backend/alembic/versions/001_initial.py | Created | ✅ |
| 2025-12-17 | backend/app/models/template.py | Created | ✅ |
| 2025-12-17 | backend/app/schemas/template.py | Created | ✅ |
| 2025-12-17 | backend/app/repositories/template.py | Created | ✅ |
| 2025-12-17 | backend/app/services/template.py | Created | ✅ |
| 2025-12-17 | backend/app/api/v1/endpoints/templates.py | Created | ✅ |
| 2025-12-17 | backend/alembic/versions/002_templates.py | Created | ✅ |
| 2025-12-17 | backend/app/models/project.py | Created | ✅ |
| 2025-12-17 | backend/app/schemas/project.py | Created | ✅ |
| 2025-12-17 | backend/app/services/codegen.py | Created | ✅ |
| 2025-12-17 | backend/app/repositories/project.py | Created | ✅ |
| 2025-12-17 | backend/app/services/project.py | Created | ✅ |
| 2025-12-17 | backend/app/api/v1/endpoints/projects.py | Created | ✅ |
| 2025-12-17 | backend/alembic/versions/003_projects.py | Created | ✅ |

---

# STATUS LEGEND

| Icon | Meaning |
|------|---------|
| 📋 | Planned / To Create |
| 🔨 | In Progress |
| ✅ | Implemented & Verified |
| ⚠️ | Needs Update |
| ❌ | Deprecated |

---

# UPDATE CHECKLIST

After generating ANY file:

```
□ Add entry to FILE REGISTRY section
□ Update status from 📋 to ✅
□ List all exports
□ List all dependencies
□ Add to GENERATION LOG
□ Run flutter analyze / python lint
□ Verify imports resolve
```
| 2025-12-17 | web/pubspec.yaml | Created | ✅ |
| 2025-12-17 | web/analysis_options.yaml | Created | ✅ |
| 2025-12-17 | web/lib/core/theme/app_colors.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/theme/app_typography.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/theme/app_spacing.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/theme/app_radius.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/theme/app_shadows.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/theme/app_icons.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/theme/app_theme.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/types/result.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/network/api_client.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/storage/secure_storage.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/config/env_config.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/widgets/primary_button.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/widgets/secondary_button.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/widgets/app_text_button.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/widgets/app_text_field.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/widgets/app_card.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/widgets/loading_indicator.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/widgets/empty_state.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/widgets/error_state.dart | Created | ✅ |
| 2025-12-17 | web/lib/features/auth/domain/entities/user.dart | Created | ✅ |
| 2025-12-17 | web/lib/features/auth/domain/repositories/auth_repository.dart | Created | ✅ |
| 2025-12-17 | web/lib/features/auth/data/repositories/auth_repository_impl.dart | Created | ✅ |
| 2025-12-17 | web/lib/features/auth/presentation/providers/auth_provider.dart | Created | ✅ |
| 2025-12-17 | web/lib/features/auth/presentation/screens/login_screen.dart | Created | ✅ |
| 2025-12-17 | web/lib/features/auth/presentation/screens/register_screen.dart | Created | ✅ |
| 2025-12-17 | web/lib/core/router/app_router.dart | Created | ✅ |
| 2025-12-17 | web/lib/main.dart | Created | ✅ |
| 2025-12-17 | web/lib/features/projects/domain/entities/project.dart | Created | ✅ |
| 2025-12-17 | web/lib/features/projects/domain/repositories/project_repository.dart | Created | ✅ |
| 2025-12-17 | web/lib/features/projects/data/repositories/project_repository_impl.dart | Created | ✅ |
| 2025-12-17 | web/lib/features/projects/presentation/providers/projects_provider.dart | Created | ✅ |
| 2025-12-17 | web/lib/features/projects/presentation/providers/project_detail_provider.dart | Created | ✅ |
