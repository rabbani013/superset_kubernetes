#!/bin/bash

# ===========================================
# Stop Superset Local Docker Compose Deployment
# ===========================================

set -e

echo "🛑 Stopping Superset Local Docker Compose Deployment..."

# Stop and remove containers
echo "📦 Stopping services..."
docker-compose -f docker-compose-local.yml -p superset-local down

echo ""
echo "✅ Superset has been stopped (data preserved)!"
echo ""
echo "📊 To check status: docker-compose -f docker-compose-local.yml -p superset-local ps"
echo "🔄 To restart: ./scripts/local_docker_compose_start.sh"
echo ""
echo "💾 Note: PostgreSQL data is preserved in Docker volume 'superset-postgres-data'"
echo "   Your dashboards, users, and datasets will remain."
echo ""
echo "🗑️  To delete all data: docker volume rm superset_kub_test_superset-postgres-data"
echo ""
