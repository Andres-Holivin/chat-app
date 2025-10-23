#!/bin/bash
# health-check.sh - Check application health

set -e

APP_URL="${APP_URL:-http://localhost:80}"
MAX_ATTEMPTS="${MAX_ATTEMPTS:-10}"
WAIT_TIME="${WAIT_TIME:-3}"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "🔍 Checking application health at ${APP_URL}"

for i in $(seq 1 $MAX_ATTEMPTS); do
    if curl -f -s "${APP_URL}/" > /dev/null; then
        echo -e "${GREEN}✅ Application is healthy!${NC}"
        
        # Additional checks
        echo "📊 Container status:"
        docker-compose ps
        
        echo "📈 Resource usage:"
        docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
        
        exit 0
    fi
    
    echo "⏳ Attempt $i/$MAX_ATTEMPTS failed, retrying in ${WAIT_TIME}s..."
    sleep $WAIT_TIME
done

echo -e "${RED}❌ Health check failed after $MAX_ATTEMPTS attempts${NC}"
echo "📋 Recent logs:"
docker-compose logs --tail=30

exit 1
