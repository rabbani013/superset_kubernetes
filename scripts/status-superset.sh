#!/bin/bash

# ===========================================
# Check Superset Kubernetes Status
# ===========================================

echo "📊 Superset Kubernetes Status"
echo "================================"

# Check minikube status
echo "🔧 Minikube Status:"
minikube status

echo ""
echo "📦 Kubernetes Pods:"
kubectl get pods

echo ""
echo "🌐 Services:"
kubectl get services

echo ""
echo "🔗 Superset Access:"
if kubectl get deployment superset >/dev/null 2>&1; then
    # Check if port forwarding is already running
    if curl -s --connect-timeout 2 "http://localhost:8080" > /dev/null 2>&1; then
        SUPERSET_URL="http://localhost:8080"
    else
        SUPERSET_URL=$(timeout 5 minikube service superset-service --url 2>/dev/null || echo "Service not available")
    fi
    echo ""
    echo "   🌐 ACCESS URL: $SUPERSET_URL"
    echo "   👤 Username: admin"
    echo "   🔑 Password: admin"
    echo ""
    echo "   💡 Copy this URL to your browser: $SUPERSET_URL"
else
    echo "   ❌ Superset is not running"
fi

echo ""
echo "📝 Recent Logs:"
if kubectl get deployment superset >/dev/null 2>&1; then
    kubectl logs deployment/superset --tail=10
else
    echo "   No Superset logs available"
fi

echo ""
