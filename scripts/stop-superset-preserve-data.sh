#!/bin/bash

# ===========================================
# Stop Superset (Preserve Data)
# ===========================================

set -e

echo "🛑 Stopping Superset (Preserving Data)..."

# Stop any port forwarding processes
echo "🔧 Stopping port forwarding processes..."
pkill -f "kubectl port-forward service/superset-service" 2>/dev/null || true

# Delete only the Superset deployments (keeps PostgreSQL and Redis running)
echo "📦 Stopping Superset services..."
kubectl delete deployment superset --ignore-not-found=true
kubectl delete deployment superset-beat --ignore-not-found=true
kubectl delete deployment superset-worker --ignore-not-found=true

echo ""
echo "✅ Superset has been stopped (data preserved)!"
echo ""
echo "📊 To check status: kubectl get pods"
echo "🔄 To restart: ./scripts/start-superset.sh"
echo ""
echo "💾 Note: PostgreSQL and Redis data is preserved"
echo "   Your dashboards, users, and datasets will remain"
echo ""
echo "🗑️  To completely remove data: ./scripts/stop-superset.sh"
echo ""
