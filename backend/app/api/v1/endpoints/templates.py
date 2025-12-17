"""Template API endpoints."""

from typing import Annotated, Optional
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.api.dependencies import get_current_active_user
from app.services.template import TemplateService
from app.schemas.template import (
    TemplateCreate,
    TemplateUpdate,
    TemplateResponse,
    TemplateListResponse
)
from app.models.user import User
import uuid


router = APIRouter(prefix="/templates", tags=["Templates"])


@router.post(
    "",
    response_model=dict,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new template"
)
async def create_template(
    data: TemplateCreate,
    current_user: Annotated[User, Depends(get_current_active_user)],
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Create a new code generation template."""
    service = TemplateService(session)
    template = await service.create_template(data, current_user.id)

    return {
        "success": True,
        "message": "Template created successfully",
        "data": TemplateResponse.model_validate(template)
    }


@router.get(
    "",
    response_model=dict,
    summary="List templates"
)
async def list_templates(
    session: Annotated[AsyncSession, Depends(get_db)],
    category: Optional[str] = Query(None, description="Filter by category"),
    language: Optional[str] = Query(None, description="Filter by language"),
    search: Optional[str] = Query(None, description="Search query"),
    my_templates: bool = Query(False, description="Show only my templates"),
    skip: int = Query(0, ge=0, description="Skip N templates"),
    limit: int = Query(20, ge=1, le=100, description="Limit results"),
    current_user: Annotated[User, Depends(get_current_active_user)] = None
) -> dict:
    """List templates with optional filters."""
    service = TemplateService(session)

    if search:
        templates = await service.search_templates(search, skip, limit)
    else:
        user_id = current_user.id if my_templates and current_user else None
        templates = await service.list_templates(
            user_id=user_id,
            category=category,
            language=language,
            public_only=not my_templates,
            skip=skip,
            limit=limit
        )

    total = len(templates)
    pages = (total + limit - 1) // limit if limit > 0 else 1

    return {
        "success": True,
        "message": "Templates retrieved successfully",
        "data": {
            "items": [TemplateResponse.model_validate(t) for t in templates],
            "total": total,
            "page": skip // limit + 1 if limit > 0 else 1,
            "size": limit,
            "pages": pages
        }
    }


@router.get(
    "/{template_id}",
    response_model=dict,
    summary="Get template by ID"
)
async def get_template(
    template_id: uuid.UUID,
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Get a specific template by ID."""
    service = TemplateService(session)
    template = await service.get_template(template_id)

    return {
        "success": True,
        "message": "Template retrieved successfully",
        "data": TemplateResponse.model_validate(template)
    }


@router.put(
    "/{template_id}",
    response_model=dict,
    summary="Update template"
)
async def update_template(
    template_id: uuid.UUID,
    data: TemplateUpdate,
    current_user: Annotated[User, Depends(get_current_active_user)],
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Update a template."""
    service = TemplateService(session)
    template = await service.update_template(template_id, data, current_user.id)

    return {
        "success": True,
        "message": "Template updated successfully",
        "data": TemplateResponse.model_validate(template)
    }


@router.delete(
    "/{template_id}",
    response_model=dict,
    summary="Delete template"
)
async def delete_template(
    template_id: uuid.UUID,
    current_user: Annotated[User, Depends(get_current_active_user)],
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Delete a template."""
    service = TemplateService(session)
    await service.delete_template(template_id, current_user.id)

    return {
        "success": True,
        "message": "Template deleted successfully",
        "data": None
    }
