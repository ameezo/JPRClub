import uuid
from datetime import datetime
from sqlalchemy import String, Integer, DateTime, ForeignKey, Enum, Text, JSON
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from app.db.database import Base
import enum

class SessionStatus(str, enum.Enum):
    draft = "draft"
    published = "published"
    cancelled = "cancelled"
    completed = "completed"

class Session(Base):
    __tablename__ = "sessions"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title: Mapped[str] = mapped_column(String, nullable=False)
    title_ar: Mapped[str | None] = mapped_column(String, nullable=True)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    description_ar: Mapped[str | None] = mapped_column(Text, nullable=True)
    material_type: Mapped[str] = mapped_column(String, nullable=False)
    chapters: Mapped[str | None] = mapped_column(String, nullable=True)
    level: Mapped[str | None] = mapped_column(String, nullable=True)
    
    scheduled_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    duration_minutes: Mapped[int | None] = mapped_column(Integer, nullable=True)
    status: Mapped[SessionStatus] = mapped_column(Enum(SessionStatus), default=SessionStatus.draft, nullable=False)
    cover_image_url: Mapped[str | None] = mapped_column(String, nullable=True)
    studio_content: Mapped[str | None] = mapped_column(Text, nullable=True)
    gallery_images: Mapped[list | None] = mapped_column(JSON, nullable=True, default=list)
    
    idempotency_key: Mapped[str | None] = mapped_column(String, unique=True, nullable=True)
    
    created_by: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)
    published_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    
    version: Mapped[int] = mapped_column(Integer, default=1, nullable=False)

    __mapper_args__ = {
        "version_id_col": version
    }
