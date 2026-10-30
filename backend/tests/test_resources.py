import pytest
from httpx import AsyncClient, ASGITransport
from app.main import app

@pytest.mark.asyncio
async def test_resource_crud_and_filtering():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        # 1. Public list
        list_res = await ac.get("/api/resources")
        assert list_res.status_code == 200
        data = list_res.json()
        assert "items" in data
        assert "total" in data

        # 2. Login as admin
        login_res = await ac.post("/api/auth/login", json={
            "email": "admin@jprclub.org",
            "password": "admin12345"
        })
        assert login_res.status_code == 200
        token = login_res.json()["access_token"]
        headers = {"Authorization": f"Bearer {token}"}

        # 3. Create a resource
        new_resource = {
            "title": "Nihongo Master Test Podcast",
            "title_ar": "بودكاست اختبار نيهونغو ماستر",
            "category": "podcast",
            "level": "jlpt",
            "jlpt_sublevel": "N4",
            "url": "https://example.com/podcast",
            "description": "Test podcast for learning Japanese intermediate level.",
            "description_ar": "بودكاست تجريبي للمستوى المتوسط.",
            "is_recommended": True,
            "status": "published"
        }
        create_res = await ac.post("/api/resources", json=new_resource, headers=headers)
        assert create_res.status_code == 201
        res_data = create_res.json()
        resource_id = res_data["id"]
        assert res_data["title"] == "Nihongo Master Test Podcast"
        assert res_data["category"] == "podcast"
        assert res_data["jlpt_sublevel"] == "N4"

        # 4. Filter by category
        filter_res = await ac.get("/api/resources?category=podcast")
        assert filter_res.status_code == 200
        assert all(item["category"] == "podcast" for item in filter_res.json()["items"])

        # 5. Filter by jlpt_sublevel
        sublevel_res = await ac.get("/api/resources?jlpt_sublevel=N4")
        assert sublevel_res.status_code == 200
        assert any(item["id"] == resource_id for item in sublevel_res.json()["items"])

        # 6. Update resource
        update_res = await ac.put(
            f"/api/resources/{resource_id}",
            json={"title": "Nihongo Master Updated Podcast"},
            headers=headers
        )
        assert update_res.status_code == 200
        assert update_res.json()["title"] == "Nihongo Master Updated Podcast"

        # 7. Delete resource
        del_res = await ac.delete(f"/api/resources/{resource_id}", headers=headers)
        assert del_res.status_code == 204

        # 8. Verify deletion
        get_res = await ac.get(f"/api/resources/{resource_id}")
        assert get_res.status_code == 404
