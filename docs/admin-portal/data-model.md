# Data Model Plan

## Existing Database

- Server: `ckmecr-admin-server.database.windows.net`
- Database: `finance`
- Existing table: `dbo.invoices`

## Existing Anchor Table

`dbo.invoices` remains the system-of-record for processed invoice headers, parser metadata, PDF identity, duplicate prevention, amounts, raw text, and raw JSON.

## Core Tables

- `dbo.companies`: legal and operating entities managed by ClickMe.
- `dbo.vendors`: supplier master data and procurement metadata.
- `dbo.expense_categories`: controlled expense taxonomy for reporting.
- `dbo.invoice_line_items`: structured invoice lines linked to `dbo.invoices`.
- `dbo.invoice_expense_classifications`: invoice-to-category mapping for reporting.
- `dbo.payments`: payment status, due dates, payment amounts, and reconciliation metadata.
- `dbo.documents`: metadata for PDFs, JSON files, contracts, and attachments.
- `dbo.approval_workflows`: reusable approval workflow definitions.
- `dbo.approval_requests`: approval instances tied to invoices, vendors, documents, or other entities.
- `dbo.automation_runs`: execution history for parsers, watchers, and integrations.
- `dbo.portal_users`: application user metadata mapped to Microsoft Entra ID.
- `dbo.portal_roles`: application roles.
- `dbo.portal_user_roles`: user-role assignments.
- `dbo.audit_events`: append-only trail for sensitive actions.

## Dashboard Views

- `dbo.vw_invoice_summary`
- `dbo.vw_invoice_vendor_spend`
- `dbo.vw_invoice_monthly_trend`
- `dbo.vw_invoice_processing_quality`
- `dbo.vw_invoice_category_spend`
- `dbo.vw_automation_run_health`
- `dbo.vw_accounts_payable_status`

## Deduplication Principles

- Keep `dbo.invoices.sha256` uniqueness for file-level invoice duplicates.
- Keep `dbo.invoices.dedup_key` filtered uniqueness for invoice-level duplicates.
- Keep `dbo.documents.sha256` filtered uniqueness for document-level duplicates when a hash exists.
- Store raw parser output in JSON for traceability.
- Do not insert dashboard aggregates directly; generate them from views.

## Portal Integration Principles

- The portal should read dashboard data through API endpoints backed by SQL views.
- The parser can continue writing to `dbo.invoices` without needing to know the full portal schema.
- Vendor matching can begin by normalized vendor name and evolve into explicit `vendor_id` references later.
- Microsoft Entra ID remains the identity source; portal tables store app-level metadata and roles.

## Script Location

`sql/admin-portal/001_core_schema_and_views.sql`
