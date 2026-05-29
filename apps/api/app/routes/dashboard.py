from __future__ import annotations

from fastapi import APIRouter

from ..db import get_connection

router = APIRouter(prefix="/api/dashboard", tags=["dashboard"])


def fetch_all(query: str) -> list[dict]:
    with get_connection() as conn:
        cursor = conn.cursor()
        cursor.execute(query)
        columns = [column[0] for column in cursor.description]
        return [dict(zip(columns, row)) for row in cursor.fetchall()]


@router.get("/invoices")
def get_invoice_fact() -> list[dict]:
    return fetch_all("SELECT TOP 500 * FROM dbo.invoice_fact ORDER BY created_at_utc DESC")


@router.get("/vendors")
def get_vendor_dim() -> list[dict]:
    return fetch_all("SELECT * FROM dbo.vendor_dim ORDER BY vendor_name")


@router.get("/dates")
def get_date_dim() -> list[dict]:
    return fetch_all("SELECT * FROM dbo.date_dim ORDER BY calendar_date DESC")
