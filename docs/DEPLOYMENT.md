# JPR Club - Production Deployment Guide

This document explains how to move your codebase to a production server (VPS) and run it securely using a Cloudflare Tunnel.

## 1. What to Move to the Server
You do **NOT** need to move the `node_modules`, `venv`, `.git`, or temporary files. 

You only need to move the source code and configuration files:
*   `backend/` (source files, `requirements.txt`, etc.)
*   `frontend/` (source files, `package.json`, etc.)
*   `docker/` (contains Dockerfiles)
*   `docker-compose.prod.yml`
*   `.env.production` (you will create this securely on the server)

## 2. How to Move the Code to the VPS

### Option A: Using Git (Recommended)
The cleanest way is to use Git.
1. Push your code to a private GitHub/GitLab repository.
2. SSH into your VPS: `ssh root@your-server-ip`
3. Clone the repo: `git clone https://github.com/your-username/jprclub.git`

### Option B: Using Rsync (Direct Transfer)
If you don't want to use Git, you can copy the files directly from your computer to the VPS using `rsync` (mac/linux):
```bash
# Run this from your local machine, inside the JPRClub folder
rsync -avz --exclude 'node_modules' --exclude '.git' --exclude 'backend/venv' ./ root@your-server-ip:/opt/jprclub/
```

## 3. Server Setup

Once your code is on the VPS (e.g., in `/opt/jprclub`), SSH into the server and follow these steps:

### Step 3.1: Install Docker
If Docker is not installed on your VPS, install Docker and Docker Compose:
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

### Step 3.2: Create the `.env` file
Inside your project folder on the server, create a `.env` file containing your production secrets:
```bash
# PostgreSQL Database
POSTGRES_USER=jprclub_admin
POSTGRES_PASSWORD=your_super_secure_db_password
POSTGRES_DB=jprclub_prod

# Backend Security
SECRET_KEY=generate_a_random_32_character_string_here
BACKEND_CORS_ORIGINS=https://yourdomain.com

# Initial Admin User
ADMIN_EMAIL=admin@yourdomain.com
ADMIN_PASSWORD=your_secure_admin_password

# Cloudflare Tunnel
CLOUDFLARE_TUNNEL_TOKEN=your_cloudflare_token_here
```

## 4. Understanding Cloudflare Tunnel (cloudflared)

**Why use Cloudflare Tunnel instead of Caddy?**
Since you are using a Cloudflare Tunnel token, we do not need Caddy to manage SSL certificates or open ports on your server's firewall. 
The `cloudflared` container makes an outbound connection to Cloudflare's edge. Cloudflare handles the HTTPS (SSL/TLS) termination and securely routes traffic to your internal Docker containers. 
This means your server doesn't need *any* open inbound ports (not even 80 or 443)!

### Configuring the Tunnel in Cloudflare Dashboard:
In your Cloudflare Zero Trust Dashboard (Access > Tunnels > your tunnel > Public Hostnames), you only need **a single hostname rule**:
*   **Public Hostname**: `yourdomain.com` (e.g. `jprclub.zaytoonic.com`)
*   **Service**: `HTTP://frontend:80`

> **How it works:**
> Nginx inside the frontend container handles all routing internally:
> - Normal web requests (`/`, `/sessions`, `/journal`, etc.) serve the React SPA.
> - `/api/*` requests are automatically reverse-proxied to `http://backend:8000`.
> - `/media/*` requests are automatically reverse-proxied to `http://backend:8000`.
> 
> You do **not** need separate path rules for `/api` or `/media` in Cloudflare!

## 5. Starting Production

Run the following command to build and start the production environment in the background:
```bash
docker compose -f docker-compose.prod.yml --env-file .env up -d --build
```

**To apply database migrations (Run this once after the first start):**
```bash
docker compose -f docker-compose.prod.yml exec backend alembic upgrade head
```

**To seed the initial admin account and default sessions:**
```bash
docker compose -f docker-compose.prod.yml exec backend python -m app.db.init_db
```

## 6. Backups
Because we configured Docker volumes for the database and media, data persists even if containers are destroyed.
To back up the database, you can run:
```bash
docker compose -f docker-compose.prod.yml exec postgres pg_dump -U jprclub_admin jprclub_prod > backup.sql
```
To back up media files, simply copy `/var/lib/docker/volumes/jprclub_media_data/_data`.
