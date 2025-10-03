#!/bin/bash

# ===========================================
# Start Superset Local Docker Compose Deployment
# ===========================================

set -e

echo "🚀 Starting Superset Local Docker Compose Deployment..."

# Build the Docker image first
echo "🏗️  Building Superset Docker image..."
docker build -f Dockerfile.superset -t superset-k8s:latest .

# Start the services
echo "📦 Starting services with Docker Compose..."
docker-compose -f docker-compose-local.yml -p superset-local up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check if services are running
if docker-compose -f docker-compose-local.yml -p superset-local ps | grep -q "Up"; then
    echo ""
    echo "✅ Superset is now running locally!"
    echo ""
    echo "🔗 ACCESS URL: http://localhost:8088"
    echo ""
    echo "📋 Login Credentials:"
    echo "   Username: admin"
    echo "   Password: admin"
    echo ""
    echo "🚀 Quick Actions:"
    echo "   • Open in browser: http://localhost:8088"
    echo "   • Check status: docker-compose -f docker-compose-local.yml -p superset-local ps"
    echo "   • View logs: docker-compose -f docker-compose-local.yml -p superset-local logs"
    echo "   • Stop Superset: ./scripts/local_docker_compose_stop.sh"
    echo ""
    echo "💡 Tip: Your data will be preserved in Docker volumes!"
    echo ""
    echo "📊 Container Structure:"
    echo "   superset-local/"
    echo "   ├── superset-postgres"
    echo "   ├── superset-redis"
    echo "   └── superset-web"
    echo ""
else
    echo "❌ Failed to start services. Check logs with: docker-compose -f docker-compose-local.yml -p superset-local logs"
    exit 1
fi
