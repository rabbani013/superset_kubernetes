#!/bin/bash

# ===========================================
# Superset Kubernetes Management Menu
# ===========================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display menu
show_menu() {
    echo ""
    echo -e "${BLUE}🚀 Superset Kubernetes Management${NC}"
    echo "=================================="
    echo ""
    echo "1) 🚀 Start Superset"
    echo "2) 🛑 Stop Superset"
    echo "3) 🔄 Restart Superset"
    echo "4) 📊 Check Status"
    echo "5) 📝 View Logs"
    echo "6) 🌐 Get Access URL"
    echo "7) 🧹 Clean Everything (WARNING: Deletes all data)"
    echo "8) ❌ Exit"
    echo ""
    echo -n "Please select an option (1-8): "
}

# Function to get access URL
get_access_url() {
    echo ""
    echo -e "${GREEN}🌐 Superset Access Information${NC}"
    echo "================================"
    
    if kubectl get deployment superset >/dev/null 2>&1; then
        # Check if port forwarding is already running
        if curl -s --connect-timeout 2 "http://localhost:8080" > /dev/null 2>&1; then
            SUPERSET_URL="http://localhost:8080"
        else
            SUPERSET_URL=$(timeout 5 minikube service superset-service --url 2>/dev/null || echo "Service not available")
        fi
        echo -e "${GREEN}✅ Superset is running!${NC}"
        echo ""
        echo "🌐 ACCESS URL: $SUPERSET_URL"
        echo "👤 Username: admin"
        echo "🔑 Password: admin"
        echo ""
        echo "💡 Copy this URL to your browser: $SUPERSET_URL"
    else
        echo -e "${RED}❌ Superset is not running${NC}"
        echo "💡 Run option 1 to start Superset"
    fi
    echo ""
}

# Function to clean everything
clean_everything() {
    echo ""
    echo -e "${RED}⚠️  WARNING: This will delete ALL data!${NC}"
    echo "This includes:"
    echo "- All user accounts"
    echo "- All dashboards and charts"
    echo "- All database connections"
    echo "- All configuration"
    echo ""
    echo -n "Are you sure you want to continue? (yes/no): "
    read -r confirm
    
    if [[ $confirm == "yes" ]]; then
        echo "🧹 Cleaning everything..."
        kubectl delete deployment superset --ignore-not-found=true
        kubectl delete deployment postgres --ignore-not-found=true
        kubectl delete deployment redis --ignore-not-found=true
        kubectl delete service postgres-service --ignore-not-found=true
        kubectl delete service redis-service --ignore-not-found=true
        kubectl delete service superset-service --ignore-not-found=true
        kubectl delete service superset-service-internal --ignore-not-found=true
        kubectl delete configmap superset-config --ignore-not-found=true
        kubectl delete secret superset-secrets --ignore-not-found=true
        echo -e "${GREEN}✅ Everything has been cleaned!${NC}"
    else
        echo "❌ Cleanup cancelled"
    fi
    echo ""
}

# Main menu loop
while true; do
    show_menu
    read -r choice
    
    case $choice in
        1)
            echo ""
            echo -e "${GREEN}🚀 Starting Superset...${NC}"
            ./scripts/start-superset.sh
            ;;
        2)
            echo ""
            echo -e "${YELLOW}🛑 Stopping Superset...${NC}"
            ./scripts/stop-superset.sh
            ;;
        3)
            echo ""
            echo -e "${BLUE}🔄 Restarting Superset...${NC}"
            ./scripts/restart-superset.sh
            ;;
        4)
            echo ""
            echo -e "${BLUE}📊 Checking Status...${NC}"
            ./scripts/status-superset.sh
            ;;
        5)
            echo ""
            echo -e "${BLUE}📝 Viewing Logs...${NC}"
            ./scripts/logs-superset.sh
            ;;
        6)
            get_access_url
            ;;
        7)
            clean_everything
            ;;
        8)
            echo ""
            echo -e "${GREEN}👋 Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo ""
            echo -e "${RED}❌ Invalid option. Please select 1-8.${NC}"
            ;;
    esac
    
    echo ""
    echo -n "Press Enter to continue..."
    read -r
done
