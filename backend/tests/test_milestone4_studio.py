import pytest
from httpx import AsyncClient, ASGITransport
from datetime import datetime, timezone, timedelta
from app.main import app

@pytest.mark.asyncio
async def test_milestone4_reading_studio_flow():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        # 1. Login as admin
        login_res = await ac.post("/api/auth/login", json={
            "email": "admin@jprclub.org",
            "password": "admin12345"
        })
        assert login_res.status_code == 200
        token = login_res.json()["access_token"]
        headers = {"Authorization": f"Bearer {token}"}

        # 2. Create a session with studio fields
        unique_suffix = int(datetime.now(timezone.utc).timestamp())
        scheduled = (datetime.now(timezone.utc) - timedelta(days=2)).isoformat()
        create_payload = {
            "title": f"M4 Studio Test {unique_suffix}",
            "description": "Testing studio features",
            "material_type": "Book",
            "scheduled_at": scheduled,
            "duration_minutes": 60,
            "cover_image_url": "https://example.com/cover.jpg",
            "studio_content": "# Session Notes\n\n- Key point 1\n- Key point 2",
            "gallery_images": [
                "https://example.com/img1.jpg",
                "https://example.com/img2.jpg"
            ]
        }
        res = await ac.post("/api/sessions", json=create_payload, headers=headers)
        assert res.status_code == 201, res.text
        session_data = res.json()
        session_id = session_data["id"]
        assert session_data["studio_content"] == create_payload["studio_content"]
        assert session_data["gallery_images"] == create_payload["gallery_images"]
        assert session_data["status"] == "draft"

        # 3. Publish and complete session
        pub_res = await ac.post(f"/api/sessions/{session_id}/publish", headers=headers)
        assert pub_res.status_code == 200
        assert pub_res.json()["status"] == "published"

        comp_res = await ac.post(f"/api/sessions/{session_id}/complete", headers=headers)
        assert comp_res.status_code == 200
        assert comp_res.json()["status"] == "completed"

        # 4. Public endpoint: list completed sessions
        list_res = await ac.get("/api/sessions?status=completed")
        assert list_res.status_code == 200
        items = list_res.json()["items"]
        completed_ids = [item["id"] for item in items]
        assert session_id in completed_ids

        # 5. Public endpoint: get single session
        detail_res = await ac.get(f"/api/sessions/{session_id}")
        assert detail_res.status_code == 200
        detail = detail_res.json()
        assert detail["status"] == "completed"
        assert detail["studio_content"] == create_payload["studio_content"]
        assert detail["gallery_images"] == create_payload["gallery_images"]

        # 6. Update studio content with optimistic locking
        current_version = detail["version"]
        patch_res = await ac.patch(f"/api/sessions/{session_id}", headers=headers, json={
            "version": current_version,
            "studio_content": "## Updated Notes\n\nAdded more details."
        })
        assert patch_res.status_code == 200
        assert "Updated Notes" in patch_res.json()["studio_content"]

        # Teardown / Cleanup
        from app.db.database import AsyncSessionLocal
        from app.models.session import Session
        from uuid import UUID
        async with AsyncSessionLocal() as session:
            s = await session.get(Session, UUID(session_id))
            if s:
                await session.delete(s)
                await session.commit()
