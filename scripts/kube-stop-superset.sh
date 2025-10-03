#!/bin/bash

# ===========================================
# Stop Superset Kubernetes Deployment
# ===========================================

set -e

echo "🛑 Stopping Superset Kubernetes Deployment..."

# Stop any port forwarding processes
echo "🔧 Stopping port forwarding processes..."
pkill -f "kubectl port-forward service/superset-service" 2>/dev/null || true

# Delete only the Superset deployments (keeps PostgreSQL and Redis running)
echo "📦 Stopping Superset services..."
kubectl delete deployment superset --ignore-not-found=true
kubectl delete deployment superset-beat --ignore-not-found=true
kubectl delete deployment superset-worker --ignore-not-found=true

# Ask user if they want to stop everything
echo ""
echo "🤔 Do you want to stop PostgreSQL and Redis too? (This will DELETE ALL DATA)"
echo "   y = Stop everything (DELETE DATA)"
echo "   n = Keep PostgreSQL/Redis running (PRESERVE DATA)"
echo ""
read -p "Choice (y/n): " choice

if [[ $choice == "y" || $choice == "Y" ]]; then
    echo "📦 Stopping all services (DELETING DATA)..."
    kubectl delete deployment postgres --ignore-not-found=true
    kubectl delete deployment redis --ignore-not-found=true
    kubectl delete service postgres-service --ignore-not-found=true
    kubectl delete service redis-service --ignore-not-found=true
    kubectl delete service superset-service --ignore-not-found=true
    kubectl delete service superset-service-internal --ignore-not-found=true
    kubectl delete configmap superset-config --ignore-not-found=true
    kubectl delete secret superset-secrets --ignore-not-found=true
    echo "💾 Note: All data has been removed (PostgreSQL, Redis, Superset)"
else
    echo "💾 Note: PostgreSQL and Redis data is preserved"
    echo "   Your dashboards, users, and datasets will remain"
fi

echo ""
echo "✅ Superset has been stopped!"
echo ""
echo "📊 To check status: kubectl get pods"
echo "🔄 To restart: ./scripts/start-superset.sh"
echo ""
echo "💡 For data-preserving stop: ./scripts/stop-superset-preserve-data.sh"
echo ""
