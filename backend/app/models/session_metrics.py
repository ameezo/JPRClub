import uuid
from datetime import datetime, date
from sqlalchemy import String, Integer, Date, DateTime, ForeignKey, Boolean, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from app.db.database import Base

class SessionMetrics(Base):
    __tablename__ = "session_metrics"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    session_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("sessions.id", ondelete="CASCADE"), unique=True, nullable=False, index=True)
    
    # Rescheduled actual date (if different from scheduled_at)
    actual_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    actual_duration_minutes: Mapped[int | None] = mapped_column(Integer, nullable=True)
    
    # Attendance visits: null = unknown, 0 = confirmed zero (distinct!)
    attendance_visits: Mapped[int | None] = mapped_column(Integer, nullable=True)
    attendance_in_person: Mapped[int | None] = mapped_column(Integer, nullable=True)
    attendance_online: Mapped[int | None] = mapped_column(Integer, nullable=True)
    attendance_counting_method: Mapped[str | None] = mapped_column(String(50), nullable=True)
    staff_included: Mapped[bool] = mapped_column(Boolean, default=False, server_default=func.false(), nullable=False)
    
    # Feedback card counts and 1-5 ratings
    feedback_cards_received: Mapped[int | None] = mapped_column(Integer, nullable=True)
    rating_1_count: Mapped[int] = mapped_column(Integer, default=0, server_default="0", nullable=False)
    rating_2_count: Mapped[int] = mapped_column(Integer, default=0, server_default="0", nullable=False)
    rating_3_count: Mapped[int] = mapped_column(Integer, default=0, server_default="0", nullable=False)
    rating_4_count: Mapped[int] = mapped_column(Integer, default=0, server_default="0", nullable=False)
    rating_5_count: Mapped[int] = mapped_column(Integer, default=0, server_default="0", nullable=False)
    unrated_count: Mapped[int] = mapped_column(Integer, default=0, server_default="0", nullable=False)
    
    # Flag indicating whether tally entry is finalized/reconciled
    tally_completed: Mapped[bool] = mapped_column(Boolean, default=False, server_default=func.false(), nullable=False)
    
    # Internal moderator/admin notes (strictly omitted from public responses)
    internal_notes: Mapped[str | None] = mapped_column(Text, nullable=True)
    
    updated_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)
    
    # Optimistic locking version
    version: Mapped[int] = mapped_column(Integer, default=1, nullable=False)

    __mapper_args__ = {
        "version_id_col": version
    }

    session = relationship("Session", back_populates="metrics")


class FeedbackQuote(Base):
    __tablename__ = "feedback_quotes"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    session_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("sessions.id", ondelete="CASCADE"), nullable=False, index=True)
    
    quote_text: Mapped[str] = mapped_column(Text, nullable=False)
    source_language: Mapped[str] = mapped_column(String(10), default="en", nullable=False)
    source_type: Mapped[str] = mapped_column(String(50), default="in_person_card", nullable=False)
    
    # Defaults strictly to False per privacy specification
    permission_to_publish: Mapped[bool] = mapped_column(Boolean, default=False, server_default=func.false(), nullable=False)
    is_reviewed: Mapped[bool] = mapped_column(Boolean, default=False, server_default=func.false(), nullable=False)
    is_highlight: Mapped[bool] = mapped_column(Boolean, default=False, server_default=func.false(), nullable=False)
    
    reviewed_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    reviewed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    session = relationship("Session", back_populates="quotes")
