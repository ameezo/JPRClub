import os
import json
import hashlib
import zoneinfo
from datetime import datetime, date, timezone
from uuid import UUID
from typing import Any, Dict, List, Tuple
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload

from app.core.config import settings
from app.models.session import Session, SessionStatus
from app.models.session_metrics import SessionMetrics, FeedbackQuote
from app.models.report import AnnualReport, ReportRevision

class ReportEngine:
    @staticmethod
    def get_timezone() -> zoneinfo.ZoneInfo:
        try:
            return zoneinfo.ZoneInfo(settings.REPORTING_TIMEZONE)
        except Exception:
            return zoneinfo.ZoneInfo("Asia/Amman")

    @classmethod
    def get_session_effective_date(cls, session: Session, tz: zoneinfo.ZoneInfo) -> date:
        if session.metrics and session.metrics.actual_date:
            return session.metrics.actual_date
        # Convert scheduled_at (timestamptz) to reporting timezone date
        return session.scheduled_at.astimezone(tz).date()

    @classmethod
    async def get_eligible_sessions(cls, db: AsyncSession, year: int) -> List[Tuple[Session, date]]:
        tz = cls.get_timezone()
        stmt = (
            select(Session)
            .where(
                Session.status == SessionStatus.completed,
                Session.exclude_from_reports == False,
            )
            .options(
                selectinload(Session.metrics),
                selectinload(Session.quotes),
            )
        )
        result = await db.execute(stmt)
        completed_sessions = result.scalars().all()

        eligible: List[Tuple[Session, date]] = []
        for s in completed_sessions:
            eff_date = cls.get_session_effective_date(s, tz)
            if eff_date.year == year:
                eligible.append((s, eff_date))

        # Sort chronologically by effective date, then scheduled_at
        eligible.sort(key=lambda item: (item[1], item[0].scheduled_at))
        return eligible

    @classmethod
    async def compute_missing_data_checklist(cls, db: AsyncSession, year: int) -> Dict[str, Any]:
        tz = cls.get_timezone()
        # Fetch all completed sessions in year regardless of metrics status
        stmt = (
            select(Session)
            .options(
                selectinload(Session.metrics),
            )
        )
        result = await db.execute(stmt)
        all_sessions = result.scalars().all()

        held_sessions = []
        excluded_sessions = []
        for s in all_sessions:
            eff_date = cls.get_session_effective_date(s, tz)
            if eff_date.year == year:
                if s.status == SessionStatus.completed:
                    if s.exclude_from_reports:
                        excluded_sessions.append(s)
                    else:
                        held_sessions.append((s, eff_date))

        total_held = len(held_sessions)
        missing_attendance = []
        missing_duration = []
        missing_studio = []
        incomplete_tallies = []

        for s, eff_date in held_sessions:
            m = s.metrics
            if not m or m.attendance_visits is None:
                missing_attendance.append({
                    "id": str(s.id),
                    "title": s.title,
                    "date": eff_date.isoformat(),
                })
            if not m or m.actual_duration_minutes is None:
                missing_duration.append({
                    "id": str(s.id),
                    "title": s.title,
                    "date": eff_date.isoformat(),
                    "planned_duration": s.duration_minutes,
                })
            if s.documentation_status != "published":
                missing_studio.append({
                    "id": str(s.id),
                    "title": s.title,
                    "date": eff_date.isoformat(),
                    "documentation_status": s.documentation_status,
                })
            if m and not m.tally_completed and m.feedback_cards_received is not None:
                incomplete_tallies.append({
                    "id": str(s.id),
                    "title": s.title,
                    "date": eff_date.isoformat(),
                    "cards_received": m.feedback_cards_received,
                })

        return {
            "year": year,
            "reporting_timezone": settings.REPORTING_TIMEZONE,
            "total_completed_sessions": total_held,
            "excluded_sessions_count": len(excluded_sessions),
            "excluded_sessions": [{"id": str(s.id), "title": s.title} for s in excluded_sessions],
            "missing_attendance_count": len(missing_attendance),
            "missing_attendance_sessions": missing_attendance,
            "missing_actual_duration_count": len(missing_duration),
            "missing_actual_duration_sessions": missing_duration,
            "missing_studio_documentation_count": len(missing_studio),
            "missing_studio_sessions": missing_studio,
            "incomplete_tallies_count": len(incomplete_tallies),
            "incomplete_tallies_sessions": incomplete_tallies,
            "is_ready_for_generation": total_held > 0,
        }

    @classmethod
    async def build_snapshot(
        cls,
        db: AsyncSession,
        year: int,
        language: str = "en"
    ) -> Dict[str, Any]:
        tz = cls.get_timezone()
        now_tz = datetime.now(tz)
        current_calendar_year = now_tz.year
        period_start = date(year, 1, 1)
        period_end = date(year, 12, 31)
        is_ytd = (year == current_calendar_year)
        as_of_date = now_tz.date() if is_ytd else period_end

        eligible_items = await cls.get_eligible_sessions(db, year)
        sessions_held = len(eligible_items)

        # 1. Attendance visits & coverage
        attendance_known_items = [
            (s, d) for s, d in eligible_items 
            if s.metrics and s.metrics.attendance_visits is not None
        ]
        total_attendance_visits = sum(
            s.metrics.attendance_visits for s, _ in attendance_known_items
        )
        attendance_recorded_count = len(attendance_known_items)
        attendance_coverage_pct = (
            round((attendance_recorded_count / sessions_held) * 100, 1) 
            if sessions_held > 0 else 0.0
        )
        average_attendance = (
            round(total_attendance_visits / attendance_recorded_count, 1)
            if attendance_recorded_count > 0 else None
        )

        # Optional Modality Split
        in_person_visits = sum(
            (s.metrics.attendance_in_person or 0) 
            for s, _ in eligible_items if s.metrics and s.metrics.attendance_in_person is not None
        )
        online_visits = sum(
            (s.metrics.attendance_online or 0) 
            for s, _ in eligible_items if s.metrics and s.metrics.attendance_online is not None
        )

        # 2. Session Hours & Duration Coverage
        duration_known_items = [
            (s, d) for s, d in eligible_items
            if s.metrics and s.metrics.actual_duration_minutes is not None
        ]
        total_actual_minutes = sum(
            s.metrics.actual_duration_minutes for s, _ in duration_known_items
        )
        total_session_hours = round(total_actual_minutes / 60.0, 1)
        duration_recorded_count = len(duration_known_items)
        duration_coverage_pct = (
            round((duration_recorded_count / sessions_held) * 100, 1)
            if sessions_held > 0 else 0.0
        )

        # 3. Reading Studio Documentation Coverage
        studio_published_count = sum(
            1 for s, _ in eligible_items if s.documentation_status == "published"
        )
        studio_coverage_pct = (
            round((studio_published_count / sessions_held) * 100, 1)
            if sessions_held > 0 else 0.0
        )

        # 4. Feedback Cards & Rating Distribution
        cards_known_items = [
            (s, d) for s, d in eligible_items
            if s.metrics and s.metrics.feedback_cards_received is not None
        ]
        total_feedback_cards = sum(
            s.metrics.feedback_cards_received for s, _ in cards_known_items
        )
        cards_recorded_count = len(cards_known_items)
        cards_coverage_pct = (
            round((cards_recorded_count / sessions_held) * 100, 1)
            if sessions_held > 0 else 0.0
        )

        rating_5 = sum((s.metrics.rating_5_count or 0) for s, _ in eligible_items if s.metrics)
        rating_4 = sum((s.metrics.rating_4_count or 0) for s, _ in eligible_items if s.metrics)
        rating_3 = sum((s.metrics.rating_3_count or 0) for s, _ in eligible_items if s.metrics)
        rating_2 = sum((s.metrics.rating_2_count or 0) for s, _ in eligible_items if s.metrics)
        rating_1 = sum((s.metrics.rating_1_count or 0) for s, _ in eligible_items if s.metrics)
        unrated_cards = sum((s.metrics.unrated_count or 0) for s, _ in eligible_items if s.metrics)

        total_rated_responses = rating_5 + rating_4 + rating_3 + rating_2 + rating_1
        average_rating = (
            round(
                (5 * rating_5 + 4 * rating_4 + 3 * rating_3 + 2 * rating_2 + 1 * rating_1) / total_rated_responses,
                2
            )
            if total_rated_responses > 0 else None
        )

        # 5. Reading Materials Breakdown
        materials_count: Dict[str, int] = {}
        for s, _ in eligible_items:
            m_type = (s.material_type or "Other").strip()
            materials_count[m_type] = materials_count.get(m_type, 0) + 1

        materials_distribution = [
            {"material_type": k, "count": v, "percentage": round((v / sessions_held * 100), 1) if sessions_held > 0 else 0.0}
            for k, v in sorted(materials_count.items(), key=lambda x: x[1], reverse=True)
        ]

        # 6. Monthly Metrics (12 months)
        monthly_metrics = []
        for m in range(1, 13):
            month_sessions = [(s, d) for s, d in eligible_items if d.month == m]
            m_recorded = [
                s for s, _ in month_sessions 
                if s.metrics and s.metrics.attendance_visits is not None
            ]
            m_visits = sum(s.metrics.attendance_visits for s in m_recorded)
            monthly_metrics.append({
                "month": m,
                "sessions_count": len(month_sessions),
                "recorded_attendance_sessions": len(m_recorded),
                "attendance_visits": m_visits if len(m_recorded) > 0 else None,
                "has_unrecorded_attendance": (len(month_sessions) > len(m_recorded)),
            })

        # 7. Reviewed Anonymous Feedback Quotes (Strictly Opt-in & Reviewed)
        approved_quotes = []
        for s, d in eligible_items:
            for q in (s.quotes or []):
                if q.permission_to_publish and q.is_reviewed:
                    approved_quotes.append({
                        "id": str(q.id),
                        "session_id": str(s.id),
                        "session_title": s.title,
                        "session_title_ar": s.title_ar,
                        "session_date": d.isoformat(),
                        "quote_text": q.quote_text,
                        "source_language": q.source_language,
                        "source_type": q.source_type,
                        "is_highlight": q.is_highlight,
                    })

        # 8. Chronological Session Timeline
        timeline = []
        for s, d in eligible_items:
            m = s.metrics
            dur = m.actual_duration_minutes if (m and m.actual_duration_minutes is not None) else s.duration_minutes
            dur_actual = bool(m and m.actual_duration_minutes is not None)
            
            # Short recap summary from studio content if available
            recap_preview = None
            if s.studio_content:
                try:
                    # If JSON blocks from blocknote, extract first paragraph
                    parsed_blocks = json.loads(s.studio_content)
                    if isinstance(parsed_blocks, list):
                        for b in parsed_blocks:
                            if isinstance(b, dict) and b.get("content"):
                                contents = b.get("content")
                                if isinstance(contents, list):
                                    text_parts = [c.get("text", "") for c in contents if isinstance(c, dict)]
                                    first_line = "".join(text_parts).strip()
                                    if first_line:
                                        recap_preview = first_line[:200]
                                        break
                except Exception:
                    # Markdown / plain text fallback
                    recap_preview = s.studio_content.strip()[:200]

            if recap_preview:
                recap_preview = " ".join(recap_preview.split())

            timeline.append({
                "id": str(s.id),
                "title": s.title,
                "title_ar": s.title_ar,
                "date": d.isoformat(),
                "material_type": s.material_type,
                "chapters": s.chapters,
                "level": s.level,
                "duration_minutes": dur,
                "duration_is_actual": dur_actual,
                "attendance_visits": m.attendance_visits if m else None,
                "attendance_counting_method": m.attendance_counting_method if m else None,
                "documentation_status": s.documentation_status,
                "cover_image_url": s.cover_image_url,
                "recap_preview": recap_preview,
            })

        # 9. Assembled Frozen Snapshot
        snapshot_data = {
            "schema_version": "1.0",
            "metadata": {
                "year": year,
                "language": language,
                "status_label": "Year-to-Date (YTD)" if is_ytd else "Annual Report (Final)",
                "is_year_to_date": is_ytd,
                "period_start": period_start.isoformat(),
                "period_end": period_end.isoformat(),
                "as_of_date": as_of_date.isoformat(),
                "generated_at": now_tz.isoformat(),
                "reporting_timezone": settings.REPORTING_TIMEZONE,
            },
            "summary_metrics": {
                "sessions_held": sessions_held,
                "total_attendance_visits": total_attendance_visits,
                "attendance_coverage": {
                    "recorded_sessions": attendance_recorded_count,
                    "total_sessions": sessions_held,
                    "coverage_percent": attendance_coverage_pct,
                },
                "average_attendance_per_session": average_attendance,
                "in_person_visits": in_person_visits if in_person_visits > 0 else None,
                "online_visits": online_visits if online_visits > 0 else None,
                "total_session_hours": total_session_hours,
                "duration_coverage": {
                    "recorded_sessions": duration_recorded_count,
                    "total_sessions": sessions_held,
                    "coverage_percent": duration_coverage_pct,
                },
                "studio_documentation": {
                    "published_recap_sessions": studio_published_count,
                    "total_sessions": sessions_held,
                    "coverage_percent": studio_coverage_pct,
                },
                "feedback_cards": {
                    "total_cards_received": total_feedback_cards,
                    "recorded_sessions": cards_recorded_count,
                    "total_sessions": sessions_held,
                    "coverage_percent": cards_coverage_pct,
                },
                "ratings": {
                    "rating_5_count": rating_5,
                    "rating_4_count": rating_4,
                    "rating_3_count": rating_3,
                    "rating_2_count": rating_2,
                    "rating_1_count": rating_1,
                    "unrated_count": unrated_cards,
                    "total_rated_responses": total_rated_responses,
                    "average_rating": average_rating,
                },
            },
            "materials_distribution": materials_distribution,
            "monthly_metrics": monthly_metrics,
            "approved_quotes": approved_quotes,
            "timeline_sessions": timeline,
            "methodology": {
                "timezone_policy": f"Session eligibility is evaluated using configured club timezone ({settings.REPORTING_TIMEZONE}).",
                "date_selection_rule": "Selects by confirmed actual date when rescheduled, otherwise confirmed scheduled date.",
                "attendance_policy": "Each attendee is counted once per session. Repeat sessions represent repeat visits; unique attendees across sessions are not calculated without deduplicated identification records.",
                "missing_data_disclosure": "Unknown attendance and durations are preserved and omitted from averages rather than treated as zero.",
                "privacy_disclosure": "Only anonymous quotes with recorded administrative review and explicit publication consent are published.",
            }
        }

        # Deterministic SHA-256 hash
        snapshot_serialized = json.dumps(snapshot_data, sort_keys=True, separators=(',', ':'))
        content_hash = hashlib.sha256(snapshot_serialized.encode("utf-8")).hexdigest()

        return snapshot_data, content_hash, period_start, period_end, as_of_date, is_ytd

    @classmethod
    async def create_or_rebuild_draft(
        cls,
        db: AsyncSession,
        year: int,
        user_id: UUID,
        language: str = "en"
    ) -> ReportRevision:
        snapshot_data, content_hash, period_start, period_end, as_of_date, is_ytd = await cls.build_snapshot(
            db, year, language
        )

        # 1. Fetch or create AnnualReport for (year, language)
        stmt = (
            select(AnnualReport)
            .where(
                AnnualReport.year == year,
                AnnualReport.language == language,
            )
        )
        result = await db.execute(stmt)
        report = result.scalars().first()

        if not report:
            report = AnnualReport(
                year=year,
                language=language,
                status="draft",
            )
            db.add(report)
            await db.flush()

        # Determine next revision number
        rev_stmt = (
            select(ReportRevision.revision_number)
            .where(ReportRevision.report_id == report.id)
            .order_by(ReportRevision.revision_number.desc())
        )
        rev_result = await db.execute(rev_stmt)
        last_rev = rev_result.scalars().first()
        next_rev = (last_rev or 0) + 1

        # 2. Create immutable ReportRevision
        revision = ReportRevision(
            report_id=report.id,
            revision_number=next_rev,
            period_start=period_start,
            period_end=period_end,
            as_of_date=as_of_date,
            is_year_to_date=is_ytd,
            schema_version="1.0",
            snapshot_data=snapshot_data,
            content_hash=content_hash,
            generation_status="draft_ready",
            created_by=user_id,
        )
        db.add(revision)
        await db.flush()

        # 3. Generate PDF artifact in private storage (isolated from public static mounts)
        from app.services.pdf_generator import ReportPdfGenerator
        private_dir = os.path.abspath("private_reports")
        pdf_filename = f"annual_report_{year}_{language}_r{next_rev}.pdf"
        pdf_dest_path = os.path.join(private_dir, str(year), pdf_filename)

        try:
            ReportPdfGenerator.generate_pdf(snapshot_data, pdf_dest_path)
            revision.pdf_path = pdf_dest_path
            revision.pdf_file_size = os.path.getsize(pdf_dest_path)
            revision.generation_status = "draft_ready"
        except Exception as e:
            revision.generation_status = "failed"
            revision.error_message = f"PDF generation error: {str(e)}"

        # Point active draft to this new revision
        report.active_draft_revision_id = revision.id
        if report.status != "published":
            report.status = "draft"

        await db.commit()
        await db.refresh(revision)
        return revision
