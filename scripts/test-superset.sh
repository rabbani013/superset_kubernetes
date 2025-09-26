#!/bin/bash

# ===========================================
# Test Superset Deployment
# ===========================================

set -e

echo "🧪 Testing Superset Deployment"
echo "=============================="

# Check if Superset is running
if ! kubectl get deployment superset >/dev/null 2>&1; then
    echo "❌ Superset is not running"
    echo "💡 Run './scripts/start-superset.sh' to start Superset"
    exit 1
fi

# Check pod status
echo "📦 Checking pod status..."
kubectl get pods | grep superset

# Check if pod is ready
if kubectl get pods | grep superset | grep -q "1/1.*Running"; then
    echo "✅ Superset pod is running"
else
    echo "❌ Superset pod is not ready"
    echo "📝 Check logs with: ./scripts/logs-superset.sh"
    exit 1
fi

# Check services
echo ""
echo "🌐 Checking services..."
kubectl get services | grep superset

# Test health endpoint
echo ""
echo "🏥 Testing health endpoint..."
if kubectl get pods | grep superset | grep -q "1/1.*Running"; then
    POD_NAME=$(kubectl get pods | grep superset | grep "1/1.*Running" | awk '{print $1}')
    if kubectl exec $POD_NAME -- curl -s http://localhost:8088/health >/dev/null 2>&1; then
        echo "✅ Health check passed"
    else
        echo "⚠️  Health check failed (this might be normal during startup)"
    fi
fi

# Get access URL
echo ""
echo "🔗 Getting access URL..."
# Check if port forwarding is already running
if curl -s --connect-timeout 2 "http://localhost:8080" > /dev/null 2>&1; then
    SUPERSET_URL="http://localhost:8080"
else
    SUPERSET_URL=$(timeout 5 minikube service superset-service --url 2>/dev/null || echo "Service not available")
fi

if [[ $SUPERSET_URL != "Service not available" ]]; then
    echo ""
    echo "✅ Superset is accessible!"
    echo ""
    echo "🌐 ACCESS URL: $SUPERSET_URL"
    echo "👤 Username: admin"
    echo "🔑 Password: admin"
    echo ""
    echo "💡 Copy this URL to your browser: $SUPERSET_URL"
else
    echo "❌ Could not get access URL"
fi

echo ""
echo "🎉 Test completed!"
echo ""
echo "📋 Next steps:"
echo "   - Access Superset: $SUPERSET_URL"
echo "   - Login with admin/admin"
echo "   - Check logs: ./scripts/logs-superset.sh"
echo "   - Check status: ./scripts/status-superset.sh"
echo ""
