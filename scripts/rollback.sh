#!/bin/bash
# rollback.sh - Rollback to previous deployment

set -e

DEPLOY_DIR="${DEPLOY_DIR:-/opt/chat-app}"
BACKUP_DIR="${DEPLOY_DIR}/backups"

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

cd "${DEPLOY_DIR}"

if [ ! -f "${BACKUP_DIR}/docker-compose.yml.backup" ]; then
    echo -e "${RED}❌ No backup found to rollback to!${NC}"
    exit 1
fi

echo -e "${YELLOW}⚠️  Rolling back to previous version...${NC}"

# Stop current containers
echo "⏸️  Stopping current containers..."
docker-compose down

# Restore backup
echo "📦 Restoring backup configuration..."
cp "${BACKUP_DIR}/docker-compose.yml.backup" docker-compose.yml

# Restart containers
echo "▶️  Starting previous version..."
docker-compose up -d

# Wait and check
sleep 10

if docker ps | grep -q "chat-app"; then
    echo -e "${GREEN}✅ Rollback successful!${NC}"
    docker-compose ps
else
    echo -e "${RED}❌ Rollback failed!${NC}"
    docker-compose logs --tail=50
    exit 1
fi
