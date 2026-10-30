import uuid
from datetime import datetime
from sqlalchemy import String, Integer, DateTime, ForeignKey, Enum, Text, JSON
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from app.db.database import Base
from app.models.user import User
import enum

class JournalStatus(str, enum.Enum):
    draft = "draft"
    pending = "pending"
    approved = "approved"
    rejected = "rejected"

class JournalSubmission(Base):
    __tablename__ = "journal_submissions"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title: Mapped[str] = mapped_column(String, nullable=False)
    title_ar: Mapped[str | None] = mapped_column(String, nullable=True)
    content: Mapped[str] = mapped_column(Text, nullable=False)
    content_ar: Mapped[str | None] = mapped_column(Text, nullable=True)
    content_format: Mapped[str] = mapped_column(String, default="markdown", nullable=False)
    content_language: Mapped[str] = mapped_column(String, default="en", nullable=False)
    cover_image_url: Mapped[str | None] = mapped_column(String, nullable=True)
    
    status: Mapped[JournalStatus] = mapped_column(Enum(JournalStatus), default=JournalStatus.draft, nullable=False)
    
    author_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    author: Mapped["User"] = relationship("User", lazy="selectin")
    
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)
    published_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    
    version: Mapped[int] = mapped_column(Integer, default=1, nullable=False)

    @property
    def author_name(self) -> str | None:
        return self.author.name if self.author else None

    __mapper_args__ = {
        "version_id_col": version
    }
