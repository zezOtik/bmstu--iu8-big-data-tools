# superset_config.py

# Секретный ключ
import os

SECRET_KEY = os.environ.get("SUPERSET_SECRET_KEY", "fallback-super-secret-key-please-change")

# Настройки БД
SQLALCHEMY_DATABASE_URI = 'postgresql://superset:superset_secure_pass@postgres:5432/superset'

# Другие настройки (по желанию)
CACHE_DEFAULT_TIMEOUT = 60 * 60 * 24  # 1 день
ENABLE_PROXY_FIX = True
PROXY_FIX_CONFIG = dict(x_for=1, x_proto=1)

# Безопасность
WTF_CSRF_ENABLED = True
SESSION_COOKIE_SAMESITE = "Lax"
SESSION_COOKIE_SECURE = False  # Включить, если используется HTTPS