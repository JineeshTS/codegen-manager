"""User repository for database operations.

This module provides the UserRepository class for user-specific database operations,
extending the generic BaseRepository with user-specific queries.
"""

from typing import Optional
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.user import User
from app.repositories.base import BaseRepository


class UserRepository(BaseRepository[User]):
    """Repository for User model database operations.

    Extends BaseRepository with user-specific query methods.

    Example:
        >>> async with async_session() as session:
        ...     user_repo = UserRepository(session)
        ...     user = await user_repo.get_by_email("user@example.com")
        ...     if user:
        ...         print(user.full_name)
    """

    def __init__(self, session: AsyncSession):
        """Initialize the User repository.

        Args:
            session: The async database session
        """
        super().__init__(User, session)

    async def get_by_email(self, email: str) -> Optional[User]:
        """Get a user by email address.

        Args:
            email: The email address to search for

        Returns:
            The User instance if found, None otherwise

        Example:
            >>> user = await user_repo.get_by_email("user@example.com")
            >>> if user:
            ...     print(f"Found user: {user.full_name}")
            ... else:
            ...     print("User not found")
        """
        stmt = select(User).where(User.email == email)
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()
