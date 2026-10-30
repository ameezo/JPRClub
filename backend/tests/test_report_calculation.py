import pytest
import os
from httpx import AsyncClient, ASGITransport
from datetime import datetime, timezone, timedelta, date
from uuid import UUID
from sqlalchemy import select
from app.main import app
from app.db.database import AsyncSessionLocal
from app.models.session import Session, SessionStatus
from app.models.session_metrics import SessionMetrics, FeedbackQuote
from app.models.report import AnnualReport, ReportRevision

@pytest.mark.asyncio
async def test_deterministic_report_calculation_and_publication():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        # 1. Admin Login
        login_res = await ac.post("/api/auth/login", json={
            "email": "admin@jprclub.org",
            "password": "admin12345"
        })
        assert login_res.status_code == 200
        admin_token = login_res.json()["access_token"]
        headers = {"Authorization": f"Bearer {admin_token}"}

        # 2. Setup known deterministic session fixtures for year 2023
        # Session A: 10 visits, 90 mins actual duration, 10 cards
        # Session B: 0 visits (confirmed zero), 60 mins actual duration
        # Session C: None visits (unknown), None duration (unknown)
        # Session D: Completed but exclude_from_reports=True (Must be excluded!)
        # Session E: Cancelled (Must be excluded!)
        created_session_ids = []
        try:
            date_2023 = datetime(2023, 5, 10, 14, 0, tzinfo=timezone.utc)
            
            # Session A
            s_a = Session(
                title="Fixtures Session A",
                description="Test session A",
                material_type="Novel",
                scheduled_at=date_2023,
                duration_minutes=90,
                status=SessionStatus.completed,
                documentation_status="published",
                exclude_from_reports=False,
                created_by=login_res.json()["user"]["id"],
            )
            # Session B
            s_b = Session(
                title="Fixtures Session B",
                description="Test session B",
                material_type="Manga",
                scheduled_at=date_2023 + timedelta(days=7),
                duration_minutes=60,
                status=SessionStatus.completed,
                documentation_status="draft",
                exclude_from_reports=False,
                created_by=login_res.json()["user"]["id"],
            )
            # Session C
            s_c = Session(
                title="Fixtures Session C",
                description="Test session C",
                material_type="Manga",
                scheduled_at=date_2023 + timedelta(days=14),
                duration_minutes=90,
                status=SessionStatus.completed,
                documentation_status="none",
                exclude_from_reports=False,
                created_by=login_res.json()["user"]["id"],
            )
            # Session D (Excluded)
            s_d = Session(
                title="Fixtures Session D (Excluded)",
                description="Test session D",
                material_type="Test",
                scheduled_at=date_2023 + timedelta(days=21),
                duration_minutes=90,
                status=SessionStatus.completed,
                documentation_status="none",
                exclude_from_reports=True, # EXCLUDED!
                created_by=login_res.json()["user"]["id"],
            )
            # Session E (Cancelled)
            s_e = Session(
                title="Fixtures Session E (Cancelled)",
                description="Cancelled session",
                material_type="Manga",
                scheduled_at=date_2023 + timedelta(days=28),
                duration_minutes=90,
                status=SessionStatus.cancelled, # CANCELLED!
                exclude_from_reports=False,
                created_by=login_res.json()["user"]["id"],
            )

            async with AsyncSessionLocal() as db:
                db.add_all([s_a, s_b, s_c, s_d, s_e])
                await db.commit()
                await db.refresh(s_a)
                await db.refresh(s_b)
                await db.refresh(s_c)
                await db.refresh(s_d)
                await db.refresh(s_e)
                created_session_ids = [s_a.id, s_b.id, s_c.id, s_d.id, s_e.id]

                # Add Metrics
                m_a = SessionMetrics(
                    session_id=s_a.id,
                    attendance_visits=10,
                    actual_duration_minutes=90,
                    feedback_cards_received=10,
                    rating_5_count=6,
                    rating_4_count=4,
                    tally_completed=True,
                )
                m_b = SessionMetrics(
                    session_id=s_b.id,
                    attendance_visits=0, # Confirmed ZERO!
                    actual_duration_minutes=60,
                    feedback_cards_received=None,
                    tally_completed=False,
                )
                m_c = SessionMetrics(
                    session_id=s_c.id,
                    attendance_visits=None, # Unknown!
                    actual_duration_minutes=None, # Unknown!
                    feedback_cards_received=None,
                )
                db.add_all([m_a, m_b, m_c])

                # Add Feedback Quotes to Session A
                q_approved = FeedbackQuote(
                    session_id=s_a.id,
                    quote_text="Wonderful literature exploration!",
                    source_language="en",
                    source_type="in_person_card",
                    is_reviewed=True,
                    permission_to_publish=True, # Must be included in report
                )
                q_private = FeedbackQuote(
                    session_id=s_a.id,
                    quote_text="I liked the room acoustics.",
                    source_language="en",
                    source_type="in_person_card",
                    is_reviewed=True,
                    permission_to_publish=False, # Strictly excluded!
                )
                q_unreviewed = FeedbackQuote(
                    session_id=s_a.id,
                    quote_text="Nice books.",
                    source_language="en",
                    source_type="in_person_card",
                    is_reviewed=False,
                    permission_to_publish=False, # Strictly excluded!
                )
                db.add_all([q_approved, q_private, q_unreviewed])
                await db.commit()

            # 3. Check Missing Data Checklist via API
            checklist_res = await ac.get("/api/admin/reports/2023/missing-data-checklist", headers=headers)
            assert checklist_res.status_code == 200
            ck = checklist_res.json()
            assert ck["total_completed_sessions"] == 3 # A, B, C (D excluded, E cancelled)
            assert ck["excluded_sessions_count"] == 1 # D
            assert ck["missing_attendance_count"] == 1 # C
            assert ck["missing_actual_duration_count"] == 1 # C
            assert ck["missing_studio_documentation_count"] == 2 # B (draft), C (none)

            # 4. Generate Report Draft for 2023
            draft_res = await ac.post("/api/admin/reports/2023/draft", json={"language": "en"}, headers=headers)
            assert draft_res.status_code == 200
            draft_data = draft_res.json()
            assert draft_data["year"] == 2023
            assert draft_data["language"] == "en"
            assert draft_data["revision_number"] == 1
            assert draft_data["is_year_to_date"] is False # Past year!
            assert len(draft_data["content_hash"]) == 64 # SHA-256
            assert draft_data["generation_status"] == "draft_ready"
            assert draft_data["pdf_path"] is not None
            assert os.path.exists(draft_data["pdf_path"])

            # 5. Verify Deterministic Metrics in Snapshot
            snap = draft_data["snapshot_data"]
            summary = snap["summary_metrics"]
            # Sessions held: 3
            assert summary["sessions_held"] == 3
            # Attendance visits: 10 + 0 = 10
            assert summary["total_attendance_visits"] == 10
            # Recorded coverage: 2 of 3 (Session A and B recorded, C is unknown)
            assert summary["attendance_coverage"]["recorded_sessions"] == 2
            assert summary["attendance_coverage"]["total_sessions"] == 3
            # Average attendance: 10 / 2 = 5.0 (Confirmed 0 is in denominator, unknown is not!)
            assert summary["average_attendance_per_session"] == 5.0
            # Duration hours: (90 + 60) / 60 = 2.5 hours
            assert summary["total_session_hours"] == 2.5
            assert summary["duration_coverage"]["recorded_sessions"] == 2
            # Materials distribution: 2 Manga, 1 Novel
            mats = {m["material_type"]: m["count"] for m in snap["materials_distribution"]}
            assert mats.get("Manga") == 2
            assert mats.get("Novel") == 1
            # Feedback quotes: ONLY q_approved included!
            quotes_in_snap = snap["approved_quotes"]
            assert len(quotes_in_snap) == 1
            assert quotes_in_snap[0]["quote_text"] == "Wonderful literature exploration!"

            # 6. Verify Public Access is Blocked Before Publication
            public_list_before = await ac.get("/api/reports")
            assert public_list_before.status_code == 200
            years_in_public = [item["year"] for item in public_list_before.json()]
            assert 2023 not in years_in_public, "Unpublished draft must not appear in public listing"

            public_detail_before = await ac.get("/api/reports/2023")
            assert public_detail_before.status_code == 404, "Public request for unpublished year must return 404"

            public_download_before = await ac.get("/api/reports/2023/download")
            assert public_download_before.status_code == 404, "Public download for unpublished year must return 404"

            # Admin can preview draft
            admin_preview = await ac.get("/api/reports/2023?draft=true", headers=headers)
            assert admin_preview.status_code == 200

            # 7. Publish Revision (Manual Gate)
            rev_id = draft_data["id"]
            pub_res = await ac.post("/api/admin/reports/2023/publish", json={"revision_id": rev_id}, headers=headers)
            assert pub_res.status_code == 200
            assert pub_res.json()["published_at"] is not None

            # 8. Verify Public Access is Enabled After Publication
            public_list_after = await ac.get("/api/reports")
            assert public_list_after.status_code == 200
            years_after = [item["year"] for item in public_list_after.json()]
            assert 2023 in years_after, "Published report must appear in public listing"

            public_detail_after = await ac.get("/api/reports/2023")
            assert public_detail_after.status_code == 200
            assert public_detail_after.json()["summary_metrics"]["sessions_held"] == 3

            public_download_after = await ac.get("/api/reports/2023/download")
            assert public_download_after.status_code == 200
            assert public_download_after.headers["content-type"] == "application/pdf"
            assert len(public_download_after.content) > 1000

        finally:
            # Cleanup created test sessions and report revisions
            async with AsyncSessionLocal() as db:
                for s_id in created_session_ids:
                    s = await db.get(Session, s_id)
                    if s:
                        await db.delete(s)
                # Cleanup 2023 report
                rep_stmt = select(AnnualReport).where(AnnualReport.year == 2023)
                rep_res = await db.execute(rep_stmt)
                r = rep_res.scalars().first()
                if r:
                    await db.delete(r)
                await db.commit()
