import pytest
from httpx import AsyncClient, ASGITransport
import io
from app.main import app

@pytest.mark.asyncio
async def test_upload_endpoints():
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

        # 2. Upload single image
        fake_png = io.BytesIO(b"\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x06\x00\x00\x00\x1f\x15c4")
        files = {"file": ("test_image.png", fake_png, "image/png")}
        res = await ac.post("/api/upload", files=files, headers=headers)
        assert res.status_code == 201, res.text
        data = res.json()
        assert "url" in data
        assert data["url"].startswith("/media/")
        assert data["url"].endswith(".png")

        # 3. Upload multiple images
        fake_jpg1 = io.BytesIO(b"\xff\xd8\xff\xe0\x00\x10JFIF\x00\x01\x01\x01\x00`\x00`\x00\x00")
        fake_jpg2 = io.BytesIO(b"\xff\xd8\xff\xe0\x00\x10JFIF\x00\x01\x01\x01\x00`\x00`\x00\x00")
        multi_files = [
            ("files", ("photo1.jpg", fake_jpg1, "image/jpeg")),
            ("files", ("photo2.jpg", fake_jpg2, "image/jpeg")),
        ]
        multi_res = await ac.post("/api/upload/multiple", files=multi_files, headers=headers)
        assert multi_res.status_code == 201, multi_res.text
        multi_data = multi_res.json()
        assert "urls" in multi_data
        assert len(multi_data["urls"]) == 2
        for url in multi_data["urls"]:
            assert url.startswith("/media/")
            assert url.endswith(".jpg")

        # 4. Reject non-image extension
        fake_txt = io.BytesIO(b"Hello world executable")
        bad_files = {"file": ("malicious.exe", fake_txt, "application/octet-stream")}
        bad_res = await ac.post("/api/upload", files=bad_files, headers=headers)
        assert bad_res.status_code == 400
