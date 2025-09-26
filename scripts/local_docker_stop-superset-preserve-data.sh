#!/bin/bash

# ===========================================
# Stop Superset Local Docker Deployment (Preserve Data)
# ===========================================

set -e

echo "🛑 Stopping Superset Local Docker Deployment (preserving data)..."

# Stop Superset container
echo "📦 Stopping Superset container..."
if docker ps | grep -q superset-web-local; then
    docker stop superset-web-local
    docker rm superset-web-local
    echo "✅ Superset container stopped and removed"
else
    echo "⚠️  Superset container not running"
fi

# Stop Redis container
echo "🔴 Stopping Redis container..."
if docker ps | grep -q superset-redis-local; then
    docker stop superset-redis-local
    docker rm superset-redis-local
    echo "✅ Redis container stopped and removed"
else
    echo "⚠️  Redis container not running"
fi

# Stop PostgreSQL container
echo "🐘 Stopping PostgreSQL container..."
if docker ps | grep -q superset-postgres-local; then
    docker stop superset-postgres-local
    docker rm superset-postgres-local
    echo "✅ PostgreSQL container stopped and removed"
else
    echo "⚠️  PostgreSQL container not running"
fi

# Clean up network (optional)
echo "🌐 Cleaning up Docker network..."
docker network rm superset-local 2>/dev/null || true

echo ""
echo "✅ Superset has been stopped (data preserved)!"
echo ""
echo "📊 To check status: docker ps"
echo "🔄 To restart: ./scripts/local_docker_start-superset.sh"
echo ""
echo "💾 Note: PostgreSQL data is preserved in Docker volume 'superset-postgres-data'"
echo "   Your dashboards, users, and datasets will remain."
echo ""
echo "🗑️  To delete all data: docker volume rm superset-postgres-data"
echo ""
