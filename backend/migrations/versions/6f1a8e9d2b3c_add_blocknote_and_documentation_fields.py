"""Add blocknote and documentation fields to sessions and journal_submissions

Revision ID: 6f1a8e9d2b3c
Revises: 532235a66e11
Create Date: 2026-10-08 15:30:00.000000

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '6f1a8e9d2b3c'
down_revision: Union[str, Sequence[str], None] = '532235a66e11'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Add fields to sessions
    op.add_column(
        'sessions',
        sa.Column('studio_content_format', sa.String(), nullable=False, server_default='markdown')
    )
    op.add_column(
        'sessions',
        sa.Column('documentation_status', sa.String(), nullable=False, server_default='none')
    )

    # Backfill: mark already completed sessions with existing studio_content as published documentation
    op.execute("""
        UPDATE sessions 
        SET documentation_status = 'published' 
        WHERE status = 'completed' AND studio_content IS NOT NULL AND length(trim(studio_content)) > 0
    """)

    # 2. Add fields to journal_submissions
    op.add_column(
        'journal_submissions',
        sa.Column('cover_image_url', sa.String(), nullable=True)
    )
    op.add_column(
        'journal_submissions',
        sa.Column('content_format', sa.String(), nullable=False, server_default='markdown')
    )
    op.add_column(
        'journal_submissions',
        sa.Column('content_language', sa.String(), nullable=False, server_default='en')
    )


def downgrade() -> None:
    op.drop_column('journal_submissions', 'content_language')
    op.drop_column('journal_submissions', 'content_format')
    op.drop_column('journal_submissions', 'cover_image_url')

    op.drop_column('sessions', 'documentation_status')
    op.drop_column('sessions', 'studio_content_format')
