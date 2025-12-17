"""Template Pydantic schemas.

This module defines request and response schemas for template operations.
"""

import uuid
from datetime import datetime
from typing import Optional, Dict, Any, List

from pydantic import BaseModel, Field, ConfigDict


class TemplateCreate(BaseModel):
    """Schema for creating a new template."""

    name: str = Field(
        ...,
        min_length=1,
        max_length=255,
        description="Template name",
        examples=["FastAPI CRUD Endpoint"]
    )

    description: Optional[str] = Field(
        None,
        description="Template description",
        examples=["Creates a complete CRUD endpoint with repository pattern"]
    )

    content: str = Field(
        ...,
        min_length=1,
        description="Template content with {{variable}} placeholders",
        examples=["def {{function_name}}({{params}}):\n    pass"]
    )

    category: str = Field(
        ...,
        min_length=1,
        max_length=100,
        description="Template category",
        examples=["API", "Database", "Frontend", "Backend"]
    )

    language: str = Field(
        ...,
        min_length=1,
        max_length=50,
        description="Programming language",
        examples=["Python", "JavaScript", "TypeScript", "Dart"]
    )

    variables: Optional[Dict[str, Any]] = Field(
        default=None,
        description="Template variables and their types/defaults",
        examples=[{"function_name": "str", "params": "str"}]
    )

    is_public: bool = Field(
        default=False,
        description="Whether template is publicly accessible"
    )


class TemplateUpdate(BaseModel):
    """Schema for updating a template."""

    name: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = None
    content: Optional[str] = Field(None, min_length=1)
    category: Optional[str] = Field(None, min_length=1, max_length=100)
    language: Optional[str] = Field(None, min_length=1, max_length=50)
    variables: Optional[Dict[str, Any]] = None
    is_public: Optional[bool] = None


class TemplateResponse(BaseModel):
    """Schema for template response."""

    id: uuid.UUID = Field(..., description="Template ID")
    name: str = Field(..., description="Template name")
    description: Optional[str] = Field(None, description="Template description")
    content: str = Field(..., description="Template content")
    category: str = Field(..., description="Template category")
    language: str = Field(..., description="Programming language")
    variables: Optional[Dict[str, Any]] = Field(None, description="Template variables")
    user_id: uuid.UUID = Field(..., description="Creator user ID")
    is_public: bool = Field(..., description="Is publicly accessible")
    created_at: datetime = Field(..., description="Creation timestamp")
    updated_at: Optional[datetime] = Field(None, description="Last update timestamp")

    model_config = ConfigDict(
        from_attributes=True,
        json_schema_extra={
            "example": {
                "id": "123e4567-e89b-12d3-a456-426614174000",
                "name": "FastAPI CRUD Endpoint",
                "description": "Complete CRUD endpoint template",
                "content": "def {{function_name}}():\n    pass",
                "category": "API",
                "language": "Python",
                "variables": {"function_name": "str"},
                "user_id": "123e4567-e89b-12d3-a456-426614174000",
                "is_public": False,
                "created_at": "2025-12-17T12:00:00Z",
                "updated_at": None
            }
        }
    )


class TemplateListResponse(BaseModel):
    """Schema for paginated template list."""

    items: List[TemplateResponse] = Field(..., description="List of templates")
    total: int = Field(..., description="Total count of templates")
    page: int = Field(..., description="Current page number")
    size: int = Field(..., description="Page size")
    pages: int = Field(..., description="Total number of pages")
