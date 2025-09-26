#!/bin/bash

# ===========================================
# Restart Superset Kubernetes Deployment
# ===========================================

set -e

echo "🔄 Restarting Superset Kubernetes Deployment..."

# Stop Superset
echo "🛑 Stopping Superset..."
kubectl delete deployment superset --ignore-not-found=true

# Wait a moment
echo "⏳ Waiting for shutdown..."
sleep 5

# Start Superset
echo "🚀 Starting Superset..."
kubectl apply -f k8s/deploy-all.yml

# Wait for deployment to be ready
echo "⏳ Waiting for Superset to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/superset

# Get the service URL
echo "🌐 Getting Superset service URL..."

# Use port forwarding for stable access
echo "🔧 Setting up port forwarding..."
kubectl port-forward service/superset-service 8080:8088 > /dev/null 2>&1 &
PORT_FORWARD_PID=$!
sleep 3

# Test if port forwarding works
if curl -s --connect-timeout 3 "http://localhost:8080" > /dev/null 2>&1; then
    SUPERSET_URL="http://localhost:8080"
    echo "✅ Using port forwarding URL: $SUPERSET_URL"
else
    SUPERSET_URL=$(timeout 10 minikube service superset-service --url 2>/dev/null || echo "http://localhost:8080")
fi

echo ""
echo "✅ Superset has been restarted!"
echo ""
echo "🔗 ACCESS URL: $SUPERSET_URL"
echo ""
echo "📋 Login Credentials:"
echo "   Username: admin"
echo "   Password: admin"
echo ""
echo "🚀 Quick Actions:"
echo "   • Open in browser: $SUPERSET_URL"
echo "   • Check status: ./scripts/status-superset.sh"
echo "   • View logs: ./scripts/logs-superset.sh"
echo ""
