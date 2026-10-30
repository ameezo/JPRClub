from datetime import datetime, timezone
from typing import Annotated, Any
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc
from app.db.database import get_db
from app.models.user import User
from app.models.session import Session
from app.models.session_metrics import SessionMetrics, FeedbackQuote
from app.schemas.session_metrics import (
    SessionMetricsUpdate,
    SessionMetricsResponse,
    FeedbackQuoteCreate,
    FeedbackQuoteUpdate,
    FeedbackQuoteResponse,
)
from app.core.dependencies import get_current_admin_or_organizer

router = APIRouter(prefix="/sessions/{session_id}", tags=["session_metrics"])

@router.get("/metrics", response_model=SessionMetricsResponse)
async def get_session_metrics(
    session_id: UUID,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    session = await db.get(Session, session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")

    result = await db.execute(select(SessionMetrics).where(SessionMetrics.session_id == session_id))
    metrics = result.scalars().first()

    if not metrics:
        # Return empty default structure for this session without saving yet
        now = datetime.now(timezone.utc)
        return SessionMetricsResponse(
            id=session_id,
            session_id=session_id,
            version=1,
            actual_date=None,
            actual_duration_minutes=None,
            attendance_visits=None,
            attendance_in_person=None,
            attendance_online=None,
            attendance_counting_method=None,
            staff_included=False,
            feedback_cards_received=None,
            rating_1_count=0,
            rating_2_count=0,
            rating_3_count=0,
            rating_4_count=0,
            rating_5_count=0,
            unrated_count=0,
            tally_completed=False,
            internal_notes=None,
            ratings_sum=0,
            tally_reconciled=True,
            tally_difference=0,
            updated_by=None,
            created_at=now,
            updated_at=now,
        )

    return SessionMetricsResponse.from_orm_model(metrics)

@router.put("/metrics", response_model=SessionMetricsResponse)
async def update_session_metrics(
    session_id: UUID,
    metrics_in: SessionMetricsUpdate,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    session = await db.get(Session, session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")

    result = await db.execute(select(SessionMetrics).where(SessionMetrics.session_id == session_id))
    metrics = result.scalars().first()

    # Optimistic locking check
    if metrics and metrics_in.version is not None and metrics.version != metrics_in.version:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail={
                "message": "Session metrics have been modified by another user. Please reload and try again.",
                "current_version": metrics.version,
            }
        )

    # Completed tally reconciliation validation
    ratings_sum = (
        (metrics_in.rating_1_count or 0) +
        (metrics_in.rating_2_count or 0) +
        (metrics_in.rating_3_count or 0) +
        (metrics_in.rating_4_count or 0) +
        (metrics_in.rating_5_count or 0) +
        (metrics_in.unrated_count or 0)
    )

    if metrics_in.tally_completed:
        if metrics_in.feedback_cards_received is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Cannot mark feedback tally as complete without entering total cards received."
            )
        if ratings_sum != metrics_in.feedback_cards_received:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=(
                    f"Completed tally must reconcile: sum of ratings ({ratings_sum}) "
                    f"does not match feedback cards received ({metrics_in.feedback_cards_received})."
                )
            )
        if (metrics_in.attendance_in_person is not None and 
            metrics_in.attendance_online is not None and 
            metrics_in.attendance_visits is not None):
            if metrics_in.attendance_in_person + metrics_in.attendance_online != metrics_in.attendance_visits:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=(
                        f"Attendance split mismatch: in-person ({metrics_in.attendance_in_person}) + "
                        f"online ({metrics_in.attendance_online}) does not equal total visits ({metrics_in.attendance_visits})."
                    )
                )

    if not metrics:
        metrics = SessionMetrics(
            session_id=session_id,
            actual_date=metrics_in.actual_date,
            actual_duration_minutes=metrics_in.actual_duration_minutes,
            attendance_visits=metrics_in.attendance_visits,
            attendance_in_person=metrics_in.attendance_in_person,
            attendance_online=metrics_in.attendance_online,
            attendance_counting_method=metrics_in.attendance_counting_method,
            staff_included=metrics_in.staff_included,
            feedback_cards_received=metrics_in.feedback_cards_received,
            rating_1_count=metrics_in.rating_1_count or 0,
            rating_2_count=metrics_in.rating_2_count or 0,
            rating_3_count=metrics_in.rating_3_count or 0,
            rating_4_count=metrics_in.rating_4_count or 0,
            rating_5_count=metrics_in.rating_5_count or 0,
            unrated_count=metrics_in.unrated_count or 0,
            tally_completed=metrics_in.tally_completed,
            internal_notes=metrics_in.internal_notes,
            updated_by=current_user.id,
        )
        db.add(metrics)
    else:
        metrics.actual_date = metrics_in.actual_date
        metrics.actual_duration_minutes = metrics_in.actual_duration_minutes
        metrics.attendance_visits = metrics_in.attendance_visits
        metrics.attendance_in_person = metrics_in.attendance_in_person
        metrics.attendance_online = metrics_in.attendance_online
        metrics.attendance_counting_method = metrics_in.attendance_counting_method
        metrics.staff_included = metrics_in.staff_included
        metrics.feedback_cards_received = metrics_in.feedback_cards_received
        metrics.rating_1_count = metrics_in.rating_1_count or 0
        metrics.rating_2_count = metrics_in.rating_2_count or 0
        metrics.rating_3_count = metrics_in.rating_3_count or 0
        metrics.rating_4_count = metrics_in.rating_4_count or 0
        metrics.rating_5_count = metrics_in.rating_5_count or 0
        metrics.unrated_count = metrics_in.unrated_count or 0
        metrics.tally_completed = metrics_in.tally_completed
        metrics.internal_notes = metrics_in.internal_notes
        metrics.updated_by = current_user.id

    await db.commit()
    await db.refresh(metrics)
    return SessionMetricsResponse.from_orm_model(metrics)

# Quotes Sub-resources

@router.get("/quotes", response_model=list[FeedbackQuoteResponse])
async def list_session_quotes(
    session_id: UUID,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    session = await db.get(Session, session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")

    result = await db.execute(
        select(FeedbackQuote)
        .where(FeedbackQuote.session_id == session_id)
        .order_by(desc(FeedbackQuote.created_at))
    )
    quotes = result.scalars().all()
    return quotes

@router.post("/quotes", response_model=FeedbackQuoteResponse, status_code=status.HTTP_201_CREATED)
async def create_session_quote(
    session_id: UUID,
    quote_in: FeedbackQuoteCreate,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    session = await db.get(Session, session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")

    # If publication permission is requested, quote must be reviewed
    is_reviewed = quote_in.is_reviewed
    permission = quote_in.permission_to_publish
    if permission and not is_reviewed:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Quote must be recorded as reviewed before granting permission to publish."
        )

    now = datetime.now(timezone.utc)
    new_quote = FeedbackQuote(
        session_id=session_id,
        quote_text=quote_in.quote_text.strip(),
        source_language=quote_in.source_language,
        source_type=quote_in.source_type,
        permission_to_publish=permission,
        is_reviewed=is_reviewed,
        is_highlight=quote_in.is_highlight,
        reviewed_by=current_user.id if is_reviewed else None,
        reviewed_at=now if is_reviewed else None,
    )
    db.add(new_quote)
    await db.commit()
    await db.refresh(new_quote)
    return new_quote

@router.patch("/quotes/{quote_id}", response_model=FeedbackQuoteResponse)
async def update_session_quote(
    session_id: UUID,
    quote_id: UUID,
    quote_in: FeedbackQuoteUpdate,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    quote = await db.get(FeedbackQuote, quote_id)
    # Check that quote belongs to the session in the URL
    if not quote or quote.session_id != session_id:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Quote not found for this session"
        )

    now = datetime.now(timezone.utc)
    if quote_in.quote_text is not None:
        quote.quote_text = quote_in.quote_text.strip()
    if quote_in.source_language is not None:
        quote.source_language = quote_in.source_language
    if quote_in.source_type is not None:
        quote.source_type = quote_in.source_type
    if quote_in.is_highlight is not None:
        quote.is_highlight = quote_in.is_highlight

    if quote_in.is_reviewed is not None:
        quote.is_reviewed = quote_in.is_reviewed
        if quote_in.is_reviewed:
            quote.reviewed_by = current_user.id
            quote.reviewed_at = now
        else:
            quote.reviewed_by = None
            quote.reviewed_at = None
            quote.permission_to_publish = False  # Unreviewed quotes cannot have publication permission

    if quote_in.permission_to_publish is not None:
        if quote_in.permission_to_publish:
            if not quote.is_reviewed and not (quote_in.is_reviewed is True):
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Quote must be recorded as reviewed before granting permission to publish."
                )
            quote.permission_to_publish = True
        else:
            # Revocation / withdrawal workflow
            quote.permission_to_publish = False

    await db.commit()
    await db.refresh(quote)
    return quote

@router.delete("/quotes/{quote_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_session_quote(
    session_id: UUID,
    quote_id: UUID,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> None:
    quote = await db.get(FeedbackQuote, quote_id)
    # Check that quote belongs to the session in the URL
    if not quote or quote.session_id != session_id:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Quote not found for this session"
        )

    await db.delete(quote)
    await db.commit()
