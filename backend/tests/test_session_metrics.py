import pytest
from httpx import AsyncClient, ASGITransport
from datetime import datetime, timezone, timedelta, date
from uuid import UUID, uuid4
from app.main import app
from app.db.database import AsyncSessionLocal
from app.models.session import Session
from app.models.session_metrics import SessionMetrics, FeedbackQuote

@pytest.mark.asyncio
async def test_session_metrics_and_feedback_workflow():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        # 1. Login as admin
        login_res = await ac.post("/api/auth/login", json={
            "email": "admin@jprclub.org",
            "password": "admin12345"
        })
        assert login_res.status_code == 200, f"Login failed: {login_res.text}"
        admin_token = login_res.json()["access_token"]
        admin_headers = {"Authorization": f"Bearer {admin_token}"}

        # 2. Login as regular member (non-admin)
        member_login_res = await ac.post("/api/auth/login", json={
            "email": "ameen2@gmail.com",
            "password": "admin12345" # fallback if same or test unauthorized
        })
        member_headers = {}
        if member_login_res.status_code == 200:
            member_headers = {"Authorization": f"Bearer {member_login_res.json()['access_token']}"}

        # 3. Create a test session
        unique_suffix = int(datetime.now(timezone.utc).timestamp())
        scheduled = (datetime.now(timezone.utc) + timedelta(days=2)).isoformat()
        create_payload = {
            "title": f"Metrics Test Session {unique_suffix}",
            "description": "Session for testing attendance metrics and feedback workflow",
            "material_type": "Manga",
            "scheduled_at": scheduled,
            "duration_minutes": 90,
            "exclude_from_reports": False
        }
        create_res = await ac.post("/api/sessions", json=create_payload, headers=admin_headers)
        assert create_res.status_code == 201
        session_id = create_res.json()["id"]

        try:
            # 4. Unauthorized rejection: public and regular member cannot access metrics or quotes
            anon_metrics_res = await ac.get(f"/api/sessions/{session_id}/metrics")
            assert anon_metrics_res.status_code in (401, 403), "Anonymous user must be rejected"

            anon_quotes_res = await ac.get(f"/api/sessions/{session_id}/quotes")
            assert anon_quotes_res.status_code in (401, 403), "Anonymous user must be rejected"

            if member_headers:
                mem_metrics_res = await ac.get(f"/api/sessions/{session_id}/metrics", headers=member_headers)
                assert mem_metrics_res.status_code == 403, "Non-admin member must be forbidden"

            # 5. Get default empty metrics (unknown attendance, not zero)
            get_res = await ac.get(f"/api/sessions/{session_id}/metrics", headers=admin_headers)
            assert get_res.status_code == 200
            empty_data = get_res.json()
            assert empty_data["attendance_visits"] is None, "Initial attendance visits must be null/unknown, not 0"
            assert empty_data["feedback_cards_received"] is None
            assert empty_data["tally_completed"] is False

            # 6. Save and reload attendance: confirmed zero vs unknown
            # Test confirmed zero
            zero_payload = {
                "attendance_visits": 0,
                "attendance_counting_method": "headcount",
                "staff_included": False,
                "version": empty_data["version"]
            }
            save_zero_res = await ac.put(f"/api/sessions/{session_id}/metrics", json=zero_payload, headers=admin_headers)
            assert save_zero_res.status_code == 200
            assert save_zero_res.json()["attendance_visits"] == 0, "Confirmed zero must be saved as 0, not null"

            # Test reload
            reload_zero_res = await ac.get(f"/api/sessions/{session_id}/metrics", headers=admin_headers)
            assert reload_zero_res.status_code == 200
            assert reload_zero_res.json()["attendance_visits"] == 0
            v_after_zero = reload_zero_res.json()["version"]

            # Test setting back to unknown (null)
            unknown_payload = {
                "attendance_visits": None,
                "version": v_after_zero
            }
            save_unknown_res = await ac.put(f"/api/sessions/{session_id}/metrics", json=unknown_payload, headers=admin_headers)
            assert save_unknown_res.status_code == 200
            assert save_unknown_res.json()["attendance_visits"] is None, "Unknown attendance must be preserved as null"

            # 7. Save incomplete feedback tally (tally_completed=False allows mismatch without error)
            v_current = save_unknown_res.json()["version"]
            incomplete_tally_payload = {
                "attendance_visits": 12,
                "attendance_in_person": 10,
                "attendance_online": 2,
                "actual_duration_minutes": 95,
                "feedback_cards_received": 10,
                "rating_5_count": 4,
                "rating_4_count": 2,
                # Sum = 6, but cards received = 10 (incomplete tally)
                "tally_completed": False,
                "internal_notes": "Moderator private note: paper cards still being sorted.",
                "version": v_current
            }
            incomplete_res = await ac.put(f"/api/sessions/{session_id}/metrics", json=incomplete_tally_payload, headers=admin_headers)
            assert incomplete_res.status_code == 200
            incomplete_data = incomplete_res.json()
            assert incomplete_data["attendance_visits"] == 12
            assert incomplete_data["feedback_cards_received"] == 10
            assert incomplete_data["ratings_sum"] == 6
            assert incomplete_data["tally_reconciled"] is False
            assert incomplete_data["tally_difference"] == 4
            assert incomplete_data["internal_notes"] == "Moderator private note: paper cards still being sorted."

            # 8. Validation of completed tally (tally_completed=True requires sum to match cards received)
            v_current = incomplete_data["version"]
            invalid_completed_payload = {
                **incomplete_tally_payload,
                "tally_completed": True,
                "version": v_current
            }
            invalid_res = await ac.put(f"/api/sessions/{session_id}/metrics", json=invalid_completed_payload, headers=admin_headers)
            assert invalid_res.status_code == 400, "Completed tally with mismatched sum must be rejected"
            assert "reconcile" in invalid_res.json()["detail"].lower()

            # Now provide reconciled counts: 4(5) + 3(4) + 1(3) + 1(2) + 1(unrated) = 10
            valid_completed_payload = {
                **incomplete_tally_payload,
                "rating_5_count": 4,
                "rating_4_count": 3,
                "rating_3_count": 1,
                "rating_2_count": 1,
                "rating_1_count": 0,
                "unrated_count": 1,
                "tally_completed": True,
                "version": v_current
            }
            valid_completed_res = await ac.put(f"/api/sessions/{session_id}/metrics", json=valid_completed_payload, headers=admin_headers)
            assert valid_completed_res.status_code == 200
            completed_data = valid_completed_res.json()
            assert completed_data["ratings_sum"] == 10
            assert completed_data["tally_reconciled"] is True
            assert completed_data["tally_difference"] == 0

            # 9. Private notes inaccessible through public routes
            public_session_res = await ac.get(f"/api/sessions/{session_id}")
            assert public_session_res.status_code == 200
            public_session_data = public_session_res.json()
            assert "internal_notes" not in public_session_data, "Public session response must not expose internal_notes"
            assert "metrics" not in public_session_data

            # 10. Concurrent-edit conflict handling (optimistic locking)
            stale_payload = {
                **valid_completed_payload,
                "attendance_visits": 15,
                "version": v_current # Stale version! Current version is higher
            }
            conflict_res = await ac.put(f"/api/sessions/{session_id}/metrics", json=stale_payload, headers=admin_headers)
            assert conflict_res.status_code == 409, "Stale version edit must return 409 Conflict"

            # 11. Feedback Quotes workflow & permissions
            # Quote permission defaults strictly to false
            create_quote_payload = {
                "quote_text": "The discussion on vocabulary nuance was wonderful!",
                "source_language": "en",
                "source_type": "in_person_card"
                # permission_to_publish omitted -> defaults to False
                # is_reviewed omitted -> defaults to False
            }
            quote_res = await ac.post(f"/api/sessions/{session_id}/quotes", json=create_quote_payload, headers=admin_headers)
            assert quote_res.status_code == 201
            quote_data = quote_res.json()
            assert quote_data["permission_to_publish"] is False, "Permission to publish must default to False"
            assert quote_data["is_reviewed"] is False, "Review status must default to False"
            quote_id = quote_data["id"]

            # Cannot set permission_to_publish to True without being reviewed
            unreviewed_pub_res = await ac.patch(
                f"/api/sessions/{session_id}/quotes/{quote_id}",
                json={"permission_to_publish": True},
                headers=admin_headers
            )
            assert unreviewed_pub_res.status_code == 400, "Cannot grant publication permission to unreviewed quote"

            # Review and grant permission
            reviewed_res = await ac.patch(
                f"/api/sessions/{session_id}/quotes/{quote_id}",
                json={"is_reviewed": True, "permission_to_publish": True, "is_highlight": True},
                headers=admin_headers
            )
            assert reviewed_res.status_code == 200
            assert reviewed_res.json()["is_reviewed"] is True
            assert reviewed_res.json()["permission_to_publish"] is True
            assert reviewed_res.json()["reviewed_by"] is not None
            assert reviewed_res.json()["reviewed_at"] is not None

            # Revocation / withdrawal workflow
            revoke_res = await ac.patch(
                f"/api/sessions/{session_id}/quotes/{quote_id}",
                json={"permission_to_publish": False},
                headers=admin_headers
            )
            assert revoke_res.status_code == 200
            assert revoke_res.json()["permission_to_publish"] is False, "Permission must be revokable"

            # 12. Check URL validation: nested quote IDs belong to the session in the URL
            other_session_id = uuid4()
            mismatch_patch = await ac.patch(
                f"/api/sessions/{other_session_id}/quotes/{quote_id}",
                json={"quote_text": "Hacked"},
                headers=admin_headers
            )
            assert mismatch_patch.status_code == 404, "Quote belonging to another session must return 404"

            mismatch_delete = await ac.delete(
                f"/api/sessions/{other_session_id}/quotes/{quote_id}",
                headers=admin_headers
            )
            assert mismatch_delete.status_code == 404, "Quote delete with mismatched session ID must return 404"

            # Delete quote properly
            delete_res = await ac.delete(f"/api/sessions/{session_id}/quotes/{quote_id}", headers=admin_headers)
            assert delete_res.status_code == 204

            # 13. Exclude from reports flag on session
            exclude_patch_res = await ac.patch(
                f"/api/sessions/{session_id}",
                json={"exclude_from_reports": True},
                headers=admin_headers
            )
            assert exclude_patch_res.status_code == 200
            assert exclude_patch_res.json()["exclude_from_reports"] is True

        finally:
            # Cleanup session and cascaded child records
            async with AsyncSessionLocal() as session:
                s = await session.get(Session, UUID(session_id))
                if s:
                    await session.delete(s)
                    await session.commit()
