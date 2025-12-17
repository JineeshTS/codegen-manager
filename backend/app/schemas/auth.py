"""Authentication Pydantic schemas.

This module defines request and response schemas for authentication endpoints
using Pydantic for validation and serialization.
"""

import uuid
from datetime import datetime
from typing import Optional

from pydantic import BaseModel, EmailStr, Field, ConfigDict


class RegisterRequest(BaseModel):
    """Schema for user registration request.

    Attributes:
        email: User's email address (must be valid email format)
        password: User's password (minimum 8 characters)
        full_name: User's full name

    Example:
        >>> request = RegisterRequest(
        ...     email="user@example.com",
        ...     password="securepass123",
        ...     full_name="John Doe"
        ... )
    """

    email: EmailStr = Field(
        ...,
        description="User's email address",
        examples=["user@example.com"]
    )

    password: str = Field(
        ...,
        min_length=8,
        description="User's password (minimum 8 characters)",
        examples=["securepassword123"]
    )

    full_name: str = Field(
        ...,
        min_length=1,
        max_length=255,
        description="User's full name",
        examples=["John Doe"]
    )


class LoginRequest(BaseModel):
    """Schema for user login request.

    Attributes:
        email: User's email address
        password: User's password

    Example:
        >>> request = LoginRequest(
        ...     email="user@example.com",
        ...     password="securepass123"
        ... )
    """

    email: EmailStr = Field(
        ...,
        description="User's email address",
        examples=["user@example.com"]
    )

    password: str = Field(
        ...,
        description="User's password",
        examples=["securepassword123"]
    )


class TokenResponse(BaseModel):
    """Schema for authentication token response.

    Attributes:
        access_token: JWT access token for API authentication
        refresh_token: JWT refresh token for obtaining new access tokens
        token_type: Type of token (always "bearer")

    Example:
        >>> response = TokenResponse(
        ...     access_token="eyJhbGci...",
        ...     refresh_token="eyJhbGci...",
        ...     token_type="bearer"
        ... )
    """

    access_token: str = Field(
        ...,
        description="JWT access token",
        examples=["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."]
    )

    refresh_token: str = Field(
        ...,
        description="JWT refresh token",
        examples=["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."]
    )

    token_type: str = Field(
        default="bearer",
        description="Token type",
        examples=["bearer"]
    )


class UserResponse(BaseModel):
    """Schema for user data in responses.

    This schema is used to serialize User model instances for API responses.

    Attributes:
        id: User's unique identifier
        email: User's email address
        full_name: User's full name
        created_at: Timestamp when the user was created

    Example:
        >>> response = UserResponse(
        ...     id=uuid.uuid4(),
        ...     email="user@example.com",
        ...     full_name="John Doe",
        ...     created_at=datetime.now()
        ... )
    """

    id: uuid.UUID = Field(
        ...,
        description="User's unique identifier"
    )

    email: str = Field(
        ...,
        description="User's email address",
        examples=["user@example.com"]
    )

    full_name: str = Field(
        ...,
        description="User's full name",
        examples=["John Doe"]
    )

    created_at: datetime = Field(
        ...,
        description="Timestamp when the user was created"
    )

    model_config = ConfigDict(
        from_attributes=True,
        json_schema_extra={
            "example": {
                "id": "123e4567-e89b-12d3-a456-426614174000",
                "email": "user@example.com",
                "full_name": "John Doe",
                "created_at": "2025-12-17T12:00:00Z"
            }
        }
    )
