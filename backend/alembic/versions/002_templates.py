"""Add templates table

Revision ID: 002_templates
Revises: 001_initial
Create Date: 2025-12-17

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = '002_templates'
down_revision: Union[str, None] = '001_initial'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create templates table."""
    op.create_table(
        'templates',
        sa.Column('id', sa.UUID(), server_default=sa.text('gen_random_uuid()'), nullable=False),
        sa.Column('name', sa.String(length=255), nullable=False),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('content', sa.Text(), nullable=False),
        sa.Column('category', sa.String(length=100), nullable=False),
        sa.Column('language', sa.String(length=50), nullable=False),
        sa.Column('variables', postgresql.JSON(astext_type=sa.Text()), nullable=True),
        sa.Column('user_id', sa.UUID(), nullable=False),
        sa.Column('is_public', sa.Boolean(), server_default='false', nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_templates_name'), 'templates', ['name'], unique=False)
    op.create_index(op.f('ix_templates_category'), 'templates', ['category'], unique=False)
    op.create_index(op.f('ix_templates_language'), 'templates', ['language'], unique=False)
    op.create_index(op.f('ix_templates_user_id'), 'templates', ['user_id'], unique=False)


def downgrade() -> None:
    """Drop templates table."""
    op.drop_index(op.f('ix_templates_user_id'), table_name='templates')
    op.drop_index(op.f('ix_templates_language'), table_name='templates')
    op.drop_index(op.f('ix_templates_category'), table_name='templates')
    op.drop_index(op.f('ix_templates_name'), table_name='templates')
    op.drop_table('templates')
