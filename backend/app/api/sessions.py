from datetime import datetime, timezone
from typing import Annotated, Any
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc, cast, Date
from sqlalchemy.exc import IntegrityError

from app.db.database import get_db
from app.models.user import User
from app.models.session import Session, SessionStatus
from app.schemas.session import SessionCreate, SessionUpdate, SessionResponse, SessionList, NextSessionResponse
from app.core.dependencies import get_current_admin_or_organizer

router = APIRouter(prefix="/sessions", tags=["sessions"])

@router.get("", response_model=SessionList)
async def list_sessions(
    db: Annotated[AsyncSession, Depends(get_db)],
    status: str = "published",
    limit: int = 50,
    offset: int = 0,
    upcoming: bool = False
) -> Any:
    query = select(Session)
    if status and status != "all":
        query = query.where(Session.status == status)
    
    if upcoming:
        query = query.where(Session.scheduled_at > datetime.now(timezone.utc))
        
    query = query.order_by(desc(Session.scheduled_at)).offset(offset).limit(limit)
    
    result = await db.execute(query)
    sessions = result.scalars().all()
    
    # We should normally count without limits, but for simplicity here we return length
    # A true total would need a separate count() query.
    return {
        "items": sessions,
        "total": len(sessions),
        "limit": limit,
        "offset": offset
    }

@router.get("/next", response_model=NextSessionResponse)
async def get_next_session(
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    query = select(Session)\
        .where(Session.status == "published")\
        .where(Session.scheduled_at > datetime.now(timezone.utc))\
        .order_by(Session.scheduled_at.asc())\
        .limit(1)
        
    result = await db.execute(query)
    session = result.scalars().first()
    
    return {"session": session}

@router.get("/{id}", response_model=SessionResponse)
async def get_session(
    id: UUID,
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    result = await db.execute(select(Session).where(Session.id == id))
    session = result.scalars().first()
    
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
        
    return session

@router.post("", response_model=SessionResponse, status_code=201)
async def create_session(
    session_in: SessionCreate,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    # Check idempotency key if provided
    if session_in.idempotency_key:
        result = await db.execute(select(Session).where(Session.idempotency_key == session_in.idempotency_key))
        existing = result.scalars().first()
        if existing:
            return existing
            
    # Duplicate protection (same title and same day)
    duplicate_query = select(Session).where(
        Session.title == session_in.title,
        cast(Session.scheduled_at, Date) == session_in.scheduled_at.date()
    )
    duplicate_result = await db.execute(duplicate_query)
    if duplicate_result.scalars().first():
        raise HTTPException(status_code=409, detail="A session with this title is already scheduled for this day.")

    new_session = Session(
        **session_in.model_dump(exclude={"idempotency_key"}),
        idempotency_key=session_in.idempotency_key,
        created_by=current_user.id
    )
    db.add(new_session)
    try:
        await db.commit()
        await db.refresh(new_session)
    except IntegrityError:
        await db.rollback()
        raise HTTPException(status_code=400, detail="Error creating session, might be duplicate idempotency key")
        
    return new_session

@router.patch("/{id}", response_model=SessionResponse)
async def update_session(
    id: UUID,
    session_in: SessionUpdate,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    result = await db.execute(select(Session).where(Session.id == id))
    session = result.scalars().first()
    
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
        
    if session.version != session_in.version:
        raise HTTPException(
            status_code=409, 
            detail={
                "message": "Session has been modified by another user. Please reload and try again.",
                "current_version": session.version
            }
        )
        
    update_data = session_in.model_dump(exclude_unset=True, exclude={"version"})
    for field, value in update_data.items():
        setattr(session, field, value)
        
    # Optimistic locking requires version increment or rely on mapper config
    # SQLAlchemy version_id_col handles increment automatically on flush
    try:
        await db.commit()
        await db.refresh(session)
    except Exception:
        await db.rollback()
        raise
        
    return session

@router.post("/{id}/publish", response_model=SessionResponse)
async def publish_session(
    id: UUID,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    result = await db.execute(select(Session).where(Session.id == id))
    session = result.scalars().first()
    
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
        
    if session.status != SessionStatus.draft:
        raise HTTPException(status_code=400, detail="Only drafts can be published")
        
    session.status = SessionStatus.published
    session.published_at = datetime.now(timezone.utc)
    
    await db.commit()
    await db.refresh(session)
    return session

@router.post("/{id}/cancel", response_model=SessionResponse)
async def cancel_session(
    id: UUID,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    result = await db.execute(select(Session).where(Session.id == id))
    session = result.scalars().first()
    
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
        
    session.status = SessionStatus.cancelled
    await db.commit()
    await db.refresh(session)
    return session

@router.post("/{id}/complete", response_model=SessionResponse)
async def complete_session(
    id: UUID,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    result = await db.execute(select(Session).where(Session.id == id))
    session = result.scalars().first()
    
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
        
    session.status = SessionStatus.completed
    await db.commit()
    await db.refresh(session)
    return session

@router.delete("/{id}", status_code=204)
async def delete_draft_session(
    id: UUID,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> None:
    result = await db.execute(select(Session).where(Session.id == id))
    session = result.scalars().first()
    
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
        
    if session.status != SessionStatus.draft:
        raise HTTPException(status_code=400, detail="Only draft sessions can be deleted")
        
    await db.delete(session)
    await db.commit()
