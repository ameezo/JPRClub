import pytest
from httpx import AsyncClient, ASGITransport
from datetime import datetime, timezone
from uuid import UUID
from app.main import app
from app.db.database import AsyncSessionLocal
from app.models.session_interest import SessionInterest

@pytest.mark.asyncio
async def test_session_interest_workflow():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        # 1. Public submission (no auth)
        payload = {
            "type": "volunteer",
            "full_name": "Taro Tanaka",
            "email": "taro@example.com",
            "phone": "+966500000000",
            "message": "I would love to help prepare reading materials."
        }
        res = await ac.post("/api/session-interests", json=payload)
        assert res.status_code == 201
        data = res.json()
        interest_id = data["id"]
        assert data["type"] == "volunteer"
        assert data["full_name"] == "Taro Tanaka"
        assert data["status"] == "new"

        try:
            # 2. Public access to admin list should be forbidden/unauthorized
            list_unauth = await ac.get("/api/session-interests")
            assert list_unauth.status_code == 401

            # 3. Login as admin
            login_res = await ac.post("/api/auth/login", json={
                "email": "admin@jprclub.org",
                "password": "admin12345"
            })
            assert login_res.status_code == 200
            token = login_res.json()["access_token"]
            headers = {"Authorization": f"Bearer {token}"}

            # 4. Admin can list submissions
            list_res = await ac.get("/api/session-interests", headers=headers)
            assert list_res.status_code == 200
            items = list_res.json()["items"]
            assert any(item["id"] == interest_id for item in items)

            # 5. Admin can filter by type
            filter_res = await ac.get("/api/session-interests?type=volunteer", headers=headers)
            assert filter_res.status_code == 200
            assert all(item["type"] == "volunteer" for item in filter_res.json()["items"])

            # 6. Admin can update status
            patch_res = await ac.patch(
                f"/api/session-interests/{interest_id}",
                json={"status": "contacted"},
                headers=headers
            )
            assert patch_res.status_code == 200
            assert patch_res.json()["status"] == "contacted"

            # 7. Admin can delete submission
            del_res = await ac.delete(f"/api/session-interests/{interest_id}", headers=headers)
            assert del_res.status_code == 204

            # Verify deleted
            get_res = await ac.get(f"/api/session-interests/{interest_id}", headers=headers)
            assert get_res.status_code == 404

        finally:
            async with AsyncSessionLocal() as session:
                entry = await session.get(SessionInterest, UUID(interest_id))
                if entry:
                    await session.delete(entry)
                    await session.commit()
