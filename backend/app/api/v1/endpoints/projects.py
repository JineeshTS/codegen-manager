"""Project API endpoints."""

from typing import Annotated, Dict, Any
from fastapi import APIRouter, Depends, status, Body
from sqlalchemy.ext.asyncio import AsyncSession
import uuid

from app.core.database import get_db
from app.api.dependencies import get_current_active_user
from app.services.project import ProjectService
from app.schemas.project import ProjectCreate, ProjectUpdate, ProjectResponse
from app.models.user import User


router = APIRouter(prefix="/projects", tags=["Projects"])


@router.post(
    "",
    response_model=dict,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new project"
)
async def create_project(
    data: ProjectCreate,
    current_user: Annotated[User, Depends(get_current_active_user)],
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Create a new code generation project."""
    service = ProjectService(session)
    project = await service.create_project(data, current_user.id)

    return {
        "success": True,
        "message": "Project created successfully",
        "data": ProjectResponse.model_validate(project)
    }


@router.get(
    "",
    response_model=dict,
    summary="List user's projects"
)
async def list_projects(
    current_user: Annotated[User, Depends(get_current_active_user)],
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """List all projects for the current user."""
    service = ProjectService(session)
    projects = await service.repository.get_by_user(current_user.id)

    return {
        "success": True,
        "message": "Projects retrieved successfully",
        "data": [ProjectResponse.model_validate(p) for p in projects]
    }


@router.get(
    "/{project_id}",
    response_model=dict,
    summary="Get project by ID"
)
async def get_project(
    project_id: uuid.UUID,
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Get a specific project by ID."""
    service = ProjectService(session)
    project = await service.repository.get(project_id)

    if not project:
        from app.core.exceptions import NotFoundException
        raise NotFoundException(f"Project {project_id} not found")

    return {
        "success": True,
        "message": "Project retrieved successfully",
        "data": ProjectResponse.model_validate(project)
    }


@router.put(
    "/{project_id}",
    response_model=dict,
    summary="Update project"
)
async def update_project(
    project_id: uuid.UUID,
    data: ProjectUpdate,
    current_user: Annotated[User, Depends(get_current_active_user)],
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Update a project."""
    service = ProjectService(session)
    project = await service.update_project(project_id, data, current_user.id)

    return {
        "success": True,
        "message": "Project updated successfully",
        "data": ProjectResponse.model_validate(project)
    }


@router.delete(
    "/{project_id}",
    response_model=dict,
    summary="Delete project"
)
async def delete_project(
    project_id: uuid.UUID,
    current_user: Annotated[User, Depends(get_current_active_user)],
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Delete a project."""
    service = ProjectService(session)
    await service.delete_project(project_id, current_user.id)

    return {
        "success": True,
        "message": "Project deleted successfully",
        "data": None
    }


@router.post(
    "/{project_id}/generate",
    response_model=dict,
    summary="Generate code for project"
)
async def generate_code(
    project_id: uuid.UUID,
    variables: Dict[str, Any] = Body(..., description="Template variables"),
    current_user: Annotated[User, Depends(get_current_active_user)],
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Generate code for a project using its template."""
    service = ProjectService(session)
    project = await service.generate_code_for_project(
        project_id,
        current_user.id,
        variables
    )

    return {
        "success": True,
        "message": "Code generated successfully",
        "data": ProjectResponse.model_validate(project)
    }


@router.get(
    "/{project_id}/code",
    response_model=dict,
    summary="Get generated code"
)
async def get_generated_code(
    project_id: uuid.UUID,
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Get the generated code for a project."""
    service = ProjectService(session)
    project = await service.repository.get(project_id)

    if not project:
        from app.core.exceptions import NotFoundException
        raise NotFoundException(f"Project {project_id} not found")

    return {
        "success": True,
        "message": "Generated code retrieved",
        "data": {
            "project_id": project.id,
            "code": project.generated_code,
            "status": project.status
        }
    }
