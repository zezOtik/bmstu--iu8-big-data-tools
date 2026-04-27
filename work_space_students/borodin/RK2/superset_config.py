SECRET_KEY = "my_very_secure_key_here_123!"

SQLALCHEMY_DATABASE_URI = "postgresql+psycopg2://superset:superset_secure_pass@postgres:5432/superset"

FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
}