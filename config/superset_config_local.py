import os

# ===========================================
# SUPERSET CONFIGURATION FOR LOCAL DOCKER
# ===========================================

# Database Settings (PostgreSQL)
POSTGRES_USER = os.getenv("POSTGRES_USER", "superset")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "superset")
POSTGRES_HOST = os.getenv("POSTGRES_HOST", "postgres")
POSTGRES_DB = os.getenv("POSTGRES_DB", "superset")
POSTGRES_PORT = int(os.getenv("POSTGRES_PORT", "5432"))

# Connect to database
SQLALCHEMY_DATABASE_URI = f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}"

# Redis Settings
REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))
REDIS_PASSWORD = os.getenv("REDIS_PASSWORD", "")

# Superset Settings
SUPERSET_PORT = int(os.getenv("SUPERSET_PORT", "8088"))
SUPERSET_EXTERNAL_PORT = int(os.getenv("SUPERSET_EXTERNAL_PORT", "8088"))

# Email Settings
SMTP_HOST = os.getenv("SMTP_HOST", "smtp.gmail.com")
SMTP_PORT = int(os.getenv("SMTP_PORT", "587"))
SMTP_USER = os.getenv("SMTP_USER")
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD")
SMTP_MAIL_FROM = os.getenv("SMTP_MAIL_FROM")

# App Settings
APP_NAME = "Superset Analytics"
SECRET_KEY = os.getenv("SUPERSET_SECRET_KEY", "F4Y58kW6frSGa9DfvzKej/xsdQz5nzdkC8CyqKI0CIXXasV3SuUQnSvJ")

# Enable features
FEATURE_FLAGS = {
    "ENABLE_PASSWORD_RESET": True,
    "ALERT_REPORTS": True,
    "ALERTS_ATTACH_REPORTS": True,
    "SCHEDULED_EMAIL_REPORTS": True,
    "DASHBOARD_NATIVE_FILTERS": True,
    "DASHBOARD_CROSS_FILTERS": True,
    "DASHBOARD_RBAC": True,
}

# Email URL for reports
WEBDRIVER_BASEURL = f"http://{os.getenv('SUPERSET_CONTAINER_NAME', 'superset_web')}:{os.getenv('SUPERSET_PORT')}"
WEBDRIVER_BASEURL_USER_FRIENDLY = f"http://localhost:{os.getenv('SUPERSET_EXTERNAL_PORT')}"

# ===========================================
# NO EMAIL FUNCTIONALITY FOR LOCAL DOCKER
# ===========================================

# Local Docker setup doesn't need email functionality
# Email is only enabled in Kubernetes deployment
