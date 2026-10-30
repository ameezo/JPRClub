import uuid
from datetime import datetime, date
from sqlalchemy import String, Integer, Date, DateTime, ForeignKey, Boolean, Text, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.sql import func
from app.db.database import Base

class AnnualReport(Base):
    __tablename__ = "annual_reports"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    year: Mapped[int] = mapped_column(Integer, nullable=False, index=True)
    # English default per user decision
    language: Mapped[str] = mapped_column(String(10), default="en", nullable=False)
    status: Mapped[str] = mapped_column(String(20), default="draft", nullable=False) # draft, published, archived
    
    # Active pointers to revisions (self-referential FKs with post_update)
    active_draft_revision_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("report_revisions.id", ondelete="SET NULL", use_alter=True, name="fk_annual_report_active_draft"),
        nullable=True
    )
    published_revision_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("report_revisions.id", ondelete="SET NULL", use_alter=True, name="fk_annual_report_published"),
        nullable=True
    )
    
    # Preserved legacy report metadata
    legacy_pdf_url: Mapped[str | None] = mapped_column(String, nullable=True)
    is_legacy: Mapped[bool] = mapped_column(Boolean, default=False, server_default=func.false(), nullable=False)
    
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    __table_args__ = (
        UniqueConstraint("year", "language", name="uq_annual_report_year_language"),
    )

    revisions = relationship(
        "ReportRevision",
        back_populates="report",
        foreign_keys="[ReportRevision.report_id]",
        cascade="all, delete-orphan"
    )
    active_draft_revision = relationship("ReportRevision", foreign_keys=[active_draft_revision_id], post_update=True)
    published_revision = relationship("ReportRevision", foreign_keys=[published_revision_id], post_update=True)


class ReportRevision(Base):
    __tablename__ = "report_revisions"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    report_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("annual_reports.id", ondelete="CASCADE"), nullable=False, index=True)
    revision_number: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    
    generated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    period_start: Mapped[date] = mapped_column(Date, nullable=False)
    period_end: Mapped[date] = mapped_column(Date, nullable=False)
    as_of_date: Mapped[date] = mapped_column(Date, nullable=False)
    is_year_to_date: Mapped[bool] = mapped_column(Boolean, default=False, server_default=func.false(), nullable=False)
    schema_version: Mapped[str] = mapped_column(String(20), default="1.0", nullable=False)
    
    # Immutable frozen snapshot of all metrics, distributions, quotes, and timeline
    snapshot_data: Mapped[dict] = mapped_column(JSONB, nullable=False)
    content_hash: Mapped[str] = mapped_column(String(64), nullable=False) # SHA-256
    
    # PDF storage artifact
    pdf_path: Mapped[str | None] = mapped_column(String, nullable=True)
    pdf_file_size: Mapped[int | None] = mapped_column(Integer, nullable=True)
    generation_status: Mapped[str] = mapped_column(String(30), default="draft_ready", nullable=False)
    error_message: Mapped[str | None] = mapped_column(Text, nullable=True)
    
    created_by: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    published_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    published_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    report = relationship("AnnualReport", back_populates="revisions", foreign_keys=[report_id])
