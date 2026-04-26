import os

# Секретный ключ должен быть сложным и уникальным
SECRET_KEY = os.environ.get('SUPERSET_SECRET_KEY', 'my_very_secure_key_here_123!')

# Настройка подключения к метаданным Superset (PostgreSQL)
SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URI', 'sqlite:///var/lib/superset/superset.db')

# Разрешаем загрузку внешних CSS/JS (если нужно)
TALISMAN_ENABLED = False

# Настройки кэширования (опционально)
CACHE_CONFIG = {
    'CACHE_TYPE': 'RedisCache',
    'CACHE_REDIS_URL': 'redis://localhost:6379/0',
}

# Явная регистрация драйвера ClickHouse (иногда помогает)
from clickhouse_connect.driver.superset import ClickHouseEngineSpec

# Дополнительные настройки безопасности
FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
}