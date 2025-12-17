"""Authentication service for user management and authentication.

This module provides the AuthService class for handling user registration,
login, token management, and profile updates.
"""

import uuid
from typing import Tuple
from datetime import timedelta

from sqlalchemy.ext.asyncio import AsyncSession

from app.models.user import User
from app.repositories.user import UserRepository
from app.schemas.auth import RegisterRequest
from app.core.security import hash_password, verify_password, create_access_token, verify_token
from app.core.exceptions import UnauthorizedException, ValidationException, NotFoundException
from app.core.config import settings


class AuthService:
    """Service for authentication and user management operations.

    This service handles user registration, login, token verification,
    and profile management.

    Attributes:
        session: The async database session
        user_repository: Repository for user database operations
    """

    def __init__(self, session: AsyncSession):
        """Initialize the auth service.

        Args:
            session: The async database session
        """
        self.session = session
        self.user_repository = UserRepository(session)

    async def register(self, data: RegisterRequest) -> Tuple[User, str]:
        """Register a new user.

        Args:
            data: User registration data

        Returns:
            Tuple of (created User instance, access token)

        Raises:
            ValidationException: If email already exists

        Example:
            >>> service = AuthService(session)
            >>> user, token = await service.register(request_data)
            >>> print(f"User {user.email} registered with token {token[:10]}...")
        """
        # Check if user already exists
        existing_user = await self.user_repository.get_by_email(data.email)
        if existing_user:
            raise ValidationException(
                "Email already registered",
                errors={"email": "This email is already in use"}
            )

        # Create new user
        user = User(
            email=data.email,
            hashed_password=hash_password(data.password),
            full_name=data.full_name,
            is_active=True
        )

        created_user = await self.user_repository.create(user)

        # Generate access token
        access_token = create_access_token(
            data={"sub": str(created_user.id)}
        )

        return created_user, access_token

    async def login(self, email: str, password: str) -> Tuple[User, str, str]:
        """Authenticate a user and generate tokens.

        Args:
            email: User's email address
            password: User's plain-text password

        Returns:
            Tuple of (User instance, access token, refresh token)

        Raises:
            UnauthorizedException: If credentials are invalid

        Example:
            >>> user, access_token, refresh_token = await service.login(
            ...     "user@example.com",
            ...     "password123"
            ... )
        """
        # Get user by email
        user = await self.user_repository.get_by_email(email)

        # Verify user exists and password is correct
        if not user or not verify_password(password, user.hashed_password):
            raise UnauthorizedException("Invalid email or password")

        # Check if user is active
        if not user.is_active:
            raise UnauthorizedException("Account is disabled")

        # Generate tokens
        access_token = create_access_token(
            data={"sub": str(user.id)}
        )

        refresh_token = create_access_token(
            data={"sub": str(user.id)},
            expires_delta=timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
        )

        return user, access_token, refresh_token

    async def get_current_user(self, token: str) -> User:
        """Get user from JWT token.

        Args:
            token: JWT access token

        Returns:
            User instance

        Raises:
            UnauthorizedException: If token is invalid or user not found

        Example:
            >>> user = await service.get_current_user(token)
            >>> print(f"Current user: {user.email}")
        """
        try:
            payload = verify_token(token)
            user_id = payload.get("sub")

            if not user_id:
                raise UnauthorizedException("Invalid token payload")

            user = await self.user_repository.get(uuid.UUID(user_id))

            if not user:
                raise NotFoundException("User not found")

            return user

        except Exception as e:
            if isinstance(e, (UnauthorizedException, NotFoundException)):
                raise
            raise UnauthorizedException("Invalid or expired token")

    async def update_profile(self, user_id: uuid.UUID, full_name: str) -> User:
        """Update user profile information.

        Args:
            user_id: ID of the user to update
            full_name: New full name

        Returns:
            Updated User instance

        Raises:
            NotFoundException: If user not found

        Example:
            >>> updated_user = await service.update_profile(
            ...     user_id,
            ...     "Jane Doe"
            ... )
        """
        user = await self.user_repository.get(user_id)

        if not user:
            raise NotFoundException(f"User with id {user_id} not found")

        user.full_name = full_name
        return await self.user_repository.update(user)
