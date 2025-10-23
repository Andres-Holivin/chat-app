#!/bin/bash
# deploy.sh - Server-side deployment script
# Run this script on your server to deploy the application

set -e

# Configuration
APP_NAME="chat-app"
DEPLOY_DIR="${DEPLOY_DIR:-/opt/chat-app}"
IMAGE_NAME="${IMAGE_NAME:-ghcr.io/YOUR_USERNAME/chat-app:latest}"
BACKUP_DIR="${DEPLOY_DIR}/backups"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting deployment of ${APP_NAME}${NC}"

# Create backup directory
mkdir -p "${BACKUP_DIR}"

# Function to rollback
rollback() {
    echo -e "${RED}❌ Deployment failed, rolling back...${NC}"
    if [ -f "${BACKUP_DIR}/docker-compose.yml.backup" ]; then
        cp "${BACKUP_DIR}/docker-compose.yml.backup" "${DEPLOY_DIR}/docker-compose.yml"
        cd "${DEPLOY_DIR}"
        docker-compose up -d
        echo -e "${YELLOW}⚠️  Rolled back to previous version${NC}"
    fi
    exit 1
}

# Trap errors
trap rollback ERR

# Navigate to deployment directory
cd "${DEPLOY_DIR}"

# Backup current docker-compose.yml
if [ -f "docker-compose.yml" ]; then
    echo "📦 Backing up current configuration..."
    cp docker-compose.yml "${BACKUP_DIR}/docker-compose.yml.backup"
fi

# Pull latest code (if using git deployment)
# git pull origin main

# Pull latest Docker image
echo "📥 Pulling latest Docker image..."
docker pull "${IMAGE_NAME}"

# Stop current containers
echo "⏸️  Stopping current containers..."
docker-compose down

# Start new containers
echo "▶️  Starting new containers..."
docker-compose up -d

# Wait for application to be ready
echo "⏳ Waiting for application to start..."
sleep 15

# Run database migrations
echo "🗄️  Running database migrations..."
docker-compose exec -T web bundle exec rails db:migrate

# Check if container is running
if docker ps | grep -q "${APP_NAME}"; then
    echo -e "${GREEN}✅ Deployment successful!${NC}"
    
    # Show running containers
    docker-compose ps
    
    # Clean up old images
    echo "🧹 Cleaning up old images..."
    docker image prune -af --filter "until=48h"
    
    # Remove old backups (keep last 5)
    ls -t "${BACKUP_DIR}"/docker-compose.yml.backup* 2>/dev/null | tail -n +6 | xargs -r rm
    
    echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
else
    echo -e "${RED}❌ Container failed to start${NC}"
    docker-compose logs --tail=50
    rollback
fi
