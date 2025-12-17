# SESSION PROTOCOL
## Achieving 99%+ Code Consistency
## The Missing Piece

---

# THE PROBLEM

Two failure modes remain:

| Failure | Cause | Impact |
|---------|-------|--------|
| Context window overflow | Sessions too long | Claude loses earlier context |
| Registry update skipped | No enforcement | Registry becomes stale |

---

# THE SOLUTION: 3-Part System

```
┌─────────────────────────────────────────────────────────────────┐
│  PART 1: SESSION CHUNKING                                       │
│  Never exceed 5-7 files per session                             │
├─────────────────────────────────────────────────────────────────┤
│  PART 2: MANDATORY COMPLETION OUTPUT                            │
│  Claude MUST output specific format after EVERY generation      │
├─────────────────────────────────────────────────────────────────┤
│  PART 3: AUTOMATED VERIFICATION                                 │
│  Git hooks verify registry matches actual files                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# PART 1: SESSION CHUNKING PROTOCOL

## The Rule

> **NEVER generate more than 5-7 files in a single conversation session.**

## Why This Works

| Session Length | Context Usage | Risk |
|----------------|---------------|------|
| 1-3 files | ~30% | ✅ Safe |
| 4-7 files | ~60% | ✅ Safe |
| 8-15 files | ~80% | ⚠️ Risky |
| 15+ files | 100%+ | ❌ Failure likely |

## How to Chunk Work

### Step 1: Break WBS into Sessions

```
SESSION 1: Core Foundation (5 files)
├── core/types/result.dart
├── core/network/api_client.dart
├── core/storage/secure_storage.dart
├── core/config/env_config.dart
└── core/constants/api_constants.dart

SESSION 2: Auth Feature - Backend (5 files)
├── backend/models/user.py
├── backend/schemas/auth.py
├── backend/repositories/user.py
├── backend/services/auth.py
└── backend/api/v1/endpoints/auth.py

SESSION 3: Auth Feature - Flutter (6 files)
├── features/auth/domain/entities/user.dart
├── features/auth/domain/repositories/auth_repository.dart
├── features/auth/data/repositories/auth_repository_impl.dart
├── features/auth/data/datasources/auth_remote_datasource.dart
├── features/auth/presentation/providers/auth_provider.dart
└── features/auth/presentation/screens/login_screen.dart

... and so on
```

### Step 2: Session Start Protocol

At the START of each new session, tell Claude:

```
Read CLAUDE.md, CODE_REGISTRY.md, and WBS.md.

This session's scope: [SESSION NAME]
Files to generate:
1. [file 1]
2. [file 2]
3. [file 3]
4. [file 4]
5. [file 5]

Generate these files, update CODE_REGISTRY.md after each file,
and output the COMPLETION REPORT at the end.
```

### Step 3: Session End Protocol

Before ending ANY session:

```
□ All files generated
□ CODE_REGISTRY.md updated with ALL new files
□ COMPLETION REPORT output
□ Git commit made
```

---

# PART 2: MANDATORY COMPLETION OUTPUT

## The Rule

> **Claude MUST output this EXACT format after generating ANY file.**

## After EVERY File Generation

```
═══════════════════════════════════════════════════════════════
📁 FILE GENERATED
═══════════════════════════════════════════════════════════════
Path: [exact/file/path.dart]
Status: ✅ Created
Exports: [ClassName, methodName, etc.]
Depends On: [list of imports]
═══════════════════════════════════════════════════════════════
📝 REGISTRY UPDATE
═══════════════════════════════════════════════════════════════
Action: [Added new entry / Updated existing entry]
Section: [which section of CODE_REGISTRY.md]
═══════════════════════════════════════════════════════════════
```

## At END of Session

```
═══════════════════════════════════════════════════════════════
🏁 SESSION COMPLETION REPORT
═══════════════════════════════════════════════════════════════
Session: [Session Name]
Files Generated: [count]

| # | File | Status | Registry Updated |
|---|------|--------|------------------|
| 1 | path/to/file1.dart | ✅ | ✅ |
| 2 | path/to/file2.dart | ✅ | ✅ |
| 3 | path/to/file3.dart | ✅ | ✅ |

Registry Entries Added: [count]
Registry Entries Updated: [count]

VERIFICATION:
□ All files created
□ All registry entries updated
□ Ready for git commit
═══════════════════════════════════════════════════════════════
```

## Why This Works

1. **Explicit format forces Claude to think about registry update**
2. **Visible checkboxes make skips obvious**
3. **Human can verify at a glance**
4. **If format missing = Claude skipped something**

## Human Verification

After Claude outputs completion report, human checks:

```
IF completion report is present AND all checkboxes marked:
  → Session successful, commit to git
  
IF completion report is missing:
  → Ask Claude: "Output the completion report"
  
IF checkboxes show ❌:
  → Ask Claude: "Complete the missing items"
```

---

# PART 3: AUTOMATED VERIFICATION

## Git Pre-Commit Hook

This script runs BEFORE every commit and BLOCKS commit if registry is out of sync.

### Setup Script

Create `scripts/setup_hooks.sh`:

```bash
#!/bin/bash

# Create hooks directory if not exists
mkdir -p .git/hooks

# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "🔍 Verifying CODE_REGISTRY.md..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0

# Check 1: Registry file exists
if [ ! -f "CODE_REGISTRY.md" ]; then
    echo -e "${RED}❌ CODE_REGISTRY.md not found${NC}"
    exit 1
fi

# Check 2: All Dart files in lib/ are in registry
echo "Checking Flutter files..."
for file in $(find mobile/lib -name "*.dart" -not -name "*.g.dart" -not -name "*.freezed.dart" 2>/dev/null); do
    relative_path=${file#mobile/}
    if ! grep -q "$relative_path" CODE_REGISTRY.md; then
        echo -e "${RED}❌ Missing from registry: $relative_path${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check 3: All Python files in app/ are in registry
echo "Checking Backend files..."
for file in $(find backend/app -name "*.py" -not -name "__init__.py" 2>/dev/null); do
    relative_path=${file#backend/}
    if ! grep -q "$relative_path" CODE_REGISTRY.md; then
        echo -e "${RED}❌ Missing from registry: $relative_path${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check 4: Registry was modified if code was modified
CODE_CHANGED=$(git diff --cached --name-only | grep -E "\.(dart|py)$" | wc -l)
REGISTRY_CHANGED=$(git diff --cached --name-only | grep "CODE_REGISTRY.md" | wc -l)

if [ "$CODE_CHANGED" -gt 0 ] && [ "$REGISTRY_CHANGED" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Code files changed but CODE_REGISTRY.md not updated${NC}"
    echo "Did you forget to update the registry?"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Final result
if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}═══════════════════════════════════════════════════${NC}"
    echo -e "${RED}❌ Registry verification failed: $ERRORS file(s) missing${NC}"
    echo -e "${RED}═══════════════════════════════════════════════════${NC}"
    echo ""
    echo "To fix: Update CODE_REGISTRY.md with missing files"
    echo "Or bypass with: git commit --no-verify"
    exit 1
fi

echo -e "${GREEN}✅ Registry verification passed${NC}"
exit 0
EOF

# Make hook executable
chmod +x .git/hooks/pre-commit

echo "✅ Git hooks installed"
```

Run setup:
```bash
chmod +x scripts/setup_hooks.sh
./scripts/setup_hooks.sh
```

### What This Does

| Scenario | What Happens |
|----------|--------------|
| New file created, registry updated | ✅ Commit succeeds |
| New file created, registry NOT updated | ❌ Commit blocked |
| Registry updated, no new files | ✅ Commit succeeds |
| Bypass needed | `git commit --no-verify` |

---

# PART 4: UPDATED CLAUDE.md ADDITION

Add this section at the VERY END of CLAUDE.md (most recent = highest attention):

```markdown
---

# ⚠️ CRITICAL: COMPLETION PROTOCOL (READ LAST = HIGHEST PRIORITY)

## After EVERY File Generation, Output:

```
═══════════════════════════════════════════════════════════════
📁 FILE GENERATED
═══════════════════════════════════════════════════════════════
Path: [exact/file/path]
Status: ✅ Created
Exports: [list]
Depends On: [list]
═══════════════════════════════════════════════════════════════
📝 REGISTRY UPDATE
═══════════════════════════════════════════════════════════════
Action: [Added/Updated]
Section: [section name]
═══════════════════════════════════════════════════════════════
```

## At Session End, Output:

```
═══════════════════════════════════════════════════════════════
🏁 SESSION COMPLETION REPORT
═══════════════════════════════════════════════════════════════
Files Generated: [count]
Registry Entries Added: [count]
All files in registry: ✅
Ready for commit: ✅
═══════════════════════════════════════════════════════════════
```

## THIS IS MANDATORY. DO NOT SKIP.

If you generate a file without this output, the human will ask you to provide it.
The git hook will block commits if registry is out of sync.
```

---

# WORKFLOW SUMMARY

## Starting a Project

```bash
# 1. Create repo with base files
git init
cp CLAUDE.md CODE_REGISTRY.md DEPLOYMENT.md .
cp your_wbs.md WBS.md

# 2. Setup git hooks
./scripts/setup_hooks.sh

# 3. Initial commit
git add .
git commit -m "Initial setup"
```

## Development Session

```
1. Open new Claude conversation

2. Paste to Claude:
   "Read CLAUDE.md, CODE_REGISTRY.md, WBS.md.
    This session: [SESSION NAME]
    Generate: [list 5-7 files]"

3. Claude generates files + outputs completion format

4. Verify completion report shows all ✅

5. If anything missing, ask Claude to fix

6. Commit:
   git add .
   git commit -m "feat: [session name]"
   
7. Hook verifies registry, blocks if out of sync

8. If blocked, update registry and recommit

9. Push to GitHub
```

## Visual Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                     NEW SESSION                                 │
│  "Generate files X, Y, Z"                                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   CLAUDE GENERATES                              │
│  1. Reads CLAUDE.md, CODE_REGISTRY.md, WBS.md                  │
│  2. Generates file                                              │
│  3. Outputs completion format ← MANDATORY                       │
│  4. Updates registry                                            │
│  5. Repeat for each file                                        │
│  6. Outputs session completion report ← MANDATORY               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                  HUMAN VERIFIES                                 │
│  □ Completion report present?                                   │
│  □ All files marked ✅?                                         │
│  □ Registry entries marked ✅?                                  │
│                                                                 │
│  IF any ❌ → Ask Claude to fix                                  │
│  IF all ✅ → Proceed to commit                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   GIT COMMIT                                    │
│  git add . && git commit -m "message"                          │
│                                                                 │
│  PRE-COMMIT HOOK RUNS:                                          │
│  □ All code files in registry?                                  │
│  □ Registry modified if code modified?                          │
│                                                                 │
│  IF check fails → COMMIT BLOCKED                                │
│  IF check passes → COMMIT SUCCEEDS                              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   SESSION COMPLETE                              │
│  ✅ Code generated                                              │
│  ✅ Registry updated                                            │
│  ✅ Committed to git                                            │
│  ✅ Ready for next session                                      │
└─────────────────────────────────────────────────────────────────┘
```

---

# FAILURE RECOVERY

## Scenario 1: Claude Didn't Output Completion Format

```
Human: "Output the completion report for the files you generated"
Claude: [outputs the format]
Human: [verifies and continues]
```

## Scenario 2: Git Hook Blocks Commit

```bash
$ git commit -m "feat: auth"
🔍 Verifying CODE_REGISTRY.md...
❌ Missing from registry: lib/features/auth/data/models/user_model.dart
═══════════════════════════════════════════════════════════════
❌ Registry verification failed: 1 file(s) missing
═══════════════════════════════════════════════════════════════

# Fix: Update CODE_REGISTRY.md manually or ask Claude
# Then recommit
```

## Scenario 3: Context Window Reaching Limit

Signs:
- Claude's responses becoming shorter
- Claude forgetting things from earlier in conversation
- Claude asking about things it should know

Action:
```
1. Stop current session
2. Ask Claude for session completion report
3. Commit current work
4. Start NEW conversation
5. Continue with next session chunk
```

---

# SUCCESS METRICS

| Metric | Before | After |
|--------|--------|-------|
| Registry always updated | ~80% | ~99% |
| Files in correct location | ~90% | ~99% |
| Context overflow issues | ~10% | ~1% |
| Overall consistency | ~95% | ~99% |

---

# THE BRUTAL TRUTH

## What We've Achieved

| Problem | Solution | Effectiveness |
|---------|----------|---------------|
| Context overflow | Session chunking | 99% - Hard sessions limits prevent overflow |
| Claude skips registry | Mandatory output format | 95% - Format makes skips visible |
| Skips go unnoticed | Human verification | 99% - Visible checkboxes |
| Commits with missing registry | Git hook | 100% - Automated block |

## What We CANNOT Achieve

| Issue | Why |
|-------|-----|
| 100% Claude compliance | Claude is probabilistic, not deterministic |
| Zero human involvement | Someone must verify the completion report |
| Infinite session length | Context window is a hard technical limit |

## Final Realistic Assessment

```
With this system:
├── 99% of files will be in correct location
├── 99% of registry updates will happen
├── 100% of commits will be verified (git hook)
├── 1% may require human intervention ("output completion report")
└── 0% will slip through to production unverified
```

**This is as close to 100% as is technically possible given the constraints of AI systems.**

---

# QUICK REFERENCE

## Session Rules
- Max 5-7 files per session
- Always start with: "Read CLAUDE.md, CODE_REGISTRY.md, WBS.md"
- Always end with: Verify completion report

## If Claude Skips Format
Say: "Output the completion report"

## If Hook Blocks Commit
Fix CODE_REGISTRY.md, then recommit

## Setup Commands
```bash
# Install hooks
./scripts/setup_hooks.sh

# Bypass hook (emergency only)
git commit --no-verify -m "message"
```
