#!/bin/bash

# ===========================================
# Start Superset Kubernetes Deployment
# ===========================================

set -e

echo "🚀 Starting Superset Kubernetes Deployment..."

# Check if minikube is running
if ! minikube status >/dev/null 2>&1; then
    echo "❌ Minikube is not running. Starting minikube..."
    minikube start
fi

# Set Docker environment to use minikube's Docker daemon
echo "🔧 Setting up Docker environment for minikube..."
eval $(minikube docker-env)

# Build the Docker image
echo "🏗️  Building Superset Docker image..."
docker build -f Dockerfile.superset -t superset-k8s:latest .

# Apply Kubernetes configuration
echo "📦 Deploying to Kubernetes..."
kubectl apply -f k8s/deploy-all.yml

# Wait for deployments to be ready
echo "⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/postgres
kubectl wait --for=condition=available --timeout=300s deployment/redis
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
    echo "💡 This URL is stable and won't change!"
    echo "🔧 Port forwarding PID: $PORT_FORWARD_PID"
else
    # Fallback to tunnel
    echo "⚠️  Port forwarding failed, trying tunnel..."
    SUPERSET_URL=$(timeout 10 minikube service superset-service --url 2>/dev/null | head -1)
    if [ -z "$SUPERSET_URL" ]; then
        SUPERSET_URL="http://localhost:8080"
        echo "⚠️  Using fallback URL: $SUPERSET_URL"
        echo "💡 You may need to run: kubectl port-forward service/superset-service 8080:8088"
    else
        echo "✅ Got tunnel URL: $SUPERSET_URL"
        echo "⚠️  Note: This URL will change on each restart"
    fi
fi

echo ""
echo "✅ Superset is now running!"
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
echo "   • Stop Superset: ./scripts/stop-superset.sh"
echo ""
echo "💡 Tip: Bookmark this URL for easy access!"
echo ""
