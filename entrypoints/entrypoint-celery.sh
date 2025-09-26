#!/bin/sh
# Simple Celery worker startup script

echo "👷 Starting Celery worker..."

# Wait for database and redis
echo "⏳ Waiting for database and redis..."
sleep 20

# Start Celery worker
echo "🔄 Starting background worker..."
celery --app=superset.tasks.celery_app:app worker --pool=${WORKER_POOL:-solo} -O${WORKER_OPTIMIZATION:-fair}