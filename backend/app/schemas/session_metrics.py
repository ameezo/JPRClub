from pydantic import BaseModel, Field, field_validator, ConfigDict
from uuid import UUID
from datetime import datetime, date
from typing import Optional

class SessionMetricsBase(BaseModel):
    actual_date: Optional[date] = None
    actual_duration_minutes: Optional[int] = Field(None, ge=0)
    
    # Null = unknown; 0 = confirmed zero (strictly distinguished)
    attendance_visits: Optional[int] = Field(None, ge=0)
    attendance_in_person: Optional[int] = Field(None, ge=0)
    attendance_online: Optional[int] = Field(None, ge=0)
    attendance_counting_method: Optional[str] = Field(None, max_length=50)
    staff_included: bool = False
    
    feedback_cards_received: Optional[int] = Field(None, ge=0)
    rating_1_count: int = Field(0, ge=0)
    rating_2_count: int = Field(0, ge=0)
    rating_3_count: int = Field(0, ge=0)
    rating_4_count: int = Field(0, ge=0)
    rating_5_count: int = Field(0, ge=0)
    unrated_count: int = Field(0, ge=0)
    
    tally_completed: bool = False
    internal_notes: Optional[str] = None

class SessionMetricsUpdate(SessionMetricsBase):
    version: Optional[int] = None

    @field_validator("attendance_visits")
    @classmethod
    def validate_visits(cls, v):
        if v is not None and v < 0:
            raise ValueError("attendance_visits cannot be negative")
        return v

class SessionMetricsResponse(SessionMetricsBase):
    id: UUID
    session_id: UUID
    version: int
    ratings_sum: int = 0
    tally_reconciled: bool = True
    tally_difference: int = 0
    updated_by: Optional[UUID] = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)

    @classmethod
    def from_orm_model(cls, obj) -> "SessionMetricsResponse":
        ratings_sum = (
            (obj.rating_1_count or 0) +
            (obj.rating_2_count or 0) +
            (obj.rating_3_count or 0) +
            (obj.rating_4_count or 0) +
            (obj.rating_5_count or 0) +
            (obj.unrated_count or 0)
        )
        cards = obj.feedback_cards_received
        reconciled = (cards is None) or (ratings_sum == cards)
        diff = (cards or 0) - ratings_sum if cards is not None else 0

        return cls(
            id=obj.id,
            session_id=obj.session_id,
            actual_date=obj.actual_date,
            actual_duration_minutes=obj.actual_duration_minutes,
            attendance_visits=obj.attendance_visits,
            attendance_in_person=obj.attendance_in_person,
            attendance_online=obj.attendance_online,
            attendance_counting_method=obj.attendance_counting_method,
            staff_included=obj.staff_included,
            feedback_cards_received=obj.feedback_cards_received,
            rating_1_count=obj.rating_1_count or 0,
            rating_2_count=obj.rating_2_count or 0,
            rating_3_count=obj.rating_3_count or 0,
            rating_4_count=obj.rating_4_count or 0,
            rating_5_count=obj.rating_5_count or 0,
            unrated_count=obj.unrated_count or 0,
            tally_completed=obj.tally_completed,
            internal_notes=obj.internal_notes,
            version=obj.version,
            ratings_sum=ratings_sum,
            tally_reconciled=reconciled,
            tally_difference=diff,
            updated_by=obj.updated_by,
            created_at=obj.created_at,
            updated_at=obj.updated_at,
        )


class FeedbackQuoteBase(BaseModel):
    quote_text: str = Field(..., min_length=1)
    source_language: str = Field("en", max_length=10)
    source_type: str = Field("in_person_card", max_length=50)
    permission_to_publish: bool = False  # Strict default False
    is_reviewed: bool = False           # Strict default False
    is_highlight: bool = False

class FeedbackQuoteCreate(FeedbackQuoteBase):
    pass

class FeedbackQuoteUpdate(BaseModel):
    quote_text: Optional[str] = Field(None, min_length=1)
    source_language: Optional[str] = Field(None, max_length=10)
    source_type: Optional[str] = Field(None, max_length=50)
    permission_to_publish: Optional[bool] = None
    is_reviewed: Optional[bool] = None
    is_highlight: Optional[bool] = None

class FeedbackQuoteResponse(FeedbackQuoteBase):
    id: UUID
    session_id: UUID
    reviewed_by: Optional[UUID] = None
    reviewed_at: Optional[datetime] = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
