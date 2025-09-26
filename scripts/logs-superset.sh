#!/bin/bash

# ===========================================
# View Superset Logs
# ===========================================

echo "📝 Superset Logs"
echo "================="

if kubectl get deployment superset >/dev/null 2>&1; then
    echo "🔍 Following Superset logs (Press Ctrl+C to stop)..."
    echo ""
    kubectl logs -f deployment/superset
else
    echo "❌ Superset deployment not found"
    echo "💡 Run './scripts/start-superset.sh' to start Superset"
    exit 1
fi
