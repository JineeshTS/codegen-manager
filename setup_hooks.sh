#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# SETUP SCRIPT: Git Hooks for Code Registry Verification
# Run this ONCE when setting up a new project
# ═══════════════════════════════════════════════════════════════

echo "🔧 Setting up Git hooks for registry verification..."

# Create scripts directory if not exists
mkdir -p scripts

# Create hooks directory if not exists
mkdir -p .git/hooks

# ═══════════════════════════════════════════════════════════════
# PRE-COMMIT HOOK
# Verifies CODE_REGISTRY.md is in sync with actual files
# ═══════════════════════════════════════════════════════════════

cat > .git/hooks/pre-commit << 'HOOK_EOF'
#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# PRE-COMMIT HOOK: Registry Verification
# Blocks commits if CODE_REGISTRY.md is out of sync
# ═══════════════════════════════════════════════════════════════

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "🔍 Verifying CODE_REGISTRY.md..."
echo "═══════════════════════════════════════════════════════════════"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# ─────────────────────────────────────────────────────────────────
# Check 1: Registry file exists
# ─────────────────────────────────────────────────────────────────
echo -e "${BLUE}[1/4]${NC} Checking registry exists..."

if [ ! -f "CODE_REGISTRY.md" ]; then
    echo -e "${RED}❌ CODE_REGISTRY.md not found${NC}"
    echo "Create CODE_REGISTRY.md before committing"
    exit 1
fi
echo -e "${GREEN}  ✓ CODE_REGISTRY.md found${NC}"

# ─────────────────────────────────────────────────────────────────
# Check 2: Flutter files (if mobile/ exists)
# ─────────────────────────────────────────────────────────────────
if [ -d "mobile/lib" ]; then
    echo -e "${BLUE}[2/4]${NC} Checking Flutter files..."
    
    FLUTTER_FILES=$(find mobile/lib -name "*.dart" \
        -not -name "*.g.dart" \
        -not -name "*.freezed.dart" \
        -not -path "*/generated/*" \
        2>/dev/null)
    
    for file in $FLUTTER_FILES; do
        # Get relative path from mobile/
        relative_path=${file#mobile/}
        
        # Check if file path exists in registry
        if ! grep -q "$relative_path" CODE_REGISTRY.md 2>/dev/null; then
            echo -e "${RED}  ❌ Missing: $relative_path${NC}"
            ERRORS=$((ERRORS + 1))
        fi
    done
    
    if [ $ERRORS -eq 0 ]; then
        echo -e "${GREEN}  ✓ All Flutter files in registry${NC}"
    fi
else
    echo -e "${BLUE}[2/4]${NC} Skipping Flutter check (no mobile/lib folder)"
fi

# ─────────────────────────────────────────────────────────────────
# Check 3: Backend files (if backend/ exists)
# ─────────────────────────────────────────────────────────────────
if [ -d "backend/app" ]; then
    echo -e "${BLUE}[3/4]${NC} Checking Backend files..."
    
    BACKEND_FILES=$(find backend/app -name "*.py" \
        -not -name "__init__.py" \
        -not -name "__pycache__" \
        -not -path "*/__pycache__/*" \
        2>/dev/null)
    
    for file in $BACKEND_FILES; do
        # Get relative path from backend/
        relative_path=${file#backend/}
        
        # Check if file path exists in registry
        if ! grep -q "$relative_path" CODE_REGISTRY.md 2>/dev/null; then
            echo -e "${RED}  ❌ Missing: $relative_path${NC}"
            ERRORS=$((ERRORS + 1))
        fi
    done
    
    if [ $ERRORS -eq 0 ]; then
        echo -e "${GREEN}  ✓ All Backend files in registry${NC}"
    fi
else
    echo -e "${BLUE}[3/4]${NC} Skipping Backend check (no backend/app folder)"
fi

# ─────────────────────────────────────────────────────────────────
# Check 4: Registry updated when code changed
# ─────────────────────────────────────────────────────────────────
echo -e "${BLUE}[4/4]${NC} Checking registry was updated..."

# Count staged code files
CODE_CHANGED=$(git diff --cached --name-only 2>/dev/null | grep -E "\.(dart|py)$" | grep -v "\.g\.dart$" | grep -v "\.freezed\.dart$" | wc -l)

# Check if registry is staged
REGISTRY_CHANGED=$(git diff --cached --name-only 2>/dev/null | grep "CODE_REGISTRY.md" | wc -l)

if [ "$CODE_CHANGED" -gt 0 ] && [ "$REGISTRY_CHANGED" -eq 0 ]; then
    echo -e "${YELLOW}  ⚠️  Code changed but CODE_REGISTRY.md not staged${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

if [ "$WARNINGS" -eq 0 ] && [ "$ERRORS" -eq 0 ]; then
    echo -e "${GREEN}  ✓ Registry properly updated${NC}"
fi

# ─────────────────────────────────────────────────────────────────
# Final Result
# ─────────────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════════════════════════"

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}❌ COMMIT BLOCKED: $ERRORS file(s) missing from registry${NC}"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "To fix:"
    echo "  1. Update CODE_REGISTRY.md with missing files"
    echo "  2. Stage the changes: git add CODE_REGISTRY.md"
    echo "  3. Try commit again"
    echo ""
    echo "To bypass (not recommended):"
    echo "  git commit --no-verify -m \"your message\""
    echo ""
    exit 1
fi

if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  WARNING: Code changed but registry not updated${NC}"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Commit cancelled. Update CODE_REGISTRY.md first."
        exit 1
    fi
fi

echo -e "${GREEN}✅ Registry verification passed${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
exit 0
HOOK_EOF

# Make hook executable
chmod +x .git/hooks/pre-commit

# ═══════════════════════════════════════════════════════════════
# SUCCESS MESSAGE
# ═══════════════════════════════════════════════════════════════

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Git hooks installed successfully!${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "What happens now:"
echo "  • Every commit will verify CODE_REGISTRY.md"
echo "  • Missing files will BLOCK the commit"
echo "  • You'll be warned if code changes without registry update"
echo ""
echo "To bypass in emergency:"
echo "  git commit --no-verify -m \"message\""
echo ""
echo "To uninstall:"
echo "  rm .git/hooks/pre-commit"
echo ""
