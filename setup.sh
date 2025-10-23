#!/bin/bash
# Quick Setup Script for Chat App
# Run this script to set up the project: chmod +x setup.sh && ./setup.sh

echo "🚀 Setting up Chat App..."
echo ""

# Check for Ruby
if ! command -v ruby &> /dev/null; then
    echo "❌ Ruby is not installed. Please install Ruby 3.4.7 or higher."
    exit 1
fi

echo "✓ Ruby $(ruby -v | awk '{print $2}')"

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18 or higher."
    exit 1
fi

echo "✓ Node.js $(node -v)"

# Check for Yarn
if ! command -v yarn &> /dev/null; then
    echo "⚠️  Yarn not found. Installing Yarn..."
    npm install -g yarn
fi

echo "✓ Yarn $(yarn -v)"

# Install Ruby dependencies
echo ""
echo "📦 Installing Ruby gems..."
bundle install

# Install JavaScript dependencies
echo ""
echo "📦 Installing JavaScript packages..."
yarn install

# Setup database
echo ""
echo "🗄️  Setting up database..."
if [ ! -f .env ]; then
    echo "⚠️  No .env file found. Please create one with your DATABASE_URL"
    echo "Example:"
    echo "DATABASE_URL=postgresql://user:password@host/database?sslmode=require"
else
    bin/rails db:create db:migrate
fi

# Build assets
echo ""
echo "🎨 Building assets..."
yarn build
yarn build:css

echo ""
echo "✅ Setup complete!"
echo ""
echo "🎯 To start the development server, run:"
echo "   bin/dev"
echo ""
echo "🌐 Then open http://localhost:3000 in your browser"
echo ""
