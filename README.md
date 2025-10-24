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