# DEPLOYMENT GUIDE
## Hostinger VPS + FastAPI + PostgreSQL + Flutter
## Complete Setup from Zero to Production

---

# OVERVIEW

| Component | Technology | Location |
|-----------|------------|----------|
| Backend API | FastAPI + PostgreSQL | Hostinger VPS |
| Mobile App | Flutter | Google Play + App Store |
| SSL/HTTPS | Let's Encrypt (Certbot) | Hostinger VPS |
| Reverse Proxy | Nginx | Hostinger VPS |
| Process Manager | systemd | Hostinger VPS |

---

# PART 1: VPS INITIAL SETUP

## 1.1 Connect to VPS

Open Hostinger browser terminal or SSH:
```bash
ssh root@your-vps-ip
```

## 1.2 Update System

```bash
# Update package list
apt update

# Upgrade all packages
apt upgrade -y

# Install essential tools
apt install -y curl wget git unzip software-properties-common
```

## 1.3 Create Non-Root User (Recommended)

```bash
# Create user
adduser deploy

# Add to sudo group
usermod -aG sudo deploy

# Switch to new user
su - deploy
```

## 1.4 Configure Firewall

```bash
# Enable UFW
sudo ufw enable

# Allow SSH
sudo ufw allow 22

# Allow HTTP
sudo ufw allow 80

# Allow HTTPS
sudo ufw allow 443

# Check status
sudo ufw status
```

---

# PART 2: INSTALL POSTGRESQL

## 2.1 Install PostgreSQL

```bash
# Add PostgreSQL repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Add repository key
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update and install
sudo apt update
sudo apt install -y postgresql-16 postgresql-contrib-16
```

## 2.2 Configure PostgreSQL

```bash
# Start PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Check status
sudo systemctl status postgresql
```

## 2.3 Create Database and User

```bash
# Switch to postgres user
sudo -u postgres psql

# In PostgreSQL shell:
```

```sql
-- Create database
CREATE DATABASE your_project_db;

-- Create user with password
CREATE USER your_project_user WITH ENCRYPTED PASSWORD 'your_secure_password_here';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE your_project_db TO your_project_user;

-- Connect to database
\c your_project_db

-- Grant schema privileges (important for new PostgreSQL versions)
GRANT ALL ON SCHEMA public TO your_project_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO your_project_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO your_project_user;

-- Exit
\q
```

## 2.4 Test Database Connection

```bash
# Test connection
psql -h localhost -U your_project_user -d your_project_db

# If successful, you'll see the psql prompt
# Type \q to exit
```

---

# PART 3: INSTALL PYTHON AND DEPENDENCIES

## 3.1 Install Python 3.12

```bash
# Add deadsnakes PPA
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update

# Install Python 3.12
sudo apt install -y python3.12 python3.12-venv python3.12-dev

# Verify
python3.12 --version
```

## 3.2 Install pip

```bash
# Download get-pip.py
curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12

# Verify
python3.12 -m pip --version
```

---

# PART 4: INSTALL NGINX

## 4.1 Install Nginx

```bash
sudo apt install -y nginx

# Start and enable
sudo systemctl start nginx
sudo systemctl enable nginx

# Verify
sudo systemctl status nginx
```

## 4.2 Test Nginx

Open browser and go to: `http://your-vps-ip`

You should see "Welcome to nginx!" page.

---

# PART 5: DEPLOY BACKEND APPLICATION

## 5.1 Create App Directory

```bash
# Create directory structure
sudo mkdir -p /var/www/your_project
sudo chown -R $USER:$USER /var/www/your_project

# Navigate to directory
cd /var/www/your_project
```

## 5.2 Clone Repository

```bash
# Clone your repo
git clone https://github.com/your-username/your-repo.git .

# Or if private repo
git clone https://your-username:your-token@github.com/your-username/your-repo.git .
```

## 5.3 Setup Python Virtual Environment

```bash
# Navigate to backend
cd /var/www/your_project/backend

# Create virtual environment
python3.12 -m venv venv

# Activate
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt
```

## 5.4 Create Environment File

```bash
# Create .env file
nano /var/www/your_project/backend/.env
```

Add the following content:
```bash
# Application
APP_NAME=YourProjectName
DEBUG=false
ENVIRONMENT=production

# Database
DATABASE_URL=postgresql+asyncpg://your_project_user:your_secure_password_here@localhost:5432/your_project_db

# Security (generate with: openssl rand -hex 32)
SECRET_KEY=your-very-long-secret-key-at-least-32-characters
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# CORS (your domain)
CORS_ORIGINS=["https://yourdomain.com","https://api.yourdomain.com"]
```

Save: `Ctrl+O`, `Enter`, `Ctrl+X`

## 5.5 Run Database Migrations

```bash
# Make sure venv is active
source /var/www/your_project/backend/venv/bin/activate

# Navigate to backend
cd /var/www/your_project/backend

# Run migrations
alembic upgrade head
```

## 5.6 Test Application Manually

```bash
# Test run
uvicorn app.main:app --host 0.0.0.0 --port 8000

# Should see: Uvicorn running on http://0.0.0.0:8000
# Press Ctrl+C to stop
```

---

# PART 6: SETUP SYSTEMD SERVICE

## 6.1 Create Service File

```bash
sudo nano /etc/systemd/system/your_project.service
```

Add the following content:
```ini
[Unit]
Description=Your Project FastAPI Backend
After=network.target postgresql.service

[Service]
User=root
Group=www-data
WorkingDirectory=/var/www/your_project/backend
Environment="PATH=/var/www/your_project/backend/venv/bin"
EnvironmentFile=/var/www/your_project/backend/.env
ExecStart=/var/www/your_project/backend/venv/bin/uvicorn app.main:app --host 127.0.0.1 --port 8000 --workers 4
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Save and exit.

## 6.2 Start Service

```bash
# Reload systemd
sudo systemctl daemon-reload

# Start service
sudo systemctl start your_project

# Enable on boot
sudo systemctl enable your_project

# Check status
sudo systemctl status your_project
```

## 6.3 Useful Service Commands

```bash
# Stop service
sudo systemctl stop your_project

# Restart service
sudo systemctl restart your_project

# View logs
sudo journalctl -u your_project -f

# View last 100 lines
sudo journalctl -u your_project -n 100
```

---

# PART 7: CONFIGURE NGINX + SSL

## 7.1 Point Domain to VPS

In Hostinger DNS settings:
- Add A record: `@` → `your-vps-ip`
- Add A record: `api` → `your-vps-ip` (for api.yourdomain.com)

Wait 5-10 minutes for DNS propagation.

## 7.2 Create Nginx Configuration

```bash
sudo nano /etc/nginx/sites-available/your_project
```

Add the following content:
```nginx
# API Server
server {
    listen 80;
    server_name api.yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 86400;
    }
}

# Optional: Main domain (if hosting web frontend)
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    root /var/www/your_project/web/build;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

Save and exit.

## 7.3 Enable Site

```bash
# Create symlink
sudo ln -s /etc/nginx/sites-available/your_project /etc/nginx/sites-enabled/

# Remove default site (optional)
sudo rm /etc/nginx/sites-enabled/default

# Test configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx
```

## 7.4 Install SSL with Certbot

```bash
# Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d api.yourdomain.com -d yourdomain.com -d www.yourdomain.com

# Follow prompts:
# - Enter email
# - Agree to terms
# - Choose whether to redirect HTTP to HTTPS (recommended: Yes)
```

## 7.5 Auto-Renewal

```bash
# Test renewal
sudo certbot renew --dry-run

# Certbot adds auto-renewal cron job automatically
```

## 7.6 Verify SSL

Open browser: `https://api.yourdomain.com/docs`

You should see FastAPI Swagger documentation with HTTPS.

---

# PART 8: DEPLOYMENT WORKFLOW

## 8.1 Initial Deploy Script

Create `/var/www/your_project/scripts/deploy.sh`:

```bash
#!/bin/bash

echo "🚀 Starting deployment..."

# Navigate to project
cd /var/www/your_project

# Pull latest code
echo "📥 Pulling latest code..."
git pull origin main

# Backend deployment
echo "🐍 Deploying backend..."
cd backend
source venv/bin/activate
pip install -r requirements.txt
alembic upgrade head
deactivate

# Restart service
echo "🔄 Restarting service..."
sudo systemctl restart your_project

echo "✅ Deployment complete!"
echo "📊 Service status:"
sudo systemctl status your_project --no-pager
```

Make executable:
```bash
chmod +x /var/www/your_project/scripts/deploy.sh
```

## 8.2 Run Deployment

```bash
# Run deploy script
/var/www/your_project/scripts/deploy.sh
```

## 8.3 Quick Commands Reference

```bash
# Deploy latest code
cd /var/www/your_project && git pull && sudo systemctl restart your_project

# View live logs
sudo journalctl -u your_project -f

# Check service status
sudo systemctl status your_project

# Restart service
sudo systemctl restart your_project

# Check nginx status
sudo systemctl status nginx

# Reload nginx config
sudo nginx -t && sudo systemctl reload nginx
```

---

# PART 9: FLUTTER MOBILE BUILD

## 9.1 Environment Setup (Development Machine)

### Update API Base URL

In `mobile/lib/core/config/env_config.dart`:
```dart
class EnvConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.yourdomain.com',
  );
}
```

## 9.2 Build Android APK

```bash
# Navigate to mobile folder
cd mobile

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Build release APK
flutter build apk --release --dart-define=API_BASE_URL=https://api.yourdomain.com

# Output: build/app/outputs/flutter-apk/app-release.apk
```

## 9.3 Build Android App Bundle (for Play Store)

```bash
# Build app bundle
flutter build appbundle --release --dart-define=API_BASE_URL=https://api.yourdomain.com

# Output: build/app/outputs/bundle/release/app-release.aab
```

## 9.4 Build iOS (requires Mac)

```bash
# Navigate to mobile folder
cd mobile

# Clean
flutter clean

# Get dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Build iOS
flutter build ios --release --dart-define=API_BASE_URL=https://api.yourdomain.com

# Then open Xcode for archive and upload
open ios/Runner.xcworkspace
```

---

# PART 10: GITHUB ACTIONS CI/CD

## 10.1 Backend Deploy Workflow

Create `.github/workflows/deploy_backend.yml`:

```yaml
name: Deploy Backend

on:
  push:
    branches: [main]
    paths:
      - 'backend/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - name: Deploy to VPS
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.VPS_HOST }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          script: |
            cd /var/www/your_project
            git pull origin main
            cd backend
            source venv/bin/activate
            pip install -r requirements.txt
            alembic upgrade head
            deactivate
            sudo systemctl restart your_project
```

## 10.2 Flutter Build Workflow

Create `.github/workflows/flutter_build.yml`:

```yaml
name: Flutter Build

on:
  push:
    branches: [main]
    paths:
      - 'mobile/**'

jobs:
  build-android:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'
      
      - name: Get dependencies
        working-directory: mobile
        run: flutter pub get
      
      - name: Run code generation
        working-directory: mobile
        run: dart run build_runner build --delete-conflicting-outputs
      
      - name: Build APK
        working-directory: mobile
        run: flutter build apk --release --dart-define=API_BASE_URL=https://api.yourdomain.com
      
      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: app-release
          path: mobile/build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    runs-on: macos-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'
      
      - name: Get dependencies
        working-directory: mobile
        run: flutter pub get
      
      - name: Run code generation
        working-directory: mobile
        run: dart run build_runner build --delete-conflicting-outputs
      
      - name: Build iOS
        working-directory: mobile
        run: flutter build ios --release --no-codesign --dart-define=API_BASE_URL=https://api.yourdomain.com
```

## 10.3 Setup GitHub Secrets

Go to GitHub repo → Settings → Secrets and variables → Actions

Add these secrets:
- `VPS_HOST`: Your VPS IP address
- `VPS_USER`: `root` or your deploy user
- `VPS_SSH_KEY`: Your private SSH key

---

# PART 11: DATABASE BACKUP

## 11.1 Manual Backup

```bash
# Backup database
pg_dump -U your_project_user -h localhost your_project_db > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore database
psql -U your_project_user -h localhost your_project_db < backup_file.sql
```

## 11.2 Automated Daily Backup

Create `/var/www/your_project/scripts/backup_db.sh`:

```bash
#!/bin/bash

BACKUP_DIR="/var/backups/postgresql"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="your_project_db"
DB_USER="your_project_user"

# Create backup directory
mkdir -p $BACKUP_DIR

# Create backup
PGPASSWORD="your_password" pg_dump -U $DB_USER -h localhost $DB_NAME > $BACKUP_DIR/backup_$DATE.sql

# Compress
gzip $BACKUP_DIR/backup_$DATE.sql

# Delete backups older than 7 days
find $BACKUP_DIR -name "*.gz" -mtime +7 -delete

echo "Backup completed: backup_$DATE.sql.gz"
```

Add to crontab:
```bash
# Edit crontab
crontab -e

# Add daily backup at 2 AM
0 2 * * * /var/www/your_project/scripts/backup_db.sh
```

---

# PART 12: MONITORING & LOGS

## 12.1 View Application Logs

```bash
# Live logs
sudo journalctl -u your_project -f

# Last 100 lines
sudo journalctl -u your_project -n 100

# Logs from today
sudo journalctl -u your_project --since today

# Logs from last hour
sudo journalctl -u your_project --since "1 hour ago"
```

## 12.2 View Nginx Logs

```bash
# Access logs
sudo tail -f /var/log/nginx/access.log

# Error logs
sudo tail -f /var/log/nginx/error.log
```

## 12.3 System Monitoring

```bash
# CPU and Memory
htop

# Disk usage
df -h

# Check running processes
ps aux | grep uvicorn

# Check port usage
sudo netstat -tulpn | grep LISTEN
```

---

# QUICK REFERENCE COMMANDS

## Deployment

```bash
# Full deploy
cd /var/www/your_project && git pull && cd backend && source venv/bin/activate && pip install -r requirements.txt && alembic upgrade head && deactivate && sudo systemctl restart your_project

# Quick restart
sudo systemctl restart your_project

# Check status
sudo systemctl status your_project
```

## Database

```bash
# Connect to database
sudo -u postgres psql -d your_project_db

# Backup
pg_dump -U your_project_user your_project_db > backup.sql

# Check database size
sudo -u postgres psql -c "SELECT pg_size_pretty(pg_database_size('your_project_db'));"
```

## SSL

```bash
# Renew SSL
sudo certbot renew

# Check certificate expiry
sudo certbot certificates
```

## Troubleshooting

```bash
# Service won't start - check logs
sudo journalctl -u your_project -n 50

# Nginx config error
sudo nginx -t

# Port already in use
sudo lsof -i :8000

# Kill process on port
sudo kill -9 $(sudo lsof -t -i :8000)
```

---

# CHECKLIST: FIRST DEPLOYMENT

```
□ VPS updated (apt update && apt upgrade)
□ Firewall configured (ports 22, 80, 443)
□ PostgreSQL installed and running
□ Database and user created
□ Python 3.12 installed
□ Nginx installed
□ Repository cloned to /var/www/your_project
□ Virtual environment created
□ Dependencies installed
□ .env file configured
□ Migrations run
□ Systemd service created and started
□ Nginx configured
□ Domain pointed to VPS
□ SSL certificate installed
□ HTTPS working
□ API accessible at https://api.yourdomain.com/docs
```

---

# SECURITY CHECKLIST

```
□ Non-root user for deployment
□ SSH key authentication (disable password)
□ Firewall enabled
□ Strong database password
□ SECRET_KEY is long and random
□ DEBUG=false in production
□ CORS configured correctly
□ SSL/HTTPS enabled
□ Database not exposed to internet
□ Regular backups configured
```
