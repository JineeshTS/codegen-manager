"""Database configuration and session management.

This module provides SQLAlchemy async engine, session factory, base model class,
and FastAPI dependency for database sessions.
"""

import os
from typing import AsyncGenerator

from sqlalchemy.ext.asyncio import (
    AsyncSession,
    create_async_engine,
    async_sessionmaker,
)
from sqlalchemy.orm import DeclarativeBase


# Database URL from environment variable with fallback default
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+asyncpg://postgres:postgres@localhost:5432/codegen_manager"
)

# Create async engine with connection pooling
engine = create_async_engine(
    DATABASE_URL,
    echo=False,  # Set to True for SQL query logging in development
    pool_pre_ping=True,  # Verify connections before using them
    pool_size=5,  # Maximum number of permanent connections
    max_overflow=10,  # Maximum number of temporary connections
)

# Create async session factory
async_session = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,  # Don't expire objects after commit
    autocommit=False,  # Explicit transaction control
    autoflush=False,  # Manual flush control
)


class Base(DeclarativeBase):
    """Base class for all SQLAlchemy models.

    All database models should inherit from this class to be included
    in the SQLAlchemy metadata and support automatic table creation.
    """
    pass


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """FastAPI dependency that provides a database session.

    This async generator creates a new database session for each request,
    automatically commits on success, rolls back on error, and always
    closes the session when done.

    Yields:
        AsyncSession: SQLAlchemy async session for database operations

    Example:
        ```python
        @router.get("/users")
        async def get_users(db: AsyncSession = Depends(get_db)):
            result = await db.execute(select(User))
            return result.scalars().all()
        ```
    """
    async with async_session() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()
