from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    azure_sql_server: str = "ckmecr-admin-server.database.windows.net"
    azure_sql_database: str = "finance"
    azure_sql_authentication: str = "ActiveDirectoryInteractive"
    azure_sql_username: str | None = None
    azure_sql_driver: str = "ODBC Driver 17 for SQL Server"
    azure_sql_timeout_seconds: int = 30


settings = Settings()
