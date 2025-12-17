"""Template repository for database operations."""

import uuid
from typing import Optional, List
from sqlalchemy import select, or_
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.template import Template
from app.repositories.base import BaseRepository


class TemplateRepository(BaseRepository[Template]):
    """Repository for Template model database operations."""

    def __init__(self, session: AsyncSession):
        super().__init__(Template, session)

    async def get_by_user(
        self,
        user_id: uuid.UUID,
        skip: int = 0,
        limit: int = 100
    ) -> List[Template]:
        """Get templates created by a specific user."""
        stmt = (
            select(Template)
            .where(Template.user_id == user_id)
            .offset(skip)
            .limit(limit)
            .order_by(Template.created_at.desc())
        )
        result = await self.session.execute(stmt)
        return list(result.scalars().all())

    async def get_public(
        self,
        skip: int = 0,
        limit: int = 100
    ) -> List[Template]:
        """Get all public templates."""
        stmt = (
            select(Template)
            .where(Template.is_public == True)
            .offset(skip)
            .limit(limit)
            .order_by(Template.created_at.desc())
        )
        result = await self.session.execute(stmt)
        return list(result.scalars().all())

    async def get_by_category(
        self,
        category: str,
        skip: int = 0,
        limit: int = 100
    ) -> List[Template]:
        """Get templates by category."""
        stmt = (
            select(Template)
            .where(Template.category == category)
            .where(Template.is_public == True)
            .offset(skip)
            .limit(limit)
            .order_by(Template.created_at.desc())
        )
        result = await self.session.execute(stmt)
        return list(result.scalars().all())

    async def filter_by_language(
        self,
        language: str,
        skip: int = 0,
        limit: int = 100
    ) -> List[Template]:
        """Get templates by programming language."""
        stmt = (
            select(Template)
            .where(Template.language == language)
            .where(Template.is_public == True)
            .offset(skip)
            .limit(limit)
            .order_by(Template.created_at.desc())
        )
        result = await self.session.execute(stmt)
        return list(result.scalars().all())

    async def search(
        self,
        query: str,
        skip: int = 0,
        limit: int = 100
    ) -> List[Template]:
        """Search templates by name or description."""
        search_pattern = f"%{query}%"
        stmt = (
            select(Template)
            .where(
                or_(
                    Template.name.ilike(search_pattern),
                    Template.description.ilike(search_pattern)
                )
            )
            .where(Template.is_public == True)
            .offset(skip)
            .limit(limit)
            .order_by(Template.created_at.desc())
        )
        result = await self.session.execute(stmt)
        return list(result.scalars().all())
