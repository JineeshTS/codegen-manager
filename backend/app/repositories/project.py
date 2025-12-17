"""Project repository for database operations."""

import uuid
from typing import List
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.project import Project
from app.repositories.base import BaseRepository


class ProjectRepository(BaseRepository[Project]):
    """Repository for Project model operations."""

    def __init__(self, session: AsyncSession):
        super().__init__(Project, session)

    async def get_by_user(
        self,
        user_id: uuid.UUID,
        skip: int = 0,
        limit: int = 100
    ) -> List[Project]:
        """Get projects created by a user."""
        stmt = (
            select(Project)
            .where(Project.user_id == user_id)
            .offset(skip)
            .limit(limit)
            .order_by(Project.created_at.desc())
        )
        result = await self.session.execute(stmt)
        return list(result.scalars().all())

    async def get_by_template(
        self,
        template_id: uuid.UUID,
        skip: int = 0,
        limit: int = 100
    ) -> List[Project]:
        """Get projects using a specific template."""
        stmt = (
            select(Project)
            .where(Project.template_id == template_id)
            .offset(skip)
            .limit(limit)
            .order_by(Project.created_at.desc())
        )
        result = await self.session.execute(stmt)
        return list(result.scalars().all())

    async def get_recent(
        self,
        user_id: uuid.UUID,
        limit: int = 10
    ) -> List[Project]:
        """Get recent projects for a user."""
        stmt = (
            select(Project)
            .where(Project.user_id == user_id)
            .order_by(Project.updated_at.desc())
            .limit(limit)
        )
        result = await self.session.execute(stmt)
        return list(result.scalars().all())
