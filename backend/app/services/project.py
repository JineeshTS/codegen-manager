"""Project service for business logic."""

import uuid
from typing import List
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.project import Project
from app.repositories.project import ProjectRepository
from app.repositories.template import TemplateRepository
from app.schemas.project import ProjectCreate, ProjectUpdate
from app.services.codegen import CodeGenService
from app.core.exceptions import NotFoundException, UnauthorizedException


class ProjectService:
    """Service for project operations."""

    def __init__(self, session: AsyncSession):
        self.session = session
        self.repository = ProjectRepository(session)
        self.template_repository = TemplateRepository(session)
        self.codegen_service = CodeGenService()

    async def create_project(
        self,
        data: ProjectCreate,
        user_id: uuid.UUID
    ) -> Project:
        """Create a new project."""
        # Verify template exists
        template = await self.template_repository.get(data.template_id)
        if not template:
            raise NotFoundException(f"Template {data.template_id} not found")

        project = Project(
            name=data.name,
            description=data.description,
            template_id=data.template_id,
            user_id=user_id,
            config=data.config or {},
            status="draft"
        )
        return await self.repository.create(project)

    async def generate_code_for_project(
        self,
        project_id: uuid.UUID,
        user_id: uuid.UUID,
        variables: dict
    ) -> Project:
        """Generate code for a project using its template."""
        project = await self.repository.get(project_id)

        if not project:
            raise NotFoundException(f"Project {project_id} not found")

        if project.user_id != user_id:
            raise UnauthorizedException("Not authorized to modify this project")

        # Get template
        if not project.template_id:
            raise ValueError("Project has no associated template")

        template = await self.template_repository.get(project.template_id)
        if not template:
            raise NotFoundException("Template not found")

        # Generate code
        generated_code = await self.codegen_service.generate_code(
            template.content,
            variables
        )

        project.generated_code = generated_code
        project.status = "generated"

        return await self.repository.update(project)

    async def update_project(
        self,
        project_id: uuid.UUID,
        data: ProjectUpdate,
        user_id: uuid.UUID
    ) -> Project:
        """Update a project."""
        project = await self.repository.get(project_id)

        if not project:
            raise NotFoundException(f"Project {project_id} not found")

        if project.user_id != user_id:
            raise UnauthorizedException("Not authorized to modify this project")

        if data.name is not None:
            project.name = data.name
        if data.description is not None:
            project.description = data.description
        if data.config is not None:
            project.config = data.config
        if data.status is not None:
            project.status = data.status

        return await self.repository.update(project)

    async def delete_project(
        self,
        project_id: uuid.UUID,
        user_id: uuid.UUID
    ) -> bool:
        """Delete a project."""
        project = await self.repository.get(project_id)

        if not project:
            raise NotFoundException(f"Project {project_id} not found")

        if project.user_id != user_id:
            raise UnauthorizedException("Not authorized to delete this project")

        return await self.repository.delete(project_id)

    async def get_project_history(
        self,
        user_id: uuid.UUID,
        limit: int = 10
    ) -> List[Project]:
        """Get recent projects for a user."""
        return await self.repository.get_recent(user_id, limit)
