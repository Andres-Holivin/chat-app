# ⚡ Ruby on Rails 8 + React App

A **full-stack web application** built using **Ruby on Rails 8** (API mode) and **React 18** frontend.

Rails handles the backend API, while React powers the user interface — integrated with **Vite** or **Webpacker**, depending on setup.

---

## 🚀 Features

- Ruby on Rails 8 (API mode)
- React 19 with TypeScript
- PostgreSQL database (Neon)
- Redis for ActionCable (Redis Cloud)
- Real-time chat with WebSockets
- TailwindCSS 4 (frontend)
- Shadcn/ui components
- Docker deployment ready
- GitHub Actions CI/CD

---

## 🐳 Quick Start with Docker

The fastest way to run this application:

```bash
# 1. Clone the repository
git clone https://github.com/Andres-Holivin/chat-app
cd chat-app

# 2. Create .env file (copy from .env.example if available)
# Add your DATABASE_URL, REDIS_URL, and SECRET_KEY_BASE

# 3. Build and run with Docker
docker-compose up -d

# 4. Run migrations
docker-compose run --rm web bundle exec rails db:migrate

# 5. Open in browser
# http://localhost:3000
```

---

## 🚀 Deployment to Production Server

This app includes automated deployment via GitHub Actions. See detailed guides:

- **[📘 Full Deployment Guide](DEPLOYMENT.md)** - Complete step-by-step instructions
- **[🔑 GitHub Secrets Setup](GITHUB_SECRETS.md)** - How to configure secrets

### Quick Deployment Steps:

1. **Prepare your server** (run on your server):
   ```bash
   # Copy and run the setup script
   curl -o setup.sh https://raw.githubusercontent.com/Andres-Holivin/chat-app/main/scripts/setup-server.sh
   chmod +x setup.sh
   ./setup.sh
   ```

2. **Set up GitHub Secrets** (in your repository settings):
   - `SERVER_HOST` - Your server IP/domain
   - `SERVER_USER` - SSH username
   - `SERVER_SSH_KEY` - Your private SSH key
   - `SERVER_PORT` - SSH port (usually 22)
   - `DEPLOY_PATH` - Deployment directory (e.g., /opt/chat-app)
   - `GHCR_TOKEN` - GitHub Personal Access Token

3. **Deploy automatically**:
   ```bash
   git push origin main
   ```
   
   Or trigger manually from GitHub Actions tab.

4. **Access your app**:
   ```
   http://your-server-ip:3000
   ```

### Pre-Deployment Check

Run this on your local machine before deploying:

```powershell
# Windows PowerShell
.\scripts\pre-deploy-check.ps1
```

---

## 🧰 Requirements

| Tool | Version |
|------|----------|
| Ruby | 3.2+ |
| Rails | 8.0+ |
| Node.js | 18+ |
| Yarn / npm / Bun | Latest |
| PostgreSQL | 14+ |

---

## ⚙️ Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/Andres-Holivin/chat-app
cd chat-app
```
### 2. Backend Setup (Rails API)
```bash
Install gems
bundle install
```

### Setup environment variables

Create a .env file:
```
DATABASE_URL=postgresql://user:password@localhost:5432/rails_react_dev
SECRET_KEY_BASE=your-secret-key
```

### Setup database
```
rails db:create db:migrate db:seed
```
### Start Rails API
```
bin/dev
```

or manually:

```
rails server -p 3000
```


API available at 👉 http://localhost:3000