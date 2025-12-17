# CODEGEN MANAGER - COMPLETE WBS (Part 2)
## Phases 4-7: Prompt Engine, Execution, AI Consensus, Polish

---

# PHASE 4: PROMPT ENGINE
## Prompt Compilation + Context Injection

### API Contract

```yaml
# Prompt API

POST /api/v1/projects/{project_id}/prompts/generate:
  description: Generate prompts from tasks
  request:
    task_ids: uuid[] (optional, default: all pending tasks)
    regenerate: boolean (default: false)
  response:
    prompts_generated: number
    prompts:
      - id: uuid
        task_id: uuid
        task_code: string
        content: string  # The full prompt text
        status: string  # ready, executed, failed
        created_at: datetime

GET /api/v1/projects/{project_id}/prompts:
  query:
    status: string (optional)
    task_id: uuid (optional)
  response:
    prompts:
      - id: uuid
        task_id: uuid
        task_code: string
        task_name: string
        content_preview: string  # First 200 chars
        status: string
        execution_order: number
        created_at: datetime

GET /api/v1/projects/{project_id}/prompts/{id}:
  response:
    prompt:
      id: uuid
      task_id: uuid
      task: {task object}
      content: string  # Full prompt text
      status: string
      dependencies_included: string[]  # List of files injected
      standards_sections: string[]  # Which CLAUDE.md sections
      created_at: datetime

PUT /api/v1/projects/{project_id}/prompts/{id}:
  request:
    content: string  # Allow manual editing
  response:
    prompt: {updated prompt}

POST /api/v1/projects/{project_id}/prompts/{id}/regenerate:
  response:
    prompt: {regenerated prompt}

# Standards API

GET /api/v1/projects/{project_id}/standards:
  response:
    claude_md: string
    design_system_md: string
    code_registry_md: string

PUT /api/v1/projects/{project_id}/standards:
  request:
    claude_md: string
    design_system_md: string
  response:
    success: boolean

GET /api/v1/projects/{project_id}/standards/templates:
  response:
    templates:
      - name: string
        description: string
        content: string
```

### Tasks

#### Backend (15 tasks)

```
BE-041: Prompt Model
├── File: backend/app/models/prompt.py
├── Description: SQLAlchemy Prompt model
├── Depends On: BE-001, BE-025
├── Exports: Prompt
├── Fields: id, task_id, content, status, dependencies_hash, created_at, updated_at
└── Estimated: 3 hours

BE-042: Standards Model
├── File: backend/app/models/standards.py
├── Description: Store CLAUDE.md, DESIGN_SYSTEM.md per project
├── Depends On: BE-001, BE-016
├── Exports: ProjectStandards
├── Fields: id, project_id, claude_md, design_system_md, code_registry_md, updated_at
└── Estimated: 2 hours

BE-043: Prompt Schemas
├── File: backend/app/schemas/prompt.py
├── Description: Pydantic schemas for prompts
├── Depends On: None
├── Exports: PromptResponse, PromptGenerateRequest, PromptUpdateRequest
└── Estimated: 2 hours

BE-044: Standards Schemas
├── File: backend/app/schemas/standards.py
├── Description: Pydantic schemas for standards
├── Depends On: None
├── Exports: StandardsResponse, StandardsUpdateRequest
└── Estimated: 1 hour

BE-045: Prompt Repository
├── File: backend/app/repositories/prompt.py
├── Description: Prompt CRUD operations
├── Depends On: BE-004, BE-041
├── Exports: PromptRepository
└── Estimated: 3 hours

BE-046: Standards Repository
├── File: backend/app/repositories/standards.py
├── Description: Standards CRUD operations
├── Depends On: BE-004, BE-042
├── Exports: StandardsRepository
└── Estimated: 2 hours

BE-047: Context Injection Service
├── File: backend/app/services/context_injection.py
├── Description: Extract relevant standards sections, inject dependencies
├── Depends On: BE-046, BE-029
├── Exports: ContextInjectionService
├── Methods: get_relevant_standards, inject_dependencies, build_context
└── Estimated: 6 hours

BE-048: Prompt Compiler Service
├── File: backend/app/services/prompt_compiler.py
├── Description: Generate prompt from task + context
├── Depends On: BE-047, BE-029
├── Exports: PromptCompilerService
├── Methods: compile_prompt, compile_all, regenerate_prompt
└── Estimated: 8 hours

BE-049: Prompt Templates
├── File: backend/app/services/prompt_templates.py
├── Description: Prompt template strings for different task types
├── Depends On: None
├── Exports: BACKEND_MODEL_TEMPLATE, FLUTTER_ENTITY_TEMPLATE, FLUTTER_SCREEN_TEMPLATE, etc.
└── Estimated: 5 hours

BE-050: Prompt Service
├── File: backend/app/services/prompt.py
├── Description: Prompt business logic
├── Depends On: BE-045, BE-048
├── Exports: PromptService
└── Estimated: 4 hours

BE-051: Standards Service
├── File: backend/app/services/standards.py
├── Description: Standards management
├── Depends On: BE-046
├── Exports: StandardsService
├── Methods: get_standards, update_standards, get_templates, initialize_defaults
└── Estimated: 3 hours

BE-052: Prompt Endpoints
├── File: backend/app/api/v1/endpoints/prompts.py
├── Description: Prompt API routes
├── Depends On: BE-050, BE-043, BE-010
├── Exports: router
└── Estimated: 4 hours

BE-053: Standards Endpoints
├── File: backend/app/api/v1/endpoints/standards.py
├── Description: Standards API routes
├── Depends On: BE-051, BE-044, BE-010
├── Exports: router
└── Estimated: 3 hours

BE-054: Prompt Migration
├── File: backend/alembic/versions/005_prompts.py
├── Description: Create prompts and standards tables
├── Depends On: BE-041, BE-042
└── Estimated: 1 hour

BE-055: Update API Router for Prompts
├── File: backend/app/api/v1/router.py (UPDATE)
├── Description: Add prompt and standards routes
├── Depends On: BE-052, BE-053
└── Estimated: 1 hour
```

#### Frontend (17 tasks)

```
FE-070: Prompt Entity
├── File: web/lib/features/prompts/domain/entities/prompt.dart
├── Description: Prompt data model (Freezed)
├── Depends On: None
├── Exports: Prompt, PromptStatus
└── Estimated: 2 hours

FE-071: Standards Entity
├── File: web/lib/features/prompts/domain/entities/standards.dart
├── Description: Standards data model
├── Depends On: None
├── Exports: ProjectStandards
└── Estimated: 2 hours

FE-072: Prompt Repository Interface
├── File: web/lib/features/prompts/domain/repositories/prompt_repository.dart
├── Description: Abstract prompt repository
├── Depends On: FE-008, FE-070
├── Exports: PromptRepository
└── Estimated: 2 hours

FE-073: Prompt Repository Implementation
├── File: web/lib/features/prompts/data/repositories/prompt_repository_impl.dart
├── Description: Prompt API implementation
├── Depends On: FE-009, FE-072
├── Exports: PromptRepositoryImpl
└── Estimated: 4 hours

FE-074: Prompts Provider
├── File: web/lib/features/prompts/presentation/providers/prompts_provider.dart
├── Description: Riverpod state for prompts
├── Depends On: FE-073
├── Exports: promptsProvider
└── Estimated: 4 hours

FE-075: Standards Provider
├── File: web/lib/features/prompts/presentation/providers/standards_provider.dart
├── Description: Riverpod state for standards
├── Depends On: FE-073
├── Exports: standardsProvider
└── Estimated: 3 hours

FE-076: Prompts List Screen
├── File: web/lib/features/prompts/presentation/screens/prompts_list_screen.dart
├── Description: List all generated prompts
├── Depends On: FE-074
├── Exports: PromptsListScreen
└── Estimated: 5 hours

FE-077: Prompt Card Widget
├── File: web/lib/features/prompts/presentation/widgets/prompt_card.dart
├── Description: Prompt list item
├── Depends On: FE-070, FE-016
├── Exports: PromptCard
└── Estimated: 3 hours

FE-078: Prompt Detail Screen
├── File: web/lib/features/prompts/presentation/screens/prompt_detail_screen.dart
├── Description: View/edit single prompt
├── Depends On: FE-074
├── Exports: PromptDetailScreen
└── Estimated: 5 hours

FE-079: Prompt Content Viewer
├── File: web/lib/features/prompts/presentation/widgets/prompt_content_viewer.dart
├── Description: Syntax-highlighted prompt display
├── Depends On: FE-001
├── Exports: PromptContentViewer
└── Estimated: 4 hours

FE-080: Generate Prompts Button
├── File: web/lib/features/prompts/presentation/widgets/generate_prompts_button.dart
├── Description: Button to trigger prompt generation
├── Depends On: FE-012, FE-074
├── Exports: GeneratePromptsButton
└── Estimated: 2 hours

FE-081: Standards Editor Screen
├── File: web/lib/features/prompts/presentation/screens/standards_editor_screen.dart
├── Description: Edit CLAUDE.md, DESIGN_SYSTEM.md
├── Depends On: FE-075
├── Exports: StandardsEditorScreen
└── Estimated: 5 hours

FE-082: Markdown Editor Widget
├── File: web/lib/core/widgets/markdown_editor.dart
├── Description: Code editor for markdown
├── Depends On: FE-001
├── Exports: MarkdownEditor
└── Estimated: 4 hours

FE-083: Standards Template Selector
├── File: web/lib/features/prompts/presentation/widgets/standards_template_selector.dart
├── Description: Choose from pre-built templates
├── Depends On: FE-075
├── Exports: StandardsTemplateSelector
└── Estimated: 3 hours

FE-084: Prompt Status Filter
├── File: web/lib/features/prompts/presentation/widgets/prompt_status_filter.dart
├── Description: Filter prompts by status
├── Depends On: FE-001
├── Exports: PromptStatusFilter
└── Estimated: 2 hours

FE-085: Regenerate Prompt Dialog
├── File: web/lib/features/prompts/presentation/widgets/regenerate_prompt_dialog.dart
├── Description: Confirm regenerate prompt
├── Depends On: FE-012, FE-013
├── Exports: RegeneratePromptDialog
└── Estimated: 2 hours

FE-086: Update Router for Prompts
├── File: web/lib/core/router/app_router.dart (UPDATE)
├── Description: Add prompt routes
├── Depends On: FE-076, FE-078, FE-081
└── Estimated: 1 hour
```

---

# PHASE 5: EXECUTION ENGINE
## Claude Code Execution + Verification + Git Integration

### API Contract

```yaml
# Execution API

POST /api/v1/projects/{project_id}/executions/start:
  description: Start executing prompts
  request:
    prompt_ids: uuid[] (optional, default: all ready prompts in order)
    mode: string  # "auto" (continuous) or "manual" (one at a time)
  response:
    execution_session:
      id: uuid
      status: string  # running, paused, completed, failed
      total_prompts: number
      completed: number
      current_prompt_id: uuid

GET /api/v1/projects/{project_id}/executions/current:
  response:
    session:
      id: uuid
      status: string
      total_prompts: number
      completed: number
      failed: number
      current_task:
        id: uuid
        code: string
        name: string
        status: string
      recent_logs:
        - timestamp: datetime
          level: string
          message: string

POST /api/v1/projects/{project_id}/executions/pause:
  response:
    success: boolean

POST /api/v1/projects/{project_id}/executions/resume:
  response:
    success: boolean

POST /api/v1/projects/{project_id}/executions/stop:
  response:
    success: boolean

POST /api/v1/projects/{project_id}/executions/retry/{task_id}:
  response:
    success: boolean

POST /api/v1/projects/{project_id}/executions/skip/{task_id}:
  response:
    success: boolean

GET /api/v1/projects/{project_id}/executions/history:
  response:
    executions:
      - id: uuid
        task_id: uuid
        task_code: string
        status: string  # success, failed, skipped
        duration_seconds: number
        error_message: string
        git_commit: string
        executed_at: datetime

# WebSocket for real-time updates
WS /api/v1/projects/{project_id}/executions/stream:
  messages:
    - type: "status_update"
      data:
        task_id: uuid
        status: string
        progress: number
    - type: "log"
      data:
        level: string
        message: string
        timestamp: datetime
    - type: "task_complete"
      data:
        task_id: uuid
        success: boolean
        git_commit: string
    - type: "session_complete"
      data:
        total: number
        succeeded: number
        failed: number

# Code Registry API
GET /api/v1/projects/{project_id}/registry:
  response:
    registry:
      files:
        - path: string
          task_id: uuid
          status: string
          exports: string[]
          depends_on: string[]
          created_at: datetime

PUT /api/v1/projects/{project_id}/registry:
  request:
    content: string  # Full CODE_REGISTRY.md content
  response:
    success: boolean
```

### Tasks

#### Backend (20 tasks)

```
BE-056: Execution Session Model
├── File: backend/app/models/execution_session.py
├── Description: Track execution sessions
├── Depends On: BE-001, BE-016
├── Exports: ExecutionSession
├── Fields: id, project_id, status, total_prompts, completed, failed, started_at, ended_at
└── Estimated: 3 hours

BE-057: Execution Log Model
├── File: backend/app/models/execution_log.py
├── Description: Individual task execution records
├── Depends On: BE-001, BE-056, BE-025
├── Exports: ExecutionLog
├── Fields: id, session_id, task_id, status, output, error_message, git_commit, duration, executed_at
└── Estimated: 3 hours

BE-058: Execution Schemas
├── File: backend/app/schemas/execution.py
├── Description: Pydantic schemas for execution
├── Depends On: None
├── Exports: ExecutionStartRequest, ExecutionSessionResponse, ExecutionLogResponse
└── Estimated: 2 hours

BE-059: Execution Repository
├── File: backend/app/repositories/execution.py
├── Description: Execution CRUD operations
├── Depends On: BE-004, BE-056, BE-057
├── Exports: ExecutionRepository
└── Estimated: 4 hours

BE-060: Claude Code Runner Service
├── File: backend/app/services/claude_runner.py
├── Description: Execute prompts via Claude Code CLI
├── Depends On: BE-002
├── Exports: ClaudeCodeRunner
├── Methods: execute_prompt, check_completion, get_output
└── Estimated: 8 hours

BE-061: Syntax Verifier Service
├── File: backend/app/services/syntax_verifier.py
├── Description: Run dart analyze / python lint
├── Depends On: None
├── Exports: SyntaxVerifier
├── Methods: verify_dart, verify_python, verify_file
└── Estimated: 5 hours

BE-062: Interface Verifier Service
├── File: backend/app/services/interface_verifier.py
├── Description: Check if code implements interface correctly
├── Depends On: None
├── Exports: InterfaceVerifier
├── Methods: verify_exports, verify_methods, verify_implementation
└── Estimated: 6 hours

BE-063: Pattern Verifier Service
├── File: backend/app/services/pattern_verifier.py
├── Description: Check code follows CLAUDE.md patterns
├── Depends On: BE-046
├── Exports: PatternVerifier
├── Methods: verify_patterns, check_naming, check_structure
└── Estimated: 5 hours

BE-064: Verification Orchestrator Service
├── File: backend/app/services/verification_orchestrator.py
├── Description: Run all verifications in sequence
├── Depends On: BE-061, BE-062, BE-063
├── Exports: VerificationOrchestrator
├── Methods: verify_all, get_verification_report
└── Estimated: 4 hours

BE-065: Git Commit Service
├── File: backend/app/services/git_commit.py
├── Description: Stage, commit, push to GitHub
├── Depends On: BE-019
├── Exports: GitCommitService
├── Methods: stage_file, commit, push, get_status
└── Estimated: 5 hours

BE-066: Code Registry Service
├── File: backend/app/services/code_registry.py
├── Description: Update CODE_REGISTRY.md after each task
├── Depends On: BE-019
├── Exports: CodeRegistryService
├── Methods: update_registry, get_registry, add_entry
└── Estimated: 5 hours

BE-067: Execution Engine Service
├── File: backend/app/services/execution_engine.py
├── Description: Orchestrate entire execution flow
├── Depends On: BE-060, BE-064, BE-065, BE-066, BE-059
├── Exports: ExecutionEngine
├── Methods: start_session, execute_next, pause, resume, stop, retry, skip
└── Estimated: 10 hours

BE-068: Execution WebSocket Manager
├── File: backend/app/services/execution_websocket.py
├── Description: Real-time updates via WebSocket
├── Depends On: None
├── Exports: ExecutionWebSocketManager
├── Methods: broadcast, send_to_session, handle_connection
└── Estimated: 5 hours

BE-069: Execution Endpoints
├── File: backend/app/api/v1/endpoints/executions.py
├── Description: Execution API routes
├── Depends On: BE-067, BE-058, BE-010
├── Exports: router
└── Estimated: 5 hours

BE-070: Execution WebSocket Endpoint
├── File: backend/app/api/v1/endpoints/execution_ws.py
├── Description: WebSocket route for real-time updates
├── Depends On: BE-068
├── Exports: websocket_endpoint
└── Estimated: 4 hours

BE-071: Registry Endpoints
├── File: backend/app/api/v1/endpoints/registry.py
├── Description: Code registry API routes
├── Depends On: BE-066, BE-010
├── Exports: router
└── Estimated: 3 hours

BE-072: Execution Migration
├── File: backend/alembic/versions/006_executions.py
├── Description: Create execution tables
├── Depends On: BE-056, BE-057
└── Estimated: 1 hour

BE-073: Background Task Queue
├── File: backend/app/core/task_queue.py
├── Description: Async task queue for execution
├── Depends On: None
├── Exports: TaskQueue, task_queue
└── Estimated: 4 hours

BE-074: Update API Router for Execution
├── File: backend/app/api/v1/router.py (UPDATE)
├── Description: Add execution routes
├── Depends On: BE-069, BE-070, BE-071
└── Estimated: 1 hour
```

#### Frontend (24 tasks)

```
FE-087: Execution Session Entity
├── File: web/lib/features/execution/domain/entities/execution_session.dart
├── Description: Execution session model
├── Depends On: None
├── Exports: ExecutionSession, SessionStatus
└── Estimated: 2 hours

FE-088: Execution Log Entity
├── File: web/lib/features/execution/domain/entities/execution_log.dart
├── Description: Execution log model
├── Depends On: None
├── Exports: ExecutionLog, LogLevel
└── Estimated: 2 hours

FE-089: Execution Repository Interface
├── File: web/lib/features/execution/domain/repositories/execution_repository.dart
├── Description: Abstract execution repository
├── Depends On: FE-008, FE-087, FE-088
├── Exports: ExecutionRepository
└── Estimated: 2 hours

FE-090: Execution Repository Implementation
├── File: web/lib/features/execution/data/repositories/execution_repository_impl.dart
├── Description: Execution API implementation
├── Depends On: FE-009, FE-089
├── Exports: ExecutionRepositoryImpl
└── Estimated: 5 hours

FE-091: WebSocket Service
├── File: web/lib/core/network/websocket_service.dart
├── Description: WebSocket connection management
├── Depends On: FE-010
├── Exports: WebSocketService
└── Estimated: 5 hours

FE-092: Execution Provider
├── File: web/lib/features/execution/presentation/providers/execution_provider.dart
├── Description: Riverpod state for execution
├── Depends On: FE-090, FE-091
├── Exports: executionProvider, ExecutionState
└── Estimated: 6 hours

FE-093: Execution Logs Provider
├── File: web/lib/features/execution/presentation/providers/execution_logs_provider.dart
├── Description: Real-time logs state
├── Depends On: FE-091
├── Exports: executionLogsProvider
└── Estimated: 4 hours

FE-094: Execution Dashboard Screen
├── File: web/lib/features/execution/presentation/screens/execution_dashboard_screen.dart
├── Description: Main execution control screen
├── Depends On: FE-092
├── Exports: ExecutionDashboardScreen
└── Estimated: 6 hours

FE-095: Current Task Card
├── File: web/lib/features/execution/presentation/widgets/current_task_card.dart
├── Description: Shows currently executing task
├── Depends On: FE-092, FE-016
├── Exports: CurrentTaskCard
└── Estimated: 4 hours

FE-096: Execution Progress Bar
├── File: web/lib/features/execution/presentation/widgets/execution_progress_bar.dart
├── Description: Overall progress indicator
├── Depends On: FE-001, FE-092
├── Exports: ExecutionProgressBar
└── Estimated: 3 hours

FE-097: Execution Controls
├── File: web/lib/features/execution/presentation/widgets/execution_controls.dart
├── Description: Start, pause, resume, stop buttons
├── Depends On: FE-012, FE-092
├── Exports: ExecutionControls
└── Estimated: 4 hours

FE-098: Real-Time Log Viewer
├── File: web/lib/features/execution/presentation/widgets/realtime_log_viewer.dart
├── Description: Scrolling log display
├── Depends On: FE-093
├── Exports: RealTimeLogViewer
└── Estimated: 5 hours

FE-099: Task Queue List
├── File: web/lib/features/execution/presentation/widgets/task_queue_list.dart
├── Description: List of pending/completed tasks
├── Depends On: FE-092
├── Exports: TaskQueueList
└── Estimated: 4 hours

FE-100: Task Queue Item
├── File: web/lib/features/execution/presentation/widgets/task_queue_item.dart
├── Description: Single task in queue
├── Depends On: FE-060
├── Exports: TaskQueueItem
└── Estimated: 3 hours

FE-101: Execution Error Dialog
├── File: web/lib/features/execution/presentation/widgets/execution_error_dialog.dart
├── Description: Show error with retry/skip options
├── Depends On: FE-012, FE-013
├── Exports: ExecutionErrorDialog
└── Estimated: 4 hours

FE-102: Verification Results Card
├── File: web/lib/features/execution/presentation/widgets/verification_results_card.dart
├── Description: Show syntax/interface/pattern check results
├── Depends On: FE-016
├── Exports: VerificationResultsCard
└── Estimated: 4 hours

FE-103: Git Status Widget
├── File: web/lib/features/execution/presentation/widgets/git_status_widget.dart
├── Description: Show last commit, push status
├── Depends On: FE-001
├── Exports: GitStatusWidget
└── Estimated: 3 hours

FE-104: Execution History Screen
├── File: web/lib/features/execution/presentation/screens/execution_history_screen.dart
├── Description: Past execution logs
├── Depends On: FE-092
├── Exports: ExecutionHistoryScreen
└── Estimated: 5 hours

FE-105: Execution History Item
├── File: web/lib/features/execution/presentation/widgets/execution_history_item.dart
├── Description: Single history entry
├── Depends On: FE-088, FE-016
├── Exports: ExecutionHistoryItem
└── Estimated: 3 hours

FE-106: Code Registry Screen
├── File: web/lib/features/execution/presentation/screens/code_registry_screen.dart
├── Description: View/edit CODE_REGISTRY.md
├── Depends On: FE-082
├── Exports: CodeRegistryScreen
└── Estimated: 4 hours

FE-107: Generated Files Tree
├── File: web/lib/features/execution/presentation/widgets/generated_files_tree.dart
├── Description: Tree view of generated files
├── Depends On: FE-001
├── Exports: GeneratedFilesTree
└── Estimated: 4 hours

FE-108: Execution Mode Selector
├── File: web/lib/features/execution/presentation/widgets/execution_mode_selector.dart
├── Description: Auto vs Manual mode toggle
├── Depends On: FE-001
├── Exports: ExecutionModeSelector
└── Estimated: 2 hours

FE-109: Session Complete Dialog
├── File: web/lib/features/execution/presentation/widgets/session_complete_dialog.dart
├── Description: Summary when all tasks complete
├── Depends On: FE-012
├── Exports: SessionCompleteDialog
└── Estimated: 3 hours

FE-110: Update Router for Execution
├── File: web/lib/core/router/app_router.dart (UPDATE)
├── Description: Add execution routes
├── Depends On: FE-094, FE-104, FE-106
└── Estimated: 1 hour
```

---

# PHASE 6: AI CONSENSUS
## Multi-AI Review System (Claude + Gemini + GPT)

### API Contract

```yaml
# Consensus API

PUT /api/v1/projects/{project_id}/settings/consensus:
  request:
    enabled: boolean
    reviewers: string[]  # ["gemini", "gpt"]
    min_approval_score: number  # 0-100, default 95
    max_rounds: number  # default 3
    review_mode: string  # "critical_only", "all_business", "everything"
    gemini_api_key: string (encrypted)
    gpt_api_key: string (encrypted)
  response:
    success: boolean

GET /api/v1/projects/{project_id}/settings/consensus:
  response:
    enabled: boolean
    reviewers: string[]
    min_approval_score: number
    max_rounds: number
    review_mode: string
    gemini_connected: boolean
    gpt_connected: boolean

POST /api/v1/projects/{project_id}/consensus/review/{task_id}:
  description: Manually trigger consensus review for a task
  response:
    review_session:
      id: uuid
      task_id: uuid
      round: number
      status: string  # in_progress, approved, rejected, needs_fix

GET /api/v1/projects/{project_id}/consensus/review/{task_id}:
  response:
    review:
      task_id: uuid
      rounds:
        - round: number
          reviews:
            - reviewer: string  # "gemini" or "gpt"
              approval_score: number
              severity: string
              issues: 
                - description: string
                  fix_suggestion: string
              approved: boolean
          consensus_reached: boolean
      final_status: string
      total_rounds: number

# WebSocket for consensus updates
WS /api/v1/projects/{project_id}/consensus/stream:
  messages:
    - type: "review_started"
      data: { task_id, reviewer }
    - type: "review_complete"
      data: { task_id, reviewer, score, issues }
    - type: "consensus_reached"
      data: { task_id, approved }
    - type: "fix_required"
      data: { task_id, issues }
```

### Tasks

#### Backend (12 tasks)

```
BE-075: Consensus Settings Model
├── File: backend/app/models/consensus_settings.py
├── Description: Store consensus configuration per project
├── Depends On: BE-001, BE-016
├── Exports: ConsensusSettings
└── Estimated: 2 hours

BE-076: Consensus Review Model
├── File: backend/app/models/consensus_review.py
├── Description: Store review results
├── Depends On: BE-001, BE-025
├── Exports: ConsensusReview, ReviewRound
└── Estimated: 3 hours

BE-077: Consensus Schemas
├── File: backend/app/schemas/consensus.py
├── Description: Pydantic schemas for consensus
├── Depends On: None
├── Exports: ConsensusSettingsRequest, ConsensusReviewResponse
└── Estimated: 2 hours

BE-078: Consensus Repository
├── File: backend/app/repositories/consensus.py
├── Description: Consensus CRUD operations
├── Depends On: BE-004, BE-075, BE-076
├── Exports: ConsensusRepository
└── Estimated: 3 hours

BE-079: Gemini Review Service
├── File: backend/app/services/gemini_reviewer.py
├── Description: Gemini API integration for code review
├── Depends On: BE-046
├── Exports: GeminiReviewer
├── Methods: review_code, parse_response
└── Estimated: 6 hours

BE-080: GPT Review Service
├── File: backend/app/services/gpt_reviewer.py
├── Description: GPT API integration for code review
├── Depends On: BE-046
├── Exports: GPTReviewer
├── Methods: review_code, parse_response
└── Estimated: 6 hours

BE-081: Consensus Engine Service
├── File: backend/app/services/consensus_engine.py
├── Description: Orchestrate multi-AI review
├── Depends On: BE-079, BE-080, BE-078
├── Exports: ConsensusEngine
├── Methods: run_consensus, check_approval, request_fix
└── Estimated: 8 hours

BE-082: Review Prompt Builder Service
├── File: backend/app/services/review_prompt_builder.py
├── Description: Build review prompts with full context
├── Depends On: BE-047
├── Exports: ReviewPromptBuilder
└── Estimated: 5 hours

BE-083: Consensus Endpoints
├── File: backend/app/api/v1/endpoints/consensus.py
├── Description: Consensus API routes
├── Depends On: BE-081, BE-077, BE-010
├── Exports: router
└── Estimated: 4 hours

BE-084: Consensus WebSocket
├── File: backend/app/api/v1/endpoints/consensus_ws.py
├── Description: WebSocket for real-time review updates
├── Depends On: BE-081
├── Exports: consensus_websocket
└── Estimated: 3 hours

BE-085: Consensus Migration
├── File: backend/alembic/versions/007_consensus.py
├── Description: Create consensus tables
├── Depends On: BE-075, BE-076
└── Estimated: 1 hour

BE-086: Update API Router for Consensus
├── File: backend/app/api/v1/router.py (UPDATE)
├── Description: Add consensus routes
├── Depends On: BE-083, BE-084
└── Estimated: 1 hour
```

#### Frontend (14 tasks)

```
FE-111: Consensus Settings Entity
├── File: web/lib/features/consensus/domain/entities/consensus_settings.dart
├── Description: Consensus settings model
├── Depends On: None
├── Exports: ConsensusSettings, ReviewMode
└── Estimated: 2 hours

FE-112: Consensus Review Entity
├── File: web/lib/features/consensus/domain/entities/consensus_review.dart
├── Description: Review result model
├── Depends On: None
├── Exports: ConsensusReview, ReviewRound, AIReview
└── Estimated: 2 hours

FE-113: Consensus Repository Interface
├── File: web/lib/features/consensus/domain/repositories/consensus_repository.dart
├── Description: Abstract consensus repository
├── Depends On: FE-008, FE-111, FE-112
├── Exports: ConsensusRepository
└── Estimated: 2 hours

FE-114: Consensus Repository Implementation
├── File: web/lib/features/consensus/data/repositories/consensus_repository_impl.dart
├── Description: Consensus API implementation
├── Depends On: FE-009, FE-113
├── Exports: ConsensusRepositoryImpl
└── Estimated: 4 hours

FE-115: Consensus Provider
├── File: web/lib/features/consensus/presentation/providers/consensus_provider.dart
├── Description: Riverpod state for consensus
├── Depends On: FE-114
├── Exports: consensusProvider
└── Estimated: 4 hours

FE-116: Consensus Settings Screen
├── File: web/lib/features/consensus/presentation/screens/consensus_settings_screen.dart
├── Description: Configure AI reviewers
├── Depends On: FE-115
├── Exports: ConsensusSettingsScreen
└── Estimated: 5 hours

FE-117: API Key Input Widget
├── File: web/lib/features/consensus/presentation/widgets/api_key_input.dart
├── Description: Secure API key input
├── Depends On: FE-015
├── Exports: ApiKeyInput
└── Estimated: 3 hours

FE-118: Reviewer Toggle Widget
├── File: web/lib/features/consensus/presentation/widgets/reviewer_toggle.dart
├── Description: Enable/disable each reviewer
├── Depends On: FE-001
├── Exports: ReviewerToggle
└── Estimated: 2 hours

FE-119: Consensus Status Card
├── File: web/lib/features/consensus/presentation/widgets/consensus_status_card.dart
├── Description: Show review status in execution
├── Depends On: FE-016, FE-112
├── Exports: ConsensusStatusCard
└── Estimated: 4 hours

FE-120: AI Review Result Card
├── File: web/lib/features/consensus/presentation/widgets/ai_review_result_card.dart
├── Description: Single AI's review result
├── Depends On: FE-016
├── Exports: AIReviewResultCard
└── Estimated: 4 hours

FE-121: Review Issues List
├── File: web/lib/features/consensus/presentation/widgets/review_issues_list.dart
├── Description: List of issues from review
├── Depends On: FE-001
├── Exports: ReviewIssuesList
└── Estimated: 3 hours

FE-122: Consensus Round Timeline
├── File: web/lib/features/consensus/presentation/widgets/consensus_round_timeline.dart
├── Description: Visual timeline of review rounds
├── Depends On: FE-001
├── Exports: ConsensusRoundTimeline
└── Estimated: 4 hours

FE-123: Approval Score Gauge
├── File: web/lib/features/consensus/presentation/widgets/approval_score_gauge.dart
├── Description: Visual score indicator
├── Depends On: FE-001
├── Exports: ApprovalScoreGauge
└── Estimated: 3 hours

FE-124: Update Router for Consensus
├── File: web/lib/core/router/app_router.dart (UPDATE)
├── Description: Add consensus routes
├── Depends On: FE-116
└── Estimated: 1 hour
```

---

# PHASE 7: POLISH
## Settings, Analytics, Help, Final Touches

### Tasks

#### Backend (8 tasks)

```
BE-087: User Settings Model
├── File: backend/app/models/user_settings.py
├── Description: User preferences
├── Depends On: BE-001, BE-006
├── Exports: UserSettings
└── Estimated: 2 hours

BE-088: Analytics Service
├── File: backend/app/services/analytics.py
├── Description: Calculate project statistics
├── Depends On: BE-029, BE-059
├── Exports: AnalyticsService
├── Methods: get_project_stats, get_execution_stats, get_success_rate
└── Estimated: 5 hours

BE-089: Export Service
├── File: backend/app/services/export.py
├── Description: Export project data
├── Depends On: BE-018, BE-029, BE-045
├── Exports: ExportService
├── Methods: export_project, export_prompts, export_logs
└── Estimated: 4 hours

BE-090: Settings Endpoints
├── File: backend/app/api/v1/endpoints/settings.py
├── Description: User settings API
├── Depends On: BE-087, BE-010
├── Exports: router
└── Estimated: 3 hours

BE-091: Analytics Endpoints
├── File: backend/app/api/v1/endpoints/analytics.py
├── Description: Analytics API
├── Depends On: BE-088, BE-010
├── Exports: router
└── Estimated: 3 hours

BE-092: Export Endpoints
├── File: backend/app/api/v1/endpoints/export.py
├── Description: Export API
├── Depends On: BE-089, BE-010
├── Exports: router
└── Estimated: 2 hours

BE-093: Settings Migration
├── File: backend/alembic/versions/008_settings.py
├── Description: Create settings table
├── Depends On: BE-087
└── Estimated: 1 hour

BE-094: Final API Router Update
├── File: backend/app/api/v1/router.py (UPDATE)
├── Description: Add all remaining routes
├── Depends On: BE-090, BE-091, BE-092
└── Estimated: 1 hour
```

#### Frontend (12 tasks)

```
FE-125: Settings Screen
├── File: web/lib/features/settings/presentation/screens/settings_screen.dart
├── Description: User preferences
├── Depends On: FE-015, FE-012
├── Exports: SettingsScreen
└── Estimated: 5 hours

FE-126: Theme Selector
├── File: web/lib/features/settings/presentation/widgets/theme_selector.dart
├── Description: Light/Dark mode toggle
├── Depends On: FE-001
├── Exports: ThemeSelector
└── Estimated: 2 hours

FE-127: Analytics Dashboard Screen
├── File: web/lib/features/analytics/presentation/screens/analytics_dashboard_screen.dart
├── Description: Project statistics
├── Depends On: FE-016
├── Exports: AnalyticsDashboardScreen
└── Estimated: 6 hours

FE-128: Stats Card Widget
├── File: web/lib/features/analytics/presentation/widgets/stats_card.dart
├── Description: Single statistic card
├── Depends On: FE-016
├── Exports: StatsCard
└── Estimated: 2 hours

FE-129: Success Rate Chart
├── File: web/lib/features/analytics/presentation/widgets/success_rate_chart.dart
├── Description: Pie/bar chart of success rate
├── Depends On: FE-001
├── Exports: SuccessRateChart
└── Estimated: 4 hours

FE-130: Execution Timeline Chart
├── File: web/lib/features/analytics/presentation/widgets/execution_timeline_chart.dart
├── Description: Timeline of executions
├── Depends On: FE-001
├── Exports: ExecutionTimelineChart
└── Estimated: 4 hours

FE-131: Help Screen
├── File: web/lib/features/help/presentation/screens/help_screen.dart
├── Description: Documentation and help
├── Depends On: FE-016
├── Exports: HelpScreen
└── Estimated: 4 hours

FE-132: Help Article Widget
├── File: web/lib/features/help/presentation/widgets/help_article.dart
├── Description: Single help article
├── Depends On: FE-001
├── Exports: HelpArticle
└── Estimated: 2 hours

FE-133: Keyboard Shortcuts Widget
├── File: web/lib/core/widgets/keyboard_shortcuts.dart
├── Description: Show available shortcuts
├── Depends On: FE-001
├── Exports: KeyboardShortcuts
└── Estimated: 2 hours

FE-134: App Drawer/Sidebar
├── File: web/lib/core/widgets/app_drawer.dart
├── Description: Navigation sidebar
├── Depends On: FE-001, FE-006
├── Exports: AppDrawer
└── Estimated: 4 hours

FE-135: User Profile Menu
├── File: web/lib/core/widgets/user_profile_menu.dart
├── Description: User dropdown menu
├── Depends On: FE-023
├── Exports: UserProfileMenu
└── Estimated: 3 hours

FE-136: Final Router Update
├── File: web/lib/core/router/app_router.dart (UPDATE)
├── Description: Add all remaining routes
├── Depends On: FE-125, FE-127, FE-131
└── Estimated: 2 hours
```

---

# SUMMARY

## Total Tasks by Phase

| Phase | Backend | Frontend | Total |
|-------|---------|----------|-------|
| 1. Foundation | 15 | 27 | 42 |
| 2. Projects | 8 | 16 | 24 |
| 3. WBS Builder | 17 | 26 | 43 |
| 4. Prompts | 15 | 17 | 32 |
| 5. Execution | 19 | 24 | 43 |
| 6. Consensus | 12 | 14 | 26 |
| 7. Polish | 8 | 12 | 20 |
| **TOTAL** | **94** | **136** | **230** |

## Estimated Timeline

| Phase | Duration |
|-------|----------|
| Phase 1 | 5-7 days |
| Phase 2 | 3-4 days |
| Phase 3 | 5-7 days |
| Phase 4 | 4-5 days |
| Phase 5 | 5-7 days |
| Phase 6 | 3-4 days |
| Phase 7 | 2-3 days |
| **TOTAL** | **27-37 days** |

*With AI generating code using our system, actual time could be significantly less.*

---

# EXECUTION ORDER

The prompts should be executed in this order:

```
1. BE-001 through BE-015 (Backend Foundation)
2. FE-001 through FE-019 (Frontend Design System + Components)
3. FE-020 through FE-027 (Frontend Auth)
4. BE-016 through BE-023 (Backend Projects)
5. FE-028 through FE-043 (Frontend Projects)
6. BE-024 through BE-040 (Backend WBS)
7. FE-044 through FE-069 (Frontend WBS)
8. BE-041 through BE-055 (Backend Prompts)
9. FE-070 through FE-086 (Frontend Prompts)
10. BE-056 through BE-074 (Backend Execution)
11. FE-087 through FE-110 (Frontend Execution)
12. BE-075 through BE-086 (Backend Consensus)
13. FE-111 through FE-124 (Frontend Consensus)
14. BE-087 through BE-094 (Backend Polish)
15. FE-125 through FE-136 (Frontend Polish)
```

---

# FILES TO CREATE FIRST

Before any code generation:

1. `CLAUDE.md` - Code standards (already created)
2. `DESIGN_SYSTEM.md` - Design standards (already created)
3. `CODE_REGISTRY.md` - Empty template (already created)
4. `API_CONTRACTS.md` - All API contracts (in this document)

---

# THIS IS THE GOLDEN BULLET

With this WBS:
- 230 atomic tasks
- Clear dependencies
- API contracts defined
- Build order specified
- Each task = 1 file = 1 prompt

Execute prompts 1-by-1 → Complete app in GitHub
