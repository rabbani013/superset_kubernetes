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
# WELCOME EMAIL FUNCTIONALITY
# ===========================================

# Import security manager
try:
    from superset.security import SupersetSecurityManager
except ImportError:
    from flask_appbuilder.security.sqla.manager import SecurityManager as SupersetSecurityManager

# Custom Security Manager to send Welcome Email
class CustomSecurityManager(SupersetSecurityManager):
    def __init__(self, appbuilder):
        print("🔧 CustomSecurityManager initialized!")
        super().__init__(appbuilder)
        
    def add_user(self, username, first_name, last_name, email, role, password="", hashed_password=""):
        print(f"🎯 Creating user via add_user: {username} ({email})")
        user = super().add_user(username, first_name, last_name, email, role, password, hashed_password)
        
        if user and email:
            self._send_welcome_email(user, first_name, last_name, username)
        
        return user
        
    def register_user(self, user):
        print(f"🎯 Registering user via register_user: {user.username} ({user.email})")
        result = super().register_user(user)
        
        if user and hasattr(user, 'email') and user.email:
            self._send_welcome_email(user, getattr(user, 'first_name', ''), getattr(user, 'last_name', ''), user.username)
        
        return result
        
    def _send_welcome_email(self, user, first_name, last_name, username):
        """Send welcome email to user"""
        try:
            print(f"🎯 Sending welcome email to {user.email}")
            
            # Send welcome email using direct SMTP
            import smtplib
            from email.mime.text import MIMEText
            from email.mime.multipart import MIMEMultipart
            from flask import current_app
            
            # Get SMTP configuration
            smtp_host = current_app.config.get('SMTP_HOST', 'smtp.gmail.com')
            smtp_port = current_app.config.get('SMTP_PORT', 587)
            smtp_user = current_app.config.get('SMTP_USER')
            smtp_password = current_app.config.get('SMTP_PASSWORD')
            smtp_mail_from = current_app.config.get('SMTP_MAIL_FROM')
            
            if smtp_user and smtp_password and smtp_mail_from:
                # Create SMTP connection
                server = smtplib.SMTP(smtp_host, smtp_port)
                server.starttls()
                server.login(smtp_user, smtp_password)
                
                # Create email message
                msg = MIMEMultipart()
                msg['From'] = smtp_mail_from
                msg['To'] = user.email
                msg['Subject'] = f"Welcome to {APP_NAME}"
                
                # HTML content
                html_content = f"""
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h2 style="color: #1f4e79;">Welcome to {APP_NAME}!</h2>
                    <p>Hello {first_name or 'User'},</p>
                    <p>Your Superset account has been created successfully.</p>
                    <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;">
                        <p><strong>Username:</strong> {username}</p>
                        <p><strong>Login URL:</strong> <a href="{WEBDRIVER_BASEURL_USER_FRIENDLY}" style="color: #1f4e79;">{WEBDRIVER_BASEURL_USER_FRIENDLY}</a></p>
                    </div>
                    <p>You can now access your analytics dashboard and start creating reports.</p>
                    <p>If you have any questions, please contact your administrator.</p>
                    <hr style="margin: 30px 0; border: none; border-top: 1px solid #eee;">
                    <p style="color: #666; font-size: 12px;">This is an automated message from {APP_NAME}</p>
                </div>
                """
                
                msg.attach(MIMEText(html_content, 'html'))
                
                # Send email
                server.send_message(msg)
                server.quit()
                print(f"✅ Welcome email sent to {user.email}")
            else:
                print("❌ SMTP configuration missing")
        except Exception as e:
            print(f"❌ Failed to send welcome email to {user.email}: {e}")

# Use our custom security manager
CUSTOM_SECURITY_MANAGER = CustomSecurityManager

# SQLAlchemy event approach for user creation
def register_sqlalchemy_events():
    """Register SQLAlchemy events for user creation"""
    try:
        from flask_appbuilder.security.sqla.models import User
        from sqlalchemy import event
        
        @event.listens_for(User, 'after_insert')
        def user_created(mapper, connection, target):
            """Triggered when a new user is inserted into the database"""
            try:
                print(f"🎯 SQLAlchemy event: User created - {target.username} ({target.email})")
                
                if target.email:
                    # Send welcome email using direct SMTP
                    import smtplib
                    from email.mime.text import MIMEText
                    from email.mime.multipart import MIMEMultipart
                    from flask import current_app
                    
                    # Get SMTP configuration
                    smtp_host = current_app.config.get('SMTP_HOST', 'smtp.gmail.com')
                    smtp_port = current_app.config.get('SMTP_PORT', 587)
                    smtp_user = current_app.config.get('SMTP_USER')
                    smtp_password = current_app.config.get('SMTP_PASSWORD')
                    smtp_mail_from = current_app.config.get('SMTP_MAIL_FROM')
                    
                    if smtp_user and smtp_password and smtp_mail_from:
                        # Create SMTP connection
                        server = smtplib.SMTP(smtp_host, smtp_port)
                        server.starttls()
                        server.login(smtp_user, smtp_password)
                        
                        # Create email message
                        msg = MIMEMultipart()
                        msg['From'] = smtp_mail_from
                        msg['To'] = target.email
                        msg['Subject'] = f"Welcome to {APP_NAME}"
                        
                        # HTML content
                        html_content = f"""
                        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                            <h2 style="color: #1f4e79;">Welcome to {APP_NAME}!</h2>
                            <p>Hello {getattr(target, 'first_name', 'User')},</p>
                            <p>Your Superset account has been created successfully.</p>
                            <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;">
                                <p><strong>Username:</strong> {target.username}</p>
                                <p><strong>Login URL:</strong> <a href="{WEBDRIVER_BASEURL_USER_FRIENDLY}" style="color: #1f4e79;">{WEBDRIVER_BASEURL_USER_FRIENDLY}</a></p>
                            </div>
                            <p>You can now access your analytics dashboard and start creating reports.</p>
                            <p>If you have any questions, please contact your administrator.</p>
                            <hr style="margin: 30px 0; border: none; border-top: 1px solid #eee;">
                            <p style="color: #666; font-size: 12px;">This is an automated message from {APP_NAME}</p>
                        </div>
                        """
                        
                        msg.attach(MIMEText(html_content, 'html'))
                        
                        # Send email
                        server.send_message(msg)
                        server.quit()
                        print(f"✅ Welcome email sent to {target.email}")
                    else:
                        print("❌ SMTP configuration missing")
                else:
                    print("❌ No email found for user")
            except Exception as e:
                print(f"❌ SQLAlchemy event error: {e}")
        
        print("🔧 SQLAlchemy events registered for user creation")
    except Exception as e:
        print(f"❌ Failed to register SQLAlchemy events: {e}")

# Register SQLAlchemy events when the module is imported
register_sqlalchemy_events()
