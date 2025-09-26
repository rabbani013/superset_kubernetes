#!/bin/sh
# Simple Celery beat startup script

echo "⏰ Starting Celery beat scheduler..."

# Wait for database and redis
echo "⏳ Waiting for database and redis..."
sleep ${DATABASE_WAIT_TIME}

# Create beat schedule directory and set permissions
echo "🔧 Setting up beat schedule directory..."
BEAT_SCHEDULE_DIR=${BEAT_SCHEDULE_DIR:-/tmp/celery_beat_data}
mkdir -p "$BEAT_SCHEDULE_DIR"
chmod 777 "$BEAT_SCHEDULE_DIR"

# Start Celery beat with custom schedule path
echo "📅 Starting task scheduler..."
celery --app=superset.tasks.celery_app:app beat --schedule="$BEAT_SCHEDULE_DIR/celerybeat-schedule"