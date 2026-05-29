from __future__ import annotations

from fastapi import APIRouter

from ..db import fetch_all

router = APIRouter(prefix="/api/purchase-invoices", tags=["purchase-invoices"])


@router.get("")
def list_purchase_invoices() -> list[dict]:
    return fetch_all(
        """
        SELECT TOP 500
            invoice_key,
            invoice_number,
            vendor_key,
            invoice_date_key,
            due_date_key,
            currency_code,
            total_amount,
            recognized_amount,
            open_amount,
            processing_status,
            needs_review,
            is_overdue
        FROM dbo.invoice_fact
        ORDER BY created_at_utc DESC
        """
    )
