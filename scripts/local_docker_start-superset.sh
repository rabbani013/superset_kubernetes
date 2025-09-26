#!/bin/bash

# ===========================================
# Start Superset Local Docker Deployment
# ===========================================

set -e

echo "🚀 Starting Superset Local Docker Deployment..."

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Set Docker environment
echo "🔧 Setting up Docker environment..."

# Build the Docker image
echo "🏗️  Building Superset Docker image..."
docker build -f Dockerfile.superset -t superset-k8s:latest .

# Create Docker network for local setup
echo "🌐 Creating Docker network..."
docker network create superset-local 2>/dev/null || true

# Stop any existing containers with the same names
echo "🧹 Cleaning up any existing containers..."
docker stop superset-postgres-local superset-redis-local superset-web-local 2>/dev/null || true
docker rm superset-postgres-local superset-redis-local superset-web-local 2>/dev/null || true

# Start PostgreSQL
echo "🐘 Starting PostgreSQL..."
docker run -d \
    --name superset-postgres-local \
    --network superset-local \
    -e POSTGRES_USER=superset \
    -e POSTGRES_PASSWORD=superset \
    -e POSTGRES_DB=superset \
    -v superset-postgres-data:/var/lib/postgresql/data \
    postgres:13

# Start Redis
echo "🔴 Starting Redis..."
docker run -d \
    --name superset-redis-local \
    --network superset-local \
    redis:6

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Start Superset
echo "📊 Starting Superset..."
docker run -d \
    --name superset-web-local \
    --network superset-local \
    -p 8088:8088 \
    -e POSTGRES_USER=superset \
    -e POSTGRES_PASSWORD=superset \
    -e POSTGRES_DB=superset \
    -e POSTGRES_HOST=superset-postgres-local \
    -e POSTGRES_PORT=5432 \
    -e REDIS_HOST=superset-redis-local \
    -e REDIS_PORT=6379 \
    -e REDIS_PASSWORD= \
    -e SUPERSET_PORT=8088 \
    -e SUPERSET_EXTERNAL_PORT=8088 \
    -e SUPERSET_CONTAINER_NAME=superset_web \
    -e SUPERSET_SECRET_KEY=F4Y58kW6frSGa9DfvzKej/xsdQz5nzdkC8CyqKI0CIXXasV3SuUQnSvJ \
    -e SUPERSET_CONFIG_PATH=/app/pythonpath/superset_config.py \
    -v $(pwd)/config/superset_config_local.py:/app/pythonpath/superset_config.py \
    -e SMTP_HOST=smtp.gmail.com \
    -e SMTP_PORT=587 \
    -e SMTP_USER=raabbaani@gmail.com \
    -e SMTP_PASSWORD=czpsoustkkvbwnfg \
    -e SMTP_MAIL_FROM=raabbaani@gmail.com \
    -e ADMIN_USERNAME=admin \
    -e ADMIN_FIRSTNAME=Admin \
    -e ADMIN_LASTNAME=User \
    -e ADMIN_EMAIL=admin@example.com \
    -e ADMIN_PASSWORD=admin \
    -e INIT_MODE=fresh \
    superset-k8s:latest

# Wait for Superset to be ready
echo "⏳ Waiting for Superset to be ready..."
sleep 30

# Check if Superset is running
if docker ps | grep -q superset-web-local; then
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
    echo "   • Check status: docker ps"
    echo "   • View logs: docker logs superset-web-local"
    echo "   • Stop Superset: ./scripts/local_docker_stop-superset-preserve-data.sh"
    echo ""
    echo "💡 Tip: Your data will be preserved in Docker volumes!"
    echo ""
else
    echo "❌ Failed to start Superset. Check logs with: docker logs superset-web-local"
    exit 1
fi
