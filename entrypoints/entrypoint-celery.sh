#!/bin/sh
# Simple Celery worker startup script

echo "👷 Starting Celery worker..."

# Wait for database and redis
echo "⏳ Waiting for database and redis..."
DATABASE_WAIT_TIME=${DATABASE_WAIT_TIME:-20}
sleep $DATABASE_WAIT_TIME

# Start Celery worker
echo "🔄 Starting background worker..."
exec celery --app=superset.tasks.celery_app:app worker --pool=${WORKER_POOL:-solo} -O${WORKER_OPTIMIZATION:-fair}