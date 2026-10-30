from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Float
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
from app.db.database import Base

class AuditLog(Base):
    __tablename__ = "audit_logs"

    id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime(timezone=True), server_default=func.now(), index=True)
    method = Column(String(10), index=True)
    path = Column(String(255), index=True)
    ip_address = Column(String(50))
    user_agent = Column(String(512))
    status_code = Column(Integer, index=True)
    process_time = Column(Float)  # in seconds
    
    # Optional: Associate with a user if they are logged in
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="SET NULL"), nullable=True, index=True)
    
    user = relationship("User")
