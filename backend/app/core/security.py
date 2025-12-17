"""Security utilities for password hashing and JWT token management.

This module provides functions for secure password hashing using bcrypt
and JWT token creation/verification using python-jose.
"""

from datetime import datetime, timedelta
from typing import Dict, Optional

from jose import JWTError, jwt
from passlib.context import CryptContext

from app.core.config import settings


# Password hashing context using bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password: str) -> str:
    """Hash a plain-text password using bcrypt.

    Args:
        password: Plain-text password to hash

    Returns:
        Hashed password string

    Example:
        >>> hashed = hash_password("mypassword123")
        >>> print(hashed)
        $2b$12$...
    """
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a plain-text password against a hashed password.

    Args:
        plain_password: Plain-text password to verify
        hashed_password: Hashed password to compare against

    Returns:
        True if password matches, False otherwise

    Example:
        >>> hashed = hash_password("mypassword123")
        >>> verify_password("mypassword123", hashed)
        True
        >>> verify_password("wrongpassword", hashed)
        False
    """
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(
    data: Dict[str, any],
    expires_delta: Optional[timedelta] = None
) -> str:
    """Create a JWT access token.

    Args:
        data: Dictionary of claims to encode in the token (e.g., {"sub": user_id})
        expires_delta: Optional custom expiration time. If not provided,
                      uses ACCESS_TOKEN_EXPIRE_MINUTES from settings

    Returns:
        Encoded JWT token string

    Example:
        >>> token = create_access_token({"sub": "user@example.com"})
        >>> print(token)
        eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
    """
    to_encode = data.copy()

    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(
            minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
        )

    to_encode.update({"exp": expire})

    encoded_jwt = jwt.encode(
        to_encode,
        settings.SECRET_KEY,
        algorithm=settings.ALGORITHM
    )

    return encoded_jwt


def verify_token(token: str) -> Dict[str, any]:
    """Verify and decode a JWT token.

    Args:
        token: JWT token string to verify

    Returns:
        Dictionary of decoded token claims

    Raises:
        JWTError: If token is invalid, expired, or malformed

    Example:
        >>> token = create_access_token({"sub": "user@example.com"})
        >>> payload = verify_token(token)
        >>> print(payload["sub"])
        user@example.com
    """
    try:
        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=[settings.ALGORITHM]
        )
        return payload
    except JWTError as e:
        raise JWTError(f"Token verification failed: {str(e)}")
