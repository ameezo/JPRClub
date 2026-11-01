# JPR Club — Production Deployment & Update Guide

This guide explains how to safely deploy updates from your local developer machine to an **existing production server**, ensuring that **the production database and uploaded media remain 100% intact with zero data loss**.

---

## ⚠️ The 3 Golden Rules to Protect Production Data

1. **NEVER run `docker compose down -v` on production:**
   * The `-v` flag deletes named Docker volumes (`postgres_data`, `media_data`), which completely erases your database!
   * Always use `docker compose down` (without `-v`) or better yet, rebuild containers in-place using `up -d --build`.

2. **NEVER overwrite the server's `.env` with your local `.env`:**
   * Your server's `.env` holds the production `POSTGRES_PASSWORD`, `SECRET_KEY`, and admin credentials.
   * If you change the database password or secret key, the backend will not be able to decrypt tokens or access existing tables.

3. **Rebuild ONLY `frontend` and `backend` containers:**
   * The database container (`postgres`) does not need to be rebuilt.
   * Keeping `postgres` running means your database connections stay stable and volumes are never detached.

---

## Step-by-Step: Moving Latest Updates to the Server

### Step 1: Pre-Deployment Database Backup (Takes 30 Seconds)

Before touching any code or restarting any container, always take a timestamped snapshot of your live database.

1. SSH into your server:
   ```bash
   ssh user@your-server-ip
   cd /opt/jprclub   # or your project folder on the server
   ```

2. Create a timestamped SQL dump:
   ```bash
   # Create a backups directory if not already present
   mkdir -p ./backups

   # Export the database directly from the running postgres container
   docker compose -f docker-compose.prod.yml exec -T postgres pg_dump -U jprclub jprclub > ./backups/jprclub_backup_$(date +%Y%m%d_%H%M%S).sql
   ```

3. Confirm the backup file exists and has content:
   ```bash
   ls -lh ./backups/
   ```

---

### Step 2: Transfer Latest Code to the Server

#### Option A: Using Git (Recommended)
Since all changes have been pushed to GitHub (`origin/main`):

```bash
# On the server inside the project root:
git fetch origin main
git pull origin main
```

> **Note:** If git warns about local changes to `.env` or temporary files, run `git status`. Your `.env` should remain untracked (it is in `.gitignore`).

#### Option B: Using Rsync (Direct File Transfer)
If you transfer files directly from your local Mac, **make sure to exclude `.env`, `.git`, and volumes**:

```bash
# Run this from your LOCAL Mac inside /Users/ameezo/File/JPRClub:
rsync -avz --exclude '.env*' \
            --exclude 'node_modules' \
            --exclude '.git' \
            --exclude 'backend/venv' \
            --exclude 'backend/media' \
            --exclude 'backups' \
            ./ user@your-server-ip:/opt/jprclub/
```

---

### Step 3: Verify Environment & Ports on Server

Check that your server `.env` file is present and has the correct settings:

```bash
cat .env
```

Ensure the key variables are set:
```bash
# PostgreSQL Database (Must match the existing production database!)
POSTGRES_USER=jprclub
POSTGRES_PASSWORD=your_existing_production_db_password
POSTGRES_DB=jprclub

# Backend Security
SECRET_KEY=your_existing_production_secret_key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
BACKEND_CORS_ORIGINS=https://yourdomain.com,http://your-server-ip

# Port for frontend (Nginx reverse proxy)
PORT=80
```

> **Note on Cloudflare:** If you manage Cloudflare via the Cloudflare dashboard (DNS A-record pointing to your server IP or a host-level tunnel), the frontend container simply listens on port 80 (or your configured `$PORT`). No extra cloudflare container is needed in Docker.

---

### Step 4: Rebuild Frontend & Backend (Database Untouched)

Rebuild **only** the `frontend` and `backend` images and restart their containers in the background.

```bash
docker compose -f docker-compose.prod.yml --env-file .env up -d --build --no-deps frontend backend
```

> **Why `--no-deps frontend backend`?**
> This instructs Docker Compose to rebuild and replace *only* the frontend and backend containers.
> The `postgres` container continues running completely uninterrupted.

---

### Step 5: Apply Database Migrations (Safe & Non-Destructive)

Alembic migrations only add new columns and tables needed for new features (e.g., reports, studio fields, resources, journal tables); **they never delete existing data**.

Run the migration command inside the backend container:
```bash
docker compose -f docker-compose.prod.yml exec backend alembic upgrade head
```

You should see output indicating migrations were applied or already at `head`:
```text
INFO  [alembic.runtime.migration] Context impl PostgresqlImpl.
INFO  [alembic.runtime.migration] Will assume transactional DDL.
...
INFO  [alembic.runtime.migration] Running upgrade -> ...
```

> ⚠️ **IMPORTANT: Do NOT run `python -m app.db.init_db` on an existing production database.**
> `init_db` is only intended for Day 1 on a completely blank database. On an existing server with real users, running `alembic upgrade head` is all that is required.

---

### Step 6: Verify Deployment Health

1. **Check running containers:**
   ```bash
   docker compose -f docker-compose.prod.yml ps
   ```
   All three containers should be `Up`:
   * `jprclub-db-prod` (healthy)
   * `jprclub-backend-prod`
   * `jprclub-frontend-prod`

2. **Check backend logs for any runtime errors:**
   ```bash
   docker compose -f docker-compose.prod.yml logs --tail 40 backend
   ```

3. **Check frontend Nginx logs:**
   ```bash
   docker compose -f docker-compose.prod.yml logs --tail 20 frontend
   ```

4. **Verify in your browser:**
   * Open `https://yourdomain.com` (or `http://your-server-ip`).
   * Verify the new **Washi Paper & Ink** design elements, navigation bar, hero ticket, studio notes, and resources directory.
   * Log into the Admin or Member dashboard to ensure your existing user account works seamlessly.

---

## Emergency Rollback (Just in Case)

If anything unexpected ever occurs with your application data:

1. Restore the SQL backup created in Step 1:
   ```bash
   # Replace with your actual backup filename:
   cat ./backups/jprclub_backup_YYYYMMDD_HHMMSS.sql | docker compose -f docker-compose.prod.yml exec -T postgres psql -U jprclub -d jprclub
   ```

2. Restart the backend:
   ```bash
   docker compose -f docker-compose.prod.yml restart backend
   ```

---

## Summary Cheat Sheet (Copy-Paste for Future Updates)

When deploying future updates to your production server:

```bash
# 1. SSH into the server
ssh user@your-server-ip
cd /opt/jprclub

# 2. Safety database backup
mkdir -p ./backups
docker compose -f docker-compose.prod.yml exec -T postgres pg_dump -U jprclub jprclub > ./backups/backup_$(date +%Y%m%d_%H%M%S).sql

# 3. Pull latest code from GitHub
git pull origin main

# 4. Rebuild frontend and backend only
docker compose -f docker-compose.prod.yml --env-file .env up -d --build --no-deps frontend backend

# 5. Apply migrations
docker compose -f docker-compose.prod.yml exec backend alembic upgrade head

# 6. Verify logs
docker compose -f docker-compose.prod.yml logs --tail 30 backend
```
