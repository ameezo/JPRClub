import pytest
from httpx import AsyncClient, ASGITransport
from datetime import datetime, timezone, timedelta
from uuid import UUID
from app.main import app
from app.db.database import AsyncSessionLocal
from app.models.session import Session

@pytest.mark.asyncio
async def test_session_documentation_workflow():
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

        # 2. Create a session
        unique_suffix = int(datetime.now(timezone.utc).timestamp())
        scheduled = (datetime.now(timezone.utc) + timedelta(days=1)).isoformat()
        create_payload = {
            "title": f"Doc Workflow Session {unique_suffix}",
            "description": "Planning to document this later",
            "material_type": "Manga",
            "scheduled_at": scheduled,
            "duration_minutes": 90,
        }
        res = await ac.post("/api/sessions", json=create_payload, headers=headers)
        assert res.status_code == 201
        session_id = res.json()["id"]

        try:
            # 3. Publish the session (scheduling)
            pub_res = await ac.post(f"/api/sessions/{session_id}/publish", headers=headers)
            assert pub_res.status_code == 200
            assert pub_res.json()["status"] == "published"
            assert pub_res.json()["documentation_status"] == "none"

            # 4. Complete and document session
            comp_res = await ac.post(f"/api/sessions/{session_id}/complete-and-document", headers=headers)
            assert comp_res.status_code == 200
            comp_data = comp_res.json()
            assert comp_data["status"] == "completed"
            assert comp_data["documentation_status"] == "draft"

            # 5. Save draft documentation with BlockNote content
            blocknote_json = '[{"id":"block-1","type":"paragraph","content":[{"type":"text","text":"Great discussion today!"}]}]'
            doc_update_payload = {
                "title": f"Doc Workflow Session {unique_suffix} (Summary)",
                "studio_content": blocknote_json,
                "studio_content_format": "blocknote",
                "cover_image_url": "https://example.com/cover.jpg",
                "version": comp_data["version"]
            }
            patch_res = await ac.patch(f"/api/sessions/{session_id}/documentation", json=doc_update_payload, headers=headers)
            assert patch_res.status_code == 200
            patch_data = patch_res.json()
            assert patch_data["studio_content"] == blocknote_json
            assert patch_data["studio_content_format"] == "blocknote"
            assert patch_data["documentation_status"] == "draft"

            # 6. Publish to studio
            publish_studio_res = await ac.post(f"/api/sessions/{session_id}/publish-studio", headers=headers)
            assert publish_studio_res.status_code == 200
            studio_data = publish_studio_res.json()
            assert studio_data["documentation_status"] == "published"
            assert studio_data["status"] == "completed"

            # 7. Check Studio query with documentation_status=published
            studio_list = await ac.get("/api/sessions?status=completed&documentation_status=published")
            assert studio_list.status_code == 200
            studio_ids = [item["id"] for item in studio_list.json()["items"]]
            assert session_id in studio_ids

        finally:
            # Cleanup
            async with AsyncSessionLocal() as session:
                s = await session.get(Session, UUID(session_id))
                if s:
                    await session.delete(s)
                    await session.commit()
