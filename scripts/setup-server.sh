#!/bin/bash

# Server Setup Script for Chat App Deployment
# Run this script on your server to prepare it for deployment

set -e

echo "🚀 Setting up server for Chat App deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}Please don't run this script as root. Run as normal user with sudo privileges.${NC}"
    exit 1
fi

# Update system
echo -e "${YELLOW}📦 Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}🐳 Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    echo -e "${GREEN}✅ Docker installed successfully${NC}"
else
    echo -e "${GREEN}✅ Docker already installed${NC}"
fi

# Install Docker Compose if not already installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}🐙 Installing Docker Compose...${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}✅ Docker Compose installed successfully${NC}"
else
    echo -e "${GREEN}✅ Docker Compose already installed${NC}"
fi

# Install curl if not already installed
if ! command -v curl &> /dev/null; then
    echo -e "${YELLOW}📡 Installing curl...${NC}"
    sudo apt install curl -y
fi

# Create deployment directory
DEPLOY_DIR="/opt/chat-app"
echo -e "${YELLOW}📁 Creating deployment directory at $DEPLOY_DIR${NC}"
sudo mkdir -p $DEPLOY_DIR
sudo chown $USER:$USER $DEPLOY_DIR

# Prompt for environment variables
echo -e "${YELLOW}⚙️  Setting up environment variables...${NC}"
read -p "Enter your DATABASE_URL: " DATABASE_URL
read -p "Enter your REDIS_URL: " REDIS_URL
read -p "Enter your SECRET_KEY_BASE: " SECRET_KEY_BASE

# Create .env file
cat > $DEPLOY_DIR/.env << EOF
DATABASE_URL=$DATABASE_URL
REDIS_URL=$REDIS_URL
RAILS_ENV=production
SECRET_KEY_BASE=$SECRET_KEY_BASE
EOF

echo -e "${GREEN}✅ Environment file created at $DEPLOY_DIR/.env${NC}"

# Set proper permissions
chmod 600 $DEPLOY_DIR/.env

# Check if firewall is active and configure it
if command -v ufw &> /dev/null; then
    echo -e "${YELLOW}🔥 Configuring firewall...${NC}"
    sudo ufw allow 22/tcp    # SSH
    sudo ufw allow 80/tcp    # HTTP
    sudo ufw allow 443/tcp   # HTTPS
    sudo ufw allow 3000/tcp  # Rails app
    echo -e "${GREEN}✅ Firewall rules configured${NC}"
fi

# Display versions
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Installed versions:"
docker --version
docker-compose --version
echo ""
echo -e "${YELLOW}Deployment directory: $DEPLOY_DIR${NC}"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT: You may need to log out and log back in for Docker group permissions to take effect${NC}"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "1. Set up GitHub secrets (see DEPLOYMENT.md)"
echo "2. Push your code to GitHub"
echo "3. The GitHub Action will automatically deploy"
echo ""
echo -e "${GREEN}To manually test Docker:${NC}"
echo "  docker run hello-world"
echo ""
echo -e "${GREEN}To view your environment file:${NC}"
echo "  cat $DEPLOY_DIR/.env"
echo ""
echo -e "${GREEN}🎉 Server is ready for deployment!${NC}"
