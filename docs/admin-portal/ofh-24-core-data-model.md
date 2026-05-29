# OFH-24 - Core Data Model And Azure SQL Tables

## Goal

Define the first Admin Portal data model on top of the existing `finance` Azure SQL database so dashboards and portal modules can read consistent operational data.

## Existing Anchor Table

`dbo.invoices` is the current source of processed invoice records. It already stores document identity, parser metadata, invoice header fields, vendor/customer data, amounts, payment fields, line JSON, raw JSON, and duplicate prevention keys.

## Core Tables Added In Draft Script

- `dbo.companies`: legal or operating entities managed by ClickMe.
- `dbo.vendors`: supplier master data, normalized by vendor name.
- `dbo.expense_categories`: controlled expense taxonomy.
- `dbo.invoice_line_items`: structured invoice line details linked to `dbo.invoices`.
- `dbo.invoice_expense_classifications`: invoice-to-category mapping.
- `dbo.payments`: payment and reconciliation records.
- `dbo.documents`: metadata for PDFs, JSON files, contracts, and attachments.
- `dbo.approval_workflows`: reusable approval workflow definitions.
- `dbo.approval_requests`: approval instances tied to portal entities.
- `dbo.automation_runs`: execution history for parsers, watchers, and jobs.
- `dbo.portal_users`: portal user metadata mapped to Microsoft Entra ID.
- `dbo.portal_roles`: application roles.
- `dbo.portal_user_roles`: user-role assignments.
- `dbo.audit_events`: append-only audit trail for sensitive actions.

## Dashboard Views Added In Draft Script

- `dbo.vw_invoice_summary`: invoice count, review count, parsed count, total amount, and date range.
- `dbo.vw_invoice_vendor_spend`: spend and review count by vendor and currency.
- `dbo.vw_invoice_monthly_trend`: monthly invoice totals and processing quality.
- `dbo.vw_invoice_processing_quality`: parser/version/status quality view.
- `dbo.vw_invoice_category_spend`: spend by expense category and currency.
- `dbo.vw_automation_run_health`: automation execution health.
- `dbo.vw_accounts_payable_status`: open and overdue payable balances.

## Design Principles

- Keep `dbo.invoices` as the system-of-record for parsed invoices.
- Add normalized tables for portal workflows without breaking the parser.
- Use SQL views as dashboard contracts.
- Keep raw parser JSON available for traceability.
- Avoid duplicate invoices through existing `sha256` and `dedup_key` constraints.
- Use filtered unique indexes for optional hashes and Entra IDs.
- Keep Microsoft Entra ID as the source of identity, with portal tables storing application metadata only.

## Script Location

`sql/admin-portal/001_core_schema_and_views.sql`

## Execution Status

Drafted and versioned in GitHub. Not yet executed against Azure SQL.

## Open Questions

- Which ClickMe legal entities need to be seeded in `dbo.companies`?
- Should vendor matching be manual, automatic, or hybrid?
- Which payment statuses should become the official list?
- Which roles from OFH-25 should be seeded in `dbo.portal_roles`?
- Should documents store only local paths or Azure Blob Storage references?
- Which approval workflows are needed in the MVP?
