"""Template database model.

This module defines the Template model for storing code generation templates.
"""

import uuid
from datetime import datetime
from typing import Optional, Dict, Any

from sqlalchemy import String, Text, Boolean, DateTime, ForeignKey, JSON
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.sql import func

from app.core.database import Base


class Template(Base):
    """Template model for code generation templates.

    Templates contain reusable code patterns with variables that can be
    filled in during code generation.

    Attributes:
        id: Unique template identifier (UUID)
        name: Template name
        description: Template description
        content: Template content with variable placeholders
        category: Template category (e.g., 'API', 'Database', 'Frontend')
        language: Programming language (e.g., 'Python', 'JavaScript')
        variables: JSON dict of template variables and their types
        user_id: ID of user who created the template
        is_public: Whether template is publicly accessible
        created_at: Timestamp when template was created
        updated_at: Timestamp when template was last updated
    """

    __tablename__ = "templates"

    id: Mapped[uuid.UUID] = mapped_column(
        primary_key=True,
        default=uuid.uuid4,
        server_default=func.gen_random_uuid(),
    )

    name: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
        index=True,
    )

    description: Mapped[Optional[str]] = mapped_column(
        Text,
        nullable=True,
    )

    content: Mapped[str] = mapped_column(
        Text,
        nullable=False,
    )

    category: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
        index=True,
    )

    language: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        index=True,
    )

    variables: Mapped[Optional[Dict[str, Any]]] = mapped_column(
        JSON,
        nullable=True,
        default=dict,
    )

    user_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )

    is_public: Mapped[bool] = mapped_column(
        Boolean,
        default=False,
        server_default="false",
        nullable=False,
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )

    updated_at: Mapped[Optional[datetime]] = mapped_column(
        DateTime(timezone=True),
        onupdate=func.now(),
        nullable=True,
    )

    def __repr__(self) -> str:
        """String representation of the Template."""
        return f"<Template(id={self.id}, name={self.name}, category={self.category})>"
