import uuid
from datetime import datetime
from sqlalchemy import String, DateTime, ForeignKey, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from app.db.database import Base
from app.models.session import Session

class SessionInterest(Base):
    __tablename__ = "session_interests"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    type: Mapped[str] = mapped_column(String(50), nullable=False, index=True) # "attendance", "volunteer", "team", "instructor"
    full_name: Mapped[str] = mapped_column(String(255), nullable=False)
    email: Mapped[str] = mapped_column(String(255), nullable=False, index=True)
    phone: Mapped[str] = mapped_column(String(100), nullable=False)
    message: Mapped[str] = mapped_column(Text, nullable=True, default="")
    
    session_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True), 
        ForeignKey("sessions.id", ondelete="SET NULL"), 
        nullable=True, 
        index=True
    )
    status: Mapped[str] = mapped_column(String(50), default="new", nullable=False, index=True) # "new", "reviewed", "contacted", "archived"
    
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    
    session: Mapped["Session"] = relationship("Session", lazy="selectin")

    @property
    def session_title(self) -> str | None:
        return self.session.title if self.session else None
