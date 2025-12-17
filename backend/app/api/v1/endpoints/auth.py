"""Authentication API endpoints.

This module provides REST API endpoints for user authentication operations
including registration, login, logout, and profile management.
"""

from typing import Annotated
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.api.dependencies import get_current_user, get_current_active_user
from app.services.auth import AuthService
from app.schemas.auth import RegisterRequest, LoginRequest, TokenResponse, UserResponse
from app.models.user import User


router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post(
    "/register",
    response_model=dict,
    status_code=status.HTTP_201_CREATED,
    summary="Register a new user"
)
async def register(
    data: RegisterRequest,
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Register a new user account.

    Creates a new user with the provided email, password, and full name.
    Returns the user data and an access token for immediate authentication.

    Args:
        data: User registration data
        session: Database session

    Returns:
        Dictionary with user data and access token

    Raises:
        422: If email is already registered
    """
    auth_service = AuthService(session)
    user, access_token = await auth_service.register(data)

    return {
        "success": True,
        "message": "User registered successfully",
        "data": {
            "user": UserResponse.model_validate(user),
            "access_token": access_token,
            "token_type": "bearer"
        }
    }


@router.post(
    "/login",
    response_model=dict,
    summary="Login user"
)
async def login(
    data: LoginRequest,
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Authenticate a user and return tokens.

    Verifies the email and password, then generates access and refresh tokens.

    Args:
        data: Login credentials
        session: Database session

    Returns:
        Dictionary with tokens and user data

    Raises:
        401: If credentials are invalid
    """
    auth_service = AuthService(session)
    user, access_token, refresh_token = await auth_service.login(
        data.email,
        data.password
    )

    return {
        "success": True,
        "message": "Login successful",
        "data": {
            "user": UserResponse.model_validate(user),
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "bearer"
        }
    }


@router.post(
    "/logout",
    response_model=dict,
    summary="Logout user"
)
async def logout(
    current_user: Annotated[User, Depends(get_current_user)]
) -> dict:
    """Logout the current user.

    Note: In a stateless JWT system, logout is handled client-side by
    removing the token. This endpoint confirms the logout action.

    Args:
        current_user: The authenticated user

    Returns:
        Success message
    """
    return {
        "success": True,
        "message": "Logged out successfully",
        "data": None
    }


@router.get(
    "/me",
    response_model=dict,
    summary="Get current user"
)
async def get_me(
    current_user: Annotated[User, Depends(get_current_active_user)]
) -> dict:
    """Get the currently authenticated user's profile.

    Args:
        current_user: The authenticated active user

    Returns:
        Current user's profile data
    """
    return {
        "success": True,
        "message": "User profile retrieved",
        "data": UserResponse.model_validate(current_user)
    }


@router.put(
    "/me",
    response_model=dict,
    summary="Update current user profile"
)
async def update_me(
    full_name: str,
    current_user: Annotated[User, Depends(get_current_active_user)],
    session: Annotated[AsyncSession, Depends(get_db)]
) -> dict:
    """Update the current user's profile.

    Args:
        full_name: New full name for the user
        current_user: The authenticated active user
        session: Database session

    Returns:
        Updated user profile data
    """
    auth_service = AuthService(session)
    updated_user = await auth_service.update_profile(
        current_user.id,
        full_name
    )

    return {
        "success": True,
        "message": "Profile updated successfully",
        "data": UserResponse.model_validate(updated_user)
    }
