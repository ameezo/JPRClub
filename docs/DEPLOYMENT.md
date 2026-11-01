# JPR Club — Production Deployment & Migration Guide

This guide explains two approaches to managing your production server:
* **Method A (Recommended for Routine Updates): In-Place Rebuild** — Keeps your existing database and media volumes completely untouched (Zero risk, fastest).
* **Method B: Clean Slate Reset / Moving to a New Server** — How to set up a server from scratch, wipe/recreate containers, and safely restore both your **PostgreSQL database** and **website photos/media**.

---

## ⚠️ CRITICAL WARNING: What You Must Know Before Restoring or Wiping

### 1. The Database SQL file does NOT contain your photos!
* Your `.sql` backup only contains text and metadata (users, session titles, notes, comments, and file paths like `media/xyz.jpg`).
* **The actual image files, book covers, and gallery photos live inside the `media_data` Docker volume (`/app/media`).**
* If you delete Docker volumes without copying out `/app/media`, **ALL PHOTOS WILL BE PERMANENTLY LOST!**

### 2. Verify your SQL backup file before deleting anything!
* The PostgreSQL backup command is **`pg_dump`**.
* The correct syntax is:
  ```bash
  docker compose -f docker-compose.prod.yml exec -T postgres pg_dump -U <username> <database_name> > ./backups/production_db_backup.sql
  ```
* **Always verify the backup file size and contents** using `head -n 20 ./backups/production_db_backup.sql`.
* If the file is 0 KB or contains an error message, **DO NOT delete your containers!**

### 3. Why restoring an SQL backup requires wiping the schema first:
* When `backend` starts, its startup command automatically runs `alembic upgrade head && python -m app.db.init_db`, which inserts a temporary admin user (`admin@zaytoonic.com`).
* If you pipe your backup into PostgreSQL while those temporary tables exist, PostgreSQL will fail with:
  `ERROR: duplicate key value violates unique constraint "ix_users_email"`
  `ERROR: insert or update on table "sessions" violates foreign key constraint`
* **Solution:** You must clean the `public` schema first (`DROP SCHEMA public CASCADE; CREATE SCHEMA public;`) before piping your `.sql` backup file!

---

## Method A (Recommended): In-Place Update (Zero Risk, No Restore Needed)

When updating the site on an existing server, you do **not** need to wipe containers or volumes.

```bash
# 1. SSH into the server and pull latest code
cd /opt/jprclub
git pull origin main

# 2. Take a quick safety backup of database and media (just in case)
mkdir -p ./backups
docker compose -f docker-compose.prod.yml exec -T postgres pg_dump -U jprclub_admin jprclub_prod > ./backups/safety_backup_$(date +%Y%m%d_%H%M%S).sql
docker compose -f docker-compose.prod.yml cp backend:/app/media ./backups/media_backup_$(date +%Y%m%d_%H%M%S)

# 3. Rebuild frontend and backend containers only (Postgres stays running)
docker compose -f docker-compose.prod.yml --env-file .env up -d --build --no-deps frontend backend

# 4. Apply any new database migrations safely
docker compose -f docker-compose.prod.yml exec backend alembic upgrade head
```

---

## Method B: Clean Slate Reset (Full Wipe & Fresh Restore)

Follow this procedure if you want to completely remove all existing containers and volumes and start clean while restoring your database and photos.

### Step 1: Backup BOTH the Database AND the Photos

1. **Back up the Database:**
   ```bash
   mkdir -p ./backups
   docker compose -f docker-compose.prod.yml exec -T postgres pg_dump -U jprclub_admin jprclub_prod > ./backups/production_db_backup.sql
   ```

2. **Back up the Uploaded Photos & Media:**
   ```bash
   docker compose -f docker-compose.prod.yml cp backend:/app/media ./backups/media_backup
   ```

3. **VERIFY YOUR BACKUPS:**
   ```bash
   ls -lh ./backups/production_db_backup.sql
   ls -la ./backups/media_backup/
   head -n 25 ./backups/production_db_backup.sql
   ```
   * Ensure `production_db_backup.sql` is > 100 KB and begins with `-- PostgreSQL database dump`.

---

### Step 2: Wipe Docker Containers and Volumes

```bash
docker compose -f docker-compose.prod.yml down -v
```

---

### Step 3: Configure `.env` on the Server

Ensure `.env` matches your database credentials:

```bash
# Database credentials
POSTGRES_USER=jprclub_admin
POSTGRES_PASSWORD=your_super_secure_db_password
POSTGRES_DB=jprclub_prod

# Backend Security
SECRET_KEY=your_existing_production_secret_key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
BACKEND_CORS_ORIGINS=https://jprclub.zaytoonic.com

# Initial Admin User
ADMIN_EMAIL=admin@zaytoonic.com
ADMIN_PASSWORD=your_admin_password

# Cloudflare Tunnel
CLOUDFLARE_TUNNEL_TOKEN=your_tunnel_token_here
```

---

### Step 4: Start Fresh Containers

```bash
git pull origin main
docker compose -f docker-compose.prod.yml --env-file .env up -d --build

# Wait 10-15 seconds for PostgreSQL to initialize
sleep 10
docker compose -f docker-compose.prod.yml exec postgres pg_isready -U jprclub_admin
```

---

### Step 5: Clean Schema & Restore Database and Photos

#### 1. Clean the Temporary Schema:
```bash
docker compose -f docker-compose.prod.yml exec -T postgres psql -U jprclub_admin -d jprclub_prod -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO jprclub_admin;"
```

#### 2. Restore the SQL Database:
```bash
cat ./backups/production_db_backup.sql | docker compose -f docker-compose.prod.yml exec -T postgres psql -U jprclub_admin -d jprclub_prod
```

#### 3. Restore the Photos & Media:
```bash
# 1. Copy your media backup into the backend container
docker compose -f docker-compose.prod.yml cp ./backups/media_backup/. backend:/app/media/

# 2. Also copy any media committed in the repository
docker compose -f docker-compose.prod.yml cp ./backend/media/. backend:/app/media/

# 3. Ensure read permissions on all media files
docker compose -f docker-compose.prod.yml exec backend chmod -R 755 /app/media
```

#### 4. Apply New Database Migrations:
```bash
docker compose -f docker-compose.prod.yml exec backend alembic upgrade head
```

#### 5. Restart Backend:
```bash
docker compose -f docker-compose.prod.yml restart backend
```

#### 6. Verify Records:
```bash
docker compose -f docker-compose.prod.yml exec -T postgres psql -U jprclub_admin -d jprclub_prod -c "SELECT count(*) AS total_users FROM users; SELECT count(*) AS total_sessions FROM sessions; SELECT count(*) AS total_resources FROM resources;"
```

---

## 📋 Summary & Operations Cheat Sheet

Use these quick copy-paste blocks for day-to-day operations.

---

### 1. Steps to Git Clone to a New Server (with Backups)

Follow these steps when moving to a brand new VPS server from scratch:

```bash
# Step 1.1: Install Docker (if not installed)
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Step 1.2: Clone the repository into /opt/jprclub
sudo mkdir -p /opt/jprclub && sudo chown -R $USER:$USER /opt/jprclub
git clone https://github.com/ameezo/JPRClub.git /opt/jprclub
cd /opt/jprclub

# Step 1.3: Create the backups folder and transfer your backups from old server or local machine
mkdir -p ./backups
# (Upload production_db_backup.sql and media_backup folder into /opt/jprclub/backups/)
# Example using scp from local machine:
# scp production_db_backup.sql user@new-server:/opt/jprclub/backups/
# scp -r media_backup user@new-server:/opt/jprclub/backups/

# Step 1.4: Create the production .env file
nano .env
# Paste your production values (POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB, SECRET_KEY, CLOUDFLARE_TUNNEL_TOKEN)

# Step 1.5: Build and start fresh containers
docker compose -f docker-compose.prod.yml --env-file .env up -d --build

# Step 1.6: Wait 10 seconds for Postgres to initialize
sleep 10
docker compose -f docker-compose.prod.yml exec postgres pg_isready -U jprclub_admin

# Step 1.7: Clean default schema to avoid duplicate key conflicts
docker compose -f docker-compose.prod.yml exec -T postgres psql -U jprclub_admin -d jprclub_prod -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO jprclub_admin;"

# Step 1.8: Restore the SQL database
cat ./backups/production_db_backup.sql | docker compose -f docker-compose.prod.yml exec -T postgres psql -U jprclub_admin -d jprclub_prod

# Step 1.9: Restore all media photos & fix permissions
docker compose -f docker-compose.prod.yml cp ./backups/media_backup/. backend:/app/media/
docker compose -f docker-compose.prod.yml cp ./backend/media/. backend:/app/media/
docker compose -f docker-compose.prod.yml exec backend chmod -R 755 /app/media

# Step 1.10: Apply migrations & restart backend
docker compose -f docker-compose.prod.yml exec backend alembic upgrade head
docker compose -f docker-compose.prod.yml restart backend

# Step 1.11: Verify data counts
docker compose -f docker-compose.prod.yml exec -T postgres psql -U jprclub_admin -d jprclub_prod -c "SELECT count(*) FROM users; SELECT count(*) FROM sessions; SELECT count(*) FROM resources;"
```

---

### 2. Steps to Take Backups (Database + Photos)

Run these commands periodically or before any major server updates:

```bash
# Navigate to project directory
cd /opt/jprclub

# Ensure backups directory exists
mkdir -p ./backups

# 1. Back up the PostgreSQL database
docker compose -f docker-compose.prod.yml exec -T postgres pg_dump -U jprclub_admin jprclub_prod > ./backups/jprclub_backup_$(date +%Y%m%d_%H%M%S).sql

# Also keep a copy as latest production_db_backup.sql
cp $(ls -t ./backups/jprclub_backup_*.sql | head -1) ./backups/production_db_backup.sql

# 2. Back up website photos & media files
docker compose -f docker-compose.prod.yml cp backend:/app/media ./backups/media_backup

# 3. Verify backup integrity
ls -lh ./backups/
head -n 25 ./backups/production_db_backup.sql
ls -la ./backups/media_backup/
```

---

### 3. Steps to Recover from Backups

Run these commands whenever you need to restore your database and photos on an existing or recreated server:

```bash
# Navigate to project directory
cd /opt/jprclub

# 1. Clean the database schema (avoids duplicate admin user & foreign key errors)
docker compose -f docker-compose.prod.yml exec -T postgres psql -U jprclub_admin -d jprclub_prod -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO jprclub_admin;"

# 2. Restore database from SQL backup
cat ./backups/production_db_backup.sql | docker compose -f docker-compose.prod.yml exec -T postgres psql -U jprclub_admin -d jprclub_prod

# 3. Restore all photos & media files into the backend container
docker compose -f docker-compose.prod.yml cp ./backups/media_backup/. backend:/app/media/
docker compose -f docker-compose.prod.yml cp ./backend/media/. backend:/app/media/

# 4. Ensure read permissions on all media files
docker compose -f docker-compose.prod.yml exec backend chmod -R 755 /app/media

# 5. Apply any new migrations
docker compose -f docker-compose.prod.yml exec backend alembic upgrade head

# 6. Restart backend service
docker compose -f docker-compose.prod.yml restart backend

# 7. Verify all records restored successfully
docker compose -f docker-compose.prod.yml exec -T postgres psql -U jprclub_admin -d jprclub_prod -c "SELECT count(*) AS total_users FROM users; SELECT count(*) AS total_sessions FROM sessions; SELECT count(*) AS total_resources FROM resources;"
```
