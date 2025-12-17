"""Base repository for generic CRUD operations.

This module provides a generic async repository base class that can be extended
for specific models, implementing common CRUD operations using SQLAlchemy async sessions.
"""

from typing import Generic, List, Optional, Type, TypeVar
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession


# Generic type variable for SQLAlchemy models
T = TypeVar("T")


class BaseRepository(Generic[T]):
    """Generic async repository for CRUD operations.

    This base class provides common database operations (Create, Read, Update, Delete)
    that can be inherited and extended by model-specific repositories.

    Type Parameters:
        T: The SQLAlchemy model class this repository operates on

    Attributes:
        model: The SQLAlchemy model class
        session: The async database session

    Example:
        >>> class UserRepository(BaseRepository[User]):
        ...     def __init__(self, session: AsyncSession):
        ...         super().__init__(User, session)
        ...
        >>> async with async_session() as session:
        ...     user_repo = UserRepository(session)
        ...     user = await user_repo.get(user_id)
    """

    def __init__(self, model: Type[T], session: AsyncSession):
        """Initialize the repository.

        Args:
            model: The SQLAlchemy model class to operate on
            session: The async database session
        """
        self.model = model
        self.session = session

    async def get(self, id: any) -> Optional[T]:
        """Get a single record by ID.

        Args:
            id: The primary key value to search for

        Returns:
            The model instance if found, None otherwise

        Example:
            >>> user = await user_repo.get(123)
            >>> if user:
            ...     print(user.email)
        """
        return await self.session.get(self.model, id)

    async def get_all(self, skip: int = 0, limit: int = 100) -> List[T]:
        """Get all records with pagination.

        Args:
            skip: Number of records to skip (offset)
            limit: Maximum number of records to return

        Returns:
            List of model instances

        Example:
            >>> users = await user_repo.get_all(skip=0, limit=50)
            >>> print(f"Found {len(users)} users")
        """
        stmt = select(self.model).offset(skip).limit(limit)
        result = await self.session.execute(stmt)
        return list(result.scalars().all())

    async def create(self, obj: T) -> T:
        """Create a new record.

        Args:
            obj: The model instance to create

        Returns:
            The created model instance with populated fields (e.g., ID)

        Example:
            >>> new_user = User(email="user@example.com", full_name="John Doe")
            >>> created_user = await user_repo.create(new_user)
            >>> print(created_user.id)  # Auto-generated ID
        """
        self.session.add(obj)
        await self.session.flush()
        await self.session.refresh(obj)
        return obj

    async def update(self, obj: T) -> T:
        """Update an existing record.

        The object should already be attached to the session with modified attributes.

        Args:
            obj: The model instance to update

        Returns:
            The updated model instance

        Example:
            >>> user = await user_repo.get(123)
            >>> user.full_name = "Jane Doe"
            >>> updated_user = await user_repo.update(user)
        """
        await self.session.flush()
        await self.session.refresh(obj)
        return obj

    async def delete(self, id: any) -> bool:
        """Delete a record by ID.

        Args:
            id: The primary key value of the record to delete

        Returns:
            True if the record was deleted, False if not found

        Example:
            >>> deleted = await user_repo.delete(123)
            >>> if deleted:
            ...     print("User deleted successfully")
        """
        obj = await self.get(id)
        if obj:
            await self.session.delete(obj)
            await self.session.flush()
            return True
        return False
