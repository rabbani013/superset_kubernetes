# 🚀 Simple Superset Setup

A beginner-friendly Apache Superset setup with email notifications.

## 📁 What's in this folder?

```
superset/
├── 📁 config/          # Settings and configuration
├── 📁 scripts/          # Easy-to-use scripts
├── 📁 docs/            # Help and guides
├── 📁 data/            # Your data (hidden)
└── 📁 test/            # Test files
```

## 🚀 Quick Start

### 1. First Time Setup
```bash
# Setup email (optional)
./scripts/configure-smtp.sh

# Start Superset
./scripts/start-preserve.sh
```

### 2. Open Superset
- **URL**: http://localhost:8080
- **Login**: admin / admin

## 📧 Email Setup (Optional)

If you want email notifications:

```bash
./scripts/configure-smtp.sh
```

**For Gmail:**
- Use your Gmail address
- Use an "App Password" (not your regular password)
- Get App Password: Google Account → Security → 2-Step Verification → App passwords

## 🛠️ Scripts Explained

| Script | What it does |
|--------|-------------|
| `start-preserve.sh` | Start Superset (keeps your data) |
| `start-fresh.sh` | Start fresh (deletes everything) |
| `start-auto.sh` | Start (auto-detects what to do) |
| `stop-superset.sh` | Stop Superset |
| `configure-smtp.sh` | Setup email |

## 🔧 Configuration

All settings are in the `.env` file:
- **Ports**: Change SUPERSET_EXTERNAL_PORT to use different port
- **Email**: SMTP settings for notifications
- **Database**: PostgreSQL settings

## 📚 Features

- ✅ **Easy Setup** - Just run one script
- ✅ **Email Notifications** - Welcome emails, reports
- ✅ **Data Safety** - Your data is preserved
- ✅ **Multiple Instances** - Run multiple Superset instances
- ✅ **Beginner Friendly** - Simple scripts and clear documentation

## 🆘 Troubleshooting

**Can't access Superset?**
- Check if containers are running: `docker ps`
- Try: `./scripts/stop-superset.sh` then `./scripts/start-preserve.sh`

**Email not working?**
- Check your SMTP settings in `.env`
- For Gmail, use App Password, not regular password

**Need help?**
- Check the `docs/` folder for detailed guides
- All scripts have simple comments explaining what they do

---

**🎯 Goal**: Make Superset easy to use for beginners while keeping all the powerful features!