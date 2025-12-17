"""FastAPI dependencies for authentication and authorization.

This module provides dependency functions for protecting routes and
accessing the current authenticated user.
"""

from typing import Annotated
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth import AuthService
from app.models.user import User
from app.core.exceptions import UnauthorizedException, NotFoundException


# HTTP Bearer token scheme
security = HTTPBearer()


async def get_current_user(
    credentials: Annotated[HTTPAuthorizationCredentials, Depends(security)],
    session: Annotated[AsyncSession, Depends(get_db)]
) -> User:
    """Get the current authenticated user from JWT token.

    This dependency extracts the JWT token from the Authorization header,
    verifies it, and returns the corresponding user.

    Args:
        credentials: HTTP Bearer credentials containing the JWT token
        session: Database session from dependency injection

    Returns:
        The authenticated User instance

    Raises:
        HTTPException: 401 if token is invalid or user not found

    Example:
        >>> @router.get("/protected")
        >>> async def protected_route(
        ...     user: User = Depends(get_current_user)
        ... ):
        ...     return {"user": user.email}
    """
    try:
        token = credentials.credentials
        auth_service = AuthService(session)
        user = await auth_service.get_current_user(token)
        return user

    except (UnauthorizedException, NotFoundException) as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e),
            headers={"WWW-Authenticate": "Bearer"},
        )
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )


async def get_current_active_user(
    current_user: Annotated[User, Depends(get_current_user)]
) -> User:
    """Get the current authenticated and active user.

    This dependency ensures the user is not only authenticated but also
    has an active account.

    Args:
        current_user: The authenticated user from get_current_user dependency

    Returns:
        The active User instance

    Raises:
        HTTPException: 401 if user account is not active

    Example:
        >>> @router.get("/active-only")
        >>> async def active_route(
        ...     user: User = Depends(get_current_active_user)
        ... ):
        ...     return {"user": user.email}
    """
    if not current_user.is_active:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Inactive user account"
        )
    return current_user
