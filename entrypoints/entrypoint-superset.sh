#!/bin/sh
# Simple Superset startup script

echo "🚀 Starting Superset..."

# Wait for database and redis to be ready
echo "⏳ Waiting for database..."
sleep 15

# Always upgrade database (safe to run)
echo "📊 Setting up database..."
superset db upgrade

# Check what mode we're in
if [ "$INIT_MODE" = "fresh" ]; then
    echo "🆕 Fresh mode: Creating new admin user..."
    superset fab create-admin --username ${ADMIN_USERNAME} --firstname ${ADMIN_FIRSTNAME} --lastname ${ADMIN_LASTNAME} --email ${ADMIN_EMAIL} --password ${ADMIN_PASSWORD}
    superset init
elif [ "$INIT_MODE" = "preserve" ]; then
    echo "💾 Preserve mode: Keeping existing data..."
    # Check if admin user exists, create if not
    if ! superset fab list-users | grep -q "${ADMIN_USERNAME}"; then
        echo "👤 Creating admin user..."
        superset fab create-admin --username ${ADMIN_USERNAME} --firstname ${ADMIN_FIRSTNAME} --lastname ${ADMIN_LASTNAME} --email ${ADMIN_EMAIL} --password ${ADMIN_PASSWORD}
    fi
    superset init
else
    echo "🔍 Auto mode: Checking if setup needed..."
    # Check if any users exist
    if ! superset fab list-users | grep -q "User"; then
        echo "👤 No users found, creating admin..."
        superset fab create-admin --username ${ADMIN_USERNAME} --firstname ${ADMIN_FIRSTNAME} --lastname ${ADMIN_LASTNAME} --email ${ADMIN_EMAIL} --password ${ADMIN_PASSWORD}
        superset init
    else
        echo "✅ Users found, keeping existing data..."
        superset init
    fi
fi

# Start Superset web server
echo "🌐 Starting Superset web server..."
superset run -h 0.0.0.0 -p ${SUPERSET_PORT} --with-threads --reload --debugger