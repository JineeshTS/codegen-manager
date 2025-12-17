# CODEGEN MANAGER - COMPLETE WBS
## The Golden Bullet
## AI-Powered Code Generation Management System

---

# PROJECT OVERVIEW

## What This App Does

```
YOU (Non-Technical User):
1. Describe your app idea
2. Build WBS visually (click, not code)
3. Click "Generate"
4. Watch AI build your app
5. Code appears in GitHub
6. Deploy with copy-paste commands
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter Web |
| Backend | FastAPI + PostgreSQL |
| AI Generation | Claude Code (CLI on VPS) |
| AI Review | Gemini 1.5 Pro + GPT-5 |
| Hosting | Hostinger VPS |
| Version Control | GitHub |

## Project Structure

```
codegen_manager/
├── web/                      # Flutter Web App
│   ├── lib/
│   │   ├── core/            # Design system, utilities
│   │   └── features/        # Feature modules
│   └── pubspec.yaml
│
├── backend/                  # FastAPI Backend
│   ├── app/
│   │   ├── api/             # API endpoints
│   │   ├── models/          # Database models
│   │   ├── schemas/         # Pydantic schemas
│   │   ├── services/        # Business logic
│   │   └── repositories/    # Data access
│   └── requirements.txt
│
├── docs/                     # Documentation
│   ├── CLAUDE.md            # Code standards
│   ├── DESIGN_SYSTEM.md     # Design standards
│   └── API_CONTRACTS.md     # API specifications
│
└── scripts/                  # Deployment scripts
```

---

# PHASE OVERVIEW

| Phase | Name | Tasks | Description |
|-------|------|-------|-------------|
| 1 | Foundation | 42 | Auth, design system, base setup |
| 2 | Project Management | 28 | Create/manage projects, GitHub integration |
| 3 | WBS Builder | 45 | Visual WBS creation, task management |
| 4 | Prompt Engine | 32 | Prompt compilation, context injection |
| 5 | Execution Engine | 44 | Claude Code execution, verification |
| 6 | AI Consensus | 26 | Multi-AI review system |
| 7 | Polish | 20 | Settings, analytics, help |
| **TOTAL** | | **237** | |

---

# PHASE 1: FOUNDATION
## Authentication + Design System + Base Setup

### API Contract

```yaml
# Authentication API

POST /api/v1/auth/register:
  request:
    email: string (required)
    password: string (required, min 8 chars)
    full_name: string (required)
  response:
    user:
      id: uuid
      email: string
      full_name: string
      created_at: datetime
    token: string

POST /api/v1/auth/login:
  request:
    email: string (required)
    password: string (required)
  response:
    user:
      id: uuid
      email: string
      full_name: string
    token: string
    refresh_token: string

POST /api/v1/auth/refresh:
  request:
    refresh_token: string (required)
  response:
    token: string
    refresh_token: string

POST /api/v1/auth/logout:
  headers:
    Authorization: Bearer {token}
  response:
    success: boolean

GET /api/v1/auth/me:
  headers:
    Authorization: Bearer {token}
  response:
    user:
      id: uuid
      email: string
      full_name: string
      created_at: datetime

PUT /api/v1/auth/me:
  headers:
    Authorization: Bearer {token}
  request:
    full_name: string
    current_password: string (required for password change)
    new_password: string
  response:
    user: {updated user object}
```

### Tasks

#### Backend Foundation (15 tasks)

```
BE-001: Database Configuration
├── File: backend/app/core/database.py
├── Description: SQLAlchemy async engine, session factory, Base class
├── Depends On: None
├── Exports: engine, async_session, Base, get_db
└── Estimated: 4 hours

BE-002: Settings Configuration
├── File: backend/app/core/config.py
├── Description: Pydantic Settings for env variables
├── Depends On: None
├── Exports: Settings, settings
└── Estimated: 2 hours

BE-003: Security Utilities
├── File: backend/app/core/security.py
├── Description: Password hashing, JWT creation/verification
├── Depends On: BE-002
├── Exports: hash_password, verify_password, create_access_token, verify_token
└── Estimated: 4 hours

BE-004: Base Repository
├── File: backend/app/repositories/base.py
├── Description: Generic CRUD repository base class
├── Depends On: BE-001
├── Exports: BaseRepository[T]
└── Estimated: 4 hours

BE-005: Exception Handlers
├── File: backend/app/core/exceptions.py
├── Description: Custom exceptions and FastAPI exception handlers
├── Depends On: None
├── Exports: AppException, NotFoundException, UnauthorizedException, handlers
└── Estimated: 3 hours

BE-006: User Model
├── File: backend/app/models/user.py
├── Description: SQLAlchemy User model
├── Depends On: BE-001
├── Exports: User
├── Fields: id, email, hashed_password, full_name, is_active, created_at, updated_at
└── Estimated: 3 hours

BE-007: Auth Schemas
├── File: backend/app/schemas/auth.py
├── Description: Pydantic schemas for auth requests/responses
├── Depends On: None
├── Exports: RegisterRequest, LoginRequest, TokenResponse, UserResponse
└── Estimated: 2 hours

BE-008: User Repository
├── File: backend/app/repositories/user.py
├── Description: User CRUD operations
├── Depends On: BE-004, BE-006
├── Exports: UserRepository
├── Methods: get_by_email, get_by_id, create, update
└── Estimated: 3 hours

BE-009: Auth Service
├── File: backend/app/services/auth.py
├── Description: Authentication business logic
├── Depends On: BE-003, BE-008
├── Exports: AuthService
├── Methods: register, login, refresh_token, get_current_user, update_profile
└── Estimated: 5 hours

BE-010: Auth Dependencies
├── File: backend/app/api/dependencies.py
├── Description: FastAPI dependencies for auth
├── Depends On: BE-009
├── Exports: get_current_user, get_current_active_user
└── Estimated: 2 hours

BE-011: Auth Endpoints
├── File: backend/app/api/v1/endpoints/auth.py
├── Description: Auth API routes
├── Depends On: BE-009, BE-010, BE-007
├── Exports: router
├── Endpoints: POST /register, POST /login, POST /refresh, POST /logout, GET /me, PUT /me
└── Estimated: 4 hours

BE-012: API Router Setup
├── File: backend/app/api/v1/router.py
├── Description: Main API router combining all endpoints
├── Depends On: BE-011
├── Exports: api_router
└── Estimated: 1 hour

BE-013: App Factory
├── File: backend/app/main.py
├── Description: FastAPI app creation with middleware, CORS, routers
├── Depends On: BE-012, BE-005
├── Exports: app
└── Estimated: 3 hours

BE-014: Alembic Setup
├── File: backend/alembic/, backend/alembic.ini
├── Description: Database migration configuration
├── Depends On: BE-001, BE-006
├── Exports: Migration scripts
└── Estimated: 2 hours

BE-015: Initial Migration
├── File: backend/alembic/versions/001_initial.py
├── Description: Create users table
├── Depends On: BE-014
├── Exports: Migration
└── Estimated: 1 hour
```

#### Frontend Foundation (27 tasks)

```
FE-001: App Colors
├── File: web/lib/core/theme/app_colors.dart
├── Description: All color constants per DESIGN_SYSTEM.md
├── Depends On: None
├── Exports: AppColors
└── Estimated: 2 hours

FE-002: App Typography
├── File: web/lib/core/theme/app_typography.dart
├── Description: All text styles per DESIGN_SYSTEM.md
├── Depends On: FE-001
├── Exports: AppTextStyles
└── Estimated: 2 hours

FE-003: App Spacing
├── File: web/lib/core/theme/app_spacing.dart
├── Description: All spacing constants
├── Depends On: None
├── Exports: AppSpacing
└── Estimated: 1 hour

FE-004: App Radius
├── File: web/lib/core/theme/app_radius.dart
├── Description: Border radius constants
├── Depends On: None
├── Exports: AppRadius
└── Estimated: 1 hour

FE-005: App Shadows
├── File: web/lib/core/theme/app_shadows.dart
├── Description: Shadow styles
├── Depends On: FE-001
├── Exports: AppShadows
└── Estimated: 1 hour

FE-006: App Icons
├── File: web/lib/core/theme/app_icons.dart
├── Description: Icon mappings using lucide_icons
├── Depends On: None
├── Exports: AppIcons
└── Estimated: 2 hours

FE-007: App Theme
├── File: web/lib/core/theme/app_theme.dart
├── Description: ThemeData combining all design tokens
├── Depends On: FE-001, FE-002, FE-003, FE-004
├── Exports: AppTheme
└── Estimated: 3 hours

FE-008: Result Type
├── File: web/lib/core/types/result.dart
├── Description: Result<T> and Failure types for error handling
├── Depends On: None
├── Exports: Result, Failure, ServerFailure, NetworkFailure
└── Estimated: 2 hours

FE-009: API Client
├── File: web/lib/core/network/api_client.dart
├── Description: Dio HTTP client with interceptors
├── Depends On: FE-008
├── Exports: ApiClient
└── Estimated: 4 hours

FE-010: Secure Storage
├── File: web/lib/core/storage/secure_storage.dart
├── Description: Token storage (flutter_secure_storage for web)
├── Depends On: None
├── Exports: SecureStorage
└── Estimated: 2 hours

FE-011: Environment Config
├── File: web/lib/core/config/env_config.dart
├── Description: Environment variables (API URL, etc.)
├── Depends On: None
├── Exports: EnvConfig
└── Estimated: 1 hour

FE-012: Primary Button
├── File: web/lib/core/widgets/primary_button.dart
├── Description: Primary action button per DESIGN_SYSTEM.md
├── Depends On: FE-001, FE-002, FE-004
├── Exports: PrimaryButton
└── Estimated: 2 hours

FE-013: Secondary Button
├── File: web/lib/core/widgets/secondary_button.dart
├── Description: Secondary action button
├── Depends On: FE-001, FE-002, FE-004
├── Exports: SecondaryButton
└── Estimated: 2 hours

FE-014: Text Button
├── File: web/lib/core/widgets/app_text_button.dart
├── Description: Text-only button
├── Depends On: FE-001, FE-002
├── Exports: AppTextButton
└── Estimated: 1 hour

FE-015: App Text Field
├── File: web/lib/core/widgets/app_text_field.dart
├── Description: Styled text input per DESIGN_SYSTEM.md
├── Depends On: FE-001, FE-002, FE-004
├── Exports: AppTextField
└── Estimated: 3 hours

FE-016: App Card
├── File: web/lib/core/widgets/app_card.dart
├── Description: Card container
├── Depends On: FE-001, FE-004, FE-005
├── Exports: AppCard
└── Estimated: 2 hours

FE-017: Loading Indicator
├── File: web/lib/core/widgets/loading_indicator.dart
├── Description: Loading spinner
├── Depends On: FE-001
├── Exports: LoadingIndicator
└── Estimated: 1 hour

FE-018: Empty State
├── File: web/lib/core/widgets/empty_state.dart
├── Description: Empty list placeholder
├── Depends On: FE-001, FE-002, FE-006
├── Exports: EmptyState
└── Estimated: 2 hours

FE-019: Error State
├── File: web/lib/core/widgets/error_state.dart
├── Description: Error display with retry
├── Depends On: FE-001, FE-002, FE-012
├── Exports: ErrorState
└── Estimated: 2 hours

FE-020: User Entity
├── File: web/lib/features/auth/domain/entities/user.dart
├── Description: User data model (Freezed)
├── Depends On: None
├── Exports: User
└── Estimated: 2 hours

FE-021: Auth Repository Interface
├── File: web/lib/features/auth/domain/repositories/auth_repository.dart
├── Description: Abstract auth repository
├── Depends On: FE-008, FE-020
├── Exports: AuthRepository
└── Estimated: 2 hours

FE-022: Auth Repository Implementation
├── File: web/lib/features/auth/data/repositories/auth_repository_impl.dart
├── Description: Auth repository with API calls
├── Depends On: FE-009, FE-010, FE-021
├── Exports: AuthRepositoryImpl
└── Estimated: 4 hours

FE-023: Auth Provider
├── File: web/lib/features/auth/presentation/providers/auth_provider.dart
├── Description: Riverpod auth state management
├── Depends On: FE-022
├── Exports: authProvider, AuthState, AuthNotifier
└── Estimated: 4 hours

FE-024: Login Screen
├── File: web/lib/features/auth/presentation/screens/login_screen.dart
├── Description: Login form UI
├── Depends On: FE-012, FE-015, FE-023
├── Exports: LoginScreen
└── Estimated: 4 hours

FE-025: Register Screen
├── File: web/lib/features/auth/presentation/screens/register_screen.dart
├── Description: Registration form UI
├── Depends On: FE-012, FE-015, FE-023
├── Exports: RegisterScreen
└── Estimated: 4 hours

FE-026: App Router
├── File: web/lib/core/router/app_router.dart
├── Description: GoRouter configuration with auth guards
├── Depends On: FE-023, FE-024, FE-025
├── Exports: appRouter
└── Estimated: 3 hours

FE-027: App Entry Point
├── File: web/lib/main.dart
├── Description: Main app widget with providers
├── Depends On: FE-007, FE-026
├── Exports: main(), MyApp
└── Estimated: 2 hours
```

---

# PHASE 2: PROJECT MANAGEMENT
## Create, Edit, Delete Projects + GitHub Integration

### API Contract

```yaml
# Project API

GET /api/v1/projects:
  headers:
    Authorization: Bearer {token}
  query:
    page: number (default: 1)
    per_page: number (default: 20)
    search: string (optional)
    status: string (optional) # draft, in_progress, completed
  response:
    projects:
      - id: uuid
        name: string
        description: string
        platforms: string[]  # ["mobile", "web", "desktop", "backend"]
        github_repo: string
        github_connected: boolean
        status: string
        progress_percentage: number
        total_tasks: number
        completed_tasks: number
        created_at: datetime
        updated_at: datetime
    pagination:
      total: number
      page: number
      per_page: number
      total_pages: number

POST /api/v1/projects:
  headers:
    Authorization: Bearer {token}
  request:
    name: string (required, max 100)
    description: string (max 500)
    platforms: string[] (required, min 1)
    github_repo: string (required, format: owner/repo)
  response:
    project: {full project object}

GET /api/v1/projects/{id}:
  headers:
    Authorization: Bearer {token}
  response:
    project: {full project object}
    features:
      - id: uuid
        name: string
        task_count: number
        completed_count: number
    recent_activity:
      - type: string
        description: string
        timestamp: datetime

PUT /api/v1/projects/{id}:
  headers:
    Authorization: Bearer {token}
  request:
    name: string
    description: string
    platforms: string[]
    github_repo: string
    status: string
  response:
    project: {updated project object}

DELETE /api/v1/projects/{id}:
  headers:
    Authorization: Bearer {token}
  response:
    success: boolean

POST /api/v1/projects/{id}/github/connect:
  headers:
    Authorization: Bearer {token}
  request:
    access_token: string (GitHub personal access token)
  response:
    success: boolean
    repository:
      name: string
      full_name: string
      default_branch: string

GET /api/v1/projects/{id}/github/status:
  headers:
    Authorization: Bearer {token}
  response:
    connected: boolean
    last_commit: string
    last_commit_date: datetime
    branch: string
```

### Tasks

#### Backend (12 tasks)

```
BE-016: Project Model
├── File: backend/app/models/project.py
├── Description: SQLAlchemy Project model
├── Depends On: BE-001, BE-006
├── Exports: Project
├── Fields: id, user_id, name, description, platforms, github_repo, github_token, status, created_at, updated_at
└── Estimated: 3 hours

BE-017: Project Schemas
├── File: backend/app/schemas/project.py
├── Description: Pydantic schemas for project API
├── Depends On: None
├── Exports: ProjectCreate, ProjectUpdate, ProjectResponse, ProjectListResponse
└── Estimated: 2 hours

BE-018: Project Repository
├── File: backend/app/repositories/project.py
├── Description: Project CRUD operations
├── Depends On: BE-004, BE-016
├── Exports: ProjectRepository
├── Methods: get_by_user, get_by_id, create, update, delete, search
└── Estimated: 4 hours

BE-019: GitHub Service
├── File: backend/app/services/github.py
├── Description: GitHub API integration
├── Depends On: BE-002
├── Exports: GitHubService
├── Methods: validate_repo, get_repo_info, commit_file, create_branch, get_status
└── Estimated: 5 hours

BE-020: Project Service
├── File: backend/app/services/project.py
├── Description: Project business logic
├── Depends On: BE-018, BE-019
├── Exports: ProjectService
├── Methods: create_project, update_project, delete_project, connect_github, get_progress
└── Estimated: 5 hours

BE-021: Project Endpoints
├── File: backend/app/api/v1/endpoints/projects.py
├── Description: Project API routes
├── Depends On: BE-020, BE-017, BE-010
├── Exports: router
├── Endpoints: GET /, POST /, GET /{id}, PUT /{id}, DELETE /{id}, POST /{id}/github/connect, GET /{id}/github/status
└── Estimated: 5 hours

BE-022: Project Migration
├── File: backend/alembic/versions/002_projects.py
├── Description: Create projects table
├── Depends On: BE-016
├── Exports: Migration
└── Estimated: 1 hour

BE-023: Update API Router
├── File: backend/app/api/v1/router.py (UPDATE)
├── Description: Add project routes to main router
├── Depends On: BE-021, BE-012
├── Exports: api_router
└── Estimated: 1 hour
```

#### Frontend (16 tasks)

```
FE-028: Project Entity
├── File: web/lib/features/projects/domain/entities/project.dart
├── Description: Project data model (Freezed)
├── Depends On: None
├── Exports: Project, ProjectStatus
└── Estimated: 2 hours

FE-029: Project Repository Interface
├── File: web/lib/features/projects/domain/repositories/project_repository.dart
├── Description: Abstract project repository
├── Depends On: FE-008, FE-028
├── Exports: ProjectRepository
└── Estimated: 2 hours

FE-030: Project Repository Implementation
├── File: web/lib/features/projects/data/repositories/project_repository_impl.dart
├── Description: Project API implementation
├── Depends On: FE-009, FE-029
├── Exports: ProjectRepositoryImpl
└── Estimated: 4 hours

FE-031: Projects Provider
├── File: web/lib/features/projects/presentation/providers/projects_provider.dart
├── Description: Riverpod state for project list
├── Depends On: FE-030
├── Exports: projectsProvider, ProjectsState, ProjectsNotifier
└── Estimated: 4 hours

FE-032: Project Detail Provider
├── File: web/lib/features/projects/presentation/providers/project_detail_provider.dart
├── Description: Single project state
├── Depends On: FE-030
├── Exports: projectDetailProvider
└── Estimated: 3 hours

FE-033: Project Card Widget
├── File: web/lib/features/projects/presentation/widgets/project_card.dart
├── Description: Project list item card
├── Depends On: FE-016, FE-028
├── Exports: ProjectCard
└── Estimated: 3 hours

FE-034: Progress Bar Widget
├── File: web/lib/core/widgets/progress_bar.dart
├── Description: Horizontal progress indicator
├── Depends On: FE-001
├── Exports: ProgressBar
└── Estimated: 2 hours

FE-035: Platform Badge Widget
├── File: web/lib/features/projects/presentation/widgets/platform_badge.dart
├── Description: Platform indicator (Mobile, Web, etc.)
├── Depends On: FE-001, FE-006
├── Exports: PlatformBadge
└── Estimated: 2 hours

FE-036: Dashboard Screen
├── File: web/lib/features/projects/presentation/screens/dashboard_screen.dart
├── Description: Main dashboard with project list
├── Depends On: FE-031, FE-033, FE-018
├── Exports: DashboardScreen
└── Estimated: 5 hours

FE-037: Create Project Screen
├── File: web/lib/features/projects/presentation/screens/create_project_screen.dart
├── Description: New project form
├── Depends On: FE-015, FE-012, FE-031
├── Exports: CreateProjectScreen
└── Estimated: 5 hours

FE-038: Platform Selector Widget
├── File: web/lib/features/projects/presentation/widgets/platform_selector.dart
├── Description: Multi-select platform picker
├── Depends On: FE-001, FE-006
├── Exports: PlatformSelector
└── Estimated: 3 hours

FE-039: Project Detail Screen
├── File: web/lib/features/projects/presentation/screens/project_detail_screen.dart
├── Description: Single project view with tabs
├── Depends On: FE-032, FE-016
├── Exports: ProjectDetailScreen
└── Estimated: 5 hours

FE-040: Edit Project Screen
├── File: web/lib/features/projects/presentation/screens/edit_project_screen.dart
├── Description: Edit project form
├── Depends On: FE-015, FE-012, FE-032
├── Exports: EditProjectScreen
└── Estimated: 4 hours

FE-041: GitHub Connect Dialog
├── File: web/lib/features/projects/presentation/widgets/github_connect_dialog.dart
├── Description: Dialog to enter GitHub token
├── Depends On: FE-015, FE-012
├── Exports: GitHubConnectDialog
└── Estimated: 3 hours

FE-042: Delete Confirmation Dialog
├── File: web/lib/core/widgets/delete_confirmation_dialog.dart
├── Description: Generic delete confirmation
├── Depends On: FE-012, FE-013
├── Exports: DeleteConfirmationDialog
└── Estimated: 2 hours

FE-043: Update Router for Projects
├── File: web/lib/core/router/app_router.dart (UPDATE)
├── Description: Add project routes
├── Depends On: FE-036, FE-037, FE-039, FE-040
├── Exports: appRouter
└── Estimated: 2 hours
```

---

# PHASE 3: WBS BUILDER
## Visual Task Breakdown Structure Creation

### API Contract

```yaml
# Feature API

GET /api/v1/projects/{project_id}/features:
  response:
    features:
      - id: uuid
        name: string
        description: string
        order: number
        task_count: number
        completed_count: number
        tasks:
          - id: uuid
            code: string
            name: string
            status: string

POST /api/v1/projects/{project_id}/features:
  request:
    name: string (required)
    description: string
    order: number
  response:
    feature: {feature object}

PUT /api/v1/projects/{project_id}/features/{id}:
  request:
    name: string
    description: string
    order: number
  response:
    feature: {updated feature object}

DELETE /api/v1/projects/{project_id}/features/{id}:
  response:
    success: boolean

# Task API

GET /api/v1/projects/{project_id}/tasks:
  query:
    feature_id: uuid (optional)
    status: string (optional)
    platform: string (optional)
  response:
    tasks:
      - id: uuid
        code: string  # e.g., "MOB-001"
        name: string
        description: string
        platform: string  # mobile, web, desktop, backend
        layer: string  # model, schema, repository, service, endpoint, entity, screen, widget, provider
        output_path: string
        depends_on: uuid[]
        exports: string[]
        status: string  # pending, in_progress, completed, failed
        feature_id: uuid
        order: number
        created_at: datetime

POST /api/v1/projects/{project_id}/tasks:
  request:
    code: string (required)
    name: string (required)
    description: string (required)
    platform: string (required)
    layer: string (required)
    output_path: string (required)
    depends_on: uuid[]
    exports: string[]
    feature_id: uuid (required)
  response:
    task: {task object}

PUT /api/v1/projects/{project_id}/tasks/{id}:
  request:
    code: string
    name: string
    description: string
    platform: string
    layer: string
    output_path: string
    depends_on: uuid[]
    exports: string[]
    feature_id: uuid
  response:
    task: {updated task object}

DELETE /api/v1/projects/{project_id}/tasks/{id}:
  response:
    success: boolean

POST /api/v1/projects/{project_id}/tasks/reorder:
  request:
    task_orders:
      - id: uuid
        order: number
  response:
    success: boolean

POST /api/v1/projects/{project_id}/wbs/import:
  request:
    content: string  # Markdown or YAML content
    format: string  # "markdown" or "yaml"
  response:
    features_created: number
    tasks_created: number

GET /api/v1/projects/{project_id}/wbs/export:
  query:
    format: string  # "markdown" or "yaml"
  response:
    content: string
    filename: string

POST /api/v1/projects/{project_id}/tasks/calculate-order:
  response:
    execution_order:
      - task_id: uuid
        order: number
        can_run: boolean
        blocked_by: uuid[]
```

### Tasks

#### Backend (18 tasks)

```
BE-024: Feature Model
├── File: backend/app/models/feature.py
├── Description: SQLAlchemy Feature model
├── Depends On: BE-001, BE-016
├── Exports: Feature
├── Fields: id, project_id, name, description, order, created_at
└── Estimated: 2 hours

BE-025: Task Model
├── File: backend/app/models/task.py
├── Description: SQLAlchemy Task model
├── Depends On: BE-001, BE-024
├── Exports: Task
├── Fields: id, feature_id, code, name, description, platform, layer, output_path, depends_on, exports, status, order, created_at, updated_at
└── Estimated: 3 hours

BE-026: Feature Schemas
├── File: backend/app/schemas/feature.py
├── Description: Pydantic schemas for features
├── Depends On: None
├── Exports: FeatureCreate, FeatureUpdate, FeatureResponse
└── Estimated: 2 hours

BE-027: Task Schemas
├── File: backend/app/schemas/task.py
├── Description: Pydantic schemas for tasks
├── Depends On: None
├── Exports: TaskCreate, TaskUpdate, TaskResponse, TaskReorderRequest
└── Estimated: 2 hours

BE-028: Feature Repository
├── File: backend/app/repositories/feature.py
├── Description: Feature CRUD operations
├── Depends On: BE-004, BE-024
├── Exports: FeatureRepository
└── Estimated: 3 hours

BE-029: Task Repository
├── File: backend/app/repositories/task.py
├── Description: Task CRUD operations
├── Depends On: BE-004, BE-025
├── Exports: TaskRepository
├── Methods: get_by_project, get_by_feature, create, update, delete, reorder, get_dependencies
└── Estimated: 4 hours

BE-030: Dependency Resolver Service
├── File: backend/app/services/dependency_resolver.py
├── Description: Calculate task execution order based on dependencies
├── Depends On: BE-029
├── Exports: DependencyResolver
├── Methods: calculate_order, validate_dependencies, detect_cycles
└── Estimated: 5 hours

BE-031: WBS Import Service
├── File: backend/app/services/wbs_import.py
├── Description: Parse markdown/yaml WBS into tasks
├── Depends On: BE-028, BE-029
├── Exports: WBSImportService
├── Methods: import_markdown, import_yaml, validate_wbs
└── Estimated: 6 hours

BE-032: WBS Export Service
├── File: backend/app/services/wbs_export.py
├── Description: Export tasks to markdown/yaml
├── Depends On: BE-028, BE-029
├── Exports: WBSExportService
├── Methods: export_markdown, export_yaml
└── Estimated: 4 hours

BE-033: Feature Service
├── File: backend/app/services/feature.py
├── Description: Feature business logic
├── Depends On: BE-028
├── Exports: FeatureService
└── Estimated: 3 hours

BE-034: Task Service
├── File: backend/app/services/task.py
├── Description: Task business logic
├── Depends On: BE-029, BE-030
├── Exports: TaskService
└── Estimated: 4 hours

BE-035: Feature Endpoints
├── File: backend/app/api/v1/endpoints/features.py
├── Description: Feature API routes
├── Depends On: BE-033, BE-026, BE-010
├── Exports: router
└── Estimated: 4 hours

BE-036: Task Endpoints
├── File: backend/app/api/v1/endpoints/tasks.py
├── Description: Task API routes
├── Depends On: BE-034, BE-027, BE-010
├── Exports: router
└── Estimated: 5 hours

BE-037: WBS Endpoints
├── File: backend/app/api/v1/endpoints/wbs.py
├── Description: WBS import/export routes
├── Depends On: BE-031, BE-032, BE-010
├── Exports: router
└── Estimated: 3 hours

BE-038: Feature Migration
├── File: backend/alembic/versions/003_features.py
├── Description: Create features table
├── Depends On: BE-024
└── Estimated: 1 hour

BE-039: Task Migration
├── File: backend/alembic/versions/004_tasks.py
├── Description: Create tasks table
├── Depends On: BE-025
└── Estimated: 1 hour

BE-040: Update API Router for WBS
├── File: backend/app/api/v1/router.py (UPDATE)
├── Description: Add feature, task, wbs routes
├── Depends On: BE-035, BE-036, BE-037
└── Estimated: 1 hour
```

#### Frontend (27 tasks)

```
FE-044: Feature Entity
├── File: web/lib/features/wbs/domain/entities/feature.dart
├── Description: Feature data model (Freezed)
├── Depends On: None
├── Exports: Feature
└── Estimated: 2 hours

FE-045: Task Entity
├── File: web/lib/features/wbs/domain/entities/task.dart
├── Description: Task data model (Freezed)
├── Depends On: None
├── Exports: Task, TaskStatus, Platform, Layer
└── Estimated: 3 hours

FE-046: WBS Repository Interface
├── File: web/lib/features/wbs/domain/repositories/wbs_repository.dart
├── Description: Abstract WBS repository
├── Depends On: FE-008, FE-044, FE-045
├── Exports: WBSRepository
└── Estimated: 2 hours

FE-047: WBS Repository Implementation
├── File: web/lib/features/wbs/data/repositories/wbs_repository_impl.dart
├── Description: WBS API implementation
├── Depends On: FE-009, FE-046
├── Exports: WBSRepositoryImpl
└── Estimated: 5 hours

FE-048: WBS Provider
├── File: web/lib/features/wbs/presentation/providers/wbs_provider.dart
├── Description: Riverpod state for WBS
├── Depends On: FE-047
├── Exports: wbsProvider, WBSState, WBSNotifier
└── Estimated: 5 hours

FE-049: Task Editor Provider
├── File: web/lib/features/wbs/presentation/providers/task_editor_provider.dart
├── Description: State for task creation/editing
├── Depends On: FE-047
├── Exports: taskEditorProvider
└── Estimated: 3 hours

FE-050: WBS Builder Screen
├── File: web/lib/features/wbs/presentation/screens/wbs_builder_screen.dart
├── Description: Main WBS builder with split view
├── Depends On: FE-048
├── Exports: WBSBuilderScreen
└── Estimated: 6 hours

FE-051: Feature Tree Widget
├── File: web/lib/features/wbs/presentation/widgets/feature_tree.dart
├── Description: Collapsible feature/task tree
├── Depends On: FE-048, FE-044, FE-045
├── Exports: FeatureTree
└── Estimated: 5 hours

FE-052: Feature List Item Widget
├── File: web/lib/features/wbs/presentation/widgets/feature_list_item.dart
├── Description: Single feature row in tree
├── Depends On: FE-044
├── Exports: FeatureListItem
└── Estimated: 3 hours

FE-053: Task List Item Widget
├── File: web/lib/features/wbs/presentation/widgets/task_list_item.dart
├── Description: Single task row in tree
├── Depends On: FE-045
├── Exports: TaskListItem
└── Estimated: 3 hours

FE-054: Task Detail Panel
├── File: web/lib/features/wbs/presentation/widgets/task_detail_panel.dart
├── Description: Right panel showing selected task details
├── Depends On: FE-045, FE-049
├── Exports: TaskDetailPanel
└── Estimated: 5 hours

FE-055: Add Feature Dialog
├── File: web/lib/features/wbs/presentation/widgets/add_feature_dialog.dart
├── Description: Dialog to create new feature
├── Depends On: FE-015, FE-012
├── Exports: AddFeatureDialog
└── Estimated: 3 hours

FE-056: Add Task Dialog
├── File: web/lib/features/wbs/presentation/widgets/add_task_dialog.dart
├── Description: Dialog to create new task
├── Depends On: FE-015, FE-012, FE-049
├── Exports: AddTaskDialog
└── Estimated: 4 hours

FE-057: Platform Dropdown
├── File: web/lib/features/wbs/presentation/widgets/platform_dropdown.dart
├── Description: Platform selector dropdown
├── Depends On: FE-001
├── Exports: PlatformDropdown
└── Estimated: 2 hours

FE-058: Layer Dropdown
├── File: web/lib/features/wbs/presentation/widgets/layer_dropdown.dart
├── Description: Layer selector dropdown
├── Depends On: FE-001
├── Exports: LayerDropdown
└── Estimated: 2 hours

FE-059: Dependency Selector
├── File: web/lib/features/wbs/presentation/widgets/dependency_selector.dart
├── Description: Multi-select for task dependencies
├── Depends On: FE-048
├── Exports: DependencySelector
└── Estimated: 4 hours

FE-060: Task Status Badge
├── File: web/lib/features/wbs/presentation/widgets/task_status_badge.dart
├── Description: Status indicator (pending, completed, etc.)
├── Depends On: FE-001
├── Exports: TaskStatusBadge
└── Estimated: 2 hours

FE-061: Import WBS Dialog
├── File: web/lib/features/wbs/presentation/widgets/import_wbs_dialog.dart
├── Description: Import markdown/yaml WBS
├── Depends On: FE-015, FE-012, FE-048
├── Exports: ImportWBSDialog
└── Estimated: 4 hours

FE-062: Export WBS Dialog
├── File: web/lib/features/wbs/presentation/widgets/export_wbs_dialog.dart
├── Description: Export WBS options
├── Depends On: FE-012, FE-048
├── Exports: ExportWBSDialog
└── Estimated: 3 hours

FE-063: Execution Order Preview
├── File: web/lib/features/wbs/presentation/widgets/execution_order_preview.dart
├── Description: Show calculated task order
├── Depends On: FE-048
├── Exports: ExecutionOrderPreview
└── Estimated: 4 hours

FE-064: Drag Handle Widget
├── File: web/lib/core/widgets/drag_handle.dart
├── Description: Reorderable list drag handle
├── Depends On: FE-001
├── Exports: DragHandle
└── Estimated: 1 hour

FE-065: WBS Stats Card
├── File: web/lib/features/wbs/presentation/widgets/wbs_stats_card.dart
├── Description: Shows total tasks, by platform, by status
├── Depends On: FE-016, FE-048
├── Exports: WBSStatsCard
└── Estimated: 3 hours

FE-066: Bulk Actions Bar
├── File: web/lib/features/wbs/presentation/widgets/bulk_actions_bar.dart
├── Description: Multi-select actions (delete, move)
├── Depends On: FE-012, FE-048
├── Exports: BulkActionsBar
└── Estimated: 3 hours

FE-067: Search Tasks Widget
├── File: web/lib/features/wbs/presentation/widgets/search_tasks.dart
├── Description: Search/filter tasks
├── Depends On: FE-015
├── Exports: SearchTasks
└── Estimated: 2 hours

FE-068: Platform Filter Chips
├── File: web/lib/features/wbs/presentation/widgets/platform_filter_chips.dart
├── Description: Filter by platform
├── Depends On: FE-001
├── Exports: PlatformFilterChips
└── Estimated: 2 hours

FE-069: Update Router for WBS
├── File: web/lib/core/router/app_router.dart (UPDATE)
├── Description: Add WBS builder route
├── Depends On: FE-050
└── Estimated: 1 hour
```

---

# Continue in Part 2...

The complete WBS continues with:
- Phase 4: Prompt Engine
- Phase 5: Execution Engine
- Phase 6: AI Consensus
- Phase 7: Polish

Total tasks so far: 42 + 28 + 45 = 115 tasks
