from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc, func
from typing import Annotated
from uuid import UUID
from datetime import datetime, timezone

from app.db.database import get_db
from app.models.journal import JournalSubmission, JournalStatus
from app.models.user import User
from app.schemas.journal import (
    JournalSubmissionCreate,
    JournalSubmissionUpdate,
    JournalSubmissionResponse,
    JournalSubmissionList
)
from app.core.dependencies import (
    get_current_user,
    get_current_user_optional,
    get_current_admin_or_organizer,
    get_current_verified_user
)

router = APIRouter(prefix="/journal", tags=["journal"])

@router.get("/public", response_model=JournalSubmissionList)
async def list_public_journal_entries(
    db: Annotated[AsyncSession, Depends(get_db)],
    limit: int = Query(10, ge=1, le=100),
    offset: int = Query(0, ge=0)
):
    query = select(JournalSubmission).where(JournalSubmission.status == JournalStatus.approved)
    total_query = select(func.count()).select_from(query.subquery())
    total = await db.scalar(total_query) or 0
    
    query = query.order_by(
        desc(JournalSubmission.published_at).nulls_last(),
        desc(JournalSubmission.created_at)
    ).offset(offset).limit(limit)
    result = await db.execute(query)
    submissions = result.scalars().all()
    
    return {
        "items": submissions,
        "total": total,
        "limit": limit,
        "offset": offset
    }

@router.get("", response_model=JournalSubmissionList)
async def list_journal_submissions(
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
    status: str = "all",
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0)
):
    query = select(JournalSubmission)
    
    # If not admin/organizer, only see own submissions
    if current_user.role not in ["admin", "organizer"]:
        query = query.where(JournalSubmission.author_id == current_user.id)
        
    if status != "all":
        try:
            query = query.where(JournalSubmission.status == JournalStatus(status))
        except ValueError:
            pass # Invalid status, ignore
            
    total_query = select(func.count()).select_from(query.subquery())
    total = await db.scalar(total_query) or 0
    
    query = query.order_by(desc(JournalSubmission.created_at)).offset(offset).limit(limit)
    result = await db.execute(query)
    submissions = result.scalars().all()
    
    return {
        "items": submissions,
        "total": total,
        "limit": limit,
        "offset": offset
    }

@router.post("", response_model=JournalSubmissionResponse, status_code=201)
async def create_journal_submission(
    submission: JournalSubmissionCreate,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_verified_user)]
):
    # Members can submit as draft or pending (for review)
    initial_status = JournalStatus.draft
    if submission.status in [JournalStatus.draft, JournalStatus.pending]:
        initial_status = submission.status
    elif current_user.role in ["admin", "organizer"] and submission.status:
        initial_status = submission.status

    submission_data = submission.model_dump(exclude={"status"})
    db_submission = JournalSubmission(
        **submission_data,
        author_id=current_user.id,
        status=initial_status
    )
    db.add(db_submission)
    await db.commit()
    await db.refresh(db_submission)
    return db_submission

@router.get("/{id}", response_model=JournalSubmissionResponse)
async def get_journal_submission(
    id: UUID,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User | None, Depends(get_current_user_optional)] = None
):
    result = await db.execute(select(JournalSubmission).where(JournalSubmission.id == id))
    submission = result.scalars().first()
    
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")
        
    # Approved entries can be viewed publicly by anyone
    if submission.status == JournalStatus.approved:
        return submission
        
    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication required to view non-approved submission"
        )
        
    if current_user.role not in ["admin", "organizer"] and submission.author_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to view this submission")
        
    return submission

@router.put("/{id}", response_model=JournalSubmissionResponse)
@router.patch("/{id}", response_model=JournalSubmissionResponse)
async def update_journal_submission(
    id: UUID,
    submission_in: JournalSubmissionUpdate,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)]
):
    result = await db.execute(select(JournalSubmission).where(JournalSubmission.id == id))
    submission = result.scalars().first()
    
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")
        
    if current_user.role not in ["admin", "organizer"] and submission.author_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this submission")
        
    if submission_in.version is not None and submission.version != submission_in.version:
        raise HTTPException(status_code=409, detail="Conflict: document has been modified by another request")
        
    update_data = submission_in.model_dump(exclude_unset=True)
    
    # Only admins can change status directly via patch (e.g. to approved)
    if "status" in update_data and current_user.role not in ["admin", "organizer"]:
        # Users can only submit for review
        if update_data["status"] == JournalStatus.pending and submission.status in [JournalStatus.draft, JournalStatus.rejected]:
            pass # allowed
        elif update_data["status"] == JournalStatus.draft and submission.status in [JournalStatus.draft]:
            pass # allowed
        else:
            del update_data["status"]
            
    for field, value in update_data.items():
        if field != "version":
            setattr(submission, field, value)
            
    if submission.status == JournalStatus.approved and not submission.published_at:
        submission.published_at = datetime.now(timezone.utc)
        
    await db.commit()
    await db.refresh(submission)
    return submission

@router.post("/{id}/approve", response_model=JournalSubmissionResponse)
async def approve_journal_submission(
    id: UUID,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)]
):
    result = await db.execute(select(JournalSubmission).where(JournalSubmission.id == id))
    submission = result.scalars().first()
    
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")
        
    submission.status = JournalStatus.approved
    if not submission.published_at:
        submission.published_at = datetime.now(timezone.utc)
        
    await db.commit()
    await db.refresh(submission)
    return submission

@router.post("/{id}/reject", response_model=JournalSubmissionResponse)
async def reject_journal_submission(
    id: UUID,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)]
):
    result = await db.execute(select(JournalSubmission).where(JournalSubmission.id == id))
    submission = result.scalars().first()
    
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")
        
    submission.status = JournalStatus.rejected
    await db.commit()
    await db.refresh(submission)
    return submission

@router.delete("/{id}", status_code=204)
async def delete_journal_submission(
    id: UUID,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)]
):
    result = await db.execute(select(JournalSubmission).where(JournalSubmission.id == id))
    submission = result.scalars().first()
    
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")
        
    if current_user.role not in ["admin", "organizer"] and submission.author_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this submission")
        
    await db.delete(submission)
    await db.commit()
    return None
