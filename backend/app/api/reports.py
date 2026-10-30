import os
from datetime import datetime, date, timezone
from typing import Annotated, Any, List, Optional
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.responses import FileResponse
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc
from sqlalchemy.orm import selectinload

from app.db.database import get_db
from app.models.user import User
from app.models.report import AnnualReport, ReportRevision
from app.models.session import Session, SessionStatus
from app.schemas.report import (
    ReportYearSummary,
    MissingDataChecklist,
    ReportDraftGenerateRequest,
    ReportPublishRequest,
    ReportRevisionResponse,
    PublicReportListItem,
)
from app.core.dependencies import get_current_admin_or_organizer, get_current_user_optional
from app.services.report_engine import ReportEngine

router = APIRouter(tags=["reports"])

# ================= ADMIN ROUTES =================

@router.get("/admin/reports/years", response_model=List[ReportYearSummary])
async def list_report_years(
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    tz = ReportEngine.get_timezone()

    # 1. Get all completed sessions to discover session years
    sess_stmt = select(Session).where(
        Session.status == SessionStatus.completed,
        Session.exclude_from_reports == False,
    ).options(selectinload(Session.metrics))
    sess_res = await db.execute(sess_stmt)
    sessions = sess_res.scalars().all()

    year_session_counts: dict[int, int] = {}
    for s in sessions:
        eff_date = ReportEngine.get_session_effective_date(s, tz)
        year_session_counts[eff_date.year] = year_session_counts.get(eff_date.year, 0) + 1

    # 2. Get all existing AnnualReport records
    rep_stmt = select(AnnualReport).order_by(desc(AnnualReport.year))
    rep_res = await db.execute(rep_stmt)
    reports = rep_res.scalars().all()
    reports_by_year = {r.year: r for r in reports}

    # Combine all years discovered
    all_years = sorted(set(list(year_session_counts.keys()) + list(reports_by_year.keys())), reverse=True)
    if not all_years:
        all_years = [datetime.now(tz).year]

    summaries = []
    current_year = datetime.now(tz).year
    for yr in all_years:
        r = reports_by_year.get(yr)
        sess_count = year_session_counts.get(yr, 0)
        
        status_val = r.status if r else "not_generated"
        is_legacy = r.is_legacy if r else False
        legacy_url = r.legacy_pdf_url if r else None
        active_draft = r.active_draft_revision_id if r else None
        published_rev = r.published_revision_id if r else None

        summaries.append(ReportYearSummary(
            year=yr,
            language=r.language if r else "en",
            status=status_val,
            report_id=r.id if r else None,
            active_draft_revision_id=active_draft,
            published_revision_id=published_rev,
            is_legacy=is_legacy,
            legacy_pdf_url=legacy_url,
            is_year_to_date=(yr == current_year),
            completed_sessions_count=sess_count,
            updated_at=r.updated_at if r else None,
        ))

    return summaries

@router.get("/admin/reports/{year}/missing-data-checklist", response_model=MissingDataChecklist)
async def get_missing_data_checklist(
    year: int,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    return await ReportEngine.compute_missing_data_checklist(db, year)

@router.post("/admin/reports/{year}/draft", response_model=ReportRevisionResponse)
async def generate_report_draft(
    year: int,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)],
    payload: ReportDraftGenerateRequest = ReportDraftGenerateRequest()
) -> Any:
    revision = await ReportEngine.create_or_rebuild_draft(
        db=db,
        year=year,
        user_id=current_user.id,
        language=payload.language
    )

    report_stmt = select(AnnualReport).where(AnnualReport.id == revision.report_id)
    report_res = await db.execute(report_stmt)
    report = report_res.scalars().first()

    return ReportRevisionResponse(
        id=revision.id,
        report_id=revision.report_id,
        year=report.year,
        language=report.language,
        revision_number=revision.revision_number,
        generated_at=revision.generated_at,
        period_start=revision.period_start,
        period_end=revision.period_end,
        as_of_date=revision.as_of_date,
        is_year_to_date=revision.is_year_to_date,
        schema_version=revision.schema_version,
        snapshot_data=revision.snapshot_data,
        content_hash=revision.content_hash,
        pdf_path=revision.pdf_path,
        pdf_file_size=revision.pdf_file_size,
        generation_status=revision.generation_status,
        error_message=revision.error_message,
        created_by=revision.created_by,
        published_at=revision.published_at,
        published_by=revision.published_by,
        created_at=revision.created_at,
    )

@router.get("/admin/reports/{year}/draft", response_model=ReportRevisionResponse)
async def get_active_draft_revision(
    year: int,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)],
    language: str = "en"
) -> Any:
    stmt = (
        select(AnnualReport)
        .where(AnnualReport.year == year, AnnualReport.language == language)
        .options(selectinload(AnnualReport.active_draft_revision))
    )
    result = await db.execute(stmt)
    report = result.scalars().first()

    if not report or not report.active_draft_revision:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"No active draft revision found for year {year} ({language})."
        )

    rev = report.active_draft_revision
    return ReportRevisionResponse(
        id=rev.id,
        report_id=rev.report_id,
        year=report.year,
        language=report.language,
        revision_number=rev.revision_number,
        generated_at=rev.generated_at,
        period_start=rev.period_start,
        period_end=rev.period_end,
        as_of_date=rev.as_of_date,
        is_year_to_date=rev.is_year_to_date,
        schema_version=rev.schema_version,
        snapshot_data=rev.snapshot_data,
        content_hash=rev.content_hash,
        pdf_path=rev.pdf_path,
        pdf_file_size=rev.pdf_file_size,
        generation_status=rev.generation_status,
        error_message=rev.error_message,
        created_by=rev.created_by,
        published_at=rev.published_at,
        published_by=rev.published_by,
        created_at=rev.created_at,
    )

@router.post("/admin/reports/{year}/publish", response_model=ReportRevisionResponse)
async def publish_report_revision(
    year: int,
    payload: ReportPublishRequest,
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    rev = await db.get(ReportRevision, payload.revision_id)
    if not rev:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Revision not found")

    report = await db.get(AnnualReport, rev.report_id)
    if not report or report.year != year:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Revision does not match specified year")

    # Manual publish action gate
    now = datetime.now(timezone.utc)
    report.published_revision_id = rev.id
    report.status = "published"
    
    rev.published_at = now
    rev.published_by = current_user.id
    rev.generation_status = "published"

    await db.commit()
    await db.refresh(rev)

    return ReportRevisionResponse(
        id=rev.id,
        report_id=rev.report_id,
        year=report.year,
        language=report.language,
        revision_number=rev.revision_number,
        generated_at=rev.generated_at,
        period_start=rev.period_start,
        period_end=rev.period_end,
        as_of_date=rev.as_of_date,
        is_year_to_date=rev.is_year_to_date,
        schema_version=rev.schema_version,
        snapshot_data=rev.snapshot_data,
        content_hash=rev.content_hash,
        pdf_path=rev.pdf_path,
        pdf_file_size=rev.pdf_file_size,
        generation_status=rev.generation_status,
        error_message=rev.error_message,
        created_by=rev.created_by,
        published_at=rev.published_at,
        published_by=rev.published_by,
        created_at=rev.created_at,
    )

# ================= PUBLIC ROUTES =================

@router.get("/reports", response_model=List[PublicReportListItem])
async def list_public_reports(
    db: Annotated[AsyncSession, Depends(get_db)]
) -> Any:
    stmt = (
        select(AnnualReport)
        .where(AnnualReport.status.in_(["published", "archived"]))
        .options(selectinload(AnnualReport.published_revision))
        .order_by(desc(AnnualReport.year))
    )
    result = await db.execute(stmt)
    reports = result.scalars().all()

    items = []
    for r in reports:
        if r.is_legacy and r.legacy_pdf_url:
            items.append(PublicReportListItem(
                year=r.year,
                language=r.language,
                title=f"JPR Club Annual Report {r.year}",
                description=f"Archived report for {r.year}. Preserved official club documentation.",
                is_legacy=True,
                is_year_to_date=False,
                as_of_date=date(r.year, 12, 31),
                has_web_report=False,
                has_pdf_download=True,
                download_url=f"/api/reports/{r.year}/download",
                web_url=None,
                published_at=r.created_at,
            ))
        elif r.published_revision:
            rev = r.published_revision
            meta = rev.snapshot_data.get("metadata", {})
            metrics = rev.snapshot_data.get("summary_metrics", {})
            held = metrics.get("sessions_held", 0)
            visits = metrics.get("total_attendance_visits", 0)

            items.append(PublicReportListItem(
                year=r.year,
                language=r.language,
                title=f"JPR Club Annual Report {r.year}",
                description=f"Comprehensive documentation covering {held} completed sessions and {visits} attendance visits.",
                is_legacy=False,
                is_year_to_date=rev.is_year_to_date,
                as_of_date=rev.as_of_date,
                has_web_report=True,
                has_pdf_download=bool(rev.pdf_path),
                download_url=f"/api/reports/{r.year}/download",
                web_url=f"/reports/{r.year}",
                published_at=rev.published_at,
            ))

    return items

@router.get("/reports/{year}")
async def get_public_report_snapshot(
    year: int,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[Optional[User], Depends(get_current_user_optional)] = None,
    language: str = "en",
    draft: bool = False
) -> Any:
    stmt = (
        select(AnnualReport)
        .where(AnnualReport.year == year, AnnualReport.language == language)
        .options(
            selectinload(AnnualReport.published_revision),
            selectinload(AnnualReport.active_draft_revision),
        )
    )
    result = await db.execute(stmt)
    report = result.scalars().first()

    if not report:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"No annual report found for year {year}")

    # If draft preview is requested, check admin authorization
    if draft:
        if not current_user or current_user.role not in ["admin", "organizer"]:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Draft preview requires admin authentication")
        if not report.active_draft_revision:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="No active draft revision exists")
        return report.active_draft_revision.snapshot_data

    # Public request must resolve only published revision
    if not report.published_revision:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"No published report available for {year}")

    return report.published_revision.snapshot_data

@router.get("/reports/{year}/download")
async def download_report_pdf(
    year: int,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[Optional[User], Depends(get_current_user_optional)] = None,
    language: str = "en",
    draft: bool = False
) -> Any:
    stmt = (
        select(AnnualReport)
        .where(AnnualReport.year == year, AnnualReport.language == language)
        .options(
            selectinload(AnnualReport.published_revision),
            selectinload(AnnualReport.active_draft_revision),
        )
    )
    result = await db.execute(stmt)
    report = result.scalars().first()

    if not report:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Report for year {year} not found")

    # If legacy report, serve stored legacy PDF
    if report.is_legacy and report.legacy_pdf_url:
        legacy_path = report.legacy_pdf_url
        if legacy_path.startswith("/media/"):
            legacy_path = os.path.join(os.getcwd(), legacy_path.lstrip("/"))
        if os.path.exists(legacy_path):
            return FileResponse(
                legacy_path,
                media_type="application/pdf",
                filename=f"jprclub_annual_report_{year}.pdf",
            )

    # Draft download check
    if draft:
        if not current_user or current_user.role not in ["admin", "organizer"]:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Draft downloads require admin privileges")
        target_rev = report.active_draft_revision
    else:
        # Public download resolves ONLY published revision
        target_rev = report.published_revision

    if not target_rev or not target_rev.pdf_path or not os.path.exists(target_rev.pdf_path):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="PDF artifact not found")

    filename = f"jprclub_annual_report_{year}_{language}.pdf"
    return FileResponse(
        target_rev.pdf_path,
        media_type="application/pdf",
        filename=filename,
    )
