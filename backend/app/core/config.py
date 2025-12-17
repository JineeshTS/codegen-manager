"""Application settings and configuration.

This module provides Pydantic Settings for managing environment variables
and application configuration with validation and type safety.
"""

from typing import List
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables.

    All settings can be overridden by environment variables or .env file.
    Environment variables should be uppercase (e.g., DATABASE_URL, SECRET_KEY).

    Attributes:
        APP_NAME: Application name
        DEBUG: Enable debug mode (default: False)
        ENVIRONMENT: Environment name (development, staging, production)
        DATABASE_URL: PostgreSQL connection string with asyncpg driver
        SECRET_KEY: Secret key for JWT token signing (min 32 characters)
        ALGORITHM: JWT algorithm (default: HS256)
        ACCESS_TOKEN_EXPIRE_MINUTES: JWT access token expiration in minutes
        REFRESH_TOKEN_EXPIRE_DAYS: JWT refresh token expiration in days
        CORS_ORIGINS: List of allowed CORS origins
    """

    # Application
    APP_NAME: str = Field(default="CodeGen Manager", description="Application name")
    DEBUG: bool = Field(default=False, description="Enable debug mode")
    ENVIRONMENT: str = Field(default="production", description="Environment name")

    # Database
    DATABASE_URL: str = Field(
        default="postgresql+asyncpg://postgres:postgres@localhost:5432/codegen_manager",
        description="PostgreSQL connection string with asyncpg driver",
    )

    # Security
    SECRET_KEY: str = Field(
        default="change-this-to-a-secure-secret-key-min-32-characters-long",
        description="Secret key for JWT token signing",
        min_length=32,
    )
    ALGORITHM: str = Field(default="HS256", description="JWT algorithm")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = Field(
        default=30,
        description="JWT access token expiration in minutes",
        ge=1,
    )
    REFRESH_TOKEN_EXPIRE_DAYS: int = Field(
        default=7,
        description="JWT refresh token expiration in days",
        ge=1,
    )

    # CORS
    CORS_ORIGINS: List[str] = Field(
        default=[
            "http://localhost:3000",
            "http://localhost:5000",
            "http://localhost:8080",
        ],
        description="List of allowed CORS origins",
    )

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
        extra="ignore",
    )


# Global settings instance
# This can be imported and used throughout the application
settings = Settings()
