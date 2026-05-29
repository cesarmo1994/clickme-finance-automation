from __future__ import annotations

from fastapi import APIRouter

from ..db import fetch_all

router = APIRouter(prefix="/api/vendors", tags=["vendors"])


@router.get("")
def list_vendors() -> list[dict]:
    return fetch_all(
        """
        SELECT
            vendor_key,
            vendor_name,
            normalized_vendor_name,
            tax_id,
            primary_email,
            country_code,
            default_currency_code,
            procurement_status,
            risk_level
        FROM dbo.vendor_dim
        ORDER BY vendor_name
        """
    )
