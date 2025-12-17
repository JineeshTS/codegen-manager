#!/usr/bin/env python3
"""
Prompt Generator for CodeGen Manager
Generates complete, self-contained prompts for each task.

Usage:
    python generate_prompt.py BE-001
    python generate_prompt.py BE-001 --output prompts/
    python generate_prompt.py --list
    python generate_prompt.py --list --phase 1
    python generate_prompt.py --next
"""

import json
import os
import argparse
from pathlib import Path
from datetime import datetime


class PromptGenerator:
    def __init__(self, project_root: str = None):
        self.project_root = Path(project_root) if project_root else Path.cwd()
        self.tasks_file = self.project_root / "scripts" / "tasks.json"
        self.claude_md = self.project_root / "CLAUDE.md"
        self.design_system_md = self.project_root / "DESIGN_SYSTEM.md"
        self.code_registry_md = self.project_root / "CODE_REGISTRY.md"
        
        self.tasks = self._load_tasks()
    
    def _load_tasks(self) -> dict:
        """Load tasks from JSON file."""
        if not self.tasks_file.exists():
            raise FileNotFoundError(f"Tasks file not found: {self.tasks_file}")
        
        with open(self.tasks_file, "r") as f:
            return json.load(f)
    
    def _read_file(self, path: Path) -> str:
        """Read file content if exists."""
        if path.exists():
            with open(path, "r") as f:
                return f.read()
        return ""
    
    def _get_relevant_standards(self, task: dict) -> str:
        """Extract relevant sections from CLAUDE.md based on task type."""
        claude_content = self._read_file(self.claude_md)
        
        if not claude_content:
            return "# PROJECT STANDARDS\n\nNo CLAUDE.md found."
        
        # For now, include key sections based on platform
        platform = task.get("platform", "backend")
        layer = task.get("layer", "")
        
        # Return full CLAUDE.md for now - can be optimized later
        return f"# PROJECT STANDARDS (from CLAUDE.md)\n\n{claude_content}"
    
    def _get_design_system(self, task: dict) -> str:
        """Include DESIGN_SYSTEM.md for frontend tasks."""
        platform = task.get("platform", "")
        
        if platform not in ["mobile", "web", "desktop"]:
            return ""
        
        design_content = self._read_file(self.design_system_md)
        
        if not design_content:
            return ""
        
        return f"\n\n# DESIGN SYSTEM (from DESIGN_SYSTEM.md)\n\n{design_content}"
    
    def _get_code_registry(self) -> str:
        """Get current CODE_REGISTRY.md content."""
        registry_content = self._read_file(self.code_registry_md)
        
        if not registry_content:
            return ""
        
        return f"\n\n# EXISTING CODE (from CODE_REGISTRY.md)\n\n{registry_content}"
    
    def _get_dependency_code(self, task: dict) -> str:
        """Get actual code from dependency files."""
        depends_on = task.get("depends_on", [])
        
        if not depends_on:
            return ""
        
        dependency_code = "\n\n# DEPENDENCY CODE\n\n"
        dependency_code += "The following files already exist and you should use them:\n\n"
        
        for dep_id in depends_on:
            dep_task = self.tasks.get(dep_id)
            if dep_task:
                file_path = self.project_root / dep_task.get("output_path", "")
                if file_path.exists():
                    code = self._read_file(file_path)
                    dependency_code += f"## {dep_task['output_path']}\n\n```python\n{code}\n```\n\n"
                else:
                    dependency_code += f"## {dep_task['output_path']}\n\n*(File not yet created)*\n\n"
        
        return dependency_code
    
    def _get_tech_stack(self, platform: str) -> str:
        """Get tech stack based on platform."""
        if platform == "backend":
            return """### Tech Stack
- Python 3.11+
- FastAPI
- SQLAlchemy 2.0 (async)
- PostgreSQL
- Alembic for migrations
- Pydantic for schemas
- JWT for authentication"""
        
        elif platform in ["mobile", "web", "desktop"]:
            return """### Tech Stack
- Flutter 3.x
- Dart
- Riverpod for state management
- Freezed for immutable models
- Dio for HTTP client
- GoRouter for navigation"""
        
        return ""
    
    def _get_code_style(self, platform: str) -> str:
        """Get code style based on platform."""
        if platform == "backend":
            return """### Code Style
- Use snake_case for variables, functions, files
- Use PascalCase for classes
- Type hints required on all functions
- Docstrings on all public functions
- No print statements (use logging)
- Use Result pattern for error handling"""
        
        elif platform in ["mobile", "web", "desktop"]:
            return """### Code Style
- Use snake_case for files
- Use PascalCase for classes and widgets
- Use camelCase for variables and functions
- Always use const constructors where possible
- Use Riverpod for all state management
- Use Freezed for all entities
- Follow DESIGN_SYSTEM.md for all UI elements"""
        
        return ""
    
    def generate_prompt(self, task_id: str) -> str:
        """Generate complete prompt for a task."""
        task = self.tasks.get(task_id)
        
        if not task:
            raise ValueError(f"Task not found: {task_id}")
        
        platform = task.get("platform", "backend")
        
        prompt = f"""# TASK: {task_id} - {task['name']}

## TASK DETAILS
- **Task ID:** {task_id}
- **File to Create:** {task['output_path']}
- **Description:** {task['description']}
- **Platform:** {platform}
- **Layer:** {task.get('layer', 'N/A')}
- **Depends On:** {', '.join(task.get('depends_on', [])) or 'None'}
- **Exports:** {', '.join(task.get('exports', []))}

---

{self._get_tech_stack(platform)}

{self._get_code_style(platform)}

---

## YOUR TASK

{task.get('detailed_requirements', task['description'])}

### File to Create
```
{task['output_path']}
```

### Required Exports
```
{chr(10).join(task.get('exports', []))}
```

{self._get_dependency_code(task)}

---

## COMPLETION REQUIREMENTS

1. Create the file at the exact path specified
2. Include all required exports
3. Follow all code standards
4. Include type hints and docstrings
5. After creating, update CODE_REGISTRY.md with:

```markdown
### {task['output_path']}
- **Status:** ✅ Implemented
- **Task:** {task_id}
- **Exports:** {', '.join(task.get('exports', []))}
- **Depends On:** {', '.join(task.get('depends_on', [])) or 'None'}
```

6. Commit with message: "{task_id}: {task['name']}"

---

## VERIFICATION

After creating, verify:
- [ ] File exists at correct path
- [ ] All exports are present
- [ ] No syntax errors
- [ ] Type hints included
- [ ] Docstrings included
- [ ] CODE_REGISTRY.md updated

---

TASK COMPLETE MARKER (respond with this when done):
```
TASK COMPLETE: {task_id}
FILE CREATED: {task['output_path']}
EXPORTS: {', '.join(task.get('exports', []))}
```
"""
        
        # Add design system for frontend tasks
        if platform in ["mobile", "web", "desktop"]:
            prompt += "\n\n---\n\n## DESIGN SYSTEM REFERENCE\n\n"
            prompt += "**IMPORTANT:** Use ONLY values from DESIGN_SYSTEM.md for all UI elements.\n"
            prompt += "Do NOT create custom colors, spacing, or text styles.\n"
        
        return prompt
    
    def list_tasks(self, phase: int = None, status: str = None) -> list:
        """List all tasks, optionally filtered by phase or status."""
        result = []
        
        for task_id, task in self.tasks.items():
            if phase and task.get("phase") != phase:
                continue
            if status and task.get("status") != status:
                continue
            
            result.append({
                "id": task_id,
                "name": task["name"],
                "phase": task.get("phase"),
                "platform": task.get("platform"),
                "status": task.get("status", "pending"),
                "output_path": task.get("output_path")
            })
        
        return sorted(result, key=lambda x: (x.get("phase", 0), x["id"]))
    
    def get_next_task(self) -> dict:
        """Get the next pending task based on dependencies."""
        for task_id, task in self.tasks.items():
            if task.get("status") == "completed":
                continue
            
            # Check if all dependencies are completed
            depends_on = task.get("depends_on", [])
            deps_complete = all(
                self.tasks.get(dep, {}).get("status") == "completed"
                for dep in depends_on
            )
            
            if deps_complete:
                return {"id": task_id, **task}
        
        return None
    
    def mark_complete(self, task_id: str):
        """Mark a task as complete."""
        if task_id in self.tasks:
            self.tasks[task_id]["status"] = "completed"
            self.tasks[task_id]["completed_at"] = datetime.now().isoformat()
            
            # Save updated tasks
            with open(self.tasks_file, "w") as f:
                json.dump(self.tasks, f, indent=2)
            
            print(f"✅ Marked {task_id} as complete")
    
    def save_prompt(self, task_id: str, output_dir: str = "prompts"):
        """Generate and save prompt to file."""
        output_path = self.project_root / output_dir
        output_path.mkdir(parents=True, exist_ok=True)
        
        prompt = self.generate_prompt(task_id)
        prompt_file = output_path / f"{task_id}.md"
        
        with open(prompt_file, "w") as f:
            f.write(prompt)
        
        print(f"✅ Saved prompt to: {prompt_file}")
        return prompt_file


def main():
    parser = argparse.ArgumentParser(description="Generate prompts for CodeGen Manager tasks")
    parser.add_argument("task_id", nargs="?", help="Task ID (e.g., BE-001)")
    parser.add_argument("--output", "-o", default="prompts", help="Output directory for prompts")
    parser.add_argument("--list", "-l", action="store_true", help="List all tasks")
    parser.add_argument("--phase", "-p", type=int, help="Filter by phase (1-7)")
    parser.add_argument("--next", "-n", action="store_true", help="Show next pending task")
    parser.add_argument("--complete", "-c", help="Mark task as complete")
    parser.add_argument("--print", action="store_true", help="Print prompt to stdout instead of file")
    
    args = parser.parse_args()
    
    try:
        generator = PromptGenerator()
        
        if args.list:
            tasks = generator.list_tasks(phase=args.phase)
            print(f"\n{'ID':<10} {'Name':<40} {'Phase':<6} {'Platform':<10} {'Status':<10}")
            print("-" * 80)
            for task in tasks:
                print(f"{task['id']:<10} {task['name'][:38]:<40} {task.get('phase', '-'):<6} {task['platform']:<10} {task['status']:<10}")
            print(f"\nTotal: {len(tasks)} tasks")
        
        elif args.next:
            next_task = generator.get_next_task()
            if next_task:
                print(f"\n📋 Next Task: {next_task['id']} - {next_task['name']}")
                print(f"   File: {next_task['output_path']}")
                print(f"   Depends on: {', '.join(next_task.get('depends_on', [])) or 'None'}")
                print(f"\nRun: python generate_prompt.py {next_task['id']}")
            else:
                print("🎉 All tasks complete!")
        
        elif args.complete:
            generator.mark_complete(args.complete)
        
        elif args.task_id:
            if args.print:
                prompt = generator.generate_prompt(args.task_id)
                print(prompt)
            else:
                generator.save_prompt(args.task_id, args.output)
        
        else:
            parser.print_help()
    
    except FileNotFoundError as e:
        print(f"❌ Error: {e}")
    except ValueError as e:
        print(f"❌ Error: {e}")


if __name__ == "__main__":
    main()
