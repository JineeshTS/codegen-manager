"""Template service for business logic."""

import uuid
from typing import List, Optional
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.template import Template
from app.repositories.template import TemplateRepository
from app.schemas.template import TemplateCreate, TemplateUpdate
from app.core.exceptions import NotFoundException, UnauthorizedException


class TemplateService:
    """Service for template operations."""

    def __init__(self, session: AsyncSession):
        self.session = session
        self.repository = TemplateRepository(session)

    async def create_template(
        self,
        data: TemplateCreate,
        user_id: uuid.UUID
    ) -> Template:
        """Create a new template."""
        template = Template(
            name=data.name,
            description=data.description,
            content=data.content,
            category=data.category,
            language=data.language,
            variables=data.variables or {},
            user_id=user_id,
            is_public=data.is_public
        )
        return await self.repository.create(template)

    async def update_template(
        self,
        template_id: uuid.UUID,
        data: TemplateUpdate,
        user_id: uuid.UUID
    ) -> Template:
        """Update a template."""
        template = await self.repository.get(template_id)

        if not template:
            raise NotFoundException(f"Template {template_id} not found")

        # Check ownership
        if template.user_id != user_id:
            raise UnauthorizedException("You don't have permission to update this template")

        # Update fields
        if data.name is not None:
            template.name = data.name
        if data.description is not None:
            template.description = data.description
        if data.content is not None:
            template.content = data.content
        if data.category is not None:
            template.category = data.category
        if data.language is not None:
            template.language = data.language
        if data.variables is not None:
            template.variables = data.variables
        if data.is_public is not None:
            template.is_public = data.is_public

        return await self.repository.update(template)

    async def delete_template(
        self,
        template_id: uuid.UUID,
        user_id: uuid.UUID
    ) -> bool:
        """Delete a template."""
        template = await self.repository.get(template_id)

        if not template:
            raise NotFoundException(f"Template {template_id} not found")

        # Check ownership
        if template.user_id != user_id:
            raise UnauthorizedException("You don't have permission to delete this template")

        return await self.repository.delete(template_id)

    async def get_template(self, template_id: uuid.UUID) -> Template:
        """Get a single template by ID."""
        template = await self.repository.get(template_id)

        if not template:
            raise NotFoundException(f"Template {template_id} not found")

        return template

    async def list_templates(
        self,
        user_id: Optional[uuid.UUID] = None,
        category: Optional[str] = None,
        language: Optional[str] = None,
        public_only: bool = False,
        skip: int = 0,
        limit: int = 100
    ) -> List[Template]:
        """List templates with optional filters."""
        if user_id and not public_only:
            return await self.repository.get_by_user(user_id, skip, limit)
        elif category:
            return await self.repository.get_by_category(category, skip, limit)
        elif language:
            return await self.repository.filter_by_language(language, skip, limit)
        else:
            return await self.repository.get_public(skip, limit)

    async def search_templates(
        self,
        query: str,
        skip: int = 0,
        limit: int = 100
    ) -> List[Template]:
        """Search templates."""
        return await self.repository.search(query, skip, limit)
