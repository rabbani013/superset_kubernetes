# Superset Kubernetes Management Scripts

This directory contains scripts to manage your Superset Kubernetes deployment.

## 📋 Available Scripts

### 🚀 `start-superset.sh`
Starts the complete Superset deployment including:
- Checks and starts minikube if needed
- Builds the Docker image
- Deploys all Kubernetes resources
- Waits for services to be ready
- Provides access URL and credentials

**Usage:**
```bash
./scripts/start-superset.sh
```

### 🛑 `stop-superset.sh`
Stops the Superset deployment while preserving data:
- Stops Superset services
- Keeps PostgreSQL data intact
- Optionally stops all services (commented out)

**Usage:**
```bash
./scripts/stop-superset.sh
```

### 🔄 `restart-superset.sh`
Restarts the Superset deployment:
- Stops Superset
- Waits for shutdown
- Starts Superset again
- Provides access URL

**Usage:**
```bash
./scripts/restart-superset.sh
```

### 📊 `status-superset.sh`
Shows the current status of your deployment:
- Minikube status
- Kubernetes pods status
- Services status
- Access URL and credentials
- Recent logs

**Usage:**
```bash
./scripts/status-superset.sh
```

### 📝 `logs-superset.sh`
Follows Superset logs in real-time:
- Shows live logs from Superset
- Press Ctrl+C to stop following

**Usage:**
```bash
./scripts/logs-superset.sh
```

## 🎯 Quick Start

1. **Start Superset:**
   ```bash
   ./scripts/start-superset.sh
   ```

2. **Check Status:**
   ```bash
   ./scripts/status-superset.sh
   ```

3. **View Logs:**
   ```bash
   ./scripts/logs-superset.sh
   ```

4. **Stop Superset:**
   ```bash
   ./scripts/stop-superset.sh
   ```

## 🔧 Prerequisites

- **minikube** installed and running
- **kubectl** installed
- **Docker** installed
- **Bash** shell

## 📊 Access Information

After starting Superset, you'll get:
- **URL**: Provided by the start script
- **Username**: `admin`
- **Password**: `admin`

## 💾 Data Persistence

- **PostgreSQL data** is preserved between restarts
- **User accounts, dashboards, and charts** are maintained
- **Configuration** is stored in Kubernetes ConfigMaps and Secrets

## 🚨 Troubleshooting

- **Check status**: `./scripts/status-superset.sh`
- **View logs**: `./scripts/logs-superset.sh`
- **Restart**: `./scripts/restart-superset.sh`

## 📁 File Structure

```
scripts/
├── start-superset.sh      # Start deployment
├── stop-superset.sh       # Stop deployment
├── restart-superset.sh    # Restart deployment
├── status-superset.sh     # Check status
├── logs-superset.sh       # View logs
└── README.md             # This file
```
