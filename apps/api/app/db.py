from __future__ import annotations

from contextlib import contextmanager
from typing import Iterator

import pyodbc

from .settings import settings


def build_connection_string() -> str:
    parts = [
        f"DRIVER={{{settings.azure_sql_driver}}}",
        f"SERVER=tcp:{settings.azure_sql_server},1433",
        f"DATABASE={settings.azure_sql_database}",
        "Encrypt=yes",
        "TrustServerCertificate=no",
        f"Connection Timeout={settings.azure_sql_timeout_seconds}",
    ]

    if settings.azure_sql_authentication:
        parts.append(f"Authentication={settings.azure_sql_authentication}")

    if settings.azure_sql_username:
        parts.append(f"UID={settings.azure_sql_username}")

    return ";".join(parts)


@contextmanager
def get_connection() -> Iterator[pyodbc.Connection]:
    conn = pyodbc.connect(build_connection_string())
    try:
        yield conn
    finally:
        conn.close()


def fetch_all(query: str) -> list[dict]:
    with get_connection() as conn:
        cursor = conn.cursor()
        cursor.execute(query)
        columns = [column[0] for column in cursor.description]
        return [dict(zip(columns, row)) for row in cursor.fetchall()]
