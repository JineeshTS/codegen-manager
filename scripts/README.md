# Prompt Generator for CodeGen Manager

Generates complete, self-contained prompts for each task in the WBS.

## Setup

1. Upload these files to your GitHub repo under `scripts/`:
   - `generate_prompt.py`
   - `tasks.json`
   - `README.md`

2. Your repo structure should look like:
   ```
   codegen-manager/
   ├── CLAUDE.md
   ├── DESIGN_SYSTEM.md
   ├── CODE_REGISTRY.md
   ├── scripts/
   │   ├── generate_prompt.py
   │   ├── tasks.json
   │   └── README.md
   ├── backend/
   └── web/
   ```

## Usage in Claude Code Web

### Option 1: Let Claude Read Tasks Directly

Just tell Claude:
```
Read scripts/tasks.json and complete task BE-001. 
Follow all standards in CLAUDE.md.
After completing, update CODE_REGISTRY.md and commit.
```

### Option 2: Generate Prompt First

```
Run: python scripts/generate_prompt.py BE-001 --print
Then execute the generated prompt.
```

### Option 3: Batch Mode

```
Run: python scripts/generate_prompt.py --next
This shows the next task to work on based on dependencies.
```

## Commands

```bash
# Show next pending task
python scripts/generate_prompt.py --next

# List all tasks
python scripts/generate_prompt.py --list

# List tasks for specific phase
python scripts/generate_prompt.py --list --phase 1

# Generate prompt for specific task
python scripts/generate_prompt.py BE-001

# Print prompt to screen (don't save file)
python scripts/generate_prompt.py BE-001 --print

# Mark task as complete
python scripts/generate_prompt.py --complete BE-001
```

## Task Workflow

For each task:

1. **Get the task:**
   ```
   python scripts/generate_prompt.py --next
   ```

2. **Complete the task:**
   Tell Claude Code: "Complete task BE-001 from scripts/tasks.json"

3. **Verify:**
   - File created at correct path
   - All exports present
   - No syntax errors

4. **Update registry:**
   Add entry to CODE_REGISTRY.md

5. **Commit:**
   ```
   git add . && git commit -m "BE-001: Task name" && git push
   ```

6. **Mark complete:**
   ```
   python scripts/generate_prompt.py --complete BE-001
   ```

## Task Structure (tasks.json)

```json
{
  "BE-001": {
    "name": "Database Configuration",
    "description": "SQLAlchemy async engine...",
    "phase": 1,
    "platform": "backend",
    "layer": "core",
    "output_path": "backend/app/core/database.py",
    "depends_on": [],
    "exports": ["engine", "async_session", "Base", "get_db"],
    "status": "pending",
    "detailed_requirements": "Full task details..."
  }
}
```

## Phase 1 Tasks (42 total)

### Backend (BE-001 to BE-015)
| ID | Name | Dependencies |
|----|------|--------------|
| BE-001 | Database Configuration | - |
| BE-002 | Settings Configuration | - |
| BE-003 | Security Utilities | BE-002 |
| BE-004 | Base Repository | BE-001 |
| BE-005 | Exception Handlers | - |
| BE-006 | User Model | BE-001 |
| BE-007 | Auth Schemas | - |
| BE-008 | User Repository | BE-004, BE-006 |
| BE-009 | Auth Service | BE-003, BE-008 |
| BE-010 | Auth Dependencies | BE-009 |
| BE-011 | Auth Endpoints | BE-009, BE-010, BE-007 |
| BE-012 | API Router Setup | BE-011 |
| BE-013 | App Factory | BE-012, BE-005 |
| BE-014 | Alembic Setup | BE-001, BE-006 |
| BE-015 | Initial Migration | BE-014 |

### Frontend (FE-001 to FE-027)
| ID | Name | Dependencies |
|----|------|--------------|
| FE-001 | App Colors | - |
| FE-002 | App Typography | FE-001 |
| FE-003 | App Spacing | - |
| FE-004 | App Radius | - |
| FE-005 | App Shadows | - |
| FE-006 | App Icons | - |
| FE-007 | App Theme | FE-001, FE-002, FE-003, FE-004 |
| FE-008 | Result Type | - |
| FE-009 | API Client | FE-008 |
| FE-010 | Secure Storage | - |
| FE-011 | Environment Config | - |
| FE-012 | Primary Button | FE-001, FE-002, FE-004 |
| FE-013 | Secondary Button | FE-001, FE-002, FE-004 |
| FE-014 | Text Button | FE-001, FE-002 |
| FE-015 | App Text Field | FE-001, FE-002, FE-004 |
| FE-016 | App Card | FE-001, FE-004, FE-005 |
| FE-017 | Loading Indicator | FE-001 |
| FE-018 | Empty State | FE-001, FE-002, FE-006 |
| FE-019 | Error State | FE-001, FE-002, FE-012 |
| FE-020 | User Entity | - |
| FE-021 | Auth Repository Interface | FE-008, FE-020 |
| FE-022 | Auth Repository Implementation | FE-009, FE-010, FE-021 |
| FE-023 | Auth Provider | FE-022 |
| FE-024 | Login Screen | FE-012, FE-015, FE-023 |
| FE-025 | Register Screen | FE-012, FE-015, FE-023 |
| FE-026 | App Router | FE-023, FE-024, FE-025 |
| FE-027 | App Entry Point | FE-007, FE-026 |
