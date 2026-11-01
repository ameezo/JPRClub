# JPR Club — Production Deployment & Migration Guide

This guide explains two approaches to updating your production server:
* **Method A (Recommended): In-Place Rebuild** — Keeps your existing database and media volumes completely untouched (Zero risk, fastest).
* **Method B: Clean Slate Reset (Wipe & Restore)** — How to delete all Docker containers and volumes, start fresh, and safely restore both your **database** and **website photos/media**.

---

## ⚠️ CRITICAL WARNING: What You Must Know Before Deleting Docker

### 1. The Database SQL file does NOT contain your photos!
* Your `.sql` backup only contains text data (users, session titles, notes, comments, and file paths like `media/xyz.jpg`).
* **The actual image files, book covers, and gallery photos live inside the `media_data` Docker volume (`/app/media`).**
* If you delete all Docker volumes without copying out `/app/media`, **ALL PHOTOS WILL BE PERMANENTLY LOST!**

### 2. Verify your SQL backup file before deleting anything!
* The PostgreSQL backup command is **`pg_dump`** (not `jprclub_prod` or `postgres`).
* The correct syntax is:
  ```bash
  docker compose -f docker-compose.prod.yml exec -T postgres pg_dump -U <username> <database_name> > ./backups/backup.sql
  ```
* **Always verify the backup file size and contents** using `head -n 20 ./backups/backup.sql`. If the file is empty (0 KB) or contains an error message, **DO NOT delete your containers!**

---

## Method A (Recommended): In-Place Update (Zero Risk, No Restore Needed)

You do **not** need to wipe your containers or volumes to update the website. When you rebuild, Docker keeps your database and media volumes attached.

```bash
# 1. SSH into the server and pull latest code
cd /opt/jprclub
git pull origin main

# 2. Take a safety backup of database and media (just in case)
mkdir -p ./backups
docker compose -f docker-compose.prod.yml exec -T postgres pg_dump -U jprclub jprclub > ./backups/safety_backup_$(date +%Y%m%d_%H%M%S).sql
docker compose -f docker-compose.prod.yml cp backend:/app/media ./backups/media_backup_$(date +%Y%m%d_%H%M%S)

# 3. Rebuild frontend and backend containers only (Postgres stays running)
docker compose -f docker-compose.prod.yml --env-file .env up -d --build --no-deps frontend backend

# 4. Apply any new database migrations safely
docker compose -f docker-compose.prod.yml exec backend alembic upgrade head
```

---

## Method B: Clean Slate Reset (Full Wipe & Fresh Restore)

Follow this exact procedure if you want to completely remove all existing containers and volumes and start clean while restoring your database and photos.

### Step 1: Backup BOTH the Database AND the Photos

1. **Back up the Database:**
   ```bash
   mkdir -p ./backups

   # Use your existing production database credentials from .env:
   # (Default user: jprclub, DB: jprclub — or jprclub_admin / jprclub_prod if customized)
   docker compose -f docker-compose.prod.yml exec -T postgres pg_dump -U jprclub jprclub > ./backups/production_db_backup.sql
   ```

2. **Back up the Uploaded Photos & Media:**
   ```bash
   # Copy the entire /app/media folder out of the backend container to the host
   docker compose -f docker-compose.prod.yml cp backend:/app/media ./backups/media_backup
   ```

3. **VERIFY YOUR BACKUPS (DO NOT SKIP THIS!):**
   ```bash
   # Check file sizes
   ls -lh ./backups/
   ls -la ./backups/media_backup/

   # Inspect the top of the SQL file
   head -n 25 ./backups/production_db_backup.sql
   ```
   * You should see: `-- PostgreSQL database dump` and `CREATE TABLE ...`.
   * You should see files inside `./backups/media_backup/`.
   * **If either backup is empty, STOP and fix the command before proceeding!**

---

### Step 2: Wipe Docker Containers and Volumes

Now that you have verified backups of both the SQL data and media files on your host disk:

```bash
# Stop and remove all containers, networks, and named volumes
docker compose -f docker-compose.prod.yml down -v
```

> **Optional:** If you want to clean old cached Docker images:
> ```bash
> docker image prune -f
> ```

---

### Step 3: Configure `.env` on the Server

Ensure your `.env` matches the username and database name from your backup:

```bash
# Database credentials
POSTGRES_USER=jprclub
POSTGRES_PASSWORD=your_secure_db_password
POSTGRES_DB=jprclub

# Backend Security
SECRET_KEY=your_existing_production_secret_key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
BACKEND_CORS_ORIGINS=https://yourdomain.com,http://localhost:5173

# Frontend Port
PORT=80
```

> 💡 **Tip:** If your backup was originally made from `POSTGRES_USER=jprclub_admin` and `POSTGRES_DB=jprclub_prod`, set those exact same values in `.env` so all table permissions match without any warnings.

---

### Step 4: Start Fresh Containers

Pull latest code and start the containers:

```bash
# Pull latest code
git pull origin main

# Start containers with fresh volumes
docker compose -f docker-compose.prod.yml --env-file .env up -d --build
```

Wait ~10–15 seconds for PostgreSQL to initialize itself:
```bash
docker compose -f docker-compose.prod.yml exec postgres pg_isready -U jprclub
```
You should see: `accepting connections`.

---

### Step 5: Restore the Database & Photos (In This Exact Order!)

#### 1. Restore the SQL Database:
Pipe your backup file into `psql`:

```bash
cat ./backups/production_db_backup.sql | docker compose -f docker-compose.prod.yml exec -T postgres psql -U jprclub -d jprclub
```

> **Why before migrations?**
> You must restore the database **before** running Alembic. The backup file already contains your original schema and `alembic_version`.

#### 2. Restore the Photos & Media:
Copy the saved media files back into the newly created `media_data` volume inside the backend container:

```bash
docker compose -f docker-compose.prod.yml cp ./backups/media_backup/. backend:/app/media/
```

Verify the files are in place:
```bash
docker compose -f docker-compose.prod.yml exec backend ls -la /app/media
```

#### 3. Apply New Database Migrations:
Now run Alembic so any new columns/tables added in the redesign (e.g. session metrics, resources, journal tables) are safely added:

```bash
docker compose -f docker-compose.prod.yml exec backend alembic upgrade head
```

#### 4. Restart Backend to Refresh Connections:
```bash
docker compose -f docker-compose.prod.yml restart backend
```

---

### Step 6: Verify Everything is Working

1. **Check running containers:**
   ```bash
   docker compose -f docker-compose.prod.yml ps
   ```
2. **Check backend logs:**
   ```bash
   docker compose -f docker-compose.prod.yml logs --tail 30 backend
   ```
3. **Open the site in your browser:**
   * Verify all existing sessions, notes, and member accounts are visible.
   * Verify uploaded book covers and photos are loading properly (HTTP 200, not 404).
