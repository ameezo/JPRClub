import pytest
from httpx import AsyncClient, ASGITransport
from datetime import datetime, timezone
from uuid import UUID
from app.main import app
from app.db.database import AsyncSessionLocal
from app.models.journal import JournalSubmission

@pytest.mark.asyncio
async def test_journal_composer_workflow():
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

        # 2. Create BlockNote journal entry
        unique_suffix = int(datetime.now(timezone.utc).timestamp())
        blocknote_content = '[{"id":"b1","type":"paragraph","content":[{"type":"text","text":"My reading reflections"}]}]'
        create_payload = {
            "title": f"Rich Journal Entry {unique_suffix}",
            "content": blocknote_content,
            "content_format": "blocknote",
            "content_language": "en",
            "cover_image_url": "https://example.com/journal-cover.jpg",
            "status": "draft"
        }
        res = await ac.post("/api/journal", json=create_payload, headers=headers)
        assert res.status_code == 201
        entry_data = res.json()
        entry_id = entry_data["id"]
        assert entry_data["content_format"] == "blocknote"
        assert entry_data["content_language"] == "en"
        assert entry_data["cover_image_url"] == "https://example.com/journal-cover.jpg"
        assert entry_data["status"] == "draft"

        try:
            # 3. Update entry via PATCH
            updated_content = '[{"id":"b1","type":"paragraph","content":[{"type":"text","text":"Updated reflections"}]}]'
            patch_res = await ac.patch(f"/api/journal/{entry_id}", json={
                "content": updated_content,
                "version": entry_data["version"]
            }, headers=headers)
            assert patch_res.status_code == 200
            assert patch_res.json()["content"] == updated_content

            # 4. Approve / Publish article directly by admin
            approve_res = await ac.post(f"/api/journal/{entry_id}/approve", headers=headers)
            assert approve_res.status_code == 200
            assert approve_res.json()["status"] == "approved"

            # 5. Check public listing
            pub_res = await ac.get("/api/journal/public")
            assert pub_res.status_code == 200
            pub_ids = [item["id"] for item in pub_res.json()["items"]]
            assert entry_id in pub_ids

        finally:
            # Cleanup
            async with AsyncSessionLocal() as session:
                j = await session.get(JournalSubmission, UUID(entry_id))
                if j:
                    await session.delete(j)
                    await session.commit()
